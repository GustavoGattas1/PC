local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Busy = false
local StopFlag = false
local SavedPlayer = nil
local StudioCam = nil
local StudioVehicle = nil
local LoadedHash = nil
local ScreenshotPromise = nil

local function Notify(Type, Message, Time)
	local N = Config.Notify
	TriggerEvent("Notify", N.Title, Message, N[Type] or N.Info, Time or 5000)
end

local function HideHudThisFrame()
	local Components = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 }
	for i = 1, #Components do
		HideHudComponentThisFrame(Components[i])
	end
	DisplayRadar(false)
	DisplayHud(false)
end

local function WaitMs(Ms)
	local Start = GetGameTimer()
	while GetGameTimer() - Start < Ms do
		HideHudThisFrame()
		Wait(0)
	end
end

local function ApplyStudioWorld()
	local S = Config.Studio
	NetworkOverrideClockTime(S.Time.Hour, S.Time.Minute, S.Time.Second or 0)
	SetWeatherTypeNow(S.Weather)
	SetWeatherTypePersist(S.Weather)
	SetWind(0.0)
	SetTimecycleModifier(S.Timecycle)
	SetTimecycleModifierStrength(S.TimecycleStrength or 0.45)
end

local function ClearStudioWorld()
	ClearTimecycleModifier()
	ClearExtraTimecycleModifier()
end

local function SavePlayerState()
	local Ped = PlayerPedId()
	SavedPlayer = {
		coords = GetEntityCoords(Ped),
		heading = GetEntityHeading(Ped)
	}
end

local function RestorePlayerState()
	local Ped = PlayerPedId()
	SetEntityVisible(Ped, true, false)
	SetEntityCollision(Ped, true, true)
	FreezeEntityPosition(Ped, false)

	if SavedPlayer then
		SetEntityCoords(Ped, SavedPlayer.coords.x, SavedPlayer.coords.y, SavedPlayer.coords.z, false, false, false, false)
		SetEntityHeading(Ped, SavedPlayer.heading)
		SavedPlayer = nil
	end
end

local function DestroyStudio()
	if StudioCam then
		RenderScriptCams(false, true, 500, true, true)
		DestroyCam(StudioCam, false)
		StudioCam = nil
	end

	if StudioVehicle and DoesEntityExist(StudioVehicle) then
		DeleteEntity(StudioVehicle)
		StudioVehicle = nil
	end

	if LoadedHash then
		SetModelAsNoLongerNeeded(LoadedHash)
		LoadedHash = nil
	end

	ClearStudioWorld()
end

local function LoadVehicleModel(Hash)
	if not IsModelInCdimage(Hash) or not IsModelAVehicle(Hash) then
		return false
	end

	RequestModel(Hash)
	local Deadline = GetGameTimer() + Config.Timing.ModelLoadTimeout
	while not HasModelLoaded(Hash) do
		if GetGameTimer() > Deadline then
			return false
		end
		Wait(10)
	end

	return true
end

local function SetupCamera(Vehicle)
	local Coords = GetEntityCoords(Vehicle)
	local MinDim, MaxDim = GetModelDimensions(GetEntityModel(Vehicle))
	local Size = math.max(MaxDim.x - MinDim.x, MaxDim.y - MinDim.y, MaxDim.z - MinDim.z, 2.0)
	local Dist = Size * Config.Camera.DistanceMultiplier

	local CamPos = GetOffsetFromEntityInWorldCoords(
		Vehicle,
		-Dist * Config.Camera.SideOffset,
		Dist * Config.Camera.SideOffset,
		Size * Config.Camera.HeightOffset
	)

	if StudioCam then
		DestroyCam(StudioCam, false)
	end

	StudioCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(StudioCam, CamPos.x, CamPos.y, CamPos.z)
	PointCamAtCoord(StudioCam, Coords.x, Coords.y, Coords.z + (Size * 0.25))
	SetCamFov(StudioCam, Config.Camera.Fov)
	SetCamActive(StudioCam, true)
	RenderScriptCams(true, true, 500, true, true)
end

local function WaitVehicleReady(Vehicle)
	local S = Config.Studio.Coords
	SetEntityLoadCollisionFlag(Vehicle, true)
	SetFocusEntity(Vehicle)
	RequestCollisionAtCoord(S.x, S.y, S.z)

	local Deadline = GetGameTimer() + Config.Timing.StreamTimeout
	while GetGameTimer() < Deadline do
		if HasCollisionLoadedAroundEntity(Vehicle) and not IsEntityWaitingForWorldCollision(Vehicle) then
			break
		end
		HideHudThisFrame()
		SetFocusEntity(Vehicle)
		Wait(0)
	end

	for _ = 1, Config.Timing.RenderFrames do
		HideHudThisFrame()
		SetFocusEntity(Vehicle)
		Wait(0)
	end

	WaitMs(Config.Timing.SettleAfterLoad)
	ClearFocus()
end

local function SpawnVehicle(Model)
	local Hash = joaat(Model)
	if not LoadVehicleModel(Hash) then
		return nil, "modelo inválido ou timeout"
	end

	DestroyStudio()
	SavePlayerState()

	local Ped = PlayerPedId()
	local S = Config.Studio.Coords

	SetEntityCoords(Ped, S.x, S.y, S.z - 50.0, false, false, false, false)
	SetEntityVisible(Ped, false, false)
	SetEntityCollision(Ped, false, false)
	FreezeEntityPosition(Ped, true)

	ApplyStudioWorld()

	StudioVehicle = CreateVehicle(Hash, S.x, S.y, S.z, S.w, false, false)
	if not DoesEntityExist(StudioVehicle) then
		return nil, "falha ao spawnar"
	end

	LoadedHash = Hash
	SetEntityAsMissionEntity(StudioVehicle, true, true)
	SetEntityCoords(StudioVehicle, S.x, S.y, S.z, false, false, false, false)
	FreezeEntityPosition(StudioVehicle, true)
	SetVehicleDirtLevel(StudioVehicle, 0.0)
	SetVehicleEngineOn(StudioVehicle, false, true, false)
	SetVehicleNumberPlateText(StudioVehicle, "")
	SetVehicleModKit(StudioVehicle, 0)

	SetupCamera(StudioVehicle)
	WaitVehicleReady(StudioVehicle)
	WaitMs(Config.Timing.BeforePhoto)

	return StudioVehicle
end

local function HasScreenshot()
	return GetResourceState(Config.Capture.ScreenshotResource) == "started"
end

RegisterNUICallback("photoReady", function(Data, Cb)
	if ScreenshotPromise then
		if Data.ok and Data.image then
			ScreenshotPromise:resolve(Data.image)
		else
			ScreenshotPromise:resolve(nil)
		end
		ScreenshotPromise = nil
	end
	Cb("ok")
end)

local function CaptureScreenshot()
	if not HasScreenshot() then
		Notify("Error", Config.Lang.NoScreenshot)
		return nil
	end

	local P = promise.new()
	ScreenshotPromise = P
	local Done = false

	SetTimeout(Config.Timing.ScreenshotTimeout, function()
		if not Done then
			Done = true
			if ScreenshotPromise then
				ScreenshotPromise:resolve(nil)
				ScreenshotPromise = nil
			end
		end
	end)

	exports[Config.Capture.ScreenshotResource]:requestScreenshot({ encoding = "png" }, function(Data)
		if Done then return end
		SendNUIMessage({
			action = "process",
			image = Data,
			width = Config.Image.Width,
			height = Config.Image.Height,
			maxKB = Config.Image.MaxKB
		})
	end)

	local Result = Citizen.Await(P)
	Done = true
	return Result
end

local SaveCallbacks = {}
local ExistsCallbacks = {}
local RequestCounter = 0

local function NextRequestId()
	RequestCounter = RequestCounter + 1
	return RequestCounter
end

RegisterNetEvent("vehicle-photos:client:saveResult")
AddEventHandler("vehicle-photos:client:saveResult", function(RequestId, Ok)
	if SaveCallbacks[RequestId] then
		SaveCallbacks[RequestId](Ok)
		SaveCallbacks[RequestId] = nil
	end
end)

RegisterNetEvent("vehicle-photos:client:existsResult")
AddEventHandler("vehicle-photos:client:existsResult", function(RequestId, Exists)
	if ExistsCallbacks[RequestId] then
		ExistsCallbacks[RequestId](Exists)
		ExistsCallbacks[RequestId] = nil
	end
end)

local function SavePhoto(Model, Base64)
	local P = promise.new()
	local RequestId = NextRequestId()

	SaveCallbacks[RequestId] = function(Ok)
		P:resolve(Ok)
	end

	if TriggerLatentServerEvent then
		TriggerLatentServerEvent("vehicle-photos:server:save", 500000, RequestId, Model, Base64)
	else
		TriggerServerEvent("vehicle-photos:server:save", RequestId, Model, Base64)
	end

	return Citizen.Await(P)
end

local function FileExists(Model)
	local P = promise.new()
	local RequestId = NextRequestId()

	ExistsCallbacks[RequestId] = function(Exists)
		P:resolve(Exists)
	end

	TriggerServerEvent("vehicle-photos:server:exists", RequestId, Model)
	return Citizen.Await(P)
end

local function CaptureOne(Model)
	if StopFlag then return false end

	Notify("Info", Config.Lang.Loading:format(Model), 4000)

	local Vehicle, Err = SpawnVehicle(Model)
	if not Vehicle then
		Notify("Error", Config.Lang.Failed:format(Model .. " (" .. (Err or "?") .. ")"))
		RestorePlayerState()
		DestroyStudio()
		return false
	end

	local Image = CaptureScreenshot()
	WaitMs(Config.Timing.AfterPhoto)

	RestorePlayerState()
	DestroyStudio()

	if not Image then
		Notify("Error", Config.Lang.Failed:format(Model))
		return false
	end

	if not SavePhoto(Model, Image) then
		Notify("Error", Config.Lang.SaveError:format(Model))
		return false
	end

	return true
end

RegisterNetEvent("vehicle-photos:client:captureAll")
AddEventHandler("vehicle-photos:client:captureAll", function(List)
	if Busy then
		Notify("Warning", Config.Lang.AlreadyRunning)
		return
	end

	Busy = true
	StopFlag = false

	Notify("Info", Config.Lang.Started:format(#List))
	local Saved = 0

	for i = 1, #List do
		if StopFlag then break end

		local Model = string.lower(List[i])

		if Config.Capture.SkipExisting and FileExists(Model) then
			Notify("Info", Config.Lang.Skipped:format(Model), 3000)
		else
			Notify("Info", Config.Lang.Progress:format(i, #List, Model), 4000)
			if CaptureOne(Model) then
				Saved = Saved + 1
				Notify("Success", Config.Lang.Saved:format(Model), 3000)
			end
		end

		Wait(Config.Timing.BetweenVehicles)
	end

	Busy = false
	TriggerServerEvent("vehicle-photos:server:finished")
	Notify("Success", Config.Lang.Done:format(Saved), 8000)
end)

RegisterNetEvent("vehicle-photos:client:captureOne")
AddEventHandler("vehicle-photos:client:captureOne", function(Model)
	if Busy then
		Notify("Warning", Config.Lang.AlreadyRunning)
		return
	end

	Busy = true
	StopFlag = false

	if CaptureOne(string.lower(Model)) then
		Notify("Success", Config.Lang.SingleDone:format(Model))
	end

	Busy = false
	TriggerServerEvent("vehicle-photos:server:finished")
end)

RegisterNetEvent("vehicle-photos:client:stop")
AddEventHandler("vehicle-photos:client:stop", function()
	StopFlag = true
	Busy = false
	RestorePlayerState()
	DestroyStudio()
end)

exports("CaptureVehicle", function(Model)
	if Busy then return false end
	Busy = true
	local Ok = CaptureOne(string.lower(tostring(Model)))
	Busy = false
	return Ok
end)

exports("IsCapturing", function()
	return Busy
end)
