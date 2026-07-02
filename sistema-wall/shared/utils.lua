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

	for _, Group in ipairs(Groups) do
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
	local Hp = math.max(0, Health - 100)
	return math.floor(Hp)
end

function Wall_GetHealthPercent(Health)
	local Hp = Wall_FormatHealth(Health)
	return math.min(100, math.max(0, Hp))
end

function Wall_IsDead(Ped, Health)
	if not Ped or not DoesEntityExist(Ped) then return true end
	if Health and Health <= 101 then return true end
	return IsEntityDead(Ped) or IsPedDeadOrDying(Ped, true)
end

function Wall_HexToRgb(Hex)
	Hex = Hex:gsub("#", "")
	if #Hex ~= 6 then return 255, 255, 255 end
	return tonumber(Hex:sub(1, 2), 16) or 255, tonumber(Hex:sub(3, 4), 16) or 255, tonumber(Hex:sub(5, 6), 16) or 255
end
