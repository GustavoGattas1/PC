-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET FORENSE E SCANNER GSR (estilo Pluto Dev)
-----------------------------------------------------------------------------------------------------------------------------------------
local TabletProp = nil

function AttachTabletProp()
	local Ped = PlayerPedId()
	local Model = Config.Tablet and Config.Tablet.Prop or `prop_cs_tablet`

	if LoadModel and LoadModel(Model) then
		local Bone = GetPedBoneIndex(Ped, 28422)
		TabletProp = CreateObject(Model, 0.0, 0.0, 0.0, true, true, false)
		AttachEntityToEntity(TabletProp, Ped, Bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(Model)
	end

	local Dict = Config.Tablet and Config.Tablet.AnimDict
	local Anim = Config.Tablet and Config.Tablet.AnimName
	if Dict and Anim and LoadAnimDict and LoadAnimDict(Dict) then
		TaskPlayAnim(Ped, Dict, Anim, 8.0, -8.0, -1, 49, 0, false, false, false)
	end
end

function RemoveTabletProp()
	local Ped = PlayerPedId()
	if TabletProp and DoesEntityExist(TabletProp) then
		DeleteEntity(TabletProp)
	end
	TabletProp = nil
	ClearPedSecondaryTask(Ped)
end

function BuildLocalSceneScan()
	local PedCoords = GetEntityCoords(PlayerPedId())
	local List = {}

	for Id, Evidence in pairs(SceneEvidence or {}) do
		if Evidence.coords and not Evidence.collected then
			local EvCoords = vector3(Evidence.coords.x, Evidence.coords.y, Evidence.coords.z)
			local Dist = #(PedCoords - EvCoords)
			if Dist < (Config.SceneOverlay.DrawDistance or 50.0) then
				local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
				List[#List + 1] = {
					id = Id,
					type = Evidence.type,
					label = TypeInfo.Label or Evidence.type,
					icon = TypeInfo.Icon or "📋",
					color = TypeInfo.Color or "#e74c3c",
					distance = RoundNumber(Dist, 1),
					caliber = Evidence.metadata and Evidence.metadata.caliber
				}
			end
		end
	end

	table.sort(List, function(A, B) return A.distance < B.distance end)
	return List
end

function closeTablet(cb)
	SetNuiFocus(false, false)
	NuiOpen = false
	RemoveTabletProp()
	cb("ok")
end

RegisterNetEvent("iml-evidencias:OpenTablet")
AddEventHandler("iml-evidencias:OpenTablet", function()
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end

	AttachTabletProp()

	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({
		action = "openTablet",
		evidence = vSERVER.GetMyEvidence(),
		cases = vSERVER.GetCases(),
		reports = vSERVER.GetMyReports(),
		scene = BuildLocalSceneScan(),
		overlay = SceneOverlayActive
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

	SendNUIMessage({ action = "startGsrScan" })
	TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)
	Wait(2500)
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
	if Data then
		TriggerServerEvent("iml-evidencias:ArchiveCase", Data.case_id, Data.title, Data.notes)
	end
	cb("ok")
end)

RegisterNUICallback("printReport", function(Data, cb)
	TriggerServerEvent("iml-evidencias:PrintReport", Data and Data.report_id)
	SetNuiFocus(false, false)
	NuiOpen = false
	RemoveTabletProp()
	cb("ok")
end)

RegisterNUICallback("toggleOverlay", function(_, cb)
	SceneOverlayActive = not SceneOverlayActive
	IMLNotify("important", SceneOverlayActive and Config.Lang.OverlayOn or Config.Lang.OverlayOff, 3000)
	cb("ok")
end)

RegisterNUICallback("placeMarker", function(_, cb)
	TriggerEvent("iml-evidencias:PlaceMarker")
	closeTablet(cb)
end)

RegisterNUICallback("placeTape", function(_, cb)
	TriggerEvent("iml-evidencias:PlaceTape")
	closeTablet(cb)
end)

RegisterNUICallback("scanNearbyGsr", function(_, cb)
	closeTablet(cb)
	TriggerEvent("iml-evidencias:OpenGsrScanner")
end)

RegisterNUICallback("refreshScene", function(_, cb)
	SendNUIMessage({ action = "updateScene", scene = BuildLocalSceneScan() })
	cb("ok")
end)
