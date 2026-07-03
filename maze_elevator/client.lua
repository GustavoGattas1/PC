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
vSERVER = Tunnel.getInterface("maze_elevator")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Panels = {}
local NuiOpen = false
local Traveling = false
local CurrentContext = nil

local InteractionDistance = Config.InteractionDistance
local MarkerDistance = Config.MarkerDistance
local InteractionDistanceSq = InteractionDistance * InteractionDistance
local MarkerDistanceSq = MarkerDistance * MarkerDistance

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(Message, Color)
	TriggerEvent("Notify", Config.Notify.Title, Message, Color or Config.Notify.Info, 5000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INDEXA PAINÉIS DO CONFIG (executado uma vez)
-----------------------------------------------------------------------------------------------------------------------------------------
local function BuildPanelIndex()
	local Index = 1

	for ElevatorId, Elevator in pairs(Config.Elevators) do
		if Elevator.Floors then
			for FloorIndex, Floor in ipairs(Elevator.Floors) do
				local Panel = Floor.Panel

				if not Panel and Floor.Coords then
					Panel = vec3(Floor.Coords.x, Floor.Coords.y, Floor.Coords.z)
				end

				if Panel then
					Panels[Index] = {
						elevatorId = ElevatorId,
						floorIndex = FloorIndex,
						coords = Panel
					}
					Index = Index + 1
				end
			end
		end
	end
end

BuildPanelIndex()

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESENHO DE TEXTO 3D
-----------------------------------------------------------------------------------------------------------------------------------------
local function DrawText3D(x, y, z, text)
	local OnScreen, ScreenX, ScreenY = World3dToScreen2d(x, y, z)
	if not OnScreen then return end

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextColour(255, 255, 255, 215)
	SetTextOutline()
	SetTextCentre(true)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(ScreenX, ScreenY)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESENHO DE MARKER
-----------------------------------------------------------------------------------------------------------------------------------------
local function DrawPanelMarker(Coords)
	local Color = Config.MarkerColor
	local Scale = Config.MarkerScale

	DrawMarker(
		Config.MarkerType,
		Coords.x, Coords.y, Coords.z - 0.95,
		0.0, 0.0, 0.0,
		0.0, 0.0, 0.0,
		Scale.x, Scale.y, Scale.z,
		Color.r, Color.g, Color.b, Color.a or 160,
		Config.MarkerBob,
		Config.MarkerRotate,
		2, false, nil, nil, false
	)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTROLE DA NUI
-----------------------------------------------------------------------------------------------------------------------------------------
local function SetNui(State)
	NuiOpen = State
	SetNuiFocus(State, State)
	SetNuiFocusKeepInput(false)

	if State then
		DisplayRadar(false)
	else
		DisplayRadar(true)
	end
end

local function DisableControls()
	DisableControlAction(0, 1, true)
	DisableControlAction(0, 2, true)
	DisableControlAction(0, 24, true)
	DisableControlAction(0, 25, true)
	DisableControlAction(0, 37, true)
	DisableControlAction(0, 44, true)
	DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 257, true)
	DisableControlAction(0, 263, true)
	DisableControlAction(0, 264, true)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR ELEVADOR (EXPORT / LOCAL)
-----------------------------------------------------------------------------------------------------------------------------------------
local function OpenElevator(ElevatorId, FloorIndex)
	if NuiOpen or Traveling then return false end

	TriggerServerEvent("maze_elevator:Open", ElevatorId, FloorIndex)
	return true
end

exports("OpenElevator", OpenElevator)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: ABRIR UI (SERVER → CLIENT)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maze_elevator:OpenUI")
AddEventHandler("maze_elevator:OpenUI", function(Payload)
	if Traveling then return end

	CurrentContext = {
		elevatorId = Payload.elevatorId,
		currentFloor = Payload.currentFloor,
		testMode = Payload.testMode == true
	}

	SetNui(true)

	if Config.Teleport.ScreenBlur then
		TriggerScreenblurFadeIn(250)
	end

	SendNUIMessage({
		action = "open",
		data = Payload
	})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO: FECHAR UI
-----------------------------------------------------------------------------------------------------------------------------------------
local function CloseUI()
	SendNUIMessage({ action = "close" })
	SetNui(false)

	if Config.Teleport.ScreenBlur then
		TriggerScreenblurFadeOut(250)
	end

	CurrentContext = nil
end

RegisterNetEvent("maze_elevator:Close")
AddEventHandler("maze_elevator:Close", CloseUI)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(_, Cb)
	CloseUI()
	Cb("ok")
end)

RegisterNUICallback("selectFloor", function(Data, Cb)
	if not CurrentContext or Traveling then
		Cb("busy")
		return
	end

	local TargetFloor = tonumber(Data.floor)
	if not TargetFloor then
		Cb("invalid")
		return
	end

	TriggerServerEvent(
		"maze_elevator:Teleport",
		CurrentContext.elevatorId,
		TargetFloor,
		CurrentContext.currentFloor
	)

	Cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR COLISÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadCollisionAtCoords(x, y, z)
	local Timeout = Config.Teleport.CollisionTimeout
	local Step = Config.Teleport.CollisionStep

	RequestCollisionAtCoord(x, y, z)

	while Timeout > 0 do
		if HasCollisionLoadedAroundEntity(PlayerPedId()) then
			return true
		end

		Wait(Step)
		Timeout = Timeout - Step
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTE SEGURO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maze_elevator:DoTeleport")
AddEventHandler("maze_elevator:DoTeleport", function(Data)
	if Traveling or not Data or not Data.destination then return end

	Traveling = true
	local Ped = PlayerPedId()
	local Dest = Data.destination

	SendNUIMessage({ action = "close" })
	SetNui(false)

	if Config.Teleport.ScreenBlur then
		TriggerScreenblurFadeOut(200)
	end

	DoScreenFadeOut(Data.fadeOut or 800)
	Wait(Data.fadeOut or 800)

	if Data.freeze then
		FreezeEntityPosition(Ped, true)
	end

	SendNUIMessage({ action = "playSound", sound = "elevator", volume = Config.Sounds.Volume })

	if Data.cameraShake then
		ShakeGameplayCam("ROAD_VIBRATION_SHAKE", Data.shakeIntensity or 0.08)
	end

	Wait(Data.travelDelay or 2500)

	SetEntityCoordsNoOffset(Ped, Dest.x, Dest.y, Dest.z, false, false, false)
	SetEntityHeading(Ped, Dest.heading or 0.0)

	LoadCollisionAtCoords(Dest.x, Dest.y, Dest.z)

	local GroundFound, GroundZ = GetGroundZFor_3dCoord(Dest.x, Dest.y, Dest.z + 1.0, false)
	if GroundFound and math.abs(GroundZ - Dest.z) > 3.0 then
		SetEntityCoordsNoOffset(Ped, Dest.x, Dest.y, GroundZ + 0.15, false, false, false)
	end

	StopGameplayCamShaking(true)

	if Data.freeze then
		FreezeEntityPosition(Ped, false)
	end

	SendNUIMessage({ action = "playSound", sound = "ding", volume = Config.Sounds.Volume })

	DoScreenFadeIn(Data.fadeIn or 800)
	Wait(Data.fadeIn or 800)

	Notify(Config.Lang.Arrived, Config.Notify.Success)

	Traveling = false
	CurrentContext = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE PROXIMIDADE (OTIMIZADO)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if not NuiOpen and not Traveling then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			local NearInteract = false

			for i = 1, #Panels do
				local Panel = Panels[i]
				local Dx = Coords.x - Panel.coords.x
				local Dy = Coords.y - Panel.coords.y
				local Dz = Coords.z - Panel.coords.z
				local DistSq = Dx * Dx + Dy * Dy + Dz * Dz

				if DistSq <= MarkerDistanceSq then
					Sleep = 0

					if Config.DrawMarker then
						DrawPanelMarker(Panel.coords)
					end

					if DistSq <= InteractionDistanceSq then
						NearInteract = true

						if Config.DrawText3D then
							DrawText3D(Panel.coords.x, Panel.coords.y, Panel.coords.z + 0.25, Config.Text3D)
						end

						if IsControlJustPressed(0, Config.InteractionKey) then
							OpenElevator(Panel.elevatorId, Panel.floorIndex)
						end
					end
				end
			end

			if not NearInteract and Sleep == 0 then
				Sleep = 250
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE CONTROLES COM NUI ABERTA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if NuiOpen then
			DisableControls()

			if IsControlJustPressed(0, 200) or IsControlJustPressed(0, 322) then
				CloseUI()
			end

			Wait(0)
		else
			Wait(500)
		end
	end
end)
