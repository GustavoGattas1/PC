-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOR DE GRAVAÇÃO E DETECÇÃO DE EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------

local Session = {
	active = false,
	recording = false,
	sessionId = nil,
	startedAt = 0,
	elapsed = 0,
	battery = 100,
	officerName = "",
	badge = "",
	unit = "",
	bookmarks = 0,
	events = 0,
	lastWeapon = nil,
	lastShotTime = 0,
	lastDamage = 0,
	lastSiren = false,
	lowBatteryWarned = false
}

function BCC_GetSession()
	return Session
end

function BCC_IsActive()
	return Session.active
end

function BCC_IsRecording()
	return Session.recording
end

function BCC_GetSessionId()
	return Session.sessionId
end

function BCC_ResetSession()
	Session = {
		active = false,
		recording = false,
		sessionId = nil,
		startedAt = 0,
		elapsed = 0,
		battery = Config.Recording.FullBatteryOnStart,
		officerName = "",
		badge = "",
		unit = "",
		bookmarks = 0,
		events = 0,
		lastWeapon = nil,
		lastShotTime = 0,
		lastDamage = 0,
		lastSiren = false,
		lowBatteryWarned = false
	}
end

function BCC_StartSession(Data)
	BCC_ResetSession()

	Session.active = true
	Session.recording = true
	Session.sessionId = Data.sessionId
	Session.startedAt = GetGameTimer()
	Session.battery = Config.Recording.FullBatteryOnStart
	Session.officerName = Data.officerName or "Oficial"
	Session.badge = Data.badge or ("#" .. tostring(Data.passport or "?"))
	Session.unit = Data.unit or "PATRULHA"

	BCC_AttachProp()
	BCC_PlaySound("Start")
	BCC_UpdateNuiHud()

	TriggerServerEvent("camera-corporal:LogEvent", Session.sessionId, "session_start", "Gravação iniciada", BCC_GetEventPayload())
end

function BCC_StopSession(Save)
	if not Session.active then return end

	local SessionId = Session.sessionId
	Session.active = false
	Session.recording = false

	BCC_RemoveProp()
	BCC_PlaySound("Stop")
	BCC_UpdateNuiHud(true)

	if Save and SessionId then
		TriggerServerEvent("camera-corporal:EndSession", SessionId, {
			elapsed = Session.elapsed,
			battery = Session.battery,
			events = Session.events,
			bookmarks = Session.bookmarks
		})
	end

	BCC_ResetSession()
end

function BCC_GetEventPayload()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Speed = 0.0
	local Vehicle = nil

	if IsPedInAnyVehicle(Ped, false) then
		Vehicle = GetVehiclePedIsIn(Ped, false)
		Speed = GetEntitySpeed(Vehicle) * 3.6
	end

	return {
		coords = { x = Coords.x, y = Coords.y, z = Coords.z },
		street = BCC_GetStreetLabel(Coords),
		speed = BCC_Round(Speed, 0),
		weapon = GetSelectedPedWeapon(Ped),
		elapsed = Session.elapsed
	}
end

function BCC_LogEvent(EventType, Label, Extra)
	if not Session.recording or not Session.sessionId then return end

	Session.events = Session.events + 1

	local Payload = BCC_GetEventPayload()
	if Extra then
		for Key, Value in pairs(Extra) do
			Payload[Key] = Value
		end
	end

	TriggerServerEvent("camera-corporal:LogEvent", Session.sessionId, EventType, Label, Payload)
	BCC_Debug("Evento:", EventType, Label)
end

function BCC_AddBookmark(Label)
	if not Session.recording or not Session.sessionId then return false end
	if Session.bookmarks >= Config.Recording.MaxBookmarks then
		BCC_Notify("important", "Limite de marcações atingido.", 4000)
		return false
	end

	Session.bookmarks = Session.bookmarks + 1
	local Payload = BCC_GetEventPayload()
	Payload.label = Label or "Incidente marcado"

	TriggerServerEvent("camera-corporal:AddBookmark", Session.sessionId, Payload)
	BCC_PlaySound("Bookmark")
	BCC_Notify("success", Config.Lang.BookmarkSaved, 3000)
	return true
end

function BCC_PlaySound(Type)
	local Sound = Config.Sounds[Type]
	if not Sound then return end
	PlaySoundFrontend(-1, Sound.Name, Sound.Set, true)
end

function BCC_UpdateNuiHud(Hide)
	if Hide or not Session.active then
		SendNUIMessage({ action = "hud", visible = false })
		return
	end

	local State = BCC_BuildHudState(Session)
	SendNUIMessage({
		action = "hud",
		visible = true,
		data = State
	})
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE GRAVAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if Session.recording then
			Sleep = 0
			local Now = GetGameTimer()
			Session.elapsed = math.floor((Now - Session.startedAt) / 1000)

			local Drain = Config.Recording.BatteryDrainPerMinute / 60.0
			Session.battery = math.max(0, Session.battery - Drain)

			if Session.battery <= Config.Recording.DeadBatteryThreshold then
				BCC_Notify("negado", Config.Lang.BatteryDead, 5000)
				BCC_StopSession(true)
			elseif Session.battery <= Config.Recording.LowBatteryThreshold and not Session.lowBatteryWarned then
				Session.lowBatteryWarned = true
				BCC_PlaySound("LowBattery")
				BCC_Notify("important", string.format(Config.Lang.LowBattery, math.floor(Session.battery)), 5000)
			end

			if Session.elapsed >= Config.Recording.MaxDuration then
				BCC_Notify("important", Config.Lang.MaxDuration, 5000)
				BCC_StopSession(true)
			else
				BCC_DrawHud(BCC_BuildHudState(Session))
				BCC_DetectEvents()
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DETECÇÃO DE EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
function BCC_DetectEvents()
	local Ped = PlayerPedId()
	local Events = Config.Events

	if Events.WeaponDrawn then
		local Weapon = GetSelectedPedWeapon(Ped)
		if Weapon ~= Session.lastWeapon then
			Session.lastWeapon = Weapon
			if Weapon ~= `WEAPON_UNARMED` then
				BCC_LogEvent("weapon_drawn", string.format(Config.Lang.EventWeapon, BCC_GetWeaponLabel(Weapon)), {
					weapon_hash = Weapon
				})
			end
		end
	end

	if Events.WeaponFired then
		if IsPedShooting(Ped) then
			local Now = GetGameTimer()
			if (Now - Session.lastShotTime) > 500 then
				Session.lastShotTime = Now
				local Weapon = GetSelectedPedWeapon(Ped)
				BCC_LogEvent("weapon_fired", string.format(Config.Lang.EventShot, BCC_GetWeaponLabel(Weapon)), {
					weapon_hash = Weapon
				})
			end
		end
	end

	if Events.VehiclePursuit and IsPedInAnyVehicle(Ped, false) then
		local Vehicle = GetVehiclePedIsIn(Ped, false)
		local Speed = GetEntitySpeed(Vehicle) * 3.6
		if Speed >= Config.PursuitMinSpeed then
			local Now = GetGameTimer()
			if not Session.lastPursuit or (Now - Session.lastPursuit) > 10000 then
				Session.lastPursuit = Now
				BCC_LogEvent("pursuit", string.format(Config.Lang.EventPursuit, math.floor(Speed)), {
					speed = Speed
				})
			end
		end
	end

	if Events.SirenOn and IsPedInAnyVehicle(Ped, false) then
		local Vehicle = GetVehiclePedIsIn(Ped, false)
		local SirenOn = IsVehicleSirenOn(Vehicle)
		if SirenOn and not Session.lastSiren then
			Session.lastSiren = true
			BCC_LogEvent("siren", Config.Lang.EventSiren)
		elseif not SirenOn then
			Session.lastSiren = false
		end
	end

	if Events.DamageTaken then
		local Health = GetEntityHealth(Ped)
		if Health < Session.lastDamage and Session.lastDamage > 0 then
			local Damage = Session.lastDamage - Health
			if Damage >= 5 then
				BCC_LogEvent("damage", string.format(Config.Lang.EventDamage, math.floor(Damage)))
			end
		end
		Session.lastDamage = Health
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SNAPSHOT PERIÓDICO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait((Config.Recording.SnapshotInterval or 15) * 1000)

		if Session.recording and Session.sessionId then
			TriggerServerEvent("camera-corporal:Snapshot", Session.sessionId, BCC_GetEventPayload())
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("IsBodycamActive", function()
	return Session.active
end)

exports("IsRecording", function()
	return Session.recording
end)

exports("GetSessionId", function()
	return Session.sessionId
end)
