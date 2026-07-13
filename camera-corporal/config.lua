-----------------------------------------------------------------------------------------------------------------------------------------
-- CÂMERA CORPORAL — CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES (grupos vRP com acesso à bodycam)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Groups = {
	"Policia",
	"PMERJ",
	"PRF",
	"BOPE",
	"Civil",
	"Federal",
	"GOT",
	"CORE"
}

-- Grupos que podem revisar gravações de outros oficiais (supervisores)
Config.SupervisorGroups = {
	"Comando",
	"SubComando",
	"Coronel",
	"TenenteCoronel",
	"Major",
	"Capitao",
	"Delegado",
	"Admin"
}

Config.RequireService = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS E TECLAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Command = "bodycam"
Config.CommandAliases = { "camcorporal", "bcc" }

Config.ReviewCommand = "bodycamreview"
Config.ReviewAliases = { "bccreview", "revisarcam" }

Config.BookmarkKey = "G"
Config.BookmarkCommand = "bodycammarcar"

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM (opcional — deixe nil para não exigir item)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Item = "cameracorporal"

-----------------------------------------------------------------------------------------------------------------------------------------
-- GRAVAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Recording = {
	MaxDuration = 3600,
	AutoStartOnService = true,
	AutoStopOffService = true,
	SnapshotInterval = 15,
	MaxSnapshotsPerSession = 240,
	MaxBookmarks = 50,
	BatteryDrainPerMinute = 2.5,
	LowBatteryThreshold = 15,
	DeadBatteryThreshold = 5,
	FullBatteryOnStart = 100
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DETECÇÃO DE EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Events = {
	WeaponDrawn = true,
	WeaponFired = true,
	SirenOn = true,
	VehiclePursuit = true,
	DamageTaken = true,
	Arrest = true,
	Interaction = true
}

Config.PursuitMinSpeed = 80.0

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD (overlay estilo Axon Body 3)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Hud = {
	Enabled = true,
	ShowRec = true,
	ShowTimestamp = true,
	ShowOfficer = true,
	ShowBadge = true,
	ShowUnit = true,
	ShowGps = true,
	ShowSpeed = true,
	ShowBattery = true,
	ShowSessionId = true,
	Scanlines = true,
	Vignette = true,
	RecBlinkMs = 800,
	Position = "top-right"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROP FÍSICO NO UNIFORME
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Prop = {
	Enabled = true,
	Model = `prop_cs_mini_tv`,
	Bone = 24818,
	Offset = vec3(0.12, 0.04, 0.0),
	Rotation = vec3(0.0, 90.0, 180.0)
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- SONS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Sounds = {
	Start = { Name = "Beep_Green", Set = "DLC_HEIST_HACKING_SNAKE_SOUNDS" },
	Stop = { Name = "Beep_Red", Set = "DLC_HEIST_HACKING_SNAKE_SOUNDS" },
	Bookmark = { Name = "Pin_Good", Set = "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS" },
	LowBattery = { Name = "Beep_Red", Set = "DLC_HEIST_HACKING_SNAKE_SOUNDS" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANCO DE DADOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Database = {
	CharacterId = "id",
	CharacterLicense = "License",
	CharacterName = "Name",
	CharacterName2 = "Lastname"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS DE REVISÃO (delegacias / salas de comando)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.ReviewLocations = {
	{ Coords = vec3(441.15, -981.85, 30.69), Heading = 90.0, Label = "Sala de Revisão — LSPD" },
	{ Coords = vec3(-1097.45, -839.20, 19.00), Heading = 125.0, Label = "Sala de Revisão — PMERJ" },
	{ Coords = vec3(252.45, -1370.20, 39.53), Heading = 230.0, Label = "Sala de Revisão — Civil" }
}

Config.Marker = {
	Type = 27,
	Size = vec3(0.5, 0.5, 0.5),
	Color = { r = 30, g = 120, b = 220, a = 180 },
	DrawDistance = 12.0,
	InteractDistance = 1.8
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS (labels para logs)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Weapons = {
	[`WEAPON_UNARMED`] = "Desarmado",
	[`WEAPON_NIGHTSTICK`] = "Cassetete",
	[`WEAPON_STUNGUN`] = "Taser",
	[`WEAPON_FLASHLIGHT`] = "Lanterna",
	[`WEAPON_PISTOL`] = "Pistola 9mm",
	[`WEAPON_COMBATPISTOL`] = "Glock",
	[`WEAPON_APPISTOL`] = "AP Pistol",
	[`WEAPON_PISTOL50`] = "Desert Eagle",
	[`WEAPON_SNSPISTOL`] = "HK P7M10",
	[`WEAPON_HEAVYPISTOL`] = "Ati FX45",
	[`WEAPON_REVOLVER`] = "Magnum 44",
	[`WEAPON_MICROSMG`] = "Uzi",
	[`WEAPON_SMG`] = "MP5",
	[`WEAPON_ASSAULTSMG`] = "MTAR-21",
	[`WEAPON_CARBINERIFLE`] = "M4A1",
	[`WEAPON_ASSAULTRIFLE`] = "AK-103",
	[`WEAPON_SPECIALCARBINE`] = "G36C",
	[`WEAPON_PUMPSHOTGUN`] = "Shotgun",
	[`WEAPON_SNIPERRIFLE`] = "Sniper"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	success = { Title = "Bodycam", Color = "verde" },
	negado = { Title = "Bodycam", Color = "vermelho" },
	important = { Title = "Bodycam", Color = "amarelo" },
	info = { Title = "Bodycam", Color = "azul" },
	rec = { Title = "● REC", Color = "vermelho" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	NotAuthorized = "Você não tem permissão para usar a câmera corporal.",
	NeedService = "Entre em serviço para ativar a bodycam.",
	NeedItem = "Você precisa de uma Câmera Corporal no inventário.",
	AlreadyOn = "A câmera corporal já está ligada.",
	AlreadyOff = "A câmera corporal já está desligada.",
	CameraOn = "Câmera corporal ~g~ligada~w~. Gravação iniciada.",
	CameraOff = "Câmera corporal ~r~desligada~w~. Gravação salva.",
	Recording = "Gravando em andamento...",
	BookmarkSaved = "Marcação de incidente registrada na gravação.",
	LowBattery = "Bateria da bodycam baixa (%s%%).",
	BatteryDead = "Bateria esgotada. Câmera desligada automaticamente.",
	MaxDuration = "Limite de gravação atingido. Sessão encerrada.",
	ReviewDenied = "Sem permissão para revisar gravações.",
	NoRecordings = "Nenhuma gravação encontrada.",
	SessionSaved = "Sessão #%s salva com %s evento(s).",
	AutoStart = "Bodycam ativada automaticamente — em serviço.",
	AutoStop = "Bodycam desligada — fora de serviço.",
	PanelBusy = "Feche o painel aberto antes de continuar.",
	NearReview = "Pressione ~y~E~w~ para acessar revisão de bodycams",
	EventWeapon = "Arma sacada: %s",
	EventShot = "Disparo registrado: %s",
	EventPursuit = "Perseguição em andamento — %s km/h",
	EventDamage = "Oficial ferido — %s de dano",
	EventSiren = "Sirene acionada",
	EventArrest = "Prisão / detenção registrada",
	EventInteraction = "Interação com cidadão"
}
