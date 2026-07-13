-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------

function BCC_Debug(...)
	if Config.Debug then
		print("[camera-corporal]", ...)
	end
end

function BCC_Notify(Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.info
	TriggerEvent("Notify", Info.Title, Message, Info.Color, Duration or 5000)
end

function BCC_NotifyServer(Source, Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.info
	TriggerClientEvent("Notify", Source, Info.Title, Message, Info.Color, Duration or 5000)
end

function BCC_HasGroup(Passport, Groups)
	if not Passport or not Groups then return false end
	if type(Groups) == "string" then Groups = { Groups } end

	for _, Group in ipairs(Groups) do
		if Config.RequireService and vRP and vRP.HasService(Passport, Group) then
			return true
		end

		if vRP and vRP.HasGroup(Passport, Group) then
			if not Config.RequireService then
				return true
			elseif vRP.HasService(Passport, Group) then
				return true
			end
		end
	end

	return false
end

function BCC_IsSupervisor(Passport)
	return BCC_HasGroup(Passport, Config.SupervisorGroups)
end

function BCC_GetWeaponLabel(Hash)
	if not Hash or Hash == 0 then return "Desarmado" end
	return Config.Weapons[Hash] or ("Arma #" .. tostring(Hash))
end

function BCC_Round(Number, Decimals)
	local Mult = 10 ^ (Decimals or 1)
	return math.floor(Number * Mult + 0.5) / Mult
end

function BCC_UnixToDateTime(Unix)
	Unix = math.floor(Unix or 0)
	local SecOfDay = Unix % 86400
	local Days = math.floor(Unix / 86400)
	local Hour = math.floor(SecOfDay / 3600)
	local Min = math.floor((SecOfDay % 3600) / 60)
	local Sec = SecOfDay % 60

	Days = Days + 719468
	local Era = math.floor((Days >= 0 and Days or Days - 146096) / 146097)
	local DoE = Days - Era * 146097
	local YOE = math.floor((DoE - math.floor(DoE / 1460) + math.floor(DoE / 36524) - math.floor(DoE / 146096)) / 365)
	local Year = YOE + Era * 400
	local Doy = DoE - (365 * YOE + math.floor(YOE / 4) - math.floor(YOE / 100))
	local Mp = math.floor((5 * Doy + 2) / 153)
	local Day = Doy - math.floor((153 * Mp + 2) / 5) + 1
	local Month = Mp + 3

	if Month > 12 then
		Month = Month - 12
		Year = Year + 1
	end

	return string.format("%02d/%02d/%04d %02d:%02d:%02d", Day, Month, Year, Hour, Min, Sec)
end

function BCC_FormatTimestamp(Unix)
	if os and os.date then
		if Unix then
			return os.date("%d/%m/%Y %H:%M:%S", Unix)
		end
		return os.date("%d/%m/%Y %H:%M:%S")
	end

	if not Unix and GetCloudTimeAsInt then
		Unix = GetCloudTimeAsInt()
	end

	return BCC_UnixToDateTime(Unix or 0)
end

function BCC_FormatTimestampNow()
	return BCC_FormatTimestamp()
end

function BCC_FormatDuration(Seconds)
	Seconds = math.max(0, math.floor(Seconds or 0))
	local Hours = math.floor(Seconds / 3600)
	local Minutes = math.floor((Seconds % 3600) / 60)
	local Secs = Seconds % 60

	if Hours > 0 then
		return string.format("%02d:%02d:%02d", Hours, Minutes, Secs)
	end

	return string.format("%02d:%02d", Minutes, Secs)
end

function BCC_GenerateSessionId()
	local Chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local Id = "BCC-"
	for i = 1, 8 do
		local Index = math.random(1, #Chars)
		Id = Id .. string.sub(Chars, Index, Index)
	end
	return Id
end

function BCC_GenerateBookmarkId()
	return "BM-" .. tostring(os.time()) .. "-" .. math.random(100, 999)
end

function BCC_CoordsToString(Coords)
	if not Coords then return "0, 0, 0" end
	return string.format("%.2f, %.2f, %.2f", Coords.x or 0, Coords.y or 0, Coords.z or 0)
end

function BCC_ParseCoords(Value)
	if type(Value) == "table" then
		return {
			x = tonumber(Value.x) or 0.0,
			y = tonumber(Value.y) or 0.0,
			z = tonumber(Value.z) or 0.0
		}
	end

	if type(Value) ~= "string" then return nil end

	local X, Y, Z = Value:match("([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
	if not X then return nil end

	return {
		x = tonumber(X) or 0.0,
		y = tonumber(Y) or 0.0,
		z = tonumber(Z) or 0.0
	}
end

function BCC_TableCopy(Original)
	if type(Original) ~= "table" then return Original end
	local Copy = {}
	for Key, Value in pairs(Original) do
		Copy[Key] = type(Value) == "table" and BCC_TableCopy(Value) or Value
	end
	return Copy
end

function BCC_Encode(Data)
	if json and json.encode then
		return json.encode(Data)
	end
	return "{}"
end

function BCC_Decode(String)
	if not String or String == "" then return {} end
	if json and json.decode then
		local Ok, Result = pcall(json.decode, String)
		if Ok and type(Result) == "table" then
			return Result
		end
	end
	return {}
end
