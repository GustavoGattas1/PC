--[[
	ITENS — cadastrar em @vrp/config/Item.lua (mesmo padrão do helicrash/shared)
	Exemplo de estrutura da sua base:
]]

--[[
	["kitpericia"] = {
		["Index"] = "kitpericia",
		["Name"] = "Kit de Perícia",
		["Type"] = "Usável",
		["Weight"] = 1.5,
		["Economy"] = 2500,
		["Description"] = "Kit forense para coleta de evidências na cena do crime."
	},
	["saco-evidencia"] = {
		["Index"] = "saco-evidencia",
		["Name"] = "Saco de Evidência",
		["Type"] = "Comum",
		["Weight"] = 0.3,
		["Description"] = "Saco lacrado com material probatório."
	},
	["luvas-latex"] = {
		["Index"] = "luvas-latex",
		["Name"] = "Luvas de Látex",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Description"] = "Evita deixar impressões digitais."
	},
	["swab-sangue"] = {
		["Index"] = "swab-sangue",
		["Name"] = "Swab de Sangue",
		["Type"] = "Comum",
		["Weight"] = 0.1,
		["Description"] = "Coleta de sangue em cadáveres."
	},
	["kit-gsr"] = {
		["Index"] = "kit-gsr",
		["Name"] = "Kit GSR",
		["Type"] = "Comum",
		["Weight"] = 0.5,
		["Description"] = "Coleta de resíduo de pólvora."
	},
	["saco-cadaver"] = {
		["Index"] = "saco-cadaver",
		["Name"] = "Saco Mortuário",
		["Type"] = "Comum",
		["Weight"] = 2.0,
		["Description"] = "Transporte de corpos ao IML."
	},
	["laudo-pericial"] = {
		["Index"] = "laudo-pericial",
		["Name"] = "Laudo Pericial",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Description"] = "Documento oficial de perícia."
	},
]]

-- Usar luvas (no sistema de itens usáveis da base):
-- TriggerClientEvent("iml-evidencias:ToggleGloves", source)

-- Usar laudo:
-- TriggerServerEvent("iml-evidencias:ViewReport")
