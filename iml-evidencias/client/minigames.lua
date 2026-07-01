-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIGAMES DE COLETA
-----------------------------------------------------------------------------------------------------------------------------------------
local MinigameActive = false
local MinigameCallback = nil

function StartMinigame(Type, Callback)
	if MinigameActive then return end
	MinigameActive = true
	MinigameCallback = Callback

	SetNuiFocus(true, true)
	SendNUIMessage({ action = "startMinigame", type = Type })
end

RegisterNUICallback("minigameResult", function(Data, cb)
	SetNuiFocus(false, false)
	MinigameActive = false

	if MinigameCallback then
		MinigameCallback(Data and Data.success == true)
		MinigameCallback = nil
	end

	cb("ok")
end)

RegisterNUICallback("minigameCancel", function(_, cb)
	SetNuiFocus(false, false)
	MinigameActive = false

	if MinigameCallback then
		MinigameCallback(false)
		MinigameCallback = nil
	end

	cb("ok")
end)
