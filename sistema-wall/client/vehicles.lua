-----------------------------------------------------------------------------------------------------------------------------------------
-- WALL DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------

local VehicleClassLabels = {
	[0] = "Compacto",
	[1] = "Sedan",
	[2] = "SUV",
	[3] = "Cupê",
	[4] = "Muscle",
	[5] = "Clássico",
	[6] = "Esportivo",
	[7] = "Super",
	[8] = "Moto",
	[9] = "Off-road",
	[10] = "Industrial",
	[11] = "Utilitário",
	[12] = "Van",
	[13] = "Bicicleta",
	[14] = "Barco",
	[15] = "Helicóptero",
	[16] = "Avião",
	[17] = "Serviço",
	[18] = "Emergência",
	[19] = "Militar",
	[20] = "Comercial",
	[21] = "Trem"
}

function Wall_GetVehicleLabel(Vehicle)
	if not Vehicle or not DoesEntityExist(Vehicle) then return "Desconhecido" end

	local Model = GetEntityModel(Vehicle)
	local Display = GetDisplayNameFromVehicleModel(Model)
	local Label = GetLabelText(Display)

	if Label and Label ~= "NULL" and Label ~= "" then
		return Label
	end

	return Display or "Veículo"
end

function Wall_GetVehicleClassLabel(Vehicle)
	if not Vehicle or not DoesEntityExist(Vehicle) then return "" end
	local Class = GetVehicleClass(Vehicle)
	return VehicleClassLabels[Class] or "Veículo"
end

function Wall_GetVehicleSpeed(Vehicle)
	if not Vehicle or not DoesEntityExist(Vehicle) then return 0 end
	return math.floor(GetEntitySpeed(Vehicle) * 3.6)
end

function Wall_GetVehiclePlate(Vehicle)
	if not Vehicle or not DoesEntityExist(Vehicle) then return "???" end
	return GetVehicleNumberPlateText(Vehicle) or "???"
end

function Wall_BuildVehicleLines(Vehicle, Distance)
	local Lines = {}
	local Label = Wall_GetVehicleLabel(Vehicle)
	local Class = Wall_GetVehicleClassLabel(Vehicle)
	local Plate = Wall_GetVehiclePlate(Vehicle)
	local Speed = Wall_GetVehicleSpeed(Vehicle)
	local Health = GetVehicleEngineHealth(Vehicle)
	local BodyHealth = GetVehicleBodyHealth(Vehicle)

	Lines[#Lines + 1] = "~y~[VEÍCULO]~w~ " .. Label
	Lines[#Lines + 1] = "~c~Placa: ~w~" .. Plate .. " ~c~| ~w~" .. Class

	if Config.Display.Speed then
		Lines[#Lines + 1] = "~o~Velocidade: ~w~" .. Speed .. " km/h"
	end

	if Config.Display.Health then
		Lines[#Lines + 1] = string.format("~g~Motor: ~w~%d%% ~r~| ~g~Lataria: ~w~%d%%",
			math.floor(math.max(0, Health) / 10),
			math.floor(math.max(0, BodyHealth) / 10)
		)
	end

	if Config.Display.Distance then
		Lines[#Lines + 1] = "~c~Dist: ~w~" .. Wall_Round(Distance, 1) .. "m"
	end

	return Lines
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if WallActive and Config.Display.Vehicle then
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local DrawDistance = math.min(Config.DrawDistance, 150.0)

			Sleep = Config.RenderSleep or 0

			local Vehicles = GetGamePool("CVehicle")

			for _, Vehicle in ipairs(Vehicles) do
				if DoesEntityExist(Vehicle) then
					local VehCoords = GetEntityCoords(Vehicle)
					local Distance = #(PedCoords - VehCoords)

					if Distance <= DrawDistance then
						local Driver = GetPedInVehicleSeat(Vehicle, -1)

						if Driver == 0 or not IsPedAPlayer(Driver) then
							local Lines = Wall_BuildVehicleLines(Vehicle, Distance)

							if #Lines > 0 then
								Wall_DrawText3D(VehCoords.x, VehCoords.y, VehCoords.z + 1.2, Lines, { 255, 200, 80, 220 })
							end

							if Config.Display.Line then
								local C = Config.Colors.Line
								DrawLine(
									PedCoords.x, PedCoords.y, PedCoords.z,
									VehCoords.x, VehCoords.y, VehCoords.z + 0.5,
									C[1], C[2], C[3], math.floor(C[4] * 0.6)
								)
							end
						end
					end
				end
			end
		end

		Wait(Sleep)
	end
end)
