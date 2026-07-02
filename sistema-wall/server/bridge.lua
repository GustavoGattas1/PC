-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- BRIDGE — RESOLUÇÃO DE NOMES VIA BANCO
-----------------------------------------------------------------------------------------------------------------------------------------

local CharacterCache = {}
local CACHE_TTL = 5000

local function CacheNow()
	if GetGameTimer then
		return GetGameTimer()
	end
	return os.time() * 1000
end

vRP.Prepare("wall/GetCharacter", [[
	SELECT * FROM characters WHERE id = @passport LIMIT 1
]])

local function CacheKey(Passport)
	return tostring(Passport)
end

local function GetCached(Passport)
	local Entry = CharacterCache[CacheKey(Passport)]
	if Entry and (CacheNow() - Entry.time) < CACHE_TTL then
		return Entry.data
	end
	return nil
end

local function SetCache(Passport, Data)
	CharacterCache[CacheKey(Passport)] = {
		data = Data,
		time = CacheNow()
	}
end

function Wall_Bridge_GetCharacter(Passport)
	if not Passport then return nil end

	local Cached = GetCached(Passport)
	if Cached then return Cached end

	local Result = vRP.Query("wall/GetCharacter", { passport = Passport })
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

function Wall_Bridge_GetPlayerName(Passport)
	local Char = Wall_Bridge_GetCharacter(Passport)
	if not Char then
		return "Jogador #" .. tostring(Passport)
	end

	local First = tostring(Char.name or "")
	local Last = tostring(Char.name2 or "")
	local Full = (First .. " " .. Last):gsub("^%s+", ""):gsub("%s+$", "")

	if Full == "" then
		return "Jogador #" .. tostring(Passport)
	end

	return Full
end

function Wall_Bridge_ClearCache(Passport)
	if Passport then
		CharacterCache[CacheKey(Passport)] = nil
	else
		CharacterCache = {}
	end
end
