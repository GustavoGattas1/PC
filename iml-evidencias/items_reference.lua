--[[
	ITENS — cadastrar em @vrp/config/Item.lua
	Creative Uncharted — copie os blocos abaixo (sem hífen nos nomes).
]]

--[[
	["kitpericia"] = {
		Index = "kitpericia",
		Name = "Kit de Perícia",
		Type = "Usável",
		Weight = 1.5,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "kitpericia")
		end
	},

	["tabletforense"] = {
		Index = "tabletforense",
		Name = "Tablet Forense",
		Type = "Usável",
		Weight = 0.8,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "tabletforense")
		end
	},

	["luvaslatex"] = {
		Index = "luvaslatex",
		Name = "Luvas de Látex",
		Type = "Usável",
		Weight = 0.1,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "luvaslatex")
		end
	},

	["sacocadaver"] = {
		Index = "sacocadaver",
		Name = "Saco Mortuário",
		Type = "Usável",
		Weight = 2.0,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "sacocadaver")
		end
	},

	["scannergsr"] = {
		Index = "scannergsr",
		Name = "Scanner GSR",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "scannergsr")
		end
	},

	["laudopericial"] = {
		Index = "laudopericial",
		Name = "Laudo Pericial",
		Type = "Usável",
		Weight = 0.1,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "laudopericial")
		end
	},

	["marcadorevidencia"] = {
		Index = "marcadorevidencia",
		Name = "Marcador de Evidência",
		Type = "Usável",
		Weight = 0.3,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "marcadorevidencia")
		end
	},

	["fitapolicial"] = {
		Index = "fitapolicial",
		Name = "Fita Policial",
		Type = "Usável",
		Weight = 0.2,
		Execute = function(source)
			exports["iml-evidencias"]:UseItem(source, "fitapolicial")
		end
	},

	-- Itens de consumo / resultado (sem Execute)
	["sacoevidencia"] = {
		Index = "sacoevidencia",
		Name = "Saco de Evidência",
		Type = "Comum",
		Weight = 0.5
	},

	["swabsangue"] = {
		Index = "swabsangue",
		Name = "Swab de Sangue",
		Type = "Comum",
		Weight = 0.1
	},

	["kitgsr"] = {
		Index = "kitgsr",
		Name = "Kit GSR",
		Type = "Comum",
		Weight = 0.3
	},

	["moldepneu"] = {
		Index = "moldepneu",
		Name = "Molde de Pneu",
		Type = "Comum",
		Weight = 0.4
	},

	["relatoriodna"] = {
		Index = "relatoriodna",
		Name = "Relatório de DNA",
		Type = "Comum",
		Weight = 0.1
	},

	["relatoriobalistica"] = {
		Index = "relatoriobalistica",
		Name = "Relatório Balístico",
		Type = "Comum",
		Weight = 0.1
	},
]]

-- Alternativa via evento (se sua base usar):
-- TriggerServerEvent("iml-evidencias:UseItem", "fitapolicial")

-- Comandos de fallback no jogo:
-- /luvas — equipar/remover luvas
-- /cena ou M — overlay de investigação
-- /tabletforense — abrir tablet
-- /coletarcorpo — coletar corpo com saco mortuário
