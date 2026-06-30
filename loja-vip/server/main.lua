-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
Loja = {}
Tunnel.bindInterface("loja-vip", Loja)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local PurchaseCooldowns = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERSONAGEM / IDENTIDADE (compatível com Base Cliente e Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsCharacterReady(Passport)
	if not Passport then return false end

	if vRP.Datatable then
		local Ok, Datatable = pcall(vRP.Datatable, Passport)
		if Ok and not Datatable then
			return false
		end
	end

	return true
end

local function GetPlayerName(Source, Passport)
	if vRP.FullName then
		local Ok, Name = pcall(vRP.FullName, Source)
		if Ok and type(Name) == "string" and Name ~= "" then
			return Name
		end
	end

	if vRP.Identity and Passport then
		local Ok, Identity = pcall(vRP.Identity, Passport)
		if Ok and type(Identity) == "table" then
			local First = Identity.name or Identity.Name or Identity.nome or Identity.firstname or ""
			local Last = Identity.name2 or Identity.Lastname or Identity.sobrenome or ""
			local Full = (tostring(First) .. " " .. tostring(Last)):gsub("^%s+", ""):gsub("%s+$", "")
			if Full ~= "" then
				return Full
			end
		end
	end

	return "Jogador #" .. tostring(Passport)
end

local function SafeCall(Function, ...)
	if not Function then return nil end
	local Ok, Result = pcall(Function, ...)
	if Ok then return Result end
	Loja_Debug("SafeCall error:", Result)
	return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOEDA
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetBalance(Passport, Currency)
	if Currency == "bank" then
		local Bank = SafeCall(vRP.GetBank, Passport) or SafeCall(vRP.Bank, Passport)
		return tonumber(Bank) or 0
	end

	local Gems = SafeCall(vRP.UserGemstone, Passport)
		or SafeCall(vRP.Gemstone, Passport)
		or SafeCall(vRP.GetGems, Passport)

	return tonumber(Gems) or 0
end

local function TakeBalance(Passport, Currency, Amount)
	if Currency == "bank" then
		if vRP.PaymentBank then
			return vRP.PaymentBank(Passport, Amount)
		end
		if vRP.TryPayment then
			return vRP.TryPayment(Passport, Amount)
		end
		return false
	end

	if vRP.PaymentGems then
		return vRP.PaymentGems(Passport, Amount)
	end
	if vRP.RemoveGemstone then
		return vRP.RemoveGemstone(Passport, Amount)
	end
	if vRP.TakeGems then
		return vRP.TakeGems(Passport, Amount)
	end
	return false
end

local function GiveBank(Passport, Amount)
	if vRP.GiveBank then
		vRP.GiveBank(Passport, Amount)
		return true
	end
	if vRP.AddBank then
		vRP.AddBank(Passport, Amount)
		return true
	end
	return false
end

local function GeneratePlate()
	if vRP.GeneratePlate then
		return vRP.GeneratePlate()
	end

	local Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local Numbers = "0123456789"
	local Plate = ""

	for _ = 1, 3 do
		local Index = math.random(1, #Letters)
		Plate = Plate .. Letters:sub(Index, Index)
	end
	Plate = Plate .. " "
	for _ = 1, 4 do
		local Index = math.random(1, #Numbers)
		Plate = Plate .. Numbers:sub(Index, Index)
	end

	return Plate
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
local function DeliverVIP(Passport, Data)
	if not Data or not Data.group then return false end

	local Level = Data.level or 1
	if vRP.SetPermission then
		vRP.SetPermission(Passport, Data.group, Level)
	end

	if Data.days and vRP.SetPermission then
		local Expire = os.time() + (Data.days * 86400)
		local Key = "vip_expire_" .. Data.group
		if vRP.SetSrvData then
			vRP.SetSrvData(Key .. ":" .. Passport, Expire, true)
		end
	end

	if Data.salary and Data.salary > 0 then
		Loja_DB_AddExtra(Passport, "vip_salary_" .. Data.group, Data.salary)
	end

	if Data.garageSlots and Data.garageSlots > 0 then
		Loja_DB_AddExtra(Passport, "garage_slot", Data.garageSlots)
	end

	if Data.house then
		DeliverHouse(Passport, { property = Data.house, interior = Data.interior or "modern" })
	end

	return true
end

function DeliverVehicle(Passport, Data)
	if not Data or not Data.model then return false, "invalid" end

	local Exist = vRP.Query("loja_vip/VehicleExist", {
		Passport = Passport,
		vehicle = Data.model
	})

	if Exist and Exist[1] then
		return false, "exists"
	end

	local Plate = GeneratePlate()
	local Work = Data.work and "true" or "false"

	vRP.Query("loja_vip/AddVehicle", {
		Passport = Passport,
		vehicle = Data.model,
		plate = Plate,
		work = Work
	})

	return true, Plate
end

function DeliverHouse(Passport, Data)
	if not Data or not Data.property then return false, "invalid" end

	local Owner = vRP.Query("loja_vip/PropertyOwner", { name = Data.property })
	if Owner and Owner[1] and tonumber(Owner[1].Passport) ~= Passport then
		return false, "owned"
	end

	vRP.Query("loja_vip/BuyProperty", {
		name = Data.property,
		passport = Passport,
		interior = Data.interior or "modern"
	})

	return true
end

local function DeliverItems(Passport, Data)
	if Data.bank and Data.bank > 0 then
		GiveBank(Passport, Data.bank)
	end

	if Data.items then
		for _, Entry in ipairs(Data.items) do
			if vRP.GenerateItem then
				vRP.GenerateItem(Passport, Entry.item, Entry.amount or 1, true)
			end
		end
	end

	return true
end

local function DeliverExtra(Passport, Data)
	if not Data or not Data.extra then return false end

	if Data.extra == "character_slot" or Data.extra == "garage_slot" then
		Loja_DB_AddExtra(Passport, Data.extra, Data.amount or 1)
		return true
	end

	if Data.extra == "custom_plate" or Data.extra == "name_change" then
		Loja_DB_AddExtra(Passport, Data.extra, 1)
		return true
	end

	return false
end

local function DeliverProduct(Passport, Product)
	if not Product or not Product.data then return false, "invalid" end

	if Product.type == "vip" then
		return DeliverVIP(Passport, Product.data), nil
	elseif Product.type == "vehicle" then
		return DeliverVehicle(Passport, Product.data)
	elseif Product.type == "house" then
		return DeliverHouse(Passport, Product.data)
	elseif Product.type == "item" then
		return DeliverItems(Passport, Product.data), nil
	elseif Product.type == "extra" then
		return DeliverExtra(Passport, Product.data), nil
	elseif Product.type == "pack" then
		local AllOk = true
		for _, SubId in ipairs(Product.data.products or {}) do
			local Sub = Loja_FindProduct(SubId)
			if Sub then
				local Ok = select(1, DeliverProduct(Passport, Sub))
				if not Ok then AllOk = false end
			else
				AllOk = false
			end
		end
		return AllOk, AllOk and nil or "partial"
	end

	return false, "unknown"
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL — DADOS DA LOJA
-----------------------------------------------------------------------------------------------------------------------------------------
function Loja.GetShopData()
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not IsCharacterReady(Passport) then return nil end

	local Name = GetPlayerName(Source, Passport)

	local VipGroup = nil
	for _, Product in ipairs(Config.Products) do
		if Product.type == "vip" and Product.data and Product.data.group then
			if SafeCall(vRP.HasGroup, Passport, Product.data.group) then
				VipGroup = Product.data.group
			end
		end
	end

	return {
		catalog = Loja_SanitizeCatalog(),
		player = {
			passport = Passport,
			name = Name,
			vip = VipGroup,
			balance = {
				gems = GetBalance(Passport, "gems"),
				bank = GetBalance(Passport, "bank")
			}
		},
		history = Loja_DB_GetHistory(Passport, 10)
	}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL — COMPRA
-----------------------------------------------------------------------------------------------------------------------------------------
function Loja.Purchase(ProductId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then
		return { success = false, message = Config.Lang.NoPassport }
	end

	local Now = GetGameTimer()
	if PurchaseCooldowns[Source] and (Now - PurchaseCooldowns[Source]) < Config.PurchaseCooldown then
		return { success = false, message = Config.Lang.Cooldown }
	end

	local Product = Loja_FindProduct(ProductId)
	if not Product then
		return { success = false, message = Config.Lang.ProductNotFound }
	end

	if Product.data and Product.data.requireGroup then
		if not Loja_HasGroup(Passport, Product.data.requireGroup) then
			return { success = false, message = Config.Lang.NoPermission }
		end
	end

	local Currency = Product.currency or Config.DefaultCurrency
	local Price = Product.price

	if Product.type == "vehicle" and Product.data and Product.data.model then
		local Exist = vRP.Query("loja_vip/VehicleExist", {
			Passport = Passport,
			vehicle = Product.data.model
		})
		if Exist and Exist[1] then
			return { success = false, message = Config.Lang.VehicleExists }
		end
	end

	if Product.type == "house" and Product.data and Product.data.property then
		local Owner = vRP.Query("loja_vip/PropertyOwner", { name = Product.data.property })
		if Owner and Owner[1] and tonumber(Owner[1].Passport) ~= Passport then
			return { success = false, message = Config.Lang.HouseExists }
		end
	end

	local Balance = GetBalance(Passport, Currency)
	if Balance < Price then
		return { success = false, message = Config.Lang.InsufficientFunds }
	end

	if not TakeBalance(Passport, Currency, Price) then
		return { success = false, message = Config.Lang.InsufficientFunds }
	end

	local Ok, Reason = DeliverProduct(Passport, Product)
	if not Ok then
		if Currency == "bank" then
			GiveBank(Passport, Price)
		elseif vRP.GiveGems then
			vRP.GiveGems(Passport, Price)
		elseif vRP.AddGemstone then
			vRP.AddGemstone(Passport, Price)
		end

		local Message = Config.Lang.PurchaseFailed
		if Reason == "exists" then Message = Config.Lang.VehicleExists
		elseif Reason == "owned" then Message = Config.Lang.HouseExists end

		return { success = false, message = Message }
	end

	Loja_DB_LogPurchase(Passport, Product)
	PurchaseCooldowns[Source] = Now

	Loja_Notify(Source, "success", Config.Lang.PurchaseSuccess)

	return {
		success = true,
		message = Config.Lang.PurchaseSuccess,
		balance = {
			gems = GetBalance(Passport, "gems"),
			bank = GetBalance(Passport, "bank")
		}
	}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO ADMIN — RECARREGAR CATÁLOGO (DEBUG)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lojareload", function(Source)
	if Source == 0 then return end
	local Passport = vRP.Passport(Source)
	if Passport and vRP.HasGroup(Passport, "Admin") then
		Loja_Notify(Source, "info", "Catálogo da loja recarregado.", 3000)
	end
end, false)
