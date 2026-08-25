-- TIPO: ModuleScript   NOME: Config   PASTA: ReplicatedStorage/RaioGame
-- Cole o conteúdo deste arquivo no script do Studio (apague o código padrão antes).

--[[
	+1 RAIO Keyboard Escape
	Tema: tempestade neon / dragão elétrico
	Tudo que o jogo usa (números, loja, fases, códigos) mora aqui.
]]

local Config = {}

Config.Title = "+1 RAIO"
Config.Subtitle = "KEYBOARD ESCAPE"
Config.Tagline = "Cada passo no teclado = +1 RAIO. Fuja do Dragão da Tempestade!"

Config.DataStoreName = "RaioEscape_v1"
Config.MaxPlayersSpeedCap = 1e15

-- Movimento (fica rápido, mas jogável)
Config.BaseWalkSpeed = 16
Config.MaxWalkSpeed = 240
Config.BaseJumpPower = 50
Config.MaxJumpPower = 175

-- Ganho de velocidade por passo
Config.StepCooldown = 0.12
Config.SameKeyCooldown = 0.40
Config.TreadmillTick = 0.18
Config.ComboWindow = 1.35
Config.LuckyKeyChance = 0.04
Config.LuckyKeyMultiplier = 12

-- Evento global (conteúdo de streamer)
Config.StormInterval = 180
Config.StormDuration = 45
Config.StormMultiplier = 3

-- Códigos (pode trocar quando quiser)
Config.Codes = {
	RAIO = { Speed = 2500, Wins = 5, Message = "⚡ Código RAIO! +2500 velocidade e +5 wins" },
	TEMPESTADE = { Speed = 8000, Wins = 15, Message = "🌩️ Tempestade liberada! +8000 velocidade" },
	DRAGAO = { Speed = 15000, Wins = 25, Message = "🐉 O dragão te abençoou!" },
	STREAMER = { Speed = 30000, Wins = 50, Message = "📺 Pack de streamer! Vai pra cima!" },
	NEON = { Wins = 40, Message = "💜 +40 Wins neon" },
	COMBO100 = { Speed = 10000, Message = "🔥 Combo lendário pré-pago" },
}

Config.Rebirths = {
	{ Level = 10,  Mult = 2 },
	{ Level = 25,  Mult = 3 },
	{ Level = 45,  Mult = 5 },
	{ Level = 70,  Mult = 8 },
	{ Level = 100, Mult = 12 },
	{ Level = 140, Mult = 20 },
	{ Level = 190, Mult = 35 },
	{ Level = 250, Mult = 60 },
	{ Level = 320, Mult = 100 },
	{ Level = 400, Mult = 180 },
}

Config.Transformations = {
	{ Level = 8,   Name = "Faísca",        Color = Color3.fromRGB(255, 240, 80),  Message = "✨ Você virou FAÍSCA!" },
	{ Level = 20,  Name = "Lobo Trovão",   Color = Color3.fromRGB(80, 200, 255),  Message = "🐺 LOBO TROVÃO acordou!" },
	{ Level = 40,  Name = "Dragão Neon",   Color = Color3.fromRGB(255, 60, 220),  Message = "🐉 DRAGÃO NEON!" },
	{ Level = 75,  Name = "Tempestade",    Color = Color3.fromRGB(180, 80, 255),  Message = "🌩️ VOCÊ É A TEMPESTADE!" },
	{ Level = 120, Name = "DEUS DO RAIO",  Color = Color3.fromRGB(255, 220, 40),  Message = "⚡⚡ DEUS DO RAIO ⚡⚡" },
}

Config.Trails = {
	{ Id = "Spark",    Name = "Faísca",       Wins = 15,     Mult = 1.5, Color = Color3.fromRGB(255, 230, 80) },
	{ Id = "Cyan",     Name = "Ciano",        Wins = 60,     Mult = 2.0, Color = Color3.fromRGB(0, 245, 255) },
	{ Id = "Magenta",  Name = "Magenta",      Wins = 180,    Mult = 3.0, Color = Color3.fromRGB(255, 46, 234) },
	{ Id = "Storm",    Name = "Tempestade",   Wins = 500,    Mult = 4.5, Color = Color3.fromRGB(140, 90, 255) },
	{ Id = "Rainbow",  Name = "Arco-Íris",    Wins = 1500,   Mult = 7.0, Color = Color3.fromRGB(255, 90, 180) },
	{ Id = "Void",     Name = "Vazio",        Wins = 5000,   Mult = 12,  Color = Color3.fromRGB(40, 0, 70) },
	{ Id = "Godlike",  Name = "Lendária",     Wins = 20000,  Mult = 25,  Color = Color3.fromRGB(255, 215, 0) },
}

Config.Auras = {
	{ Id = "Glow",   Name = "Brilho",     Wins = 40,     Mult = 1.2, Color = Color3.fromRGB(220, 220, 255) },
	{ Id = "Wind",   Name = "Vento",      Wins = 200,    Mult = 1.6, Color = Color3.fromRGB(160, 255, 210) },
	{ Id = "Plasma", Name = "Plasma",     Wins = 800,    Mult = 2.2, Color = Color3.fromRGB(255, 70, 200) },
	{ Id = "Fire",   Name = "Fogo Elétrico", Wins = 2500, Mult = 3.5, Color = Color3.fromRGB(255, 120, 40) },
	{ Id = "Cosmic", Name = "Cósmica",    Wins = 9000,   Mult = 6.0, Color = Color3.fromRGB(120, 80, 255) },
}

Config.Pets = {
	{ Id = "Cub",      Name = "Filhote Faísca",  Wins = 0,      Mult = 1.1, Color = Color3.fromRGB(255, 230, 90),  Shape = "Ball" },
	{ Id = "Bunny",    Name = "Coelho Volt",     Wins = 80,     Mult = 1.4, Color = Color3.fromRGB(255, 120, 220), Shape = "Ball" },
	{ Id = "Cat",      Name = "Gato Trovão",     Wins = 350,    Mult = 1.9, Color = Color3.fromRGB(80, 220, 255),  Shape = "Ball" },
	{ Id = "Wolf",     Name = "Lobo Plasma",     Wins = 1200,   Mult = 2.8, Color = Color3.fromRGB(180, 90, 255),  Shape = "Ball" },
	{ Id = "Dragon",   Name = "Dragão RAIO",     Wins = 4500,   Mult = 4.5, Color = Color3.fromRGB(255, 70, 70),   Shape = "Ball" },
	{ Id = "Phoenix",  Name = "Fênix Galáctica", Wins = 18000,  Mult = 8.0, Color = Color3.fromRGB(255, 180, 40),  Shape = "Ball" },
}

Config.Treadmills = {
	{ Id = "Free",    Name = "Esteira Faísca",  Mult = 1,   Color = Color3.fromRGB(80, 255, 180) },
	{ Id = "Gold",    Name = "Esteira Ouro",    Mult = 3,   Color = Color3.fromRGB(255, 200, 50),  Wins = 250 },
	{ Id = "Diamond", Name = "Esteira Diamante",Mult = 8,   Color = Color3.fromRGB(120, 220, 255), Wins = 2000 },
	{ Id = "Storm",   Name = "Esteira Tempestade", Mult = 20, Color = Color3.fromRGB(180, 70, 255), Wins = 8000 },
}

Config.Stages = {
	{ Name = "Prado Trovão",      Color = Color3.fromRGB(80, 255, 140),  RequiredLevel = 0,   Wins = 2,    Gap = 8,  Keys = 10 },
	{ Name = "Cânion Elétrico",   Color = Color3.fromRGB(0, 220, 255),   RequiredLevel = 5,   Wins = 5,    Gap = 12, Keys = 12 },
	{ Name = "Metrópole Neon",    Color = Color3.fromRGB(255, 50, 200),  RequiredLevel = 12,  Wins = 12,   Gap = 16, Keys = 12 },
	{ Name = "Núcleo do Vulcão",  Color = Color3.fromRGB(255, 90, 40),   RequiredLevel = 22,  Wins = 28,   Gap = 22, Keys = 14 },
	{ Name = "Selva Plasma",      Color = Color3.fromRGB(160, 255, 60),  RequiredLevel = 35,  Wins = 70,   Gap = 28, Keys = 14 },
	{ Name = "Pico da Tempestade",Color = Color3.fromRGB(150, 90, 255),  RequiredLevel = 55,  Wins = 160,  Gap = 34, Keys = 16 },
	{ Name = "Abismo Violeta",    Color = Color3.fromRGB(90, 40, 160),   RequiredLevel = 80,  Wins = 400,  Gap = 42, Keys = 16 },
	{ Name = "Galáxia RAIO",      Color = Color3.fromRGB(255, 220, 60),  RequiredLevel = 110, Wins = 1200, Gap = 52, Keys = 18 },
}

Config.KeyboardRows = {
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" },
	{ "A", "S", "D", "F", "G", "H", "J", "K", "L" },
	{ "Z", "X", "C", "V", "B", "N", "M" },
	{ "CTRL", "ALT", "SPACE", "ENTER" },
}

Config.KeySize = Vector3.new(8, 2.2, 8)
Config.KeyGap = 1.4
Config.Palette = {
	Color3.fromRGB(0, 245, 255),
	Color3.fromRGB(255, 46, 234),
	Color3.fromRGB(255, 220, 50),
	Color3.fromRGB(140, 90, 255),
	Color3.fromRGB(80, 255, 160),
	Color3.fromRGB(255, 90, 70),
}

Config.Sounds = {
	Click = "rbxasset://sounds/electronicpingshort.wav",
	Win = "rbxasset://sounds/electronicpingshort.wav",
	Whoosh = "rbxasset://sounds/action_get_up.mp3",
	Notify = "rbxasset://sounds/switch.wav",
}

function Config.LevelFromSpeed(speed)
	speed = math.max(0, speed or 0)
	return math.floor((speed / 80) ^ 0.55)
end

function Config.SpeedToWalk(speed)
	local level = Config.LevelFromSpeed(speed)
	local walk = Config.BaseWalkSpeed + (level ^ 0.62) * 2.15
	return math.clamp(walk, Config.BaseWalkSpeed, Config.MaxWalkSpeed)
end

function Config.SpeedToJump(speed)
	local level = Config.LevelFromSpeed(speed)
	local jump = Config.BaseJumpPower + (level ^ 0.5) * 3.4
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
