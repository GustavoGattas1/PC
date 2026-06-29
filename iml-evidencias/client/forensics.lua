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
			local IsDown = IsEntityDead(TargetPed) or GetEntityHealth(TargetPed) <= 100

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
		local Ped = PlayerPedId()
		local PedCoords = GetEntityCoords(Ped)

		for _, Player in ipairs(GetActivePlayers()) do
			local TargetPed = GetPlayerPed(Player)
			if TargetPed ~= Ped then
				local TargetCoords = GetEntityCoords(TargetPed)
				local Dist = #(PedCoords - TargetCoords)
				local IsDown = IsEntityDead(TargetPed) or GetEntityHealth(TargetPed) <= 100

				if IsDown and Dist < 8.0 then
					Sleep = 0
					DrawMarker(20, TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 200, 30, 30, 120, false, false, 2, false, nil, nil, false)

					if Dist < Config.CorpseDistance then
						DrawText3D(TargetCoords.x, TargetCoords.y, TargetCoords.z + 0.5, "~r~[E]~w~ Periciar  ~r~[G]~w~ Coletar Sangue  ~r~[H]~w~ Acondicionar")

						local TargetSource = GetPlayerServerId(Player)

						if IsControlJustPressed(0, 38) then
							TriggerServerEvent("iml-evidencias:ExamineCorpse", TargetSource)
						end

						if IsControlJustPressed(0, 47) then
							TriggerServerEvent("iml-evidencias:CollectBloodSwab", TargetSource)
						end

						if IsControlJustPressed(0, 74) then
							TriggerServerEvent("iml-evidencias:CollectBody", TargetSource)
						end
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR GSR DE SUSPEITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("coletargsr", function()
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
		TriggerEvent("Notify", "negado", "Nenhum suspeito próximo.", false, 5000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO COLETAR CORPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("coletarcorpo", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:CollectBody", TargetSource)
	else
		TriggerEvent("Notify", "negado", Config.Lang.NoCorpse, false, 5000)
	end
end)

RegisterCommand("periciar", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:ExamineCorpse", TargetSource)
	else
		TriggerEvent("Notify", "negado", Config.Lang.NoCorpse, false, 5000)
	end
end)

RegisterCommand("coletarsangue", function()
	local TargetSource = GetClosestCorpsePlayer()
	if TargetSource then
		TriggerServerEvent("iml-evidencias:CollectBloodSwab", TargetSource)
	else
		TriggerEvent("Notify", "negado", Config.Lang.NoCorpse, false, 5000)
	end
end)
