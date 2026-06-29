-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-- Grupos com permissão (Creative Uncharted)
Config.Groups = {
	IML = { "IML", "Paramedico" },
	Police = { "Policia", "PC", "PRF", "BOPE", "GOT", "CORE" },
	AllForensic = { "IML", "Paramedico", "Policia", "PC", "PRF", "BOPE", "GOT", "CORE" }
}

-- Itens do inventário (ajuste conforme sua base)
Config.Items = {
	ForensicKit = "kitpericia",
	EvidenceBag = "saco-evidencia",
	LatexGloves = "luvas-latex",
	BodyBag = "saco-cadaver",
	Laudo = "laudo-pericial",
	DnaReport = "relatorio-dna",
	BulletReport = "relatorio-balistica"
}

-- Chances de gerar evidência (0-100)
Config.Chances = {
	Blood = 85,
	Fingerprint = 70,
	Casing = 95,
	Magazine = 40
}

-- Tempo de expiração das evidências na cena (segundos)
Config.EvidenceExpire = 3600

-- Cooldown entre geração de evidências por jogador (ms)
Config.EvidenceCooldown = 3000

-- Distância máxima para coletar evidência
Config.CollectDistance = 2.5

-- Máximo de evidências na cena por servidor
Config.MaxSceneEvidence = 200

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS DO IML
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Locations = {
	-- Mesa de análise forense
	Lab = {
		{ Coords = vec3(247.35, -1374.35, 39.53), Heading = 320.0, Label = "Laboratório Forense" },
		{ Coords = vec3(275.82, -1361.48, 24.53), Heading = 50.0, Label = "Laboratório Forense" }
	},

	-- Sala de autópsia
	Autopsy = {
		{ Coords = vec3(243.10, -1378.90, 39.53), Heading = 140.0, Label = "Sala de Autópsia" }
	},

	-- Armário de evidências (guardar/recuperar)
	Locker = {
		{ Coords = vec3(252.45, -1370.20, 39.53), Heading = 230.0, Label = "Armário de Evidências" }
	},

	-- Ponto de entrega de corpos
	BodyDrop = {
		{ Coords = vec3(240.55, -1380.75, 39.53), Heading = 50.0, Label = "Entrega de Corpos" }
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS NO MAPA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Blips = {
	Enabled = true,
	Coords = vec3(247.35, -1374.35, 39.53),
	Sprite = 153,
	Color = 1,
	Scale = 0.7,
	Label = "Instituto Médico Legal"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCADORES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Marker = {
	Type = 27,
	Size = vec3(0.6, 0.6, 0.6),
	Color = { r = 180, g = 30, b = 30, a = 180 },
	DrawDistance = 15.0,
	InteractDistance = 1.8
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TIPOS DE EVIDÊNCIA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.EvidenceTypes = {
	blood = {
		Label = "Amostra de Sangue",
		Icon = "🩸",
		Color = "#c0392b",
		Prop = "prop_blood_pool_01",
		RequiresKit = true
	},
	fingerprint = {
		Label = "Impressão Digital",
		Icon = "👆",
		Color = "#8e44ad",
		Prop = nil,
		RequiresKit = true
	},
	casing = {
		Label = "Cápsula de Projétil",
		Icon = "🔫",
		Color = "#d4ac0d",
		Prop = "prop_cs_cardbox_01",
		RequiresKit = true
	},
	magazine = {
		Label = "Pente Abandonado",
		Icon = "📦",
		Color = "#2c3e50",
		Prop = "w_pi_pistol_mag1",
		RequiresKit = true
	},
	bullet = {
		Label = "Projétil Impactado",
		Icon = "💥",
		Color = "#e67e22",
		Prop = nil,
		RequiresKit = true
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS (hash -> nome para laudo balístico)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Weapons = {
	[`WEAPON_PISTOL`] = "Pistola 9mm",
	[`WEAPON_COMBATPISTOL`] = "Pistola de Combate",
	[`WEAPON_APPISTOL`] = "Pistola AP",
	[`WEAPON_PISTOL50`] = "Desert Eagle",
	[`WEAPON_MICROSMG`] = "Micro SMG",
	[`WEAPON_SMG`] = "SMG",
	[`WEAPON_ASSAULTRIFLE`] = "Rifle de Assalto",
	[`WEAPON_CARBINERIFLE`] = "Carabina",
	[`WEAPON_PUMPSHOTGUN`] = "Shotgun",
	[`WEAPON_SAWNOFFSHOTGUN`] = "Shotgun Serrada",
	[`WEAPON_SNIPERRIFLE`] = "Rifle de Precisão",
	[`WEAPON_KNIFE`] = "Faca",
	[`WEAPON_MACHETE`] = "Machete"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGENS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	NotAuthorized = "Você não tem permissão para isso.",
	NeedKit = "Você precisa de um Kit de Perícia.",
	NeedGloves = "Use luvas de látex para não deixar impressões digitais.",
	EvidenceCollected = "Evidência coletada e lacrada no saco.",
	EvidenceAnalyzed = "Análise concluída. Laudo gerado.",
	NoEvidence = "Nenhuma evidência encontrada na cena.",
	BodyCollected = "Corpo acondicionado no saco mortuário.",
	BodyDelivered = "Corpo entregue ao IML para autópsia.",
	AutopsyDone = "Autópsia concluída. Laudo médico-legal emitido.",
	DnaMatch = "DNA compatível com: %s (Passaporte #%s)",
	DnaNoMatch = "DNA não encontrado na base de dados.",
	FingerprintMatch = "Digital compatível com: %s (Passaporte #%s)",
	FingerprintNoMatch = "Digital não encontrada na base de dados.",
	BallisticMatch = "Arma identificada: %s | Serial: %s",
	Cooldown = "Aguarde antes de realizar outra ação.",
	AlreadyCollected = "Esta evidência já foi coletada.",
	SceneFull = "Limite de evidências na cena atingido."
}
