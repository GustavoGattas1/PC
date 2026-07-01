-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------
function DebugPrint(...)
	if Config.Debug then
		print("[IML]", ...)
	end
end

function GetWeaponLabel(Hash)
	if not Hash then return "Desconhecida" end
	return Config.Weapons[Hash] or ("Arma Desconhecida (#" .. tostring(Hash) .. ")")
end

function GetAmmoInfo(Hash)
	if not Hash then return { Type = "?", Label = "Desconhecido", Category = "?", CasingModel = nil } end
	return Config.AmmoTypes[Hash] or { Type = "?", Label = "Munição não catalogada", Category = "?", CasingModel = nil }
end

function GetDeathCause(WeaponHash)
	if not WeaponHash or WeaponHash == 0 then
		return Config.DeathCauses.Unknown
	end

	if Config.MeleeWeapons[WeaponHash] then
		return Config.DeathCauses.Melee
	end

	if WeaponHash == `WEAPON_UNARMED` then
		return Config.DeathCauses.Unarmed
	end

	local Ammo = GetAmmoInfo(WeaponHash)
	if Ammo.Category == "Shotgun" then
		return Config.DeathCauses.Shotgun
	elseif Ammo.Category == "Precisão" then
		return Config.DeathCauses.Sniper
	elseif Ammo.Category == "Pistola" or Ammo.Category == "Submetralhadora" or Ammo.Category == "Rifle" then
		return Config.DeathCauses.Firearm
	end

	return Config.DeathCauses.Unknown
end

function GetBoneLabel(BoneId)
	return Config.BoneLabels[BoneId] or "Região não identificada"
end

function GetBoneZone(BoneLabel)
	if not BoneLabel then return "unknown" end
	return Config.BoneZones[BoneLabel] or "unknown"
end

function GetBodyTemperature(DeathTimestamp)
	if not DeathTimestamp then
		return { Label = "Desconhecido", Color = "#95a5a6", Description = "Temperatura corporal indeterminada" }
	end

	local Elapsed = os.time() - DeathTimestamp
	for _, Stage in ipairs(Config.BodyTemperature) do
		if Elapsed <= Stage.MaxSeconds then
			return Stage
		end
	end

	return Config.BodyTemperature[#Config.BodyTemperature]
end

function GenerateSerial()
	local Chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local Serial = ""
	for i = 1, 8 do
		local Index = math.random(1, #Chars)
		Serial = Serial .. string.sub(Chars, Index, Index)
	end
	return Serial
end

function GenerateDnaCode(Passport)
	return string.format("DNA-%05d-%s", Passport, string.upper(string.sub(GenerateSerial(), 1, 4)))
end

function FormatTimestamp()
	return os.date("%d/%m/%Y às %H:%M")
end

function FormatTimeOnly()
	return os.date("%H:%M:%S")
end

function IMLNotify(Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.important
	TriggerEvent("Notify", Info.Title, Message, Info.Color, Duration or 5000)
end

function IsFirearm(WeaponHash)
	if not WeaponHash then return false end
	local Ammo = Config.AmmoTypes[WeaponHash]
	return Ammo ~= nil
end

function RoundNumber(Number, Decimals)
	local Mult = 10 ^ (Decimals or 1)
	return math.floor(Number * Mult + 0.5) / Mult
end

function GetEvidenceCooldown(Type)
	if Config.EvidenceCooldown and Config.EvidenceCooldown[Type] then
		return Config.EvidenceCooldown[Type]
	end
	return Config.EvidenceCooldown and Config.EvidenceCooldown.default or 400
end

function IsGunshotDeath(WeaponHash)
	if not WeaponHash or WeaponHash == 0 then return false end
	local Ammo = GetAmmoInfo(WeaponHash)
	return Ammo.Category == "Pistola" or Ammo.Category == "Submetralhadora" or Ammo.Category == "Rifle" or Ammo.Category == "Shotgun" or Ammo.Category == "Precisão"
end

function GetSpreadRange(EvidenceType)
	local Spread = Config.EvidenceSpread or {}
	if EvidenceType == "casing" or EvidenceType == "magazine" then
		return Spread.Casing or Spread.Default or { Min = 0.6, Max = 1.8 }
	elseif EvidenceType == "blood" or EvidenceType == "blood_pool" or EvidenceType == "blood_swab" then
		return Spread.Blood or Spread.Default or { Min = 0.5, Max = 2.0 }
	elseif EvidenceType == "bullet" or EvidenceType == "bullet_fragment" or EvidenceType == "vehicle_bullet" then
		return Spread.Bullet or Spread.Default or { Min = 0.3, Max = 1.2 }
	elseif EvidenceType == "tire_track" then
		return Spread.TireTrack or Spread.Default or { Min = 1.5, Max = 3.5 }
	elseif EvidenceType == "dna" then
		return Spread.Dna or Spread.Default or { Min = 0.4, Max = 1.5 }
	end
	return Spread.Default or { Min = 0.5, Max = 1.5 }
end

function SpreadCoords(Coords, EvidenceType, Heading)
	if not Coords then return Coords end

	local Range = GetSpreadRange(EvidenceType)
	local MinR = Range.Min or 0.5
	local MaxR = Range.Max or 1.5
	local Radius = MinR + math.random() * (MaxR - MinR)
	local Angle = math.random() * math.pi * 2

	if Heading and (EvidenceType == "casing" or EvidenceType == "magazine") then
		local Rad = math.rad(Heading)
		Angle = Rad + math.pi * 0.5 + math.random(-40, 40) / 100
		Radius = MinR + math.random() * (MaxR - MinR)
	end

	return {
		x = Coords.x + math.cos(Angle) * Radius,
		y = Coords.y + math.sin(Angle) * Radius,
		z = Coords.z
	}
end

function CoordsDistance2D(A, B)
	if not A or not B then return 999.0 end
	local Dx = (A.x or 0) - (B.x or 0)
	local Dy = (A.y or 0) - (B.y or 0)
	return math.sqrt(Dx * Dx + Dy * Dy)
end

function ResolveEvidenceCoords(Coords, EvidenceType, ExistingList)
	if not Coords then return Coords end

	local Spread = Config.EvidenceSpread or {}
	local MinDist = Spread.MinDistance or 1.0
	local Range = GetSpreadRange(EvidenceType)
	local Result = SpreadCoords(Coords, EvidenceType)

	if not ExistingList then return Result end

	for Attempt = 1, 20 do
		local TooClose = false

		for _, Evidence in pairs(ExistingList) do
			if Evidence.coords and not Evidence.collected then
				if CoordsDistance2D(Result, Evidence.coords) < MinDist then
					TooClose = true
					break
				end
			end
		end

		if not TooClose then
			return Result
		end

		local Push = MinDist + math.random() * (Range.Max or 1.5)
		local Angle = math.random() * math.pi * 2
		Result = {
			x = Coords.x + math.cos(Angle) * Push,
			y = Coords.y + math.sin(Angle) * Push,
			z = Coords.z
		}
	end

	return Result
end
