-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Capturing = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasPermission(Passport)
	if not Passport then return false end
	for i = 1, #Config.Groups do
		if vRP.HasGroup(Passport, Config.Groups[i]) then
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE64 DECODE
-----------------------------------------------------------------------------------------------------------------------------------------
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function Base64Decode(Data)
	Data = Data:gsub("[^" .. B64 .. "=]", "")
	return (Data:gsub(".", function(x)
		if x == "=" then return "" end
		local r, f = "", (B64:find(x) - 1)
		for i = 6, 1, -1 do
			r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
		end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do
			c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
		end
		return string.char(c)
	end))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVAR ARQUIVO
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetOutputPath(Model)
	local Resource = GetCurrentResourceName()
	local Base = GetResourcePath(Resource)
	return Base .. "/" .. Config.OutputFolder .. "/" .. Model .. ".png"
end

local function FileExists(Path)
	local File = io.open(Path, "rb")
	if File then
		File:close()
		return true
	end
	return false
end

local function SaveImage(Model, Base64Data)
	local Clean = Base64Data:gsub("^data:image/%a+;base64,", "")
	local Path = GetOutputPath(Model)
	local Binary = Base64Decode(Clean)
	local File = io.open(Path, "wb")

	if not File then
		return false, "Não foi possível criar o arquivo."
	end

	File:write(Binary)
	File:close()
	return true, Path
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR LISTA DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadFromFile()
	local Models = {}
	local Resource = GetCurrentResourceName()
	local Path = GetResourcePath(Resource) .. "/vehicles.txt"
	local File = io.open(Path, "r")

	if not File then return Models end

	for Line in File:lines() do
		local Model = VP_NormalizeModel(Line:match("^[^#%s]+"))
		if Model and Model ~= "" then
			Models[#Models + 1] = Model
		end
	end

	File:close()
	return Models
end

local function LoadFromLojaVip()
	local Models = {}

	if GetResourceState("loja-vip") ~= "started" then
		return Models
	end

	local Content = LoadResourceFile("loja-vip", "config.lua")
	if not Content then return Models end

	for Model in Content:gmatch('model%s*=%s*["\']([^"\']+)["\']') do
		Models[#Models + 1] = VP_NormalizeModel(Model)
	end

	return Models
end

local function BuildVehicleList()
	local Models = {}

	if Config.Sources.Manual and Config.Vehicles then
		VP_MergeModels(Models, Config.Vehicles)
	end

	if Config.Sources.VehiclesFile then
		VP_MergeModels(Models, LoadFromFile())
	end

	if Config.Sources.VRPVehicleList and List then
		local VRPModels = {}
		for Model in pairs(List) do
			VRPModels[#VRPModels + 1] = VP_NormalizeModel(Model)
		end
		VP_MergeModels(Models, VRPModels)
	end

	if Config.Sources.LojaVip then
		VP_MergeModels(Models, LoadFromLojaVip())
	end

	return VP_SortModels(Models)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehicle-photos:SaveImage")
AddEventHandler("vehicle-photos:SaveImage", function(Model, Base64Data, RequestId)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or not HasPermission(Passport) then return end

	Model = VP_NormalizeModel(Model)
	if not Model or not Base64Data then return end

	local Ok, Result = SaveImage(Model, Base64Data)
	TriggerClientEvent("vehicle-photos:SaveResult", Source, Model, Ok, Result, RequestId)
end)

RegisterNetEvent("vehicle-photos:CheckExists")
AddEventHandler("vehicle-photos:CheckExists", function(Model, RequestId)
	local Source = source
	Model = VP_NormalizeModel(Model)
	local Exists = Model and FileExists(GetOutputPath(Model)) or false
	TriggerClientEvent("vehicle-photos:ExistsResult", Source, RequestId, Exists)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function StartCapture(Source)
	local Passport = vRP.Passport(Source)
	if not HasPermission(Passport) then
		VP_NotifyServer(Source, "Error", Config.Lang.NoPermission)
		return
	end

	if Capturing[Source] then
		VP_NotifyServer(Source, "Warning", Config.Lang.AlreadyRunning)
		return
	end

	local List = BuildVehicleList()
	if #List == 0 then
		VP_NotifyServer(Source, "Warning", Config.Lang.NoVehicles)
		return
	end

	Capturing[Source] = true
	TriggerClientEvent("vehicle-photos:StartBatch", Source, List)
end

RegisterCommand(Config.Command, function(Source)
	StartCapture(Source)
end, false)

RegisterCommand(Config.CommandStop, function(Source)
	if Capturing[Source] then
		Capturing[Source] = nil
		TriggerClientEvent("vehicle-photos:Stop", Source)
		VP_NotifyServer(Source, "Info", Config.Lang.Stopped)
	end
end, false)

RegisterCommand(Config.CommandSingle, function(Source, Args)
	local Passport = vRP.Passport(Source)
	if not HasPermission(Passport) then
		VP_NotifyServer(Source, "Error", Config.Lang.NoPermission)
		return
	end

	local Model = VP_NormalizeModel(Args[1])
	if not Model then
		VP_NotifyServer(Source, "Warning", "Uso: /" .. Config.CommandSingle .. " [spawn]")
		return
	end

	TriggerClientEvent("vehicle-photos:CaptureSingle", Source, Model)
end, false)

RegisterNetEvent("vehicle-photos:Finished")
AddEventHandler("vehicle-photos:Finished", function()
	Capturing[source] = nil
end)

AddEventHandler("playerDropped", function()
	Capturing[source] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetVehicleList", BuildVehicleList)
exports("GetOutputPath", function(Model)
	return GetOutputPath(VP_NormalizeModel(Model))
end)
