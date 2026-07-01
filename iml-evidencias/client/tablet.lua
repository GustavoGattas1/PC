-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET FORENSE E SCANNER GSR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:OpenTablet")
AddEventHandler("iml-evidencias:OpenTablet", function()
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end

	local Evidence = vSERVER.GetMyEvidence()
	local Cases = vSERVER.GetCases()
	local Reports = vSERVER.GetMyReports()

	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({
		action = "openTablet",
		evidence = Evidence,
		cases = Cases,
		reports = Reports
	})
end)

RegisterNetEvent("iml-evidencias:OpenGsrScanner")
AddEventHandler("iml-evidencias:OpenGsrScanner", function()
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end

	local Ped = PlayerPedId()
	local PedCoords = GetEntityCoords(Ped)
	local ClosestPlayer = nil
	local ClosestDist = 3.0

	for _, Player in ipairs(GetActivePlayers()) do
		local TargetPed = GetPlayerPed(Player)
		if TargetPed ~= Ped then
			local Dist = #(PedCoords - GetEntityCoords(TargetPed))
			if Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPlayer = GetPlayerServerId(Player)
			end
		end
	end

	if not ClosestPlayer then
		IMLNotify("negado", "Nenhum suspeito próximo para escanear.")
		return
	end

	TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)
	Wait(1500)

	vSERVER.ScanGSR(ClosestPlayer)
	ClearPedTasks(Ped)
end)

RegisterNetEvent("iml-evidencias:GsrScanResult")
AddEventHandler("iml-evidencias:GsrScanResult", function(Result)
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openGsrScanner", result = Result })
end)

RegisterNetEvent("iml-evidencias:OpenBodyDiagram")
AddEventHandler("iml-evidencias:OpenBodyDiagram", function(Exam)
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openBodyDiagram", exam = Exam })
end)

RegisterNetEvent("iml-evidencias:PrintReport")
AddEventHandler("iml-evidencias:PrintReport", function()
	local Ped = PlayerPedId()
	TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
	Wait(3000)
	ClearPedTasks(Ped)
	IMLNotify("success", Config.Lang.ReportPrinted, 4000)
end)

RegisterNUICallback("archiveCase", function(Data, cb)
	if Data and Data.case_id then
		TriggerServerEvent("iml-evidencias:ArchiveCase", Data.case_id, Data.title, Data.notes)
	end
	cb("ok")
end)

RegisterNUICallback("printReport", function(Data, cb)
	TriggerServerEvent("iml-evidencias:PrintReport", Data and Data.report_id)
	SetNuiFocus(false, false)
	NuiOpen = false
	cb("ok")
end)

RegisterNUICallback("toggleOverlay", function(_, cb)
	SceneOverlayActive = not SceneOverlayActive
	IMLNotify("important", SceneOverlayActive and Config.Lang.OverlayOn or Config.Lang.OverlayOff, 3000)
	cb("ok")
end)

RegisterNUICallback("placeMarker", function(_, cb)
	TriggerEvent("iml-evidencias:PlaceMarker")
	cb("ok")
end)

RegisterNUICallback("placeTape", function(_, cb)
	TriggerEvent("iml-evidencias:PlaceTape")
	cb("ok")
end)

RegisterNUICallback("scanNearbyGsr", function(_, cb)
	TriggerEvent("iml-evidencias:OpenGsrScanner")
	cb("ok")
end)
