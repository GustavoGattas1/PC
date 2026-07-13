-----------------------------------------------------------------------------------------------------------------------------------------
-- AO VIVO — SINCRONIZAÇÃO E MONITORAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------

local Watchers = {}

function BCC_CanWatchLive(Passport)
	if not Passport then return false end
	if BCC_IsSupervisor(Passport) then return true end
	return Config.LiveView.AllowOfficersWatchPeers and BCC_HasPermission(Passport)
end

function BCC_BuildLiveOfficer(Passport, Session)
	local Telemetry = Session.telemetry or {}
	local OfficerName = Session.officerName or BCC_Bridge_GetPlayerName(Passport)

	return {
		passport = Passport,
		source = Session.source,
		sessionId = Session.sessionId,
		officerName = OfficerName,
		unit = Session.unit or BCC_Bridge_GetUnit(Passport),
		badge = Session.badge or BCC_Bridge_GetBadge(Passport),
		elapsed = Telemetry.elapsed or 0,
		battery = Telemetry.battery or 100,
		speed = Telemetry.speed or 0,
		street = Telemetry.street or "—",
		coords = Telemetry.coords or "0, 0, 0",
		health = Telemetry.health or 100,
		armor = Telemetry.armor or 0,
		weapon = Telemetry.weapon or "Desarmado",
		inVehicle = Telemetry.inVehicle == true,
		watchers = Watchers[Passport] or 0
	}
end

function BCC_GetLiveOfficersList()
	local List = {}

	for Passport, Session in pairs(ActiveSessions) do
		if Session and Session.sessionId then
			List[#List + 1] = BCC_BuildLiveOfficer(Passport, Session)
		end
	end

	table.sort(List, function(A, B)
		return (A.officerName or "") < (B.officerName or "")
	end)

	return List
end

function BCC.AddWatcher(TargetPassport, ViewerPassport)
	if not Watchers[TargetPassport] then
		Watchers[TargetPassport] = 0
	end
	Watchers[TargetPassport] = Watchers[TargetPassport] + 1
end

function BCC.RemoveWatcher(TargetPassport)
	if not Watchers[TargetPassport] then return end
	Watchers[TargetPassport] = math.max(0, Watchers[TargetPassport] - 1)
	if Watchers[TargetPassport] == 0 then
		Watchers[TargetPassport] = nil
	end
end

function BCC.OpenDispatch()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_HasPermission(Passport) then
		return { success = false, message = Config.Lang.ReviewDenied }
	end

	local AllAccess = BCC_IsSupervisor(Passport)
	local CanWatch = BCC_CanWatchLive(Passport)
	local Rows = BCC_DB_GetSessions(Passport, 80, AllAccess)
	local Sessions = {}

	for _, Row in ipairs(Rows) do
		Sessions[#Sessions + 1] = BCC_DB_FormatSession(Row)
	end

	return {
		success = true,
		mode = "dispatch",
		live = CanWatch and BCC_GetLiveOfficersList() or {},
		sessions = Sessions,
		supervisor = AllAccess,
		canWatch = CanWatch,
		officerName = BCC_Bridge_GetPlayerName(Passport),
		passport = Passport
	}
end

function BCC.GetLiveOfficers()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_CanWatchLive(Passport) then
		return { success = false, officers = {} }
	end

	return {
		success = true,
		officers = BCC_GetLiveOfficersList()
	}
end

function BCC.StartWatch(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_CanWatchLive(Passport) then
		return { success = false, message = Config.Lang.DispatchDenied }
	end

	TargetSource = tonumber(TargetSource)
	if not TargetSource or TargetSource == Source then
		return { success = false, message = Config.Lang.OfficerOffline }
	end

	local TargetPassport = vRP.Passport(TargetSource)
	if not TargetPassport or not ActiveSessions[TargetPassport] then
		return { success = false, message = Config.Lang.OfficerOffline }
	end

	local Session = ActiveSessions[TargetPassport]
	BCC.AddWatcher(TargetPassport, Passport)

	if Config.LiveView.NotifyOfficer then
		local ViewerName = BCC_Bridge_GetPlayerName(Passport)
		BCC_NotifyServer(TargetSource, "info", string.format(Config.Lang.LiveWatched, ViewerName), 6000)
	end

	return {
		success = true,
		target = BCC_BuildLiveOfficer(TargetPassport, Session)
	}
end

function BCC.StopWatch(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return { success = false } end

	TargetSource = tonumber(TargetSource)
	if TargetSource then
		local TargetPassport = vRP.Passport(TargetSource)
		if TargetPassport then
			BCC_RemoveWatcher(TargetPassport)
		end
	end

	return { success = true }
end

RegisterNetEvent("camera-corporal:UpdateTelemetry")
AddEventHandler("camera-corporal:UpdateTelemetry", function(Payload)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not ActiveSessions[Passport] then return end

	local Session = ActiveSessions[Passport]
	Session.telemetry = Payload or {}
	Session.officerName = Session.officerName or Payload.officerName
	Session.unit = Session.unit or Payload.unit
	Session.badge = Session.badge or Payload.badge
end)
