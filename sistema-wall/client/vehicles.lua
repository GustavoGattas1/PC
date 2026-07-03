-----------------------------------------------------------------------------------------------------------------------------------------
-- WALL DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
if not Config.Display.Vehicle then return end

local VehicleClassLabels = {
	[0] = "Compacto", [1] = "Sedan", [2] = "SUV", [3] = "Cupê", [4] = "Muscle",
	[5] = "Clássico", [6] = "Esportivo", [7] = "Super", [8] = "Moto", [9] = "Off-road",
	[10] = "Industrial", [11] = "Utilitário", [12] = "Van", [13] = "Bicicleta",
	[14] = "Barco", [15] = "Helicóptero", [16] = "Avião", [17] = "Serviço",
	[18] = "Emergência", [19] = "Militar", [20] = "Comercial", [21] = "Trem"
}

local ShowSpeed = Config.Display.Speed
local ShowHealth = Config.Display.Health
local ShowDistance = Config.Display.Distance
local ShowLine = Config.Display.Line
local DrawDistance = math.min(Config.DrawDistance, 150.0)
local DrawDistanceSq = DrawDistance * DrawDistance
local LineColor = Config.Colors.Line
local VehicleLines = {}

local function ClearTable(T)
	for i = #T, 1, -1 do
		T[i] = nil
	end
end

local function BuildVehicleLines(Vehicle, Distance)
	ClearTable(VehicleLines)

	local Model = GetEntityModel(Vehicle)
	local Display = GetDisplayNameFromVehicleModel(Model)
	local Label = GetLabelText(Display)
	if not Label or Label == "NULL" or Label == "" then
		Label = Display or "Veículo"
	end

	VehicleLines[1] = "~y~[VEÍCULO]~w~ " .. Label
	VehicleLines[2] = "~c~Placa: ~w~" .. (GetVehicleNumberPlateText(Vehicle) or "???") .. " ~c~| ~w~" .. (VehicleClassLabels[GetVehicleClass(Vehicle)] or "Veículo")

	if ShowSpeed then
		VehicleLines[#VehicleLines + 1] = "~o~Velocidade: ~w~" .. math.floor(GetEntitySpeed(Vehicle) * 3.6) .. " km/h"
	end

	if ShowHealth then
		VehicleLines[#VehicleLines + 1] = string.format("~g~Motor: ~w~%d%% ~r~| ~g~Lataria: ~w~%d%%",
			math.floor(math.max(0, GetVehicleEngineHealth(Vehicle)) / 10),
			math.floor(math.max(0, GetVehicleBodyHealth(Vehicle)) / 10)
		)
	end

	if ShowDistance then
		VehicleLines[#VehicleLines + 1] = "~c~Dist: ~w~" .. Wall_Round(Distance, 1) .. "m"
	end

	return VehicleLines
end

CreateThread(function()
	while true do
		if not WallActive then
			Wait(1000)
		else
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			local Px, Py, Pz = PedCoords.x, PedCoords.y, PedCoords.z
			local Vehicles = GetGamePool("CVehicle")

			for i = 1, #Vehicles do
				local Vehicle = Vehicles[i]
				if DoesEntityExist(Vehicle) then
					local VehCoords = GetEntityCoords(Vehicle)
					local Dx = Px - VehCoords.x
					local Dy = Py - VehCoords.y
					local Dz = Pz - VehCoords.z
					local DistSq = Dx * Dx + Dy * Dy + Dz * Dz

					if DistSq <= DrawDistanceSq then
						local Driver = GetPedInVehicleSeat(Vehicle, -1)
						if Driver == 0 or not IsPedAPlayer(Driver) then
							local Lines = BuildVehicleLines(Vehicle, math.sqrt(DistSq))
							local Vx, Vy, Vz = VehCoords.x, VehCoords.y, VehCoords.z + 1.2
							Wall_DrawText3D(Vx, Vy, Vz, Lines, { 255, 200, 80, 220 })

							if ShowLine then
								DrawLine(Px, Py, Pz, Vx, Vy, Vz, LineColor[1], LineColor[2], LineColor[3], math.floor(LineColor[4] * 0.6))
							end
						end
					end
				end
			end

			Wait(Config.RenderSleep or 0)
		end
	end
end)
