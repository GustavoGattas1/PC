-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO DE ITENS USÁVEIS (Creative / vRP)
-----------------------------------------------------------------------------------------------------------------------------------------
local ItemAliases = {
	["luvas-latex"] = "luvaslatex",
	["marcador-evidencia"] = "marcadorevidencia",
	["laudo-pericial"] = "laudopericial",
	["swab-sangue"] = "swabsangue",
	["molde-pneu"] = "moldepneu",
	["tablet-forense"] = "tabletforense",
	["saco-evidencia"] = "sacoevidencia"
}

local function NormalizeItemName(ItemName)
	if type(ItemName) ~= "string" or ItemName == "" then
		return nil
	end

	ItemName = string.lower(ItemName)
	ItemName = string.match(ItemName, "^([^%-]+)") or ItemName

	return ItemAliases[ItemName] or ItemName
end

local function ResolveItemName(...)
	local Args = { ... }

	for _, Arg in ipairs(Args) do
		if type(Arg) == "string" and Arg ~= "" and not tonumber(Arg) then
			local Normalized = NormalizeItemName(Arg)
			if Normalized and ItemHandlers[Normalized] then
				return Normalized
			end
		end
	end

	return nil
end

local ItemHandlers = {
	[Config.Items.LatexGloves] = function(Source, Passport)
		TriggerClientEvent("iml-evidencias:ToggleGloves", Source)
	end,

	[Config.Items.Laudo] = function(Source, Passport)
		IML_OpenLatestReport(Source, Passport)
	end,

	[Config.Items.ForensicTablet] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:OpenTablet", Source)
	end,

	[Config.Items.EvidenceMarker] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:PlaceMarker", Source, true)
	end,

	[Config.Items.ForensicKit] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:OpenTablet", Source)
	end
}

local function HandleItemUse(Source, ItemName)
	local Passport = vRP.Passport(Source)
	if not Passport then return false end

	ItemName = NormalizeItemName(ItemName)
	if not ItemName then return false end

	local Handler = ItemHandlers[ItemName]
	if Handler then
		Handler(Source, Passport)
		return true
	end

	IML_Notify(Source, "negado", Config.Lang.ItemNotRecognized)
	return false
end

local function HandleItemUseEvent(ItemName)
	HandleItemUse(source, ItemName)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS PADRÃO CREATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:UseItem")
AddEventHandler("iml-evidencias:UseItem", function(ItemName)
	HandleItemUseEvent(ItemName)
end)

RegisterNetEvent("inventory:UseItem")
AddEventHandler("inventory:UseItem", function(ItemName)
	HandleItemUseEvent(ItemName)
end)

RegisterNetEvent("inventory:Use")
AddEventHandler("inventory:Use", function(ItemName)
	HandleItemUseEvent(ItemName)
end)

RegisterNetEvent("inventory:ServerUse")
AddEventHandler("inventory:ServerUse", function(ItemName)
	HandleItemUseEvent(ItemName)
end)

RegisterNetEvent("player:UseItem")
AddEventHandler("player:UseItem", function(ItemName)
	HandleItemUseEvent(ItemName)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS PARA Item.lua (Execute)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("UseItem", function(Source, ...)
	local ItemName = ResolveItemName(...)
	if not ItemName then
		if Config.Debug then
			print("[IML] UseItem sem nome válido. Source:", Source)
		end
		return false
	end

	return HandleItemUse(Source, ItemName)
end)

exports("UseLuvas", function(Source)
	return HandleItemUse(Source, Config.Items.LatexGloves)
end)

exports("UseTablet", function(Source)
	if HandleItemUse(Source, Config.Items.ForensicTablet) then return true end
	if HandleItemUse(Source, Config.Items.ForensicKit) then return true end
	return false
end)

exports("UseLaudo", function(Source)
	return HandleItemUse(Source, Config.Items.Laudo)
end)

exports("UseMarcador", function(Source)
	return HandleItemUse(Source, Config.Items.EvidenceMarker)
end)
