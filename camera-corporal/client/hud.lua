-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD OVERLAY — ESTILO AXON BODY 3
-----------------------------------------------------------------------------------------------------------------------------------------

local RecVisible = true
local RecLastBlink = 0

function BCC_GetStreetLabel(Coords)
	if not Coords then return "Local desconhecido" end

	local StreetHash, CrossingHash = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
	local Street = GetStreetNameFromHashKey(StreetHash)
	local Crossing = GetStreetNameFromHashKey(CrossingHash)

	if Crossing and Crossing ~= "" then
		return Street .. " / " .. Crossing
	end

	if Street and Street ~= "" then
		return Street
	end

	return "Via não identificada"
end

function BCC_DrawHud(State)
	if not Config.Hud.Enabled or not State.active then return end

	local Hud = Config.Hud
	local Now = GetGameTimer()

	if Hud.ShowRec and (Now - RecLastBlink) >= (Hud.RecBlinkMs or 800) then
		RecVisible = not RecVisible
		RecLastBlink = Now
	end

	if Hud.Vignette then
		BCC_DrawVignette()
	end

	if Hud.Scanlines then
		BCC_DrawScanlines()
	end

	local BaseX = 0.965
	local BaseY = 0.025
	local LineHeight = 0.022

	if Hud.Position == "top-left" then
		BaseX = 0.035
	elseif Hud.Position == "bottom-right" then
		BaseX = 0.965
		BaseY = 0.82
	elseif Hud.Position == "bottom-left" then
		BaseX = 0.035
		BaseY = 0.82
	end

	local Line = 0

	if Hud.ShowRec then
		local RecColor = RecVisible and { 220, 40, 40, 255 } or { 220, 40, 40, 80 }
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "● REC", 0.38, RecColor, true)
		Line = Line + 1
	end

	if Hud.ShowSessionId and State.sessionId then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), State.sessionId, 0.28, { 200, 200, 200, 200 }, true)
		Line = Line + 1
	end

	if Hud.ShowTimestamp then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), State.timestamp or "", 0.30, { 255, 255, 255, 230 }, true)
		Line = Line + 1
	end

	if Hud.ShowOfficer and State.officerName then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "OFICIAL: " .. State.officerName, 0.30, { 255, 255, 255, 220 }, true)
		Line = Line + 1
	end

	if Hud.ShowBadge and State.badge then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "CRACHÁ: " .. State.badge, 0.28, { 180, 210, 255, 210 }, true)
		Line = Line + 1
	end

	if Hud.ShowUnit and State.unit then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "UNIDADE: " .. State.unit, 0.28, { 180, 210, 255, 210 }, true)
		Line = Line + 1
	end

	if Hud.ShowGps and State.gps then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), State.gps, 0.26, { 160, 200, 160, 200 }, true)
		Line = Line + 1
	end

	if Hud.ShowSpeed and State.speed then
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "VEL: " .. State.speed .. " km/h", 0.28, { 255, 220, 120, 220 }, true)
		Line = Line + 1
	end

	if Hud.ShowBattery and State.battery then
		local Battery = State.battery
		local Color = { 80, 220, 120, 220 }
		if Battery <= Config.Recording.LowBatteryThreshold then
			Color = { 255, 80, 80, 230 }
		elseif Battery <= 40 then
			Color = { 255, 180, 60, 220 }
		end
		BCC_DrawText(BaseX, BaseY + (Line * LineHeight), "BAT: " .. math.floor(Battery) .. "%", 0.28, Color, true)
	end

	BCC_DrawWatermark()
end

function BCC_DrawText(X, Y, Text, Scale, Color, RightAlign)
	SetTextFont(4)
	SetTextScale(Scale, Scale)
	SetTextColour(Color[1], Color[2], Color[3], Color[4])
	SetTextOutline()
	SetTextDropShadow()
	SetTextProportional(true)

	if RightAlign then
		SetTextRightJustify(true)
		SetTextWrap(0.0, X)
	end

	SetTextEntry("STRING")
	AddTextComponentString(Text)
	DrawText(X, Y)
end

function BCC_DrawVignette()
	DrawRect(0.5, 0.02, 1.0, 0.04, 0, 0, 0, 60)
	DrawRect(0.5, 0.98, 1.0, 0.04, 0, 0, 0, 60)
	DrawRect(0.02, 0.5, 0.04, 1.0, 0, 0, 0, 40)
	DrawRect(0.98, 0.5, 0.04, 1.0, 0, 0, 0, 40)
end

function BCC_DrawScanlines()
	for i = 0, 18 do
		local Y = 0.05 + (i * 0.05)
		DrawRect(0.5, Y, 1.0, 0.001, 0, 0, 0, 12)
	end
end

function BCC_DrawWatermark()
	BCC_DrawText(0.035, 0.965, "AXON BODY 3 — CREATIVE UNCHARTED", 0.22, { 255, 255, 255, 80 }, false)
end

function BCC_BuildHudState(Session)
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Speed = 0.0

	if IsPedInAnyVehicle(Ped, false) then
		local Vehicle = GetVehiclePedIsIn(Ped, false)
		Speed = GetEntitySpeed(Vehicle) * 3.6
	end

	return {
		active = Session.active,
		recording = Session.recording,
		sessionId = Session.sessionId,
		timestamp = os.date("%d/%m/%Y %H:%M:%S"),
		officerName = Session.officerName,
		badge = Session.badge,
		unit = Session.unit,
		gps = BCC_CoordsToString(Coords),
		street = BCC_GetStreetLabel(Coords),
		speed = math.floor(Speed),
		battery = Session.battery,
		elapsed = Session.elapsed or 0
	}
end
