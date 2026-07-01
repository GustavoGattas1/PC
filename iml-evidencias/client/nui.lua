-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTROLE ÚNICO DE PAINÉIS NUI
-----------------------------------------------------------------------------------------------------------------------------------------
function IsNuiBusy()
	return NuiOpen or Collecting
end

function CloseNuiPanel(SkipNuiMessage)
	if Collecting and CancelCollection then
		CancelCollection()
	end

	if MinigameCallback then
		local Callback = MinigameCallback
		MinigameCallback = nil
		Callback(false)
	end

	ProgressCallback = nil

	SetNuiFocus(false, false)
	NuiOpen = false

	if RemoveTabletProp then
		RemoveTabletProp()
	end

	if not SkipNuiMessage then
		SendNUIMessage({ action = "forceClose" })
	end
end

function OpenNuiPanel(Payload, Options)
	Options = Options or {}
	local Replace = Options.replace
	if Replace == nil then
		Replace = true
	end

	if IsNuiBusy() then
		if not Replace then
			if Options.notify ~= false then
				IMLNotify("important", Config.Lang.PanelBusy or "Feche o painel aberto antes de continuar.", 3000)
			end
			return false
		end
		CloseNuiPanel()
	end

	SetNuiFocus(true, true)
	NuiOpen = true
	SendNUIMessage(Payload)
	return true
end
