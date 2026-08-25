--[[
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
