-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLE PHOTOS — CONFIGURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

Config.Debug = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO (apenas staff)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Groups = { "Admin" }

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Command = "fotosveiculos"
Config.CommandSingle = "fotoveiculo"
Config.CommandStop = "fotosveiculosstop"

-----------------------------------------------------------------------------------------------------------------------------------------
-- IMAGEM DE SAÍDA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Image = {
	Width = 800,
	Height = 450,
	Format = "png",
	MaxSizeKB = 300,
	Quality = 0.88
}

-- Resolução alternativa (descomente no client se preferir 512x288):
-- Config.Image.Width = 512
-- Config.Image.Height = 288

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTÚDIO FOTOGRÁFICO
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Studio = {
	-- Estúdio no céu (sem chão/aeroporto visível — só fundo limpo)
	Coords = vec4(-1267.0, -3013.0, 1500.0, 0.0),

	Time = { Hour = 12, Minute = 0, Second = 0 },
	Weather = "CLEAR",
	Wind = 0.0,

	-- Fundo escuro/cinza via filtro visual (sem props físicos)
	Timecycle = "NG_blackout",
	TimecycleStrength = 0.42
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CÂMERA — ÂNGULO 3/4 DE FRENTE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Camera = {
	-- Offset relativo ao veículo (frente-esquerda elevada = 3/4)
	OffsetX = -3.2,
	OffsetY = 3.2,
	OffsetZ = 0.65,

	-- Ponto de mira (centro do veículo)
	AimOffsetZ = 0.35,

	-- FOV base — ajustado automaticamente pelo tamanho do modelo
	Fov = 38.0,

	-- Veículo ocupa ~70% da imagem
	FillRatio = 0.70,

	-- Heading do veículo na foto
	VehicleHeading = 45.0
}

-- Ajuste extra para motos (classe 8)
Config.Motorcycle = {
	OffsetX = -2.4,
	OffsetY = 2.4,
	OffsetZ = 0.55,
	AimOffsetZ = 0.45,
	Fov = 42.0,
	FillRatio = 0.72
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACA — minimizar visibilidade
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Plate = {
	Text = "PHOTO",
	Hide = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAPTURA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Capture = {
	-- Tempo com o carro visível ANTES de tirar a foto (ms)
	DelayBeforeShot = 5000,
	-- Tempo com o carro visível DEPOIS da foto, antes de sumir (ms)
	DelayAfterShot = 2000,
	-- Tempo escondendo HUD antes/durante a captura (ms)
	DelayHudHide = 3000,
	-- Pausa entre veículos no /fotosveiculos (ms)
	DelayBetweenVehicles = 3000,
	SkipExisting = true,
	ScreenshotResource = "screenshot-basic",
	ScreenshotTimeout = 15000,
	-- Transferência lenta para base64 grande (evita erro de rede)
	LatentBps = 500000,
	-- Tamanho de cada chunk se latent não estiver disponível
	ChunkSize = 48000
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ORIGEM DA LISTA DE VEÍCULOS
-- O script tenta carregar de todas as fontes habilitadas e remove duplicatas.
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Sources = {
	-- Lista manual abaixo (Config.Vehicles)
	Manual = true,

	-- Tabela global List do @vrp/config/Vehicle.lua (descomente no fxmanifest)
	VRPVehicleList = false,

	-- Produtos type=vehicle da loja-vip (se resource estiver rodando)
	LojaVip = true,

	-- Arquivo vehicles.txt (um spawn por linha)
	VehiclesFile = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTA MANUAL (adicione spawn names aqui)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Vehicles = {
	"akuma",
	"bati",
	"double",
	"pcj",
	"sanchez",
	"shotaro",
	"adder",
	"zentorno",
	"t20",
	"nero"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PASTA DE SAÍDA (relativa ao resource no servidor)
-- Caminho final: resources/vehicle-photos/output/vehicles/NOME.png
-----------------------------------------------------------------------------------------------------------------------------------------
Config.OutputFolder = "output/vehicles"

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	Title = "Fotos Veículos",
	Success = "verde",
	Error = "vermelho",
	Warning = "amarelo",
	Info = "azul"
}

Config.Lang = {
	NoPermission = "Sem permissão.",
	AlreadyRunning = "Captura já em andamento.",
	NotRunning = "Nenhuma captura em andamento.",
	Started = "Iniciando captura de %s veículo(s)...",
	Progress = "Foto %s/%s — %s",
	Saved = "Salvo: %s.png",
	Skipped = "Pulado (já existe): %s",
	Failed = "Falhou: %s",
	Done = "Concluído! %s fotos salvas em output/vehicles/",
	NoVehicles = "Nenhum veículo encontrado na lista.",
	NoScreenshot = "Instale o resource screenshot-basic para capturar imagens.",
	SaveError = "Erro ao salvar %s: %s",
	Stopped = "Captura interrompida.",
	SingleDone = "Foto salva: %s.png"
}
