# IML Evidências — Sistema Forense Avançado

Sistema completo de perícia e evidências para **Creative Uncharted** (FiveM).

## Funcionalidades

- Cápsulas, projéteis impactados e marcas em veículos (props 3D por calibre)
- Teste GSR (kit + scanner portátil)
- Sangue, poças de sangue e swab em cadáveres
- Rastros de pneu (derrapagem/burnout)
- DNA e impressões digitais
- Overlay de investigação (`/cena` ou tecla **M**)
- Minigames de coleta (swab, saco, molde)
- Marcadores numerados e fita policial
- Tablet forense com arquivo de casos
- Painel 3D do corpo com região do tiro
- Estado térmico do corpo (Quente / Morno / Frio / Gelado)
- Laudos imprimíveis

## Instalação

1. Copie `iml-evidencias/` para `resources/`
2. Execute `sql/install.sql` no banco
3. Cadastre os itens em `@vrp/config/Item.lua` — veja `items_reference.lua`
4. Adicione ao `server.cfg`: `ensure iml-evidencias`

## Itens obrigatórios

| Item | Uso |
|------|-----|
| `kitpericia` / `tablet-forense` | Tablet forense |
| `luvas-latex` | Evitar digitais |
| `saco-cadaver` | Acondicionar corpo |
| `saco-evidencia` | Receber evidências coletadas |
| `swab-sangue` | Coletar sangue do cadáver |
| `kit-gsr` | Coleta GSR em suspeito |
| `scanner-gsr` | Scanner portátil GSR |
| `laudo-pericial` | Ver laudos |
| `marcador-evidencia` | Marcador numerado |
| `fita-policial` | Isolar perímetro |

## Permissões

- Grupo: **Civil** (em serviço se `Config.RequireService = true`)
- Lanterna (`WEAPON_FLASHLIGHT`) obrigatória para ver/coletar evidências

## Comandos

| Comando | Ação |
|---------|------|
| `/cena` ou **M** | Overlay de cena do crime |
| `/luvas` | Equipar/remover luvas |
| `/tabletforense` | Abrir tablet |
| `/periciar` | Periciar cadáver próximo |
| `/coletarcorpo` | Coletar corpo (precisa saco) |
| `/coletarsangue` | Swab no cadáver |
| `/coletargsr` | Coletar GSR do suspeito |

## Perícia em local de tiro

Ao periciar um cadáver com arma de fogo, abre o **painel 3D** mostrando onde o projétil atingiu (braço, perna, tórax, etc.) e o **estado térmico** do corpo em vez da hora do óbito.

## Exports (Item.lua)

```lua
exports["iml-evidencias"]:UseLuvas(source)
exports["iml-evidencias"]:UseBodyBag(source)
exports["iml-evidencias"]:UseTablet(source)
exports["iml-evidencias"]:UseGsrScanner(source)
exports["iml-evidencias"]:UseLaudo(source)
```
