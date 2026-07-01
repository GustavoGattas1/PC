-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS 3D, OVERLAY, MARCADORES E FITA POLICIAL
-----------------------------------------------------------------------------------------------------------------------------------------
EvidenceProps = {}
MarkerProps = {}
TapeProps = {}
SceneOverlayActive = false
SceneMarkers = {}
SceneTape = {}
SceneEvidenceIndex = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR MODELO
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadModel(Model)
	if not Model or Model == 0 then return false end
	if not IsModelValid(Model) then return false end

	RequestModel(Model)
	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Model) do
		if GetGameTimer() > Timeout then return false end
		Wait(10)
	end
	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN PROP DE EVIDÊNCIA
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnEvidenceProp(Evidence)
	if not Config.SceneOverlay.ShowProps then return end
	if not Evidence or not Evidence.coords or EvidenceProps[Evidence.id] then return end

	local PropConfig = Config.Props[Evidence.type]
	if Evidence.metadata and Evidence.metadata.prop_model then
		PropConfig = { Model = Evidence.metadata.prop_model, Scale = 1.0 }
	end
	if not PropConfig or not PropConfig.Model then return end
	if not LoadModel(PropConfig.Model) then return end

	local Coords = Evidence.coords
	local Obj = CreateObject(PropConfig.Model, Coords.x, Coords.y, Coords.z, false, false, false)
	if not DoesEntityExist(Obj) then return end

	SetEntityAsMissionEntity(Obj, true, true)
	PlaceObjectOnGroundProperly(Obj)
	FreezeEntityPosition(Obj, true)
	SetEntityCollision(Obj, false, false)

	if Evidence.heading then
		SetEntityHeading(Obj, Evidence.heading + math.random(-25, 25))
	end

	EvidenceProps[Evidence.id] = Obj
	SetModelAsNoLongerNeeded(PropConfig.Model)
end

function RemoveEvidenceProp(EvidenceId)
	local Obj = EvidenceProps[EvidenceId]
	if Obj and DoesEntityExist(Obj) then DeleteEntity(Obj) end
	EvidenceProps[EvidenceId] = nil
end

RegisterNetEvent("iml-evidencias:SyncEvidence")
AddEventHandler("iml-evidencias:SyncEvidence", function(Evidence)
	if Evidence and Evidence.id and Evidence.coords then
		SpawnEvidenceProp(Evidence)
	end
end)

RegisterNetEvent("iml-evidencias:RemoveEvidence")
AddEventHandler("iml-evidencias:RemoveEvidence", function(EvidenceId)
	RemoveEvidenceProp(EvidenceId)
	SceneEvidenceIndex[EvidenceId] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- OVERLAY DE INVESTIGAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.SceneOverlay.Command or "cena", function()
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end
	SceneOverlayActive = not SceneOverlayActive
	IMLNotify("important", SceneOverlayActive and Config.Lang.OverlayOn or Config.Lang.OverlayOff, 3000)
end)

RegisterKeyMapping(Config.SceneOverlay.Command or "cena", "Overlay de Cena do Crime (IML)", "keyboard", "M")

function HexToRgb(Hex)
	Hex = Hex:gsub("#", "")
	if #Hex ~= 6 then return 200, 30, 30 end
	return tonumber(Hex:sub(1, 2), 16) or 200, tonumber(Hex:sub(3, 4), 16) or 30, tonumber(Hex:sub(5, 6), 16) or 30
end

function DrawFloatingLabel(x, y, z, Icon, Label, Distance, Color)
	local OnScreen, ScreenX, ScreenY = World3dToScreen2d(x, y, z)
	if not OnScreen then return end

	local Scale = math.max(0.28, 0.42 - (Distance * 0.008))
	SetTextScale(Scale, Scale)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextColour(255, 255, 255, 230)
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString((Icon or "•") .. "  " .. Label)
	DrawText(ScreenX, ScreenY)

	if Distance < Config.CollectDistance + 1.0 then
		SetTextScale(Scale * 0.85, Scale * 0.85)
		SetTextColour(255, 220, 80, 220)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString("~y~[E]~w~ Coletar")
		DrawText(ScreenX, ScreenY + 0.022)
	end
end

function DrawSceneHud(Count)
	if not Config.SceneOverlay.ShowHud then return end

	SetTextFont(4)
	SetTextScale(0.38, 0.38)
	SetTextColour(100, 180, 255, 230)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString("~b~MODO INVESTIGAÇÃO~w~  |  " .. Count .. " evidência(s) detectada(s)")
	DrawText(0.015, 0.92)
end

function DrawBallisticsTraces(PedCoords)
	if not SceneOverlayActive or not Config.SceneOverlay.ShowBallisticsTrace then return end

	local Casings = {}
	local Bullets = {}
	local MaxDist = Config.SceneOverlay.TraceDistance or 25.0

	for _, Evidence in pairs(SceneEvidence) do
		if Evidence.coords and not Evidence.collected then
			if Evidence.type == "casing" then
				Casings[#Casings + 1] = Evidence
			elseif Evidence.type == "bullet" or Evidence.type == "bullet_fragment" then
				Bullets[#Bullets + 1] = Evidence
			end
		end
	end

	for _, Casing in ipairs(Casings) do
		local CC = vector3(Casing.coords.x, Casing.coords.y, Casing.coords.z)
		if #(PedCoords - CC) < MaxDist then
			local Closest = nil
			local ClosestDist = MaxDist

			for _, Bullet in ipairs(Bullets) do
				local BC = vector3(Bullet.coords.x, Bullet.coords.y, Bullet.coords.z)
				local Dist = #(CC - BC)
				if Dist < ClosestDist then
					ClosestDist = Dist
					Closest = BC
				end
			end

			if Closest then
				DrawLine(CC.x, CC.y, CC.z + 0.1, Closest.x, Closest.y, Closest.z + 0.1, 255, 200, 50, 180)
			end
		end
	end
end

function RebuildEvidenceIndex()
	SceneEvidenceIndex = {}
	local Num = 0
	for Id, Evidence in pairs(SceneEvidence) do
		if Evidence.coords and not Evidence.collected then
			Num = Num + 1
			SceneEvidenceIndex[Id] = Num
		end
	end
	return Num
end

CreateThread(function()
	while true do
		local Sleep = 1000

		if IsCivil and (SceneOverlayActive or IsFlashlightOut()) then
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local DrawDistance = SceneOverlayActive and (Config.SceneOverlay.DrawDistance or 50.0) or (Config.Flashlight.DrawDistance or 30.0)
			local EvidenceCount = 0
			local Pulse = math.sin(GetGameTimer() / 350.0) * 0.05 + 1.0

			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected then
					local EvCoords = vector3(Evidence.coords.x, Evidence.coords.y, Evidence.coords.z)
					local Distance = #(PedCoords - EvCoords)

					if Distance < DrawDistance then
						Sleep = 0
						EvidenceCount = EvidenceCount + 1
						local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
						local R, G, B = HexToRgb(TypeInfo.Color or "#e74c3c")
						local Index = SceneEvidenceIndex[Id] or EvidenceCount

						if SceneOverlayActive then
							local RingSize = 0.35 * Pulse
							DrawMarker(25, EvCoords.x, EvCoords.y, EvCoords.z + 0.02, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, RingSize, RingSize, 0.08, R, G, B, 120, false, false, 2, false, nil, nil, false)
							DrawMarker(32, EvCoords.x, EvCoords.y, EvCoords.z + 0.55, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, R, G, B, 200, true, false, 2, true, nil, nil, false)
							DrawLightWithRange(EvCoords.x, EvCoords.y, EvCoords.z + 0.3, R, G, B, 2.0, 0.3)
							DrawFloatingLabel(EvCoords.x, EvCoords.y, EvCoords.z + 0.65, TypeInfo.Icon, "#" .. Index .. " " .. (TypeInfo.Label or "Evidência"), Distance)
						else
							DrawMarker(28, EvCoords.x, EvCoords.y, EvCoords.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, R, G, B, 140, false, false, 2, false, nil, nil, false)
						end

						if Distance < Config.CollectDistance and IsFlashlightOut() and not Collecting and not NuiOpen then
							if not SceneOverlayActive then
								DrawText3D(EvCoords.x, EvCoords.y, EvCoords.z + 0.45, (TypeInfo.Icon or "📋") .. " ~y~[E]~w~ " .. (TypeInfo.Label or "Evidência"))
							end

							if IsControlJustPressed(0, 38) and StartEvidenceCollection then
								StartEvidenceCollection(Id, Evidence)
							end
						end
					end
				end
			end

			if SceneOverlayActive then
				RebuildEvidenceIndex()
				DrawSceneHud(EvidenceCount)
				DrawBallisticsTraces(PedCoords)
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCADORES NUMERADOS (PROP 3D)
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnMarkerProp(Marker)
	if not Marker or not Marker.coords or MarkerProps[Marker.id] then return end
	local Model = Config.SceneProps and Config.SceneProps.Marker or `prop_roadcone02a`
	if not LoadModel(Model) then return end

	local C = Marker.coords
	local Obj = CreateObject(Model, C.x, C.y, C.z, false, false, false)
	if DoesEntityExist(Obj) then
		PlaceObjectOnGroundProperly(Obj)
		FreezeEntityPosition(Obj, true)
		SetEntityCollision(Obj, false, false)
		MarkerProps[Marker.id] = Obj
	end
	SetModelAsNoLongerNeeded(Model)
end

RegisterNetEvent("iml-evidencias:SyncMarker")
AddEventHandler("iml-evidencias:SyncMarker", function(Marker)
	if Marker and Marker.id then
		SceneMarkers[Marker.id] = Marker
		SpawnMarkerProp(Marker)
	end
end)

RegisterNetEvent("iml-evidencias:RemoveMarker")
AddEventHandler("iml-evidencias:RemoveMarker", function(MarkerId)
	SceneMarkers[MarkerId] = nil
	local Obj = MarkerProps[MarkerId]
	if Obj and DoesEntityExist(Obj) then DeleteEntity(Obj) end
	MarkerProps[MarkerId] = nil
end)

RegisterNetEvent("iml-evidencias:PlaceMarker")
AddEventHandler("iml-evidencias:PlaceMarker", function()
	if not IsCivil then return end
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	TriggerServerEvent("iml-evidencias:PlaceMarker", { x = Coords.x, y = Coords.y, z = Coords.z - 0.95 })
end)

CreateThread(function()
	while true do
		local Sleep = 1000
		if IsCivil then
			local PedCoords = GetEntityCoords(PlayerPedId())
			for _, Marker in pairs(SceneMarkers) do
				if Marker.coords then
					local MCoords = vector3(Marker.coords.x, Marker.coords.y, Marker.coords.z)
					if #(PedCoords - MCoords) < 40.0 then
						Sleep = 0
						DrawText3D(MCoords.x, MCoords.y, MCoords.z + 0.55, "~y~EVIDÊNCIA #" .. (Marker.number or "?"))
					end
				end
			end
		end
		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FITA POLICIAL (PROP 3D)
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnTapeProp(Segment)
	if not Segment or not Segment.start or TapeProps[Segment.id] then return end
	local Model = Config.SceneProps and Config.SceneProps.Tape or `prop_barrier_work06`
	if not LoadModel(Model) then return end

	local Mid = vector3(
		(Segment.start.x + Segment.finish.x) / 2,
		(Segment.start.y + Segment.finish.y) / 2,
		(Segment.start.z + Segment.finish.z) / 2
	)

	local Obj = CreateObject(Model, Mid.x, Mid.y, Mid.z, false, false, false)
	if DoesEntityExist(Obj) then
		local Heading = math.deg(math.atan(Segment.finish.x - Segment.start.x, Segment.finish.y - Segment.start.y))
		SetEntityHeading(Obj, Heading)
		PlaceObjectOnGroundProperly(Obj)
		FreezeEntityPosition(Obj, true)
		SetEntityCollision(Obj, false, false)
		TapeProps[Segment.id] = Obj
	end
	SetModelAsNoLongerNeeded(Model)
end

RegisterNetEvent("iml-evidencias:PlaceTape")
AddEventHandler("iml-evidencias:PlaceTape", function()
	if not IsCivil then return end
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	TriggerServerEvent("iml-evidencias:PlaceTape", { x = Coords.x, y = Coords.y, z = Coords.z }, GetEntityHeading(Ped))
end)

RegisterNetEvent("iml-evidencias:SyncTape")
AddEventHandler("iml-evidencias:SyncTape", function(Segment)
	if Segment and Segment.id then
		SceneTape[Segment.id] = Segment
		SpawnTapeProp(Segment)
	end
end)

CreateThread(function()
	while true do
		local Sleep = 1000
		if IsCivil then
			local PedCoords = GetEntityCoords(PlayerPedId())
			for _, Segment in pairs(SceneTape) do
				if Segment.start and Segment.finish then
					local Mid = vector3(
						(Segment.start.x + Segment.finish.x) / 2,
						(Segment.start.y + Segment.finish.y) / 2,
						(Segment.start.z + Segment.finish.z) / 2
					)
					if #(PedCoords - Mid) < 50.0 then
						Sleep = 0
						DrawLine(Segment.start.x, Segment.start.y, Segment.start.z + 0.5, Segment.finish.x, Segment.finish.y, Segment.finish.z + 0.5, 255, 220, 0, 160)
					end
				end
			end
		end
		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS AO CARREGAR CENA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(3000)
		if IsCivil then
			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected and not EvidenceProps[Id] then
					SpawnEvidenceProp(Evidence)
				end
			end
			for Id, Marker in pairs(SceneMarkers) do
				if not MarkerProps[Id] then SpawnMarkerProp(Marker) end
			end
			for Id, Segment in pairs(SceneTape) do
				if not TapeProps[Id] then SpawnTapeProp(Segment) end
			end
		else
			for Id in pairs(EvidenceProps) do RemoveEvidenceProp(Id) end
			for Id, Obj in pairs(MarkerProps) do
				if DoesEntityExist(Obj) then DeleteEntity(Obj) end
				MarkerProps[Id] = nil
			end
			for Id, Obj in pairs(TapeProps) do
				if DoesEntityExist(Obj) then DeleteEntity(Obj) end
				TapeProps[Id] = nil
			end
		end
	end
end)
