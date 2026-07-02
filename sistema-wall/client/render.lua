-----------------------------------------------------------------------------------------------------------------------------------------
-- RENDERIZAÇÃO DO WALL
-----------------------------------------------------------------------------------------------------------------------------------------

local PlayerBlips = {}

local SkeletonBones = {
	{ 31086, 39317 },
	{ 39317, 24818 },
	{ 24818, 24817 },
	{ 24817, 24816 },
	{ 24816, 23553 },
	{ 23553, 11816 },
	{ 24818, 10706 },
	{ 10706, 2992 },
	{ 2992, 28422 },
	{ 24818, 64729 },
	{ 64729, 22711 },
	{ 22711, 28252 },
	{ 11816, 58271 },
	{ 58271, 63931 },
	{ 63931, 14201 },
	{ 11816, 51826 },
	{ 51826, 36864 },
	{ 36864, 52301 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESENHO DE TEXTO
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_DrawText3D(x, y, z, Lines, Color)
	local OnScreen, ScreenX, ScreenY = World3dToScreen2d(x, y, z)
	if not OnScreen then return end

	local R = Color and Color[1] or 255
	local G = Color and Color[2] or 255
	local B = Color and Color[3] or 255
	local A = Color and Color[4] or 230
	local BaseScale = Config.TextScale or 0.22
	local LineSpacing = Config.TextLineSpacing or 0.014

	for Index, Line in ipairs(Lines) do
		local Scale = math.max(0.18, BaseScale - ((Index - 1) * 0.02))
		SetTextScale(Scale, Scale)
		SetTextFont(4)
		SetTextProportional(true)
		SetTextColour(R, G, B, A)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(Line)
		DrawText(ScreenX, ScreenY + ((Index - 1) * LineSpacing))
	end
end

function Wall_GetColor(Ped, Health, IsSelf, IsStaff)
	if Wall_IsDead(Ped, Health) then
		return Config.Colors.Dead
	end

	if IsSelf then
		return Config.Colors.Self
	end

	if IsStaff then
		return Config.Colors.Staff
	end

	if Health and Health <= Config.LowHealthThreshold then
		return Config.Colors.LowHealth
	end

	return Config.Colors.Alive
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LINHA ATÉ O JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_DrawLineToTarget(PedCoords, TargetCoords)
	local C = Config.Colors.Line
	DrawLine(
		PedCoords.x, PedCoords.y, PedCoords.z,
		TargetCoords.x, TargetCoords.y, TargetCoords.z + 0.5,
		C[1], C[2], C[3], C[4]
	)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESQUELETO
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_DrawSkeleton(Ped)
	local C = Config.Colors.Skeleton

	for _, Pair in ipairs(SkeletonBones) do
		local Bone1 = GetPedBoneCoords(Ped, Pair[1], 0.0, 0.0, 0.0)
		local Bone2 = GetPedBoneCoords(Ped, Pair[2], 0.0, 0.0, 0.0)

		if Bone1 and Bone2 then
			DrawLine(Bone1.x, Bone1.y, Bone1.z, Bone2.x, Bone2.y, Bone2.z, C[1], C[2], C[3], C[4])
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_UpdateBlip(ServerId, Ped, Name)
	if not WallDisplay.Blip then return end

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
	AddTextComponentString(Name or ("Jogador " .. ServerId))
	EndTextCommandSetBlipName(Blip)
end

function Wall_ClearBlips()
	for ServerId, Blip in pairs(PlayerBlips) do
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
		end
		PlayerBlips[ServerId] = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONTAR LINHAS DE INFO
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_BuildInfoLines(ServerId, Ped, Distance, PlayerData)
	local Lines = {}
	local Health = GetEntityHealth(Ped)
	local Armor = GetPedArmour(Ped)
	local IsDead = Wall_IsDead(Ped, Health)
	local WeaponHash = GetSelectedPedWeapon(Ped)

	local MainLine = ""

	if WallDisplay.Passport and PlayerData and PlayerData.passport then
		MainLine = "~w~#" .. PlayerData.passport
	end

	if WallDisplay.SteamName and PlayerData and PlayerData.steam then
		MainLine = MainLine .. (MainLine ~= "" and " ~s~" or "~s~") .. PlayerData.steam
	elseif WallDisplay.Name and PlayerData and PlayerData.name then
		MainLine = MainLine .. (MainLine ~= "" and " ~s~" or "~s~") .. PlayerData.name
	end

	if MainLine ~= "" then
		Lines[#Lines + 1] = MainLine
	end

	if WallDisplay.Health then
		if IsDead then
			Lines[#Lines + 1] = "~r~MORTO"
		else
			Lines[#Lines + 1] = "~g~" .. Wall_FormatHealth(Health) .. "%"
		end
	end

	if WallDisplay.Armor and not IsDead then
		Lines[#Lines + 1] = "~b~" .. Armor .. "%"
	end

	if WallDisplay.Weapon and not IsDead then
		Lines[#Lines + 1] = "~o~" .. Wall_GetWeaponLabel(WeaponHash)
	end

	if WallDisplay.Group and PlayerData and PlayerData.group then
		Lines[#Lines + 1] = "~p~" .. PlayerData.group
	end

	if WallDisplay.Distance then
		Lines[#Lines + 1] = "~c~" .. Wall_Round(Distance, 1) .. "m"
	end

	if WallDisplay.Status then
		local State = Player(ServerId).state
		if State then
			local StatusParts = {}

			if State.Death or State.death or State.Coma or State.coma then
				StatusParts[#StatusParts + 1] = "~r~Coma"
			end

			if State.Arena or State.arena then
				StatusParts[#StatusParts + 1] = "~o~Arena"
			end

			if #StatusParts > 0 then
				Lines[#Lines + 1] = table.concat(StatusParts, " | ")
			end
		end
	end

	return Lines
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if WallActive then
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local DrawDistance = Config.DrawDistance

			Sleep = Config.RenderSleep or 0

			for _, Player in ipairs(GetActivePlayers()) do
				local TargetPed = GetPlayerPed(Player)
				local ServerId = GetPlayerServerId(Player)
				local IsSelf = TargetPed == Ped

				if TargetPed and DoesEntityExist(TargetPed) and (not IsSelf or WallDisplay.Self) then
					if IsPedAPlayer(TargetPed) or WallDisplay.Npcs then
						local TargetCoords = GetEntityCoords(TargetPed)
						local Distance = #(PedCoords - TargetCoords)

						if Distance <= DrawDistance then
							local PlayerData = Wall_GetPlayerData(ServerId)
							local Health = GetEntityHealth(TargetPed)
							local Color = Wall_GetColor(TargetPed, Health, IsSelf, PlayerData and PlayerData.staff)
							local HeadCoords = GetPedBoneCoords(TargetPed, 31086, 0.0, 0.0, Config.HeadOffset or 0.55)
							local Lines = Wall_BuildInfoLines(ServerId, TargetPed, Distance, PlayerData)

							if #Lines > 0 then
								Wall_DrawText3D(HeadCoords.x, HeadCoords.y, HeadCoords.z, Lines, Color)
							end

							if WallDisplay.Line and not IsSelf then
								Wall_DrawLineToTarget(PedCoords, TargetCoords)
							end

							if WallDisplay.Skeleton then
								Wall_DrawSkeleton(TargetPed)
							end

							if WallDisplay.Blip then
								local BlipName = PlayerData and (PlayerData.steam or PlayerData.name) or ("#" .. (PlayerData and PlayerData.passport or ServerId))
								Wall_UpdateBlip(ServerId, TargetPed, BlipName)
							end

							if not WallDisplay.ThroughWalls then
								if not HasEntityClearLosToEntity(Ped, TargetPed, 17) then
									-- info ainda visível mas com opacidade reduzida — padrão BR mantém visível
								end
							end
						elseif WallDisplay.Blip and PlayerBlips[ServerId] then
							if DoesBlipExist(PlayerBlips[ServerId]) then
								RemoveBlip(PlayerBlips[ServerId])
							end
							PlayerBlips[ServerId] = nil
						end
					end
				end
			end
		else
			if next(PlayerBlips) then
				Wall_ClearBlips()
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PERIÓDICO DO CLIENTE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(Config.UpdateInterval or 500)

		if WallActive then
			TriggerServerEvent("sistema-wall:RequestSync")
		end
	end
end)
