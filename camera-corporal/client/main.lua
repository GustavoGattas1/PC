-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
BCC = {}
Tunnel.bindInterface("camera-corporal", BCC)
vSERVER = Tunnel.getInterface("camera-corporal")

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------------------------------------------------------------------------------
local Authorized = false
local InService = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIALIZAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(2000)
	Authorized = vSERVER.CheckPermission()
	InService = vSERVER.CheckService()
	BCC_Debug("Autorizado:", Authorized, "Em serviço:", InService)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE BODY CAM
-----------------------------------------------------------------------------------------------------------------------------------------
function BCC_ToggleCamera()
	if not Authorized then
		Authorized = vSERVER.CheckPermission()
	end

	if not Authorized then
		BCC_Notify("negado", Config.Lang.NotAuthorized)
		return
	end

	if Config.RequireService and not vSERVER.CheckService() then
		BCC_Notify("negado", Config.Lang.NeedService)
		return
	end

	if Config.Item and not vSERVER.HasItem() then
		BCC_Notify("negado", Config.Lang.NeedItem)
		return
	end

	if BCC_IsActive() then
		BCC_StopSession(true)
		BCC_Notify("important", Config.Lang.CameraOff, 4000)
	else
		local Result = vSERVER.StartSession()
		if Result and Result.success then
			BCC_StartSession(Result)
			BCC_Notify("success", Config.Lang.CameraOn, 4000)
		else
			BCC_Notify("negado", Result and Result.message or Config.Lang.NotAuthorized)
		end
	end
end

RegisterNetEvent("camera-corporal:Toggle")
AddEventHandler("camera-corporal:Toggle", function()
	BCC_ToggleCamera()
end)

RegisterNetEvent("camera-corporal:ForceStop")
AddEventHandler("camera-corporal:ForceStop", function()
	if BCC_IsActive() then
		BCC_StopSession(true)
	end
end)

RegisterNetEvent("camera-corporal:AutoStart")
AddEventHandler("camera-corporal:AutoStart", function()
	if BCC_IsActive() then return end
	if not Authorized then Authorized = vSERVER.CheckPermission() end
	if not Authorized then return end
	if Config.Item and not vSERVER.HasItem() then return end

	local Result = vSERVER.StartSession()
	if Result and Result.success then
		BCC_StartSession(Result)
		BCC_Notify("info", Config.Lang.AutoStart, 4000)
	end
end)

RegisterNetEvent("camera-corporal:ServiceChanged")
AddEventHandler("camera-corporal:ServiceChanged", function(OnDuty)
	InService = OnDuty == true

	if Config.Recording.AutoStartOnService and OnDuty and not BCC_IsActive() then
		TriggerEvent("camera-corporal:AutoStart")
	elseif Config.Recording.AutoStopOffService and not OnDuty and BCC_IsActive() then
		BCC_StopSession(true)
		BCC_Notify("important", Config.Lang.AutoStop, 4000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS E KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
local function RegisterBccCommand(Name)
	RegisterCommand(Name, function()
		BCC_ToggleCamera()
	end, false)
end

RegisterBccCommand(Config.Command)
for _, Alias in ipairs(Config.CommandAliases or {}) do
	RegisterBccCommand(Alias)
end

RegisterCommand(Config.BookmarkCommand, function()
	if not BCC_IsRecording() then
		BCC_Notify("negado", Config.Lang.AlreadyOff)
		return
	end
	BCC_AddBookmark("Incidente marcado manualmente")
end, false)

RegisterKeyMapping(Config.Command, "Alternar Câmera Corporal", "keyboard", "F9")
RegisterKeyMapping(Config.BookmarkCommand, "Marcar Incidente (Bodycam)", "keyboard", Config.BookmarkKey)

local function RegisterReviewCommand(Name)
	RegisterCommand(Name, function()
		if BCC_IsNuiOpen() then
			BCC_CloseNui()
			return
		end

		local Result = vSERVER.OpenReview()
		if Result and Result.success then
			BCC_OpenReview(Result)
		else
			BCC_Notify("negado", Result and Result.message or Config.Lang.ReviewDenied)
		end
	end, false)
end

RegisterReviewCommand(Config.ReviewCommand)
for _, Alias in ipairs(Config.ReviewAliases or {}) do
	RegisterReviewCommand(Alias)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS DE REVISÃO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for _, Location in ipairs(Config.ReviewLocations or {}) do
			local Dist = #(Coords - Location.Coords)
			if Dist <= Config.Marker.DrawDistance then
				Sleep = 0
				DrawMarker(
					Config.Marker.Type,
					Location.Coords.x, Location.Coords.y, Location.Coords.z - 0.95,
					0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
					Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z,
					Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, Config.Marker.Color.a,
					false, false, 2, false, nil, nil, false
				)

				if Dist <= Config.Marker.InteractDistance then
					BCC_DrawHelpText(Config.Lang.NearReview)

					if IsControlJustPressed(0, 38) then
						ExecuteCommand(Config.ReviewCommand)
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

function BCC_DrawHelpText(Text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(Text)
	DisplayHelpTextFromStringLabel(0, false, true, -1)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
function BCC.GetStatus()
	return {
		active = BCC_IsActive(),
		recording = BCC_IsRecording(),
		sessionId = BCC_GetSessionId()
	}
end
