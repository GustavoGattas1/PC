# Sistema Wall — Creative Uncharted

Sistema completo de **Wall (ESP)** para staff em servidores FiveM com base **vRP Creative Uncharted**.

Exibe informações de jogadores em tempo real acima da cabeça — passport, nome, vida, colete, arma, grupo, distância e mais. Inclui wall de veículos, esqueleto, linhas de rastreamento e blips no mapa.

## Instalação

1. Copie a pasta `sistema-wall` para o diretório `resources` do servidor
2. Adicione ao `server.cfg`:

```
ensure vrp
ensure sistema-wall
```

3. Ajuste os grupos permitidos em `config.lua` conforme sua cidade

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/wall` | Alterna o wall ligado/desligado |
| `/esp` | Alias do wall |
| `/wallconfig` | Mostra configurações atuais |
| `/wallconfig [opção]` | Alterna uma opção de exibição |
| `/wallinfo [source]` | Informações detalhadas de um jogador |

## Tecla padrão

**DELETE** — alterna o wall (configurável em `Config.Key`)

## Opções de exibição

Use `/wallconfig [opção]` para alternar:

| Opção | Descrição |
|-------|-----------|
| `passport` | ID do personagem |
| `name` | Nome completo |
| `health` | Vida |
| `armor` | Colete |
| `weapon` | Arma equipada |
| `vehicle` | Wall de veículos sem motorista |
| `line` | Linha do staff até o alvo |
| `skeleton` | Esqueleto do ped |
| `walls` | Visão através de paredes |
| `self` | Mostrar informações sobre si mesmo |
| `blip` | Blips no mapa |
| `speed` | Velocidade do veículo |
| `distance` | Distância em metros |
| `group` | Grupo do jogador |
| `status` | Status (coma, arena) |
| `serverid` | Source do jogador |
| `npcs` | Incluir NPCs |

## Permissões

Por padrão, os grupos com acesso são:

- `Admin`
- `Moderador`
- `Suporte`

Configure em `Config.Groups`. Se `Config.RequireService = true`, exige que o staff esteja em serviço (`vRP.HasService`).

## Configuração

Principais opções em `config.lua`:

```lua
Config.DrawDistance = 250.0      -- distância máxima de renderização
Config.UpdateInterval = 500      -- intervalo de sync com o servidor (ms)
Config.Groups = { "Admin", "Moderador", "Suporte" }
```

## Exports

**Server:**

```lua
exports["sistema-wall"]:IsWallActive(source)
exports["sistema-wall"]:HasWallPermission(passport)
```

**Client:**

```lua
exports["sistema-wall"]:IsWallActive()
exports["sistema-wall"]:GetWallDisplay()
```

## Dependências

- `vrp` (Creative Uncharted)
- Tabela `characters` no banco de dados

## Estrutura

```
sistema-wall/
├── fxmanifest.lua
├── config.lua
├── shared/utils.lua
├── client/
│   ├── main.lua       — toggle, sync, configurações
│   ├── render.lua     — renderização de jogadores
│   └── vehicles.lua   — wall de veículos
└── server/
    ├── bridge.lua     — resolução de nomes via banco
    └── main.lua       — permissões e sync
```
