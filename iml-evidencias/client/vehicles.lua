-----------------------------------------------------------------------------------------------------------------------------------------
-- RASTROS DE PNEU
-----------------------------------------------------------------------------------------------------------------------------------------
local LastVehicle = 0
local LastSpeed = 0.0

CreateThread(function()
	while true do
		Wait(500)
		local Ped = PlayerPedId()

		if IsPedInAnyVehicle(Ped, false) then
			local Vehicle = GetVehiclePedIsIn(Ped, false)
			if GetPedInVehicleSeat(Vehicle, -1) == Ped then
				local Speed = GetEntitySpeed(Vehicle) * 3.6
				local Burnout = IsVehicleInBurnout(Vehicle)
				local Braking = IsControlPressed(0, 72) and Speed > 35.0

				if (Burnout or (Braking and LastSpeed > 50.0)) and math.random(100) <= Config.Chances.TireTrack then
					local Coords = GetEntityCoords(Vehicle)
					local Heading = GetEntityHeading(Vehicle)
					local TrackCoords = SpreadCoords({ x = Coords.x, y = Coords.y, z = Coords.z - 0.95 }, "tire_track", Heading)
					TriggerServerEvent("iml-evidencias:CreateEvidence", {
						type = "tire_track",
						coords = TrackCoords,
						heading = Heading,
						vehicle = VehToNet(Vehicle),
						metadata = { speed = RoundNumber(Speed, 1), burnout = Burnout }
					})
				end

				LastVehicle = Vehicle
				LastSpeed = Speed
			end
		else
			LastVehicle = 0
			LastSpeed = 0.0
		end
	end
end)
