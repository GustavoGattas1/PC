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
	Wait(2000)
	WallAuthorized = vSERVER.CheckPermission()
	Wall_Debug("Autorizado:", WallAuthorized)
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

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD DE STATUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if WallActive then
			Sleep = 0
			SetTextFont(4)
			SetTextScale(0.32, 0.32)
			SetTextColour(100, 200, 255, 200)
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~b~WALL ATIVO~w~ | " .. Wall_CountVisible() .. " jogador(es)")
			DrawText(0.015, 0.02)
		end

		Wait(Sleep)
	end
end)

function Wall_CountVisible()
	local Count = 0
	local Ped = PlayerPedId()
	local PedCoords = GetEntityCoords(Ped)

	for _, Player in ipairs(GetActivePlayers()) do
		local TargetPed = GetPlayerPed(Player)
		if TargetPed ~= Ped or Config.Display.Self then
			local Dist = #(PedCoords - GetEntityCoords(TargetPed))
			if Dist <= Config.DrawDistance then
				Count = Count + 1
			end
		end
	end

	return Count
end

function Wall_GetPlayerData(ServerId)
	return WallPlayers[ServerId]
end

function Wall_IsActive()
	return WallActive
end

function Wall_GetHeadCoords(Ped)
	local BoneCoords = GetPedBoneCoords(Ped, 31086, 0.0, 0.0, 0.0)
	local Offset = Config.HeadOffset or 0.35
	return vector3(BoneCoords.x, BoneCoords.y, BoneCoords.z + Offset)
end

exports("IsWallActive", function()
	return WallActive
end)
