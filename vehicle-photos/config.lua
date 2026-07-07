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

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTÚDIO FOTOGRÁFICO
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Studio = {
	Coords = vec4(-1267.0, -3013.0, 1500.0, 0.0),
	Time = { Hour = 12, Minute = 0, Second = 0 },
	Weather = "CLEAR",
	Wind = 0.0,
	Timecycle = "NG_blackout",
	TimecycleStrength = 0.42
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CÂMERA — ÂNGULO 3/4 DE FRENTE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Camera = {
	OffsetX = -3.2,
	OffsetY = 3.2,
	OffsetZ = 0.65,
	AimOffsetZ = 0.35,
	Fov = 38.0,
	FillRatio = 0.70,
	VehicleHeading = 45.0
}

Config.Motorcycle = {
	OffsetX = -2.4,
	OffsetY = 2.4,
	OffsetZ = 0.55,
	AimOffsetZ = 0.45,
	Fov = 42.0,
	FillRatio = 0.72
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Plate = {
	Text = "PHOTO",
	Hide = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAPTURA
-- Tempos em MILISSEGUNDOS (1000 = 1 segundo)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Capture = {
	-- Tempo extra DEPOIS do carregamento completo, antes da foto
	DelayBeforeShot = 5000,
	-- Tempo com o carro visível DEPOIS da foto, antes de trocar
	DelayAfterShot = 8000,
	-- Pausa entre um veículo e outro no lote
	DelayBetweenVehicles = 3000,
	SkipExisting = true,
	ScreenshotResource = "screenshot-basic",
	ScreenshotTimeout = 30000,
	LatentBps = 500000,
	ChunkSize = 48000,

	-- Carregamento completo do veículo antes de fotografar
	Load = {
		ModelTimeout = 30000,       -- tempo máximo para baixar o modelo (30s)
		CollisionTimeout = 20000,   -- tempo máximo para colisão/streaming (20s)
		SceneTimeout = 15000,       -- tempo máximo da cena HD (15s)
		MinRenderFrames = 300,      -- frames renderizados (~5s a 60fps)
		SettleDelay = 5000,         -- espera extra após streaming (5s)
		StreamingRadius = 50.0,
		UseSceneLoad = true
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ORIGEM DA LISTA DE VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Sources = {
	Manual = true,
	VRPVehicleList = false,
	LojaVip = true,
	VehiclesFile = true
}

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
-- PASTA DE SAÍDA
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
	Loading = "Carregando %s...",
	LoadFailed = "Falha ao carregar %s completamente.",
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
