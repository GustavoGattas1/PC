-----------------------------------------------------------------------------------------------------------------------------------------
-- BRIDGE — RESOLUÇÃO DE NOMES E UNIDADE
-----------------------------------------------------------------------------------------------------------------------------------------

local CharacterCache = {}
local CACHE_TTL = 10000

vRP.Prepare("bcc/GetCharacter", [[
	SELECT * FROM characters WHERE id = @passport LIMIT 1
]])

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

function BCC_Bridge_GetCharacter(Passport)
	if not Passport then return nil end

	local Cached = GetCached(Passport)
	if Cached then return Cached end

	local Result = vRP.Query("bcc/GetCharacter", { passport = Passport })
	if not Result or not Result[1] then return nil end

	local Row = Result[1]
	local DB = Config.Database
	local Data = {
		passport = Passport,
		name = Row[DB.CharacterName] or Row.Name or Row.name,
		name2 = Row[DB.CharacterName2] or Row.Lastname or Row.name2
	}

	SetCache(Passport, Data)
	return Data
end

function BCC_Bridge_GetPlayerName(Passport)
	local Char = BCC_Bridge_GetCharacter(Passport)
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

function BCC_Bridge_GetUnit(Passport)
	for _, Group in ipairs(Config.Groups) do
		if vRP.HasGroup(Passport, Group) then
			return string.upper(Group)
		end
	end
	return "PATRULHA"
end

function BCC_Bridge_GetBadge(Passport)
	return string.format("PM-%05d", Passport)
end

function BCC_Bridge_ClearCache(Passport)
	if Passport then
		CharacterCache[CacheKey(Passport)] = nil
	else
		CharacterCache = {}
	end
end
