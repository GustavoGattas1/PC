-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

Config.Groups = {
	Civil = { "Civil" }
}

Config.RequireService = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	success = { Title = "Sucesso", Color = "verde" },
	negado = { Title = "Negado", Color = "vermelho" },
	important = { Title = "Atenção", Color = "amarelo" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Items = {
	ForensicKit = "kitpericia",
	EvidenceBag = "sacoevidencia",
	LatexGloves = "luvaslatex",
	BodyBag = "sacocadaver",
	BloodSwab = "swabsangue",
	GsrKit = "kitgsr",
	Laudo = "laudopericial",
	DnaReport = "relatoriodna",
	BulletReport = "relatoriobalistica",
	ForensicTablet = "tabletforense",
	GsrScanner = "scannergsr",
	EvidenceMarker = "marcadorevidencia",
	PoliceTape = "fitapolicial",
	TireMold = "moldepneu"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANCES E LIMITES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Chances = {
	Blood = 90,
	BloodPool = 100,
	Fingerprint = 75,
	Casing = 98,
	Magazine = 35,
	BulletImpact = 90,
	GSR = 90,
	VehicleBullet = 75,
	TireTrack = 80,
	DnaDrop = 40
}

Config.EvidenceExpire = 7200
Config.CorpseExpire = 3600
Config.CollectDistance = 2.5
Config.CorpseDistance = 3.0
Config.MaxSceneEvidence = 400
Config.MaxMarkers = 25
Config.MaxTapeSegments = 40

Config.EvidenceCooldown = {
	default = 400,
	casing = 80,
	magazine = 800,
	bullet = 200,
	bullet_fragment = 200,
	vehicle_bullet = 300,
	blood = 600,
	blood_pool = 0,
	fingerprint = 1500,
	tire_track = 1200,
	gsr = 0
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESPAÇAMENTO ENTRE EVIDÊNCIAS (evitar empilhar no mesmo ponto)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.EvidenceSpread = {
	MinDistance = 1.0,
	Casing = { Min = 0.6, Max = 1.8 },
	Blood = { Min = 0.5, Max = 2.0 },
	Bullet = { Min = 0.3, Max = 1.2 },
	TireTrack = { Min = 1.5, Max = 3.5 },
	Dna = { Min = 0.4, Max = 1.5 },
	Default = { Min = 0.5, Max = 1.5 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPERATURA CORPORAL (segundos desde o óbito)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.BodyTemperature = {
	{ MaxSeconds = 300, Label = "Quente", Color = "#e74c3c", Description = "Corpo ainda quente — óbito muito recente" },
	{ MaxSeconds = 1800, Label = "Morno", Color = "#f39c12", Description = "Corpo em resfriamento — óbito recente" },
	{ MaxSeconds = 7200, Label = "Frio", Color = "#3498db", Description = "Corpo frio — óbito há algum tempo" },
	{ MaxSeconds = 999999, Label = "Gelado", Color = "#5dade2", Description = "Rigor mortis avançado — corpo gelado" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LANTERNA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Flashlight = {
	Weapon = `WEAPON_FLASHLIGHT`,
	RequireAiming = false,
	DrawDistance = 30.0
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- OVERLAY DE CENA DO CRIME
-----------------------------------------------------------------------------------------------------------------------------------------
Config.SceneOverlay = {
	Enabled = true,
	Key = 244,
	Command = "cena",
	DrawDistance = 50.0,
	ShowIcons = true,
	ShowProps = true,
	ShowHud = true,
	ShowBallisticsTrace = true,
	TraceDistance = 25.0,
	PulseSpeed = 2.0
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA (animação + progresso estilo Pluto Dev)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Collection = {
	UseProgress = true,
	ProgressDuration = 2500,
	UseMinigameAfter = true,
	AnimDict = "random@domestic",
	AnimName = "pickup_low"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET / PROPS DE CENA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Tablet = {
	Prop = `prop_cs_tablet`,
	AnimDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base",
	AnimName = "base"
}

Config.SceneProps = {
	Marker = `prop_roadcone02a`,
	Tape = `prop_barrier_work06`
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS 3D
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Props = {
	casing = { Model = `w_pi_singleshot_shell`, Scale = 1.0 },
	magazine = { Model = `w_pi_singleshot_shell`, Scale = 1.2 },
	bullet = { Model = `w_pi_flaregun_shell`, Scale = 0.8 },
	bullet_fragment = { Model = `w_pi_flaregun_shell`, Scale = 0.6 },
	blood = { Model = `p_bloodsplat_s`, Scale = 0.5 },
	blood_pool = { Model = `p_bloodsplat_s`, Scale = 1.2 },
	fingerprint = { Model = `prop_cs_r_business_card`, Scale = 0.3 },
	tire_track = { Model = `prop_roadcone02a`, Scale = 0.3 },
	vehicle_bullet = { Model = `prop_cs_cardbox_01`, Scale = 0.2 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS DO IML
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Locations = {
	Lab = {
		{ Coords = vec3(247.35, -1374.35, 39.53), Heading = 320.0, Label = "Laboratório Forense" },
		{ Coords = vec3(275.82, -1361.48, 24.53), Heading = 50.0, Label = "Laboratório Forense" }
	},
	Autopsy = {
		{ Coords = vec3(243.10, -1378.90, 39.53), Heading = 140.0, Label = "Sala de Autópsia" }
	},
	Locker = {
		{ Coords = vec3(252.45, -1370.20, 39.53), Heading = 230.0, Label = "Armário de Evidências" }
	},
	BodyDrop = {
		{ Coords = vec3(240.55, -1380.75, 39.53), Heading = 50.0, Label = "Entrega de Corpos" }
	},
	Ballistics = {
		{ Coords = vec3(249.80, -1372.10, 39.53), Heading = 320.0, Label = "Perícia Balística" }
	}
}

Config.Blips = {
	Enabled = true,
	Coords = vec3(247.35, -1374.35, 39.53),
	Sprite = 153,
	Color = 1,
	Scale = 0.7,
	Label = "Instituto Médico Legal"
}

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
	blood = { Label = "Amostra de Sangue", Icon = "🩸", Color = "#c0392b", Minigame = "swab" },
	blood_pool = { Label = "Poça de Sangue", Icon = "🩸", Color = "#922b21", Minigame = "swab" },
	blood_swab = { Label = "Swab de Sangue (Cadáver)", Icon = "🧪", Color = "#c0392b" },
	fingerprint = { Label = "Impressão Digital", Icon = "👆", Color = "#8e44ad", Minigame = "pickup" },
	dna = { Label = "Amostra de DNA", Icon = "🧬", Color = "#9b59b6", Minigame = "swab" },
	casing = { Label = "Cápsula de Projétil", Icon = "🔫", Color = "#d4ac0d", Minigame = "bag" },
	magazine = { Label = "Pente Abandonado", Icon = "📦", Color = "#2c3e50", Minigame = "bag" },
	bullet = { Label = "Projétil Impactado", Icon = "💥", Color = "#e67e22", Minigame = "bag" },
	bullet_fragment = { Label = "Fragmento de Projétil", Icon = "💥", Color = "#ca6f1e", Minigame = "bag" },
	gsr = { Label = "Resíduo de Pólvora (GSR)", Icon = "🧤", Color = "#566573" },
	vehicle_bullet = { Label = "Marca de Tiro em Veículo", Icon = "🚗", Color = "#1a5276", Minigame = "pickup" },
	tire_track = { Label = "Rastro de Pneu", Icon = "🛞", Color = "#566573", Minigame = "mold" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Weapons = {
	[`WEAPON_PISTOL`] = "Pistola 9mm",
	[`WEAPON_COMBATPISTOL`] = "Pistola de Combate",
	[`WEAPON_APPISTOL`] = "Pistola AP",
	[`WEAPON_PISTOL50`] = "Desert Eagle .50",
	[`WEAPON_SNSPISTOL`] = "Pistola SNS",
	[`WEAPON_HEAVYPISTOL`] = "Pistola Pesada",
	[`WEAPON_VINTAGEPISTOL`] = "Pistola Vintage",
	[`WEAPON_MICROSMG`] = "Micro SMG",
	[`WEAPON_SMG`] = "SMG",
	[`WEAPON_ASSAULTSMG`] = "SMG de Assalto",
	[`WEAPON_MACHINEPISTOL`] = "Pistola Metralhadora",
	[`WEAPON_ASSAULTRIFLE`] = "Rifle de Assalto",
	[`WEAPON_CARBINERIFLE`] = "Carabina",
	[`WEAPON_ADVANCEDRIFLE`] = "Rifle Avançado",
	[`WEAPON_SPECIALCARBINE`] = "Carabina Especial",
	[`WEAPON_BULLPUPRIFLE`] = "Rifle Bullpup",
	[`WEAPON_PUMPSHOTGUN`] = "Shotgun",
	[`WEAPON_SAWNOFFSHOTGUN`] = "Shotgun Serrada",
	[`WEAPON_ASSAULTSHOTGUN`] = "Shotgun de Assalto",
	[`WEAPON_SNIPERRIFLE`] = "Rifle de Precisão",
	[`WEAPON_HEAVYSNIPER`] = "Sniper Pesado",
	[`WEAPON_KNIFE`] = "Faca",
	[`WEAPON_MACHETE`] = "Machete",
	[`WEAPON_SWITCHBLADE`] = "Canivete",
	[`WEAPON_BAT`] = "Taco de Baseball",
	[`WEAPON_CROWBAR`] = "Pé de Cabra",
	[`WEAPON_UNARMED`] = "Desarmado / Socos"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MUNIÇÃO / CALIBRE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.AmmoTypes = {
	[`WEAPON_PISTOL`] = { Type = "9mm", Label = "9x19mm Parabellum", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_COMBATPISTOL`] = { Type = "9mm", Label = "9x19mm Parabellum", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_APPISTOL`] = { Type = "9mm", Label = "9x19mm AP", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_PISTOL50`] = { Type = ".50", Label = ".50 AE", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_SNSPISTOL`] = { Type = ".22", Label = ".22 LR", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_HEAVYPISTOL`] = { Type = ".45", Label = ".45 ACP", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_VINTAGEPISTOL`] = { Type = "9mm", Label = "9x19mm Vintage", Category = "Pistola", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_MICROSMG`] = { Type = "9mm", Label = "9x19mm SMG", Category = "Submetralhadora", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_SMG`] = { Type = "9mm", Label = "9x19mm SMG", Category = "Submetralhadora", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_ASSAULTSMG`] = { Type = "9mm", Label = "9x19mm Assault SMG", Category = "Submetralhadora", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_MACHINEPISTOL`] = { Type = "9mm", Label = "9x19mm Machine Pistol", Category = "Submetralhadora", CasingModel = `w_pi_singleshot_shell` },
	[`WEAPON_ASSAULTRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_CARBINERIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_ADVANCEDRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_SPECIALCARBINE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_BULLPUPRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_PUMPSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_SAWNOFFSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_ASSAULTSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_SNIPERRIFLE`] = { Type = ".308", Label = ".308 Winchester", Category = "Precisão", CasingModel = `w_pi_flaregun_shell` },
	[`WEAPON_HEAVYSNIPER`] = { Type = ".50", Label = ".50 BMG", Category = "Precisão", CasingModel = `w_pi_flaregun_shell` }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAUSA DA MORTE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.DeathCauses = {
	Firearm = "Hemorragia interna por projétil de arma de fogo",
	Shotgun = "Trauma penetrante por chumbo de shotgun",
	Sniper = "Lesão catastrófica por projétil de alta energia",
	Melee = "Trauma contuso / perfurante por arma branca",
	Unarmed = "Trauma contuso por agressão física",
	Unknown = "Causa da morte indeterminada"
}

Config.MeleeWeapons = {
	[`WEAPON_KNIFE`] = true,
	[`WEAPON_MACHETE`] = true,
	[`WEAPON_SWITCHBLADE`] = true,
	[`WEAPON_BAT`] = true,
	[`WEAPON_CROWBAR`] = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- OSSOS / REGIÃO DO IMPACTO (painel 3D)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.BoneLabels = {
	[31086] = "Cabeça",
	[39317] = "Pescoço",
	[24818] = "Tórax",
	[24817] = "Abdômen",
	[11816] = "Pelve",
	[57005] = "Braço Direito",
	[18905] = "Braço Esquerdo",
	[40269] = "Braço Direito",
	[45509] = "Braço Esquerdo",
	[36864] = "Perna Direita",
	[63931] = "Perna Esquerda",
	[51826] = "Perna Direita",
	[58271] = "Perna Esquerda",
	[28422] = "Mão Direita",
	[60309] = "Mão Esquerda"
}

Config.BoneZones = {
	["Cabeça"] = "head",
	["Pescoço"] = "neck",
	["Tórax"] = "chest",
	["Abdômen"] = "abdomen",
	["Pelve"] = "pelvis",
	["Braço Direito"] = "arm_right",
	["Braço Esquerdo"] = "arm_left",
	["Mão Direita"] = "hand_right",
	["Mão Esquerda"] = "hand_left",
	["Perna Direita"] = "leg_right",
	["Perna Esquerda"] = "leg_left"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGENS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	NotAuthorized = "Apenas a Polícia Civil pode realizar esta ação.",
	NeedKit = "Você precisa de um Kit de Perícia.",
	NeedFlashlight = "Equipe a lanterna para localizar e coletar evidências.",
	NeedSwab = "Você precisa de um Swab de Sangue.",
	NeedGloves = "Use luvas de látex para não deixar impressões digitais.",
	EvidenceCollected = "Evidência coletada e lacrada no saco.",
	EvidenceAnalyzed = "Análise concluída. Laudo gerado.",
	NoEvidence = "Nenhuma evidência encontrada.",
	BodyCollected = "Corpo acondicionado no saco mortuário.",
	BodyDelivered = "Corpo entregue ao IML para autópsia.",
	AutopsyDone = "Autópsia concluída. Laudo médico-legal emitido.",
	DnaMatch = "DNA compatível com: %s (Passaporte #%s)",
	DnaNoMatch = "DNA não encontrado na base de dados.",
	FingerprintMatch = "Digital compatível com: %s (Passaporte #%s)",
	FingerprintNoMatch = "Digital não encontrada na base de dados.",
	BallisticMatch = "Arma: %s | Calibre: %s | Serial: %s",
	BallisticOwner = "Registro balístico vinculado a: %s (Passaporte #%s)",
	GsrMatch = "Resíduo de pólvora compatível com disparo recente de %s",
	Cooldown = "Aguarde antes de realizar outra ação.",
	AlreadyCollected = "Esta evidência já foi coletada.",
	SceneFull = "Limite de evidências na cena atingido.",
	CorpseExamined = "Perícia preliminar do corpo concluída.",
	BloodSwabCollected = "Amostra de sangue do cadáver coletada.",
	NoCorpse = "Nenhum cadáver encontrado nas proximidades.",
	CorpseAlreadyBagged = "Este corpo já foi acondicionado.",
	GsrCollected = "Amostra GSR coletada das mãos do suspeito.",
	GsrPositive = "GSR POSITIVO — disparo recente detectado.",
	GsrNegative = "GSR NEGATIVO — sem resíduo de pólvora.",
	OverlayOn = "Overlay de investigação ativado.",
	OverlayOff = "Overlay de investigação desativado.",
	MarkerPlaced = "Marcador de evidência posicionado.",
	TapePlaced = "Fita policial instalada.",
	MinigameFailed = "Coleta falhou — tente novamente.",
	MinigameSwabHint = "Arraste o cotonete e limpe o sangue",
	MinigameBagHint = "Coloque a cápsula no saco de evidência",
	CaseArchived = "Caso arquivado com sucesso.",
	ReportPrinted = "Laudo impresso no prancheta.",
	NeedBodyBag = "Você precisa de um saco mortuário.",
	NeedTablet = "Você precisa do tablet forense.",
	NeedScanner = "Você precisa do scanner GSR portátil.",
	PanelBusy = "Feche o painel aberto antes de abrir outro."
}
