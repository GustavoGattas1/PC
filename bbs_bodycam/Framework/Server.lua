Framework = {}
local QBCore, ESX, vRP

local CharacterCache = {}
local CACHE_TTL = 10000

local function CacheKey(Passport)
	return tostring(Passport)
end

local function GetCachedCharacter(Passport)
	local Entry = CharacterCache[CacheKey(Passport)]
	if Entry and (GetGameTimer() - Entry.time) < CACHE_TTL then
		return Entry.data
	end
	return nil
end

local function SetCachedCharacter(Passport, Data)
	CharacterCache[CacheKey(Passport)] = {
		data = Data,
		time = GetGameTimer()
	}
end

local function GetVRPPassport(source)
	if not vRP then return nil end
	return vRP.Passport(source)
end

local function GetVRPCharacter(Passport)
	if not Passport then return nil end

	local Cached = GetCachedCharacter(Passport)
	if Cached then return Cached end

	local Result = vRP.Query("bbs_bodycam/GetCharacter", { passport = Passport })
	if not Result or not Result[1] then return nil end

	local Row = Result[1]
	local DB = Config.VRP.Database
	local Data = {
		passport = Passport,
		name = Row[DB.CharacterName] or Row.Name or Row.name,
		name2 = Row[DB.CharacterName2] or Row.Lastname or Row.name2
	}

	SetCachedCharacter(Passport, Data)
	return Data
end

local function GetVRPPlayerName(source)
	local Passport = GetVRPPassport(source)
	if not Passport then return GetPlayerName(source) end

	local Char = GetVRPCharacter(Passport)
	if not Char then return "Jogador #" .. tostring(Passport) end

	local First = tostring(Char.name or "")
	local Last = tostring(Char.name2 or "")
	local Full = (First .. " " .. Last):gsub("^%s+", ""):gsub("%s+$", "")

	if Full == "" then
		return "Jogador #" .. tostring(Passport)
	end

	return Full
end

local function GetVRPPrimaryJob(Passport)
	if not Passport then return "unemployed", 0, "Civil" end

	for _, Group in ipairs(Config.VRP.Groups) do
		if vRP.HasGroup(Passport, Group) then
			return Group, 0, string.upper(Group)
		end
	end

	return "unemployed", 0, "Civil"
end

local function HandleVRPItemUse(source, ItemName)
	if Config.ItemSettings.JobAssociatedItems[ItemName] then
		StartStreamForJob(source)
		return true
	end

	if Config.ItemSettings.CommercialUseItems[ItemName] then
		StartStreamForCommercial(source)
		return true
	end

	return false
end

CreateThread(function()
	if GetResourceState("vrp") == "started" then
		local Proxy = module("vrp", "lib/Proxy")
		vRP = Proxy.getInterface("vRP")

		vRP.Prepare("bbs_bodycam/GetCharacter", [[
			SELECT * FROM characters WHERE id = @passport LIMIT 1
		]])
	elseif GetResourceState("qb-core") == "started" or GetResourceState("qbox") == "started" then
		QBCore = exports["qb-core"]:GetCoreObject()
	elseif GetResourceState("es_extended") == "started" then
		if exports["es_extended"] and exports["es_extended"]:getSharedObject() then
			ESX = exports["es_extended"]:getSharedObject()
		else
			TriggerEvent("esx:getSharedObject", function(obj)
				ESX = obj
			end)
		end
	end
end)

if Config.ItemSettings.Enabled then
	if GetResourceState("ox_inventory") == "started" and exports.ox_inventory then
		exports("GovermentCam", function(event, item, inventory, slot, data)
			if event == "usingItem" and inventory.type == "player" and Config.ItemSettings.JobAssociatedItems[item.name] then
				return StartStreamForJob(inventory.player.source)
			end
		end)
		exports("CommercialCam", function(event, item, inventory, slot, data)
			if event == "usingItem" and inventory.type == "player" and Config.ItemSettings.CommercialUseItems[item.name] then
				return StartStreamForCommercial(inventory.player.source)
			end
		end)
		local filterItems = Config.ItemSettings.CommercialUseItems
		for item, _ in pairs(Config.ItemSettings.JobAssociatedItems) do
			filterItems[item] = true
		end
		exports.ox_inventory:registerHook("swapItems", function(payload)
			if payload.source and GetPlayerPed(payload.source) then
				CheckStreamingItems(payload.source)
			end
			return true
		end, {
			itemFilter = filterItems,
		})
	elseif GetResourceState("qb-inventory") == "started" or GetResourceState("ps-inventory") == "started" then
		local items = {}
		while not QBCore do Wait(100) end
		for govermentItem, _ in pairs(Config.ItemSettings.JobAssociatedItems) do
			items[govermentItem] = {
				name = govermentItem,
				label = "Goverment Issued Bodycam",
				weight = 20,
				type = "item",
				image = govermentItem .. ".png",
				unique = true,
				useable = true,
				shouldClose = true,
				combinable = nil,
			}
			QBCore.Functions.CreateUseableItem(govermentItem, function(source, item)
				StartStreamForJob(source)
			end)
		end
		for commercialItem, _ in pairs(Config.ItemSettings.CommercialUseItems) do
			items[commercialItem] = {
				name = commercialItem,
				label = "Commercial available Bodycam",
				weight = 20,
				type = "item",
				image = commercialItem .. ".png",
				unique = true,
				useable = true,
				shouldClose = true,
				combinable = nil,
			}
			QBCore.Functions.CreateUseableItem(commercialItem, function(source, item)
				StartStreamForCommercial(source)
			end)
		end
		QBCore.Functions.AddItems(items)

		AddEventHandler("QBCore:Player:SetPlayerData", function(playerData)
			CheckStreamingItems(playerData.source, playerData.items)
		end)
	elseif GetResourceState("qs-inventory") == "started" then
		for govermentItem, _ in pairs(Config.ItemSettings.JobAssociatedItems) do
			exports["qs-inventory"]:CreateUsableItem(govermentItem, function(source, item)
				StartStreamForJob(source)
			end)
		end
		for commercialItem, _ in pairs(Config.ItemSettings.CommercialUseItems) do
			exports["qs-inventory"]:CreateUsableItem(commercialItem, function(source, item)
				StartStreamForCommercial(source)
			end)
		end
		AddEventHandler("qb-inventory:server:itemRemoved", function(source, item, amount, totalAmount)
			if Config.ItemSettings.CommercialUseItems[item] or Config.ItemSettings.JobAssociatedItems[item] then
				CheckStreamingItems(source)
			end
		end)
	elseif GetResourceState("es_extended") == "started" then
		while not ESX do Wait(100) end
		for govermentItem, _ in pairs(Config.ItemSettings.JobAssociatedItems) do
			ESX.RegisterUsableItem(govermentItem, function(playerId)
				StartStreamForJob(playerId)
			end)
		end
		for commercialItem, _ in pairs(Config.ItemSettings.CommercialUseItems) do
			ESX.RegisterUsableItem(commercialItem, function(playerId)
				StartStreamForCommercial(playerId)
			end)
		end
		AddEventHandler("esx:onRemoveInventoryItem", function(source, itemname)
			if Config.ItemSettings.CommercialUseItems[itemname] or Config.ItemSettings.JobAssociatedItems[itemname] then
				CheckStreamingItems(source)
			end
		end)
	elseif GetResourceState("vrp") == "started" then
		while not vRP do Wait(100) end

		local function OnInventoryUse(source, ItemName)
			if type(ItemName) ~= "string" or ItemName == "" then return end
			HandleVRPItemUse(source, ItemName)
		end

		RegisterNetEvent("bbs_bodycam:UseItem")
		AddEventHandler("bbs_bodycam:UseItem", function(ItemName)
			OnInventoryUse(source, ItemName)
		end)

		RegisterNetEvent("inventory:UseItem")
		AddEventHandler("inventory:UseItem", function(ItemName)
			OnInventoryUse(source, ItemName)
		end)

		RegisterNetEvent("inventory:Use")
		AddEventHandler("inventory:Use", function(ItemName)
			OnInventoryUse(source, ItemName)
		end)

		RegisterNetEvent("inventory:ServerUse")
		AddEventHandler("inventory:ServerUse", function(ItemName)
			OnInventoryUse(source, ItemName)
		end)

		RegisterNetEvent("player:UseItem")
		AddEventHandler("player:UseItem", function(ItemName)
			OnInventoryUse(source, ItemName)
		end)

		AddEventHandler("Connect", function(Passport, Source)
			CheckStreamingItems(Source)
		end)
	else
		-- Add your custom inventory item register here
	end

	Framework.HasItem = function(src, item, count)
		local _item = nil
		count = count or 1

		if GetResourceState("ox_inventory") == "started" then
			_item = exports.ox_inventory:GetItem(src, item)
			if _item and _item.count then return _item.count >= count end
		elseif GetResourceState("qb-inventory") == "started" or GetResourceState("ps-inventory") == "started" then
			local Player = QBCore.Functions.GetPlayer(src)
			local foundItem = Player.Functions.GetItemByName(item)
			if foundItem then
				_item = foundItem.amount
				return _item >= count
			end
		elseif GetResourceState("qs-inventory") == "started" then
			_item = exports["qs-inventory"]:GetItemTotalAmount(src, item)
			return _item >= count
		elseif GetResourceState("es_extended") == "started" then
			_item = ESX.GetPlayerFromId(src).getInventoryItem(item).count
			return _item >= count
		elseif GetResourceState("vrp") == "started" and vRP then
			local Passport = GetVRPPassport(src)
			if not Passport then return false end

			local Result = vRP.InventoryItemAmount(Passport, item)
			local Amount = Result and Result[1] or 0
			return Amount >= count
		else
			-- Add your custom inventory check here
		end
		return false
	end
end

Framework.GetPlayerJob = function(source)
	local job, grade, gradeName

	if vRP then
		local Passport = GetVRPPassport(source)
		job, grade, gradeName = GetVRPPrimaryJob(Passport)
	elseif QBCore then
		local Player = QBCore.Functions.GetPlayer(source)
		job = Player.PlayerData.job.name
		grade = Player.PlayerData.job.grade.level
		gradeName = Player.PlayerData.job.grade.name
	elseif ESX then
		local xPlayer = ESX.GetPlayerFromId(source)
		local jobtbl = xPlayer.getJob()
		job = jobtbl.name
		grade = jobtbl.grade
		gradeName = jobtbl.grade_label
	end

	return job, grade, gradeName
end

Framework.DoJobCheck = function(player, jobs)
	local job, grade, _ = Framework.GetPlayerJob(player)
	if not job or not jobs then return false end

	if jobs[job] then
		if type(jobs[job]) == "table" then
			for _, gr in pairs(jobs[job]) do
				if gr == grade then return true end
			end

			if vRP and Config.VRP.IgnoreGrades then
				return true
			end
		else
			return true
		end
	end

	if vRP then
		local Passport = GetVRPPassport(player)
		if not Passport then return false end

		for JobName, Rule in pairs(jobs) do
			if vRP.HasGroup(Passport, JobName) then
				if type(Rule) == "table" then
					if Config.VRP.IgnoreGrades then
						return true
					end
				else
					return true
				end
			end
		end
	end

	return false
end

Framework.GetPlayerName = function(source)
	local name

	if vRP then
		name = GetVRPPlayerName(source)
	elseif QBCore then
		local Player = QBCore.Functions.GetPlayer(source)
		name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
	elseif ESX then
		local xPlayer = ESX.GetPlayerFromId(source)
		name = xPlayer.getName()
	else
		name = GetPlayerName(source)
	end

	return name
end

Framework.GetPlayerBadgeNumber = function(source)
	local badgeNum

	if vRP then
		local Passport = GetVRPPassport(source)
		if Passport then
			badgeNum = Framework.GetPlayerName(source) .. "#" .. string.format("PM-%05d", Passport)
		end
	elseif QBCore then
		local Player = QBCore.Functions.GetPlayer(source)

		if Player.PlayerData.metadata.callsign then
			badgeNum = Framework.GetPlayerName(source) .. "#" .. Player.PlayerData.metadata.callsign
		end
	else
		-- Implement your badge number system here.
	end

	return badgeNum
end

exports("UseGovermentCam", function(source, ItemName)
	if not Config.ItemSettings.Enabled then return false end
	return HandleVRPItemUse(source, ItemName or "goverment_bodycam")
end)

exports("UseCommercialCam", function(source, ItemName)
	if not Config.ItemSettings.Enabled then return false end
	return HandleVRPItemUse(source, ItemName or "commercial_bodycam")
end)
