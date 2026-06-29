-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

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

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
function IML_HasGroup(Passport, GroupList)
	for _, Permission in ipairs(GroupList) do
		if vRP.HasGroup(Passport, Permission) or vRP.HasService(Passport, Permission) then
			return true
		end
	end
	return false
end

function IML_Notify(Source, Type, Message)
	TriggerClientEvent("Notify", Source, Type, Message, false, 5000)
end

function IML_GetIdentity(Passport)
	local Identity = vRP.Identity(Passport)
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
