local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Resource = GetCurrentResourceName()
local Active = {}

local function Notify(Source, Type, Message)
	local N = Config.Notify
	TriggerClientEvent("Notify", Source, N.Title, Message, N[Type] or N.Info, 5000)
end

local function HasPermission(Source)
	local Passport = vRP.Passport(Source)
	if not Passport then return false end
	for i = 1, #Config.Groups do
		if vRP.HasGroup(Passport, Config.Groups[i]) then
			return true
		end
	end
	return false
end

local function Normalize(Model)
	if not Model then return nil end
	return string.lower(tostring(Model)):gsub("%s+", "")
end

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function DecodeBase64(Data)
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

local function RelativePath(Model)
	return Config.OutputFolder .. "/" .. Model .. ".png"
end

local function EnsureFolder()
	local Path = GetResourcePath(Resource) .. "/" .. Config.OutputFolder
	os.execute('mkdir "' .. Path:gsub("/", "\\") .. '" 2>nul')
	os.execute('mkdir -p "' .. Path .. '" 2>/dev/null')
end

local function FileExists(Model)
	local Relative = RelativePath(Model)
	if LoadResourceFile(Resource, Relative) then
		return true
	end

	local File = io.open(GetResourcePath(Resource) .. "/" .. Relative, "rb")
	if File then
		File:close()
		return true
	end

	return false
end

local function SaveFile(Model, Base64)
	local Clean = Base64:gsub("^data:image/%a+;base64,", "")
	local Binary = DecodeBase64(Clean)
	if not Binary or #Binary == 0 then
		return false
	end

	EnsureFolder()

	local Relative = RelativePath(Model)
	if SaveResourceFile(Resource, Relative, Binary, #Binary) then
		return true
	end

	local Full = GetResourcePath(Resource) .. "/" .. Relative
	local File = io.open(Full, "wb")
	if not File then
		return false
	end

	File:write(Binary)
	File:close()
	return true
end

local function LoadFromFile()
	local List = {}
	local File = io.open(GetResourcePath(Resource) .. "/vehicles.txt", "r")
	if not File then return List end

	for Line in File:lines() do
		local Model = Normalize(Line:match("^[^#%s]+"))
		if Model then
			List[#List + 1] = Model
		end
	end

	File:close()
	return List
end

local function LoadFromLojaVip()
	local List = {}
	if GetResourceState("loja-vip") ~= "started" then
		return List
	end

	local Content = LoadResourceFile("loja-vip", "config.lua")
	if not Content then return List end

	for Model in Content:gmatch('model%s*=%s*["\']([^"\']+)["\']') do
		List[#List + 1] = Normalize(Model)
	end

	return List
end

local function BuildList()
	local Seen = {}
	local List = {}

	local function Add(Models)
		for i = 1, #Models do
			local Model = Normalize(Models[i])
			if Model and not Seen[Model] then
				Seen[Model] = true
				List[#List + 1] = Model
			end
		end
	end

	if Config.Sources.Manual then
		Add(Config.Vehicles or {})
	end

	if Config.Sources.File then
		Add(LoadFromFile())
	end

	if Config.Sources.LojaVip then
		Add(LoadFromLojaVip())
	end

	table.sort(List)
	return List
end

CreateThread(function()
	EnsureFolder()
end)

RegisterNetEvent("vehicle-photos:server:save")
AddEventHandler("vehicle-photos:server:save", function(RequestId, Model, Base64)
	local Source = source
	if not HasPermission(Source) then return end

	Model = Normalize(Model)
	local Ok = Model and Base64 and SaveFile(Model, Base64) or false
	TriggerClientEvent("vehicle-photos:client:saveResult", Source, RequestId, Ok)
end)

RegisterNetEvent("vehicle-photos:server:exists")
AddEventHandler("vehicle-photos:server:exists", function(RequestId, Model)
	local Source = source
	Model = Normalize(Model)
	TriggerClientEvent("vehicle-photos:client:existsResult", Source, RequestId, Model and FileExists(Model) or false)
end)

RegisterNetEvent("vehicle-photos:server:finished")
AddEventHandler("vehicle-photos:server:finished", function()
	Active[source] = nil
end)

RegisterCommand(Config.CommandAll, function(Source)
	if not HasPermission(Source) then
		Notify(Source, "Error", Config.Lang.NoPermission)
		return
	end

	if Active[Source] then
		Notify(Source, "Warning", Config.Lang.AlreadyRunning)
		return
	end

	local List = BuildList()
	if #List == 0 then
		Notify(Source, "Warning", Config.Lang.NoVehicles)
		return
	end

	Active[Source] = true
	TriggerClientEvent("vehicle-photos:client:captureAll", Source, List)
end, false)

RegisterCommand(Config.CommandOne, function(Source, Args)
	if not HasPermission(Source) then
		Notify(Source, "Error", Config.Lang.NoPermission)
		return
	end

	local Model = Normalize(Args[1])
	if not Model then
		Notify(Source, "Warning", "Uso: /" .. Config.CommandOne .. " [spawn]")
		return
	end

	Active[Source] = true
	TriggerClientEvent("vehicle-photos:client:captureOne", Source, Model)
end, false)

RegisterCommand(Config.CommandStop, function(Source)
	if Active[Source] then
		Active[Source] = nil
		TriggerClientEvent("vehicle-photos:client:stop", Source)
		Notify(Source, "Info", Config.Lang.Stopped)
	end
end, false)

AddEventHandler("playerDropped", function()
	Active[source] = nil
end)

exports("GetVehicleList", BuildList)
