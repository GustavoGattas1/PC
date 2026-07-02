-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA WALL — CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Groups = {
	"Admin",
	"Moderador",
	"Suporte"
}

-- Se true, exige estar em serviço (vRP.HasService) além de ter o grupo
Config.RequireService = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS E TECLAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Command = "wall"
Config.CommandAliases = { "esp", "playerwall" }

-- Tecla padrão para alternar o wall (DELETE)
Config.Key = "DELETE"

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISTÂNCIA E PERFORMANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.DrawDistance = 250.0
Config.UpdateInterval = 500
Config.RenderSleep = 0

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXIBIÇÃO DE INFORMAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Display = {
	Passport = true,
	Name = true,
	ServerId = true,
	Health = true,
	Armor = true,
	Weapon = true,
	Distance = true,
	Group = true,
	Vehicle = true,
	Speed = true,
	Status = true,
	Line = true,
	Blip = false,
	Skeleton = false,
	Self = false,
	Npcs = false,
	ThroughWalls = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CORES (R, G, B, A)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Colors = {
	Alive = { 80, 220, 120, 230 },
	LowHealth = { 255, 180, 50, 230 },
	Dead = { 220, 60, 60, 230 },
	Staff = { 100, 180, 255, 230 },
	Self = { 180, 130, 255, 230 },
	Line = { 255, 255, 255, 80 },
	Skeleton = { 255, 255, 255, 120 }
}

Config.LowHealthThreshold = 120

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANCO DE DADOS (mesmo padrão da base Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Database = {
	CharacterId = "id",
	CharacterLicense = "License",
	CharacterName = "Name",
	CharacterName2 = "Lastname"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS (labels amigáveis — complementa as mais usadas)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Weapons = {
	[`WEAPON_UNARMED`] = "Desarmado",
	[`WEAPON_KNIFE`] = "Faca",
	[`WEAPON_NIGHTSTICK`] = "Cassetete",
	[`WEAPON_HAMMER`] = "Martelo",
	[`WEAPON_BAT`] = "Taco",
	[`WEAPON_CROWBAR`] = "Pé de Cabra",
	[`WEAPON_GOLFCLUB`] = "Taco de Golf",
	[`WEAPON_BOTTLE`] = "Garrafa",
	[`WEAPON_DAGGER`] = "Adaga",
	[`WEAPON_HATCHET`] = "Machado",
	[`WEAPON_MACHETE`] = "Machete",
	[`WEAPON_SWITCHBLADE`] = "Canivete",
	[`WEAPON_PISTOL`] = "Pistola",
	[`WEAPON_COMBATPISTOL`] = "Glock",
	[`WEAPON_APPISTOL`] = "AP Pistol",
	[`WEAPON_PISTOL50`] = "Desert Eagle",
	[`WEAPON_SNSPISTOL`] = "HK P7M10",
	[`WEAPON_HEAVYPISTOL`] = "Ati FX45",
	[`WEAPON_VINTAGEPISTOL`] = "M1922",
	[`WEAPON_REVOLVER`] = "Magnum 44",
	[`WEAPON_MICROSMG`] = "Uzi",
	[`WEAPON_SMG`] = "MP5",
	[`WEAPON_ASSAULTSMG`] = "MTAR-21",
	[`WEAPON_COMBATPDW`] = "Sig Sauer MPX",
	[`WEAPON_MACHINEPISTOL`] = "Tec-9",
	[`WEAPON_MINISMG`] = "Skorpion",
	[`WEAPON_PUMPSHOTGUN`] = "Shotgun",
	[`WEAPON_SAWNOFFSHOTGUN`] = "Shotgun Serrada",
	[`WEAPON_ASSAULTSHOTGUN`] = "Shotgun Automática",
	[`WEAPON_BULLPUPSHOTGUN`] = "Shotgun Bullpup",
	[`WEAPON_HEAVYSHOTGUN`] = "Shotgun Pesada",
	[`WEAPON_ASSAULTRIFLE`] = "AK-103",
	[`WEAPON_CARBINERIFLE`] = "M4A1",
	[`WEAPON_ADVANCEDRIFLE`] = "Tar-21",
	[`WEAPON_SPECIALCARBINE`] = "G36C",
	[`WEAPON_BULLPUPRIFLE`] = "QBZ-95",
	[`WEAPON_COMPACTRIFLE`] = "AK Compacta",
	[`WEAPON_MG`] = "MG",
	[`WEAPON_COMBATMG`] = "Combat MG",
	[`WEAPON_GUSENBERG`] = "Thompson",
	[`WEAPON_SNIPERRIFLE`] = "Sniper",
	[`WEAPON_HEAVYSNIPER`] = "Sniper Pesada",
	[`WEAPON_MARKSMANRIFLE`] = "Marksman",
	[`WEAPON_RPG`] = "RPG",
	[`WEAPON_GRENADELAUNCHER`] = "Lança-Granadas",
	[`WEAPON_MINIGUN`] = "Minigun",
	[`WEAPON_STUNGUN`] = "Taser",
	[`WEAPON_FLASHLIGHT`] = "Lanterna",
	[`WEAPON_PETROLCAN`] = "Galão",
	[`WEAPON_FIREEXTINGUISHER`] = "Extintor",
	[`WEAPON_BALL`] = "Bola",
	[`WEAPON_FLARE`] = "Sinalizador",
	[`WEAPON_SNOWBALL`] = "Bola de Neve"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	success = { Title = "Wall", Color = "verde" },
	negado = { Title = "Wall", Color = "vermelho" },
	important = { Title = "Wall", Color = "amarelo" },
	info = { Title = "Wall", Color = "azul" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	NotAuthorized = "Você não tem permissão para usar o Wall.",
	WallOn = "Wall ~g~ativado~w~.",
	WallOff = "Wall ~r~desativado~w~.",
	NoPermission = "Acesso negado.",
	OptionOn = "~g~ativado",
	OptionOff = "~r~desativado",
	Help = "Use ~y~/wall~w~ para alternar | ~y~/wallconfig~w~ para opções"
}
