-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------
function DebugPrint(...)
	if Config.Debug then
		print("[IML]", ...)
	end
end

function HasForensicGroup(Groups)
	if not Groups then return false end
	for _, Group in ipairs(Groups) do
		if Group then return true end
	end
	return false
end

function GetWeaponLabel(Hash)
	return Config.Weapons[Hash] or ("Arma Desconhecida (#" .. tostring(Hash) .. ")")
end

function GenerateSerial()
	local Chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local Serial = ""
	for i = 1, 8 do
		local Index = math.random(1, #Chars)
		Serial = Serial .. string.sub(Chars, Index, Index)
	end
	return Serial
end

function GenerateDnaCode(Passport)
	return string.format("DNA-%05d-%s", Passport, string.upper(string.sub(GenerateSerial(), 1, 4)))
end

function FormatTimestamp()
	return os.date("%d/%m/%Y às %H:%M")
end
