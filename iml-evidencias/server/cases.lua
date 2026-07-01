-----------------------------------------------------------------------------------------------------------------------------------------
-- ARQUIVO DE CASOS, MARCADORES E FITA
-----------------------------------------------------------------------------------------------------------------------------------------
SceneMarkers = SceneMarkers or {}
SceneTape = SceneTape or {}
MarkerCounter = MarkerCounter or 0

function IML.RequestMarkers()
	local Passport = vRP.Passport(source)
	if not IML.CanCollect(Passport) then return {} end

	local List = {}
	for Id, Marker in pairs(SceneMarkers) do
		List[#List + 1] = Marker
	end
	return List
end

function IML.RequestTape()
	local Passport = vRP.Passport(source)
	if not IML.CanCollect(Passport) then return {} end

	local List = {}
	for Id, Segment in pairs(SceneTape) do
		List[#List + 1] = Segment
	end
	return List
end

function IML.GetCases()
	local Passport = vRP.Passport(source)
	if not IML.CanCollect(Passport) then return {} end
	return vRP.Query("iml/GetCases", {}) or {}
end

function IML.GetMyReports()
	local Passport = vRP.Passport(source)
	if not Passport then return {} end

	local LaudoData = vRP.UserData(Passport, "iml_laudos") or {}
	if type(LaudoData) == "string" then LaudoData = json.decode(LaudoData) or {} end

	local List = {}
	for Id, Data in pairs(LaudoData) do
		Data.report_id = Id
		List[#List + 1] = Data
	end
	return List
end

function IML.ScanGSR(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)
	local TargetPassport = vRP.Passport(TargetSource)
	if not Passport or not TargetPassport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	local GsrData = PlayerGSR[TargetPassport]
	local Positive = GsrData and (os.time() - GsrData.timestamp) <= 1800
	local Identity = IML_GetIdentity(TargetPassport)
	local WeaponName = Positive and GetWeaponLabel(GsrData.weapon_hash) or nil

	local Result = {
		positive = Positive,
		suspect = Identity,
		weapon = WeaponName,
		message = Positive and Config.Lang.GsrPositive or Config.Lang.GsrNegative
	}

	TriggerClientEvent("iml-evidencias:GsrScanResult", Source, Result)
end

RegisterNetEvent("iml-evidencias:PlaceMarker")
AddEventHandler("iml-evidencias:PlaceMarker", function(Coords)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not IML.CanCollect(Passport) then return end

	local Count = 0
	for _ in pairs(SceneMarkers) do Count = Count + 1 end
	if Count >= Config.MaxMarkers then
		IML_Notify(Source, "negado", "Limite de marcadores atingido.")
		return
	end

	MarkerCounter = MarkerCounter + 1
	local MarkerId = IML_GenerateId("MRK")
	local Marker = {
		id = MarkerId,
		number = MarkerCounter,
		coords = Coords,
		placed_by = Passport,
		created = os.time()
	}

	SceneMarkers[MarkerId] = Marker
	IML_BroadcastCivil("iml-evidencias:SyncMarker", Marker)
	IML_Notify(Source, "success", Config.Lang.MarkerPlaced)
end)

RegisterNetEvent("iml-evidencias:PlaceTape")
AddEventHandler("iml-evidencias:PlaceTape", function(Coords, Heading)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not IML.CanCollect(Passport) then return end

	if vRP.ItemAmount(Passport, Config.Items.PoliceTape) < 1 then
		IML_Notify(Source, "negado", "Você precisa de fita policial.")
		return
	end

	local Count = 0
	for _ in pairs(SceneTape) do Count = Count + 1 end
	if Count >= Config.MaxTapeSegments then return end

	vRP.TakeItem(Passport, Config.Items.PoliceTape, 1, true)

	local Rad = math.rad(Heading or 0)
	local Length = 3.5
	local Start = { x = Coords.x, y = Coords.y, z = Coords.z }
	local Finish = {
		x = Coords.x + math.sin(Rad) * Length,
		y = Coords.y + math.cos(Rad) * Length,
		z = Coords.z
	}

	local SegmentId = IML_GenerateId("TAPE")
	local Segment = {
		id = SegmentId,
		start = Start,
		finish = Finish,
		placed_by = Passport,
		created = os.time()
	}

	SceneTape[SegmentId] = Segment
	IML_BroadcastCivil("iml-evidencias:SyncTape", Segment)
	IML_Notify(Source, "success", Config.Lang.TapePlaced)
end)

RegisterNetEvent("iml-evidencias:ArchiveCase")
AddEventHandler("iml-evidencias:ArchiveCase", function(CaseId, Title, Notes)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not IML.CanCollect(Passport) then return end

	local CaseIdFinal = CaseId or IML_GenerateId("CASE")
	vRP.Query("iml/InsertCase", {
		case_id = CaseIdFinal,
		title = Title or "Caso sem título",
		notes = Notes or "",
		author_passport = Passport,
		status = "arquivado"
	})

	IML_Notify(Source, "success", Config.Lang.CaseArchived)
end)

RegisterNetEvent("iml-evidencias:PrintReport")
AddEventHandler("iml-evidencias:PrintReport", function(ReportId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	TriggerClientEvent("iml-evidencias:PrintReport", Source)
end)
