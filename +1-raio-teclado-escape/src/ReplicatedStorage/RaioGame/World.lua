--[[
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
