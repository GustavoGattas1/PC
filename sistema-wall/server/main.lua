-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Wall = {}
Tunnel.bindInterface("sistema-wall", Wall)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local ActiveWalls = {}
local CachedPlayers = {}
local CachedPlayersDirty = true
local ShowCharacterName = Config.Display.Name

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasPermission(Passport)
	return Wall_HasGroup(Passport, Config.Groups)
end

local function GetPlayerGroup(Passport)
	for i = 1, #Config.Groups do
		if vRP.HasGroup(Passport, Config.Groups[i]) then
			return Config.Groups[i]
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DADOS DOS JOGADORES
-----------------------------------------------------------------------------------------------------------------------------------------
local function BuildPlayerData(Source)
	local Passport = vRP.Passport(Source)
	if not Passport then return end

	local SteamName = GetPlayerName(Source) or "Desconhecido"
	local Group = GetPlayerGroup(Passport)

	return {
		passport = Passport,
		name = ShowCharacterName and (Wall_Bridge_GetPlayerName(Passport) or SteamName) or SteamName,
		steam = SteamName,
		group = Group,
		staff = Group ~= nil
	}
end

local function RebuildPlayerCache()
	CachedPlayers = {}
	local Sources = vRP.Players()

	if Sources then
		for _, Source in pairs(Sources) do
			local Data = BuildPlayerData(Source)
			if Data then
				CachedPlayers[Source] = Data
			end
		end
	else
		local Players = GetPlayers()
		for i = 1, #Players do
			local Source = tonumber(Players[i])
			local Data = BuildPlayerData(Source)
			if Data then
				CachedPlayers[Source] = Data
			end
		end
	end

	CachedPlayersDirty = false
	return CachedPlayers
end

local function GetPlayerCache()
	if CachedPlayersDirty then
		return RebuildPlayerCache()
	end
	return CachedPlayers
end

local function BroadcastPlayerCache()
	local Players = GetPlayerCache()
	for Source, Active in pairs(ActiveWalls) do
		if Active then
			TriggerClientEvent("sistema-wall:SyncPlayers", Source, Players)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall.CheckPermission()
	local Passport = vRP.Passport(source)
	return Passport and HasPermission(Passport) or false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function(Source)
	local Passport = vRP.Passport(Source)
	if not Passport or not HasPermission(Passport) then
		if Passport then
			Wall_NotifyServer(Source, "negado", Config.Lang.NotAuthorized)
		end
		return
	end

	ActiveWalls[Source] = not ActiveWalls[Source]
	TriggerClientEvent("sistema-wall:Toggle", Source, ActiveWalls[Source])
end, false)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sistema-wall:RequestSync")
AddEventHandler("sistema-wall:RequestSync", function()
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not HasPermission(Passport) then return end
	TriggerClientEvent("sistema-wall:SyncPlayers", Source, GetPlayerCache())
end)

RegisterNetEvent("sistema-wall:SetActive")
AddEventHandler("sistema-wall:SetActive", function(Active)
	local Source = source
	local Passport = vRP.Passport(Source)
	if not Passport or not HasPermission(Passport) then return end

	ActiveWalls[Source] = Active == true
	if ActiveWalls[Source] then
		TriggerClientEvent("sistema-wall:SyncPlayers", Source, GetPlayerCache())
	end
end)

AddEventHandler("playerDropped", function()
	local Source = source
	ActiveWalls[Source] = nil
	CachedPlayers[Source] = nil
	CachedPlayersDirty = true
end)

AddEventHandler("Disconnect", function(Passport, Source)
	ActiveWalls[Source] = nil
	CachedPlayers[Source] = nil
	CachedPlayersDirty = true
	if Passport then
		Wall_Bridge_ClearCache(Passport)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PERIÓDICO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Interval = Config.UpdateInterval or 500
	while true do
		Wait(Interval)

		local HasActive = false
		for _, Active in pairs(ActiveWalls) do
			if Active then
				HasActive = true
				break
			end
		end

		if HasActive then
			CachedPlayersDirty = true
			BroadcastPlayerCache()
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("IsWallActive", function(Source)
	return ActiveWalls[Source] == true
end)

exports("HasWallPermission", function(Passport)
	return HasPermission(Passport)
end)
