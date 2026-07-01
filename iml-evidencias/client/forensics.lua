-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERAÇÃO FORENSE COM CADÁVERES
-----------------------------------------------------------------------------------------------------------------------------------------

function GetClosestCorpsePlayer()
	local Ped = PlayerPedId()
	local PedCoords = GetEntityCoords(Ped)
	local ClosestPlayer = nil
	local ClosestDist = Config.CorpseDistance

	for _, Player in ipairs(GetActivePlayers()) do
		local TargetPed = GetPlayerPed(Player)
		if TargetPed ~= Ped then
			local Dist = #(PedCoords - GetEntityCoords(TargetPed))
			local IsDown = IsEntityDead(TargetPed) or GetEntityHealth(TargetPed) <= 101 or IsPedDeadOrDying(TargetPed, true)

			if IsDown and Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPlayer = GetPlayerServerId(Player)
			end
		end
	end

	return ClosestPlayer
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCADORES E INTERAÇÃO NO CADÁVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if not IsCivil or not IsFlashlightOut() then
			Wait(Sleep)
		else
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for _, Player in ipairs(GetActivePlayers()) do
				local TargetPed = GetPlayerPed(Player)
				if TargetPed ~= Ped then
					local TargetCoords = GetEntityCoords(TargetPed)
					local Dist = #(PedCoords - TargetCoords)
					local IsDown = IsEntityDead(TargetPed) or GetEntityHealth(TargetPed) <= 101 or IsPedDeadOrDying(TargetPed, true)

					if IsDown and Dist < 8.0 then
						Sleep = 0
						DrawMarker(20, TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 200, 30, 30, 120, false, false, 2, false, nil, nil, false)

						if Dist < Config.CorpseDistance then
							DrawText3D(TargetCoords.x, TargetCoords.y, TargetCoords.z + 0.5, "~y~[Lanterna]~w~ ~r~[E]~w~ Periciar  ~r~[G]~w~ Sangue  ~r~[H]~w~ Saco")

							local TargetSource = GetPlayerServerId(Player)

							if IsControlJustPressed(0, 38) and IsFlashlightOut() and not IsNuiBusy() then
								TriggerServerEvent("iml-evidencias:ExamineCorpse", TargetSource)
							end

							if IsControlJustPressed(0, 47) and IsFlashlightOut() and not IsNuiBusy() then
								TriggerServerEvent("iml-evidencias:CollectBloodSwab", TargetSource)
							end

							if IsControlJustPressed(0, 74) and IsFlashlightOut() and not IsNuiBusy() then
								TriggerServerEvent("iml-evidencias:CollectBody", TargetSource)
							end
						end
					end
				end
			end

			Wait(Sleep)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR GSR DE SUSPEITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("coletargsr", function()
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end

	local Ped = PlayerPedId()
	local PedCoords = GetEntityCoords(Ped)
	local ClosestPlayer = nil
	local ClosestDist = 2.5

	for _, Player in ipairs(GetActivePlayers()) do
		local TargetPed = GetPlayerPed(Player)
		if TargetPed ~= Ped then
			local Dist = #(PedCoords - GetEntityCoords(TargetPed))
			if Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPlayer = GetPlayerServerId(Player)
			end
		end
	end

	if ClosestPlayer then
		TriggerServerEvent("iml-evidencias:CollectGSR", ClosestPlayer)
	else
		IMLNotify("negado", "Nenhum suspeito próximo.")
	end
end)

RegisterCommand("coletarcorpo", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:CollectBody", TargetSource)
	else
		IMLNotify("negado", Config.Lang.NoCorpse)
	end
end)

RegisterCommand("periciar", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:ExamineCorpse", TargetSource)
	else
		IMLNotify("negado", Config.Lang.NoCorpse)
	end
end)

RegisterCommand("coletarsangue", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:CollectBloodSwab", TargetSource)
	else
		IMLNotify("negado", Config.Lang.NoCorpse)
	end
end)

RegisterCommand("luvas", function()
	TriggerEvent("iml-evidencias:ToggleGloves")
end)

RegisterCommand("tabletforense", function()
	if IsNuiBusy and IsNuiBusy() then
		IMLNotify("important", Config.Lang.PanelBusy)
		return
	end
	TriggerEvent("iml-evidencias:OpenTablet")
end)
