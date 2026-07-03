-----------------------------------------------------------------------------------------------------------------------------------------
-- RENDERIZAÇÃO DO WALL
-----------------------------------------------------------------------------------------------------------------------------------------
local PlayerBlips = {}
local InfoLines = {}
local StatsParts = {}

local Display = Config.Display
local Colors = Config.Colors
local DrawDistance = Config.DrawDistance
local DrawDistanceSq = DrawDistance * DrawDistance
local HeadOffset = Config.HeadOffset or 0.35
local TextScale = Config.TextScale or 0.22
local TextLineSpacing = Config.TextLineSpacing or 0.014
local LowHealth = Config.LowHealthThreshold or 120

local ShowPassport = Display.Passport
local ShowSteam = Display.SteamName
local ShowName = Display.Name
local ShowHealth = Display.Health
local ShowArmor = Display.Armor
local ShowWeapon = Display.Weapon
local ShowDistance = Display.Distance
local ShowGroup = Display.Group
local ShowStatus = Display.Status
local ShowLine = Display.Line
local ShowSkeleton = Display.Skeleton
local ShowBlip = Display.Blip
local ShowSelf = Display.Self
local ShowNpcs = Display.Npcs

local LineColor = Colors.Line
local SkeletonColor = Colors.Skeleton
local ColorAlive = Colors.Alive
local ColorLow = Colors.LowHealth
local ColorDead = Colors.Dead
local ColorStaff = Colors.Staff
local ColorSelf = Colors.Self

local SkeletonBones = {
	{ 31086, 39317 }, { 39317, 24818 }, { 24818, 24817 }, { 24817, 24816 },
	{ 24816, 23553 }, { 23553, 11816 }, { 24818, 10706 }, { 10706, 2992 },
	{ 2992, 28422 }, { 24818, 64729 }, { 64729, 22711 }, { 22711, 28252 },
	{ 11816, 58271 }, { 58271, 63931 }, { 63931, 14201 }, { 11816, 51826 },
	{ 51826, 36864 }, { 36864, 52301 }
}

local function ClearTable(T)
	for i = #T, 1, -1 do
		T[i] = nil
	end
end

local function DrawText3D(x, y, z, Lines, R, G, B, A)
	local OnScreen, ScreenX, ScreenY = World3dToScreen2d(x, y, z)
	if not OnScreen then return end

	SetTextFont(4)
	SetTextProportional(true)
	SetTextOutline()
	SetTextCentre(true)

	for i = 1, #Lines do
		local Scale = math.max(0.18, TextScale - ((i - 1) * 0.02))
		SetTextScale(Scale, Scale)
		SetTextColour(R, G, B, A)
		SetTextEntry("STRING")
		AddTextComponentString(Lines[i])
		DrawText(ScreenX, ScreenY - 0.03 - ((i - 1) * TextLineSpacing))
	end
end

function Wall_DrawText3D(x, y, z, Lines, Color)
	DrawText3D(x, y, z, Lines, Color[1] or 255, Color[2] or 255, Color[3] or 255, Color[4] or 230)
end

local function GetColor(Health, IsSelf, IsStaff, IsDead)
	if IsDead then return ColorDead end
	if IsSelf then return ColorSelf end
	if IsStaff then return ColorStaff end
	if Health <= LowHealth then return ColorLow end
	return ColorAlive
end

local function DrawLineToTarget(Px, Py, Pz, Tx, Ty, Tz)
	DrawLine(Px, Py, Pz, Tx, Ty, Tz, LineColor[1], LineColor[2], LineColor[3], LineColor[4])
end

local function DrawSkeleton(Ped)
	for i = 1, #SkeletonBones do
		local Pair = SkeletonBones[i]
		local Bone1 = GetPedBoneCoords(Ped, Pair[1], 0.0, 0.0, 0.0)
		local Bone2 = GetPedBoneCoords(Ped, Pair[2], 0.0, 0.0, 0.0)
		DrawLine(Bone1.x, Bone1.y, Bone1.z, Bone2.x, Bone2.y, Bone2.z, SkeletonColor[1], SkeletonColor[2], SkeletonColor[3], SkeletonColor[4])
	end
end

function Wall_ClearBlips()
	for ServerId, Blip in pairs(PlayerBlips) do
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
		end
		PlayerBlips[ServerId] = nil
	end
end

local function UpdateBlip(ServerId, Ped, Name)
	local Blip = PlayerBlips[ServerId]
	if not Blip or not DoesBlipExist(Blip) then
		Blip = AddBlipForEntity(Ped)
		SetBlipSprite(Blip, 1)
		SetBlipScale(Blip, 0.7)
		SetBlipColour(Blip, 3)
		SetBlipAsShortRange(Blip, false)
		PlayerBlips[ServerId] = Blip
	end

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Name)
	EndTextCommandSetBlipName(Blip)
end

local function BuildInfoLines(ServerId, Ped, Distance, PlayerData)
	ClearTable(InfoLines)
	ClearTable(StatsParts)

	local Health = GetEntityHealth(Ped)
	local IsDead = Wall_IsDead(Ped, Health)
	local MainLine

	if PlayerData then
		if ShowPassport and PlayerData.passport then
			MainLine = "~w~#" .. PlayerData.passport
		end

		if ShowSteam and PlayerData.steam then
			MainLine = MainLine and (MainLine .. " ~s~" .. PlayerData.steam) or ("~s~" .. PlayerData.steam)
		elseif ShowName and PlayerData.name then
			MainLine = MainLine and (MainLine .. " ~s~" .. PlayerData.name) or ("~s~" .. PlayerData.name)
		end
	end

	if MainLine then
		InfoLines[1] = MainLine
	end

	if ShowHealth then
		StatsParts[#StatsParts + 1] = IsDead and "~r~MORTO" or ("~g~" .. Wall_FormatHealth(Health) .. "%")
	end

	if ShowArmor and not IsDead then
		StatsParts[#StatsParts + 1] = "~b~" .. GetPedArmour(Ped) .. "%"
	end

	if ShowWeapon and not IsDead then
		StatsParts[#StatsParts + 1] = "~o~" .. Wall_GetWeaponLabel(GetSelectedPedWeapon(Ped))
	end

	if ShowDistance then
		StatsParts[#StatsParts + 1] = "~c~" .. Wall_Round(Distance, 1) .. "m"
	end

	if #StatsParts > 0 then
		InfoLines[#InfoLines + 1] = table.concat(StatsParts, " | ")
	end

	if ShowGroup and PlayerData and PlayerData.group then
		InfoLines[#InfoLines + 1] = "~p~" .. PlayerData.group
	end

	if ShowStatus then
		local State = Player(ServerId).state
		if State and (State.Death or State.death or State.Coma or State.coma or State.Arena or State.arena) then
			ClearTable(StatsParts)
			if State.Death or State.death or State.Coma or State.coma then
				StatsParts[#StatsParts + 1] = "~r~Coma"
			end
			if State.Arena or State.arena then
				StatsParts[#StatsParts + 1] = "~o~Arena"
			end
			InfoLines[#InfoLines + 1] = table.concat(StatsParts, " | ")
		end
	end

	return InfoLines, IsDead
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP PRINCIPAL (render + HUD em um único thread)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if not WallActive then
			if next(PlayerBlips) then
				Wall_ClearBlips()
			end
			Wait(1000)
		else
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local Px, Py, Pz = PedCoords.x, PedCoords.y, PedCoords.z
			local VisibleCount = 0
			local Players = GetActivePlayers()

			for i = 1, #Players do
				local PlayerId = Players[i]
				local TargetPed = GetPlayerPed(PlayerId)
				if TargetPed ~= 0 and DoesEntityExist(TargetPed) then
					local IsSelf = TargetPed == Ped
					if not IsSelf or ShowSelf then
						local ServerId = GetPlayerServerId(PlayerId)
						local TargetCoords = GetEntityCoords(TargetPed)
						local Dx = Px - TargetCoords.x
						local Dy = Py - TargetCoords.y
						local Dz = Pz - TargetCoords.z
						local DistSq = Dx * Dx + Dy * Dy + Dz * Dz

						if DistSq <= DrawDistanceSq then
							VisibleCount = VisibleCount + 1
							local PlayerData = WallPlayers[ServerId]
							local Health = GetEntityHealth(TargetPed)
							local Lines, IsDead = BuildInfoLines(ServerId, TargetPed, math.sqrt(DistSq), PlayerData)
							local Color = GetColor(Health, IsSelf, PlayerData and PlayerData.staff, IsDead)
							local Hx, Hy, Hz = Wall_GetHeadCoords(TargetPed)

							if #Lines > 0 then
								DrawText3D(Hx, Hy, Hz, Lines, Color[1], Color[2], Color[3], Color[4])
							end

							if ShowLine and not IsSelf then
								DrawLineToTarget(Px, Py, Pz, Hx, Hy, Hz)
							end

							if ShowSkeleton then
								DrawSkeleton(TargetPed)
							end

							if ShowBlip then
								UpdateBlip(ServerId, TargetPed, (PlayerData and (PlayerData.steam or PlayerData.name)) or ("#" .. ServerId))
							end
						elseif ShowBlip then
							local Blip = PlayerBlips[ServerId]
							if Blip then
								if DoesBlipExist(Blip) then
									RemoveBlip(Blip)
								end
								PlayerBlips[ServerId] = nil
							end
						end
					end
				end
			end

			SetTextFont(4)
			SetTextScale(0.32, 0.32)
			SetTextColour(100, 200, 255, 200)
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~b~WALL ATIVO~w~ | " .. VisibleCount .. " jogador(es)")
			DrawText(0.015, 0.02)

			Wait(Config.RenderSleep or 0)
		end
	end
end)
