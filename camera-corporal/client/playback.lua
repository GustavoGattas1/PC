-----------------------------------------------------------------------------------------------------------------------------------------
-- REPRODUÇÃO DE GRAVAÇÕES (timeline + câmera nas rotas)
-----------------------------------------------------------------------------------------------------------------------------------------

local Playing = false
local PlayCam = nil
local PlayFrames = {}
local PlayIndex = 1
local PlayElapsed = 0.0
local PlayDuration = 0
local PlaySpeed = 1.0

function BCC_IsPlayingBack()
	return Playing
end

local function BuildPlaybackFrames(Events)
	local Frames = {}

	for _, Event in ipairs(Events or {}) do
		local Coords = BCC_ParseCoords(Event.coords)
		if not Coords and Event.metadata then
			local Meta = type(Event.metadata) == "string" and BCC_Decode(Event.metadata) or Event.metadata
			if Meta and Meta.coords then
				Coords = BCC_ParseCoords(Meta.coords)
			end
		end

		if Coords then
			Frames[#Frames + 1] = {
				elapsed = Event.elapsed or 0,
				coords = Coords,
				heading = Event.heading or 0.0,
				label = Event.label,
				type = Event.type or Event.event_type
			}
		end
	end

	table.sort(Frames, function(A, B)
		return (A.elapsed or 0) < (B.elapsed or 0)
	end)

	return Frames
end

function BCC_StartPlayback(SessionData)
	if Playing then
		BCC_StopPlayback(false)
	end

	local Events = SessionData.events or {}
	local Frames = BuildPlaybackFrames(Events)

	if #Frames < 2 then
		BCC_Notify("negado", "Gravação sem pontos suficientes para reproduzir.", 5000)
		return false
	end

	PlayFrames = Frames
	PlayDuration = SessionData.session and SessionData.session.duration or Frames[#Frames].elapsed or 0
	PlayIndex = 1
	PlayElapsed = 0.0
	PlaySpeed = Config.Playback.Speed or 1.0
	Playing = true

	local First = PlayFrames[1]
	PlayCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(PlayCam, First.coords.x, First.coords.y, First.coords.z + (Config.Playback.CameraHeight or 1.65))
	SetCamRot(PlayCam, 0.0, 0.0, First.heading or 0.0, 2)
	SetCamFov(PlayCam, 75.0)
	RenderScriptCams(true, true, 600, true, true)

	BCC_CloseNui(true)
	BCC_ShowPlaybackOverlay(SessionData.session, 0)
	BCC_Notify("info", Config.Lang.PlaybackStart, 5000)

	return true
end

function BCC_StopPlayback(Notify)
	if not Playing then return end

	Playing = false
	PlayFrames = {}

	if PlayCam and DoesCamExist(PlayCam) then
		RenderScriptCams(false, true, 500, true, true)
		DestroyCam(PlayCam, false)
	end

	PlayCam = nil
	BCC_HidePlaybackOverlay()

	if Notify ~= false then
		BCC_Notify("important", Config.Lang.PlaybackStop, 4000)
	end
end

function BCC_SeekPlayback(Elapsed)
	if not Playing or #PlayFrames < 2 then return end

	PlayElapsed = math.max(0, math.min(Elapsed or 0, PlayDuration))

	for Index, Frame in ipairs(PlayFrames) do
		if Frame.elapsed >= PlayElapsed then
			PlayIndex = math.max(1, Index - 1)
			break
		end
	end
end

function BCC_ShowPlaybackOverlay(Session, Elapsed)
	SendNUIMessage({
		action = "playbackOverlay",
		visible = true,
		data = {
			session = Session,
			elapsed = Elapsed,
			duration = PlayDuration
		}
	})
end

function BCC_HidePlaybackOverlay()
	SendNUIMessage({
		action = "playbackOverlay",
		visible = false
	})
end

function BCC_UpdatePlaybackOverlay(Elapsed)
	if not Playing then return end
	SendNUIMessage({
		action = "playbackOverlayUpdate",
		data = {
			elapsed = Elapsed,
			duration = PlayDuration,
			frame = PlayFrames[PlayIndex]
		}
	})
end

CreateThread(function()
	while true do
		if Playing and #PlayFrames >= 2 then
			local Step = (Config.Playback.StepMs or 50) / 1000.0
			PlayElapsed = PlayElapsed + (Step * PlaySpeed)

			if PlayElapsed >= PlayDuration then
				BCC_StopPlayback(true)
			else
				while PlayIndex < #PlayFrames and PlayFrames[PlayIndex + 1].elapsed <= PlayElapsed do
					PlayIndex = PlayIndex + 1
				end

				local Current = PlayFrames[PlayIndex]
				local Next = PlayFrames[math.min(PlayIndex + 1, #PlayFrames)]
				local Span = math.max(0.001, (Next.elapsed or 0) - (Current.elapsed or 0))
				local Alpha = math.min(1.0, (PlayElapsed - (Current.elapsed or 0)) / Span)

				local X = Current.coords.x + ((Next.coords.x - Current.coords.x) * Alpha)
				local Y = Current.coords.y + ((Next.coords.y - Current.coords.y) * Alpha)
				local Z = Current.coords.z + ((Next.coords.z - Current.coords.z) * Alpha) + (Config.Playback.CameraHeight or 1.65)

				if PlayCam and DoesCamExist(PlayCam) then
					SetCamCoord(PlayCam, X, Y, Z)
				end

				BCC_UpdatePlaybackOverlay(PlayElapsed)

				if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
					BCC_StopPlayback(true)
				end
			end

			Wait(Config.Playback.StepMs or 50)
		else
			Wait(400)
		end
	end
end)

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		BCC_StopPlayback(false)
	end
end)
