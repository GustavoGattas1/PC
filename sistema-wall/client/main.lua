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
WallDisplay = {}

for Key, Value in pairs(Config.Display) do
	WallDisplay[Key] = Value
end

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
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sistema-wall:OpenConfig")
AddEventHandler("sistema-wall:OpenConfig", function()
	local Lines = {
		"~b~CONFIGURAÇÕES DO WALL~w~",
		"",
		"Passport: " .. (WallDisplay.Passport and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Nome: " .. (WallDisplay.Name and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Vida: " .. (WallDisplay.Health and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Colete: " .. (WallDisplay.Armor and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Arma: " .. (WallDisplay.Weapon and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Veículo: " .. (WallDisplay.Vehicle and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Linha: " .. (WallDisplay.Line and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Esqueleto: " .. (WallDisplay.Skeleton and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"Paredes: " .. (WallDisplay.ThroughWalls and Config.Lang.OptionOn or Config.Lang.OptionOff),
		"",
		"Use ~y~/wallconfig [opção]~w~ para alternar",
		"Opções: passport, name, health, armor, weapon, vehicle, line, skeleton, walls, self, blip"
	}

	for _, Line in ipairs(Lines) do
		Wall_NotifyClient("info", Line, 12000)
		Wait(100)
	end
end)

local ConfigOptions = {
	passport = "Passport",
	name = "Name",
	health = "Health",
	armor = "Armor",
	weapon = "Weapon",
	vehicle = "Vehicle",
	speed = "Speed",
	distance = "Distance",
	group = "Group",
	status = "Status",
	line = "Line",
	skeleton = "Skeleton",
	walls = "ThroughWalls",
	self = "Self",
	blip = "Blip",
	npcs = "Npcs",
	serverid = "ServerId"
}

RegisterNetEvent("sistema-wall:SetOption")
AddEventHandler("sistema-wall:SetOption", function(Option)
	Option = string.lower(tostring(Option or ""))
	local Key = ConfigOptions[Option]

	if not Key or WallDisplay[Key] == nil then
		Wall_NotifyClient("negado", "Opção inválida. Use /wallconfig para ver as opções.")
		return
	end

	WallDisplay[Key] = not WallDisplay[Key]

	if Key == "Blip" and not WallDisplay.Blip then
		Wall_ClearBlips()
	end

	local State = WallDisplay[Key] and "~g~ativado" or "~r~desativado"
	Wall_NotifyClient("important", Option .. " " .. State, 3000)
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
			AddTextComponentString("~b~WALL ATIVO~w~ | " .. Wall_CountVisible() .. " jogador(es) | " .. math.floor(Config.DrawDistance) .. "m")
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
		if TargetPed ~= Ped or WallDisplay.Self then
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

function Wall_GetDisplay()
	return WallDisplay
end

exports("IsWallActive", function()
	return WallActive
end)

exports("GetWallDisplay", function()
	return WallDisplay
end)
