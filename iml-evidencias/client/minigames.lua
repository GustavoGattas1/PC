-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIGAMES DE COLETA
-----------------------------------------------------------------------------------------------------------------------------------------
MinigameCallback = nil

function StartMinigame(Type, Callback)
	if MinigameCallback or (IsNuiBusy and IsNuiBusy() and not Collecting) then return end
	MinigameCallback = Callback

	SetNuiFocus(true, true)
	SendNUIMessage({ action = "startMinigame", type = Type })
end

RegisterNUICallback("minigameCancel", function(_, cb)
	if not Collecting then
		SetNuiFocus(false, false)
	end
	if MinigameCallback then
		local Callback = MinigameCallback
		MinigameCallback = nil
		Callback(false)
	end
	SendNUIMessage({ action = "finishCollectionUi" })
	cb("ok")
end)
