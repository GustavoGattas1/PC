--[[
	ITENS — cadastrar em @vrp/config/Item.lua
	Creative Uncharted — copie os blocos abaixo.

	IMPORTANTE:
	- ensure bbs_bodycam DEPOIS do vrp no server.cfg
	- Ajuste os nomes dos itens em bridge/vrp/config.lua se necessário
]]

--[[
	["bodycam"] = {
		Index = "bodycam",
		Name = "Câmera Corporal",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["bbs_bodycam"]:UseBodycam(source)
		end
	},

	["dashcam"] = {
		Index = "dashcam",
		Name = "Dashcam",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["bbs_bodycam"]:UseDashcam(source)
		end
	},
]]
