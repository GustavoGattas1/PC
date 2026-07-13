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

Config.RequireService = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS E TECLAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Command = "wall"
Config.Key = "DELETE"

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERFORMANCE (valores maiores = mais leve)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.DrawDistance = 120.0
Config.UpdateInterval = 8000
Config.RenderSleep = 200
Config.IdleSleep = 2000
Config.PlayerListRefresh = 500

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXIBIÇÃO — desative o que não usar para ganhar FPS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Display = {
	Passport = true,
	SteamName = true,
	Name = false,
	Health = true,
	Armor = true,
	Weapon = true,
	Distance = false,
	Group = false,
	Vehicle = false,
	Speed = false,
	Status = false,
	Line = false,
	Blip = false,
	Skeleton = false,
	Self = false,
	HudBadge = false
}

Config.TextScale = 0.20
Config.TextLineSpacing = 0.012
Config.HeadOffset = 0.35

-----------------------------------------------------------------------------------------------------------------------------------------
-- CORES
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Colors = {
	Alive = { 80, 220, 120, 230 },
	LowHealth = { 255, 180, 50, 230 },
	Dead = { 220, 60, 60, 230 },
	Staff = { 100, 180, 255, 230 },
	Self = { 180, 130, 255, 230 },
	Line = { 255, 255, 255, 60 },
	Skeleton = { 255, 255, 255, 120 }
}

Config.LowHealthThreshold = 120

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
-- ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Weapons = {
	[`WEAPON_UNARMED`] = "Desarmado",
	[`WEAPON_KNIFE`] = "Faca",
	[`WEAPON_PISTOL`] = "Pistola",
	[`WEAPON_COMBATPISTOL`] = "Glock",
	[`WEAPON_APPISTOL`] = "AP Pistol",
	[`WEAPON_PISTOL50`] = "Desert Eagle",
	[`WEAPON_MICROSMG`] = "Uzi",
	[`WEAPON_SMG`] = "MP5",
	[`WEAPON_ASSAULTRIFLE`] = "AK-103",
	[`WEAPON_CARBINERIFLE`] = "M4A1",
	[`WEAPON_SPECIALCARBINE`] = "G36C",
	[`WEAPON_PUMPSHOTGUN`] = "Shotgun",
	[`WEAPON_SNIPERRIFLE`] = "Sniper",
	[`WEAPON_STUNGUN`] = "Taser"
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

Config.Lang = {
	NotAuthorized = "Você não tem permissão para usar o Wall.",
	WallOn = "Wall ~g~ativado~w~.",
	WallOff = "Wall ~r~desativado~w~.",
	NoPermission = "Acesso negado.",
	Help = "Use ~y~/wall~w~ para alternar"
}
