-----------------------------------------------------------------------------------------------------------------------------------------
-- BBS BODYCAM — FRAMEWORK CLIENT (vRP / Creative Uncharted)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- FRAMEWORK API CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
Framework = Framework or {}

function Framework.Notify(Message, Type, Duration)
	local Notify = BBS_VRP.Notify[Type or "info"] or BBS_VRP.Notify.info
	TriggerEvent("Notify", Notify.Title, Message, Notify.Color, Duration or 5000)
end

function Framework.GetPassport()
	return LocalPlayer.state.Passport
end

function Framework.IsPlayerLoaded()
	return Framework.GetPassport() ~= nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS DE ITEM (caso o BBS dispare por item)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("bbs_bodycam:client:useBodycam")
AddEventHandler("bbs_bodycam:client:useBodycam", function()
	TriggerEvent("bbs_bodycam:toggle")
end)

RegisterNetEvent("bbs_bodycam:client:useDashcam")
AddEventHandler("bbs_bodycam:client:useDashcam", function()
	TriggerEvent("bbs_bodycam:toggleDashcam")
end)
