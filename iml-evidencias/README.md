# IML / Evidências — Creative Uncharted

Sistema de perícia forense alinhado à base **Creative Uncharted** (referência: `helicrash`).

## Permissões

- Grupo: **`Civil`**
- Precisa estar **em serviço** (`vRP.HasService`) — `Config.RequireService = true`
- Evidências visíveis **somente para Civil em serviço**
- **Lanterna** (`WEAPON_FLASHLIGHT`) obrigatória para ver e coletar

## Padrões da base (confirmados pelo helicrash)

| Item | Padrão da sua base |
|------|-------------------|
| Utils | `@vrp/lib/Utils.lua` |
| Notify | `TriggerClientEvent("Notify", source, Titulo, Msg, Cor, Tempo)` |
| Passport | `vRP.Passport(source)` |
| Grupo | `vRP.HasGroup(Passport, "Civil")` |
| Serviço | `vRP.HasService(Passport, "Civil")` |
| Nome | `vRP.FullName(Passport)` |
| Disconnect | `AddEventHandler("Disconnect", function(Passport, source)` |
| Itens | Cadastrar em `@vrp/config/Item.lua` |
| State bags | `LocalPlayer.state.Death` |

## Instalação

1. Execute `sql/install.sql` no MariaDB
2. Copie `iml-evidencias` para `resources/[scripts]/`
3. Cadastre os 7 itens em `@vrp/config/Item.lua` (veja `items_reference.lua`)
4. Ajuste `Config.Locations` com coords do IML da cidade
5. No `server.cfg`:
```cfg
ensure vrp
ensure iml-evidencias
```

## Itens obrigatórios

| Item | Função |
|------|--------|
| `kitpericia` | Coletar evidências / periciar |
| `saco-evidencia` | Armazenar evidência |
| `swab-sangue` | Sangue do cadáver |
| `kit-gsr` | Resíduo de pólvora |
| `saco-cadaver` | Transportar corpo |
| `laudo-pericial` | Laudo gerado |
| `luvas-latex` | Evitar digitais (opcional) |

## Comandos

| Comando | Ação |
|---------|------|
| `/periciar` | Perícia preliminar do cadáver |
| `/coletarsangue` | Swab de sangue |
| `/coletarcorpo` | Acondicionar corpo |
| `/coletargsr` | Coletar GSR do suspeito |

## Teclas no cadáver (com lanterna)

- `E` — Periciar
- `G` — Coletar sangue
- `H` — Acondicionar corpo

## O que ainda precisa confirmar na sua base

1. Nome exato do grupo Civil (`Civil` ou outro?)
2. Se a lanterna é `WEAPON_FLASHLIGHT` ou item diferente
3. Coordenadas do IML em `config.lua`
