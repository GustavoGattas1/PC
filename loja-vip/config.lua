-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA VIP — CONFIGURAÇÃO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-- Comando para abrir a loja
Config.Command = "loja"
Config.CommandAliases = { "vip", "store", "donate" }

-- Moeda padrão: "gems" (diamantes) ou "bank" (banco in-game)
Config.DefaultCurrency = "gems"

-- Cooldown entre compras (ms) — anti-spam
Config.PurchaseCooldown = 3000

-- Distância para interagir no ponto físico da loja
Config.InteractDistance = 2.5

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY (padrão Creative Uncharted)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	success = { Title = "Loja VIP", Color = "verde" },
	negado = { Title = "Loja VIP", Color = "vermelho" },
	important = { Title = "Loja VIP", Color = "amarelo" },
	info = { Title = "Loja VIP", Color = "azul" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP E LOCAL FÍSICO DA LOJA (opcional — /loja funciona em qualquer lugar)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Blips = {
	Enabled = true,
	Sprite = 617,
	Color = 46,
	Scale = 0.85,
	Label = "Loja VIP"
}

Config.Locations = {
	{
		Coords = vec3(-1082.22, -247.52, 37.76),
		Heading = 210.0,
		Label = "Loja VIP — Premium Store",
		Marker = {
			Type = 29,
			Scale = vec3(0.6, 0.6, 0.6),
			Color = { r = 255, g = 200, b = 50, a = 180 }
		}
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CATEGORIAS DA LOJA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Categories = {
	{ id = "all", label = "Todos", icon = "grid", description = "Todos os produtos disponíveis" },
	{ id = "vip", label = "Planos VIP", icon = "crown", description = "Assinaturas e benefícios exclusivos" },
	{ id = "vehicles", label = "Veículos", icon = "car", description = "Carros, motos e veículos especiais" },
	{ id = "houses", label = "Casas", icon = "home", description = "Propriedades e imóveis premium" },
	{ id = "items", label = "Itens", icon = "box", description = "Itens, kits e consumíveis" },
	{ id = "packs", label = "Packs", icon = "gift", description = "Combos com desconto" },
	{ id = "extras", label = "Extras", icon = "star", description = "Slots, personagens e upgrades" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PRODUTOS
-- type: vip | vehicle | house | item | pack | extra
-- currency: gems | bank
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Products = {
	-------------------------------------------------------------------------------------------------------------------------------------
	-- PLANOS VIP
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "vip_bronze",
		category = "vip",
		type = "vip",
		name = "VIP Bronze",
		description = "Tag exclusiva, +1 slot de garagem, salário diário de R$5.000 e acesso ao chat VIP.",
		price = 150,
		currency = "gems",
		badge = "Popular",
		benefits = {
			"Tag [VIP Bronze] no chat",
			"+1 slot de garagem",
			"Salário diário R$5.000",
			"Acesso ao chat VIP",
			"30 dias de duração"
		},
		data = { group = "Bronze", level = 1, days = 30, salary = 5000, garageSlots = 1 }
	},
	{
		id = "vip_prata",
		category = "vip",
		type = "vip",
		name = "VIP Prata",
		description = "Todos os benefícios Bronze + veículo exclusivo, +2 slots de garagem e prioridade na fila.",
		price = 350,
		currency = "gems",
		badge = "Recomendado",
		benefits = {
			"Tudo do VIP Bronze",
			"+2 slots de garagem (total 3)",
			"Salário diário R$10.000",
			"Prioridade na fila do servidor",
			"1 veículo VIP incluso (escolha na garagem)",
			"30 dias de duração"
		},
		data = { group = "Prata", level = 2, days = 30, salary = 10000, garageSlots = 3, priority = true }
	},
	{
		id = "vip_ouro",
		category = "vip",
		type = "vip",
		name = "VIP Ouro",
		description = "Pacote premium completo com casa starter, 3 veículos VIP e benefícios máximos.",
		price = 750,
		currency = "gems",
		badge = "Premium",
		benefits = {
			"Tudo do VIP Prata",
			"+5 slots de garagem",
			"Salário diário R$25.000",
			"Casa starter inclusa",
			"3 veículos VIP à escolha",
			"Desconto de 15% na loja",
			"30 dias de duração"
		},
		data = { group = "Ouro", level = 3, days = 30, salary = 25000, garageSlots = 5, house = "VipStarter", discount = 15 }
	},
	{
		id = "vip_diamante",
		category = "vip",
		type = "vip",
		name = "VIP Diamante",
		description = "O plano definitivo — mansão exclusiva, frota completa e status máximo no servidor.",
		price = 1500,
		currency = "gems",
		badge = "Elite",
		benefits = {
			"Tudo do VIP Ouro",
			"+10 slots de garagem",
			"Salário diário R$50.000",
			"Mansão exclusiva inclusa",
			"5 veículos hyper à escolha",
			"Desconto de 25% na loja",
			"Suporte prioritário",
			"30 dias de duração"
		},
		data = { group = "Diamante", level = 4, days = 30, salary = 50000, garageSlots = 10, house = "VipMansion", discount = 25 }
	},

	-------------------------------------------------------------------------------------------------------------------------------------
	-- VEÍCULOS
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "veh_adder",
		category = "vehicles",
		type = "vehicle",
		name = "Truffade Adder",
		description = "Superesportivo icônico — velocidade máxima e design agressivo.",
		price = 200,
		currency = "gems",
		badge = "Super",
		data = { model = "adder", work = false }
	},
	{
		id = "veh_t20",
		category = "vehicles",
		type = "vehicle",
		name = "Progen T20",
		description = "Hypercar de elite com aerodinâmica avançada.",
		price = 250,
		currency = "gems",
		badge = "Hyper",
		data = { model = "t20", work = false }
	},
	{
		id = "veh_zentorno",
		category = "vehicles",
		type = "vehicle",
		name = "Pegassi Zentorno",
		description = "Superesportivo italiano com tração traseira brutal.",
		price = 220,
		currency = "gems",
		data = { model = "zentorno", work = false }
	},
	{
		id = "veh_sultanrs",
		category = "vehicles",
		type = "vehicle",
		name = "Karin Sultan RS",
		description = "Sedan esportivo AWD — perfeito para drift e corrida.",
		price = 120,
		currency = "gems",
		badge = "Drift",
		data = { model = "sultanrs", work = false }
	},
	{
		id = "veh_bati",
		category = "vehicles",
		type = "vehicle",
		name = "Pegassi Bati 801",
		description = "Moto esportiva veloz e ágil para o trânsito urbano.",
		price = 80,
		currency = "gems",
		data = { model = "bati", work = false }
	},
	{
		id = "veh_insurgent",
		category = "vehicles",
		type = "vehicle",
		name = "HVY Insurgent",
		description = "Blindado militar — proteção máxima contra tiros.",
		price = 400,
		currency = "gems",
		badge = "Blindado",
		data = { model = "insurgent", work = false }
	},
	{
		id = "veh_volatus",
		category = "vehicles",
		type = "vehicle",
		name = "Buckingham Volatus",
		description = "Helicóptero de luxo para transporte VIP aéreo.",
		price = 600,
		currency = "gems",
		badge = "Aéreo",
		data = { model = "volatus", work = false }
	},
	{
		id = "veh_seashark",
		category = "vehicles",
		type = "vehicle",
		name = "Speedophile Seashark",
		description = "Jet ski para diversão nas praias e costa.",
		price = 50,
		currency = "gems",
		data = { model = "seashark", work = false }
	},

	-------------------------------------------------------------------------------------------------------------------------------------
	-- CASAS / PROPRIEDADES
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "house_apto_vip",
		category = "houses",
		type = "house",
		name = "Apartamento VIP",
		description = "Apartamento moderno no centro com garagem para 2 veículos.",
		price = 300,
		currency = "gems",
		badge = "Starter",
		benefits = { "2 vagas de garagem", "Baú de 100kg", "Interior moderno" },
		data = { property = "ApartamentoVip", interior = "modern" }
	},
	{
		id = "house_casa_praia",
		category = "houses",
		type = "house",
		name = "Casa de Praia",
		description = "Residência à beira-mar com vista panorâmica e piscina.",
		price = 550,
		currency = "gems",
		badge = "Luxo",
		benefits = { "4 vagas de garagem", "Baú de 250kg", "Vista para o mar", "Piscina" },
		data = { property = "CasaPraia", interior = "beach" }
	},
	{
		id = "house_mansao_hills",
		category = "houses",
		type = "house",
		name = "Mansão Vinewood Hills",
		description = "Mansão exclusiva nas colinas com heliponto e garagem ampla.",
		price = 1200,
		currency = "gems",
		badge = "Elite",
		benefits = { "10 vagas de garagem", "Baú de 500kg", "Heliponto", "Segurança 24h" },
		data = { property = "MansaoHills", interior = "mansion" }
	},
	{
		id = "house_loft_industrial",
		category = "houses",
		type = "house",
		name = "Loft Industrial",
		description = "Loft estilo industrial no centro — ideal para empresários.",
		price = 400,
		currency = "gems",
		benefits = { "3 vagas de garagem", "Baú de 150kg", "Escritório integrado" },
		data = { property = "LoftIndustrial", interior = "loft" }
	},

	-------------------------------------------------------------------------------------------------------------------------------------
	-- ITENS
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "item_kit_inicial",
		category = "items",
		type = "item",
		name = "Kit Inicial VIP",
		description = "Kit completo para começar: comida, água, bandagem e celular.",
		price = 30,
		currency = "gems",
		data = {
			items = {
				{ item = "water", amount = 10 },
				{ item = "sandwich", amount = 10 },
				{ item = "bandage", amount = 5 },
				{ item = "cellphone", amount = 1 }
			}
		}
	},
	{
		id = "item_kit_armas",
		category = "items",
		type = "item",
		name = "Kit Armas (Licenciado)",
		description = "Pistola, munição e colete — requer porte de arma.",
		price = 100,
		currency = "gems",
		badge = "Armas",
		data = {
			requireGroup = { "Policia", "Civil", "Federal" },
			items = {
				{ item = "WEAPON_PISTOL", amount = 1 },
				{ item = "WEAPON_PISTOL_AMMO", amount = 60 },
				{ item = "vest", amount = 1 }
			}
		}
	},
	{
		id = "item_dinheiro_50k",
		category = "items",
		type = "item",
		name = "Pacote R$50.000",
		description = "Crédito direto na conta bancária do personagem.",
		price = 50,
		currency = "gems",
		data = { bank = 50000 }
	},
	{
		id = "item_dinheiro_250k",
		category = "items",
		type = "item",
		name = "Pacote R$250.000",
		description = "Grande quantia depositada diretamente no banco.",
		price = 200,
		currency = "gems",
		badge = "Economia",
		data = { bank = 250000 }
	},

	-------------------------------------------------------------------------------------------------------------------------------------
	-- PACKS (COMBOS)
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "pack_starter",
		category = "packs",
		type = "pack",
		name = "Pack Iniciante",
		description = "VIP Bronze + Sultan RS + Kit Inicial — tudo para começar com estilo.",
		price = 280,
		currency = "gems",
		badge = "-20%",
		originalPrice = 350,
		data = {
			products = { "vip_bronze", "veh_sultanrs", "item_kit_inicial" }
		}
	},
	{
		id = "pack_premium",
		category = "packs",
		type = "pack",
		name = "Pack Premium",
		description = "VIP Ouro + T20 + Apartamento VIP — pacote completo premium.",
		price = 1100,
		currency = "gems",
		badge = "-25%",
		originalPrice = 1470,
		data = {
			products = { "vip_ouro", "veh_t20", "house_apto_vip" }
		}
	},
	{
		id = "pack_elite",
		category = "packs",
		type = "pack",
		name = "Pack Elite",
		description = "VIP Diamante + Mansão + Volatus — o pacote definitivo.",
		price = 2800,
		currency = "gems",
		badge = "Melhor Valor",
		originalPrice = 3900,
		data = {
			products = { "vip_diamante", "house_mansao_hills", "veh_volatus" }
		}
	},

	-------------------------------------------------------------------------------------------------------------------------------------
	-- EXTRAS
	-------------------------------------------------------------------------------------------------------------------------------------
	{
		id = "extra_slot_personagem",
		category = "extras",
		type = "extra",
		name = "+1 Slot de Personagem",
		description = "Desbloqueie um slot adicional para criar outro personagem.",
		price = 200,
		currency = "gems",
		data = { extra = "character_slot", amount = 1 }
	},
	{
		id = "extra_slot_garagem",
		category = "extras",
		type = "extra",
		name = "+2 Slots de Garagem",
		description = "Adicione 2 vagas permanentes à sua garagem.",
		price = 100,
		currency = "gems",
		data = { extra = "garage_slot", amount = 2 }
	},
	{
		id = "extra_placa_custom",
		category = "extras",
		type = "extra",
		name = "Placa Personalizada",
		description = "Escolha uma placa customizada para um veículo (até 8 caracteres).",
		price = 75,
		currency = "gems",
		data = { extra = "custom_plate" }
	},
	{
		id = "extra_nome_personagem",
		category = "extras",
		type = "extra",
		name = "Troca de Nome",
		description = "Altere o nome do seu personagem uma vez.",
		price = 150,
		currency = "gems",
		data = { extra = "name_change" }
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTOS / LANG
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	OpenShop = "Pressione ~y~E~w~ para abrir a ~y~Loja VIP~w~",
	ShopOpened = "Loja VIP aberta.",
	ShopClosed = "Loja fechada.",
	NoPassport = "Você precisa estar logado com um personagem para acessar a loja.",
	InsufficientFunds = "Saldo insuficiente para esta compra.",
	PurchaseSuccess = "Compra realizada com sucesso!",
	PurchaseFailed = "Não foi possível concluir a compra.",
	ProductNotFound = "Produto não encontrado.",
	AlreadyOwned = "Você já possui este item.",
	Cooldown = "Aguarde antes de realizar outra compra.",
	VehicleExists = "Você já possui este veículo na garagem.",
	HouseExists = "Esta propriedade já possui dono.",
	NoPermission = "Você não tem permissão para comprar este item.",
	InvalidPlate = "Placa inválida ou já em uso.",
	PackPartialFail = "Alguns itens do pack não puderam ser entregues. Contate a administração."
}
