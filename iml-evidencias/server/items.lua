-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO DE ITENS USÁVEIS (Creative / vRP)
-----------------------------------------------------------------------------------------------------------------------------------------
local ItemHandlers = {
	[Config.Items.LatexGloves] = function(Source, Passport)
		TriggerClientEvent("iml-evidencias:ToggleGloves", Source)
	end,

	[Config.Items.BodyBag] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:UseBodyBag", Source)
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

	[Config.Items.GsrScanner] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:OpenGsrScanner", Source)
	end,

	[Config.Items.EvidenceMarker] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:PlaceMarker", Source)
	end,

	[Config.Items.PoliceTape] = function(Source, Passport)
		if not IML.CanCollect(Passport) then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
			return
		end
		TriggerClientEvent("iml-evidencias:PlaceTape", Source)
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
	if not Passport or not ItemName then return end

	local Handler = ItemHandlers[ItemName]
	if Handler then
		Handler(Source, Passport)
		return true
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS PADRÃO CREATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:UseItem")
AddEventHandler("iml-evidencias:UseItem", function(ItemName)
	HandleItemUse(source, ItemName)
end)

RegisterNetEvent("inventory:UseItem")
AddEventHandler("inventory:UseItem", function(ItemName)
	HandleItemUse(source, ItemName)
end)

RegisterNetEvent("inventory:Use")
AddEventHandler("inventory:Use", function(ItemName)
	HandleItemUse(source, ItemName)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS PARA Item.lua (Execute)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("UseItem", function(Source, ItemName)
	return HandleItemUse(Source, ItemName)
end)

exports("UseLuvas", function(Source)
	return HandleItemUse(Source, Config.Items.LatexGloves)
end)

exports("UseBodyBag", function(Source)
	return HandleItemUse(Source, Config.Items.BodyBag)
end)

exports("UseTablet", function(Source)
	if HandleItemUse(Source, Config.Items.ForensicTablet) then return true end
	if HandleItemUse(Source, Config.Items.ForensicKit) then return true end
	return false
end)

exports("UseGsrScanner", function(Source)
	return HandleItemUse(Source, Config.Items.GsrScanner)
end)

exports("UseLaudo", function(Source)
	return HandleItemUse(Source, Config.Items.Laudo)
end)
