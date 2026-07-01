--[[
	ITENS — cadastrar em @vrp/config/Item.lua
	Creative Uncharted — copie os blocos abaixo e ajuste Execute conforme sua base.
]]

--[[
	["kitpericia"] = {
		["Index"] = "kitpericia",
		["Name"] = "Kit de Perícia",
		["Type"] = "Usável",
		["Weight"] = 1.5,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseTablet(source)
		end
	},
	["tablet-forense"] = {
		["Index"] = "tablet-forense",
		["Name"] = "Tablet Forense",
		["Type"] = "Usável",
		["Weight"] = 0.8,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseTablet(source)
		end
	},
	["luvas-latex"] = {
		["Index"] = "luvas-latex",
		["Name"] = "Luvas de Látex",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseLuvas(source)
		end
	},
	["saco-cadaver"] = {
		["Index"] = "saco-cadaver",
		["Name"] = "Saco Mortuário",
		["Type"] = "Usável",
		["Weight"] = 2.0,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseBodyBag(source)
		end
	},
	["scanner-gsr"] = {
		["Index"] = "scanner-gsr",
		["Name"] = "Scanner GSR",
		["Type"] = "Usável",
		["Weight"] = 0.5,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseGsrScanner(source)
		end
	},
	["laudo-pericial"] = {
		["Index"] = "laudo-pericial",
		["Name"] = "Laudo Pericial",
		["Type"] = "Usável",
		["Weight"] = 0.1,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseLaudo(source)
		end
	},
	["marcador-evidencia"] = {
		["Index"] = "marcador-evidencia",
		["Name"] = "Marcador de Evidência",
		["Type"] = "Usável",
		["Weight"] = 0.3,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, "marcador-evidencia")
		end
	},
	["fita-policial"] = {
		["Index"] = "fita-policial",
		["Name"] = "Fita Policial",
		["Type"] = "Usável",
		["Weight"] = 0.2,
		["Execute"] = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["iml-evidencias"]:UseItem(source, "fita-policial")
		end
	},
]]

-- Alternativa via evento (se sua base usar):
-- TriggerServerEvent("iml-evidencias:UseItem", "luvas-latex")

-- Comandos de fallback no jogo:
-- /luvas — equipar/remover luvas
-- /cena ou M — overlay de investigação
-- /tabletforense — abrir tablet
-- /coletarcorpo — coletar corpo com saco mortuário
