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
local PlayerCooldowns = {}
local CollectedBodies = {}
local PlayerGSR = {}

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
-- BIOMETRIA AO CONECTAR
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, Source)
	IML_EnsureBiometrics(Passport)
end)

AddEventHandler("CharacterChosen", function(Passport, Source)
	IML_EnsureBiometrics(Passport)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTRO DE ARMA ATIVA (SERIAL BALÍSTICO)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:RegisterWeapon")
AddEventHandler("iml-evidencias:RegisterWeapon", function(WeaponHash)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not WeaponHash or WeaponHash == 0 then return end

	local Serial = IML_GetOrCreateWeaponSerial(Passport, WeaponHash)
	TriggerClientEvent("iml-evidencias:SetWeaponSerial", Source, WeaponHash, Serial)
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
	if Count >= Config.MaxSceneEvidence then
		return
	end

	if not Data.passport then
		Data.passport = Passport
	end

	if Data.weapon_hash and not Data.weapon_serial then
		Data.weapon_serial = IML_GetOrCreateWeaponSerial(Passport, Data.weapon_hash)
	end

	-- GSR fica no jogador, não na cena
	if Data.type == "gsr" then
		PlayerGSR[Passport] = {
			weapon_hash = Data.weapon_hash,
			weapon_serial = Data.weapon_serial,
			timestamp = os.time()
		}
		return
	end

	IML_CreateSceneEvidence(Data)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MORTE DO JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:PlayerDied")
AddEventHandler("iml-evidencias:PlayerDied", function(Data)
	local Source = source
	local VictimPassport = vRP.Passport(Source)
	if not VictimPassport or not Data then return end

	local KillerPassport = nil
	local KillerName = nil

	if Data.killer_source and Data.killer_source > 0 then
		KillerPassport = vRP.Passport(Data.killer_source)
		if KillerPassport then
			KillerName = IML_GetIdentity(KillerPassport).Name
		end
	end

	local VictimName = IML_GetIdentity(VictimPassport).Name
	local WeaponSerial = nil

	if KillerPassport and Data.weapon_hash and Data.weapon_hash ~= 0 then
		WeaponSerial = IML_GetOrCreateWeaponSerial(KillerPassport, Data.weapon_hash)
	end

	IML_RegisterDeath({
		victim_passport = VictimPassport,
		victim_name = VictimName,
		killer_passport = KillerPassport,
		killer_name = KillerName,
		weapon_hash = Data.weapon_hash,
		weapon_serial = WeaponSerial,
		cause_of_death = GetDeathCause(Data.weapon_hash),
		bone_hit = Data.bone_hit,
		distance = Data.distance,
		headshot = Data.headshot,
		coords = Data.coords
	})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SINCRONIZAR CENA
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.RequestScene()
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

function IML.RequestCorpses()
	local List = {}
	local Now = os.time()

	for Id, Corpse in pairs(SceneCorpses) do
		if not Corpse.bagged and Corpse.time_of_death_raw and (Now - Corpse.time_of_death_raw) < Config.CorpseExpire then
			List[#List + 1] = Corpse
		end
	end

	return List
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR EVIDÊNCIA
-----------------------------------------------------------------------------------------------------------------------------------------
local function StoreEvidenceBag(Passport, EvidenceId, ItemData)
	local Stored = vRP.UserData(Passport, "iml_evidence_bags") or {}
	if type(Stored) == "string" then Stored = json.decode(Stored) or {} end
	Stored[EvidenceId] = ItemData
	vRP.setUData(Passport, "iml_evidence_bags", json.encode(Stored))
end

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
		metadata = Evidence.metadata,
		collected_by = Passport,
		collected_at = FormatTimestamp()
	}

	vRP.GenerateItem(Passport, Config.Items.EvidenceBag, 1, true)
	StoreEvidenceBag(Passport, EvidenceId, ItemData)

	TriggerClientEvent("iml-evidencias:RemoveEvidence", -1, EvidenceId)
	IML_Notify(Source, "success", Config.Lang.EvidenceCollected)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR SANGUE DO CADÁVER (SWAB)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:CollectBloodSwab")
AddEventHandler("iml-evidencias:CollectBloodSwab", function(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)
	local VictimPassport = type(TargetSource) == "number" and vRP.Passport(TargetSource) or TargetSource
	if not Passport or not VictimPassport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	if vRP.ItemAmount(Passport, Config.Items.BloodSwab) < 1 then
		IML_Notify(Source, "negado", Config.Lang.NeedSwab)
		return
	end

	vRP.TakeItem(Passport, Config.Items.BloodSwab, 1, true)

	local EvidenceId = IML_GenerateId("SWAB")
	local Record = IML_GetDeathRecord(VictimPassport)
	local TypeInfo = Config.EvidenceTypes.blood_swab

	local ItemData = {
		evidence_id = EvidenceId,
		type = "blood_swab",
		label = TypeInfo.Label,
		passport = VictimPassport,
		metadata = { victim = VictimPassport, record_id = Record and Record.record_id },
		collected_by = Passport,
		collected_at = FormatTimestamp()
	}

	vRP.GenerateItem(Passport, Config.Items.EvidenceBag, 1, true)
	StoreEvidenceBag(Passport, EvidenceId, ItemData)

	IML_Notify(Source, "success", Config.Lang.BloodSwabCollected)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR GSR DE SUSPEITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:CollectGSR")
AddEventHandler("iml-evidencias:CollectGSR", function(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)
	local TargetPassport = vRP.Passport(TargetSource)

	if not Passport or not TargetPassport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	if vRP.ItemAmount(Passport, Config.Items.GsrKit) < 1 then
		IML_Notify(Source, "negado", "Você precisa de um Kit GSR.")
		return
	end

	local GsrData = PlayerGSR[TargetPassport]
	if not GsrData or (os.time() - GsrData.timestamp) > 1800 then
		IML_Notify(Source, "negado", "Nenhum resíduo de pólvora detectado.")
		return
	end

	vRP.TakeItem(Passport, Config.Items.GsrKit, 1, true)

	local EvidenceId = IML_GenerateId("GSR")
	local ItemData = {
		evidence_id = EvidenceId,
		type = "gsr",
		label = Config.EvidenceTypes.gsr.Label,
		passport = TargetPassport,
		weapon_hash = GsrData.weapon_hash,
		weapon_serial = GsrData.weapon_serial,
		collected_by = Passport,
		collected_at = FormatTimestamp()
	}

	vRP.GenerateItem(Passport, Config.Items.EvidenceBag, 1, true)
	StoreEvidenceBag(Passport, EvidenceId, ItemData)
	PlayerGSR[TargetPassport] = nil

	IML_Notify(Source, "success", Config.Lang.GsrCollected)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERICIAR CORPO (EXAME PRELIMINAR)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iml-evidencias:ExamineCorpse")
AddEventHandler("iml-evidencias:ExamineCorpse", function(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)
	local VictimPassport = type(TargetSource) == "number" and vRP.Passport(TargetSource) or TargetSource
	if not Passport or not VictimPassport then return end

	if not IML.CanCollect(Passport) then
		IML_Notify(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	if vRP.ItemAmount(Passport, Config.Items.ForensicKit) < 1 then
		IML_Notify(Source, "negado", Config.Lang.NeedKit)
		return
	end

	local Record = IML_GetDeathRecord(VictimPassport)
	if not Record then
		IML_Notify(Source, "negado", "Dados forenses do cadáver não encontrados.")
		return
	end

	local Exam = IML_BuildCorpseExam(Record)
	if Record.record_id then
		vRP.Query("iml/UpdateDeathExamined", { record_id = Record.record_id })
	end

	TriggerClientEvent("iml-evidencias:OpenReport", Source, Exam, "Perícia Preliminar do Cadáver")
	IML_Notify(Source, "success", Config.Lang.CorpseExamined)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANALISAR EVIDÊNCIA
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

	local Result, TypeInfo = IML_AnalyzeEvidence(ItemData)

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
AddEventHandler("iml-evidencias:CollectBody", function(TargetSource)
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
		IML_Notify(Source, "negado", Config.Lang.CorpseAlreadyBagged)
		return
	end

	vRP.TakeItem(Passport, Config.Items.BodyBag, 1, true)

	local BodyId = IML_GenerateId("BODY")
	local Identity = IML_GetIdentity(TargetPassport)
	local Record = IML_GetDeathRecord(TargetPassport)

	local BodyInfo = {
		body_id = BodyId,
		victim_passport = TargetPassport,
		victim_name = Identity.Name,
		cause = Record and Record.cause_of_death or "Causa indeterminada",
		killer_passport = Record and Record.killer_passport,
		weapon_hash = Record and Record.weapon_hash,
		weapon_serial = Record and Record.weapon_serial,
		ammo_type = Record and Record.ammo_type,
		metadata = Record and {
			bone_hit = Record.bone_hit,
			distance = Record.distance,
			headshot = Record.headshot,
			ammo_label = Record.ammo_label,
			record_id = Record.record_id
		} or {},
		collected_by = Passport
	}

	CollectedBodies[TargetPassport] = BodyInfo

	local BodyData = vRP.UserData(Passport, "iml_bodies") or {}
	if type(BodyData) == "string" then BodyData = json.decode(BodyData) or {} end
	BodyData[BodyId] = BodyInfo
	vRP.setUData(Passport, "iml_bodies", json.encode(BodyData))

	if Record and Record.record_id then
		vRP.Query("iml/UpdateDeathBagged", { record_id = Record.record_id })
		Record.bagged = true
		SceneCorpses[Record.record_id] = nil
	end

	IML_Notify(Source, "success", Config.Lang.BodyCollected)
	TriggerClientEvent("iml-evidencias:BodyCollected", TargetSource)
	TriggerClientEvent("iml-evidencias:RemoveCorpse", -1, TargetPassport)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR CORPO
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

	vRP.Query("iml/InsertBodyFull", {
		body_id = BodyId,
		victim_passport = Body.victim_passport,
		victim_name = Body.victim_name,
		cause = Body.cause,
		killer_passport = Body.killer_passport,
		weapon_hash = Body.weapon_hash,
		weapon_serial = Body.weapon_serial,
		ammo_type = Body.ammo_type,
		metadata = json.encode(Body.metadata or {}),
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

	local ReportContent = IML_BuildAutopsyReport(Body[1], Passport)
	local ReportId = IML_GenerateId("AUT")

	vRP.Query("iml/InsertReport", {
		report_id = ReportId,
		type = "autopsy",
		victim_passport = Body[1].victim_passport,
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
-- TUNNEL GETTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function IML.GetPendingBodies()
	return vRP.Query("iml/GetPendingBodies", {}) or {}
end

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
-- LIMPEZA
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

		for Id, Corpse in pairs(SceneCorpses) do
			if Corpse.time_of_death_raw and (Now - Corpse.time_of_death_raw) >= Config.CorpseExpire then
				SceneCorpses[Id] = nil
				TriggerClientEvent("iml-evidencias:RemoveCorpse", -1, Corpse.victim_passport)
			end
		end
	end
end)

AddEventHandler("playerDropped", function()
	PlayerCooldowns[source] = nil
end)
