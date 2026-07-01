-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET (olhinho) — Creative / ox_target / qtarget
-----------------------------------------------------------------------------------------------------------------------------------------
local TargetReady = false

function IsCorpsePed(Entity)
	if not Entity or Entity == 0 or not DoesEntityExist(Entity) then
		return false
	end

	if not IsPedAPlayer(Entity) then
		return false
	end

	if Entity == PlayerPedId() then
		return false
	end

	return IsEntityDead(Entity) or GetEntityHealth(Entity) <= 101 or IsPedDeadOrDying(Entity, true)
end

function GetTargetSourceFromPed(Entity)
	local Index = NetworkGetPlayerIndexFromPed(Entity)
	if Index == -1 then return nil end
	return GetPlayerServerId(Index)
end

function ResolveTargetEntity(Selected)
	if type(Selected) == "number" then
		return Selected
	end

	if type(Selected) == "table" then
		return Selected[1] or Selected.entity or Selected.Entity or Selected.ped
	end

	return nil
end

function CanForensicCorpseInteract(Entity)
	if not IsCivil then return false end
	if IsNuiBusy and IsNuiBusy() then return false end
	if not IsFlashlightOut() then return false end
	return IsCorpsePed(Entity)
end

local function ForensicFailNotify(Entity)
	if not IsCivil then
		IMLNotify("negado", Config.Lang.NotAuthorized)
	elseif IsNuiBusy and IsNuiBusy() then
		IMLNotify("important", Config.Lang.PanelBusy)
	elseif not IsFlashlightOut() then
		IMLNotify("negado", Config.Lang.NeedFlashlight)
	elseif not IsCorpsePed(Entity) then
		IMLNotify("negado", Config.Lang.NoCorpse)
	end
end

local function HandleCorpseAction(Selected, Action)
	local Entity = ResolveTargetEntity(Selected)
	if not Entity or not DoesEntityExist(Entity) then return end

	if not CanForensicCorpseInteract(Entity) then
		ForensicFailNotify(Entity)
		return
	end

	local TargetSource = GetTargetSourceFromPed(Entity)
	if not TargetSource then return end

	if Action == "examine" then
		TriggerServerEvent("iml-evidencias:ExamineCorpse", TargetSource)
	elseif Action == "swab" then
		TriggerServerEvent("iml-evidencias:CollectBloodSwab", TargetSource)
	end
end

RegisterNetEvent("iml-evidencias:TargetExamineCorpse")
AddEventHandler("iml-evidencias:TargetExamineCorpse", function(Selected)
	HandleCorpseAction(Selected, "examine")
end)

RegisterNetEvent("iml-evidencias:TargetBloodSwab")
AddEventHandler("iml-evidencias:TargetBloodSwab", function(Selected)
	HandleCorpseAction(Selected, "swab")
end)

local function BuildCreativeOptions()
	return {
		{
			event = "iml-evidencias:TargetExamineCorpse",
			label = "Periciar Cadáver",
			tunnel = "client",
			service = Config.Groups.Civil[1] or "Civil"
		},
		{
			event = "iml-evidencias:TargetBloodSwab",
			label = "Coletar Sangue (Swab)",
			tunnel = "client",
			service = Config.Groups.Civil[1] or "Civil"
		}
	}
end

local function BuildOxOptions()
	return {
		{
			name = "iml_examine_corpse",
			icon = "fa-solid fa-user-doctor",
			label = "Periciar Cadáver",
			distance = Config.Target.Distance,
			canInteract = function(Entity) return CanForensicCorpseInteract(Entity) end,
			onSelect = function(Data) HandleCorpseAction(Data.entity, "examine") end
		},
		{
			name = "iml_blood_swab",
			icon = "fa-solid fa-vial",
			label = "Coletar Sangue (Swab)",
			distance = Config.Target.Distance,
			canInteract = function(Entity) return CanForensicCorpseInteract(Entity) end,
			onSelect = function(Data) HandleCorpseAction(Data.entity, "swab") end
		}
	}
end

local function BuildQtargetOptions()
	local Options = {}
	for _, Entry in ipairs(BuildOxOptions()) do
		Options[#Options + 1] = {
			icon = Entry.icon,
			label = Entry.label,
			action = function(Entity) Entry.onSelect({ entity = Entity }) end,
			canInteract = Entry.canInteract
		}
	end
	return Options
end

function IML_RegisterTargets()
	if TargetReady then return end

	local Distance = Config.Target.Distance or 3.0

	if GetResourceState("target") == "started" then
		local CreativeOptions = BuildCreativeOptions()
		local Ok = pcall(function()
			exports["target"]:AddGlobalPlayer({
				options = CreativeOptions,
				Distance = Distance,
				distance = Distance
			})
		end)

		if not Ok then
			Ok = pcall(function()
				exports["target"]:AddTargetPlayer({
					options = CreativeOptions,
					distance = Distance
				})
			end)
		end

		if Ok then
			TargetReady = true
			return
		end
	end

	if GetResourceState("ox_target") == "started" then
		local Ok = pcall(function()
			exports.ox_target:addGlobalPlayer(BuildOxOptions())
		end)
		if Ok then
			TargetReady = true
			return
		end
	end

	if GetResourceState("qtarget") == "started" then
		local Ok = pcall(function()
			exports.qtarget:Player({
				options = BuildQtargetOptions(),
				distance = Distance,
				type = "other"
			})
		end)
		if Ok then
			TargetReady = true
			return
		end
	end

	if GetResourceState("qb-target") == "started" then
		local Ok = pcall(function()
			exports["qb-target"]:AddGlobalPlayer({
				options = {
					{
						type = "client",
						event = "iml-evidencias:TargetExamineCorpse",
						icon = "fas fa-user-doctor",
						label = "Periciar Cadáver",
						canInteract = function(Entity) return CanForensicCorpseInteract(Entity) end
					},
					{
						type = "client",
						event = "iml-evidencias:TargetBloodSwab",
						icon = "fas fa-vial",
						label = "Coletar Sangue (Swab)",
						canInteract = function(Entity) return CanForensicCorpseInteract(Entity) end
					}
				},
				distance = Distance
			})
		end)
		if Ok then
			TargetReady = true
		end
	end
end

CreateThread(function()
	while not IsCivil do
		Wait(2000)
	end
	Wait(1500)
	IML_RegisterTargets()
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function()
	Wait(3000)
	IML_RegisterTargets()
end)
