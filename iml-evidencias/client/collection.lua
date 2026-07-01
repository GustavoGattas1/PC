-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA COM ANIMAÇÃO E BARRA DE PROGRESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Collecting = false

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
	local Dict = Config.Collection.AnimDict or "random@domestic"
	local Anim = Config.Collection.AnimName or "pickup_low"

	if LoadAnimDict(Dict) then
		TaskPlayAnim(Ped, Dict, Anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end
end

function StopCollectionAnim()
	ClearPedTasks(PlayerPedId())
end

function CancelCollection()
	Collecting = false
	StopCollectionAnim()
	ProgressCallback = nil
	SendNUIMessage({ action = "cancelCollection" })
end

ProgressCallback = nil

RegisterNUICallback("progressComplete", function(_, cb)
	if ProgressCallback then
		local Callback = ProgressCallback
		ProgressCallback = nil
		Callback()
	end
	cb("ok")
end)

RegisterNUICallback("progressCancel", function(_, cb)
	CancelCollection()
	cb("ok")
end)

RegisterNUICallback("minigameResult", function(Data, cb)
	SetNuiFocus(false, false)
	if MinigameCallback then
		local Callback = MinigameCallback
		MinigameCallback = nil
		Callback(Data and Data.success == true)
	end
	SendNUIMessage({ action = "finishCollectionUi" })
	cb("ok")
end)

function RunCollectionFlow(EvidenceId, Evidence, OnComplete)
	if Collecting then return end
	Collecting = true

	local TypeInfo = Config.EvidenceTypes[Evidence.type] or {}
	local Label = TypeInfo.Label or "Evidência"

	PlayCollectionAnim(Evidence.type)

	local function FinishFlow()
		StopCollectionAnim()
		Collecting = false
		SendNUIMessage({ action = "finishCollectionUi" })
	end

	local function AfterMinigame(Success)
		if Success then
			OnComplete()
		else
			IMLNotify("negado", Config.Lang.MinigameFailed)
		end
		FinishFlow()
	end

	if Config.Collection.UseProgress then
		SendNUIMessage({
			action = "startProgress",
			label = "Coletando: " .. Label,
			duration = Config.Collection.ProgressDuration or 3000
		})

		ProgressCallback = function()
			local Minigame = TypeInfo.Minigame
			if Config.Collection.UseMinigameAfter and Minigame and StartMinigame then
				StartMinigame(Minigame, AfterMinigame)
			else
				OnComplete()
				FinishFlow()
			end
		end
	else
		Wait(Config.Collection.ProgressDuration or 2000)
		OnComplete()
		FinishFlow()
	end
end

function StartEvidenceCollection(EvidenceId, Evidence)
	if Collecting or NuiOpen then return end

	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
		return
	end

	if not IsFlashlightOut() then
		IMLNotify("negado", Config.Lang.NeedFlashlight)
		return
	end

	if not vSERVER.CanCollectGround() then
		IMLNotify("negado", Config.Lang.NeedKit)
		return
	end

	RunCollectionFlow(EvidenceId, Evidence, function()
		if not IsFlashlightOut() then
			IMLNotify("negado", Config.Lang.NeedFlashlight)
			return
		end

		TriggerServerEvent("iml-evidencias:CollectEvidence", EvidenceId)
	end)
end

RegisterNetEvent("iml-evidencias:CollectFailed")
AddEventHandler("iml-evidencias:CollectFailed", function()
	CancelCollection()
end)
