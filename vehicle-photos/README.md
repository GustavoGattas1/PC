# Vehicle Photos v2.0

Gera fotos PNG 16:9 (800x450) de veículos para usar em NUI.

## Instalação

1. Instale o **screenshot-basic**: https://github.com/citizenfx/screenshot-basic
2. Copie `vehicle-photos` para `resources/`
3. No `server.cfg`:

```
ensure screenshot-basic
ensure vehicle-photos
```

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/fotosveiculos` | Fotografa todos os veículos da lista |
| `/fotoveiculo adder` | Fotografa um veículo |
| `/fotosveiculosstop` | Para a captura |

Somente **Admin** (configurável em `Config.Groups`).

## Onde ficam as fotos

```
resources/vehicle-photos/output/vehicles/NOME.png
```

## Configuração de tempo

Edite `Config.Timing` no `config.lua` (valores em milissegundos):

```lua
Config.Timing = {
    RenderFrames = 300,      -- frames para carregar textura (~5s)
    SettleAfterLoad = 5000,  -- espera após carregar
    BeforePhoto = 5000,      -- espera antes da foto
    AfterPhoto = 5000,       -- espera depois da foto
    BetweenVehicles = 2000   -- pausa entre veículos
}
```

## Lista de veículos

- `Config.Vehicles` no config.lua
- `vehicles.txt` (um spawn por linha)
- `loja-vip` (se estiver rodando)
