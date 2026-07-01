--[[
	ITENS — cadastrar em @vrp/config/Item.lua
	Creative Uncharted — copie os blocos abaixo (sem hífen nos nomes).

	IMPORTANTE:
	- O inventário Creative geralmente JÁ CONSOME o item ao usar.
	- Por isso o Execute só chama o export — não use TakeItem no Item.lua.
	- ensure iml-evidencias DEPOIS do vrp no server.cfg
]]

--[[
	["kitpericia"] = {
		Index = "kitpericia",
		Name = "Kit de Perícia",
		Type = "Usável",
		Weight = 1.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "kitpericia")
		end
	},

	["tabletforense"] = {
		Index = "tabletforense",
		Name = "Tablet Forense",
		Type = "Usável",
		Weight = 0.8,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "tabletforense")
		end
	},

	["luvaslatex"] = {
		Index = "luvaslatex",
		Name = "Luvas de Látex",
		Type = "Usável",
		Weight = 0.1,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "luvaslatex")
		end
	},

	["sacocadaver"] = {
		Index = "sacocadaver",
		Name = "Saco Mortuário",
		Type = "Usável",
		Weight = 2.0,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "sacocadaver")
		end
	},

	["scannergsr"] = {
		Index = "scannergsr",
		Name = "Scanner GSR",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "scannergsr")
		end
	},

	["laudopericial"] = {
		Index = "laudopericial",
		Name = "Laudo Pericial",
		Type = "Usável",
		Weight = 0.1,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "laudopericial")
		end
	},

	["marcadorevidencia"] = {
		Index = "marcadorevidencia",
		Name = "Marcador de Evidência",
		Type = "Usável",
		Weight = 0.3,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "marcadorevidencia")
		end
	},

	["fitapolicial"] = {
		Index = "fitapolicial",
		Name = "Fita Policial",
		Type = "Usável",
		Weight = 0.2,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, Item or Full or "fitapolicial")
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
