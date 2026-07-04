-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------------------------------------------------------------------------------
local Capturing = false
local StopRequested = false
local StudioCam = nil
local StudioVehicle = nil
local StudioProps = {}
local SavedPosition = nil
local ProcessCallback = nil
local SaveCallbacks = {}
local ExistsCallback = {}
local ExistsRequestId = 0
local SaveRequestId = 0

local function IsValidModel(Model)
	local Hash = joaat(Model)
	return Hash ~= 0 and IsModelInCdimage(Hash) and IsModelAVehicle(Hash)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD / VISUAL
-----------------------------------------------------------------------------------------------------------------------------------------
local HiddenComponents = {
	1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
}

local function HideHud(Toggle)
	for i = 1, #HiddenComponents do
		if Toggle then
			HideHudComponentThisFrame(HiddenComponents[i])
		end
	end

	DisplayRadar(not Toggle)
	DisplayHud(not Toggle)
end

local function ApplyStudioVisuals()
	local Studio = Config.Studio
	NetworkOverrideClockTime(Studio.Time.Hour, Studio.Time.Minute, Studio.Time.Second or 0)
	SetWeatherTypeNow(Studio.Weather)
	SetWeatherTypePersist(Studio.Weather)
	SetWind(Studio.Wind or 0.0)

	if Studio.Timecycle then
		SetTimecycleModifier(Studio.Timecycle)
		SetTimecycleModifierStrength(Studio.TimecycleStrength or 0.85)
	end
end

local function ClearStudioVisuals()
	ClearTimecycleModifier()
	ClearExtraTimecycleModifier()
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTÚDIO
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadModel(Hash)
	if not IsModelValid(Hash) then return false end
	RequestModel(Hash)
	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Hash) do
		if GetGameTimer() > Timeout then return false end
		Wait(10)
	end
	return true
end

local function CleanupStudio()
	if StudioCam then
		RenderScriptCams(false, false, 0, true, true)
		DestroyCam(StudioCam, false)
		StudioCam = nil
	end

	if StudioVehicle and DoesEntityExist(StudioVehicle) then
		DeleteEntity(StudioVehicle)
		StudioVehicle = nil
	end

	for i = 1, #StudioProps do
		if DoesEntityExist(StudioProps[i]) then
			DeleteEntity(StudioProps[i])
		end
	end
	StudioProps = {}

	ClearStudioVisuals()
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CÂMERA 3/4
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsMotorcycle(Model)
	return IsThisModelABike(Model) or IsThisModelAQuadbike(Model)
end

local function GetCameraSettings(Model)
	if IsMotorcycle(Model) then
		return Config.Motorcycle
	end
	return Config.Camera
end

local function CalculateCameraDistance(Model, Settings)
	local MinDim, MaxDim = GetModelDimensions(Model)
	local SizeX = MaxDim.x - MinDim.x
	local SizeY = MaxDim.y - MinDim.y
	local SizeZ = MaxDim.z - MinDim.z
	local MaxSize = math.max(SizeX, SizeY, SizeZ, 1.0)

	local Fov = Settings.Fov or 38.0
	local Fill = Settings.FillRatio or 0.70
	local FovRad = Fov * math.pi / 180.0

	return (MaxSize / (2.0 * math.tan(FovRad / 2.0))) / Fill
end

local function SetupCamera(Vehicle, Model)
	local Settings = GetCameraSettings(Model)
	local Distance = CalculateCameraDistance(Model, Settings)

	local VehCoords = GetEntityCoords(Vehicle)
	local Heading = math.rad(Config.Camera.VehicleHeading or 45.0)

	local OffsetX = Settings.OffsetX or -3.2
	local OffsetY = Settings.OffsetY or 3.2
	local OffsetZ = Settings.OffsetZ or 0.65

	local CamX = VehCoords.x + (math.cos(Heading) * OffsetX - math.sin(Heading) * OffsetY) * (Distance / 4.0)
	local CamY = VehCoords.y + (math.sin(Heading) * OffsetX + math.cos(Heading) * OffsetY) * (Distance / 4.0)
	local CamZ = VehCoords.z + OffsetZ + (Distance * 0.08)

	if StudioCam then
		DestroyCam(StudioCam, false)
	end

	StudioCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(StudioCam, CamX, CamY, CamZ)
	PointCamAtCoord(StudioCam, VehCoords.x, VehCoords.y, VehCoords.z + (Settings.AimOffsetZ or 0.35))
	SetCamFov(StudioCam, Settings.Fov or 38.0)
	SetCamActive(StudioCam, true)
	RenderScriptCams(true, false, 0, true, true)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN VEÍCULO
-----------------------------------------------------------------------------------------------------------------------------------------
local function SpawnStudioVehicle(Model)
	local Hash = joaat(Model)
	if not IsValidModel(Model) then
		return nil, "Modelo inválido"
	end

	if not LoadModel(Hash) then
		return nil, "Falha ao carregar modelo"
	end

	local Studio = Config.Studio.Coords
	CleanupStudio()

	local Ped = PlayerPedId()
	SavedPosition = {
		coords = GetEntityCoords(Ped),
		heading = GetEntityHeading(Ped)
	}

	SetEntityCoords(Ped, Studio.x, Studio.y, Studio.z - 10.0, false, false, false, false)
	SetEntityVisible(Ped, false, false)
	FreezeEntityPosition(Ped, true)

	ApplyStudioVisuals()

	StudioVehicle = CreateVehicle(Hash, Studio.x, Studio.y, Studio.z, Config.Camera.VehicleHeading or 45.0, false, false)

	if not DoesEntityExist(StudioVehicle) then
		SetModelAsNoLongerNeeded(Hash)
		return nil, "Falha ao spawnar"
	end

	SetEntityAsMissionEntity(StudioVehicle, true, true)
	SetEntityCoords(StudioVehicle, Studio.x, Studio.y, Studio.z, false, false, false, false)
	FreezeEntityPosition(StudioVehicle, true)
	SetVehicleDirtLevel(StudioVehicle, 0.0)
	SetVehicleEngineOn(StudioVehicle, false, true, false)
	SetVehicleDoorsLocked(StudioVehicle, 2)

	if Config.Plate.Hide then
		SetVehicleNumberPlateText(StudioVehicle, Config.Plate.Text or "")
	end

	SetVehicleModKit(StudioVehicle, 0)
	SetVehicleWindowTint(StudioVehicle, 1)

	SetModelAsNoLongerNeeded(Hash)
	SetupCamera(StudioVehicle, Hash)

	return StudioVehicle
end

local function RestorePlayer()
	local Ped = PlayerPedId()
	SetEntityVisible(Ped, true, false)
	FreezeEntityPosition(Ped, false)

	if SavedPosition then
		SetEntityCoords(Ped, SavedPosition.coords.x, SavedPosition.coords.y, SavedPosition.coords.z, false, false, false, false)
		SetEntityHeading(Ped, SavedPosition.heading)
		SavedPosition = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasScreenshotResource()
	return GetResourceState(Config.Capture.ScreenshotResource) == "started"
end

local function NormalizeScreenshotData(Data)
	if not Data or Data == "" then return nil end
	if Data:find("^data:image/") then
		return Data
	end
	return "data:image/png;base64," .. Data
end

local function RequestScreenshot()
	if not HasScreenshotResource() then
		VP_NotifyClient("Error", Config.Lang.NoScreenshot)
		return nil
	end

	local P = promise.new()
	local Resolved = false

	local function Finish(Data)
		if Resolved then return end
		Resolved = true
		ProcessCallback = nil
		P:resolve(Data)
	end

	ProcessCallback = Finish

	SetTimeout(Config.Capture.ScreenshotTimeout or 15000, function()
		if not Resolved then
			VP_NotifyClient("Error", "Timeout ao capturar screenshot.")
			Finish(nil)
		end
	end)

	exports[Config.Capture.ScreenshotResource]:requestScreenshot({ encoding = "png" }, function(Data)
		SendNUIMessage({
			action = "process",
			image = NormalizeScreenshotData(Data),
			width = Config.Image.Width,
			height = Config.Image.Height,
			maxKB = Config.Image.MaxSizeKB,
			quality = Config.Image.Quality
		})
	end)

	return Citizen.Await(P)
end

local function SendImageToServer(Model, ImageData, RequestId)
	local Clean = ImageData:gsub("^data:image/%a+;base64,", "")

	if TriggerLatentServerEvent then
		TriggerLatentServerEvent("vehicle-photos:SaveImage", Config.Capture.LatentBps or 500000, Model, Clean, RequestId)
		return
	end

	local ChunkSize = Config.Capture.ChunkSize or 48000
	local Total = math.ceil(#Clean / ChunkSize)

	TriggerServerEvent("vehicle-photos:SaveBegin", Model, RequestId, Total)

	for Index = 1, Total do
		local Start = (Index - 1) * ChunkSize + 1
		local Chunk = Clean:sub(Start, Start + ChunkSize - 1)
		TriggerServerEvent("vehicle-photos:SaveChunk", RequestId, Index, Chunk)
		Wait(0)
	end

	TriggerServerEvent("vehicle-photos:SaveCommit", Model, RequestId)
end

RegisterNUICallback("processed", function(Data, Cb)
	if ProcessCallback then
		if Data.error then
			ProcessCallback(nil)
		else
			ProcessCallback(Data.data)
		end
		ProcessCallback = nil
	end
	Cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAPTURA
-----------------------------------------------------------------------------------------------------------------------------------------
local function CaptureModel(Model)
	StopRequested = false

	local Vehicle, Error = SpawnStudioVehicle(Model)
	if not Vehicle then
		VP_NotifyClient("Error", (Config.Lang.Failed):format(Model) .. " — " .. (Error or ""))
		RestorePlayer()
		CleanupStudio()
		return false
	end

	Wait(Config.Capture.DelayBeforeShot or 800)

	CreateThread(function()
		local Timeout = GetGameTimer() + 3000
		while GetGameTimer() < Timeout do
			HideHud(true)
			Wait(0)
		end
	end)

	local ImageData = RequestScreenshot()

	RestorePlayer()
	CleanupStudio()

	if not ImageData then
		VP_NotifyClient("Error", (Config.Lang.Failed):format(Model))
		return false
	end

	SaveRequestId = SaveRequestId + 1
	local RequestId = SaveRequestId
	local P = promise.new()

	SaveCallbacks[RequestId] = function(Ok)
		P:resolve(Ok)
	end

	SendImageToServer(Model, ImageData, RequestId)

	local Ok = Citizen.Await(P)
	if not Ok then
		VP_NotifyClient("Error", (Config.Lang.SaveError):format(Model, "verifique o console do servidor"))
		return false
	end

	return true
end

local function CheckExists(Model)
	if not Config.Capture.SkipExisting then return false end

	ExistsRequestId = ExistsRequestId + 1
	local Id = ExistsRequestId
	local P = promise.new()

	ExistsCallback[Id] = function(Exists)
		P:resolve(Exists)
	end

	TriggerServerEvent("vehicle-photos:CheckExists", Model, Id)
	return Citizen.Await(P)
end

RegisterNetEvent("vehicle-photos:SaveResult")
AddEventHandler("vehicle-photos:SaveResult", function(SavedModel, Ok, Result, RequestId)
	if SaveCallbacks[RequestId] then
		SaveCallbacks[RequestId](Ok)
		SaveCallbacks[RequestId] = nil
	end
end)

RegisterNetEvent("vehicle-photos:ExistsResult")
AddEventHandler("vehicle-photos:ExistsResult", function(RequestId, Exists)
	if ExistsCallback[RequestId] then
		ExistsCallback[RequestId](Exists)
		ExistsCallback[RequestId] = nil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BATCH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehicle-photos:StartBatch")
AddEventHandler("vehicle-photos:StartBatch", function(List)
	if Capturing then return end

	Capturing = true
	StopRequested = false

	VP_NotifyClient("Info", (Config.Lang.Started):format(#List))

	local Saved = 0

	for i = 1, #List do
		if StopRequested then break end

		local Model = List[i]

		if CheckExists(Model) then
			VP_NotifyClient("Info", (Config.Lang.Skipped):format(Model), 2000)
		else
			VP_NotifyClient("Info", (Config.Lang.Progress):format(i, #List, Model), 3000)

			if CaptureModel(Model) then
				Saved = Saved + 1
				VP_NotifyClient("Success", (Config.Lang.Saved):format(Model), 2000)
			end
		end

		Wait(Config.Capture.DelayBetweenVehicles or 1200)
	end

	Capturing = false
	TriggerServerEvent("vehicle-photos:Finished", Saved)
	VP_NotifyClient("Success", (Config.Lang.Done):format(Saved), 8000)
end)

RegisterNetEvent("vehicle-photos:CaptureSingle")
AddEventHandler("vehicle-photos:CaptureSingle", function(Model)
	if Capturing then
		VP_NotifyClient("Warning", Config.Lang.AlreadyRunning)
		return
	end

	Capturing = true
	if CaptureModel(Model) then
		VP_NotifyClient("Success", (Config.Lang.SingleDone):format(Model))
	end
	Capturing = false
end)

RegisterNetEvent("vehicle-photos:Stop")
AddEventHandler("vehicle-photos:Stop", function()
	StopRequested = true
	Capturing = false
	RestorePlayer()
	CleanupStudio()
end)

exports("CaptureVehicle", function(Model)
	return CaptureModel(VP_NormalizeModel(Model))
end)

exports("IsCapturing", function()
	return Capturing
end)
