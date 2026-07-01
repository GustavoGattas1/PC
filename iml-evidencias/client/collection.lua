-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA COM ANIMAÇÃO E BARRA DE PROGRESSO
-----------------------------------------------------------------------------------------------------------------------------------------
local Collecting = false

function LoadAnimDict(Dict)
	if not Dict then return false end
	RequestAnimDict(Dict)
	local Timeout = GetGameTimer() + 5000
	while not HasAnimDictLoaded(Dict) do
		if GetGameTimer() > Timeout then return false end
		Wait(10)
	end
	return true
end

function PlayCollectionAnim(EvidenceType)
	local Ped = PlayerPedId()
	local Dict = Config.Collection.AnimDict
	local Anim = Config.Collection.AnimName

	if EvidenceType == "casing" or EvidenceType == "magazine" or EvidenceType == "bullet" then
		Dict = Config.Collection.AnimDictBag or Dict
		Anim = Config.Collection.AnimNameBag or Anim
	end

	if LoadAnimDict(Dict) then
		TaskPlayAnim(Ped, Dict, Anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end
end

function StopCollectionAnim()
	local Ped = PlayerPedId()
	ClearPedTasks(Ped)
end

function StartProgressCollection(Label, Duration, Callback)
	SendNUIMessage({
		action = "startProgress",
		label = Label or "Coletando evidência...",
		duration = Duration or 3000
	})
end

RegisterNUICallback("progressComplete", function(_, cb)
	if ProgressCallback then
		ProgressCallback()
		ProgressCallback = nil
	end
	cb("ok")
end)

RegisterNUICallback("progressCancel", function(_, cb)
	Collecting = false
	StopCollectionAnim()
	ProgressCallback = nil
	cb("ok")
end)

ProgressCallback = nil

function RunCollectionFlow(EvidenceId, Evidence, OnComplete)
	if Collecting then return end
	Collecting = true

	local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
	local Label = TypeInfo.Label or "Evidência"

	PlayCollectionAnim(Evidence.type)

	if Config.Collection.UseProgress then
		StartProgressCollection("Coletando: " .. Label, Config.Collection.ProgressDuration)

		ProgressCallback = function()
			StopCollectionAnim()
			Collecting = false

			local Minigame = TypeInfo.Minigame
			if Config.Collection.UseMinigameAfter and Minigame and StartMinigame then
				StartMinigame(Minigame, function(Success)
					if Success then
						OnComplete()
					else
						IMLNotify("negado", Config.Lang.MinigameFailed)
					end
				end)
			else
				OnComplete()
			end
		end
	else
		Wait(Config.Collection.ProgressDuration or 2000)
		StopCollectionAnim()
		Collecting = false
		OnComplete()
	end
end

function StartEvidenceCollection(EvidenceId, Evidence)
	if Collecting then return end

	if not IsFlashlightOut() then
		IMLNotify("negado", Config.Lang.NeedFlashlight)
		return
	end

	RunCollectionFlow(EvidenceId, Evidence, function()
		TriggerServerEvent("iml-evidencias:CollectEvidence", EvidenceId)
	end)
end
