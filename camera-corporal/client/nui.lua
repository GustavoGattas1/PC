-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI — PAINEL DE REVISÃO
-----------------------------------------------------------------------------------------------------------------------------------------

local NuiOpen = false

function BCC_IsNuiOpen()
	return NuiOpen
end

function BCC_CloseNui()
	SetNuiFocus(false, false)
	NuiOpen = false
	SendNUIMessage({ action = "close" })
end

function BCC_OpenReview(Data)
	if NuiOpen then
		BCC_CloseNui()
	end

	SetNuiFocus(true, true)
	NuiOpen = true

	SendNUIMessage({
		action = "openReview",
		data = Data
	})
end

RegisterNUICallback("close", function(_, Callback)
	BCC_CloseNui()
	Callback("ok")
end)

RegisterNUICallback("loadSession", function(Data, Callback)
	local Result = vSERVER.GetSessionDetails(Data.sessionId)
	Callback(Result or { success = false })
end)

RegisterNUICallback("deleteSession", function(Data, Callback)
	local Result = vSERVER.DeleteSession(Data.sessionId)
	Callback(Result or { success = false })
end)

RegisterNUICallback("exportSession", function(Data, Callback)
	local Result = vSERVER.ExportSession(Data.sessionId)
	Callback(Result or { success = false })
end)

RegisterNUICallback("searchSessions", function(Data, Callback)
	local Result = vSERVER.SearchSessions(Data.query or "", Data.filter or "all")
	Callback(Result or { sessions = {} })
end)

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		BCC_CloseNui()
	end
end)
