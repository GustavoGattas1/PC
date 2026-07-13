-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI — CENTRAL DE BODYCAMS (AO VIVO + GRAVAÇÕES)
-----------------------------------------------------------------------------------------------------------------------------------------

local NuiOpen = false

function BCC_IsNuiOpen()
	return NuiOpen
end

function BCC_CloseNui(SkipMessage)
	if BCC_IsWatchingLive() then
		BCC_StopLiveWatch(true)
	end

	if BCC_IsPlayingBack() then
		BCC_StopPlayback(true)
	end

	SetNuiFocus(false, false)
	NuiOpen = false

	if not SkipMessage then
		SendNUIMessage({ action = "close" })
	end
end

function BCC_OpenDispatch(Data)
	if NuiOpen then
		BCC_CloseNui(true)
	end

	SetNuiFocus(true, true)
	NuiOpen = true

	SendNUIMessage({
		action = "openDispatch",
		data = Data
	})
end

function BCC_OpenReview(Data)
	BCC_OpenDispatch(Data)
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

RegisterNUICallback("getLiveOfficers", function(_, Callback)
	local Result = vSERVER.GetLiveOfficers()
	Callback(Result or { officers = {} })
end)

RegisterNUICallback("startWatch", function(Data, Callback)
	local Result = vSERVER.StartWatch(Data.source)
	if Result and Result.success then
		BCC_StartLiveWatch(Data.source, Result.target)
	end
	Callback(Result or { success = false })
end)

RegisterNUICallback("stopWatch", function(Data, Callback)
	BCC_StopLiveWatch(true)
	Callback({ success = true })
end)

RegisterNUICallback("startPlayback", function(Data, Callback)
	local Result = vSERVER.GetSessionDetails(Data.sessionId)
	if Result and Result.success then
		local Ok = BCC_StartPlayback(Result)
		Callback({ success = Ok })
		return
	end
	Callback({ success = false })
end)

RegisterNUICallback("stopPlayback", function(_, Callback)
	BCC_StopPlayback(true)
	Callback({ success = true })
end)

RegisterNUICallback("seekPlayback", function(Data, Callback)
	BCC_SeekPlayback(Data.elapsed)
	Callback({ success = true })
end)

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		BCC_CloseNui(true)
	end
end)
