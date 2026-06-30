-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-- Grupo com permissão (apenas Polícia Civil)
Config.Groups = {
	Civil = { "Civil" }
}

-- true = só vê/coleta em serviço (padrão Creative / scripts de polícia)
Config.RequireService = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Items = {
	ForensicKit = "kitpericia",
	EvidenceBag = "saco-evidencia",
	LatexGloves = "luvas-latex",
	BodyBag = "saco-cadaver",
	BloodSwab = "swab-sangue",
	GsrKit = "kit-gsr",
	Laudo = "laudo-pericial",
	DnaReport = "relatorio-dna",
	BulletReport = "relatorio-balistica"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANCES E LIMITES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Chances = {
	Blood = 90,
	BloodPool = 100,
	Fingerprint = 75,
	Casing = 95,
	Magazine = 45,
	BulletImpact = 80,
	GSR = 85,
	VehicleBullet = 70
}

Config.EvidenceExpire = 7200
Config.CorpseExpire = 3600
Config.EvidenceCooldown = 2000
Config.CollectDistance = 2.5
Config.CorpseDistance = 3.0
Config.MaxSceneEvidence = 300

-----------------------------------------------------------------------------------------------------------------------------------------
-- LANTERNA (obrigatória para ver e coletar evidências)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Flashlight = {
	Weapon = `WEAPON_FLASHLIGHT`,
	RequireAiming = false,
	DrawDistance = 25.0
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
	blood = { Label = "Amostra de Sangue", Icon = "🩸", Color = "#c0392b" },
	blood_pool = { Label = "Poça de Sangue", Icon = "🩸", Color = "#922b21" },
	blood_swab = { Label = "Swab de Sangue (Cadáver)", Icon = "🧪", Color = "#c0392b" },
	fingerprint = { Label = "Impressão Digital", Icon = "👆", Color = "#8e44ad" },
	casing = { Label = "Cápsula de Projétil", Icon = "🔫", Color = "#d4ac0d" },
	magazine = { Label = "Pente Abandonado", Icon = "📦", Color = "#2c3e50" },
	bullet = { Label = "Projétil Impactado", Icon = "💥", Color = "#e67e22" },
	bullet_fragment = { Label = "Fragmento de Projétil", Icon = "💥", Color = "#ca6f1e" },
	gsr = { Label = "Resíduo de Pólvora (GSR)", Icon = "🧤", Color = "#566573" },
	vehicle_bullet = { Label = "Marca de Tiro em Veículo", Icon = "🚗", Color = "#1a5276" }
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
-- MUNIÇÃO / CALIBRE POR ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.AmmoTypes = {
	[`WEAPON_PISTOL`] = { Type = "9mm", Label = "9x19mm Parabellum", Category = "Pistola" },
	[`WEAPON_COMBATPISTOL`] = { Type = "9mm", Label = "9x19mm Parabellum", Category = "Pistola" },
	[`WEAPON_APPISTOL`] = { Type = "9mm", Label = "9x19mm AP", Category = "Pistola" },
	[`WEAPON_PISTOL50`] = { Type = ".50", Label = ".50 AE", Category = "Pistola" },
	[`WEAPON_SNSPISTOL`] = { Type = ".22", Label = ".22 LR", Category = "Pistola" },
	[`WEAPON_HEAVYPISTOL`] = { Type = ".45", Label = ".45 ACP", Category = "Pistola" },
	[`WEAPON_VINTAGEPISTOL`] = { Type = "9mm", Label = "9x19mm Vintage", Category = "Pistola" },
	[`WEAPON_MICROSMG`] = { Type = "9mm", Label = "9x19mm SMG", Category = "Submetralhadora" },
	[`WEAPON_SMG`] = { Type = "9mm", Label = "9x19mm SMG", Category = "Submetralhadora" },
	[`WEAPON_ASSAULTSMG`] = { Type = "9mm", Label = "9x19mm Assault SMG", Category = "Submetralhadora" },
	[`WEAPON_MACHINEPISTOL`] = { Type = "9mm", Label = "9x19mm Machine Pistol", Category = "Submetralhadora" },
	[`WEAPON_ASSAULTRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle" },
	[`WEAPON_CARBINERIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle" },
	[`WEAPON_ADVANCEDRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle" },
	[`WEAPON_SPECIALCARBINE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle" },
	[`WEAPON_BULLPUPRIFLE`] = { Type = "5.56", Label = "5.56x45mm NATO", Category = "Rifle" },
	[`WEAPON_PUMPSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun" },
	[`WEAPON_SAWNOFFSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun" },
	[`WEAPON_ASSAULTSHOTGUN`] = { Type = "12ga", Label = "Calibre 12", Category = "Shotgun" },
	[`WEAPON_SNIPERRIFLE`] = { Type = ".308", Label = ".308 Winchester", Category = "Precisão" },
	[`WEAPON_HEAVYSNIPER`] = { Type = ".50", Label = ".50 BMG", Category = "Precisão" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAUSA DA MORTE POR TIPO DE ARMA
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
-- OSSOS / REGIÃO DO IMPACTO
-----------------------------------------------------------------------------------------------------------------------------------------
Config.BoneLabels = {
	[31086] = "Cabeça",
	[39317] = "Pescoço",
	[24818] = "Tórax",
	[24817] = "Abdômen",
	[11816] = "Pelve",
	[57005] = "Mão Direita",
	[18905] = "Mão Esquerda",
	[36864] = "Perna Direita",
	[63931] = "Perna Esquerda"
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
	GsrCollected = "Amostra GSR coletada das mãos do suspeito."
}
