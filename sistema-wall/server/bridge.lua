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
local CACHE_TTL = 60000
local DB = Config.Database

local function CacheKey(Passport)
	return tostring(Passport)
end

local function CacheNow()
	return GetGameTimer and GetGameTimer() or (os.time() * 1000)
end

function Wall_Bridge_ClearCache(Passport)
	if Passport then
		CharacterCache[CacheKey(Passport)] = nil
	else
		CharacterCache = {}
	end
end

if vRP and vRP.Prepare then
	vRP.Prepare("wall/GetCharacter", [[
		SELECT Name, Lastname FROM characters WHERE id = @passport LIMIT 1
	]])
end

function Wall_Bridge_GetPlayerName(Passport)
	if not Passport then return nil end
	if not vRP or not vRP.Query then
		return "Jogador #" .. CacheKey(Passport)
	end

	local Key = CacheKey(Passport)
	local Entry = CharacterCache[Key]
	local Now = CacheNow()

	if Entry and (Now - Entry.time) < CACHE_TTL then
		return Entry.name
	end

	local Result = vRP.Query("wall/GetCharacter", { passport = Passport })
	if not Result or not Result[1] then
		CharacterCache[Key] = { name = "Jogador #" .. Key, time = Now }
		return CharacterCache[Key].name
	end

	local Row = Result[1]
	local First = tostring(Row[DB.CharacterName] or Row.Name or Row.name or "")
	local Last = tostring(Row[DB.CharacterName2] or Row.Lastname or Row.name2 or "")
	local Full = (First .. " " .. Last):gsub("^%s+", ""):gsub("%s+$", "")

	if Full == "" then
		Full = "Jogador #" .. Key
	end

	CharacterCache[Key] = { name = Full, time = Now }
	return Full
end
