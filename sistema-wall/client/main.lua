-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Wall = {}
Tunnel.bindInterface("sistema-wall", Wall)
vSERVER = Tunnel.getInterface("sistema-wall")

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------------------------------------------------------------------------------
WallActive = false
WallAuthorized = false
WallPlayers = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIALIZAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(3000)
	WallAuthorized = vSERVER.CheckPermission()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sistema-wall:Toggle")
AddEventHandler("sistema-wall:Toggle", function(Active)
	if not WallAuthorized then
		WallAuthorized = vSERVER.CheckPermission()
	end

	if not WallAuthorized then
		Wall_NotifyClient("negado", Config.Lang.NotAuthorized)
		return
	end

	WallActive = Active == true
	TriggerServerEvent("sistema-wall:SetActive", WallActive)

	if WallActive then
		TriggerServerEvent("sistema-wall:RequestSync")
		Wall_NotifyClient("success", Config.Lang.WallOn, 3000)
	else
		Wall_ClearBlips()
		Wall_NotifyClient("important", Config.Lang.WallOff, 3000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sistema-wall:SyncPlayers")
AddEventHandler("sistema-wall:SyncPlayers", function(Players)
	WallPlayers = Players or {}
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping(Config.Command, "Alternar Wall (Staff)", "keyboard", Config.Key)

function Wall_GetPlayerData(ServerId)
	return WallPlayers[ServerId]
end

function Wall_GetHeadCoords(Ped)
	local Coords = GetPedBoneCoords(Ped, 31086, 0.0, 0.0, 0.0)
	return Coords.x, Coords.y, Coords.z + (Config.HeadOffset or 0.35)
end

exports("IsWallActive", function()
	return WallActive
end)
