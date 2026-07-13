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
vCLIENT = Tunnel.getInterface("sistema-wall")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local ActiveWalls = {}
local LastSyncRequest = {}
local LastSyncSent = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_HasPermission(Passport)
	return Wall_HasGroup(Passport, Config.Groups)
end

function Wall_GetPlayerGroup(Passport)
	if not Passport then return nil end

	for _, Group in ipairs(Config.Groups) do
		if vRP.HasGroup(Passport, Group) then
			return Group
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DADOS DOS JOGADORES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall_BuildPlayerData(Source)
	local Passport = vRP.Passport(Source)
	if not Passport then return nil end

	local Name = Wall_Bridge_GetPlayerName(Passport)
	local Group = Wall_GetPlayerGroup(Passport)

	return {
		source = Source,
		passport = Passport,
		name = Name,
		group = Group,
		staff = Group ~= nil
	}
end

function Wall_GetOnlinePlayers()
	local Players = {}
	local Sources = vRP.Players()

	if Sources then
		for Passport, Source in pairs(Sources) do
			local Data = Wall_BuildPlayerData(Source)
			if Data then
				Players[Source] = Data
			end
		end
	else
		for _, Source in ipairs(GetPlayers()) do
			Source = tonumber(Source)
			local Data = Wall_BuildPlayerData(Source)
			if Data then
				Players[Source] = Data
			end
		end
	end

	return Players
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Wall.CheckPermission()
	local Source = source
	local Passport = vRP.Passport(Source)
	return Passport and Wall_HasPermission(Passport) or false
end

function Wall.GetPlayerList()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not Wall_HasPermission(Passport) then
		return {}
	end

	return Wall_GetOnlinePlayers()
end

function Wall.GetPlayerInfo(TargetSource)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not Wall_HasPermission(Passport) then
		return nil
	end

	TargetSource = tonumber(TargetSource)
	if not TargetSource then return nil end

	return Wall_BuildPlayerData(TargetSource)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function RegisterWallCommand(Name)
	RegisterCommand(Name, function(Source)
		local Passport = vRP.Passport(Source)
		if not Passport then return end

		if not Wall_HasPermission(Passport) then
			Wall_NotifyServer(Source, "negado", Config.Lang.NotAuthorized)
			return
		end

		ActiveWalls[Source] = not ActiveWalls[Source]
		TriggerClientEvent("sistema-wall:Toggle", Source, ActiveWalls[Source])
	end, false)
end

RegisterWallCommand(Config.Command)

for _, Alias in ipairs(Config.CommandAliases or {}) do
	RegisterWallCommand(Alias)
end

RegisterCommand("wallconfig", function(Source, Args)
	local Passport = vRP.Passport(Source)
	if not Passport or not Wall_HasPermission(Passport) then
		Wall_NotifyServer(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	local Option = Args[1]
	if not Option then
		TriggerClientEvent("sistema-wall:OpenConfig", Source)
		return
	end

	TriggerClientEvent("sistema-wall:SetOption", Source, Option)
end, false)

RegisterCommand("wallinfo", function(Source, Args)
	local Passport = vRP.Passport(Source)
	if not Passport or not Wall_HasPermission(Passport) then
		Wall_NotifyServer(Source, "negado", Config.Lang.NotAuthorized)
		return
	end

	local TargetSource = tonumber(Args[1])
	if not TargetSource then
		Wall_NotifyServer(Source, "info", "Uso: /wallinfo [source]")
		return
	end

	local Data = Wall_BuildPlayerData(TargetSource)
	if not Data then
		Wall_NotifyServer(Source, "negado", "Jogador não encontrado.")
		return
	end

	Wall_NotifyServer(Source, "info",
		string.format("#%s %s | Source: %s | Grupo: %s",
			Data.passport, Data.name, Data.source, Data.group or "Nenhum"
		), 8000
	)
end, false)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function Wall_CanSync(Source)
	if not ActiveWalls[Source] then return false end
	if not GetPlayerName(Source) then return false end

	local Now = GetGameTimer()
	local Cooldown = Config.RequestSyncCooldown or Config.UpdateInterval or 5000
	local Last = LastSyncSent[Source] or 0

	return (Now - Last) >= Cooldown
end

local function Wall_ForceSync(Source)
	if not ActiveWalls[Source] or not GetPlayerName(Source) then return end

	LastSyncSent[Source] = GetGameTimer()
	TriggerClientEvent("sistema-wall:SyncPlayers", Source, Wall_GetOnlinePlayers())
end

local function Wall_SendSync(Source)
	if not Wall_CanSync(Source) then return end
	Wall_ForceSync(Source)
end

RegisterNetEvent("sistema-wall:RequestSync")
AddEventHandler("sistema-wall:RequestSync", function()
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not Wall_HasPermission(Passport) or not ActiveWalls[Source] then return end

	local Now = GetGameTimer()
	local Cooldown = Config.RequestSyncCooldown or Config.UpdateInterval or 5000
	local Last = LastSyncRequest[Source] or 0

	if (Now - Last) < Cooldown then return end

	LastSyncRequest[Source] = Now
	Wall_SendSync(Source)
end)

AddEventHandler("playerDropped", function()
	local Source = source
	ActiveWalls[Source] = nil
	LastSyncRequest[Source] = nil
	LastSyncSent[Source] = nil
	Wall_Bridge_ClearCache(nil)
end)

AddEventHandler("Disconnect", function(Passport, Source)
	ActiveWalls[Source] = nil
	LastSyncRequest[Source] = nil
	LastSyncSent[Source] = nil
	if Passport then
		Wall_Bridge_ClearCache(Passport)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PERIÓDICO PARA STAFF COM WALL ATIVO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(Config.UpdateInterval or 5000)

		for Source, Active in pairs(ActiveWalls) do
			if Active then
				Wall_SendSync(Source)
			end
		end
	end
end)

RegisterNetEvent("sistema-wall:SetActive")
AddEventHandler("sistema-wall:SetActive", function(Active)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not Wall_HasPermission(Passport) then return end

	ActiveWalls[Source] = Active == true

	if ActiveWalls[Source] then
		Wall_ForceSync(Source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("IsWallActive", function(Source)
	return ActiveWalls[Source] == true
end)

exports("HasWallPermission", function(Passport)
	return Wall_HasPermission(Passport)
end)
