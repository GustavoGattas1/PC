-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
MazeElevator = {}
Tunnel.bindInterface("maze_elevator", MazeElevator)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Traveling = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(Source, Message, Color)
	TriggerClientEvent("Notify", Source, Config.Notify.Title, Message, Color or Config.Notify.Info, 5000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasPermission(Passport, Permission)
	if not Permission or Permission == false then
		return true
	end

	if not Passport then
		return false
	end

	if vRP.HasPermission and vRP.HasPermission(Passport, Permission) then
		return true
	end

	if Config.UseHasGroupFallback and vRP.HasGroup and vRP.HasGroup(Passport, Permission) then
		return true
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VALIDAÇÃO DE ELEVADOR / ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetElevator(ElevatorId)
	if type(ElevatorId) ~= "string" then return nil end
	return Config.Elevators[ElevatorId]
end

local function GetFloor(Elevator, FloorIndex)
	FloorIndex = tonumber(FloorIndex)
	if not FloorIndex or not Elevator or not Elevator.Floors then return nil end
	return Elevator.Floors[FloorIndex], FloorIndex
end

local function GetPanelCoords(Floor)
	if Floor.Panel then
		return Floor.Panel
	end

	if Floor.Coords then
		return vec3(Floor.Coords.x, Floor.Coords.y, Floor.Coords.z)
	end
end

local function GetDestination(Floor)
	if not Floor or not Floor.Coords then return nil end
	return {
		x = Floor.Coords.x,
		y = Floor.Coords.y,
		z = Floor.Coords.z,
		heading = Floor.Coords.w or 0.0
	}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICA PERMISSÃO DO ELEVADOR E DO ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
local function CanAccessFloor(Passport, Elevator, Floor)
	if not HasPermission(Passport, Elevator.Permission) then
		return false, Config.Lang.NoPermission
	end

	if not HasPermission(Passport, Floor.Permission) then
		return false, Config.Lang.NoFloorPermission
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONTA PAYLOAD DA NUI (somente dados seguros)
-----------------------------------------------------------------------------------------------------------------------------------------
local function BuildFloorList(Passport, Elevator, CurrentFloor)
	local Floors = {}

	for Index, Floor in ipairs(Elevator.Floors) do
		local Allowed = CanAccessFloor(Passport, Elevator, Floor)
		Floors[#Floors + 1] = {
			index = Index,
			label = Floor.Label,
			description = Floor.Description,
			icon = Floor.Icon or "fa-layer-group",
			locked = not Allowed,
			current = CurrentFloor == Index
		}
	end

	return Floors
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISTÂNCIA DO PAINEL
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsNearPanel(Source, ElevatorId, FloorIndex)
	local Elevator = GetElevator(ElevatorId)
	local Floor = GetFloor(Elevator, FloorIndex)
	if not Floor then return false end

	local Panel = GetPanelCoords(Floor)
	if not Panel then return false end

	local Ped = GetPlayerPed(Source)
	if not Ped or Ped == 0 then return false end

	local Coords = GetEntityCoords(Ped)
	local Distance = #(Coords - Panel)

	return Distance <= (Config.InteractionDistance + 0.75)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: VERIFICAR PERMISSÃO (TUNNEL)
-----------------------------------------------------------------------------------------------------------------------------------------
function MazeElevator.CheckPermission(ElevatorId, FloorIndex)
	local Source = source
	local Passport = vRP.Passport(Source)
	local Elevator = GetElevator(ElevatorId)
	local Floor = GetFloor(Elevator, FloorIndex)

	if not Passport or not Elevator or not Floor then
		return false
	end

	local Allowed = CanAccessFloor(Passport, Elevator, Floor)
	return Allowed
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: ABRIR ELEVADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maze_elevator:Open")
AddEventHandler("maze_elevator:Open", function(ElevatorId, FloorIndex)
	local Source = source
	local Passport = vRP.Passport(Source)

	if Traveling[Source] then return end

	local Elevator = GetElevator(ElevatorId)
	local Floor = GetFloor(Elevator, FloorIndex)

	if not Passport or not Elevator or not Floor then
		Notify(Source, Config.Lang.InvalidElevator, Config.Notify.Error)
		return
	end

	if not IsNearPanel(Source, ElevatorId, FloorIndex) then
		Notify(Source, Config.Lang.TooFar, Config.Notify.Warning)
		return
	end

	local Allowed, Message = CanAccessFloor(Passport, Elevator, Floor)
	if not Allowed then
		Notify(Source, Message, Config.Notify.Error)
		return
	end

	TriggerClientEvent("maze_elevator:OpenUI", Source, {
		elevatorId = ElevatorId,
		currentFloor = FloorIndex,
		label = Elevator.Label,
		title = Config.NUI.Title,
		subtitle = Config.NUI.Subtitle,
		logo = Config.NUI.Logo,
		floors = BuildFloorList(Passport, Elevator, FloorIndex),
		sounds = Config.Sounds,
		blur = Config.NUI.BlurStrength,
		animation = Config.NUI.AnimationMs
	})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: TELEPORTE (VALIDAÇÃO SERVER-SIDE)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maze_elevator:Teleport")
AddEventHandler("maze_elevator:Teleport", function(ElevatorId, TargetFloor, CurrentFloor)
	local Source = source
	local Passport = vRP.Passport(Source)

	if Traveling[Source] then return end

	local Elevator = GetElevator(ElevatorId)
	local Floor = GetFloor(Elevator, TargetFloor)
	local Current = GetFloor(Elevator, CurrentFloor)

	if not Passport or not Elevator or not Floor or not Current then
		Notify(Source, Config.Lang.InvalidFloor, Config.Notify.Error)
		TriggerClientEvent("maze_elevator:Close", Source)
		return
	end

	if not IsNearPanel(Source, ElevatorId, CurrentFloor) then
		Notify(Source, Config.Lang.TooFar, Config.Notify.Warning)
		TriggerClientEvent("maze_elevator:Close", Source)
		return
	end

	if TargetFloor == CurrentFloor then
		Notify(Source, Config.Lang.SameFloor, Config.Notify.Warning)
		TriggerClientEvent("maze_elevator:Close", Source)
		return
	end

	local Allowed, Message = CanAccessFloor(Passport, Elevator, Floor)
	if not Allowed then
		Notify(Source, Message, Config.Notify.Error)
		TriggerClientEvent("maze_elevator:Close", Source)
		return
	end

	local Destination = GetDestination(Floor)
	if not Destination then
		Notify(Source, Config.Lang.InvalidFloor, Config.Notify.Error)
		TriggerClientEvent("maze_elevator:Close", Source)
		return
	end

	Traveling[Source] = true

	TriggerClientEvent("maze_elevator:DoTeleport", Source, {
		destination = Destination,
		travelDelay = Config.Teleport.TravelDelay,
		fadeOut = Config.Teleport.FadeOutDuration,
		fadeIn = Config.Teleport.FadeInDuration,
		collisionTimeout = Config.Teleport.CollisionTimeout,
		collisionStep = Config.Teleport.CollisionStep,
		freeze = Config.Teleport.FreezeDuringTravel,
		cameraShake = Config.Teleport.CameraShake,
		shakeIntensity = Config.Teleport.CameraShakeIntensity,
		blur = Config.Teleport.ScreenBlur,
		sounds = Config.Sounds
	})

	SetTimeout(Config.Teleport.TravelDelay + Config.Teleport.FadeOutDuration + Config.Teleport.FadeInDuration + 1500, function()
		Traveling[Source] = nil
	end)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: FECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maze_elevator:Close")
AddEventHandler("maze_elevator:Close", function()
	-- Apenas registrado para rastreabilidade; o client fecha localmente.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO DE TESTE
-----------------------------------------------------------------------------------------------------------------------------------------
if Config.TestCommandEnabled and Config.TestCommand then
	RegisterCommand(Config.TestCommand, function(Source)
		local Passport = vRP.Passport(Source)
		if not Passport then return end

		local ElevatorId = "MazeBank"
		local Elevator = GetElevator(ElevatorId)
		if not Elevator then return end

		TriggerClientEvent("maze_elevator:OpenUI", Source, {
			elevatorId = ElevatorId,
			currentFloor = 1,
			label = Elevator.Label,
			title = Config.NUI.Title,
			subtitle = Config.NUI.Subtitle,
			logo = Config.NUI.Logo,
			floors = BuildFloorList(Passport, Elevator, 1),
			sounds = Config.Sounds,
			blur = Config.NUI.BlurStrength,
			animation = Config.NUI.AnimationMs,
			testMode = true
		})

		Notify(Source, string.format(Config.Lang.TestOpened, Elevator.Label), Config.Notify.Info)
	end, false)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function()
	Traveling[source] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("OpenElevatorForPlayer", function(Source, ElevatorId, CurrentFloor)
	local Passport = vRP.Passport(Source)
	local Elevator = GetElevator(ElevatorId)
	CurrentFloor = tonumber(CurrentFloor) or 1

	if not Passport or not Elevator then return false end

	TriggerClientEvent("maze_elevator:OpenUI", Source, {
		elevatorId = ElevatorId,
		currentFloor = CurrentFloor,
		label = Elevator.Label,
		title = Config.NUI.Title,
		subtitle = Config.NUI.Subtitle,
		logo = Config.NUI.Logo,
		floors = BuildFloorList(Passport, Elevator, CurrentFloor),
		sounds = Config.Sounds,
		blur = Config.NUI.BlurStrength,
		animation = Config.NUI.AnimationMs
	})

	return true
end)
