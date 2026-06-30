-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO DE MORTES E CADÁVERES NA CENA
-----------------------------------------------------------------------------------------------------------------------------------------
DeathRecords = {}
SceneCorpses = {}
SceneEvidence = SceneEvidence or {}

function IML_RegisterDeath(Data)
	local VictimPassport = Data.victim_passport
	if not VictimPassport then return nil end

	local RecordId = IML_GenerateId("DEATH")
	local WeaponHash = Data.weapon_hash or 0
	local Ammo = GetAmmoInfo(WeaponHash)
	local Serial = Data.weapon_serial

	if Data.killer_passport and WeaponHash ~= 0 and not Serial then
		Serial = IML_GetOrCreateWeaponSerial(Data.killer_passport, WeaponHash)
	end

	local Record = {
		record_id = RecordId,
		victim_passport = VictimPassport,
		killer_passport = Data.killer_passport,
		weapon_hash = WeaponHash,
		weapon_serial = Serial,
		ammo_type = Ammo.Type,
		ammo_label = Ammo.Label,
		cause_of_death = Data.cause_of_death or GetDeathCause(WeaponHash),
		bone_hit = Data.bone_hit or "Não identificado",
		distance = Data.distance or 0,
		headshot = Data.headshot or false,
		coords = Data.coords,
		time_of_death = FormatTimestamp(),
		time_of_death_raw = os.time(),
		examined = false,
		bagged = false,
		victim_name = Data.victim_name,
		killer_name = Data.killer_name
	}

	DeathRecords[VictimPassport] = Record
	SceneCorpses[RecordId] = Record

	vRP.Query("iml/InsertDeathRecord", {
		record_id = RecordId,
		victim_passport = VictimPassport,
		killer_passport = Data.killer_passport,
		weapon_hash = WeaponHash,
		weapon_serial = Serial,
		ammo_type = Ammo.Type,
		ammo_label = Ammo.Label,
		cause_of_death = Record.cause_of_death,
		bone_hit = Record.bone_hit,
		distance = Record.distance,
		headshot = Record.headshot and 1 or 0,
		coords = json.encode(Data.coords or {})
	})

	-- Poça de sangue na cena da morte
	if Data.coords then
		IML_CreateSceneEvidence({
			type = "blood_pool",
			passport = VictimPassport,
			coords = Data.coords,
			metadata = { record_id = RecordId, victim = VictimPassport }
		})
	end

	IML_BroadcastCivil("iml-evidencias:SyncCorpse", Record)
	DebugPrint("Morte registrada:", RecordId, "Vítima:", VictimPassport)

	return Record
end

function IML_GetDeathRecord(VictimPassport)
	if DeathRecords[VictimPassport] then
		return DeathRecords[VictimPassport]
	end

	local Db = vRP.Query("iml/GetDeathByVictim", { victim_passport = VictimPassport })
	if Db[1] then
		local Record = Db[1]
		Record.headshot = Record.headshot == 1
		Record.coords = json.decode(Record.coords or "{}")
		return Record
	end

	return nil
end

function IML_BuildCorpseExam(Record)
	if not Record then return nil end

	local VictimIdentity = IML_GetIdentity(Record.victim_passport)
	local KillerIdentity = Record.killer_passport and IML_GetIdentity(Record.killer_passport) or nil
	local WeaponName = GetWeaponLabel(Record.weapon_hash)
	local AmmoLabel = Record.ammo_label or GetAmmoInfo(Record.weapon_hash).Label

	return {
		type = "corpse_exam",
		record_id = Record.record_id,
		victim = VictimIdentity,
		killer = KillerIdentity,
		weapon = WeaponName,
		weapon_hash = Record.weapon_hash,
		weapon_serial = Record.weapon_serial,
		ammo_type = Record.ammo_type,
		ammo_label = AmmoLabel,
		cause_of_death = Record.cause_of_death,
		bone_hit = Record.bone_hit,
		distance = RoundNumber(Record.distance or 0, 1),
		headshot = Record.headshot,
		time_of_death = Record.time_of_death or FormatTimestamp(),
		findings = IML_BuildExamFindings(Record, WeaponName, AmmoLabel, KillerIdentity)
	}
end

function IML_BuildExamFindings(Record, WeaponName, AmmoLabel, KillerIdentity)
	local Findings = {
		"Hora provável do óbito: " .. (Record.time_of_death or "Desconhecida"),
		"Causa provável: " .. (Record.cause_of_death or "Indeterminada"),
		"Região do impacto: " .. (Record.bone_hit or "Não identificada")
	}

	if Record.weapon_hash and Record.weapon_hash ~= 0 then
		Findings[#Findings + 1] = "Arma utilizada: " .. WeaponName
		Findings[#Findings + 1] = "Calibre/Munição: " .. AmmoLabel
		if Record.weapon_serial then
			Findings[#Findings + 1] = "Serial balístico: " .. Record.weapon_serial
		end
		if Record.distance and Record.distance > 0 then
			Findings[#Findings + 1] = "Distância estimada do disparo: " .. RoundNumber(Record.distance, 1) .. "m"
		end
		if Record.headshot then
			Findings[#Findings + 1] = "Observação: Impacto em região craniana (headshot)"
		end
	else
		Findings[#Findings + 1] = "Não há indícios de arma de fogo no corpo"
	end

	if KillerIdentity then
		Findings[#Findings + 1] = "Suspeito identificado: " .. KillerIdentity.Name .. " (#" .. KillerIdentity.Passport .. ")"
	else
		Findings[#Findings + 1] = "Autor do fato: Não identificado"
	end

	return Findings
end

function IML_BuildAutopsyReport(BodyInfo, Passport)
	local Identity = IML_GetIdentity(BodyInfo.victim_passport)
	local Dna = vRP.Query("iml/GetDna", { passport = BodyInfo.victim_passport })
	local Metadata = {}

	if BodyInfo.metadata then
		if type(BodyInfo.metadata) == "string" then
			Metadata = json.decode(BodyInfo.metadata) or {}
		else
			Metadata = BodyInfo.metadata
		end
	end

	local WeaponName = GetWeaponLabel(BodyInfo.weapon_hash or Metadata.weapon_hash)
	local AmmoLabel = BodyInfo.ammo_type or Metadata.ammo_label or GetAmmoInfo(BodyInfo.weapon_hash).Label
	local KillerIdentity = BodyInfo.killer_passport and IML_GetIdentity(BodyInfo.killer_passport) or nil

	local Findings = {
		"Exame externo e interno realizados.",
		"Causa da morte: " .. (BodyInfo.cause or "Indeterminada"),
		"Coleta de material biológico para confirmação de DNA."
	}

	if BodyInfo.weapon_hash and BodyInfo.weapon_hash ~= 0 then
		Findings[#Findings + 1] = "Projétil compatível com: " .. WeaponName
		Findings[#Findings + 1] = "Calibre: " .. AmmoLabel
		if BodyInfo.weapon_serial then
			Findings[#Findings + 1] = "Serial da arma: " .. BodyInfo.weapon_serial
			local OwnerPassport, OwnerIdentity = IML_GetWeaponOwner(BodyInfo.weapon_serial)
			if OwnerIdentity then
				Findings[#Findings + 1] = "Arma registrada em nome de: " .. OwnerIdentity.Name .. " (#" .. OwnerPassport .. ")"
			end
		end
	end

	if Metadata.bone_hit then
		Findings[#Findings + 1] = "Região do impacto fatal: " .. Metadata.bone_hit
	end

	if Metadata.headshot then
		Findings[#Findings + 1] = "Lesão craniana fatal confirmada."
	end

	if KillerIdentity then
		Findings[#Findings + 1] = "Indícios apontam autor: " .. KillerIdentity.Name .. " (Passaporte #" .. KillerIdentity.Passport .. ")"
	end

	return {
		type = "autopsy",
		victim = Identity,
		killer = KillerIdentity,
		cause_of_death = BodyInfo.cause,
		weapon = WeaponName,
		weapon_serial = BodyInfo.weapon_serial,
		ammo_type = BodyInfo.ammo_type,
		ammo_label = AmmoLabel,
		dna_code = Dna[1] and Dna[1].dna_code or "Não registrado",
		bone_hit = Metadata.bone_hit,
		distance = Metadata.distance,
		headshot = Metadata.headshot,
		findings = Findings,
		pathologist = IML_GetIdentity(Passport),
		timestamp = FormatTimestamp()
	}
end

function IML_AnalyzeEvidence(ItemData)
	local Result = {}
	local TypeInfo = Config.EvidenceTypes[ItemData.type] or {}

	if ItemData.type == "blood" or ItemData.type == "blood_pool" or ItemData.type == "blood_swab" then
		local TargetPassport = ItemData.passport or (ItemData.metadata and ItemData.metadata.victim)
		local Dna = TargetPassport and vRP.Query("iml/GetDna", { passport = TargetPassport })
		if Dna and Dna[1] then
			local Identity = IML_GetIdentity(TargetPassport)
			Result.match = true
			Result.message = string.format(Config.Lang.DnaMatch, Identity.Name, TargetPassport)
			Result.dna_code = Dna[1].dna_code
			Result.identity = Identity
			Result.blood_type = "O+"
		else
			Result.match = false
			Result.message = Config.Lang.DnaNoMatch
		end

	elseif ItemData.type == "fingerprint" then
		local Fp = vRP.Query("iml/GetFingerprint", { passport = ItemData.passport })
		if Fp[1] then
			local Identity = IML_GetIdentity(ItemData.passport)
			Result.match = true
			Result.message = string.format(Config.Lang.FingerprintMatch, Identity.Name, ItemData.passport)
			Result.fingerprint_hash = Fp[1].fingerprint_hash
			Result.identity = Identity
		else
			Result.match = false
			Result.message = Config.Lang.FingerprintNoMatch
		end

	elseif ItemData.type == "gsr" then
		local WeaponName = GetWeaponLabel(ItemData.weapon_hash)
		local Ammo = GetAmmoInfo(ItemData.weapon_hash)
		Result.match = true
		Result.weapon = WeaponName
		Result.ammo_label = Ammo.Label
		Result.message = string.format(Config.Lang.GsrMatch, WeaponName)
		if ItemData.passport then
			local Identity = IML_GetIdentity(ItemData.passport)
			Result.identity = Identity
			Result.message = Result.message .. " — Suspeito: " .. Identity.Name .. " (#" .. ItemData.passport .. ")"
		end

	elseif ItemData.type == "casing" or ItemData.type == "magazine" or ItemData.type == "bullet" or ItemData.type == "bullet_fragment" or ItemData.type == "vehicle_bullet" then
		Result = IML_BuildBallisticResult(ItemData.weapon_hash, ItemData.weapon_serial)
	end

	return Result, TypeInfo
end

-- Função global para criar evidência (usada por death.lua e main.lua)
function IML_CreateSceneEvidence(Data)
	local EvidenceId = IML_GenerateId("EVD")
	local WeaponSerial = Data.weapon_serial

	if Data.passport and Data.weapon_hash and not WeaponSerial then
		WeaponSerial = IML_GetOrCreateWeaponSerial(Data.passport, Data.weapon_hash)
	elseif not WeaponSerial then
		WeaponSerial = GenerateSerial()
	end

	local Evidence = {
		id = EvidenceId,
		type = Data.type,
		passport = Data.passport,
		weapon_hash = Data.weapon_hash,
		weapon_serial = WeaponSerial,
		coords = Data.coords,
		heading = Data.heading or 0.0,
		vehicle = Data.vehicle,
		collected = false,
		created = os.time(),
		metadata = Data.metadata or {}
	}

	SceneEvidence[EvidenceId] = Evidence

	vRP.Query("iml/InsertEvidence", {
		evidence_id = EvidenceId,
		type = Data.type,
		passport = Evidence.passport,
		weapon_hash = Evidence.weapon_hash,
		weapon_serial = WeaponSerial,
		coords = json.encode(Evidence.coords or {}),
		metadata = json.encode(Evidence.metadata)
	})

	IML_BroadcastCivil("iml-evidencias:SyncEvidence", Evidence)
	return EvidenceId
end
