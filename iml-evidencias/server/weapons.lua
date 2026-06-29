-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO BALÍSTICO DE ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
WeaponRegistry = {}

function IML_GetOrCreateWeaponSerial(Passport, WeaponHash)
	if not Passport or not WeaponHash or WeaponHash == 0 then
		return GenerateSerial()
	end

	local Key = Passport .. "_" .. WeaponHash
	if WeaponRegistry[Key] then
		return WeaponRegistry[Key]
	end

	local Existing = vRP.Query("iml/GetWeaponsByPassport", { passport = Passport })
	for _, Row in ipairs(Existing) do
		if Row.weapon_hash == WeaponHash then
			WeaponRegistry[Key] = Row.weapon_serial
			return Row.weapon_serial
		end
	end

	local Serial = GenerateSerial()
	local Ammo = GetAmmoInfo(WeaponHash)

	vRP.Query("iml/InsertWeapon", {
		passport = Passport,
		weapon_hash = WeaponHash,
		weapon_serial = Serial,
		ammo_type = Ammo.Type
	})

	WeaponRegistry[Key] = Serial
	return Serial
end

function IML_GetWeaponOwner(Serial)
	if not Serial then return nil end
	local Result = vRP.Query("iml/GetWeaponBySerial", { weapon_serial = Serial })
	if Result[1] then
		return Result[1].passport, IML_GetIdentity(Result[1].passport)
	end
	return nil, nil
end

function IML_BuildBallisticResult(WeaponHash, Serial)
	local WeaponName = GetWeaponLabel(WeaponHash)
	local Ammo = GetAmmoInfo(WeaponHash)
	local OwnerPassport, OwnerIdentity = IML_GetWeaponOwner(Serial)

	local Result = {
		match = true,
		weapon = WeaponName,
		serial = Serial,
		ammo_type = Ammo.Type,
		ammo_label = Ammo.Label,
		ammo_category = Ammo.Category,
		message = string.format(Config.Lang.BallisticMatch, WeaponName, Ammo.Label, Serial)
	}

	if OwnerIdentity then
		Result.owner = OwnerIdentity
		Result.owner_passport = OwnerPassport
		Result.owner_message = string.format(Config.Lang.BallisticOwner, OwnerIdentity.Name, OwnerPassport)
	end

	return Result
end
