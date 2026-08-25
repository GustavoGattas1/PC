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
]===])
makeModule("World", [===[--[[
	Mapa do jardim encantado: grama, madeira, pedra, teclado pastel.
	Letreiros viram placas (SurfaceGui) pra não ficar tudo empilhado no ar.
]]

local Config = require(script.Parent.Config)

local World = {}

local function wpart(parent, props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Material = props.Material or Enum.Material.SmoothPlastic
	p.Color = props.Color or Color3.fromRGB(180, 160, 130)
	p.Size = props.Size or Vector3.new(4, 1, 4)
	p.CFrame = props.CFrame or CFrame.new()
	p.Name = props.Name or "Part"
	p.Transparency = props.Transparency or 0
	p.CanCollide = props.CanCollide ~= false
	p.CastShadow = true
	if props.Shape then
		p.Shape = props.Shape
	end
	p.Parent = parent
	return p
end

local function faceLetter(part, text, color)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Top
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 18
	gui.LightInfluence = 0.35
	gui.Parent = part
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.FredokaOne
	tl.TextScaled = true
	tl.TextColor3 = color or Color3.fromRGB(50, 40, 30)
	tl.Text = text
	tl.Parent = gui
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.6
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.25
	stroke.Parent = tl
end

local function woodSign(parent, pos, text, color)
	local post = wpart(parent, {
		Name = "SignPost",
		Size = Vector3.new(1.2, 12, 1.2),
		CFrame = CFrame.new(pos + Vector3.new(0, 6, 0)),
		Color = Color3.fromRGB(120, 85, 50),
		Material = Enum.Material.Wood,
	})
	local board = wpart(parent, {
		Name = "SignBoard",
		Size = Vector3.new(16, 6, 0.7),
		CFrame = CFrame.new(pos + Vector3.new(0, 12, 0)),
		Color = Color3.fromRGB(165, 120, 70),
		Material = Enum.Material.WoodPlanks,
	})
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 25
	gui.LightInfluence = 0.2
	gui.Parent = board
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.FredokaOne
	tl.TextScaled = true
	tl.TextWrapped = true
	tl.TextColor3 = color or Color3.fromRGB(70, 45, 25)
	tl.Text = text
	tl.Parent = gui
	local back = gui:Clone()
	back.Face = Enum.NormalId.Back
	back.Parent = board
	return post, board
end

local function nearBillboard(part, text, color, maxDist)
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromOffset(180, 40)
	bb.StudsOffset = Vector3.new(0, 4.2, 0)
	bb.AlwaysOnTop = false
	bb.MaxDistance = maxDist or 42
	bb.Parent = part
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.FredokaOne
	tl.TextScaled = true
	tl.TextColor3 = color or Color3.fromRGB(70, 50, 30)
	tl.Text = text
	tl.Parent = bb
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.5
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = tl
end

local function tree(parent, pos, scale)
	scale = scale or 1
	wpart(parent, {
		Name = "Trunk",
		Size = Vector3.new(2.2 * scale, 10 * scale, 2.2 * scale),
		CFrame = CFrame.new(pos + Vector3.new(0, 5 * scale, 0)),
		Color = Color3.fromRGB(115, 80, 50),
		Material = Enum.Material.Wood,
	})
	for i, offset in ipairs({
		Vector3.new(0, 11 * scale, 0),
		Vector3.new(-3 * scale, 9.5 * scale, 1 * scale),
		Vector3.new(3 * scale, 9.2 * scale, -1 * scale),
		Vector3.new(0.5 * scale, 13 * scale, 0.4 * scale),
	}) do
		local leaf = wpart(parent, {
			Name = "Leaves",
			Size = Vector3.new((7 - i * 0.4) * scale, (7 - i * 0.4) * scale, (7 - i * 0.4) * scale),
			CFrame = CFrame.new(pos + offset),
			Color = Color3.fromRGB(70 + i * 12, 140 + i * 8, 70),
			Material = Enum.Material.LeafyGrass,
			Shape = Enum.PartType.Ball,
			CanCollide = false,
		})
		leaf.CanCollide = false
	end
end

local function flower(parent, pos, color)
	wpart(parent, {
		Name = "Stem",
		Size = Vector3.new(0.3, 2.2, 0.3),
		CFrame = CFrame.new(pos + Vector3.new(0, 1.1, 0)),
		Color = Color3.fromRGB(70, 130, 60),
		Material = Enum.Material.Grass,
		CanCollide = false,
	})
	local head = wpart(parent, {
		Name = "Bloom",
		Size = Vector3.new(1.6, 1.6, 1.6),
		CFrame = CFrame.new(pos + Vector3.new(0, 2.3, 0)),
		Color = color,
		Material = Enum.Material.SmoothPlastic,
		Shape = Enum.PartType.Ball,
		CanCollide = false,
	})
	head.CanCollide = false
end

local function rock(parent, pos, size)
	wpart(parent, {
		Name = "Rock",
		Size = size or Vector3.new(6, 3.5, 5),
		CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(math.random(0, 180)), math.rad(8)),
		Color = Color3.fromRGB(145, 140, 130),
		Material = Enum.Material.Rock,
	})
end

local function makeKey(parent, pos, letter, color, tags)
	local width = (letter == "SPACE") and 22 or (letter == "ENTER" or letter == "CTRL" or letter == "ALT") and 12 or Config.KeySize.X
	local base = wpart(parent, {
		Name = "KeyWood",
		Size = Vector3.new(width + 0.5, 0.55, Config.KeySize.Z + 0.5),
		CFrame = CFrame.new(pos.X, pos.Y - Config.KeySize.Y / 2 - 0.15, pos.Z),
		Color = Color3.fromRGB(120, 85, 52),
		Material = Enum.Material.WoodPlanks,
	})
	base.CanCollide = false
	local key = wpart(parent, {
		Name = "Key_" .. letter,
		Size = Vector3.new(width, Config.KeySize.Y, Config.KeySize.Z),
		CFrame = CFrame.new(pos),
		Color = color,
		Material = Enum.Material.SmoothPlastic,
	})
	key:SetAttribute("RaioKey", true)
	key:SetAttribute("Letter", letter)
	if tags then
		for k, v in pairs(tags) do
			key:SetAttribute(k, v)
		end
	end
	faceLetter(key, letter, Color3.fromRGB(55, 40, 30))
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

local function spinningHazard(parent, pos)
	local pivot = wpart(parent, {
		Name = "HazardPivot",
		Size = Vector3.new(2.4, 8, 2.4),
		CFrame = CFrame.new(pos),
		Color = Color3.fromRGB(120, 85, 50),
		Material = Enum.Material.Wood,
	})
	local bar = wpart(parent, {
		Name = "SpinBar",
		Size = Vector3.new(22, 1.2, 1.2),
		CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)),
		Color = Color3.fromRGB(170, 90, 60),
		Material = Enum.Material.WoodPlanks,
	})
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
	lighting.ClockTime = 14.2
	lighting.Brightness = 2.6
	lighting.Ambient = Color3.fromRGB(140, 145, 135)
	lighting.OutdoorAmbient = Color3.fromRGB(155, 155, 145)
	lighting.ColorShift_Top = Color3.fromRGB(255, 245, 220)
	lighting.FogColor = Color3.fromRGB(200, 220, 235)
	lighting.FogStart = 400
	lighting.FogEnd = 1800
	lighting.GlobalShadows = true
	lighting.ShadowSoftness = 0.4
	lighting.EnvironmentDiffuseScale = 0.5
	lighting.EnvironmentSpecularScale = 0.35

	for _, name in ipairs({ "RaioBloom", "RaioCC", "RaioAtmo", "RaioSun", "RaioSky", "RaioRays" }) do
		local old = lighting:FindFirstChild(name)
		if old then
			old:Destroy()
		end
	end

	local sky = Instance.new("Sky")
	sky.Name = "RaioSky"
	sky.CelestialBodiesShown = true
	sky.SunAngularSize = 12
	sky.MoonAngularSize = 8
	sky.StarCount = 0
	sky.Parent = lighting

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "RaioBloom"
	bloom.Intensity = 0.18
	bloom.Size = 8
	bloom.Threshold = 1.4
	bloom.Parent = lighting

	local cc = Instance.new("ColorCorrectionEffect")
	cc.Name = "RaioCC"
	cc.Saturation = 0.12
	cc.Contrast = 0.06
	cc.Brightness = 0.03
	cc.TintColor = Color3.fromRGB(255, 250, 240)
	cc.Parent = lighting

	local atmo = Instance.new("Atmosphere")
	atmo.Name = "RaioAtmo"
	atmo.Density = 0.22
	atmo.Offset = 0.08
	atmo.Color = Color3.fromRGB(200, 215, 180)
	atmo.Decay = Color3.fromRGB(170, 190, 220)
	atmo.Glare = 0.12
	atmo.Haze = 0.8
	atmo.Parent = lighting

	local rays = Instance.new("SunRaysEffect")
	rays.Name = "RaioRays"
	rays.Intensity = 0.12
	rays.Spread = 0.4
	rays.Parent = lighting
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
	world:SetAttribute("Theme", Config.ThemeVersion)

	local base = workspace:FindFirstChild("Baseplate")
	if base and base:IsA("BasePart") then
		base.Transparency = 1
		base.CanCollide = false
		base.CFrame = CFrame.new(0, -80, 0)
	end

	local terrain = workspace.Terrain
	pcall(function()
		terrain:Clear()
	end)
	terrain:FillBlock(CFrame.new(0, -5, 0), Vector3.new(480, 12, 480), Enum.Material.Grass)
	terrain:FillBlock(CFrame.new(0, -5, 1200), Vector3.new(110, 12, 2400), Enum.Material.Grass)

	-- deck de madeira do teclado
	wpart(world, {
		Name = "KeyboardDeck",
		Size = Vector3.new(118, 1.2, 62),
		CFrame = CFrame.new(0, 1.4, 18),
		Color = Color3.fromRGB(150, 110, 70),
		Material = Enum.Material.WoodPlanks,
	})

	-- portão de entrada (placa, não billboard)
	wpart(world, {
		Name = "GateL",
		Size = Vector3.new(3.5, 18, 3.5),
		CFrame = CFrame.new(-22, 10, -70),
		Color = Color3.fromRGB(120, 85, 50),
		Material = Enum.Material.Wood,
	})
	wpart(world, {
		Name = "GateR",
		Size = Vector3.new(3.5, 18, 3.5),
		CFrame = CFrame.new(22, 10, -70),
		Color = Color3.fromRGB(120, 85, 50),
		Material = Enum.Material.Wood,
	})
	local titleBar = wpart(world, {
		Name = "TitleBar",
		Size = Vector3.new(44, 7, 2.2),
		CFrame = CFrame.new(0, 18, -70),
		Color = Color3.fromRGB(165, 120, 70),
		Material = Enum.Material.WoodPlanks,
	})
	local titleGui = Instance.new("SurfaceGui")
	titleGui.Face = Enum.NormalId.Front
	titleGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	titleGui.PixelsPerStud = 22
	titleGui.LightInfluence = 0.15
	titleGui.Parent = titleBar
	local titleText = Instance.new("TextLabel")
	titleText.BackgroundTransparency = 1
	titleText.Size = UDim2.fromScale(1, 1)
	titleText.Font = Enum.Font.FredokaOne
	titleText.TextScaled = true
	titleText.TextColor3 = Color3.fromRGB(70, 45, 25)
	titleText.Text = "+1 RAIO   KEYBOARD ESCAPE"
	titleText.Parent = titleGui
	local titleBack = titleGui:Clone()
	titleBack.Face = Enum.NormalId.Back
	titleBack.Parent = titleBar

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "RaioSpawn"
	spawn.Size = Vector3.new(14, 1, 14)
	spawn.CFrame = CFrame.new(0, 2.2, -28)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.Material = Enum.Material.Grass
	spawn.Color = Color3.fromRGB(110, 170, 80)
	spawn.Parent = world
	faceLetter(spawn, "INÍCIO", Color3.fromRGB(50, 80, 40))

	local hubKeys = Instance.new("Folder")
	hubKeys.Name = "HubKeys"
	hubKeys.Parent = world
	buildKeyboard(hubKeys, Vector3.new(0, 2.85, 4), Config.KeyboardRows, Config.Palette, { Zone = "Hub" })

	-- natureza ao redor (longe o bastante pra não cobrir o teclado)
	for i = 1, 16 do
		local ang = i / 16 * math.pi * 2
		local r = 150 + (i % 4) * 12
		tree(world, Vector3.new(math.cos(ang) * r, 1, math.sin(ang) * r), 1 + (i % 3) * 0.25)
	end
	for i = 1, 24 do
		local ang = i / 24 * math.pi * 2
		flower(world, Vector3.new(math.cos(ang) * 88, 1, math.sin(ang) * 70), Config.Palette[(i % #Config.Palette) + 1])
	end
	rock(world, Vector3.new(-95, 2, 40), Vector3.new(8, 4, 6))
	rock(world, Vector3.new(100, 2, 30), Vector3.new(7, 3.5, 6))

	-- LOJA bem à esquerda
	local shopHouse = wpart(world, {
		Name = "ShopHouse",
		Size = Vector3.new(28, 14, 22),
		CFrame = CFrame.new(-170, 8, 0),
		Color = Color3.fromRGB(200, 90, 80),
		Material = Enum.Material.Brick,
	})
	wpart(world, {
		Name = "ShopRoof",
		Size = Vector3.new(34, 3, 28),
		CFrame = CFrame.new(-170, 16.5, 0),
		Color = Color3.fromRGB(140, 70, 50),
		Material = Enum.Material.RoofShingles,
	})
	local shop = wpart(world, {
		Name = "ShopPad",
		Size = Vector3.new(16, 1.4, 16),
		CFrame = CFrame.new(-170, 1.7, 18),
		Color = Color3.fromRGB(200, 90, 80),
		Material = Enum.Material.Brick,
	})
	shop:SetAttribute("ShopPad", true)
	woodSign(world, Vector3.new(-170, 1, 28), "LOJA", Color3.fromRGB(140, 40, 40))

	-- CÓDIGOS bem à direita
	wpart(world, {
		Name = "CodeHouse",
		Size = Vector3.new(22, 12, 22),
		CFrame = CFrame.new(170, 7, 0),
		Color = Color3.fromRGB(90, 150, 110),
		Material = Enum.Material.Cobblestone,
	})
	local codes = wpart(world, {
		Name = "CodePad",
		Size = Vector3.new(14, 1.4, 14),
		CFrame = CFrame.new(170, 1.7, 18),
		Color = Color3.fromRGB(90, 160, 100),
		Material = Enum.Material.Grass,
	})
	codes:SetAttribute("CodePad", true)
	woodSign(world, Vector3.new(170, 1, 28), "CÓDIGOS", Color3.fromRGB(40, 90, 50))

	-- REBIRTH atrás do spawn
	local rebirth = wpart(world, {
		Name = "RebirthPad",
		Size = Vector3.new(18, 1.6, 18),
		CFrame = CFrame.new(0, 1.8, -95) * CFrame.Angles(0, 0, math.rad(90)),
		Color = Color3.fromRGB(230, 190, 70),
		Material = Enum.Material.Metal,
		Shape = Enum.PartType.Cylinder,
	})
	rebirth:SetAttribute("RebirthPad", true)
	woodSign(world, Vector3.new(0, 1, -108), "REBIRTH", Color3.fromRGB(140, 100, 20))

	-- ESTEIRAS mais atrás ainda, espaçadas
	local tmFolder = Instance.new("Folder")
	tmFolder.Name = "Treadmills"
	tmFolder.Parent = world
	local tmMaterials = {
		Free = Enum.Material.WoodPlanks,
		Gold = Enum.Material.Brick,
		Diamond = Enum.Material.Marble,
		Storm = Enum.Material.Foil,
	}
	for i, tm in ipairs(Config.Treadmills) do
		local x = -48 + (i - 1) * 32
		local p = wpart(tmFolder, {
			Name = "Treadmill_" .. tm.Id,
			Size = Vector3.new(18, 2, 12),
			CFrame = CFrame.new(x, 2, -150),
			Color = tm.Color,
			Material = tmMaterials[tm.Id] or Enum.Material.WoodPlanks,
		})
		p:SetAttribute("Treadmill", true)
		p:SetAttribute("TreadmillId", tm.Id)
		p:SetAttribute("TreadmillMult", tm.Mult)
		woodSign(tmFolder, Vector3.new(x, 1, -162), tm.Name .. "\nx" .. tm.Mult, Color3.fromRGB(70, 50, 30))
	end

	-- caminho de pedra até as fases
	wpart(world, {
		Name = "StonePath",
		Size = Vector3.new(28, 0.6, 180),
		CFrame = CFrame.new(0, 1.15, 140),
		Color = Color3.fromRGB(150, 145, 135),
		Material = Enum.Material.Cobblestone,
	})
	woodSign(world, Vector3.new(18, 1, 70), "FASES →", Color3.fromRGB(70, 50, 30))

	local stagesFolder = Instance.new("Folder")
	stagesFolder.Name = "Stages"
	stagesFolder.Parent = world

	local z = 260
	for index, stage in ipairs(Config.Stages) do
		local folder = Instance.new("Folder")
		folder.Name = "Stage_" .. index
		folder.Parent = stagesFolder

		pcall(function()
			terrain:FillBlock(CFrame.new(0, -4.2, z + 70), Vector3.new(88, 10, 170), stage.Terrain or Enum.Material.Grass)
		end)

		wpart(folder, {
			Name = "StageFloor",
			Size = Vector3.new(70, 1, 150),
			CFrame = CFrame.new(0, 1.2, z + 70),
			Color = stage.Color,
			Material = stage.Terrain or Enum.Material.Grass,
		})

		woodSign(folder, Vector3.new(-22, 1, z + 4), string.format("FASE %d\n%s\nNível %d", index, stage.Name, stage.RequiredLevel), Color3.fromRGB(50, 40, 30))

		local rows = {
			{ "Q", "W", "E", "R", "T" },
			{ "A", "S", "D", "F", "G" },
		}
		if stage.Keys >= 14 then
			table.insert(rows, { "Z", "X", "C", "V", "B" })
		end
		buildKeyboard(folder, Vector3.new(0, 2.7, z + 22), rows, { stage.Color, Config.Palette[(index % #Config.Palette) + 1] }, {
			Zone = "Stage",
			Stage = index,
		})

		local gapZ = z + 68
		local before = wpart(folder, {
			Name = "GapEdgeA",
			Size = Vector3.new(26, 1.6, 8),
			CFrame = CFrame.new(0, 2.1, gapZ),
			Color = stage.Color,
			Material = Enum.Material.WoodPlanks,
		})
		before:SetAttribute("RaioKey", true)
		before:SetAttribute("Letter", "JUMP")
		faceLetter(before, "PULA!", Color3.fromRGB(50, 40, 30))

		local after = wpart(folder, {
			Name = "GapEdgeB",
			Size = Vector3.new(26, 1.6, 8),
			CFrame = CFrame.new(0, 2.1, gapZ + stage.Gap + 8),
			Color = stage.Color,
			Material = Enum.Material.WoodPlanks,
		})
		after:SetAttribute("RaioKey", true)
		after:SetAttribute("Letter", "NICE")
		faceLetter(after, "NICE", Color3.fromRGB(50, 40, 30))

		if index >= 3 then
			spinningHazard(folder, Vector3.new(0, 5, z + 52))
		end
		if index >= 5 then
			spinningHazard(folder, Vector3.new(-10, 5, z + 100))
			spinningHazard(folder, Vector3.new(10, 5, z + 100))
		end

		buildKeyboard(folder, Vector3.new(0, 2.7, gapZ + stage.Gap + 20), {
			{ "1", "2", "3", "4", "5", "6" },
		}, { stage.Color }, { Zone = "Stage", Stage = index })

		local win = wpart(folder, {
			Name = "WinPad",
			Size = Vector3.new(16, 1.6, 16),
			CFrame = CFrame.new(0, 2.2, z + 148) * CFrame.Angles(0, 0, math.rad(90)),
			Color = Color3.fromRGB(230, 190, 70),
			Material = Enum.Material.Metal,
			Shape = Enum.PartType.Cylinder,
		})
		win:SetAttribute("WinPad", true)
		win:SetAttribute("Stage", index)
		win:SetAttribute("Wins", stage.Wins)
		win:SetAttribute("RequiredLevel", stage.RequiredLevel)
		nearBillboard(win, "+" .. stage.Wins .. " WINS", Color3.fromRGB(160, 110, 20), 50)

		local cp = Instance.new("SpawnLocation")
		cp.Name = "Checkpoint"
		cp.Size = Vector3.new(10, 1, 10)
		cp.CFrame = CFrame.new(0, 2.2, z + 8)
		cp.Anchored = true
		cp.Neutral = true
		cp.Enabled = false
		cp.Duration = 0
		cp.Transparency = 0.45
		cp.Material = Enum.Material.Cobblestone
		cp.Color = stage.Color
		cp.Parent = folder
		cp:SetAttribute("Stage", index)

		tree(folder, Vector3.new(-32, 1, z + 40), 1.1)
		tree(folder, Vector3.new(32, 1, z + 40), 1.1)

		z += 200
	end

	local dragon = Instance.new("Model")
	dragon.Name = "StormDragon"
	dragon.Parent = world
	local body = wpart(dragon, {
		Name = "Body",
		Size = Vector3.new(16, 7, 28),
		CFrame = CFrame.new(-90, 18, -180),
		Color = Color3.fromRGB(90, 140, 100),
		Material = Enum.Material.Slate,
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
		Size = Vector3.new(8, 7, 10),
		CFrame = CFrame.new(-90, 21, -164),
		Color = Color3.fromRGB(120, 90, 60),
		Material = Enum.Material.Rock,
	})
	head:SetAttribute("Dragon", true)
	weldToBody(head)
	for _, side in ipairs({ -1, 1 }) do
		local wing = wpart(dragon, {
			Name = "Wing",
			Size = Vector3.new(22, 1, 9),
			CFrame = CFrame.new(-90 + 16 * side, 20, -180) * CFrame.Angles(0, 0, math.rad(16 * side)),
			Color = Color3.fromRGB(200, 210, 190),
			Material = Enum.Material.Fabric,
			CanCollide = false,
		})
		weldToBody(wing)
	end
	woodSign(world, Vector3.new(-90, 1, -198), "DRAGÃO\nDO JARDIM", Color3.fromRGB(50, 80, 50))
	dragon.PrimaryPart = body

	local trophy = wpart(world, {
		Name = "FinalTrophy",
		Size = Vector3.new(10, 16, 10),
		CFrame = CFrame.new(0, 10, z + 16),
		Color = Color3.fromRGB(230, 190, 70),
		Material = Enum.Material.Metal,
	})
	woodSign(world, Vector3.new(0, 1, z + 30), "VOCÊ ESCAPOU!", Color3.fromRGB(120, 90, 20))

	world:SetAttribute("Built", true)
	world:SetAttribute("EndZ", z)
	world:SetAttribute("SpawnCFrame", tostring(CFrame.new(0, 8, -24)))
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

World.Build()

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
local stepAcc = {}
local winCooldown = {}
local padOpenAt = {}
local spinning = {}
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude

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

	local combo = player:GetAttribute("Combo") or 0
	if not isTread then
		if (now - (lastComboAt[player] or 0)) > Config.ComboWindow then
			combo = 1
		else
			combo += 1
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
	local grants = (player:GetAttribute("GrantCount") or 0) + 1
	player:SetAttribute("GrantCount", grants)
	if lucky or grants <= 20 or grants % 3 == 0 then
		popup(player, (lucky and "LUCKY +" or "+") .. Config.Format(gain), lucky and Color3.fromRGB(80, 160, 90) or Color3.fromRGB(210, 150, 40))
	end
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
		if part:IsA("BasePart") and part:GetAttribute("WinPad") then
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
		elseif part:IsA("BasePart") and (part:GetAttribute("ShopPad") or part:GetAttribute("CodePad") or part:GetAttribute("RebirthPad")) then
			part.Touched:Connect(function(hit)
				local player = isCharacterPart(hit)
				if not player then
					return
				end
				local kind = part:GetAttribute("ShopPad") and "shop" or (part:GetAttribute("CodePad") and "codes" or "rebirth")
				local now = os.clock()
				if (padOpenAt[player] or 0) + 1.4 > now then
					return
				end
				padOpenAt[player] = now
				if kind == "shop" then
					RE.OpenShop:FireClient(player)
				elseif kind == "codes" then
					RE.OpenCodes:FireClient(player)
				else
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
					popup(player, "O moinho te pegou! Tenta de novo.", Color3.fromRGB(200, 80, 70))
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
					announce(player.DisplayName .. " foi pego pelo Dragão do Jardim!", Color3.fromRGB(90, 140, 90))
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
			popup(player, Config.Tagline, Color3.fromRGB(90, 150, 80))
			RE.Announce:FireClient(player, "Pise nas teclas coloridas! A velocidade sobe a cada passo.", Color3.fromRGB(200, 140, 50))
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	saveProfile(player)
	profiles[player] = nil
	lastStep[player] = nil
	lastKey[player] = nil
	stepAcc[player] = nil
	padOpenAt[player] = nil
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

-- passos no teclado + esteira (raycast no chão — confiável)
local lastTreadWarn = {}
RunService.Heartbeat:Connect(function(dt)
	for _, pivot in ipairs(spinning) do
		if pivot.Parent then
			pivot.CFrame *= CFrame.Angles(0, dt * 1.35, 0)
		end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		local profile = profiles[player]
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not profile or not root or not humanoid or humanoid.Health <= 0 then
			continue
		end
		overlapParams.FilterDescendantsInstances = { character }
		local feet = root.Position - Vector3.new(0, 2.5, 0)
		local parts = workspace:GetPartBoundsInBox(CFrame.new(feet), Vector3.new(5, 3.5, 5), overlapParams)
		local keyPart, treadPart
		for _, part in ipairs(parts) do
			if part:GetAttribute("Treadmill") then
				treadPart = part
			elseif part:GetAttribute("RaioKey") then
				keyPart = part
			end
		end
		if treadPart then
			local id = treadPart:GetAttribute("TreadmillId")
			if owns(profile.OwnedTreadmills, id) then
				stepAcc[player] = (stepAcc[player] or 0) + dt / Config.TreadmillTick
				while (stepAcc[player] or 0) >= 1 do
					stepAcc[player] -= 1
					grantSpeed(player, treadPart:GetAttribute("TreadmillMult") or 1, "TREAD", false)
				end
			else
				local now = os.clock()
				if (lastTreadWarn[player] or 0) + 2 < now then
					lastTreadWarn[player] = now
					popup(player, "Compre essa esteira na loja!", Color3.fromRGB(200, 90, 70))
				end
			end
		elseif keyPart then
			local moving = humanoid.MoveDirection.Magnitude > 0.08
			local rate = moving and Config.StepsPerSecondMoving or Config.StepsPerSecondIdle
			stepAcc[player] = (stepAcc[player] or 0) + dt * rate
			while (stepAcc[player] or 0) >= 1 do
				stepAcc[player] -= 1
				local lucky = math.random() < Config.LuckyKeyChance
				if lucky then
					local orig = keyPart.Color
					keyPart.Color = Color3.fromRGB(255, 220, 90)
					task.delay(0.28, function()
						if keyPart.Parent then
							keyPart.Color = orig
						end
					end)
				end
				grantSpeed(player, 1, keyPart:GetAttribute("Letter"), lucky)
			end
		else
			stepAcc[player] = 0
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

-- evento dourado (streamer bait)
task.spawn(function()
	while true do
		task.wait(Config.StormInterval)
		workspace:SetAttribute("StormActive", true)
		announce("FESTA DOURADA!  x" .. Config.StormMultiplier .. " velocidade por " .. Config.StormDuration .. "s", Color3.fromRGB(220, 170, 50))
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
	s.Volume = 0.22
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
top.BackgroundColor3 = Color3.fromRGB(245, 236, 214)
top.BackgroundTransparency = 0.08
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 78)
top.Parent = gui
gradient(top, Color3.fromRGB(250, 240, 215), Color3.fromRGB(210, 190, 150), 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0.5, -220, 0, 6)
title.Size = UDim2.fromOffset(440, 36)
title.Font = Enum.Font.FredokaOne
title.Text = "+1 RAIO  •  KEYBOARD ESCAPE"
title.TextColor3 = Color3.fromRGB(90, 60, 30)
title.TextScaled = true
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0.5, -240, 0, 42)
subtitle.Size = UDim2.fromOffset(480, 24)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "Pise no teclado  •  A velocidade sobe sozinha  •  Pule as fases"
subtitle.TextColor3 = Color3.fromRGB(110, 90, 60)
subtitle.TextScaled = true
subtitle.Parent = top

local function statCard(parent, pos, labelText, color)
	local f = Instance.new("Frame")
	f.BackgroundColor3 = Color3.fromRGB(255, 250, 235)
	f.BackgroundTransparency = 0.05
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
	v.Font = Enum.Font.FredokaOne
	v.Text = "0"
	v.TextColor3 = Color3.fromRGB(50, 40, 30)
	v.TextScaled = true
	v.Parent = f
	return v
end

local speedVal = statCard(gui, UDim2.new(0, 16, 0, 92), "VELOCIDADE", Color3.fromRGB(200, 140, 40))
local levelVal = statCard(gui, UDim2.new(0, 16, 0, 166), "NÍVEL", Color3.fromRGB(70, 140, 90))
local winsVal = statCard(gui, UDim2.new(0, 16, 0, 240), "WINS", Color3.fromRGB(200, 150, 50))
local multVal = statCard(gui, UDim2.new(0, 16, 0, 314), "MULTIPLICADOR", Color3.fromRGB(180, 100, 70))
local rebirthVal = statCard(gui, UDim2.new(0, 16, 0, 388), "REBIRTHS", Color3.fromRGB(90, 130, 90))

local comboFrame = Instance.new("Frame")
comboFrame.BackgroundColor3 = Color3.fromRGB(255, 248, 230)
comboFrame.BackgroundTransparency = 0.05
comboFrame.BorderSizePixel = 0
comboFrame.Position = UDim2.new(0.5, -140, 0, 92)
comboFrame.Size = UDim2.fromOffset(280, 58)
comboFrame.Parent = gui
corner(comboFrame, 14)
stroke(comboFrame, Color3.fromRGB(210, 120, 70), 1.7)

local comboLabel = Instance.new("TextLabel")
comboLabel.BackgroundTransparency = 1
comboLabel.Size = UDim2.fromScale(1, 1)
comboLabel.Font = Enum.Font.GothamBlack
comboLabel.Text = "COMBO x0"
comboLabel.TextColor3 = Color3.fromRGB(180, 100, 50)
comboLabel.TextScaled = true
comboLabel.Parent = comboFrame
pad(comboLabel, 8)

local transformLabel = Instance.new("TextLabel")
transformLabel.BackgroundTransparency = 1
transformLabel.Position = UDim2.new(0.5, -180, 0, 154)
transformLabel.Size = UDim2.fromOffset(360, 28)
transformLabel.Font = Enum.Font.GothamBold
transformLabel.Text = ""
transformLabel.TextColor3 = Color3.fromRGB(160, 110, 40)
transformLabel.TextScaled = true
transformLabel.Parent = gui

local announce = Instance.new("TextLabel")
announce.BackgroundTransparency = 1
announce.Position = UDim2.new(0.5, -320, 0, 188)
announce.Size = UDim2.fromOffset(640, 42)
announce.Font = Enum.Font.GothamBlack
announce.Text = ""
announce.TextColor3 = Color3.fromRGB(120, 80, 40)
announce.TextScaled = true
announce.TextStrokeTransparency = 0.4
announce.Parent = gui

local plus = Instance.new("TextLabel")
plus.BackgroundTransparency = 1
plus.Position = UDim2.new(0.5, -150, 0.42, 0)
plus.Size = UDim2.fromOffset(300, 80)
plus.Font = Enum.Font.GothamBlack
plus.Text = ""
plus.TextColor3 = Color3.fromRGB(200, 140, 40)
plus.TextScaled = true
plus.TextStrokeTransparency = 0.3
plus.Parent = gui

local function makeButton(text, pos, color, order)
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = Color3.fromRGB(255, 248, 230)
	b.BorderSizePixel = 0
	b.Position = pos
	b.Size = UDim2.fromOffset(168, 48)
	b.Font = Enum.Font.FredokaOne
	b.Text = text
	b.TextColor3 = Color3.fromRGB(60, 45, 30)
	b.TextScaled = true
	b.AutoButtonColor = true
	b.LayoutOrder = order or 0
	b.Parent = gui
	corner(b, 12)
	stroke(b, color, 1.8)
	pad(b, 6)
	return b
end

local shopBtn = makeButton("LOJA", UDim2.new(1, -184, 0, 92), Color3.fromRGB(190, 90, 80))
local rebirthBtn = makeButton("REBIRTH", UDim2.new(1, -184, 0, 150), Color3.fromRGB(210, 160, 50))
local codesBtn = makeButton("CÓDIGOS", UDim2.new(1, -184, 0, 208), Color3.fromRGB(80, 140, 90))
local hubBtn = makeButton("INÍCIO", UDim2.new(1, -184, 0, 266), Color3.fromRGB(90, 140, 180))
local petBtn = makeButton("PETS", UDim2.new(1, -184, 0, 324), Color3.fromRGB(200, 130, 70))

local hint = Instance.new("TextLabel")
hint.BackgroundTransparency = 1
hint.Position = UDim2.new(0.5, -260, 1, -54)
hint.Size = UDim2.fromOffset(520, 36)
hint.Font = Enum.Font.GothamMedium
hint.Text = "Pise nas teclas coloridas — a VELOCIDADE sobe sozinha. Siga a estrada de pedra para as fases."
hint.TextColor3 = Color3.fromRGB(90, 75, 55)
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
	f.BackgroundColor3 = Color3.fromRGB(255, 248, 230)
	f.BorderSizePixel = 0
	f.Parent = gui
	corner(f, 18)
	stroke(f, Color3.fromRGB(180, 130, 70), 2)
	gradient(f, Color3.fromRGB(255, 250, 235), Color3.fromRGB(230, 210, 175), 90)

	local h = Instance.new("TextLabel")
	h.BackgroundTransparency = 1
	h.Size = UDim2.new(1, -70, 0, 48)
	h.Position = UDim2.fromOffset(18, 10)
	h.Font = Enum.Font.FredokaOne
	h.Text = titleText
	h.TextColor3 = Color3.fromRGB(70, 50, 30)
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

local shopPanel, shopList = panel("Shop", "LOJA")
local petPanel, petList = panel("Pets", "PETS")
local rebirthPanel = panel("Rebirth", "REBIRTH")
rebirthPanel.Size = UDim2.fromOffset(480, 280)

local rebirthInfo = Instance.new("TextLabel")
rebirthInfo.BackgroundTransparency = 1
rebirthInfo.Position = UDim2.fromOffset(20, 70)
rebirthInfo.Size = UDim2.new(1, -40, 0, 110)
rebirthInfo.Font = Enum.Font.GothamMedium
rebirthInfo.TextWrapped = true
rebirthInfo.TextColor3 = Color3.fromRGB(80, 60, 40)
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
codesPanel.BackgroundColor3 = Color3.fromRGB(255, 248, 230)
codesPanel.BorderSizePixel = 0
codesPanel.Parent = gui
corner(codesPanel, 16)
stroke(codesPanel, Color3.fromRGB(90, 150, 90), 2)

local codesTitle = Instance.new("TextLabel")
codesTitle.BackgroundTransparency = 1
codesTitle.Size = UDim2.new(1, -20, 0, 40)
codesTitle.Position = UDim2.fromOffset(10, 10)
codesTitle.Font = Enum.Font.FredokaOne
codesTitle.Text = "RESGATAR CÓDIGO"
codesTitle.TextColor3 = Color3.fromRGB(60, 45, 30)
codesTitle.TextScaled = true
codesTitle.Parent = codesPanel

local codesBox = Instance.new("TextBox")
codesBox.Size = UDim2.new(1, -40, 0, 48)
codesBox.Position = UDim2.fromOffset(20, 64)
codesBox.BackgroundColor3 = Color3.fromRGB(255, 255, 245)
codesBox.PlaceholderText = "ex: RAIO"
codesBox.Text = ""
codesBox.Font = Enum.Font.GothamBold
codesBox.TextColor3 = Color3.fromRGB(50, 40, 30)
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
	b.BackgroundColor3 = Color3.fromRGB(255, 252, 240)
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
	t.Font = Enum.Font.FredokaOne
	t.Text = text
	t.TextColor3 = Color3.fromRGB(50, 40, 30)
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
		h.TextColor3 = Color3.fromRGB(140, 90, 40)
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

	local trailCol = colorOf(Config.Trails, player:GetAttribute("Trail"), Color3.fromRGB(120, 180, 90))
	local trail = Instance.new("Trail")
	trail.Name = "RaioTrail"
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Lifetime = 0.35
	trail.MinLength = 0.2
	trail.FaceCamera = true
	trail.Color = ColorSequence.new(trailCol, Color3.fromRGB(255, 245, 220))
	trail.Transparency = NumberSequence.new(0.35, 1)
	trail.WidthScale = NumberSequence.new(0.8, 0)
	trail.LightEmission = 0.2
	trail.Parent = root

	local auraCol = colorOf(Config.Auras, player:GetAttribute("Aura"), Color3.fromRGB(200, 180, 120))
	local hl = Instance.new("Highlight")
	hl.Name = "RaioHighlight"
	hl.FillColor = auraCol
	hl.OutlineColor = trailCol
	hl.FillTransparency = player:GetAttribute("Aura") ~= "" and 0.78 or 1
	hl.OutlineTransparency = 0.45
	hl.Parent = character

	local pe = Instance.new("ParticleEmitter")
	pe.Name = "RaioSparks"
	pe.Color = ColorSequence.new(trailCol)
	pe.Size = NumberSequence.new(0.25, 0)
	pe.Lifetime = NumberRange.new(0.3, 0.6)
	pe.Rate = 8
	pe.Speed = NumberRange.new(0.5, 2)
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	pe.LightEmission = 0.3
	pe.Parent = root

	local bb = Instance.new("BillboardGui")
	bb.Name = "SpeedBillboard"
	bb.Size = UDim2.fromOffset(140, 32)
	bb.StudsOffset = Vector3.new(0, 3.2, 0)
	bb.AlwaysOnTop = false
	bb.MaxDistance = 55
	bb.Parent = root
	local tl = Instance.new("TextLabel")
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.fromScale(1, 1)
	tl.Font = Enum.Font.FredokaOne
	tl.TextScaled = true
	tl.TextColor3 = Color3.fromRGB(90, 60, 30)
	tl.Text = Config.Format(player:GetAttribute("Speed") or 0) .. " RAIO"
	tl.Parent = bb

	-- pet
	local petId = player:GetAttribute("Pet") or "Cub"
	local petCfg = Config.FindById(Config.Pets, petId) or Config.Pets[1]
	local pet = Instance.new("Part")
	pet.Name = "RaioPet"
	pet.Shape = Enum.PartType.Ball
	pet.Size = Vector3.new(1.8, 1.8, 1.8)
	pet.Material = Enum.Material.SmoothPlastic
	pet.Color = petCfg.Color
	pet.Massless = true
	pet.CanCollide = false
	pet.CastShadow = true
	pet.Anchored = true
	pet.CFrame = root.CFrame * CFrame.new(2.4, 1.6, 1.2)
	pet.Parent = folder
	local pbb = Instance.new("BillboardGui")
	pbb.Size = UDim2.fromOffset(110, 22)
	pbb.StudsOffset = Vector3.new(0, 1.3, 0)
	pbb.AlwaysOnTop = false
	pbb.MaxDistance = 40
	pbb.Parent = pet
	local pn = Instance.new("TextLabel")
	pn.BackgroundTransparency = 1
	pn.Size = UDim2.fromScale(1, 1)
	pn.Font = Enum.Font.GothamBold
	pn.TextScaled = true
	pn.TextColor3 = Color3.fromRGB(60, 45, 30)
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
			TweenService:Create(cc, TweenInfo.new(0.4), { Contrast = 0.12, Saturation = 0.22, TintColor = Color3.fromRGB(255, 240, 200) }):Play()
		end
		announce.Text = "FESTA DOURADA!"
		announce.TextTransparency = 0
	else
		if cc then
			TweenService:Create(cc, TweenInfo.new(0.4), { Contrast = 0.06, Saturation = 0.12, TintColor = Color3.fromRGB(255, 250, 240) }):Play()
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
