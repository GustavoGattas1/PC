-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIGAMES DE COLETA
-----------------------------------------------------------------------------------------------------------------------------------------
MinigameCallback = nil

function StartMinigame(Type, Callback)
	if MinigameCallback then return end
	MinigameCallback = Callback

	SetNuiFocus(true, true)
	SendNUIMessage({ action = "startMinigame", type = Type })
end

RegisterNUICallback("minigameCancel", function(_, cb)
	SetNuiFocus(false, false)
	if MinigameCallback then
		local Callback = MinigameCallback
		MinigameCallback = nil
		Callback(false)
	end
	SendNUIMessage({ action = "finishCollectionUi" })
	cb("ok")
end)
