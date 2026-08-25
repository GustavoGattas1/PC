--[[
	+1 RAIO Keyboard Escape
	Tema: jardim encantado (dia, grama, madeira, pedra)
]]

local Config = {}

Config.Title = "+1 RAIO"
Config.Subtitle = "KEYBOARD ESCAPE"
Config.Tagline = "Corra no teclado! Cada passo aumenta a VELOCIDADE."
Config.ThemeVersion = "Garden_v2"

Config.DataStoreName = "RaioEscape_v1"
Config.MaxPlayersSpeedCap = 1e15

Config.BaseWalkSpeed = 16
Config.MaxWalkSpeed = 260
Config.BaseJumpPower = 50
Config.MaxJumpPower = 180

-- Passos reais por segundo enquanto está EM CIMA da tecla
Config.StepsPerSecondMoving = 8
Config.StepsPerSecondIdle = 2.4
Config.StepCooldown = 0.08
Config.TreadmillTick = 0.16
Config.ComboWindow = 1.6
Config.LuckyKeyChance = 0.035
Config.LuckyKeyMultiplier = 12

Config.StormInterval = 180
Config.StormDuration = 45
Config.StormMultiplier = 3

Config.Codes = {
	RAIO = { Speed = 2500, Wins = 5, Message = "Código RAIO! +2500 velocidade e +5 wins" },
	TEMPESTADE = { Speed = 8000, Wins = 15, Message = "Sol dourado! +8000 velocidade" },
	DRAGAO = { Speed = 15000, Wins = 25, Message = "O dragão do jardim te abençoou!" },
	STREAMER = { Speed = 30000, Wins = 50, Message = "Pack de streamer! Vai pra cima!" },
	JARDIM = { Wins = 40, Message = "+40 Wins do jardim" },
	NEON = { Wins = 40, Message = "+40 Wins" },
	COMBO100 = { Speed = 10000, Message = "Combo lendário pré-pago" },
}

Config.Rebirths = {
	{ Level = 8,   Mult = 2 },
	{ Level = 18,  Mult = 3 },
	{ Level = 32,  Mult = 5 },
	{ Level = 50,  Mult = 8 },
	{ Level = 75,  Mult = 12 },
	{ Level = 110, Mult = 20 },
	{ Level = 150, Mult = 35 },
	{ Level = 200, Mult = 60 },
	{ Level = 270, Mult = 100 },
	{ Level = 350, Mult = 180 },
}

Config.Transformations = {
	{ Level = 6,   Name = "Brilho",        Color = Color3.fromRGB(255, 214, 90),  Message = "Você começou a brilhar!" },
	{ Level = 16,  Name = "Corredor",      Color = Color3.fromRGB(90, 180, 110),  Message = "Corredor do jardim!" },
	{ Level = 32,  Name = "Campeão",       Color = Color3.fromRGB(230, 140, 70),  Message = "CAMPEÃO do teclado!" },
	{ Level = 60,  Name = "Lenda",         Color = Color3.fromRGB(210, 90, 90),   Message = "Você é uma LENDA!" },
	{ Level = 100, Name = "Rei do Teclado", Color = Color3.fromRGB(255, 200, 60), Message = "REI DO TECLADO!" },
}

Config.Trails = {
	{ Id = "Spark",    Name = "Folha",        Wins = 15,     Mult = 1.5, Color = Color3.fromRGB(120, 180, 80) },
	{ Id = "Cyan",     Name = "Céu",          Wins = 60,     Mult = 2.0, Color = Color3.fromRGB(120, 190, 230) },
	{ Id = "Magenta",  Name = "Flor",         Wins = 180,    Mult = 3.0, Color = Color3.fromRGB(230, 120, 150) },
	{ Id = "Storm",    Name = "Ametista",     Wins = 500,    Mult = 4.5, Color = Color3.fromRGB(160, 110, 200) },
	{ Id = "Rainbow",  Name = "Arco-Íris",    Wins = 1500,   Mult = 7.0, Color = Color3.fromRGB(255, 150, 90) },
	{ Id = "Void",     Name = "Noite",        Wins = 5000,   Mult = 12,  Color = Color3.fromRGB(70, 70, 100) },
	{ Id = "Godlike",  Name = "Real",         Wins = 20000,  Mult = 25,  Color = Color3.fromRGB(255, 200, 70) },
}

Config.Auras = {
	{ Id = "Glow",   Name = "Brilho",     Wins = 40,     Mult = 1.2, Color = Color3.fromRGB(255, 240, 200) },
	{ Id = "Wind",   Name = "Brisa",      Wins = 200,    Mult = 1.6, Color = Color3.fromRGB(170, 220, 180) },
	{ Id = "Plasma", Name = "Pétala",     Wins = 800,    Mult = 2.2, Color = Color3.fromRGB(240, 140, 160) },
	{ Id = "Fire",   Name = "Pôr do Sol", Wins = 2500,   Mult = 3.5, Color = Color3.fromRGB(230, 130, 70) },
	{ Id = "Cosmic", Name = "Estrela",    Wins = 9000,   Mult = 6.0, Color = Color3.fromRGB(230, 210, 120) },
}

Config.Pets = {
	{ Id = "Cub",      Name = "Pintinho",     Wins = 0,      Mult = 1.1, Color = Color3.fromRGB(255, 210, 90) },
	{ Id = "Bunny",    Name = "Coelho",       Wins = 80,     Mult = 1.4, Color = Color3.fromRGB(245, 220, 230) },
	{ Id = "Cat",      Name = "Gatinho",      Wins = 350,    Mult = 1.9, Color = Color3.fromRGB(230, 160, 90) },
	{ Id = "Wolf",     Name = "Raposa",       Wins = 1200,   Mult = 2.8, Color = Color3.fromRGB(210, 110, 70) },
	{ Id = "Dragon",   Name = "Dragãozinho",  Wins = 4500,   Mult = 4.5, Color = Color3.fromRGB(90, 160, 110) },
	{ Id = "Phoenix",  Name = "Fênix",        Wins = 18000,  Mult = 8.0, Color = Color3.fromRGB(230, 140, 60) },
}

Config.Treadmills = {
	{ Id = "Free",    Name = "Esteira de Madeira", Mult = 1,  Color = Color3.fromRGB(160, 120, 70) },
	{ Id = "Gold",    Name = "Esteira de Tijolo",  Mult = 3,  Color = Color3.fromRGB(180, 90, 60),   Wins = 250 },
	{ Id = "Diamond", Name = "Esteira de Mármore", Mult = 8,  Color = Color3.fromRGB(210, 215, 220), Wins = 2000 },
	{ Id = "Storm",   Name = "Esteira Real",       Mult = 20, Color = Color3.fromRGB(220, 180, 70),  Wins = 8000 },
}

Config.Stages = {
	{ Name = "Prado Florido",     Color = Color3.fromRGB(120, 170, 90),  Terrain = Enum.Material.Grass,       RequiredLevel = 0,   Wins = 2,    Gap = 8,  Keys = 10 },
	{ Name = "Dunas Douradas",    Color = Color3.fromRGB(210, 180, 110), Terrain = Enum.Material.Sand,        RequiredLevel = 4,   Wins = 5,    Gap = 12, Keys = 12 },
	{ Name = "Vila de Pedra",     Color = Color3.fromRGB(150, 145, 140), Terrain = Enum.Material.Cobblestone, RequiredLevel = 10,  Wins = 12,   Gap = 16, Keys = 12 },
	{ Name = "Canyon de Terra",   Color = Color3.fromRGB(170, 110, 70),  Terrain = Enum.Material.Ground,      RequiredLevel = 18,  Wins = 28,   Gap = 22, Keys = 14 },
	{ Name = "Floresta Alta",     Color = Color3.fromRGB(80, 140, 80),   Terrain = Enum.Material.LeafyGrass,  RequiredLevel = 28,  Wins = 70,   Gap = 28, Keys = 14 },
	{ Name = "Pico Nevado",       Color = Color3.fromRGB(230, 235, 240), Terrain = Enum.Material.Snow,        RequiredLevel = 42,  Wins = 160,  Gap = 34, Keys = 16 },
	{ Name = "Caverna de Quartzo",Color = Color3.fromRGB(190, 170, 200), Terrain = Enum.Material.Slate,       RequiredLevel = 60,  Wins = 400,  Gap = 42, Keys = 16 },
	{ Name = "Castelo nas Nuvens",Color = Color3.fromRGB(230, 210, 150), Terrain = Enum.Material.Marble,      RequiredLevel = 85,  Wins = 1200, Gap = 52, Keys = 18 },
}

Config.KeyboardRows = {
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" },
	{ "A", "S", "D", "F", "G", "H", "J", "K", "L" },
	{ "Z", "X", "C", "V", "B", "N", "M" },
	{ "CTRL", "ALT", "SPACE", "ENTER" },
}

Config.KeySize = Vector3.new(9, 1.5, 9)
Config.KeyGap = 0.12
Config.Palette = {
	Color3.fromRGB(255, 214, 153),
	Color3.fromRGB(167, 216, 168),
	Color3.fromRGB(255, 183, 197),
	Color3.fromRGB(255, 249, 176),
	Color3.fromRGB(174, 214, 241),
	Color3.fromRGB(215, 189, 226),
}

Config.Sounds = {
	Click = "rbxasset://sounds/switch.wav",
	Win = "rbxasset://sounds/electronicpingshort.wav",
	Whoosh = "rbxasset://sounds/action_get_up.mp3",
	Notify = "rbxasset://sounds/switch.wav",
}

function Config.LevelFromSpeed(speed)
	speed = math.max(0, speed or 0)
	return math.floor((speed / 28) ^ 0.58)
end

function Config.SpeedToWalk(speed)
	speed = math.max(0, speed or 0)
	local walk = Config.BaseWalkSpeed + (speed ^ 0.47) * 1.85
	return math.clamp(walk, Config.BaseWalkSpeed, Config.MaxWalkSpeed)
end

function Config.SpeedToJump(speed)
	speed = math.max(0, speed or 0)
	local jump = Config.BaseJumpPower + (speed ^ 0.36) * 2.55
	return math.clamp(jump, Config.BaseJumpPower, Config.MaxJumpPower)
end

function Config.NextRebirth(rebirths)
	rebirths = rebirths or 0
	local index = math.min(rebirths + 1, #Config.Rebirths)
	return Config.Rebirths[index], index
end

function Config.CurrentTransform(level)
	local found = nil
	for _, t in ipairs(Config.Transformations) do
		if level >= t.Level then
			found = t
		end
	end
	return found
end

function Config.FindById(list, id)
	for _, item in ipairs(list) do
		if item.Id == id then
			return item
		end
	end
	return nil
end

function Config.Format(n)
	n = tonumber(n) or 0
	local abs = math.abs(n)
	local suffixes = {
		{ 1e15, "Qd" },
		{ 1e12, "T" },
		{ 1e9, "B" },
		{ 1e6, "M" },
		{ 1e3, "K" },
	}
	for _, s in ipairs(suffixes) do
		if abs >= s[1] then
			return string.format("%.2f%s", n / s[1], s[2])
		end
	end
	if abs >= 100 then
		return tostring(math.floor(n + 0.5))
	end
	return string.format("%.0f", n)
end

return Config
