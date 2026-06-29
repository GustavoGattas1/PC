--[[
	ITENS PARA ADICIONAR NO SEU INVENTÁRIO (Creative Uncharted)
	Copie e adapte conforme o arquivo de itens da sua base.
	Normalmente em: vrp/config/Item.lua ou inventory/config
]]

--[[
	["kitpericia"] = {
		["Index"] = "kitpericia",
		["Name"] = "Kit de Perícia",
		["Type"] = "Usável",
		["Weight"] = 1.5,
		["Economy"] = 2500,
		["Description"] = "Kit forense com pinças, swabs e envelopes para coleta de evidências."
	},

	["saco-evidencia"] = {
		["Index"] = "saco-evidencia",
		["Name"] = "Saco de Evidência",
		["Type"] = "Comum",
		["Weight"] = 0.3,
		["Economy"] = 50,
		["Description"] = "Saco lacrado contendo material probatório coletado na cena do crime."
	},

	["luvas-latex"] = {
		["Index"] = "luvas-latex",
		["Name"] = "Luvas de Látex",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Economy"] = 25,
		["Description"] = "Luvas descartáveis que evitam deixar impressões digitais."
	},

	["saco-cadaver"] = {
		["Index"] = "saco-cadaver",
		["Name"] = "Saco Mortuário",
		["Type"] = "Comum",
		["Weight"] = 2.0,
		["Economy"] = 500,
		["Description"] = "Saco para acondicionamento e transporte de corpos."
	},

	["laudo-pericial"] = {
		["Index"] = "laudo-pericial",
		["Name"] = "Laudo Pericial",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Economy"] = 0,
		["Description"] = "Documento oficial com resultado da perícia forense."
	},
]]

-- Evento para usar luvas de látex (adicione no seu sistema de itens usáveis):
-- RegisterServerEvent ou no módulo de inventário:
--
-- if Item == "luvas-latex" then
--     TriggerClientEvent("iml-evidencias:ToggleGloves", source)
-- end
--
-- if Item == "laudo-pericial" then
--     -- Abrir último laudo do jogador via TriggerServerEvent
-- end
