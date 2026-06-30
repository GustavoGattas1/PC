-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("iml-evidencias")

ClientIML = {}
function ClientIML.IsFlashlightActive()
	return IsFlashlightOut()
end
Tunnel.bindInterface("iml-evidencias", ClientIML)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
SceneEvidence = {}
SceneCorpses = {}
WearingGloves = false
NuiOpen = false
IsCivil = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- LANTERNA
-----------------------------------------------------------------------------------------------------------------------------------------
function IsFlashlightOut()
	local Ped = PlayerPedId()
	if GetSelectedPedWeapon(Ped) ~= Config.Flashlight.Weapon then
		return false
	end

	if Config.Flashlight.RequireAiming then
		return IsPlayerFreeAiming(PlayerId())
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO CIVIL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local WasCivil = false

	while true do
		Wait(5000)
		local Civil = vSERVER.IsCivil()
		IsCivil = Civil

		if Civil and not WasCivil then
			local Scene = vSERVER.RequestScene()
			if Scene then
				for _, Evidence in ipairs(Scene) do
					SceneEvidence[Evidence.id] = Evidence
				end
			end

			local Corpses = vSERVER.RequestCorpses()
			if Corpses then
				for _, Corpse in ipairs(Corpses) do
					if Corpse.victim_passport then
						SceneCorpses[Corpse.victim_passport] = Corpse
					end
				end
			end
		elseif not Civil and WasCivil then
			SceneEvidence = {}
			SceneCorpses = {}
		end

		WasCivil = Civil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP DO IML
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if not Config.Blips.Enabled then return end

	while not IsCivil do
		Wait(5000)
	end

	local Blip = AddBlipForCoord(Config.Blips.Coords.x, Config.Blips.Coords.y, Config.Blips.Coords.z)
	SetBlipSprite(Blip, Config.Blips.Sprite)
	SetBlipColour(Blip, Config.Blips.Color)
	SetBlipScale(Blip, Config.Blips.Scale)
	SetBlipAsShortRange(Blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Blips.Label)
	EndTextCommandSetBlipName(Blip)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR CENA AO ENTRAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function()
	Wait(5000)
	IsCivil = vSERVER.IsCivil()

	if not IsCivil then return end

	local Scene = vSERVER.RequestScene()
	if Scene then
		for _, Evidence in ipairs(Scene) do
			SceneEvidence[Evidence.id] = Evidence
		end
	end

	local Corpses = vSERVER.RequestCorpses()
	if Corpses then
		for _, Corpse in ipairs(Corpses) do
			if Corpse.victim_passport then
				SceneCorpses[Corpse.victim_passport] = Corpse
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SINCRONIZAÇÃO DE EVIDÊNCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:SyncEvidence")
AddEventHandler("iml-evidencias:SyncEvidence", function(Evidence)
	if not IsCivil then return end
	if Evidence and Evidence.id then
		SceneEvidence[Evidence.id] = Evidence
	end
end)

RegisterNetEvent("iml-evidencias:RemoveEvidence")
AddEventHandler("iml-evidencias:RemoveEvidence", function(EvidenceId)
	SceneEvidence[EvidenceId] = nil
end)

RegisterNetEvent("iml-evidencias:SyncCorpse")
AddEventHandler("iml-evidencias:SyncCorpse", function(Corpse)
	if not IsCivil then return end
	if Corpse and Corpse.victim_passport then
		SceneCorpses[Corpse.victim_passport] = Corpse
	end
end)

RegisterNetEvent("iml-evidencias:RemoveCorpse")
AddEventHandler("iml-evidencias:RemoveCorpse", function(VictimPassport)
	SceneCorpses[VictimPassport] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPRESSÃO DIGITAL EM VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(2000)
		local Ped = PlayerPedId()

		if not WearingGloves and IsPedGettingIntoAVehicle(Ped) then
			local Vehicle = GetVehiclePedIsTryingToEnter(Ped)
			if Vehicle ~= 0 and math.random(100) <= Config.Chances.Fingerprint then
				local Coords = GetEntityCoords(Vehicle)
				TriggerServerEvent("iml-evidencias:CreateEvidence", {
					type = "fingerprint",
					coords = { x = Coords.x, y = Coords.y, z = Coords.z },
					vehicle = VehToNet(Vehicle)
				})
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LUVAS DE LÁTEX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:ToggleGloves")
AddEventHandler("iml-evidencias:ToggleGloves", function()
	WearingGloves = not WearingGloves
	local Message = WearingGloves and "Luvas de látex equipadas." or "Luvas de látex removidas."
	TriggerEvent("Notify", WearingGloves and "success" or "important", Message, false, 3000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESENHAR EVIDÊNCIAS NA CENA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if not IsCivil or not IsFlashlightOut() then
			Wait(Sleep)
		else
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local DrawDistance = Config.Flashlight.DrawDistance or 25.0

			for Id, Evidence in pairs(SceneEvidence) do
				if Evidence.coords and not Evidence.collected then
					local EvCoords = vector3(Evidence.coords.x, Evidence.coords.y, Evidence.coords.z)
					local Distance = #(PedCoords - EvCoords)
					local TypeInfo = Config.EvidenceTypes[Evidence.type]

					if Distance < DrawDistance then
						Sleep = 0
						local R, G, B = 200, 30, 30

						if Evidence.type == "blood" or Evidence.type == "blood_pool" then
							R, G, B = 180, 20, 20
						elseif Evidence.type == "casing" then
							R, G, B = 212, 172, 13
						elseif Evidence.type == "bullet" or Evidence.type == "bullet_fragment" then
							R, G, B = 230, 126, 34
						elseif Evidence.type == "fingerprint" then
							R, G, B = 142, 68, 173
						elseif Evidence.type == "vehicle_bullet" then
							R, G, B = 26, 82, 118
						end

						DrawMarker(28, EvCoords.x, EvCoords.y, EvCoords.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.14, 0.14, 0.14, R, G, B, 150, false, false, 2, false, nil, nil, false)

						if Distance < Config.CollectDistance then
							DrawText3D(EvCoords.x, EvCoords.y, EvCoords.z + 0.3, "~y~[Lanterna]~w~ ~r~[E]~w~ Coletar " .. (TypeInfo and TypeInfo.Label or "Evidência"))

							if IsControlJustPressed(0, 38) and IsFlashlightOut() then
								TriggerServerEvent("iml-evidencias:CollectEvidence", Id)
							end
						end
					end
				end
			end

			Wait(Sleep)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCADORES DO IML
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000
		local Ped = PlayerPedId()
		local PedCoords = GetEntityCoords(Ped)

		local AllLocations = {}
		for _, Loc in ipairs(Config.Locations.Lab) do AllLocations[#AllLocations + 1] = { data = Loc, action = "lab" } end
		for _, Loc in ipairs(Config.Locations.Ballistics or {}) do AllLocations[#AllLocations + 1] = { data = Loc, action = "lab" } end
		for _, Loc in ipairs(Config.Locations.Autopsy) do AllLocations[#AllLocations + 1] = { data = Loc, action = "autopsy" } end
		for _, Loc in ipairs(Config.Locations.Locker) do AllLocations[#AllLocations + 1] = { data = Loc, action = "locker" } end
		for _, Loc in ipairs(Config.Locations.BodyDrop) do AllLocations[#AllLocations + 1] = { data = Loc, action = "bodydrop" } end

		for _, Entry in ipairs(AllLocations) do
			if not IsCivil then break end

			local Loc = Entry.data
			local Distance = #(PedCoords - Loc.Coords)

			if Distance < Config.Marker.DrawDistance then
				Sleep = 0
				local M = Config.Marker
				DrawMarker(M.Type, Loc.Coords.x, Loc.Coords.y, Loc.Coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, M.Size.x, M.Size.y, M.Size.z, M.Color.r, M.Color.g, M.Color.b, M.Color.a, false, false, 2, false, nil, nil, false)

				if Distance < Config.Marker.InteractDistance then
					local ActionText = {
						lab = "~r~[E]~w~ Analisar Evidências",
						autopsy = "~r~[E]~w~ Realizar Autópsia",
						locker = "~r~[E]~w~ Armário de Evidências",
						bodydrop = "~r~[E]~w~ Entregar Corpo"
					}

					DrawText3D(Loc.Coords.x, Loc.Coords.y, Loc.Coords.z, ActionText[Entry.action] or "~r~[E]~w~ Interagir")

					if IsControlJustPressed(0, 38) then
						HandleLocationAction(Entry.action)
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

function HandleLocationAction(Action)
	if Action == "lab" then OpenLabMenu()
	elseif Action == "autopsy" then OpenAutopsyMenu()
	elseif Action == "locker" then OpenLockerMenu()
	elseif Action == "bodydrop" then OpenBodyDropMenu()
	end
end

function OpenLabMenu()
	local Evidence = vSERVER.GetMyEvidence()
	if not Evidence or #Evidence == 0 then
		TriggerEvent("Notify", "important", Config.Lang.NoEvidence, false, 5000)
		return
	end
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openLab", evidence = Evidence })
end

function OpenAutopsyMenu()
	local Bodies = vSERVER.GetPendingBodies()
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openAutopsy", bodies = Bodies })
end

function OpenLockerMenu()
	local Evidence = vSERVER.GetMyEvidence()
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openLocker", evidence = Evidence })
end

function OpenBodyDropMenu()
	local Bodies = vSERVER.GetMyBodies()
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openBodyDrop", bodies = Bodies })
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(_, cb)
	SetNuiFocus(false, false)
	NuiOpen = false
	cb("ok")
end)

RegisterNUICallback("analyze", function(Data, cb)
	if Data and Data.evidence_id then
		TriggerServerEvent("iml-evidencias:AnalyzeEvidence", Data.evidence_id)
	end
	SetNuiFocus(false, false)
	NuiOpen = false
	cb("ok")
end)

RegisterNUICallback("autopsy", function(Data, cb)
	if Data and Data.body_id then
		TriggerServerEvent("iml-evidencias:PerformAutopsy", Data.body_id)
	end
	SetNuiFocus(false, false)
	NuiOpen = false
	cb("ok")
end)

RegisterNUICallback("deliverBody", function(Data, cb)
	if Data and Data.body_id then
		TriggerServerEvent("iml-evidencias:DeliverBody", Data.body_id)
	end
	SetNuiFocus(false, false)
	NuiOpen = false
	cb("ok")
end)

RegisterNetEvent("iml-evidencias:OpenReport")
AddEventHandler("iml-evidencias:OpenReport", function(Report, Title)
	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage({ action = "openReport", report = Report, title = Title })
end)

RegisterNetEvent("iml-evidencias:BodyCollected")
AddEventHandler("iml-evidencias:BodyCollected", function()
	local Ped = PlayerPedId()
	SetEntityVisible(Ped, false, false)
	SetEntityCollision(Ped, false, false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW TEXT 3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
	local OnScreen, _x, _y = World3dToScreen2d(x, y, z)
	if OnScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(true)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end
