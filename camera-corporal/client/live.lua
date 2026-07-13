-----------------------------------------------------------------------------------------------------------------------------------------
-- AO VIVO — ASSISTIR BODYCAM DE OUTROS OFICIAIS
-----------------------------------------------------------------------------------------------------------------------------------------

local Watching = false
local WatchTarget = nil
local WatchCam = nil
local WatchPed = nil
local SavedViewer = nil

function BCC_IsWatchingLive()
	return Watching
end

function BCC_GetWatchTarget()
	return WatchTarget
end

local function SaveViewerState(Ped)
	return {
		visible = IsEntityVisible(Ped)
	}
end

local function RestoreViewerState(Ped)
	if not SavedViewer then return end
	SetEntityVisible(Ped, SavedViewer.visible, false)
	FreezeEntityPosition(Ped, false)
	SetEntityCollision(Ped, true, true)
	SavedViewer = nil
end

function BCC_StartLiveWatch(TargetSource, OfficerData)
	if Watching then
		BCC_StopLiveWatch(false)
	end

	TargetSource = tonumber(TargetSource)
	local PlayerIdx = GetPlayerFromServerId(TargetSource)
	if PlayerIdx == -1 then
		BCC_Notify("negado", Config.Lang.OfficerOffline)
		return false
	end

	local TargetPed = GetPlayerPed(PlayerIdx)
	if not TargetPed or not DoesEntityExist(TargetPed) then
		BCC_Notify("negado", Config.Lang.OfficerOffline)
		return false
	end

	local ViewerPed = PlayerPedId()
	SavedViewer = SaveViewerState(ViewerPed)

	if Config.LiveView.HideViewerPed then
		SetEntityVisible(ViewerPed, false, false)
	end

	if Config.LiveView.FreezeViewer then
		FreezeEntityPosition(ViewerPed, true)
		SetEntityCollision(ViewerPed, false, false)
	end

	local Live = Config.LiveView
	WatchCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	local Bone = GetPedBoneIndex(TargetPed, Live.WatchBone or 31086)
	local Offset = Live.WatchOffset or vec3(0.0, 0.08, 0.14)

	AttachCamToPedBone(
		WatchCam, TargetPed, Bone,
		Offset.x, Offset.y, Offset.z,
		true
	)

	SetCamFov(WatchCam, Live.WatchFov or 82.0)
	SetCamNearClip(WatchCam, 0.1)
	RenderScriptCams(true, true, 500, true, true)

	Watching = true
	WatchTarget = TargetSource
	WatchPed = TargetPed

	BCC_CloseNui(true)
	BCC_ShowLiveOverlay(OfficerData or {})
	BCC_Notify("info", string.format(Config.Lang.LiveWatchStart, OfficerData and OfficerData.officerName or "Oficial"), 5000)

	return true
end

function BCC_StopLiveWatch(NotifyServer)
	if not Watching then return end

	if NotifyServer ~= false and WatchTarget then
		vSERVER.StopWatch(WatchTarget)
	end

	if WatchCam and DoesCamExist(WatchCam) then
		RenderScriptCams(false, true, 500, true, true)
		DestroyCam(WatchCam, false)
	end

	WatchCam = nil
	WatchTarget = nil
	WatchPed = nil
	Watching = false

	RestoreViewerState(PlayerPedId())
	BCC_HideLiveOverlay()

	if NotifyServer ~= false then
		BCC_Notify("important", Config.Lang.LiveWatchStop, 4000)
	end
end

function BCC_ShowLiveOverlay(Data)
	SendNUIMessage({
		action = "liveOverlay",
		visible = true,
		data = Data
	})
end

function BCC_HideLiveOverlay()
	SendNUIMessage({
		action = "liveOverlay",
		visible = false
	})
end

function BCC_UpdateLiveOverlay(Data)
	if not Watching then return end
	SendNUIMessage({
		action = "liveOverlayUpdate",
		data = Data
	})
end

CreateThread(function()
	while true do
		if Watching then
			local PlayerIdx = GetPlayerFromServerId(WatchTarget or -1)
			if PlayerIdx == -1 then
				BCC_StopLiveWatch(true)
			else
				local TargetPed = GetPlayerPed(PlayerIdx)
				if not TargetPed or not DoesEntityExist(TargetPed) or IsEntityDead(TargetPed) then
					BCC_StopLiveWatch(true)
				else
					WatchPed = TargetPed

					if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
						BCC_StopLiveWatch(true)
					end

					DrawRect(0.5, 0.02, 1.0, 0.045, 0, 0, 0, 140)
					SetTextFont(4)
					SetTextScale(0.35, 0.35)
					SetTextColour(255, 60, 60, 255)
					SetTextCentre(true)
					SetTextEntry("STRING")
					AddTextComponentString("● AO VIVO — ESC para sair")
					DrawText(0.5, 0.012)
				end
			end
			Wait(0)
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(Config.LiveView.TelemetryInterval or 2000)

		if BCC_IsRecording() then
			local Session = BCC_GetSession()
			local Payload = BCC_GetEventPayload()
			Payload.officerName = Session.officerName
			Payload.unit = Session.unit
			Payload.badge = Session.badge
			Payload.battery = Session.battery
			Payload.elapsed = Session.elapsed
			Payload.health = BCC_Round(math.max(0, GetEntityHealth(PlayerPedId()) - 100), 0)
			Payload.armor = GetPedArmour(PlayerPedId())
			Payload.weapon = BCC_GetWeaponLabel(GetSelectedPedWeapon(PlayerPedId()))
			Payload.inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
			TriggerServerEvent("camera-corporal:UpdateTelemetry", Payload)
		end
	end
end)

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		BCC_StopLiveWatch(false)
	end
end)
