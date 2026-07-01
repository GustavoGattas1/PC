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

	local Health = GetEntityHealth(Entity)
	if Health > 0 and Health <= 101 then
		return true
	end

	if IsEntityDead(Entity) or IsPedDeadOrDying(Entity, true) or IsPedFatallyInjured(Entity) then
		return true
	end

	local PlayerIndex = NetworkGetPlayerIndexFromPed(Entity)
	if PlayerIndex ~= -1 then
		local ServerId = GetPlayerServerId(PlayerIndex)
		local State = Player(ServerId).state
		if State and (State.Death or State.death or State.Coma or State.coma) then
			return true
		end
	end

	return false
end

function GetTargetSourceFromPed(Entity)
	local Index = NetworkGetPlayerIndexFromPed(Entity)
	if Index == -1 then return nil end
	return GetPlayerServerId(Index)
end

function ResolveTargetEntity(...)
	local Args = { ... }

	for _, Arg in ipairs(Args) do
		if type(Arg) == "number" and DoesEntityExist(Arg) then
			return Arg
		end

		if type(Arg) == "table" then
			local Entity = Arg.entity or Arg.Entity or Arg.ped or Arg.Ped or Arg[1]
			if type(Entity) == "number" and DoesEntityExist(Entity) then
				return Entity
			end
		end
	end

	if type(Selected) == "number" and DoesEntityExist(Selected) then
		return Selected
	end

	if type(Selected) == "table" then
		local Entity = Selected.entity or Selected.Entity or Selected[1]
		if type(Entity) == "number" and DoesEntityExist(Entity) then
			return Entity
		end
	end

	for _, ExportName in ipairs({ "GetTargetEntity", "GetEntity", "SelectTarget", "RaycastTarget" }) do
		local Ok, Entity = pcall(function()
			return exports["target"][ExportName]()
		end)

		if Ok and type(Entity) == "number" and DoesEntityExist(Entity) then
			return Entity
		end
	end

	return nil
end

function CanPerformForensicAction()
	if not IsCivil then return false end
	if IsNuiBusy and IsNuiBusy() then return false end
	if not IsFlashlightOut() then return false end
	return true
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

	if not IsCorpsePed(Entity) then
		IMLNotify("negado", Config.Lang.NoCorpse)
		return
	end

	if not CanPerformForensicAction() then
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
AddEventHandler("iml-evidencias:TargetExamineCorpse", function(...)
	HandleCorpseAction(..., "examine")
end)

RegisterNetEvent("iml-evidencias:TargetBloodSwab")
AddEventHandler("iml-evidencias:TargetBloodSwab", function(...)
	HandleCorpseAction(..., "swab")
end)

local function CorpseCanInteract(Entity)
	return IsCorpsePed(Entity)
end

local function BuildCreativeOptions()
	local Service = Config.Groups.Civil[1] or "Civil"

	return {
		{
			event = "iml-evidencias:TargetExamineCorpse",
			label = "Periciar Cadáver",
			tunnel = "client",
			service = Service,
			canInteract = CorpseCanInteract,
			action = function(Entity) HandleCorpseAction(Entity, "examine") end
		},
		{
			event = "iml-evidencias:TargetBloodSwab",
			label = "Coletar Sangue (Swab)",
			tunnel = "client",
			service = Service,
			canInteract = CorpseCanInteract,
			action = function(Entity) HandleCorpseAction(Entity, "swab") end
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
			canInteract = function(Entity) return CorpseCanInteract(Entity) end,
			onSelect = function(Data) HandleCorpseAction(Data.entity, "examine") end
		},
		{
			name = "iml_blood_swab",
			icon = "fa-solid fa-vial",
			label = "Coletar Sangue (Swab)",
			distance = Config.Target.Distance,
			canInteract = function(Entity) return CorpseCanInteract(Entity) end,
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

local function TryRegisterCreative(Distance)
	local CreativeOptions = BuildCreativeOptions()
	local Attempts = {
		function()
			exports["target"]:AddGlobalPed({
				options = CreativeOptions,
				distance = Distance,
				Distance = Distance
			})
		end,
		function()
			exports["target"]:AddTargetPed({
				options = CreativeOptions,
				distance = Distance,
				Distance = Distance
			})
		end,
		function()
			exports["target"]:AddGlobalPlayer({
				options = CreativeOptions,
				distance = Distance,
				Distance = Distance
			})
		end,
		function()
			exports["target"]:AddTargetPlayer({
				options = CreativeOptions,
				distance = Distance
			})
		end
	}

	for _, Attempt in ipairs(Attempts) do
		local Ok = pcall(Attempt)
		if Ok then
			return true
		end
	end

	return false
end

function IML_RegisterTargets()
	if TargetReady then return end

	local Distance = Config.Target.Distance or 3.0

	if GetResourceState("target") == "started" then
		if TryRegisterCreative(Distance) then
			TargetReady = true
			return
		end
	end

	if GetResourceState("ox_target") == "started" then
		local OkPed = pcall(function()
			exports.ox_target:addGlobalPed(BuildOxOptions())
		end)
		local OkPlayer = pcall(function()
			exports.ox_target:addGlobalPlayer(BuildOxOptions())
		end)

		if OkPed or OkPlayer then
			TargetReady = true
			return
		end
	end

	if GetResourceState("qtarget") == "started" then
		local Options = BuildQtargetOptions()
		local OkPed = pcall(function()
			exports.qtarget:Ped({
				options = Options,
				distance = Distance,
				type = "other"
			})
		end)
		local OkPlayer = pcall(function()
			exports.qtarget:Player({
				options = Options,
				distance = Distance,
				type = "other"
			})
		end)

		if OkPed or OkPlayer then
			TargetReady = true
			return
		end
	end

	if GetResourceState("qb-target") == "started" then
		local QbOptions = {
			{
				type = "client",
				event = "iml-evidencias:TargetExamineCorpse",
				icon = "fas fa-user-doctor",
				label = "Periciar Cadáver",
				canInteract = function(Entity) return CorpseCanInteract(Entity) end,
				action = function(Entity) HandleCorpseAction(Entity, "examine") end
			},
			{
				type = "client",
				event = "iml-evidencias:TargetBloodSwab",
				icon = "fas fa-vial",
				label = "Coletar Sangue (Swab)",
				canInteract = function(Entity) return CorpseCanInteract(Entity) end,
				action = function(Entity) HandleCorpseAction(Entity, "swab") end
			}
		}

		local OkPed = pcall(function()
			exports["qb-target"]:AddGlobalPed({
				options = QbOptions,
				distance = Distance
			})
		end)
		local OkPlayer = pcall(function()
			exports["qb-target"]:AddGlobalPlayer({
				options = QbOptions,
				distance = Distance
			})
		end)

		if OkPed or OkPlayer then
			TargetReady = true
		end
	end
end

CreateThread(function()
	while GetResourceState("target") ~= "started"
		and GetResourceState("ox_target") ~= "started"
		and GetResourceState("qtarget") ~= "started"
		and GetResourceState("qb-target") ~= "started" do
		Wait(1000)
	end

	Wait(1500)

	while not TargetReady do
		IML_RegisterTargets()
		Wait(5000)
	end
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function()
	Wait(2000)
	TargetReady = false
	IML_RegisterTargets()
end)

RegisterNetEvent("iml-evidencias:RefreshAccess")
AddEventHandler("iml-evidencias:RefreshAccess", function()
	if IsCivil and not TargetReady then
		IML_RegisterTargets()
	end
end)
