-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERAÇÃO FORENSE — TARGET (olhinho Creative)
-----------------------------------------------------------------------------------------------------------------------------------------

function GetClosestCorpsePlayer()
	local Ped = PlayerPedId()
	local PedCoords = GetEntityCoords(Ped)
	local ClosestPlayer = nil
	local ClosestDist = Config.CorpseDistance

	for _, Player in ipairs(GetActivePlayers()) do
		local TargetPed = GetPlayerPed(Player)
		if TargetPed ~= Ped and IsCorpsePed(TargetPed) then
			local Dist = #(PedCoords - GetEntityCoords(TargetPed))
			if Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPlayer = GetPlayerServerId(Player)
			end
		end
	end

	return ClosestPlayer
end

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
