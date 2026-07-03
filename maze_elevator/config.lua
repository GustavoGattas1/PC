-----------------------------------------------------------------------------------------------------------------------------------------
-- MAZE ELEVATOR — CONFIGURAÇÃO GERAL
-- Todas as opções do resource devem ser editadas aqui. Não use valores fixos nos scripts.
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERAÇÃO E MARKER
-----------------------------------------------------------------------------------------------------------------------------------------
Config.InteractionKey = 38
Config.InteractionKeyLabel = "E"

Config.InteractionDistance = 1.5
Config.MarkerDistance = 10.0
Config.DrawMarker = true

Config.MarkerType = 1
Config.MarkerScale = vec3(0.55, 0.55, 0.35)
Config.MarkerColor = { r = 0, g = 150, b = 255, a = 160 }
Config.MarkerBob = false
Config.MarkerRotate = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTO 3D
-----------------------------------------------------------------------------------------------------------------------------------------
Config.DrawText3D = true
Config.Text3D = "[~b~E~w~] Utilizar Elevador"

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Teleport = {
	FadeOutDuration = 800,
	FadeInDuration = 800,
	TravelDelay = 2500,
	CollisionTimeout = 5000,
	CollisionStep = 50,
	FreezeDuringTravel = true,
	CameraShake = true,
	CameraShakeIntensity = 0.08,
	ScreenBlur = true
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-----------------------------------------------------------------------------------------------------------------------------------------
Config.NUI = {
	Title = "Elevador",
	Subtitle = "Selecione o andar",
	Logo = "images/maze_bank.svg",
	BlurStrength = 6,
	AnimationMs = 280
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- SONS (NUI)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Sounds = {
	Button = "sounds/button.mp3",
	Elevator = "sounds/elevator.mp3",
	Ding = "sounds/ding.mp3",
	Volume = 0.45
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY (padrão Creative Uncharted)
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Notify = {
	Title = "Elevador",
	Success = "verde",
	Error = "vermelho",
	Warning = "amarelo",
	Info = "azul"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO DE TESTE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.TestCommand = "elevador"
Config.TestCommandEnabled = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO — FUNÇÃO USADA NO SERVER
-- Creative/vRP: HasPermission. Algumas bases usam HasGroup como fallback.
-----------------------------------------------------------------------------------------------------------------------------------------
Config.UseHasGroupFallback = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- ELEVADORES
-- Adicione quantos elevadores quiser. Cada andar possui destino (Coords)
-- e ponto de interação (Panel). Se Panel for omitido, usa o XYZ de Coords.
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Elevators = {

	MazeBank = {
		Label = "Maze Bank",
		Permission = false,

		Floors = {
			{
				Label = "Lobby",
				Description = "Recepção Principal",
				Icon = "fa-building",
				Permission = false,
				Coords = vec4(-71.28, -801.02, 44.23, 158.75),
				Panel = vec3(-70.92, -800.68, 44.23)
			},
			{
				Label = "Escritórios",
				Description = "Andares administrativos",
				Icon = "fa-briefcase",
				Permission = false,
				Coords = vec4(-75.48, -826.99, 243.39, 252.29),
				Panel = vec3(-75.12, -826.65, 243.39)
			},
			{
				Label = "Presidência",
				Description = "Acesso restrito",
				Icon = "fa-user-tie",
				Permission = "Admin",
				Coords = vec4(-75.57, -827.06, 295.73, 68.04),
				Panel = vec3(-75.21, -826.72, 295.73)
			},
			{
				Label = "Heliponto",
				Description = "Cobertura",
				Icon = "fa-helicopter",
				Permission = false,
				Coords = vec4(-75.32, -819.52, 326.18, 252.29),
				Panel = vec3(-74.96, -819.18, 326.18)
			}
		}
	},

	Hospital = {
		Label = "Hospital Central",
		Permission = "Hospital",

		Floors = {
			{
				Label = "Térreo",
				Description = "Recepção e emergência",
				Icon = "fa-hospital",
				Permission = false,
				Coords = vec4(298.24, -584.61, 43.26, 72.0),
				Panel = vec3(298.60, -584.25, 43.26)
			},
			{
				Label = "Heliponto",
				Description = "Resgate aéreo",
				Icon = "fa-helicopter",
				Permission = "Hospital",
				Coords = vec4(338.70, -583.92, 74.16, 252.0),
				Panel = vec3(338.34, -583.56, 74.16)
			}
		}
	}

}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGENS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Lang = {
	NoPermission = "Você não tem permissão para usar este elevador.",
	NoFloorPermission = "Você não tem permissão para acessar este andar.",
	InvalidElevator = "Elevador inválido.",
	InvalidFloor = "Andar inválido.",
	SameFloor = "Você já está neste andar.",
	Traveling = "Elevador em movimento...",
	Arrived = "Você chegou ao destino.",
	TooFar = "Você está longe demais do elevador.",
	TestOpened = "Painel de teste aberto: %s"
}
