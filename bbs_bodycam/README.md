# bbs_bodycam — vRP / Creative Uncharted

Script **bbs_bodycam** (Big Bang Studios) integrado à base vRP / Creative Uncharted.

A lógica original do BBS (streaming LiveKit, estações, DUI) foi **mantida intacta**. Apenas os arquivos abertos pelo autor foram adaptados:

- `Framework/Server.lua` — detecção vRP, inventário, job, nome e crachá
- `Framework/Client.lua` — notify `creative` opcional
- `config.lua` — grupos policiais da base + bloco `Config.VRP`

## Instalação

1. `ensure ox_lib`
2. `ensure vrp`
3. `ensure bbs_bodycam`
4. Cadastre os itens em `@vrp/config/Item.lua` usando `items_reference.lua`
5. Ajuste `Config.Stations` em `config.lua` para as coordenadas do seu departamento

## Itens

| Item | Função |
|------|--------|
| `goverment_bodycam` | Stream para estações associadas ao job |
| `commercial_bodycam` | Stream comercial para IP de estação |

## Configuração vRP

```lua
Config.VRP.Groups          -- grupos que contam como job policial
Config.VRP.SupervisorGroups
Config.VRP.RequireService  -- exige vRP.HasService
Config.VRP.IgnoreGrades    -- ignora grades QB-style no DoJobCheck
```

## Notify

Padrão: `ox_lib`. Para notify Creative da base, altere em `config.lua`:

```lua
Config.Notify = "creative"
```

## Dependências

- `ox_lib`
- `vrp`
- `/assetpacks` (requerido pelo manifest original BBS)
