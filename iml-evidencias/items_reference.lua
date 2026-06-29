--[[
	ITENS PARA ADICIONAR NO INVENTÁRIO (Creative Uncharted)
	Copie para vrp/config/Item.lua ou equivalente
]]

--[[
	["kitpericia"] = {
		["Index"] = "kitpericia",
		["Name"] = "Kit de Perícia",
		["Type"] = "Usável",
		["Weight"] = 1.5,
		["Description"] = "Kit forense completo: pinças, luvas, envelopes e swabs."
	},
	["saco-evidencia"] = {
		["Index"] = "saco-evidencia",
		["Name"] = "Saco de Evidência",
		["Type"] = "Comum",
		["Weight"] = 0.3,
		["Description"] = "Saco lacrado com material probatório da cena do crime."
	},
	["luvas-latex"] = {
		["Index"] = "luvas-latex",
		["Name"] = "Luvas de Látex",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Description"] = "Evita deixar impressões digitais na cena."
	},
	["swab-sangue"] = {
		["Index"] = "swab-sangue",
		["Name"] = "Swab de Sangue",
		["Type"] = "Comum",
		["Weight"] = 0.1,
		["Description"] = "Cotonete estéril para coleta de sangue em cadáveres."
	},
	["kit-gsr"] = {
		["Index"] = "kit-gsr",
		["Name"] = "Kit GSR",
		["Type"] = "Comum",
		["Weight"] = 0.5,
		["Description"] = "Kit para coleta de resíduo de pólvora nas mãos."
	},
	["saco-cadaver"] = {
		["Index"] = "saco-cadaver",
		["Name"] = "Saco Mortuário",
		["Type"] = "Comum",
		["Weight"] = 2.0,
		["Description"] = "Saco para transporte de corpos ao IML."
	},
	["laudo-pericial"] = {
		["Index"] = "laudo-pericial",
		["Name"] = "Laudo Pericial",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Description"] = "Documento oficial com resultado da perícia."
	},
]]

-- Usar luvas: TriggerClientEvent("iml-evidencias:ToggleGloves", source)
