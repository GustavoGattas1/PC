-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
BCC = {}
Tunnel.bindInterface("camera-corporal", BCC)
vCLIENT = Tunnel.getInterface("camera-corporal")

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------------------------------------------------------------------------------
ActiveSessions = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function BCC_HasPermission(Passport)
	return BCC_HasGroup(Passport, Config.Groups)
end

function BCC_CanReview(Passport, TargetPassport)
	if not Passport then return false end
	if Passport == TargetPassport then return true end
	return BCC_IsSupervisor(Passport)
end

function BCC_IsOnService(Passport)
	if not Config.RequireService then return true end

	for _, Group in ipairs(Config.Groups) do
		if vRP.HasService(Passport, Group) then
			return true
		end
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function BCC.CheckPermission()
	local Source = source
	local Passport = vRP.Passport(Source)
	return Passport and BCC_HasPermission(Passport) or false
end

function BCC.CheckService()
	local Source = source
	local Passport = vRP.Passport(Source)
	return Passport and BCC_IsOnService(Passport) or false
end

function BCC.HasItem()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Config.Item then return true end
	if not Passport then return false end

	local Amount = vRP.InventoryItemAmount(Passport, Config.Item)
	return Amount and Amount[1] and Amount[1] > 0
end

function BCC.StartSession()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_HasPermission(Passport) then
		return { success = false, message = Config.Lang.NotAuthorized }
	end

	if Config.RequireService and not BCC_IsOnService(Passport) then
		return { success = false, message = Config.Lang.NeedService }
	end

	if Config.Item then
		local Amount = vRP.InventoryItemAmount(Passport, Config.Item)
		if not Amount or not Amount[1] or Amount[1] <= 0 then
			return { success = false, message = Config.Lang.NeedItem }
		end
	end

	if ActiveSessions[Passport] then
		return { success = false, message = Config.Lang.AlreadyOn }
	end

	local SessionId = BCC_GenerateSessionId()
	local OfficerName = BCC_Bridge_GetPlayerName(Passport)
	local Unit = BCC_Bridge_GetUnit(Passport)
	local Badge = BCC_Bridge_GetBadge(Passport)

	BCC_DB_CreateSession({
		session_id = SessionId,
		passport = Passport,
		officer_name = OfficerName,
		unit = Unit,
		badge = Badge,
		battery_start = Config.Recording.FullBatteryOnStart,
		metadata = { source = Source }
	})

	ActiveSessions[Passport] = {
		sessionId = SessionId,
		source = Source,
		startedAt = os.time(),
		officerName = OfficerName,
		unit = Unit,
		badge = Badge,
		telemetry = {}
	}

	return {
		success = true,
		sessionId = SessionId,
		passport = Passport,
		officerName = OfficerName,
		unit = Unit,
		badge = Badge
	}
end

function BCC.OpenReview()
	return BCC.OpenDispatch()
end

function BCC.GetSessionDetails(SessionId)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_HasPermission(Passport) then
		return { success = false }
	end

	local Details = BCC_DB_GetSessionDetails(SessionId)
	if not Details then
		return { success = false, message = "Sessão não encontrada." }
	end

	local SessionPassport = Details.session.passport
	if not BCC_CanReview(Passport, SessionPassport) then
		return { success = false, message = Config.Lang.ReviewDenied }
	end

	local Events = {}
	for _, Event in ipairs(Details.events) do
		Events[#Events + 1] = {
			type = Event.event_type,
			label = Event.label,
			coords = Event.coords,
			street = Event.street,
			speed = Event.speed,
			elapsed = Event.elapsed,
			timestamp = Event.created_at,
			metadata = Event.metadata
		}
	end

	local Bookmarks = {}
	for _, Bookmark in ipairs(Details.bookmarks) do
		Bookmarks[#Bookmarks + 1] = {
			id = Bookmark.bookmark_id,
			label = Bookmark.label,
			coords = Bookmark.coords,
			street = Bookmark.street,
			elapsed = Bookmark.elapsed,
			timestamp = Bookmark.created_at
		}
	end

	return {
		success = true,
		session = BCC_DB_FormatSession(Details.session),
		events = Events,
		bookmarks = Bookmarks
	}
end

function BCC.SearchSessions(Query, Filter)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_HasPermission(Passport) then
		return { sessions = {} }
	end

	local Rows
	if BCC_IsSupervisor(Passport) and Query ~= "" then
		Rows = BCC_DB_SearchSessions(Query, 50)
	else
		Rows = BCC_DB_GetSessions(Passport, 50, false)
	end

	local Sessions = {}
	for _, Row in ipairs(Rows) do
		if Filter == "bookmarked" and (Row.bookmark_count or 0) <= 0 then
			goto continue
		end
		if Filter == "long" and (Row.duration or 0) < 300 then
			goto continue
		end

		Sessions[#Sessions + 1] = BCC_DB_FormatSession(Row)
		::continue::
	end

	return { sessions = Sessions }
end

function BCC.DeleteSession(SessionId)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_IsSupervisor(Passport) then
		return { success = false, message = Config.Lang.ReviewDenied }
	end

	BCC_DB_DeleteSession(SessionId)
	return { success = true }
end

function BCC.ExportSession(SessionId)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not BCC_HasPermission(Passport) then
		return { success = false }
	end

	local Details = BCC_DB_GetSessionDetails(SessionId)
	if not Details then
		return { success = false, message = "Sessão não encontrada." }
	end

	if not BCC_CanReview(Passport, Details.session.passport) then
		return { success = false, message = Config.Lang.ReviewDenied }
	end

	local Lines = {
		"═══════════════════════════════════════",
		"RELATÓRIO DE CÂMERA CORPORAL",
		"Creative Uncharted — Bodycam Forensics",
		"═══════════════════════════════════════",
		"",
		"Sessão: " .. Details.session.session_id,
		"Oficial: " .. Details.session.officer_name,
		"Crachá: " .. (Details.session.badge or "N/A"),
		"Unidade: " .. (Details.session.unit or "N/A"),
		"Início: " .. tostring(Details.session.started_at),
		"Fim: " .. tostring(Details.session.ended_at or "Em andamento"),
		"Duração: " .. BCC_FormatDuration(Details.session.duration or 0),
		"Eventos: " .. tostring(Details.session.event_count or 0),
		"Marcações: " .. tostring(Details.session.bookmark_count or 0),
		"",
		"── EVENTOS ──"
	}

	for _, Event in ipairs(Details.events) do
		Lines[#Lines + 1] = string.format(
			"[%s] %s — %s (%s)",
			BCC_FormatDuration(Event.elapsed or 0),
			Event.event_type,
			Event.label,
			Event.street or Event.coords or ""
		)
	end

	if #Details.bookmarks > 0 then
		Lines[#Lines + 1] = ""
		Lines[#Lines + 1] = "── MARCAÇÕES ──"
		for _, Bookmark in ipairs(Details.bookmarks) do
			Lines[#Lines + 1] = string.format(
				"[%s] %s — %s",
				BCC_FormatDuration(Bookmark.elapsed or 0),
				Bookmark.label,
				Bookmark.street or Bookmark.coords or ""
			)
		end
	end

	Lines[#Lines + 1] = ""
	Lines[#Lines + 1] = "═══════════════════════════════════════"

	return {
		success = true,
		report = table.concat(Lines, "\n")
	}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("camera-corporal:EndSession")
AddEventHandler("camera-corporal:EndSession", function(SessionId, Summary)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not ActiveSessions[Passport] then return end
	if ActiveSessions[Passport].sessionId ~= SessionId then return end

	BCC_DB_EndSession(SessionId, Passport, Summary or {})
	ActiveSessions[Passport] = nil

	BCC_NotifyServer(Source, "success",
		string.format(Config.Lang.SessionSaved, SessionId, tostring(Summary and Summary.events or 0)),
		5000
	)
end)

RegisterNetEvent("camera-corporal:LogEvent")
AddEventHandler("camera-corporal:LogEvent", function(SessionId, EventType, Label, Payload)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not ActiveSessions[Passport] then return end
	if ActiveSessions[Passport].sessionId ~= SessionId then return end

	BCC_DB_InsertEvent(SessionId, EventType, Label, Payload or {})
end)

RegisterNetEvent("camera-corporal:AddBookmark")
AddEventHandler("camera-corporal:AddBookmark", function(SessionId, Payload)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not ActiveSessions[Passport] then return end
	if ActiveSessions[Passport].sessionId ~= SessionId then return end

	BCC_DB_InsertBookmark(SessionId, Passport, Payload or {})
end)

RegisterNetEvent("camera-corporal:Snapshot")
AddEventHandler("camera-corporal:Snapshot", function(SessionId, Payload)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not ActiveSessions[Passport] then return end
	if ActiveSessions[Passport].sessionId ~= SessionId then return end

	BCC_DB_InsertEvent(SessionId, "snapshot", "Posição registrada", Payload or {})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS SERVIDOR
-----------------------------------------------------------------------------------------------------------------------------------------
local function RegisterBccCommand(Name)
	RegisterCommand(Name, function(Source)
		local Passport = vRP.Passport(Source)
		if not Passport or not BCC_HasPermission(Passport) then
			BCC_NotifyServer(Source, "negado", Config.Lang.NotAuthorized)
			return
		end

		TriggerClientEvent("camera-corporal:Toggle", Source)
	end, false)
end

RegisterBccCommand(Config.Command)
for _, Alias in ipairs(Config.CommandAliases or {}) do
	RegisterBccCommand(Alias)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function()
	local Source = source
	for Passport, Session in pairs(ActiveSessions) do
		if Session.source == Source then
			BCC_DB_EndSession(Session.sessionId, Passport, {
				elapsed = os.time() - Session.startedAt,
				events = 0,
				bookmarks = 0,
				battery = 0
			})
			ActiveSessions[Passport] = nil
			break
		end
	end
end)

AddEventHandler("Disconnect", function(Passport, Source)
	if Passport and ActiveSessions[Passport] then
		local Session = ActiveSessions[Passport]
		BCC_DB_EndSession(Session.sessionId, Passport, {
			elapsed = os.time() - Session.startedAt,
			events = 0,
			bookmarks = 0,
			battery = 0
		})
		ActiveSessions[Passport] = nil
	end
	BCC_Bridge_ClearCache(Passport)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("IsRecording", function(Source)
	local Passport = vRP.Passport(Source)
	return Passport and ActiveSessions[Passport] ~= nil
end)

exports("GetActiveSession", function(Source)
	local Passport = vRP.Passport(Source)
	if Passport and ActiveSessions[Passport] then
		return ActiveSessions[Passport].sessionId
	end
	return nil
end)

exports("ForceStopRecording", function(Source)
	TriggerClientEvent("camera-corporal:ForceStop", Source)
end)
