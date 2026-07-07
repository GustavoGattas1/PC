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
local PendingSaves = {}

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
	if not Data or Data == "" then return nil end
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

local function CleanBase64(Data)
	if not Data then return nil end
	local Clean = Data
	while Clean:find("^data:image/") do
		Clean = Clean:gsub("^data:image/%a+;base64,", "")
	end
	return Clean
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVAR ARQUIVO
-----------------------------------------------------------------------------------------------------------------------------------------
local ResourceName = GetCurrentResourceName()

local function GetRelativePath(Model)
	return Config.OutputFolder .. "/" .. Model .. ".png"
end

local function GetAbsolutePath(Model)
	return GetResourcePath(ResourceName) .. "/" .. GetRelativePath(Model)
end

local function EnsureOutputFolder()
	local Base = GetResourcePath(ResourceName) .. "/" .. Config.OutputFolder
	os.execute('mkdir "' .. Base:gsub("/", "\\") .. '" 2>nul')
	os.execute('mkdir -p "' .. Base .. '" 2>/dev/null')
end

local function FileExists(Model)
	local Relative = GetRelativePath(Model)
	if LoadResourceFile(ResourceName, Relative) then
		return true
	end

	local File = io.open(GetAbsolutePath(Model), "rb")
	if File then
		File:close()
		return true
	end

	return false
end

local function SaveImage(Model, Base64Data)
	local Clean = CleanBase64(Base64Data)
	if not Clean or Clean == "" then
		return false, "Dados de imagem vazios."
	end

	local Binary = Base64Decode(Clean)
	if not Binary or #Binary == 0 then
		return false, "Falha ao decodificar base64."
	end

	EnsureOutputFolder()

	local Relative = GetRelativePath(Model)
	local Saved = SaveResourceFile(ResourceName, Relative, Binary, #Binary)

	if Saved then
		return true, Relative
	end

	local Path = GetAbsolutePath(Model)
	local File = io.open(Path, "wb")
	if not File then
		return false, "Não foi possível criar o arquivo em " .. Relative
	end

	File:write(Binary)
	File:close()
	return true, Path
end

local function FinishSave(Source, Model, RequestId, Ok, Result)
	if Ok then
		TriggerClientEvent("vehicle-photos:SaveResult", Source, Model, true, Result, RequestId)
	else
		VP_NotifyServer(Source, "Error", (Config.Lang.SaveError):format(Model, Result or "erro desconhecido"))
		TriggerClientEvent("vehicle-photos:SaveResult", Source, Model, false, Result, RequestId)
	end
end

local function CanSave(Source)
	local Passport = vRP.Passport(Source)
	return Passport and HasPermission(Passport)
end

CreateThread(function()
	EnsureOutputFolder()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR LISTA DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadFromFile()
	local Models = {}
	local Path = GetResourcePath(ResourceName) .. "/vehicles.txt"
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
-- EVENTOS — SALVAR IMAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehicle-photos:SaveImage")
AddEventHandler("vehicle-photos:SaveImage", function(Model, Base64Data, RequestId)
	local Source = source
	if not CanSave(Source) then return end

	Model = VP_NormalizeModel(Model)
	if not Model or not Base64Data then return end

	local Ok, Result = SaveImage(Model, Base64Data)
	FinishSave(Source, Model, RequestId, Ok, Result)
end)

RegisterNetEvent("vehicle-photos:SaveBegin")
AddEventHandler("vehicle-photos:SaveBegin", function(Model, RequestId, TotalChunks)
	local Source = source
	if not CanSave(Source) then return end

	Model = VP_NormalizeModel(Model)
	if not Model or not RequestId or not TotalChunks then return end

	PendingSaves[RequestId] = {
		source = Source,
		model = Model,
		total = TotalChunks,
		chunks = {},
		received = 0
	}
end)

RegisterNetEvent("vehicle-photos:SaveChunk")
AddEventHandler("vehicle-photos:SaveChunk", function(RequestId, Index, Chunk)
	local Source = source
	local Pending = PendingSaves[RequestId]
	if not Pending or Pending.source ~= Source or not Chunk then return end

	Pending.chunks[Index] = Chunk
	Pending.received = Pending.received + 1
end)

RegisterNetEvent("vehicle-photos:SaveCommit")
AddEventHandler("vehicle-photos:SaveCommit", function(Model, RequestId)
	local Source = source
	local Pending = PendingSaves[RequestId]
	PendingSaves[RequestId] = nil

	if not Pending or Pending.source ~= Source then return end

	Model = VP_NormalizeModel(Model)
	if not Model or Pending.model ~= Model then return end

	if Pending.received ~= Pending.total then
		FinishSave(Source, Model, RequestId, false, "Transferência incompleta (" .. Pending.received .. "/" .. Pending.total .. ").")
		return
	end

	local Parts = {}
	for Index = 1, Pending.total do
		local Chunk = Pending.chunks[Index]
		if not Chunk then
			FinishSave(Source, Model, RequestId, false, "Chunk " .. Index .. " ausente.")
			return
		end
		Parts[#Parts + 1] = Chunk
	end

	local Ok, Result = SaveImage(Model, table.concat(Parts))
	FinishSave(Source, Model, RequestId, Ok, Result)
end)

RegisterNetEvent("vehicle-photos:CheckExists")
AddEventHandler("vehicle-photos:CheckExists", function(Model, RequestId)
	local Source = source
	Model = VP_NormalizeModel(Model)
	local Exists = Model and FileExists(Model) or false
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
	local Source = source
	Capturing[Source] = nil

	for RequestId, Pending in pairs(PendingSaves) do
		if Pending.source == Source then
			PendingSaves[RequestId] = nil
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetVehicleList", BuildVehicleList)
exports("GetOutputPath", function(Model)
	return GetAbsolutePath(VP_NormalizeModel(Model))
end)
