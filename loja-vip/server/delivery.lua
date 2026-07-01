-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGA DE ITENS — inventário direto (sem dropar no chão)
-----------------------------------------------------------------------------------------------------------------------------------------

function Loja_GiveItem(Passport, Source, Item, Amount)
	if not Passport or not Item then return false end

	Amount = tonumber(Amount) or 1

	if vRP.GenerateItem then
		local Ok = pcall(function()
			vRP.GenerateItem(Passport, Item, Amount, true)
		end)
		if Ok then return true end
	end

	if vRP.GiveItem then
		local Ok = pcall(function()
			vRP.GiveItem(Passport, Item, Amount, true)
		end)
		if Ok then return true end
	end

	if GetResourceState("inventory") == "started" then
		local Ok = pcall(function()
			exports["inventory"]:GiveItem(Passport, Item, Amount, true)
		end)
		if Ok then return true end

		if Source then
			Ok = pcall(function()
				exports["inventory"]:GiveItem(Source, Item, Amount, true)
			end)
			if Ok then return true end
		end
	end

	Loja_Debug("Falha ao entregar item:", Item, Amount, "passport:", Passport)
	return false
end

function Loja_GiveBank(Passport, Amount)
	Amount = tonumber(Amount) or 0
	if Amount <= 0 then return false end
	return Loja_Bridge_GiveBank(Passport, Amount)
end

function Loja_ClearPlayerCache(Passport)
	if Loja_Bridge_ClearCache then
		Loja_Bridge_ClearCache(Passport)
	end
end
