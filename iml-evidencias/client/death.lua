-----------------------------------------------------------------------------------------------------------------------------------------
-- DETECÇÃO DE DANO E MORTE
-----------------------------------------------------------------------------------------------------------------------------------------
local LastHealth = 200
local LastDamager = nil
local LastWeapon = nil
local LastBone = nil
local IsDead = false
local WeaponSerials = {}
local LastShotCoords = nil

-----------------------------------------------------------------------------------------------------------------------------------------
-- SERIAL DA ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:SetWeaponSerial")
AddEventHandler("iml-evidencias:SetWeaponSerial", function(WeaponHash, Serial)
	WeaponSerials[WeaponHash] = Serial
end)

CreateThread(function()
	while true do
		Wait(2000)
		local Ped = PlayerPedId()
		local Weapon = GetSelectedPedWeapon(Ped)

		if Weapon ~= `WEAPON_UNARMED` and IsFirearm(Weapon) then
			TriggerServerEvent("iml-evidencias:RegisterWeapon", Weapon)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RASTREAR DANO RECEBIDO
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered", function(Event, Args)
	if Event ~= "CEventNetworkEntityDamage" then return end

	local Victim = Args[1]
	local Attacker = Args[2]
	local VictimDied = Args[6] == 1
	local WeaponHash = Args[7]
	local BoneHit = Args[8]

	if Victim ~= PlayerPedId() then return end

	if Attacker and Attacker ~= 0 and Attacker ~= Victim then
		LastDamager = Attacker
	end

	if WeaponHash and WeaponHash ~= 0 then
		LastWeapon = WeaponHash
	end

	if BoneHit and BoneHit ~= 0 then
		LastBone = BoneHit
	end

	if VictimDied or GetEntityHealth(Victim) <= 100 then
		HandlePlayerDeath()
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FALLBACK DE MORTE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(500)
		local Ped = PlayerPedId()
		local Health = GetEntityHealth(Ped)

		if not IsDead and not LocalPlayer.state.Death and (IsEntityDead(Ped) or Health <= 100) then
			HandlePlayerDeath()
		end

		if IsDead and Health > 100 and not IsEntityDead(Ped) then
			IsDead = false
		end

		LastHealth = Health
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSAR MORTE
-----------------------------------------------------------------------------------------------------------------------------------------
function HandlePlayerDeath()
	if IsDead then return end
	if LocalPlayer.state.Death then return end

	IsDead = true

	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local CauseWeapon = GetPedCauseOfDeath(Ped)
	local SourceEntity = GetPedSourceOfDeath(Ped)

	local WeaponHash = LastWeapon or CauseWeapon or 0
	local KillerSource = nil
	local Distance = 0
	local Headshot = false

	if LastBone == 31086 then
		Headshot = true
	end

	if SourceEntity and SourceEntity ~= 0 then
		if IsEntityAPed(SourceEntity) and IsPedAPlayer(SourceEntity) then
			KillerSource = GetPlayerServerId(NetworkGetPlayerIndexFromPed(SourceEntity))
			local KillerCoords = GetEntityCoords(SourceEntity)
			Distance = #(Coords - KillerCoords)
		end
	elseif LastDamager and IsEntityAPed(LastDamager) and IsPedAPlayer(LastDamager) then
		KillerSource = GetPlayerServerId(NetworkGetPlayerIndexFromPed(LastDamager))
		local KillerCoords = GetEntityCoords(LastDamager)
		Distance = #(Coords - KillerCoords)
	end

	TriggerServerEvent("iml-evidencias:PlayerDied", {
		killer_source = KillerSource,
		weapon_hash = WeaponHash,
		bone_hit = GetBoneLabel(LastBone or 0),
		distance = RoundNumber(Distance, 1),
		headshot = Headshot,
		coords = { x = Coords.x, y = Coords.y, z = Coords.z }
	})

	LastDamager = nil
	LastWeapon = nil
	LastBone = nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TIROS: CÁPSULAS, PROJÉTEIS, GSR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000
		local Ped = PlayerPedId()

		if IsPedShooting(Ped) then
			Sleep = 0
			local Weapon = GetSelectedPedWeapon(Ped)
			local Serial = WeaponSerials[Weapon]
			local Coords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -0.9)

			if math.random(100) <= Config.Chances.Casing then
				TriggerServerEvent("iml-evidencias:CreateEvidence", {
					type = "casing",
					weapon_hash = Weapon,
					weapon_serial = Serial,
					coords = { x = Coords.x, y = Coords.y, z = Coords.z },
					heading = GetEntityHeading(Ped)
				})
			end

			if math.random(100) <= Config.Chances.Magazine then
				local MagCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.3, 0.3, -0.9)
				TriggerServerEvent("iml-evidencias:CreateEvidence", {
					type = "magazine",
					weapon_hash = Weapon,
					weapon_serial = Serial,
					coords = { x = MagCoords.x, y = MagCoords.y, z = MagCoords.z }
				})
			end

			if math.random(100) <= Config.Chances.GSR then
				TriggerServerEvent("iml-evidencias:CreateEvidence", {
					type = "gsr",
					weapon_hash = Weapon,
					weapon_serial = Serial
				})
			end

			-- Projétil impactado (raycast)
			if math.random(100) <= Config.Chances.BulletImpact then
				local Hit = GetBulletImpactCoords(Ped)
				if Hit then
					TriggerServerEvent("iml-evidencias:CreateEvidence", {
						type = "bullet",
						weapon_hash = Weapon,
						weapon_serial = Serial,
						coords = { x = Hit.x, y = Hit.y, z = Hit.z }
					})

					if Hit.entity and Hit.entity ~= 0 and IsEntityAVehicle(Hit.entity) then
						if math.random(100) <= Config.Chances.VehicleBullet then
							local VehCoords = GetEntityCoords(Hit.entity)
							TriggerServerEvent("iml-evidencias:CreateEvidence", {
								type = "vehicle_bullet",
								weapon_hash = Weapon,
								weapon_serial = Serial,
								coords = { x = VehCoords.x, y = VehCoords.y, z = VehCoords.z },
								vehicle = VehToNet(Hit.entity)
							})
						end
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

function GetBulletImpactCoords(Ped)
	local CamCoords = GetGameplayCamCoord()
	local CamRot = GetGameplayCamRot(2)
	local Direction = RotationToDirection(CamRot)
	local Dest = vector3(
		CamCoords.x + Direction.x * 200.0,
		CamCoords.y + Direction.y * 200.0,
		CamCoords.z + Direction.z * 200.0
	)

	local Ray = StartShapeTestRay(CamCoords.x, CamCoords.y, CamCoords.z, Dest.x, Dest.y, Dest.z, -1, Ped, 0)
	local _, Hit, HitCoords, _, Entity = GetShapeTestResult(Ray)

	if Hit == 1 then
		return { x = HitCoords.x, y = HitCoords.y, z = HitCoords.z, entity = Entity }
	end

	return nil
end

function RotationToDirection(Rot)
	local RadX = math.rad(Rot.x)
	local RadZ = math.rad(Rot.z)
	return vector3(-math.sin(RadZ) * math.abs(math.cos(RadX)), math.cos(RadZ) * math.abs(math.cos(RadX)), math.sin(RadX))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SANGUE AO RECEBER DANO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(400)
		local Ped = PlayerPedId()
		local Health = GetEntityHealth(Ped)

		if Health < LastHealth and Health > 100 then
			if math.random(100) <= Config.Chances.Blood then
				local Coords = GetEntityCoords(Ped)
				TriggerServerEvent("iml-evidencias:CreateEvidence", {
					type = "blood",
					coords = { x = Coords.x, y = Coords.y, z = Coords.z - 0.95 }
				})
			end
		end

		LastHealth = Health
	end
end)
