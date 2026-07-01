-----------------------------------------------------------------------------------------------------------------------------------------
-- ARQUIVO DE CASOS E MARCADORES
-----------------------------------------------------------------------------------------------------------------------------------------
SceneMarkers = SceneMarkers or {}
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

RegisterNetEvent("iml-evidencias:PlaceMarker")
AddEventHandler("iml-evidencias:PlaceMarker", function(Coords, FromItemUse)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not IML.CanCollect(Passport) then
		if Passport then
			IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		end
		return
	end

	if not IML_ConsumeItem(Passport, Config.Items.EvidenceMarker, FromItemUse == true) then
		IML_Notify(Source, "negado", "Você precisa de um marcador de evidência.")
		return
	end

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
