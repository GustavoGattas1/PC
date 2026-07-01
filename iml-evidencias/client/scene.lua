-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS 3D, OVERLAY, MARCADORES E FITA POLICIAL
-----------------------------------------------------------------------------------------------------------------------------------------
EvidenceProps = {}
SceneOverlayActive = false
SceneMarkers = {}
SceneTape = {}
PendingCollectId = nil

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
		SetEntityHeading(Obj, Evidence.heading)
	end

	EvidenceProps[Evidence.id] = Obj
	SetModelAsNoLongerNeeded(PropConfig.Model)
end

function RemoveEvidenceProp(EvidenceId)
	local Obj = EvidenceProps[EvidenceId]
	if Obj and DoesEntityExist(Obj) then
		DeleteEntity(Obj)
	end
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

CreateThread(function()
	while true do
		local Sleep = 1000

		if IsCivil and (SceneOverlayActive or IsFlashlightOut()) then
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local DrawDistance = SceneOverlayActive and (Config.SceneOverlay.DrawDistance or 45.0) or (Config.Flashlight.DrawDistance or 30.0)

			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected then
					local EvCoords = vector3(Evidence.coords.x, Evidence.coords.y, Evidence.coords.z)
					local Distance = #(PedCoords - EvCoords)

					if Distance < DrawDistance then
						Sleep = 0
						local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
						local R, G, B = HexToRgb(TypeInfo.Color or "#e74c3c")

						if SceneOverlayActive and Config.SceneOverlay.ShowIcons then
							DrawMarker(32, EvCoords.x, EvCoords.y, EvCoords.z + 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, R, G, B, 200, true, false, 2, true, nil, nil, false)
						end

						DrawMarker(28, EvCoords.x, EvCoords.y, EvCoords.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.12, 0.12, 0.12, R, G, B, SceneOverlayActive and 200 or 140, false, false, 2, false, nil, nil, false)

						if Distance < Config.CollectDistance and IsFlashlightOut() then
							local Label = TypeInfo.Label or "Evidência"
							DrawText3D(EvCoords.x, EvCoords.y, EvCoords.z + 0.45, (TypeInfo.Icon or "📋") .. " ~y~[E]~w~ " .. Label)

							if IsControlJustPressed(0, 38) then
								StartEvidenceCollection(Id, Evidence)
							end
						end
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

function HexToRgb(Hex)
	Hex = Hex:gsub("#", "")
	if #Hex ~= 6 then return 200, 30, 30 end
	return tonumber(Hex:sub(1, 2), 16) or 200, tonumber(Hex:sub(3, 4), 16) or 30, tonumber(Hex:sub(5, 6), 16) or 30
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA COM MINIGAME
-----------------------------------------------------------------------------------------------------------------------------------------
function StartEvidenceCollection(EvidenceId, Evidence)
	if not IsFlashlightOut() then
		IMLNotify("negado", Config.Lang.NeedFlashlight)
		return
	end

	local TypeInfo = Config.EvidenceTypes[Evidence.type]
	local Minigame = TypeInfo and TypeInfo.Minigame

	if Minigame and StartMinigame then
		PendingCollectId = EvidenceId
		StartMinigame(Minigame, function(Success)
			if Success and PendingCollectId == EvidenceId then
				TriggerServerEvent("iml-evidencias:CollectEvidence", EvidenceId)
			elseif not Success then
				IMLNotify("negado", Config.Lang.MinigameFailed)
			end
			PendingCollectId = nil
		end)
	else
		TriggerServerEvent("iml-evidencias:CollectEvidence", EvidenceId)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCADORES NUMERADOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:SyncMarker")
AddEventHandler("iml-evidencias:SyncMarker", function(Marker)
	if Marker and Marker.id then
		SceneMarkers[Marker.id] = Marker
	end
end)

RegisterNetEvent("iml-evidencias:RemoveMarker")
AddEventHandler("iml-evidencias:RemoveMarker", function(MarkerId)
	SceneMarkers[MarkerId] = nil
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
						DrawMarker(25, MCoords.x, MCoords.y, MCoords.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 200, 0, 180, false, false, 2, false, nil, nil, false)
						DrawText3D(MCoords.x, MCoords.y, MCoords.z + 0.35, "~y~#" .. (Marker.number or "?"))
					end
				end
			end
		end
		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FITA POLICIAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:PlaceTape")
AddEventHandler("iml-evidencias:PlaceTape", function()
	if not IsCivil then return end
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Heading = GetEntityHeading(Ped)
	TriggerServerEvent("iml-evidencias:PlaceTape", { x = Coords.x, y = Coords.y, z = Coords.z }, Heading)
end)

RegisterNetEvent("iml-evidencias:SyncTape")
AddEventHandler("iml-evidencias:SyncTape", function(Segment)
	if Segment and Segment.id then
		SceneTape[Segment.id] = Segment
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
						DrawLine(Segment.start.x, Segment.start.y, Segment.start.z + 0.5, Segment.finish.x, Segment.finish.y, Segment.finish.z + 0.5, 255, 220, 0, 200)
						DrawText3D(Mid.x, Mid.y, Mid.z + 0.6, "~y~PERÍMETRO ISOLADO")
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
		else
			for Id in pairs(EvidenceProps) do
				RemoveEvidenceProp(Id)
			end
		end
	end
end)
