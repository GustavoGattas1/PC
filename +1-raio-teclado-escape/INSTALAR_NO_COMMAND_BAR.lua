--[[
	+1 RAIO KEYBOARD ESCAPE  —  instalador 1 clique
	================================================
	COMO USAR (30 segundos):
	1. Abra o Roblox Studio em uma Baseplate
	2. View  >  Command Bar  (barra de comando embaixo)
	3. Cole ESTE arquivo INTEIRO na Command Bar
	4. Pressione Enter
	5. Aperte Play (F5)

	O mapa, a HUD, o dragão, a loja e os scripts nascem sozinhos.
	Pode colar de novo: o instalador apaga a versão antiga antes.
]]

local function wipe(parent, name)
	local old = parent:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local SP = game:GetService("StarterPlayer")
local SPS = SP:WaitForChild("StarterPlayerScripts")

wipe(RS, "RaioGame")
wipe(SSS, "RaioServer")
wipe(SPS, "RaioClient")
wipe(workspace, "RaioWorld")

local folder = Instance.new("Folder")
folder.Name = "RaioGame"
folder.Parent = RS

local function makeModule(name, source)
	local m = Instance.new("ModuleScript")
	m.Name = name
	m.Source = source
	m.Parent = folder
end

local function makeScript(className, name, source, parent)
	local s = Instance.new(className)
	s.Name = name
	s.Source = source
	s.Parent = parent
end

makeModule("Config", [===[--[[
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
]===])
makeModule("World", [===[--[[
	Constrói o mapa inteiro: hub, teclado gigante, esteiras, fases, dragão e decoração.
	Não precisa criar nada na mão no Studio.
]]

local Config = require(script.Parent.Config)

local World = {}

local function wpart(parent, props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Material = props.Material or Enum.Material.SmoothPlastic
	p.Color = props.Color or Color3.fromRGB(20, 10, 40)
	p.Size = props.Size or Vector3.new(4, 1, 4)
	p.CFrame = props.CFrame or CFrame.new()
	p.Name = props.Name or "Part"
	p.Transparency = props.Transparency or 0
	p.CanCollide = props.CanCollide ~= false
	p.CastShadow = false
	if props.Shape then
		p.Shape = props.Shape
	end
	p.Parent = parent
	if props.Light then
		local l = Instance.new("PointLight")
		l.Color = props.Color or Color3.new(1, 1, 1)
		l.Brightness = props.Light
		l.Range = props.Range or 18
		l.Parent = p
	end
	return p
end

local function label(part, text, color)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Top
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 20
	gui.LightInfluence = 0
	gui.Parent = part
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.GothamBlack
	tl.TextScaled = true
	tl.TextColor3 = color or Color3.new(1, 1, 1)
	tl.Text = text
	tl.Parent = gui
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(10, 0, 20)
	stroke.Parent = tl
end

local function billboard(part, text, color, size)
	local bb = Instance.new("BillboardGui")
	bb.Size = size or UDim2.fromOffset(220, 50)
	bb.StudsOffset = Vector3.new(0, 6, 0)
	bb.AlwaysOnTop = true
	bb.Parent = part
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.GothamBlack
	tl.TextScaled = true
	tl.TextColor3 = color or Color3.new(1, 1, 1)
	tl.Text = text
	tl.Parent = bb
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Parent = tl
end

local function neonCrystal(parent, pos, color, height)
	height = height or 18
	local crystal = wpart(parent, {
		Name = "Crystal",
		Size = Vector3.new(2.4, height, 2.4),
		CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(18)),
		Color = color,
		Material = Enum.Material.Neon,
		Light = 2,
		Range = 28,
	})
	crystal.CanCollide = false
	wpart(parent, {
		Name = "CrystalBase",
		Size = Vector3.new(5, 1, 5),
		CFrame = CFrame.new(pos.X, pos.Y - height / 2, pos.Z),
		Color = Color3.fromRGB(12, 6, 28),
		Material = Enum.Material.Slate,
	})
	return crystal
end

local function makeKey(parent, pos, letter, color, tags)
	local width = (letter == "SPACE") and 22 or (letter == "ENTER" or letter == "CTRL" or letter == "ALT") and 12 or Config.KeySize.X
	local key = wpart(parent, {
		Name = "Key_" .. letter,
		Size = Vector3.new(width, Config.KeySize.Y, Config.KeySize.Z),
		CFrame = CFrame.new(pos),
		Color = color,
		Material = Enum.Material.Neon,
		Light = 0.7,
		Range = 14,
	})
	key:SetAttribute("RaioKey", true)
	key:SetAttribute("Letter", letter)
	if tags then
		for k, v in pairs(tags) do
			key:SetAttribute(k, v)
		end
	end
	-- borda escura embaixo (teclado mecânico)
	wpart(parent, {
		Name = "KeyBase",
		Size = Vector3.new(width + 0.4, 0.7, Config.KeySize.Z + 0.4),
		CFrame = CFrame.new(pos.X, pos.Y - 1.35, pos.Z),
		Color = Color3.fromRGB(12, 8, 22),
		Material = Enum.Material.SmoothPlastic,
	})
	label(key, letter, Color3.new(1, 1, 1))
	return key
end

local function buildKeyboard(parent, origin, rows, palette, tags)
	local folder = Instance.new("Folder")
	folder.Name = "Keyboard"
	folder.Parent = parent
	local z = origin.Z
	for r, row in ipairs(rows) do
		local total = 0
		local widths = {}
		for i, letter in ipairs(row) do
			local w = (letter == "SPACE") and 22 or (letter == "ENTER" or letter == "CTRL" or letter == "ALT") and 12 or Config.KeySize.X
			widths[i] = w
			total += w + Config.KeyGap
		end
		total -= Config.KeyGap
		local x = origin.X - total / 2
		local color = palette[((r - 1) % #palette) + 1]
		for i, letter in ipairs(row) do
			local w = widths[i]
			makeKey(folder, Vector3.new(x + w / 2, origin.Y, z), letter, color, tags)
			x += w + Config.KeyGap
		end
		z += Config.KeySize.Z + Config.KeyGap
	end
	return folder, z
end

local function spinningHazard(parent, pos, color)
	local pivot = wpart(parent, {
		Name = "HazardPivot",
		Size = Vector3.new(2, 2, 2),
		CFrame = CFrame.new(pos),
		Color = color,
		Material = Enum.Material.Neon,
		CanCollide = false,
		Light = 1.4,
	})
	local bar = wpart(parent, {
		Name = "SpinBar",
		Size = Vector3.new(28, 1.4, 1.4),
		CFrame = CFrame.new(pos),
		Color = color,
		Material = Enum.Material.Neon,
		CanCollide = false,
	})
	bar.CanCollide = true
	bar:SetAttribute("Hazard", true)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = pivot
	weld.Part1 = bar
	weld.Parent = pivot
	bar.Anchored = false
	bar.Massless = true
	pivot:SetAttribute("Spin", true)
	return pivot
end

local function applyLighting()
	local lighting = game:GetService("Lighting")
	lighting.ClockTime = 21.4
	lighting.Brightness = 1.35
	lighting.Ambient = Color3.fromRGB(20, 10, 40)
	lighting.OutdoorAmbient = Color3.fromRGB(30, 18, 55)
	lighting.FogColor = Color3.fromRGB(18, 6, 40)
	lighting.FogStart = 80
	lighting.FogEnd = 520
	lighting.GlobalShadows = false

	for _, name in ipairs({ "RaioBloom", "RaioCC", "RaioAtmo", "RaioSun" }) do
		local old = lighting:FindFirstChild(name)
		if old then
			old:Destroy()
		end
	end

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "RaioBloom"
	bloom.Intensity = 1.1
	bloom.Size = 22
	bloom.Threshold = 0.85
	bloom.Parent = lighting

	local cc = Instance.new("ColorCorrectionEffect")
	cc.Name = "RaioCC"
	cc.Saturation = 0.25
	cc.Contrast = 0.12
	cc.TintColor = Color3.fromRGB(220, 200, 255)
	cc.Parent = lighting

	local atmo = Instance.new("Atmosphere")
	atmo.Name = "RaioAtmo"
	atmo.Density = 0.32
	atmo.Offset = 0.1
	atmo.Color = Color3.fromRGB(90, 40, 140)
	atmo.Decay = Color3.fromRGB(20, 0, 40)
	atmo.Glare = 0.35
	atmo.Haze = 1.6
	atmo.Parent = lighting
end

function World.Build()
	local old = workspace:FindFirstChild("RaioWorld")
	if old then
		old:Destroy()
	end

	applyLighting()

	local world = Instance.new("Model")
	world.Name = "RaioWorld"
	world.Parent = workspace

	local base = workspace:FindFirstChild("Baseplate")
	if base and base:IsA("BasePart") then
		base.Color = Color3.fromRGB(8, 4, 18)
		base.Material = Enum.Material.SmoothPlastic
		base.Size = Vector3.new(2048, 4, 4096)
		base.CFrame = CFrame.new(0, -2, 900)
	end

	-- chão do hub
	wpart(world, {
		Name = "HubFloor",
		Size = Vector3.new(220, 2, 180),
		CFrame = CFrame.new(0, 0, 0),
		Color = Color3.fromRGB(14, 8, 32),
		Material = Enum.Material.SmoothPlastic,
	})
	wpart(world, {
		Name = "HubGlow",
		Size = Vector3.new(200, 0.2, 160),
		CFrame = CFrame.new(0, 1.12, 0),
		Color = Color3.fromRGB(40, 10, 80),
		Material = Enum.Material.Neon,
		CanCollide = false,
	})

	-- arco título
	local archL = wpart(world, {
		Name = "ArchL",
		Size = Vector3.new(4, 28, 4),
		CFrame = CFrame.new(-28, 15, -62),
		Color = Color3.fromRGB(0, 245, 255),
		Material = Enum.Material.Neon,
		Light = 2,
		Range = 30,
	})
	wpart(world, {
		Name = "ArchR",
		Size = Vector3.new(4, 28, 4),
		CFrame = CFrame.new(28, 15, -62),
		Color = Color3.fromRGB(255, 46, 234),
		Material = Enum.Material.Neon,
		Light = 2,
		Range = 30,
	})
	local titleBar = wpart(world, {
		Name = "TitleBar",
		Size = Vector3.new(60, 8, 3),
		CFrame = CFrame.new(0, 30, -62),
		Color = Color3.fromRGB(20, 8, 40),
		Material = Enum.Material.SmoothPlastic,
	})
	billboard(titleBar, "+1 RAIO  KEYBOARD ESCAPE", Color3.fromRGB(255, 240, 80), UDim2.fromOffset(520, 80))

	-- spawn
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "RaioSpawn"
	spawn.Size = Vector3.new(16, 1, 16)
	spawn.CFrame = CFrame.new(0, 2.2, -28)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.Material = Enum.Material.Neon
	spawn.Color = Color3.fromRGB(255, 230, 80)
	spawn.Parent = world
	label(spawn, "SPAWN", Color3.fromRGB(20, 10, 40))

	-- teclado do hub
	local hubKeys = Instance.new("Folder")
	hubKeys.Name = "HubKeys"
	hubKeys.Parent = world
	buildKeyboard(hubKeys, Vector3.new(0, 2.2, 8), Config.KeyboardRows, Config.Palette, { Zone = "Hub" })

	-- cristais
	for i = 1, 10 do
		local ang = i / 10 * math.pi * 2
		neonCrystal(world, Vector3.new(math.cos(ang) * 92, 10, math.sin(ang) * 70), Config.Palette[(i % #Config.Palette) + 1], 16 + (i % 4) * 4)
	end

	-- loja
	local shop = wpart(world, {
		Name = "ShopPad",
		Size = Vector3.new(28, 2, 28),
		CFrame = CFrame.new(-72, 2, -18),
		Color = Color3.fromRGB(255, 46, 234),
		Material = Enum.Material.Neon,
		Light = 1.5,
	})
	shop:SetAttribute("ShopPad", true)
	billboard(shop, "💜 LOJA DE PODER", Color3.fromRGB(255, 120, 255))

	-- rebirth
	local rebirth = wpart(world, {
		Name = "RebirthPad",
		Size = Vector3.new(22, 2, 22),
		CFrame = CFrame.new(0, 2, -48),
		Color = Color3.fromRGB(255, 220, 50),
		Material = Enum.Material.Neon,
		Light = 2,
		Shape = Enum.PartType.Cylinder,
	})
	rebirth.CFrame = CFrame.new(0, 2, -48) * CFrame.Angles(0, 0, math.rad(90))
	rebirth:SetAttribute("RebirthPad", true)
	billboard(rebirth, "⚡ PORTAL REBIRTH", Color3.fromRGB(255, 230, 80))

	-- códigos
	local codes = wpart(world, {
		Name = "CodePad",
		Size = Vector3.new(18, 2, 18),
		CFrame = CFrame.new(72, 2, -18),
		Color = Color3.fromRGB(80, 255, 160),
		Material = Enum.Material.Neon,
		Light = 1.4,
	})
	codes:SetAttribute("CodePad", true)
	billboard(codes, "🎁 CÓDIGOS", Color3.fromRGB(140, 255, 180))

	-- esteiras
	local tmFolder = Instance.new("Folder")
	tmFolder.Name = "Treadmills"
	tmFolder.Parent = world
	for i, tm in ipairs(Config.Treadmills) do
		local p = wpart(tmFolder, {
			Name = "Treadmill_" .. tm.Id,
			Size = Vector3.new(16, 2.4, 10),
			CFrame = CFrame.new(70, 2.2, 18 + (i - 1) * 14),
			Color = tm.Color,
			Material = Enum.Material.Neon,
			Light = 1.2,
		})
		p:SetAttribute("Treadmill", true)
		p:SetAttribute("TreadmillId", tm.Id)
		p:SetAttribute("TreadmillMult", tm.Mult)
		billboard(p, tm.Name .. "  x" .. tm.Mult, tm.Color)
	end

	-- trilho do percurso
	local pathStartZ = 58
	wpart(world, {
		Name = "PathRail",
		Size = Vector3.new(64, 0.4, 1700),
		CFrame = CFrame.new(0, 0.4, 58 + 850),
		Color = Color3.fromRGB(30, 10, 60),
		Material = Enum.Material.Neon,
		CanCollide = false,
	})

	local stagesFolder = Instance.new("Folder")
	stagesFolder.Name = "Stages"
	stagesFolder.Parent = world

	local z = pathStartZ
	for index, stage in ipairs(Config.Stages) do
		local folder = Instance.new("Folder")
		folder.Name = "Stage_" .. index
		folder.Parent = stagesFolder

		local floor = wpart(folder, {
			Name = "StageFloor",
			Size = Vector3.new(90, 1.6, 120),
			CFrame = CFrame.new(0, 0.8, z + 50),
			Color = Color3.fromRGB(16, 8, 30),
			Material = Enum.Material.SmoothPlastic,
		})

		local banner = wpart(folder, {
			Name = "Banner",
			Size = Vector3.new(50, 6, 2),
			CFrame = CFrame.new(0, 14, z + 4),
			Color = stage.Color,
			Material = Enum.Material.Neon,
			Light = 1.6,
			CanCollide = false,
		})
		billboard(banner, string.format("FASE %d  •  %s  •  LV %d", index, stage.Name, stage.RequiredLevel), stage.Color, UDim2.fromOffset(460, 60))

		-- teclas da fase (pista)
		local rows = {
			{ "Q", "W", "E", "R", "T" },
			{ "A", "S", "D", "F", "G" },
		}
		if stage.Keys >= 14 then
			table.insert(rows, { "Z", "X", "C", "V", "B" })
		end
		buildKeyboard(folder, Vector3.new(0, 2.2, z + 18), rows, { stage.Color, Config.Palette[(index % #Config.Palette) + 1] }, {
			Zone = "Stage",
			Stage = index,
		})

		-- gap
		local gapZ = z + 62
		local before = wpart(folder, {
			Name = "GapEdgeA",
			Size = Vector3.new(28, 2, 8),
			CFrame = CFrame.new(0, 2, gapZ),
			Color = stage.Color,
			Material = Enum.Material.Neon,
		})
		before:SetAttribute("RaioKey", true)
		before:SetAttribute("Letter", "JUMP")
		label(before, "GO!", Color3.new(1, 1, 1))

		local after = wpart(folder, {
			Name = "GapEdgeB",
			Size = Vector3.new(28, 2, 8),
			CFrame = CFrame.new(0, 2, gapZ + stage.Gap + 8),
			Color = stage.Color,
			Material = Enum.Material.Neon,
		})
		after:SetAttribute("RaioKey", true)
		after:SetAttribute("Letter", "NICE")
		label(after, "NICE", Color3.new(1, 1, 1))

		-- obstáculos
		if index >= 2 then
			spinningHazard(folder, Vector3.new(0, 6, z + 48), stage.Color)
		end
		if index >= 4 then
			spinningHazard(folder, Vector3.new(-12, 6, z + 88), Color3.fromRGB(255, 70, 70))
			spinningHazard(folder, Vector3.new(12, 6, z + 88), Color3.fromRGB(255, 70, 70))
		end

		-- mais teclas depois do gap
		buildKeyboard(folder, Vector3.new(0, 2.2, gapZ + stage.Gap + 18), {
			{ "1", "2", "3", "4", "5", "6" },
		}, { stage.Color }, { Zone = "Stage", Stage = index })

		-- win pad
		local win = wpart(folder, {
			Name = "WinPad",
			Size = Vector3.new(20, 2, 20),
			CFrame = CFrame.new(0, 2.4, z + 112),
			Color = Color3.fromRGB(255, 220, 70),
			Material = Enum.Material.Neon,
			Light = 2.4,
			Range = 26,
			Shape = Enum.PartType.Cylinder,
		})
		win.CFrame = CFrame.new(0, 2.4, z + 112) * CFrame.Angles(0, 0, math.rad(90))
		win:SetAttribute("WinPad", true)
		win:SetAttribute("Stage", index)
		win:SetAttribute("Wins", stage.Wins)
		win:SetAttribute("RequiredLevel", stage.RequiredLevel)
		billboard(win, "🏆 +" .. stage.Wins .. " WINS", Color3.fromRGB(255, 230, 80))

		-- checkpoint
		local cp = Instance.new("SpawnLocation")
		cp.Name = "Checkpoint"
		cp.Size = Vector3.new(10, 1, 10)
		cp.CFrame = CFrame.new(0, 2.2, z + 6)
		cp.Anchored = true
		cp.Neutral = true
		cp.Enabled = false
		cp.Duration = 0
		cp.Transparency = 0.35
		cp.Material = Enum.Material.Neon
		cp.Color = stage.Color
		cp.Parent = folder
		cp:SetAttribute("Stage", index)

		neonCrystal(folder, Vector3.new(-38, 12, z + 40), stage.Color, 20)
		neonCrystal(folder, Vector3.new(38, 12, z + 40), stage.Color, 20)

		z += 130
	end

	-- dragão da tempestade (modelo de parts)
	local dragon = Instance.new("Model")
	dragon.Name = "StormDragon"
	dragon.Parent = world
	local body = wpart(dragon, {
		Name = "Body",
		Size = Vector3.new(18, 8, 32),
		CFrame = CFrame.new(0, 22, -90),
		Color = Color3.fromRGB(120, 40, 255),
		Material = Enum.Material.Neon,
		Light = 3,
		Range = 40,
	})
	body:SetAttribute("Dragon", true)
	local function weldToBody(part)
		part.Anchored = false
		part.Massless = true
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = body
		weld.Part1 = part
		weld.Parent = body
	end
	local head = wpart(dragon, {
		Name = "Head",
		Size = Vector3.new(10, 8, 12),
		CFrame = CFrame.new(0, 26, -72),
		Color = Color3.fromRGB(255, 40, 200),
		Material = Enum.Material.Neon,
		Light = 2,
	})
	head:SetAttribute("Dragon", true)
	weldToBody(head)
	for _, side in ipairs({ -1, 1 }) do
		local wing = wpart(dragon, {
			Name = "Wing",
			Size = Vector3.new(28, 1.2, 10),
			CFrame = CFrame.new(18 * side, 24, -90) * CFrame.Angles(0, 0, math.rad(18 * side)),
			Color = Color3.fromRGB(0, 245, 255),
			Material = Enum.Material.Neon,
			CanCollide = false,
			Light = 1.5,
		})
		weldToBody(wing)
	end
	billboard(body, "🐉 DRAGÃO DA TEMPESTADE", Color3.fromRGB(255, 80, 220), UDim2.fromOffset(420, 70))
	dragon.PrimaryPart = body

	-- finish trophy
	local trophy = wpart(world, {
		Name = "FinalTrophy",
		Size = Vector3.new(12, 20, 12),
		CFrame = CFrame.new(0, 12, z + 10),
		Color = Color3.fromRGB(255, 215, 0),
		Material = Enum.Material.Neon,
		Light = 3,
		Range = 40,
	})
	billboard(trophy, "👑 VOCÊ ESCAPOU DA TEMPESTADE", Color3.fromRGB(255, 230, 80), UDim2.fromOffset(520, 70))

	world:SetAttribute("Built", true)
	world:SetAttribute("EndZ", z)
	return world
end

return World
]===])
makeScript("Script", "RaioServer", [===[--[[
	Servidor do +1 RAIO Keyboard Escape
	Cole em ServerScriptService como Script.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RaioGame = ReplicatedStorage:WaitForChild("RaioGame")
local Config = require(RaioGame:WaitForChild("Config"))
local World = require(RaioGame:WaitForChild("World"))

if not workspace:FindFirstChild("RaioWorld") then
	World.Build()
end

local remotesFolder = RaioGame:FindFirstChild("Remotes")
if remotesFolder then
	remotesFolder:Destroy()
end
remotesFolder = Instance.new("Folder")
remotesFolder.Name = "Remotes"
remotesFolder.Parent = RaioGame

local function remote(name, className)
	local r = Instance.new(className or "RemoteEvent")
	r.Name = name
	r.Parent = remotesFolder
	return r
end

local RE = {
	Announce = remote("Announce"),
	Popup = remote("Popup"),
	OpenShop = remote("OpenShop"),
	OpenCodes = remote("OpenCodes"),
	OpenRebirth = remote("OpenRebirth"),
	Buy = remote("Buy"),
	Equip = remote("Equip"),
	Rebirth = remote("Rebirth"),
	Redeem = remote("Redeem"),
	Teleport = remote("Teleport"),
}

local store
pcall(function()
	store = DataStoreService:GetDataStore(Config.DataStoreName)
end)

local profiles = {}
local lastStep = {}
local lastKey = {}
local lastComboAt = {}
local onTreadmill = {}
local winCooldown = {}
local spinning = {}

local function defaultProfile()
	return {
		Speed = 0,
		Wins = 0,
		Rebirths = 0,
		RebirthMult = 1,
		Trail = "",
		Aura = "",
		Pet = "Cub",
		OwnedTrails = {},
		OwnedAuras = {},
		OwnedPets = { Cub = true },
		OwnedTreadmills = { Free = true },
		Codes = {},
		BestStage = 0,
		ComboBest = 0,
	}
end

local function owns(map, id)
	return map and map[id] == true
end

local function totalMultiplier(profile)
	local m = profile.RebirthMult or 1
	local trail = Config.FindById(Config.Trails, profile.Trail)
	local aura = Config.FindById(Config.Auras, profile.Aura)
	local pet = Config.FindById(Config.Pets, profile.Pet)
	if trail then
		m *= trail.Mult
	end
	if aura then
		m *= aura.Mult
	end
	if pet then
		m *= pet.Mult
	end
	if workspace:GetAttribute("StormActive") then
		m *= Config.StormMultiplier
	end
	return m
end

local function applyMovement(player)
	local profile = profiles[player]
	if not profile then
		return
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	humanoid.UseJumpPower = true
	humanoid.WalkSpeed = Config.SpeedToWalk(profile.Speed)
	humanoid.JumpPower = Config.SpeedToJump(profile.Speed)
end

local function pushState(player)
	local profile = profiles[player]
	if not profile then
		return
	end
	local level = Config.LevelFromSpeed(profile.Speed)
	local trans = Config.CurrentTransform(level)
	local nextR = Config.NextRebirth(profile.Rebirths)
	player:SetAttribute("Speed", profile.Speed)
	player:SetAttribute("Wins", profile.Wins)
	player:SetAttribute("Rebirths", profile.Rebirths)
	player:SetAttribute("RebirthMult", profile.RebirthMult)
	player:SetAttribute("Level", level)
	player:SetAttribute("Mult", totalMultiplier(profile))
	player:SetAttribute("Trail", profile.Trail)
	player:SetAttribute("Aura", profile.Aura)
	player:SetAttribute("Pet", profile.Pet)
	player:SetAttribute("Transform", trans and trans.Name or "")
	player:SetAttribute("NextRebirthLevel", nextR and nextR.Level or 0)
	player:SetAttribute("Combo", player:GetAttribute("Combo") or 0)
	player:SetAttribute("BestStage", profile.BestStage)

	local ls = player:FindFirstChild("leaderstats")
	if ls then
		local s = ls:FindFirstChild("Speed")
		local w = ls:FindFirstChild("Wins")
		local r = ls:FindFirstChild("Rebirths")
		if s then
			s.Value = math.floor(profile.Speed)
		end
		if w then
			w.Value = math.floor(profile.Wins)
		end
		if r then
			r.Value = profile.Rebirths
		end
	end
	applyMovement(player)
end

local function announce(text, color)
	RE.Announce:FireAllClients(text, color)
end

local function popup(player, text, color)
	RE.Popup:FireClient(player, text, color)
end

local function grantSpeed(player, base, letter, lucky)
	local profile = profiles[player]
	if not profile then
		return
	end
	local now = os.clock()
	local isTread = letter == "TREAD"
	if (lastStep[player] or 0) + Config.StepCooldown > now then
		return
	end
	if not isTread and letter and lastKey[player] == letter and (now - (lastStep[player] or 0)) < Config.SameKeyCooldown then
		return
	end

	local combo = player:GetAttribute("Combo") or 0
	if not isTread then
		if lastKey[player] and lastKey[player] ~= letter and (now - (lastComboAt[player] or 0)) <= Config.ComboWindow then
			combo += 1
		else
			combo = 1
		end
		if (now - (lastComboAt[player] or 0)) > Config.ComboWindow then
			combo = 1
		end
		lastKey[player] = letter
		lastComboAt[player] = now
		player:SetAttribute("Combo", combo)
		if combo > (profile.ComboBest or 0) then
			profile.ComboBest = combo
		end
	end

	lastStep[player] = now

	local comboMult = 1 + math.min(combo, 80) * 0.02
	local gain = base * totalMultiplier(profile) * comboMult
	if lucky then
		gain *= Config.LuckyKeyMultiplier
	end
	profile.Speed = math.min(Config.MaxPlayersSpeedCap, profile.Speed + gain)

	local level = Config.LevelFromSpeed(profile.Speed)
	local trans = Config.CurrentTransform(level)
	if trans and player:GetAttribute("Transform") ~= trans.Name then
		announce(player.DisplayName .. "  " .. trans.Message, trans.Color)
	end

	if combo == 10 or combo == 25 or combo == 50 or combo == 100 then
		local shouts = {
			[10] = "NICE COMBO x10",
			[25] = "INSANO x25",
			[50] = "LENDÁRIO x50",
			[100] = "DEUS DO RAIO x100",
		}
		announce("🔥 " .. player.DisplayName .. "  " .. shouts[combo], Color3.fromRGB(255, 220, 60))
	end

	pushState(player)
	popup(player, (lucky and "💎 LUCKY +" or "+") .. Config.Format(gain), lucky and Color3.fromRGB(80, 255, 200) or Color3.fromRGB(255, 230, 80))
end

local function loadProfile(player)
	local data = defaultProfile()
	if store then
		local ok, saved = pcall(function()
			return store:GetAsync("p_" .. player.UserId)
		end)
		if ok and typeof(saved) == "table" then
			for k, v in pairs(saved) do
				data[k] = v
			end
		end
	end
	if not owns(data.OwnedPets, "Cub") then
		data.OwnedPets = data.OwnedPets or {}
		data.OwnedPets.Cub = true
	end
	if data.Pet == nil or data.Pet == "" then
		data.Pet = "Cub"
	end
	profiles[player] = data
end

local function saveProfile(player)
	local profile = profiles[player]
	if not profile or not store then
		return
	end
	pcall(function()
		store:SetAsync("p_" .. player.UserId, profile)
	end)
end

local function setupLeaderstats(player)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player
	local speed = Instance.new("NumberValue")
	speed.Name = "Speed"
	speed.Parent = ls
	local wins = Instance.new("NumberValue")
	wins.Name = "Wins"
	wins.Parent = ls
	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Parent = ls
end

local function hookCharacter(player, character)
	character:WaitForChild("HumanoidRootPart", 8)
	local humanoid = character:WaitForChild("Humanoid", 8)
	if humanoid then
		humanoid.Died:Connect(function()
			player:SetAttribute("Combo", 0)
		end)
		humanoid.UseJumpPower = true
	end
	applyMovement(player)
end

local function isCharacterPart(hit)
	local character = hit and hit.Parent
	if not character then
		return nil
	end
	local player = Players:GetPlayerFromCharacter(character)
	if player then
		return player, character
	end
	if character.Parent then
		player = Players:GetPlayerFromCharacter(character.Parent)
		if player then
			return player, character.Parent
		end
	end
	return nil
end

local function bindWorld()
	local world = workspace:WaitForChild("RaioWorld")
	for _, part in ipairs(world:GetDescendants()) do
		if part:IsA("BasePart") and part:GetAttribute("RaioKey") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if not player then
					return
				end
				local lucky = math.random() < Config.LuckyKeyChance
				if lucky then
					local orig = part.Color
					part.Color = Color3.fromRGB(255, 230, 80)
					task.delay(0.35, function()
						if part.Parent then
							part.Color = orig
						end
					end)
				end
				grantSpeed(player, 1, part:GetAttribute("Letter"), lucky)
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("WinPad") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if not player then
					return
				end
				local profile = profiles[player]
				if not profile then
					return
				end
				local now = os.clock()
				if (winCooldown[player] or 0) > now then
					return
				end
				local stage = part:GetAttribute("Stage")
				local need = part:GetAttribute("RequiredLevel") or 0
				local level = Config.LevelFromSpeed(profile.Speed)
				if level < need then
					popup(player, "Precisa do nível " .. need, Color3.fromRGB(255, 90, 90))
					winCooldown[player] = now + 1.2
					return
				end
				winCooldown[player] = now + 4
				local reward = part:GetAttribute("Wins") or 1
				profile.Wins += reward
				profile.BestStage = math.max(profile.BestStage or 0, stage)
				pushState(player)
				popup(player, "🏆 +" .. reward .. " WINS  •  " .. (Config.Stages[stage] and Config.Stages[stage].Name or ""), Color3.fromRGB(255, 220, 70))
				announce("🏆 " .. player.DisplayName .. " zerou a fase " .. stage .. "!", Color3.fromRGB(255, 220, 70))
				local character = player.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				if root then
					task.delay(0.45, function()
						if root.Parent then
							root.CFrame = CFrame.new(0, 8, -24)
						end
					end)
				end
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("Treadmill") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if not player then
					return
				end
				local profile = profiles[player]
				if not profile then
					return
				end
				local id = part:GetAttribute("TreadmillId")
				if not owns(profile.OwnedTreadmills, id) then
					popup(player, "Compre essa esteira na loja!", Color3.fromRGB(255, 90, 90))
					return
				end
				onTreadmill[player] = {
					Mult = part:GetAttribute("TreadmillMult") or 1,
					Until = os.clock() + 0.4,
				}
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("ShopPad") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if player then
					RE.OpenShop:FireClient(player)
				end
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("CodePad") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if player then
					RE.OpenCodes:FireClient(player)
				end
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("RebirthPad") then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if player then
					RE.OpenRebirth:FireClient(player)
				end
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("Hazard") then
			part.Touched:Connect(function(hit)
				local player, character = isCharacterPart(hit)
				if not player then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					humanoid.Health = 0
					popup(player, "💥 O raio te pegou!", Color3.fromRGB(255, 80, 80))
				end
			end)
		elseif part:IsA("BasePart") and part:GetAttribute("Spin") then
			table.insert(spinning, part)
		elseif part:IsA("BasePart") and part:GetAttribute("Dragon") then
			part.Touched:Connect(function(hit)
				if not workspace:GetAttribute("StormActive") then
					return
				end
				local player, character = isCharacterPart(hit)
				if not player then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					humanoid.Health = 0
					announce("🐉 " .. player.DisplayName .. " foi engolido pelo Dragão da Tempestade!", Color3.fromRGB(255, 70, 200))
				end
			end)
		end
	end
end

bindWorld()

Players.PlayerAdded:Connect(function(player)
	loadProfile(player)
	setupLeaderstats(player)
	player:SetAttribute("Combo", 0)
	pushState(player)
	player.CharacterAdded:Connect(function(character)
		hookCharacter(player, character)
	end)
	if player.Character then
		hookCharacter(player, player.Character)
	end
	task.delay(1.5, function()
		if player.Parent then
			popup(player, Config.Tagline, Color3.fromRGB(0, 245, 255))
			RE.Announce:FireClient(player, "Corra no teclado gigante! Cada passo = +1 RAIO", Color3.fromRGB(255, 230, 80))
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	saveProfile(player)
	profiles[player] = nil
	lastStep[player] = nil
	lastKey[player] = nil
	onTreadmill[player] = nil
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveProfile(player)
	end
end)

RE.Buy.OnServerEvent:Connect(function(player, kind, id)
	local profile = profiles[player]
	if not profile or typeof(kind) ~= "string" or typeof(id) ~= "string" then
		return
	end
	local list, ownedKey, equipKey
	if kind == "Trail" then
		list, ownedKey, equipKey = Config.Trails, "OwnedTrails", "Trail"
	elseif kind == "Aura" then
		list, ownedKey, equipKey = Config.Auras, "OwnedAuras", "Aura"
	elseif kind == "Pet" then
		list, ownedKey, equipKey = Config.Pets, "OwnedPets", "Pet"
	elseif kind == "Treadmill" then
		list, ownedKey, equipKey = Config.Treadmills, "OwnedTreadmills", nil
	else
		return
	end
	local item = Config.FindById(list, id)
	if not item then
		return
	end
	profile[ownedKey] = profile[ownedKey] or {}
	if owns(profile[ownedKey], id) then
		if equipKey then
			profile[equipKey] = id
			pushState(player)
			popup(player, "Equipado: " .. item.Name, item.Color)
		end
		return
	end
	local price = item.Wins or 0
	if profile.Wins < price then
		popup(player, "Wins insuficientes (" .. price .. ")", Color3.fromRGB(255, 90, 90))
		return
	end
	profile.Wins -= price
	profile[ownedKey][id] = true
	if equipKey then
		profile[equipKey] = id
	end
	pushState(player)
	popup(player, "Comprou " .. item.Name .. "!", item.Color)
	announce("💜 " .. player.DisplayName .. " comprou " .. item.Name, item.Color)
end)

RE.Equip.OnServerEvent:Connect(function(player, kind, id)
	local profile = profiles[player]
	if not profile then
		return
	end
	if kind == "Trail" and owns(profile.OwnedTrails, id) then
		profile.Trail = id
	elseif kind == "Aura" and owns(profile.OwnedAuras, id) then
		profile.Aura = id
	elseif kind == "Pet" and owns(profile.OwnedPets, id) then
		profile.Pet = id
	end
	pushState(player)
end)

RE.Rebirth.OnServerEvent:Connect(function(player)
	local profile = profiles[player]
	if not profile then
		return
	end
	local nextR = Config.NextRebirth(profile.Rebirths)
	local level = Config.LevelFromSpeed(profile.Speed)
	if not nextR or level < nextR.Level then
		popup(player, "Falta nível " .. (nextR and nextR.Level or "?") .. " para rebirth", Color3.fromRGB(255, 90, 90))
		return
	end
	profile.Rebirths += 1
	profile.RebirthMult = (profile.RebirthMult or 1) * nextR.Mult
	profile.Speed = 0
	player:SetAttribute("Combo", 0)
	pushState(player)
	popup(player, "⚡ REBIRTH x" .. Config.Format(profile.RebirthMult), Color3.fromRGB(255, 220, 70))
	announce("⚡ " .. player.DisplayName .. " deu REBIRTH! Multi x" .. Config.Format(profile.RebirthMult), Color3.fromRGB(255, 220, 70))
end)

RE.Redeem.OnServerEvent:Connect(function(player, code)
	local profile = profiles[player]
	if not profile or typeof(code) ~= "string" then
		return
	end
	code = string.upper(string.gsub(code, "%s+", ""))
	local gift = Config.Codes[code]
	if not gift then
		popup(player, "Código inválido", Color3.fromRGB(255, 90, 90))
		return
	end
	profile.Codes = profile.Codes or {}
	if profile.Codes[code] then
		popup(player, "Você já usou esse código", Color3.fromRGB(255, 160, 60))
		return
	end
	profile.Codes[code] = true
	profile.Speed += gift.Speed or 0
	profile.Wins += gift.Wins or 0
	pushState(player)
	popup(player, gift.Message, Color3.fromRGB(80, 255, 160))
end)

RE.Teleport.OnServerEvent:Connect(function(player, stageIndex)
	local profile = profiles[player]
	if not profile or typeof(stageIndex) ~= "number" then
		return
	end
	stageIndex = math.floor(stageIndex)
	if stageIndex < 0 or stageIndex > #Config.Stages then
		return
	end
	if stageIndex > 0 and (profile.BestStage or 0) < stageIndex - 1 and Config.LevelFromSpeed(profile.Speed) < (Config.Stages[stageIndex].RequiredLevel or 0) then
		popup(player, "Libere essa fase primeiro", Color3.fromRGB(255, 90, 90))
		return
	end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	if stageIndex == 0 then
		root.CFrame = CFrame.new(0, 8, -24)
		return
	end
	local folder = workspace.RaioWorld.Stages:FindFirstChild("Stage_" .. stageIndex)
	local cp = folder and folder:FindFirstChild("Checkpoint")
	if cp then
		root.CFrame = cp.CFrame + Vector3.new(0, 6, 0)
	end
end)

-- esteira AFK
task.spawn(function()
	while true do
		task.wait(Config.TreadmillTick)
		local now = os.clock()
		for player, info in pairs(onTreadmill) do
			if now > info.Until then
				onTreadmill[player] = nil
			else
				grantSpeed(player, info.Mult, "TREAD", false)
			end
		end
	end
end)

-- autosave
task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			saveProfile(player)
		end
	end
end)

-- gira obstáculos
RunService.Heartbeat:Connect(function(dt)
	for _, pivot in ipairs(spinning) do
		if pivot.Parent then
			pivot.CFrame *= CFrame.Angles(0, dt * 1.8, 0)
		end
	end
end)

-- evento de tempestade (streamer bait)
task.spawn(function()
	while true do
		task.wait(Config.StormInterval)
		workspace:SetAttribute("StormActive", true)
		announce("🌩️ TEMPESTADE DOURADA!  x" .. Config.StormMultiplier .. " RAIO por " .. Config.StormDuration .. "s", Color3.fromRGB(255, 220, 60))
		local dragon = workspace.RaioWorld:FindFirstChild("StormDragon")
		if dragon and dragon.PrimaryPart then
			local start = dragon.PrimaryPart.CFrame
			local finish = CFrame.new(0, 26, (workspace.RaioWorld:GetAttribute("EndZ") or 900))
			local tween = TweenService:Create(dragon.PrimaryPart, TweenInfo.new(Config.StormDuration, Enum.EasingStyle.Linear), { CFrame = finish })
			tween:Play()
			task.delay(Config.StormDuration, function()
				if dragon.PrimaryPart then
					dragon.PrimaryPart.CFrame = start
				end
			end)
		end
		task.wait(Config.StormDuration)
		workspace:SetAttribute("StormActive", false)
		announce("A tempestade passou... prepare-se para a próxima!", Color3.fromRGB(180, 180, 255))
		for _, player in ipairs(Players:GetPlayers()) do
			pushState(player)
		end
	end
end)

-- já logados (Play Solo no Studio)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		loadProfile(player)
		if not player:FindFirstChild("leaderstats") then
			setupLeaderstats(player)
		end
		pushState(player)
		if player.Character then
			hookCharacter(player, player.Character)
		end
	end)
end

print("[+1 RAIO] Servidor pronto. Corra no teclado!")
]===], SSS)
makeScript("LocalScript", "RaioClient", [===[--[[
	Cliente do +1 RAIO Keyboard Escape
	Cole em StarterPlayer > StarterPlayerScripts como LocalScript.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RaioGame = ReplicatedStorage:WaitForChild("RaioGame")
local Config = require(RaioGame:WaitForChild("Config"))
local Remotes = RaioGame:WaitForChild("Remotes")

local function playSound(id, pitch)
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = 0.45
	s.PlaybackSpeed = pitch or 1
	s.Parent = SoundService
	s:Play()
	s.Ended:Connect(function()
		s:Destroy()
	end)
end

local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 12)
	c.Parent = inst
	return c
end

local function stroke(inst, color, t)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = t or 1.5
	s.Transparency = 0.15
	s.Parent = inst
	return s
end

local function gradient(inst, c1, c2, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c1, c2)
	g.Rotation = rot or 90
	g.Parent = inst
	return g
end

local function pad(inst, px)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, px)
	p.PaddingBottom = UDim.new(0, px)
	p.PaddingLeft = UDim.new(0, px)
	p.PaddingRight = UDim.new(0, px)
	p.Parent = inst
end

local gui = Instance.new("ScreenGui")
gui.Name = "RaioHUD"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- fundo suave no topo
local top = Instance.new("Frame")
top.Name = "Top"
top.BackgroundColor3 = Color3.fromRGB(12, 6, 28)
top.BackgroundTransparency = 0.25
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 78)
top.Parent = gui
gradient(top, Color3.fromRGB(20, 8, 50), Color3.fromRGB(8, 4, 20), 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0.5, -220, 0, 6)
title.Size = UDim2.fromOffset(440, 36)
title.Font = Enum.Font.GothamBlack
title.Text = "+1 RAIO  •  KEYBOARD ESCAPE"
title.TextColor3 = Color3.fromRGB(255, 230, 80)
title.TextScaled = true
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0.5, -240, 0, 42)
subtitle.Size = UDim2.fromOffset(480, 24)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "Corra no teclado  •  Fuja do dragão  •  Vire lenda"
subtitle.TextColor3 = Color3.fromRGB(200, 180, 255)
subtitle.TextScaled = true
subtitle.Parent = top

local function statCard(parent, pos, labelText, color)
	local f = Instance.new("Frame")
	f.BackgroundColor3 = Color3.fromRGB(16, 8, 36)
	f.BackgroundTransparency = 0.12
	f.BorderSizePixel = 0
	f.Position = pos
	f.Size = UDim2.fromOffset(168, 64)
	f.Parent = parent
	corner(f, 14)
	stroke(f, color, 1.6)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = UDim2.new(1, 0, 0, 20)
	l.Position = UDim2.fromOffset(0, 6)
	l.Font = Enum.Font.GothamBold
	l.Text = labelText
	l.TextColor3 = color
	l.TextScaled = true
	l.Parent = f
	local v = Instance.new("TextLabel")
	v.Name = "Value"
	v.BackgroundTransparency = 1
	v.Size = UDim2.new(1, -8, 0, 32)
	v.Position = UDim2.fromOffset(4, 26)
	v.Font = Enum.Font.GothamBlack
	v.Text = "0"
	v.TextColor3 = Color3.new(1, 1, 1)
	v.TextScaled = true
	v.Parent = f
	return v
end

local speedVal = statCard(gui, UDim2.new(0, 16, 0, 92), "⚡ VELOCIDADE", Color3.fromRGB(255, 230, 80))
local levelVal = statCard(gui, UDim2.new(0, 16, 0, 166), "⭐ NÍVEL", Color3.fromRGB(0, 245, 255))
local winsVal = statCard(gui, UDim2.new(0, 16, 0, 240), "🏆 WINS", Color3.fromRGB(255, 180, 50))
local multVal = statCard(gui, UDim2.new(0, 16, 0, 314), "💥 MULTIPLICADOR", Color3.fromRGB(255, 70, 200))
local rebirthVal = statCard(gui, UDim2.new(0, 16, 0, 388), "♻️ REBIRTHS", Color3.fromRGB(180, 255, 120))

local comboFrame = Instance.new("Frame")
comboFrame.BackgroundColor3 = Color3.fromRGB(20, 8, 40)
comboFrame.BackgroundTransparency = 0.1
comboFrame.BorderSizePixel = 0
comboFrame.Position = UDim2.new(0.5, -140, 0, 92)
comboFrame.Size = UDim2.fromOffset(280, 58)
comboFrame.Parent = gui
corner(comboFrame, 14)
stroke(comboFrame, Color3.fromRGB(255, 60, 180), 1.7)

local comboLabel = Instance.new("TextLabel")
comboLabel.BackgroundTransparency = 1
comboLabel.Size = UDim2.fromScale(1, 1)
comboLabel.Font = Enum.Font.GothamBlack
comboLabel.Text = "COMBO x0"
comboLabel.TextColor3 = Color3.fromRGB(255, 90, 200)
comboLabel.TextScaled = true
comboLabel.Parent = comboFrame
pad(comboLabel, 8)

local transformLabel = Instance.new("TextLabel")
transformLabel.BackgroundTransparency = 1
transformLabel.Position = UDim2.new(0.5, -180, 0, 154)
transformLabel.Size = UDim2.fromOffset(360, 28)
transformLabel.Font = Enum.Font.GothamBold
transformLabel.Text = ""
transformLabel.TextColor3 = Color3.fromRGB(255, 230, 80)
transformLabel.TextScaled = true
transformLabel.Parent = gui

local announce = Instance.new("TextLabel")
announce.BackgroundTransparency = 1
announce.Position = UDim2.new(0.5, -320, 0, 188)
announce.Size = UDim2.fromOffset(640, 42)
announce.Font = Enum.Font.GothamBlack
announce.Text = ""
announce.TextColor3 = Color3.fromRGB(255, 240, 120)
announce.TextScaled = true
announce.TextStrokeTransparency = 0.4
announce.Parent = gui

local plus = Instance.new("TextLabel")
plus.BackgroundTransparency = 1
plus.Position = UDim2.new(0.5, -150, 0.42, 0)
plus.Size = UDim2.fromOffset(300, 80)
plus.Font = Enum.Font.GothamBlack
plus.Text = ""
plus.TextColor3 = Color3.fromRGB(255, 230, 80)
plus.TextScaled = true
plus.TextStrokeTransparency = 0.3
plus.Parent = gui

local function makeButton(text, pos, color, order)
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = Color3.fromRGB(18, 8, 40)
	b.BorderSizePixel = 0
	b.Position = pos
	b.Size = UDim2.fromOffset(168, 48)
	b.Font = Enum.Font.GothamBlack
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextScaled = true
	b.AutoButtonColor = true
	b.LayoutOrder = order or 0
	b.Parent = gui
	corner(b, 12)
	stroke(b, color, 1.8)
	pad(b, 6)
	return b
end

local shopBtn = makeButton("💜  LOJA", UDim2.new(1, -184, 0, 92), Color3.fromRGB(255, 70, 220))
local rebirthBtn = makeButton("⚡  REBIRTH", UDim2.new(1, -184, 0, 150), Color3.fromRGB(255, 220, 60))
local codesBtn = makeButton("🎁  CÓDIGOS", UDim2.new(1, -184, 0, 208), Color3.fromRGB(80, 255, 160))
local hubBtn = makeButton("🏠  HUB", UDim2.new(1, -184, 0, 266), Color3.fromRGB(0, 220, 255))
local petBtn = makeButton("🐉  PETS", UDim2.new(1, -184, 0, 324), Color3.fromRGB(255, 140, 60))

local hint = Instance.new("TextLabel")
hint.BackgroundTransparency = 1
hint.Position = UDim2.new(0.5, -260, 1, -54)
hint.Size = UDim2.fromOffset(520, 36)
hint.Font = Enum.Font.GothamMedium
hint.Text = "Ande em cima das teclas  •  Pule os vãos  •  Toque no ouro pra ganhar WINS"
hint.TextColor3 = Color3.fromRGB(210, 200, 255)
hint.TextScaled = true
hint.Parent = gui

-- painel genérico
local function panel(name, titleText)
	local f = Instance.new("Frame")
	f.Name = name
	f.Visible = false
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = UDim2.fromScale(0.5, 0.54)
	f.Size = UDim2.fromOffset(560, 460)
	f.BackgroundColor3 = Color3.fromRGB(12, 6, 28)
	f.BorderSizePixel = 0
	f.Parent = gui
	corner(f, 18)
	stroke(f, Color3.fromRGB(255, 70, 220), 2)
	gradient(f, Color3.fromRGB(28, 10, 60), Color3.fromRGB(10, 4, 24), 90)

	local h = Instance.new("TextLabel")
	h.BackgroundTransparency = 1
	h.Size = UDim2.new(1, -70, 0, 48)
	h.Position = UDim2.fromOffset(18, 10)
	h.Font = Enum.Font.GothamBlack
	h.Text = titleText
	h.TextColor3 = Color3.new(1, 1, 1)
	h.TextXAlignment = Enum.TextXAlignment.Left
	h.TextScaled = true
	h.Parent = f

	local close = Instance.new("TextButton")
	close.Size = UDim2.fromOffset(40, 40)
	close.Position = UDim2.new(1, -52, 0, 10)
	close.BackgroundColor3 = Color3.fromRGB(40, 10, 20)
	close.Text = "X"
	close.Font = Enum.Font.GothamBlack
	close.TextColor3 = Color3.new(1, 1, 1)
	close.TextScaled = true
	close.Parent = f
	corner(close, 10)
	close.MouseButton1Click:Connect(function()
		f.Visible = false
	end)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "List"
	scroll.BackgroundTransparency = 1
	scroll.Position = UDim2.fromOffset(16, 64)
	scroll.Size = UDim2.new(1, -32, 1, -80)
	scroll.CanvasSize = UDim2.fromOffset(0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarThickness = 6
	scroll.Parent = f
	local lay = Instance.new("UIListLayout")
	lay.Padding = UDim.new(0, 8)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Parent = scroll
	return f, scroll
end

local shopPanel, shopList = panel("Shop", "💜 LOJA DE PODER")
local petPanel, petList = panel("Pets", "🐉 PETS ELÉTRICOS")
local rebirthPanel = panel("Rebirth", "⚡ PORTAL REBIRTH")
rebirthPanel.Size = UDim2.fromOffset(480, 280)

local rebirthInfo = Instance.new("TextLabel")
rebirthInfo.BackgroundTransparency = 1
rebirthInfo.Position = UDim2.fromOffset(20, 70)
rebirthInfo.Size = UDim2.new(1, -40, 0, 110)
rebirthInfo.Font = Enum.Font.GothamMedium
rebirthInfo.TextWrapped = true
rebirthInfo.TextColor3 = Color3.fromRGB(230, 220, 255)
rebirthInfo.TextScaled = true
rebirthInfo.Text = ""
rebirthInfo.Parent = rebirthPanel

local doRebirth = Instance.new("TextButton")
doRebirth.Size = UDim2.new(1, -40, 0, 56)
doRebirth.Position = UDim2.new(0, 20, 1, -80)
doRebirth.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
doRebirth.Font = Enum.Font.GothamBlack
doRebirth.Text = "REBIRTH AGORA"
doRebirth.TextColor3 = Color3.fromRGB(20, 10, 40)
doRebirth.TextScaled = true
doRebirth.Parent = rebirthPanel
corner(doRebirth, 12)

local codesPanel = Instance.new("Frame")
codesPanel.Visible = false
codesPanel.AnchorPoint = Vector2.new(0.5, 0.5)
codesPanel.Position = UDim2.fromScale(0.5, 0.5)
codesPanel.Size = UDim2.fromOffset(420, 220)
codesPanel.BackgroundColor3 = Color3.fromRGB(12, 6, 28)
codesPanel.BorderSizePixel = 0
codesPanel.Parent = gui
corner(codesPanel, 16)
stroke(codesPanel, Color3.fromRGB(80, 255, 160), 2)

local codesTitle = Instance.new("TextLabel")
codesTitle.BackgroundTransparency = 1
codesTitle.Size = UDim2.new(1, -20, 0, 40)
codesTitle.Position = UDim2.fromOffset(10, 10)
codesTitle.Font = Enum.Font.GothamBlack
codesTitle.Text = "🎁 RESGATAR CÓDIGO"
codesTitle.TextColor3 = Color3.new(1, 1, 1)
codesTitle.TextScaled = true
codesTitle.Parent = codesPanel

local codesBox = Instance.new("TextBox")
codesBox.Size = UDim2.new(1, -40, 0, 48)
codesBox.Position = UDim2.fromOffset(20, 64)
codesBox.BackgroundColor3 = Color3.fromRGB(30, 14, 55)
codesBox.PlaceholderText = "ex: RAIO"
codesBox.Text = ""
codesBox.Font = Enum.Font.GothamBold
codesBox.TextColor3 = Color3.new(1, 1, 1)
codesBox.TextScaled = true
codesBox.ClearTextOnFocus = false
codesBox.Parent = codesPanel
corner(codesBox, 10)

local redeem = Instance.new("TextButton")
redeem.Size = UDim2.new(1, -40, 0, 48)
redeem.Position = UDim2.fromOffset(20, 128)
redeem.BackgroundColor3 = Color3.fromRGB(80, 255, 160)
redeem.Font = Enum.Font.GothamBlack
redeem.Text = "RESGATAR"
redeem.TextColor3 = Color3.fromRGB(10, 30, 20)
redeem.TextScaled = true
redeem.Parent = codesPanel
corner(redeem, 10)

local closeCodes = Instance.new("TextButton")
closeCodes.Size = UDim2.fromOffset(36, 36)
closeCodes.Position = UDim2.new(1, -46, 0, 10)
closeCodes.BackgroundColor3 = Color3.fromRGB(40, 10, 20)
closeCodes.Text = "X"
closeCodes.Font = Enum.Font.GothamBlack
closeCodes.TextColor3 = Color3.new(1, 1, 1)
closeCodes.TextScaled = true
closeCodes.Parent = codesPanel
corner(closeCodes, 8)
closeCodes.MouseButton1Click:Connect(function()
	codesPanel.Visible = false
end)

local function itemRow(parent, text, sub, color, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -8, 0, 64)
	b.BackgroundColor3 = Color3.fromRGB(22, 10, 44)
	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.Text = ""
	b.Parent = parent
	corner(b, 12)
	stroke(b, color, 1.4)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Position = UDim2.fromOffset(12, 6)
	t.Size = UDim2.new(1, -24, 0, 28)
	t.Font = Enum.Font.GothamBlack
	t.Text = text
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextScaled = true
	t.Parent = b
	local s = Instance.new("TextLabel")
	s.BackgroundTransparency = 1
	s.Position = UDim2.fromOffset(12, 34)
	s.Size = UDim2.new(1, -24, 0, 22)
	s.Font = Enum.Font.GothamMedium
	s.Text = sub
	s.TextColor3 = color
	s.TextXAlignment = Enum.TextXAlignment.Left
	s.TextScaled = true
	s.Parent = b
	b.MouseButton1Click:Connect(callback)
end

local function fillShop()
	shopList:ClearAllChildren()
	local lay = Instance.new("UIListLayout")
	lay.Padding = UDim.new(0, 8)
	lay.Parent = shopList

	local function header(text)
		local h = Instance.new("TextLabel")
		h.BackgroundTransparency = 1
		h.Size = UDim2.new(1, 0, 0, 28)
		h.Font = Enum.Font.GothamBlack
		h.Text = text
		h.TextColor3 = Color3.fromRGB(255, 230, 80)
		h.TextXAlignment = Enum.TextXAlignment.Left
		h.TextScaled = true
		h.Parent = shopList
	end

	header("TRILHAS")
	for _, item in ipairs(Config.Trails) do
		itemRow(shopList, item.Name .. "  x" .. item.Mult, item.Wins .. " Wins  •  clique pra comprar/equipar", item.Color, function()
			Remotes.Buy:FireServer("Trail", item.Id)
		end)
	end
	header("AURAS")
	for _, item in ipairs(Config.Auras) do
		itemRow(shopList, item.Name .. "  x" .. item.Mult, item.Wins .. " Wins", item.Color, function()
			Remotes.Buy:FireServer("Aura", item.Id)
		end)
	end
	header("ESTEIRAS AFK")
	for _, item in ipairs(Config.Treadmills) do
		itemRow(shopList, item.Name .. "  x" .. item.Mult, (item.Wins and (item.Wins .. " Wins") or "GRÁTIS"), item.Color, function()
			Remotes.Buy:FireServer("Treadmill", item.Id)
		end)
	end
end

local function fillPets()
	petList:ClearAllChildren()
	local lay = Instance.new("UIListLayout")
	lay.Padding = UDim.new(0, 8)
	lay.Parent = petList
	for _, item in ipairs(Config.Pets) do
		itemRow(petList, item.Name .. "  x" .. item.Mult, (item.Wins == 0 and "GRÁTIS — clique pra equipar" or (item.Wins .. " Wins")), item.Color, function()
			Remotes.Buy:FireServer("Pet", item.Id)
		end)
	end
end

fillShop()
fillPets()

local function refreshRebirth()
	local level = player:GetAttribute("Level") or 0
	local need = player:GetAttribute("NextRebirthLevel") or 10
	local mult = player:GetAttribute("RebirthMult") or 1
	rebirthInfo.Text = string.format(
		"Nível atual: %d\nPrecisa: %d\nMultiplicador atual: x%s\n\nRebirth zera a velocidade e MULTIPLICA todo ganho futuro. Sempre vale a pena.",
		level,
		need,
		Config.Format(mult)
	)
end

shopBtn.MouseButton1Click:Connect(function()
	shopPanel.Visible = not shopPanel.Visible
	petPanel.Visible = false
	codesPanel.Visible = false
	rebirthPanel.Visible = false
end)
petBtn.MouseButton1Click:Connect(function()
	petPanel.Visible = not petPanel.Visible
	shopPanel.Visible = false
end)
codesBtn.MouseButton1Click:Connect(function()
	codesPanel.Visible = not codesPanel.Visible
end)
rebirthBtn.MouseButton1Click:Connect(function()
	refreshRebirth()
	rebirthPanel.Visible = not rebirthPanel.Visible
end)
hubBtn.MouseButton1Click:Connect(function()
	Remotes.Teleport:FireServer(0)
end)
doRebirth.MouseButton1Click:Connect(function()
	Remotes.Rebirth:FireServer()
	rebirthPanel.Visible = false
end)
redeem.MouseButton1Click:Connect(function()
	Remotes.Redeem:FireServer(codesBox.Text)
	codesBox.Text = ""
end)

Remotes.OpenShop.OnClientEvent:Connect(function()
	shopPanel.Visible = true
end)
Remotes.OpenCodes.OnClientEvent:Connect(function()
	codesPanel.Visible = true
end)
Remotes.OpenRebirth.OnClientEvent:Connect(function()
	refreshRebirth()
	rebirthPanel.Visible = true
end)

local function refreshStats()
	speedVal.Text = Config.Format(player:GetAttribute("Speed") or 0)
	levelVal.Text = tostring(player:GetAttribute("Level") or 0)
	winsVal.Text = Config.Format(player:GetAttribute("Wins") or 0)
	multVal.Text = "x" .. Config.Format(player:GetAttribute("Mult") or 1)
	rebirthVal.Text = tostring(player:GetAttribute("Rebirths") or 0)
	local combo = player:GetAttribute("Combo") or 0
	comboLabel.Text = "COMBO x" .. combo
	local tr = player:GetAttribute("Transform") or ""
	transformLabel.Text = tr ~= "" and ("FORMA: " .. tr) or ""
end

player.AttributeChanged:Connect(function(name)
	if name == "Speed" or name == "Level" or name == "Wins" or name == "Mult" or name == "Rebirths" or name == "Combo" or name == "Transform" then
		refreshStats()
	end
end)
refreshStats()

Remotes.Popup.OnClientEvent:Connect(function(text, color)
	plus.Text = text
	plus.TextColor3 = color or Color3.fromRGB(255, 230, 80)
	plus.TextTransparency = 0
	plus.Position = UDim2.new(0.5, -150, 0.40, 0)
	playSound(Config.Sounds.Click, 0.85 + math.random() * 0.5)
	TweenService:Create(plus, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -150, 0.28, 0),
		TextTransparency = 1,
	}):Play()
end)

Remotes.Announce.OnClientEvent:Connect(function(text, color)
	announce.Text = text
	announce.TextColor3 = color or Color3.fromRGB(255, 240, 120)
	announce.TextTransparency = 0
	playSound(Config.Sounds.Notify, 1.1)
	task.delay(3.2, function()
		TweenService:Create(announce, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
	end)
end)

-- VFX no personagem: trilha, aura, pet, billboard
local function wipeNamed(parent, names)
	for _, name in ipairs(names) do
		local inst = parent:FindFirstChild(name)
		if inst then
			inst:Destroy()
		end
	end
end

local function clearVfx(character)
	wipeNamed(character, { "RaioFx", "RaioHighlight" })
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		wipeNamed(root, { "RaioTrail", "RaioSparks", "SpeedBillboard", "RaioAtt0", "RaioAtt1" })
	end
end

local function colorOf(list, id, fallback)
	local item = Config.FindById(list, id)
	return item and item.Color or fallback
end

local function attachVfx(character)
	clearVfx(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local folder = Instance.new("Folder")
	folder.Name = "RaioFx"
	folder.Parent = character

	local att0 = Instance.new("Attachment")
	att0.Name = "RaioAtt0"
	att0.Position = Vector3.new(0, 1.2, 0)
	att0.Parent = root
	local att1 = Instance.new("Attachment")
	att1.Name = "RaioAtt1"
	att1.Position = Vector3.new(0, -2.4, 0)
	att1.Parent = root

	local trailCol = colorOf(Config.Trails, player:GetAttribute("Trail"), Color3.fromRGB(0, 245, 255))
	local trail = Instance.new("Trail")
	trail.Name = "RaioTrail"
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Lifetime = 0.45
	trail.MinLength = 0.2
	trail.FaceCamera = true
	trail.Color = ColorSequence.new(trailCol, Color3.new(1, 1, 1))
	trail.Transparency = NumberSequence.new(0.15, 1)
	trail.WidthScale = NumberSequence.new(1, 0)
	trail.LightEmission = 1
	trail.Parent = root

	local auraCol = colorOf(Config.Auras, player:GetAttribute("Aura"), Color3.fromRGB(160, 80, 255))
	local hl = Instance.new("Highlight")
	hl.Name = "RaioHighlight"
	hl.FillColor = auraCol
	hl.OutlineColor = trailCol
	hl.FillTransparency = player:GetAttribute("Aura") ~= "" and 0.65 or 1
	hl.OutlineTransparency = 0.2
	hl.Parent = character

	local pe = Instance.new("ParticleEmitter")
	pe.Name = "RaioSparks"
	pe.Color = ColorSequence.new(trailCol)
	pe.Size = NumberSequence.new(0.4, 0)
	pe.Lifetime = NumberRange.new(0.3, 0.7)
	pe.Rate = 18
	pe.Speed = NumberRange.new(1, 4)
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	pe.LightEmission = 1
	pe.Parent = root

	local bb = Instance.new("BillboardGui")
	bb.Name = "SpeedBillboard"
	bb.Size = UDim2.fromOffset(160, 40)
	bb.StudsOffset = Vector3.new(0, 3.4, 0)
	bb.AlwaysOnTop = true
	bb.Parent = root
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.GothamBlack
	tl.TextScaled = true
	tl.TextColor3 = Color3.fromRGB(255, 230, 80)
	tl.Text = Config.Format(player:GetAttribute("Speed") or 0) .. " RAIO"
	tl.Parent = bb

	-- pet
	local petId = player:GetAttribute("Pet") or "Cub"
	local petCfg = Config.FindById(Config.Pets, petId) or Config.Pets[1]
	local pet = Instance.new("Part")
	pet.Name = "RaioPet"
	pet.Shape = Enum.PartType.Ball
	pet.Size = Vector3.new(1.8, 1.8, 1.8)
	pet.Material = Enum.Material.Neon
	pet.Color = petCfg.Color
	pet.Massless = true
	pet.CanCollide = false
	pet.CastShadow = false
	pet.Anchored = true
	pet.CFrame = root.CFrame * CFrame.new(2.4, 1.6, 1.2)
	pet.Parent = folder
	local light = Instance.new("PointLight")
	light.Color = petCfg.Color
	light.Brightness = 2
	light.Range = 10
	light.Parent = pet
	local pbb = Instance.new("BillboardGui")
	pbb.Size = UDim2.fromOffset(120, 24)
	pbb.StudsOffset = Vector3.new(0, 1.4, 0)
	pbb.AlwaysOnTop = true
	pbb.Parent = pet
	local pn = Instance.new("TextLabel")
	pn.BackgroundTransparency = 1
	pn.Size = UDim2.fromScale(1, 1)
	pn.Font = Enum.Font.GothamBold
	pn.TextScaled = true
	pn.TextColor3 = Color3.new(1, 1, 1)
	pn.Text = petCfg.Name
	pn.Parent = pbb

	local t0 = 0
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		if not character.Parent or not pet.Parent or not root.Parent then
			conn:Disconnect()
			return
		end
		t0 += dt
		local target = root.CFrame * CFrame.new(2.6, 1.4 + math.sin(t0 * 3) * 0.5, 1.3)
		pet.CFrame = pet.CFrame:Lerp(target, 0.18)
		tl.Text = Config.Format(player:GetAttribute("Speed") or 0) .. " RAIO"
	end)
end

local function onCharacter(character)
	task.wait(0.4)
	attachVfx(character)
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then
	task.spawn(onCharacter, player.Character)
end

player.AttributeChanged:Connect(function(name)
	if name == "Trail" or name == "Aura" or name == "Pet" or name == "Transform" then
		if player.Character then
			attachVfx(player.Character)
		end
	end
end)

-- shake leve no combo alto
local camera = workspace.CurrentCamera
player.AttributeChanged:Connect(function(name)
	if name == "Combo" then
		local combo = player:GetAttribute("Combo") or 0
		if combo >= 10 and camera then
			local cf = camera.CFrame
			camera.CFrame = cf * CFrame.new(0.08, 0, 0)
			task.delay(0.05, function()
				if camera then
					camera.CFrame = cf
				end
			end)
		end
	end
end)

-- tempestade: céu mais louco
workspace:GetAttributeChangedSignal("StormActive"):Connect(function()
	local cc = Lighting:FindFirstChild("RaioCC")
	if workspace:GetAttribute("StormActive") then
		if cc then
			TweenService:Create(cc, TweenInfo.new(0.4), { Contrast = 0.35, Saturation = 0.6 }):Play()
		end
		announce.Text = "🌩️ TEMPESTADE DOURADA!"
		announce.TextTransparency = 0
	else
		if cc then
			TweenService:Create(cc, TweenInfo.new(0.4), { Contrast = 0.12, Saturation = 0.25 }):Play()
		end
	end
end)

-- teclas: clique visual quando pisa
local lastFlash = {}
local function hookKeys()
	local world = workspace:WaitForChild("RaioWorld", 30)
	if not world then
		return
	end
	for _, part in ipairs(world:GetDescendants()) do
		if part:IsA("BasePart") and part:GetAttribute("RaioKey") then
			part.Touched:Connect(function(hit)
				local character = player.Character
				if not character or not hit:IsDescendantOf(character) then
					return
				end
				local now = os.clock()
				if (lastFlash[part] or 0) + 0.12 > now then
					return
				end
				lastFlash[part] = now
				local orig = part.Size
				TweenService:Create(part, TweenInfo.new(0.08), { Size = orig + Vector3.new(0, 0.8, 0) }):Play()
				task.delay(0.09, function()
					if part.Parent then
						TweenService:Create(part, TweenInfo.new(0.1), { Size = orig }):Play()
					end
				end)
			end)
		end
	end
end
task.spawn(hookKeys)

print("[+1 RAIO] HUD pronta. Corre!")
]===], SPS)

task.wait(0.1)
local World = require(folder:WaitForChild("World"))
World.Build()

local lighting = game:GetService("Lighting")
lighting.ClockTime = 21.4

print("================================================")
print("+1 RAIO KEYBOARD ESCAPE instalado com sucesso!")
print("Aperte Play. Ande em cima do teclado gigante.")
print("Codigos: RAIO  TEMPESTADE  DRAGAO  STREAMER  NEON  COMBO100")
print("================================================")
