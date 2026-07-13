-----------------------------------------------------------------------------------------------------------------------------------------
-- BBS BODYCAM — PONTE vRP / CREATIVE UNCHARTED
-- Cole estes arquivos na pasta de framework do bbs_bodycam e aponte o config do BBS para "vrp".
-----------------------------------------------------------------------------------------------------------------------------------------
BBS_VRP = BBS_VRP or {}

BBS_VRP.Debug = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- GRUPOS COM ACESSO À BODYCAM
-----------------------------------------------------------------------------------------------------------------------------------------
BBS_VRP.Groups = {
	"Policia",
	"PMERJ",
	"PRF",
	"BOPE",
	"Civil",
	"Federal",
	"GOT",
	"CORE"
}

BBS_VRP.SupervisorGroups = {
	"Comando",
	"SubComando",
	"Coronel",
	"TenenteCoronel",
	"Major",
	"Capitao",
	"Delegado",
	"Admin"
}

BBS_VRP.RequireService = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS (ajuste aos nomes do seu inventário / README do BBS)
-----------------------------------------------------------------------------------------------------------------------------------------
BBS_VRP.Items = {
	Bodycam = "bodycam",
	Dashcam = "dashcam"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANCO (mesmo padrão iml-evidencias / sistema-wall / loja-vip)
-----------------------------------------------------------------------------------------------------------------------------------------
BBS_VRP.Database = {
	CharacterId = "id",
	CharacterLicense = "License",
	CharacterName = "Name",
	CharacterName2 = "Lastname"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
BBS_VRP.Notify = {
	success = { Title = "Bodycam", Color = "verde" },
	negado = { Title = "Bodycam", Color = "vermelho" },
	important = { Title = "Bodycam", Color = "amarelo" },
	info = { Title = "Bodycam", Color = "azul" }
}

BBS_VRP.Lang = {
	NotAuthorized = "Você não tem permissão para usar a bodycam.",
	NeedService = "Você precisa estar em serviço.",
	NoItem = "Você não possui o equipamento necessário."
}
