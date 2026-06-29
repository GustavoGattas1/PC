-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
IML = {}
Tunnel.bindInterface("iml-evidencias", IML)
vCLIENT = Tunnel.getInterface("iml-evidencias")

-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local SceneEvidence = {}
local PlayerCooldowns = {}
local CollectedBodies = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.CanCollect(Passport)
	return IML_HasGroup(Passport, Config.Groups.AllForensic)
end

function IML.CanAnalyze(Passport)
	return IML_HasGroup(Passport, Config.Groups.AllForensic)
end

function IML.CanAutopsy(Passport)
	return IML_HasGroup(Passport, Config.Groups.IML)
end

function IML.CanDeliverBody(Passport)
	return IML_HasGroup(Passport, Config.Groups.AllForensic)
end

function IML.CheckPermission(Passport, PermissionType)
	if PermissionType == "collect" then return IML.CanCollect(Passport) end
	if PermissionType == "analyze" then return IML.CanAnalyze(Passport) end
	if PermissionType == "autopsy" then return IML.CanAutopsy(Passport) end
	if PermissionType == "body" then return IML.CanDeliverBody(Passport) end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckCooldown(Source, Key, Time)
	local Now = GetGameTimer()
	if PlayerCooldowns[Source] and PlayerCooldowns[Source][Key] and (Now - PlayerCooldowns[Source][Key]) < Time then
		return false
	end
	PlayerCooldowns[Source] = PlayerCooldowns[Source] or {}
	PlayerCooldowns[Source][Key] = Now
	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRAR BIOMETRIA AO CONECTAR
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, Source)
	IML_EnsureBiometrics(Passport)
end)

AddEventHandler("CharacterChosen", function(Passport, Source)
	IML_EnsureBiometrics(Passport)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR EVIDÊNCIA NA CENA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:CreateEvidence")
AddEventHandler("iml-evidencias:CreateEvidence", function(Data)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not Data or not Data.type then return end

	if not CheckCooldown(Source, "create_" .. Data.type, Config.EvidenceCooldown) then return end

	local Count = 0
	for _ in pairs(SceneEvidence) do Count = Count + 1 end
	if Count >= Config.MaxSceneEvidence then return end

	local EvidenceId = IML_GenerateId("EVD")
	local WeaponSerial = Data.weapon_serial or GenerateSerial()

	local Evidence = {
		id = EvidenceId,
		type = Data.type,
		passport = Data.passport or Passport,
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
		coords = json.encode(Evidence.coords),
		metadata = json.encode(Evidence.metadata)
	})

	TriggerClientEvent("iml-evidencias:SyncEvidence", -1, Evidence)
	DebugPrint("Evidência criada:", EvidenceId, Data.type)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SINCRONIZAR CENA PARA JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.RequestScene()
	local Source = source
	local List = {}
	local Now = os.time()

	for Id, Evidence in pairs(SceneEvidence) do
		if not Evidence.collected and (Now - Evidence.created) < Config.EvidenceExpire then
			List[#List + 1] = Evidence
		elseif (Now - Evidence.created) >= Config.EvidenceExpire then
			SceneEvidence[Id] = nil
		end
	end

	return List
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR EVIDÊNCIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:CollectEvidence")
AddEventHandler("iml-evidencias:CollectEvidence", function(EvidenceId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	if not CheckCooldown(Source, "collect", 1500) then
		IML_Notify(Source, "important", Config.Lang.Cooldown)
		return
	end

	if vRP.ItemAmount(Passport, Config.Items.ForensicKit) < 1 then
		IML_Notify(Source, "negado", Config.Lang.NeedKit)
		return
	end

	local Evidence = SceneEvidence[EvidenceId]
	if not Evidence or Evidence.collected then
		IML_Notify(Source, "negado", Config.Lang.AlreadyCollected)
		return
	end

	Evidence.collected = true
	SceneEvidence[EvidenceId] = nil

	vRP.Query("iml/UpdateCollected", { evidence_id = EvidenceId, collected_by = Passport })

	local TypeInfo = Config.EvidenceTypes[Evidence.type] or { Label = "Evidência" }
	local ItemData = {
		evidence_id = EvidenceId,
		type = Evidence.type,
		label = TypeInfo.Label,
		passport = Evidence.passport,
		weapon_hash = Evidence.weapon_hash,
		weapon_serial = Evidence.weapon_serial,
		collected_by = Passport,
		collected_at = FormatTimestamp()
	}

	vRP.GenerateItem(Passport, Config.Items.EvidenceBag, 1, true)
	vRP.GiveItem(Passport, Config.Items.EvidenceBag .. "-" .. EvidenceId, 1, true)

	-- Armazena metadata no playerdata
	local Stored = vRP.UserData(Passport, "iml_evidence_bags") or {}
	Stored[EvidenceId] = ItemData
	vRP.setUData(Passport, "iml_evidence_bags", json.encode(Stored))

	TriggerClientEvent("iml-evidencias:RemoveEvidence", -1, EvidenceId)
	IML_Notify(Source, "success", Config.Lang.EvidenceCollected)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANALISAR EVIDÊNCIA NO LABORATÓRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:AnalyzeEvidence")
AddEventHandler("iml-evidencias:AnalyzeEvidence", function(EvidenceId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	if not IML.CanAnalyze(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	local Stored = vRP.UserData(Passport, "iml_evidence_bags") or {}
	if type(Stored) == "string" then Stored = json.decode(Stored) or {} end

	local ItemData = Stored[EvidenceId]
	if not ItemData then
		IML_Notify(Source, "negado", "Evidência não encontrada no seu inventário.")
		return
	end

	vRP.Query("iml/UpdateAnalyzed", { evidence_id = EvidenceId, analyzed_by = Passport })

	local Result = {}
	local TypeInfo = Config.EvidenceTypes[ItemData.type] or {}

	if ItemData.type == "blood" then
		local Dna = vRP.Query("iml/GetDna", { passport = ItemData.passport })
		if Dna[1] then
			local Identity = IML_GetIdentity(ItemData.passport)
			Result.match = true
			Result.message = string.format(Config.Lang.DnaMatch, Identity.Name, ItemData.passport)
			Result.dna_code = Dna[1].dna_code
			Result.identity = Identity
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
	elseif ItemData.type == "casing" or ItemData.type == "magazine" or ItemData.type == "bullet" then
		local WeaponName = GetWeaponLabel(ItemData.weapon_hash or 0)
		Result.match = true
		Result.message = string.format(Config.Lang.BallisticMatch, WeaponName, ItemData.weapon_serial or "N/A")
		Result.weapon = WeaponName
		Result.serial = ItemData.weapon_serial
	end

	local ReportId = IML_GenerateId("RPT")
	local ReportContent = {
		evidence_id = EvidenceId,
		type = ItemData.type,
		label = TypeInfo.Label or "Evidência",
		analysis = Result,
		analyst = IML_GetIdentity(Passport),
		timestamp = FormatTimestamp()
	}

	local ReportTitle = "Laudo Pericial - " .. (TypeInfo.Label or ItemData.type)

	vRP.Query("iml/InsertReport", {
		report_id = ReportId,
		type = ItemData.type,
		victim_passport = ItemData.passport,
		author_passport = Passport,
		title = ReportTitle,
		content = json.encode(ReportContent),
		evidence_ids = EvidenceId
	})

	vRP.GenerateItem(Passport, Config.Items.Laudo, 1, true)

	local LaudoData = vRP.UserData(Passport, "iml_laudos") or {}
	if type(LaudoData) == "string" then LaudoData = json.decode(LaudoData) or {} end
	LaudoData[ReportId] = ReportContent
	vRP.setUData(Passport, "iml_laudos", json.encode(LaudoData))

	Stored[EvidenceId] = nil
	vRP.setUData(Passport, "iml_evidence_bags", json.encode(Stored))

	TriggerClientEvent("iml-evidencias:OpenReport", Source, ReportContent, ReportTitle)
	IML_Notify(Source, "success", Config.Lang.EvidenceAnalyzed)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR CORPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:CollectBody")
AddEventHandler("iml-evidencias:CollectBody", function(TargetSource, Cause)
	local Source = source
	local Passport = vRP.Passport(Source)
	local TargetPassport = vRP.Passport(TargetSource)

	if not Passport or not TargetPassport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	if vRP.ItemAmount(Passport, Config.Items.BodyBag) < 1 then
		IML_Notify(Source, "negado", "Você precisa de um saco mortuário.")
		return
	end

	if CollectedBodies[TargetPassport] then
		IML_Notify(Source, "negado", "Este corpo já foi acondicionado.")
		return
	end

	vRP.TakeItem(Passport, Config.Items.BodyBag, 1, true)

	local BodyId = IML_GenerateId("BODY")
	local Identity = IML_GetIdentity(TargetPassport)

	CollectedBodies[TargetPassport] = {
		body_id = BodyId,
		victim_passport = TargetPassport,
		victim_name = Identity.Name,
		cause = Cause or "Causa indeterminada",
		collected_by = Passport
	}

	local BodyData = vRP.UserData(Passport, "iml_bodies") or {}
	if type(BodyData) == "string" then BodyData = json.decode(BodyData) or {} end
	BodyData[BodyId] = CollectedBodies[TargetPassport]
	vRP.setUData(Passport, "iml_bodies", json.encode(BodyData))

	IML_Notify(Source, "success", Config.Lang.BodyCollected)
	TriggerClientEvent("iml-evidencias:BodyCollected", TargetSource)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR CORPO NO IML
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:DeliverBody")
AddEventHandler("iml-evidencias:DeliverBody", function(BodyId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	local BodyData = vRP.UserData(Passport, "iml_bodies") or {}
	if type(BodyData) == "string" then BodyData = json.decode(BodyData) or {} end

	local Body = BodyData[BodyId]
	if not Body then
		IML_Notify(Source, "negado", "Corpo não encontrado.")
		return
	end

	vRP.Query("iml/InsertBody", {
		body_id = BodyId,
		victim_passport = Body.victim_passport,
		victim_name = Body.victim_name,
		cause = Body.cause,
		collected_by = Body.collected_by
	})

	BodyData[BodyId] = nil
	vRP.setUData(Passport, "iml_bodies", json.encode(BodyData))

	IML_Notify(Source, "success", Config.Lang.BodyDelivered)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTÓPSIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:PerformAutopsy")
AddEventHandler("iml-evidencias:PerformAutopsy", function(BodyId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	if not IML.CanAutopsy(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	local Body = vRP.Query("iml/GetBody", { body_id = BodyId })
	if not Body[1] or Body[1].autopsy_done == 1 then
		IML_Notify(Source, "negado", "Corpo não disponível para autópsia.")
		return
	end

	local BodyInfo = Body[1]
	local Identity = IML_GetIdentity(BodyInfo.victim_passport)
	local Dna = vRP.Query("iml/GetDna", { passport = BodyInfo.victim_passport })

	local ReportId = IML_GenerateId("AUT")
	local ReportContent = {
		type = "autopsy",
		victim = Identity,
		cause_of_death = BodyInfo.cause,
		dna_code = Dna[1] and Dna[1].dna_code or "Não registrado",
		findings = {
			"Exame externo realizado.",
			"Coleta de material biológico para confirmação.",
			"Causa provável: " .. BodyInfo.cause
		},
		pathologist = IML_GetIdentity(Passport),
		timestamp = FormatTimestamp()
	}

	vRP.Query("iml/InsertReport", {
		report_id = ReportId,
		type = "autopsy",
		victim_passport = BodyInfo.victim_passport,
		author_passport = Passport,
		title = "Laudo Médico-Legal - Autópsia",
		content = json.encode(ReportContent),
		evidence_ids = BodyId
	})

	vRP.Query("iml/UpdateBodyAutopsy", {
		body_id = BodyId,
		autopsy_by = Passport,
		report_id = ReportId
	})

	vRP.GenerateItem(Passport, Config.Items.Laudo, 1, true)

	local LaudoData = vRP.UserData(Passport, "iml_laudos") or {}
	if type(LaudoData) == "string" then LaudoData = json.decode(LaudoData) or {} end
	LaudoData[ReportId] = ReportContent
	vRP.setUData(Passport, "iml_laudos", json.encode(LaudoData))

	TriggerClientEvent("iml-evidencias:OpenReport", Source, ReportContent, "Laudo Médico-Legal - Autópsia")
	IML_Notify(Source, "success", Config.Lang.AutopsyDone)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VISUALIZAR LAUDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:ViewReport")
AddEventHandler("iml-evidencias:ViewReport", function(ReportId)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	local LaudoData = vRP.UserData(Passport, "iml_laudos") or {}
	if type(LaudoData) == "string" then LaudoData = json.decode(LaudoData) or {} end

	local Report = LaudoData[ReportId]
	if not Report then
		local DbReport = vRP.Query("iml/GetReport", { report_id = ReportId })
		if DbReport[1] then
			Report = json.decode(DbReport[1].content)
		end
	end

	if Report then
		TriggerClientEvent("iml-evidencias:OpenReport", Source, Report, Report.title or "Laudo Pericial")
	else
		IML_Notify(Source, "negado", "Laudo não encontrado.")
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR CORPOS PENDENTES
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.GetPendingBodies()
	return vRP.Query("iml/GetPendingBodies", {}) or {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR CORPOS DO JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.GetMyBodies()
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return {} end

	local BodyData = vRP.UserData(Passport, "iml_bodies") or {}
	if type(BodyData) == "string" then BodyData = json.decode(BodyData) or {} end

	local List = {}
	for Id, Data in pairs(BodyData) do
		Data.body_id = Id
		List[#List + 1] = Data
	end
	return List
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR EVIDÊNCIAS DO JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.GetMyEvidence()
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport then return {} end

	local Stored = vRP.UserData(Passport, "iml_evidence_bags") or {}
	if type(Stored) == "string" then Stored = json.decode(Stored) or {} end

	local List = {}
	for Id, Data in pairs(Stored) do
		List[#List + 1] = Data
	end
	return List
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA DE EVIDÊNCIAS EXPIRADAS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(60000)
		local Now = os.time()
		for Id, Evidence in pairs(SceneEvidence) do
			if (Now - Evidence.created) >= Config.EvidenceExpire then
				SceneEvidence[Id] = nil
				TriggerClientEvent("iml-evidencias:RemoveEvidence", -1, Id)
			end
		end
	end
end)

AddEventHandler("playerDropped", function()
	local Source = source
	PlayerCooldowns[Source] = nil
end)
