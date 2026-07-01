-----------------------------------------------------------------------------------------------------------------------------------------
-- BRIDGE — ACESSO DIRETO AO BANCO (evita vRP.Identity / UserGemstone / GetBank)
-- Necessário na Base Cliente: essas funções do vRP chamam Identity internamente e quebram.
-----------------------------------------------------------------------------------------------------------------------------------------

local CharacterCache = {}
local CACHE_TTL = 5000

local function CacheKey(Passport)
	return tostring(Passport)
end

local function GetCached(Passport)
	local Key = CacheKey(Passport)
	local Entry = CharacterCache[Key]
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

local function ClearCache(Passport)
	CharacterCache[CacheKey(Passport)] = nil
end

function Loja_Bridge_GetCharacter(Passport)
	if not Passport then return nil end

	local Cached = GetCached(Passport)
	if Cached then return Cached end

	local DB = Config.Database
	local Result = vRP.Query("loja_vip/GetCharacter", { passport = Passport })
	if not Result or not Result[1] then return nil end

	local Row = Result[1]
	local Data = {
		passport = Passport,
		license = Row[DB.CharacterLicense] or Row.License or Row.license,
		name = Row[DB.CharacterName] or Row.Name or Row.name,
		name2 = Row[DB.CharacterName2] or Row.Lastname or Row.name2,
		bank = tonumber(Row[DB.CharacterBank] or Row.Bank or Row.bank) or 0
	}

	SetCache(Passport, Data)
	return Data
end

function Loja_Bridge_CharacterExists(Passport)
	return Loja_Bridge_GetCharacter(Passport) ~= nil
end

function Loja_Bridge_GetPlayerName(Passport)
	local Char = Loja_Bridge_GetCharacter(Passport)
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

function Loja_Bridge_GetBank(Passport)
	local Char = Loja_Bridge_GetCharacter(Passport)
	return Char and Char.bank or 0
end

function Loja_Bridge_GetGems(Passport)
	local Char = Loja_Bridge_GetCharacter(Passport)
	if not Char or not Char.license then return 0 end

	local Result = vRP.Query("loja_vip/GetAccountGems", { license = Char.license })

	if Result and Result[1] then
		local DB = Config.Database
		local Gems = Result[1][DB.AccountGems] or Result[1].Gemstone or Result[1].gemstone
		return tonumber(Gems) or 0
	end

	return 0
end

function Loja_Bridge_TakeBank(Passport, Amount)
	Amount = tonumber(Amount) or 0
	if Amount <= 0 then return false end

	local Before = Loja_Bridge_GetBank(Passport)
	if Before < Amount then return false end

	vRP.Query("loja_vip/TakeBank", {
		passport = Passport,
		amount = Amount
	})

	ClearCache(Passport)
	return Loja_Bridge_GetBank(Passport) <= (Before - Amount)
end

function Loja_Bridge_GiveBank(Passport, Amount)
	Amount = tonumber(Amount) or 0
	if Amount <= 0 then return false end

	vRP.Query("loja_vip/GiveBank", {
		passport = Passport,
		amount = Amount
	})

	ClearCache(Passport)
	return true
end

function Loja_Bridge_TakeGems(Passport, Amount)
	Amount = tonumber(Amount) or 0
	if Amount <= 0 then return false end

	local Char = Loja_Bridge_GetCharacter(Passport)
	if not Char or not Char.license then return false end

	local Before = Loja_Bridge_GetGems(Passport)
	if Before < Amount then return false end

	vRP.Query("loja_vip/TakeGems", {
		license = Char.license,
		amount = Amount
	})

	ClearCache(Passport)
	return Loja_Bridge_GetGems(Passport) <= (Before - Amount)
end

function Loja_Bridge_ClearCache(Passport)
	ClearCache(Passport)
end

function Loja_Bridge_GiveGems(Passport, Amount)
	Amount = tonumber(Amount) or 0
	if Amount <= 0 then return false end

	local Char = Loja_Bridge_GetCharacter(Passport)
	if not Char or not Char.license then return false end

	vRP.Query("loja_vip/GiveGems", {
		license = Char.license,
		amount = Amount
	})

	ClearCache(Passport)
	return true
end
