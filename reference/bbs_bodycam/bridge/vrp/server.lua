-----------------------------------------------------------------------------------------------------------------------------------------
-- BBS BODYCAM — FRAMEWORK SERVER (vRP / Creative Uncharted)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("bbs_vrp/GetCharacter", [[
	SELECT * FROM characters WHERE id = @passport LIMIT 1
]])

-----------------------------------------------------------------------------------------------------------------------------------------
-- FRAMEWORK API (compatível com padrão modular BBS)
-----------------------------------------------------------------------------------------------------------------------------------------
Framework = Framework or {}

function Framework.GetPassport(source)
	return vRP.Passport(source)
end

function Framework.GetPlayer(source)
	local Passport = Framework.GetPassport(source)
	if not Passport then return nil end

	return {
		source = source,
		passport = Passport,
		citizenid = tostring(Passport),
		identifier = tostring(Passport),
		firstname = BBS_VRP_Bridge_GetFirstName(Passport),
		lastname = BBS_VRP_Bridge_GetLastName(Passport),
		name = BBS_VRP_Bridge_GetPlayerName(Passport),
		job = Framework.GetJob(source),
		onduty = Framework.IsOnDuty(source),
		badge = BBS_VRP_Bridge_GetBadge(Passport),
		unit = BBS_VRP_Bridge_GetUnit(Passport)
	}
end

function Framework.GetPlayerName(source)
	local Passport = Framework.GetPassport(source)
	return Passport and BBS_VRP_Bridge_GetPlayerName(Passport) or "Desconhecido"
end

function Framework.GetJob(source)
	local Passport = Framework.GetPassport(source)
	if not Passport then return nil end

	for _, Group in ipairs(BBS_VRP.Groups) do
		if vRP.HasGroup(Passport, Group) then
			return {
				name = Group,
				label = string.upper(Group),
				grade = 0
			}
		end
	end

	return { name = "unemployed", label = "CIVIL", grade = 0 }
end

function Framework.HasJob(source, Jobs)
	local Passport = Framework.GetPassport(source)
	if not Passport then return false end

	if type(Jobs) == "string" then
		Jobs = { Jobs }
	end

	for _, Job in ipairs(Jobs) do
		if vRP.HasGroup(Passport, Job) then
			return true
		end
	end

	for _, Job in ipairs(Jobs) do
		for _, Group in ipairs(BBS_VRP.Groups) do
			if string.lower(Job) == string.lower(Group) and vRP.HasGroup(Passport, Group) then
				return true
			end
		end
	end

	return false
end

function Framework.IsOnDuty(source)
	local Passport = Framework.GetPassport(source)
	if not Passport then return false end
	if not BBS_VRP.RequireService then return true end

	for _, Group in ipairs(BBS_VRP.Groups) do
		if vRP.HasService(Passport, Group) then
			return true
		end
	end

	return false
end

function Framework.IsSupervisor(source)
	local Passport = Framework.GetPassport(source)
	if not Passport then return false end

	for _, Group in ipairs(BBS_VRP.SupervisorGroups) do
		if vRP.HasGroup(Passport, Group) then
			return true
		end
	end

	return false
end

function Framework.HasPermission(source)
	return Framework.HasJob(source, BBS_VRP.Groups) and Framework.IsOnDuty(source)
end

function Framework.HasItem(source, Item, Amount)
	local Passport = Framework.GetPassport(source)
	if not Passport or not Item then return false end

	Amount = tonumber(Amount) or 1
	local Result = vRP.InventoryItemAmount(Passport, Item)
	local Count = Result and Result[1] or 0
	return Count >= Amount
end

function Framework.GetItemCount(source, Item)
	local Passport = Framework.GetPassport(source)
	if not Passport or not Item then return 0 end

	local Result = vRP.InventoryItemAmount(Passport, Item)
	return Result and Result[1] or 0
end

function Framework.GiveItem(source, Item, Amount)
	local Passport = Framework.GetPassport(source)
	if not Passport or not Item then return false end

	Amount = tonumber(Amount) or 1
	return vRP.GenerateItem(Passport, Item, Amount, true) ~= nil
end

function Framework.TakeItem(source, Item, Amount)
	local Passport = Framework.GetPassport(source)
	if not Passport or not Item then return false end

	Amount = tonumber(Amount) or 1
	return vRP.TakeItem(Passport, Item, Amount, true)
end

function Framework.Notify(source, Message, Type, Duration)
	local Notify = BBS_VRP.Notify[Type or "info"] or BBS_VRP.Notify.info
	TriggerClientEvent("Notify", source, Notify.Title, Message, Notify.Color, Duration or 5000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS USÁVEIS (padrão Creative — ver items_reference.lua)
-----------------------------------------------------------------------------------------------------------------------------------------
local ItemHandlers = {}

function Framework.RegisterUsableItem(Item, Callback)
	if not Item or not Callback then return end
	ItemHandlers[Item] = Callback
end

local function HandleItemUse(Source, ItemName)
	if not ItemName or not ItemHandlers[ItemName] then return false end
	ItemHandlers[ItemName](Source)
	return true
end

RegisterNetEvent("bbs_bodycam:UseItem")
AddEventHandler("bbs_bodycam:UseItem", function(ItemName)
	HandleItemUse(source, ItemName)
end)

RegisterNetEvent("inventory:UseItem")
AddEventHandler("inventory:UseItem", function(ItemName)
	if ItemHandlers[ItemName] then
		HandleItemUse(source, ItemName)
	end
end)

RegisterNetEvent("inventory:Use")
AddEventHandler("inventory:Use", function(ItemName)
	if ItemHandlers[ItemName] then
		HandleItemUse(source, ItemName)
	end
end)

RegisterNetEvent("inventory:ServerUse")
AddEventHandler("inventory:ServerUse", function(ItemName)
	if ItemHandlers[ItemName] then
		HandleItemUse(source, ItemName)
	end
end)

RegisterNetEvent("player:UseItem")
AddEventHandler("player:UseItem", function(ItemName)
	if ItemHandlers[ItemName] then
		HandleItemUse(source, ItemName)
	end
end)

exports("UseItem", function(Source, ...)
	local Args = { ... }
	for _, Arg in ipairs(Args) do
		if type(Arg) == "string" and Arg ~= "" and ItemHandlers[Arg] then
			return HandleItemUse(Source, Arg)
		end
	end
	return false
end)

exports("UseBodycam", function(Source)
	return BBS_VRP.Items.Bodycam and HandleItemUse(Source, BBS_VRP.Items.Bodycam) or false
end)

exports("UseDashcam", function(Source)
	return BBS_VRP.Items.Dashcam and HandleItemUse(Source, BBS_VRP.Items.Dashcam) or false
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO DE ITENS BODYCAM / DASHCAM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if BBS_VRP.Items.Bodycam then
		Framework.RegisterUsableItem(BBS_VRP.Items.Bodycam, function(source)
			TriggerClientEvent("bbs_bodycam:client:useBodycam", source)
		end)
	end

	if BBS_VRP.Items.Dashcam then
		Framework.RegisterUsableItem(BBS_VRP.Items.Dashcam, function(source)
			TriggerClientEvent("bbs_bodycam:client:useDashcam", source)
		end)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS (para o script BBS chamar diretamente)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetFrameworkPlayer", function(source)
	return Framework.GetPlayer(source)
end)

exports("HasBodycamPermission", function(source)
	return Framework.HasPermission(source)
end)

exports("IsBodycamSupervisor", function(source)
	return Framework.IsSupervisor(source)
end)
