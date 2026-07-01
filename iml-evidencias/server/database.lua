-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

IML = IML or {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("iml/InsertEvidence", [[
	INSERT INTO iml_evidence (evidence_id, type, passport, weapon_hash, weapon_serial, coords, metadata, created_at)
	VALUES (@evidence_id, @type, @passport, @weapon_hash, @weapon_serial, @coords, @metadata, NOW())
]])

vRP.Prepare("iml/UpdateCollected", [[
	UPDATE iml_evidence SET collected_by = @collected_by, collected_at = NOW()
	WHERE evidence_id = @evidence_id
]])

vRP.Prepare("iml/UpdateAnalyzed", [[
	UPDATE iml_evidence SET analyzed = 1, analyzed_by = @analyzed_by, analyzed_at = NOW()
	WHERE evidence_id = @evidence_id
]])

vRP.Prepare("iml/GetEvidence", "SELECT * FROM iml_evidence WHERE evidence_id = @evidence_id LIMIT 1")

vRP.Prepare("iml/InsertReport", [[
	INSERT INTO iml_reports (report_id, type, victim_passport, author_passport, title, content, evidence_ids, created_at)
	VALUES (@report_id, @type, @victim_passport, @author_passport, @title, @content, @evidence_ids, NOW())
]])

vRP.Prepare("iml/GetReport", "SELECT * FROM iml_reports WHERE report_id = @report_id LIMIT 1")

vRP.Prepare("iml/InsertBody", [[
	INSERT INTO iml_bodies (body_id, victim_passport, victim_name, cause, collected_by, created_at)
	VALUES (@body_id, @victim_passport, @victim_name, @cause, @collected_by, NOW())
]])

vRP.Prepare("iml/UpdateBodyAutopsy", [[
	UPDATE iml_bodies SET autopsy_done = 1, autopsy_by = @autopsy_by, report_id = @report_id
	WHERE body_id = @body_id
]])

vRP.Prepare("iml/GetBody", "SELECT * FROM iml_bodies WHERE body_id = @body_id LIMIT 1")

vRP.Prepare("iml/GetFingerprint", "SELECT * FROM iml_fingerprints WHERE passport = @passport LIMIT 1")
vRP.Prepare("iml/GetFingerprintByHash", "SELECT * FROM iml_fingerprints WHERE fingerprint_hash = @fingerprint_hash LIMIT 1")
vRP.Prepare("iml/InsertFingerprint", "INSERT INTO iml_fingerprints (passport, fingerprint_hash) VALUES (@passport, @fingerprint_hash)")

vRP.Prepare("iml/GetDna", "SELECT * FROM iml_dna WHERE passport = @passport LIMIT 1")
vRP.Prepare("iml/GetDnaByCode", "SELECT * FROM iml_dna WHERE dna_code = @dna_code LIMIT 1")
vRP.Prepare("iml/InsertDna", "INSERT INTO iml_dna (passport, dna_code) VALUES (@passport, @dna_code)")

vRP.Prepare("iml/GetPendingBodies", "SELECT * FROM iml_bodies WHERE autopsy_done = 0 ORDER BY created_at DESC LIMIT 20")

vRP.Prepare("iml/InsertWeapon", [[
	INSERT INTO iml_weapon_registry (passport, weapon_hash, weapon_serial, ammo_type)
	VALUES (@passport, @weapon_hash, @weapon_serial, @ammo_type)
]])

vRP.Prepare("iml/GetWeaponBySerial", "SELECT * FROM iml_weapon_registry WHERE weapon_serial = @weapon_serial LIMIT 1")
vRP.Prepare("iml/GetWeaponsByPassport", "SELECT * FROM iml_weapon_registry WHERE passport = @passport")

vRP.Prepare("iml/InsertDeathRecord", [[
	INSERT INTO iml_death_records (record_id, victim_passport, killer_passport, weapon_hash, weapon_serial, ammo_type, ammo_label, cause_of_death, bone_hit, distance, headshot, coords, time_of_death)
	VALUES (@record_id, @victim_passport, @killer_passport, @weapon_hash, @weapon_serial, @ammo_type, @ammo_label, @cause_of_death, @bone_hit, @distance, @headshot, @coords, NOW())
]])

vRP.Prepare("iml/GetDeathByVictim", "SELECT * FROM iml_death_records WHERE victim_passport = @victim_passport AND bagged = 0 ORDER BY id DESC LIMIT 1")
vRP.Prepare("iml/GetDeathByRecord", "SELECT * FROM iml_death_records WHERE record_id = @record_id LIMIT 1")
vRP.Prepare("iml/UpdateDeathBagged", "UPDATE iml_death_records SET bagged = 1 WHERE record_id = @record_id")
vRP.Prepare("iml/UpdateDeathExamined", "UPDATE iml_death_records SET examined = 1 WHERE record_id = @record_id")

vRP.Prepare("iml/InsertBodyFull", [[
	INSERT INTO iml_bodies (body_id, victim_passport, victim_name, cause, killer_passport, weapon_hash, weapon_serial, ammo_type, metadata, collected_by, created_at)
	VALUES (@body_id, @victim_passport, @victim_name, @cause, @killer_passport, @weapon_hash, @weapon_serial, @ammo_type, @metadata, @collected_by, NOW())
]])

vRP.Prepare("iml/InsertCase", [[
	INSERT INTO iml_cases (case_id, title, notes, author_passport, status, created_at)
	VALUES (@case_id, @title, @notes, @author_passport, @status, NOW())
]])

vRP.Prepare("iml/GetCases", "SELECT * FROM iml_cases ORDER BY created_at DESC LIMIT 50")

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
function IML_HasGroup(Passport, GroupList)
	for _, Permission in ipairs(GroupList) do
		if Config.RequireService then
			if vRP.HasService(Passport, Permission) then
				return true
			end
		end

		if vRP.HasGroup(Passport, Permission) then
			return true
		end
	end

	return false
end

function IML_Notify(Source, Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.important
	TriggerClientEvent("Notify", Source, Info.Title, Message, Info.Color, Duration or 5000)
end

function IML_ConsumeItem(Passport, ItemName, FromItemUse)
	if not Passport or not ItemName then
		return false
	end

	if vRP.ItemAmount(Passport, ItemName) >= 1 then
		vRP.TakeItem(Passport, ItemName, 1, true)
		return true
	end

	if FromItemUse then
		return true
	end

	return false
end

function IML_GetIdentity(Passport)
	local Name = vRP.FullName(Passport)
	local Identity = vRP.Identity(Passport)

	if Name and Name ~= "" then
		return {
			Passport = Passport,
			Name = Name,
			Phone = Identity and (Identity.phone or Identity.Phone) or "N/A"
		}
	end

	if Identity then
		return {
			Passport = Passport,
			Name = (Identity.name or Identity.Name or "Desconhecido") .. " " .. (Identity.name2 or Identity.Lastname or ""),
			Phone = Identity.phone or Identity.Phone or "N/A"
		}
	end

	return { Passport = Passport, Name = "Desconhecido", Phone = "N/A" }
end

function IML_EnsureBiometrics(Passport)
	local Fingerprint = vRP.Query("iml/GetFingerprint", { passport = Passport })
	if not Fingerprint[1] then
		local Hash = "FP-" .. GenerateSerial()
		vRP.Query("iml/InsertFingerprint", { passport = Passport, fingerprint_hash = Hash })
	end

	local Dna = vRP.Query("iml/GetDna", { passport = Passport })
	if not Dna[1] then
		local Code = GenerateDnaCode(Passport)
		vRP.Query("iml/InsertDna", { passport = Passport, dna_code = Code })
	end
end

function IML_GenerateId(Prefix)
	return Prefix .. "-" .. os.time() .. "-" .. math.random(1000, 9999)
end

function IML_GetCivilSources()
	local List = {}
	local Players = vRP.Players()

	if Players then
		for Passport, Source in pairs(Players) do
			if Source and IML_HasGroup(Passport, Config.Groups.Civil) and not List[Source] then
				List[Source] = true
			end
		end
	end

	local Result = {}
	for Source in pairs(List) do
		Result[#Result + 1] = Source
	end

	return Result
end

function IML_BroadcastCivil(Event, ...)
	local Payload = { ... }

	for _, Source in ipairs(IML_GetCivilSources()) do
		TriggerClientEvent(Event, Source, table.unpack(Payload))
	end
end