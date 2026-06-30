-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("loja-vip")

-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local NuiOpen = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR / FECHAR LOJA
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenShop()
	if NuiOpen then return end

	local Data = vSERVER.GetShopData()
	if not Data then
		TriggerEvent("Notify", Config.Notify.negado.Title, Config.Lang.NoPassport, Config.Notify.negado.Color, 5000)
		return
	end

	NuiOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "open",
		catalog = Data.catalog,
		player = Data.player,
		history = Data.history
	})
end

function CloseShop()
	if not NuiOpen then return end
	NuiOpen = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "close" })
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO /loja
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function()
	OpenShop()
end, false)

for _, Alias in ipairs(Config.CommandAliases or {}) do
	RegisterCommand(Alias, function()
		OpenShop()
	end, false)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP E PONTO FÍSICO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if Config.Blips.Enabled then
		for _, Location in ipairs(Config.Locations) do
			local Blip = AddBlipForCoord(Location.Coords.x, Location.Coords.y, Location.Coords.z)
			SetBlipSprite(Blip, Config.Blips.Sprite)
			SetBlipColour(Blip, Config.Blips.Color)
			SetBlipScale(Blip, Config.Blips.Scale)
			SetBlipAsShortRange(Blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Blips.Label)
			EndTextCommandSetBlipName(Blip)
		end
	end

	while true do
		local Sleep = 1000
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for _, Location in ipairs(Config.Locations) do
			local Distance = #(Coords - Location.Coords)

			if Distance <= 15.0 then
				Sleep = 0

				if Location.Marker then
					local M = Location.Marker
					DrawMarker(
						M.Type,
						Location.Coords.x, Location.Coords.y, Location.Coords.z - 0.95,
						0.0, 0.0, 0.0,
						0.0, 0.0, 0.0,
						M.Scale.x, M.Scale.y, M.Scale.z,
						M.Color.r, M.Color.g, M.Color.b, M.Color.a,
						false, true, 2, false, nil, nil, false
					)
				end

				if Distance <= Config.InteractDistance then
					DrawText3D(Location.Coords.x, Location.Coords.y, Location.Coords.z + 0.5, Config.Lang.OpenShop)

					if IsControlJustPressed(0, 38) and not NuiOpen then
						OpenShop()
					end
				end
			end
		end

		Wait(Sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(_, cb)
	CloseShop()
	cb("ok")
end)

RegisterNUICallback("purchase", function(Data, cb)
	if not Data or not Data.productId then
		cb({ success = false, message = Config.Lang.ProductNotFound })
		return
	end

	local Result = vSERVER.Purchase(Data.productId)
	cb(Result or { success = false, message = Config.Lang.PurchaseFailed })

	if Result and Result.success and Result.balance then
		SendNUIMessage({
			action = "updateBalance",
			balance = Result.balance
		})
	end
end)

RegisterNUICallback("refresh", function(_, cb)
	local Data = vSERVER.GetShopData()
	if Data then
		SendNUIMessage({
			action = "refresh",
			catalog = Data.catalog,
			player = Data.player,
			history = Data.history
		})
	end
	cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESC FECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if NuiOpen then
			DisableControlAction(0, 1, true)
			DisableControlAction(0, 2, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 18, true)
			DisableControlAction(0, 322, true)
			DisableControlAction(0, 106, true)
			Wait(0)
		else
			Wait(500)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW TEXT 3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
	local OnScreen, _x, _y = World3dToScreen2d(x, y, z)
	if OnScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(true)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end
