--[[
	ITENS — cadastrar em @vrp/config/Item.lua
	Creative Uncharted — copie os blocos abaixo.

	IMPORTANTE:
	- ensure bbs_bodycam DEPOIS do vrp no server.cfg
	- Ícones em bbs_bodycam/itemicons/ (se existir na sua cópia)
]]

--[[
	["goverment_bodycam"] = {
		Index = "goverment_bodycam",
		Name = "Bodycam Governamental",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["bbs_bodycam"]:UseGovermentCam(source, Item or Full or "goverment_bodycam")
		end
	},

	["commercial_bodycam"] = {
		Index = "commercial_bodycam",
		Name = "Bodycam Comercial",
		Type = "Usável",
		Weight = 0.5,
		Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
			exports["bbs_bodycam"]:UseCommercialCam(source, Item or Full or "commercial_bodycam")
		end
	},
]]
