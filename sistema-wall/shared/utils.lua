-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------

function Wall_Debug(...)
	if Config.Debug then
		print("[sistema-wall]", ...)
	end
end

function Wall_NotifyClient(Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.info
	TriggerEvent("Notify", Info.Title, Message, Info.Color, Duration or 5000)
end

function Wall_NotifyServer(Source, Type, Message, Duration)
	local Info = Config.Notify[Type] or Config.Notify.info
	TriggerClientEvent("Notify", Source, Info.Title, Message, Info.Color, Duration or 5000)
end

function Wall_HasGroup(Passport, Groups)
	if not Passport or not Groups then return false end
	if type(Groups) == "string" then Groups = { Groups } end

	for i = 1, #Groups do
		local Group = Groups[i]
		if Config.RequireService and vRP and vRP.HasService(Passport, Group) then
			return true
		end
		if vRP and vRP.HasGroup(Passport, Group) then
			return true
		end
	end

	return false
end

function Wall_GetWeaponLabel(Hash)
	if not Hash or Hash == 0 then return "Desarmado" end
	return Config.Weapons[Hash] or ("Arma #" .. tostring(Hash))
end

function Wall_Round(Number, Decimals)
	local Mult = 10 ^ (Decimals or 0)
	return math.floor(Number * Mult + 0.5) / Mult
end

function Wall_FormatHealth(Health)
	return math.floor(math.max(0, Health - 100))
end

function Wall_IsDead(Ped, Health)
	if Health and Health <= 101 then return true end
	if not Ped or not DoesEntityExist(Ped) then return true end
	return IsEntityDead(Ped) or IsPedDeadOrDying(Ped, true)
end
