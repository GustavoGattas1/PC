-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANCO DE DADOS
-----------------------------------------------------------------------------------------------------------------------------------------

vRP.Prepare("bcc/CreateSession", [[
	INSERT INTO bcc_sessions (session_id, passport, officer_name, unit, badge, started_at, battery_start, status, metadata)
	VALUES (@session_id, @passport, @officer_name, @unit, @badge, NOW(), @battery_start, 'active', @metadata)
]])

vRP.Prepare("bcc/EndSession", [[
	UPDATE bcc_sessions
	SET ended_at = NOW(),
		duration = @duration,
		event_count = @event_count,
		bookmark_count = @bookmark_count,
		battery_end = @battery_end,
		status = 'completed'
	WHERE session_id = @session_id AND passport = @passport
]])

vRP.Prepare("bcc/InsertEvent", [[
	INSERT INTO bcc_events (session_id, event_type, label, coords, street, speed, weapon_hash, metadata, elapsed)
	VALUES (@session_id, @event_type, @label, @coords, @street, @speed, @weapon_hash, @metadata, @elapsed)
]])

vRP.Prepare("bcc/InsertBookmark", [[
	INSERT INTO bcc_bookmarks (bookmark_id, session_id, passport, label, coords, street, elapsed)
	VALUES (@bookmark_id, @session_id, @passport, @label, @coords, @street, @elapsed)
]])

vRP.Prepare("bcc/GetSessionsByPassport", [[
	SELECT * FROM bcc_sessions
	WHERE passport = @passport
	ORDER BY started_at DESC
	LIMIT @limit
]])

vRP.Prepare("bcc/GetAllSessions", [[
	SELECT * FROM bcc_sessions
	ORDER BY started_at DESC
	LIMIT @limit
]])

vRP.Prepare("bcc/SearchSessions", [[
	SELECT * FROM bcc_sessions
	WHERE officer_name LIKE @query OR session_id LIKE @query OR unit LIKE @query OR badge LIKE @query
	ORDER BY started_at DESC
	LIMIT @limit
]])

vRP.Prepare("bcc/GetSession", [[
	SELECT * FROM bcc_sessions WHERE session_id = @session_id LIMIT 1
]])

vRP.Prepare("bcc/GetSessionEvents", [[
	SELECT * FROM bcc_events WHERE session_id = @session_id ORDER BY elapsed ASC, id ASC
]])

vRP.Prepare("bcc/GetSessionBookmarks", [[
	SELECT * FROM bcc_bookmarks WHERE session_id = @session_id ORDER BY elapsed ASC, id ASC
]])

vRP.Prepare("bcc/DeleteSession", [[
	DELETE FROM bcc_sessions WHERE session_id = @session_id
]])

vRP.Prepare("bcc/DeleteSessionEvents", [[
	DELETE FROM bcc_events WHERE session_id = @session_id
]])

vRP.Prepare("bcc/DeleteSessionBookmarks", [[
	DELETE FROM bcc_bookmarks WHERE session_id = @session_id
]])

vRP.Prepare("bcc/GetActiveSession", [[
	SELECT * FROM bcc_sessions WHERE passport = @passport AND status = 'active' LIMIT 1
]])

function BCC_DB_CreateSession(Data)
	vRP.Query("bcc/CreateSession", {
		session_id = Data.session_id,
		passport = Data.passport,
		officer_name = Data.officer_name,
		unit = Data.unit,
		badge = Data.badge,
		battery_start = Data.battery_start or 100,
		metadata = BCC_Encode(Data.metadata or {})
	})
end

function BCC_DB_EndSession(SessionId, Passport, Summary)
	vRP.Query("bcc/EndSession", {
		session_id = SessionId,
		passport = Passport,
		duration = Summary.elapsed or 0,
		event_count = Summary.events or 0,
		bookmark_count = Summary.bookmarks or 0,
		battery_end = Summary.battery or 0
	})
end

function BCC_DB_InsertEvent(SessionId, EventType, Label, Payload)
	local Coords = Payload.coords or {}
	vRP.Query("bcc/InsertEvent", {
		session_id = SessionId,
		event_type = EventType,
		label = Label,
		coords = BCC_CoordsToString(Coords),
		street = Payload.street or "",
		speed = Payload.speed,
		weapon_hash = Payload.weapon_hash or Payload.weapon,
		metadata = BCC_Encode(Payload),
		elapsed = Payload.elapsed or 0
	})
end

function BCC_DB_InsertBookmark(SessionId, Passport, Payload)
	vRP.Query("bcc/InsertBookmark", {
		bookmark_id = BCC_GenerateBookmarkId(),
		session_id = SessionId,
		passport = Passport,
		label = Payload.label or "Incidente marcado",
		coords = BCC_CoordsToString(Payload.coords),
		street = Payload.street or "",
		elapsed = Payload.elapsed or 0
	})
end

function BCC_DB_GetSessions(Passport, Limit, AllAccess)
	if AllAccess then
		return vRP.Query("bcc/GetAllSessions", { limit = Limit or 50 }) or {}
	end
	return vRP.Query("bcc/GetSessionsByPassport", { passport = Passport, limit = Limit or 50 }) or {}
end

function BCC_DB_SearchSessions(Query, Limit)
	return vRP.Query("bcc/SearchSessions", {
		query = "%" .. tostring(Query) .. "%",
		limit = Limit or 50
	}) or {}
end

function BCC_DB_GetSessionDetails(SessionId)
	local Session = vRP.Query("bcc/GetSession", { session_id = SessionId })
	if not Session or not Session[1] then return nil end

	return {
		session = Session[1],
		events = vRP.Query("bcc/GetSessionEvents", { session_id = SessionId }) or {},
		bookmarks = vRP.Query("bcc/GetSessionBookmarks", { session_id = SessionId }) or {}
	}
end

function BCC_DB_DeleteSession(SessionId)
	vRP.Query("bcc/DeleteSessionEvents", { session_id = SessionId })
	vRP.Query("bcc/DeleteSessionBookmarks", { session_id = SessionId })
	vRP.Query("bcc/DeleteSession", { session_id = SessionId })
end

function BCC_DB_GetActiveSession(Passport)
	local Result = vRP.Query("bcc/GetActiveSession", { passport = Passport })
	if Result and Result[1] then return Result[1] end
	return nil
end

function BCC_DB_FormatSession(Row)
	if not Row then return nil end

	return {
		sessionId = Row.session_id,
		passport = Row.passport,
		officerName = Row.officer_name,
		unit = Row.unit,
		badge = Row.badge,
		startedAt = Row.started_at,
		endedAt = Row.ended_at,
		duration = Row.duration or 0,
		durationLabel = BCC_FormatDuration(Row.duration or 0),
		eventCount = Row.event_count or 0,
		bookmarkCount = Row.bookmark_count or 0,
		batteryStart = Row.battery_start,
		batteryEnd = Row.battery_end,
		status = Row.status
	}
end
