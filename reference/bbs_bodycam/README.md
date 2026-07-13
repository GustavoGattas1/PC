# bbs_bodycam → vRP / Creative Uncharted

Ponte de integração do **bbs_bodycam** (Big Bang Studios) para servidores com base **vRP / Creative Uncharted**, seguindo o mesmo padrão de `iml-evidencias`, `loja-vip` e `sistema-wall`.

## Status

Os arquivos originais do `bbs_bodycam` **ainda não foram enviados** ao repositório. Cole a pasta completa em `reference/bbs_bodycam/original/` (veja `COLE_OS_ARQUIVOS_AQUI.md`).

## O que esta ponte faz

| Função | Descrição |
|--------|-----------|
| `GetPassport` | Resolve passport vRP a partir do `source` |
| `GetPlayerName` | Nome completo via banco (`characters`) |
| `HasJob` | Verifica grupos policiais configurados |
| `IsOnDuty` | `vRP.HasService` quando `RequireService = true` |
| `HasItem` / `TakeItem` / `GiveItem` | Inventário vRP |
| `RegisterUsableItem` | Item utilizável no inventário Creative |
| `Notify` | `TriggerClientEvent("Notify", ...)` padrão da base |

## Configuração

Edite `bridge/vrp/config.lua`:

- **Config.Groups** — grupos com acesso à bodycam
- **Config.SupervisorGroups** — quem monitora estações / gravações
- **Config.Items** — nomes dos itens (`bodycam`, `dashcam`, etc.)
- **Config.Database** — colunas da tabela `characters`

## Instalação (quando tiver o script BBS)

1. Copie `bbs_bodycam` para `resources/`
2. Copie `bridge/vrp/*` para a pasta de framework do BBS (ou configure `Config.Framework = "vrp"`)
3. Ajuste `config.lua` do BBS para usar a ponte vRP
4. `ensure ox_lib` antes do `bbs_bodycam`
5. `ensure bbs_bodycam` após `vrp` no `server.cfg`

## Alternativa nativa no repositório

Se preferir um bodycam **100% vRP** (sem dependência do BBS/LiveKit), use o resource `camera-corporal` na branch `cursor/camera-corporal-policial-98e4` (PR #14).
