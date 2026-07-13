-----------------------------------------------------------------------------------------------------------------------------------------
-- BRIDGE — RESOLUÇÃO DE NOMES VIA BANCO (padrão Creative Uncharted)
-----------------------------------------------------------------------------------------------------------------------------------------

local CharacterCache = {}
local CACHE_TTL = 10000

local function CacheKey(Passport)
	return tostring(Passport)
end

local function GetCached(Passport)
	local Entry = CharacterCache[CacheKey(Passport)]
	if Entry and (GetGameTimer() - Entry.time) < CACHE_TTL then
		return Entry.data
	end
	return nil
end

local function SetCache(Passport, Data)
	CharacterCache[CacheKey(Passport)] = {
		data = Data,
		time = GetGameTimer()
	}
end

function BBS_VRP_Bridge_GetCharacter(Passport)
	if not Passport then return nil end

	local Cached = GetCached(Passport)
	if Cached then return Cached end

	local Result = vRP.Query("bbs_vrp/GetCharacter", { passport = Passport })
	if not Result or not Result[1] then return nil end

	local Row = Result[1]
	local DB = BBS_VRP.Database
	local Data = {
		passport = Passport,
		license = Row[DB.CharacterLicense] or Row.License or Row.license,
		name = Row[DB.CharacterName] or Row.Name or Row.name,
		name2 = Row[DB.CharacterName2] or Row.Lastname or Row.name2
	}

	SetCache(Passport, Data)
	return Data
end

function BBS_VRP_Bridge_GetPlayerName(Passport)
	local Char = BBS_VRP_Bridge_GetCharacter(Passport)
	if not Char then
		return "Oficial #" .. tostring(Passport)
	end

	local First = tostring(Char.name or "")
	local Last = tostring(Char.name2 or "")
	local Full = (First .. " " .. Last):gsub("^%s+", ""):gsub("%s+$", "")

	if Full == "" then
		return "Oficial #" .. tostring(Passport)
	end

	return Full
end

function BBS_VRP_Bridge_GetFirstName(Passport)
	local Char = BBS_VRP_Bridge_GetCharacter(Passport)
	return Char and tostring(Char.name or "") or "Oficial"
end

function BBS_VRP_Bridge_GetLastName(Passport)
	local Char = BBS_VRP_Bridge_GetCharacter(Passport)
	return Char and tostring(Char.name2 or "") or ""
end

function BBS_VRP_Bridge_GetUnit(Passport)
	for _, Group in ipairs(BBS_VRP.Groups) do
		if vRP.HasGroup(Passport, Group) then
			return string.upper(Group)
		end
	end
	return "PATRULHA"
end

function BBS_VRP_Bridge_GetBadge(Passport)
	return string.format("PM-%05d", Passport)
end

function BBS_VRP_Bridge_ClearCache(Passport)
	if Passport then
		CharacterCache[CacheKey(Passport)] = nil
	else
		CharacterCache = {}
	end
end
