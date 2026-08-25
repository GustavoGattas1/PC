-- TIPO: LocalScript   NOME: RaioClient   PASTA: StarterPlayer/StarterPlayerScripts
-- Cole o conteúdo deste arquivo no script do Studio (apague o código padrão antes).

--[[
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
