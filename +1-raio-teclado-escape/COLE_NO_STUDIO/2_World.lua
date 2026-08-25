-- TIPO: ModuleScript   NOME: World   PASTA: ReplicatedStorage/RaioGame
-- Cole o conteúdo deste arquivo no script do Studio (apague o código padrão antes).

--[[
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
