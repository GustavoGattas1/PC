-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS 3D, OVERLAY E MARCADORES
-----------------------------------------------------------------------------------------------------------------------------------------
EvidenceProps = {}
MarkerProps = {}
SceneOverlayActive = false
SceneMarkers = {}
SceneEvidenceIndex = {}

local HexColorCache = {}
local EvidenceIndexDirty = true
local BallisticsCacheDirty = true
local PropsDirty = true
local CachedCasings = {}
local CachedBullets = {}
local MarkerDrawDistanceSq = 1600.0

function MarkSceneEvidenceDirty()
	EvidenceIndexDirty = true
	BallisticsCacheDirty = true
	PropsDirty = true
end

local function GetTypeColor(TypeInfo)
	local Color = TypeInfo and TypeInfo.Color
	if Color and HexColorCache[Color] then
		local C = HexColorCache[Color]
		return C[1], C[2], C[3]
	end
	return HexToRgb(Color or "#e74c3c")
end

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

function RemoveEvidenceLocal(EvidenceId)
	if SceneEvidence then
		SceneEvidence[EvidenceId] = nil
	end
	RemoveEvidenceProp(EvidenceId)
	SceneEvidenceIndex[EvidenceId] = nil
	MarkSceneEvidenceDirty()
end

RegisterNetEvent("iml-evidencias:SyncEvidence")
AddEventHandler("iml-evidencias:SyncEvidence", function(Evidence)
	if Evidence and Evidence.id and Evidence.coords then
		SpawnEvidenceProp(Evidence)
		MarkSceneEvidenceDirty()
	end
end)

RegisterNetEvent("iml-evidencias:CollectSuccess")
AddEventHandler("iml-evidencias:CollectSuccess", function(EvidenceId)
	RemoveEvidenceLocal(EvidenceId)
end)

RegisterNetEvent("iml-evidencias:RemoveEvidence")
AddEventHandler("iml-evidencias:RemoveEvidence", function(EvidenceId)
	RemoveEvidenceLocal(EvidenceId)
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

for _, TypeInfo in pairs(Config.EvidenceTypes or {}) do
	if TypeInfo.Color and not HexColorCache[TypeInfo.Color] then
		local R, G, B = HexToRgb(TypeInfo.Color)
		HexColorCache[TypeInfo.Color] = { R, G, B }
	end
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

	if BallisticsCacheDirty then
		CachedCasings = {}
		CachedBullets = {}
		local MaxDist = Config.SceneOverlay.TraceDistance or 25.0

		for _, Evidence in pairs(SceneEvidence) do
			if Evidence.coords and not Evidence.collected then
				if Evidence.type == "casing" then
					CachedCasings[#CachedCasings + 1] = Evidence
				elseif Evidence.type == "bullet" or Evidence.type == "bullet_fragment" then
					CachedBullets[#CachedBullets + 1] = Evidence
				end
			end
		end

		BallisticsCacheDirty = false
	end

	local MaxDist = Config.SceneOverlay.TraceDistance or 25.0
	local Px, Py, Pz = PedCoords.x, PedCoords.y, PedCoords.z

	for i = 1, #CachedCasings do
		local Casing = CachedCasings[i]
		local CC = Casing.coords
		local Dx = Px - CC.x
		local Dy = Py - CC.y
		local Dz = Pz - CC.z
		if (Dx * Dx + Dy * Dy + Dz * Dz) < (MaxDist * MaxDist) then
			local Closest = nil
			local ClosestDistSq = MaxDist * MaxDist

			for j = 1, #CachedBullets do
				local Bullet = CachedBullets[j]
				local BC = Bullet.coords
				local Bdx = CC.x - BC.x
				local Bdy = CC.y - BC.y
				local Bdz = CC.z - BC.z
				local DistSq = Bdx * Bdx + Bdy * Bdy + Bdz * Bdz
				if DistSq < ClosestDistSq then
					ClosestDistSq = DistSq
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
	if not EvidenceIndexDirty then
		local Count = 0
		for _ in pairs(SceneEvidenceIndex) do Count = Count + 1 end
		return Count
	end

	SceneEvidenceIndex = {}
	local Num = 0
	for Id, Evidence in pairs(SceneEvidence) do
		if Evidence.coords and not Evidence.collected then
			Num = Num + 1
			SceneEvidenceIndex[Id] = Num
		end
	end

	EvidenceIndexDirty = false
	return Num
end

CreateThread(function()
	while true do
		local Sleep = 1000

		if IsCivil and (SceneOverlayActive or IsFlashlightOut()) then
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local Px, Py, Pz = PedCoords.x, PedCoords.y, PedCoords.z
			local DrawDistance = SceneOverlayActive and (Config.SceneOverlay.DrawDistance or 50.0) or (Config.Flashlight.DrawDistance or 30.0)
			local DrawDistanceSq = DrawDistance * DrawDistance
			local EvidenceCount = 0
			local Pulse = math.sin(GetGameTimer() / 350.0) * 0.05 + 1.0
			local FlashlightActive = IsFlashlightOut()
			local NuiBusy = IsNuiBusy and IsNuiBusy()
			local CollectDistance = Config.CollectDistance
			local CollectDistanceSq = CollectDistance * CollectDistance

			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected then
					local Ex = Evidence.coords.x
					local Ey = Evidence.coords.y
					local Ez = Evidence.coords.z
					local Dx = Px - Ex
					local Dy = Py - Ey
					local Dz = Pz - Ez
					local DistSq = Dx * Dx + Dy * Dy + Dz * Dz

					if DistSq < DrawDistanceSq then
						Sleep = 0
						EvidenceCount = EvidenceCount + 1
						local Distance = math.sqrt(DistSq)
						local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
						local R, G, B = GetTypeColor(TypeInfo)
						local Index = SceneEvidenceIndex[Id] or EvidenceCount

						if SceneOverlayActive then
							local RingSize = 0.35 * Pulse
							DrawMarker(25, Ex, Ey, Ez + 0.02, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, RingSize, RingSize, 0.08, R, G, B, 120, false, false, 2, false, nil, nil, false)
							DrawMarker(32, Ex, Ey, Ez + 0.55, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, R, G, B, 200, true, false, 2, true, nil, nil, false)
							if Distance < 15.0 then
								DrawLightWithRange(Ex, Ey, Ez + 0.3, R, G, B, 2.0, 0.3)
							end
							DrawFloatingLabel(Ex, Ey, Ez + 0.65, TypeInfo.Icon, "#" .. Index .. " " .. (TypeInfo.Label or "Evidência"), Distance)
						else
							DrawMarker(28, Ex, Ey, Ez + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, R, G, B, 140, false, false, 2, false, nil, nil, false)
						end

						if DistSq < CollectDistanceSq and FlashlightActive and not NuiBusy then
							if not SceneOverlayActive then
								DrawText3D(Ex, Ey, Ez + 0.45, (TypeInfo.Icon or "📋") .. " ~y~[E]~w~ " .. (TypeInfo.Label or "Evidência"))
							end

							if IsControlJustPressed(0, 38) and StartEvidenceCollection then
								StartEvidenceCollection(Id, Evidence)
							end
						end
					end
				end
			end

			for _, Marker in pairs(SceneMarkers) do
				if Marker.coords then
					local Mx = Marker.coords.x
					local My = Marker.coords.y
					local Mz = Marker.coords.z
					local Mdx = Px - Mx
					local Mdy = Py - My
					local Mdz = Pz - Mz
					if (Mdx * Mdx + Mdy * Mdy + Mdz * Mdz) < MarkerDrawDistanceSq then
						Sleep = 0
						DrawText3D(Mx, My, Mz + 0.55, "~y~EVIDÊNCIA #" .. (Marker.number or "?"))
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
		PropsDirty = true
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
AddEventHandler("iml-evidencias:PlaceMarker", function(FromItemUse)
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	TriggerServerEvent("iml-evidencias:PlaceMarker", { x = Coords.x, y = Coords.y, z = Coords.z - 0.95 }, FromItemUse == true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS AO CARREGAR CENA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if not IsCivil then
			for Id in pairs(EvidenceProps) do RemoveEvidenceProp(Id) end
			for Id, Obj in pairs(MarkerProps) do
				if DoesEntityExist(Obj) then DeleteEntity(Obj) end
				MarkerProps[Id] = nil
			end
			Wait(3000)
		elseif PropsDirty then
			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected and not EvidenceProps[Id] then
					SpawnEvidenceProp(Evidence)
				end
			end
			for Id, Marker in pairs(SceneMarkers) do
				if not MarkerProps[Id] then SpawnMarkerProp(Marker) end
			end
			PropsDirty = false
			Wait(3000)
		else
			Wait(5000)
		end
	end
end)
