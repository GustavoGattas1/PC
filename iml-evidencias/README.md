# IML Evidências — Sistema Forense Avançado

Sistema completo de perícia e evidências para **Creative Uncharted** (FiveM).

## Funcionalidades

- Cápsulas, projéteis impactados e marcas em veículos (props 3D por calibre)
- Sangue, poças de sangue e swab em cadáveres
- Rastros de pneu (derrapagem/burnout)
- DNA e impressões digitais
- Overlay de investigação (`/cena` ou tecla **M**)
- Minigames de coleta (swab, saco, molde, DNA)
- Marcadores numerados
- **Target (olhinho)** para periciar cadáver e coletar sangue
- Tablet forense com arquivo de casos
- Painel 3D do corpo com região do tiro
- Estado térmico do corpo (Quente / Morno / Frio / Gelado)
- Laudos imprimíveis

## Instalação

1. Copie `iml-evidencias/` para `resources/`
2. Execute `sql/install.sql` no banco
3. Cadastre os itens em `@vrp/config/Item.lua` — veja `items_reference.lua`
4. Adicione ao `server.cfg`: `ensure iml-evidencias` (depois do `vrp` e do `target`)

## Itens obrigatórios

| Item | Uso |
|------|-----|
| `kitpericia` / `tabletforense` | Tablet forense |
| `luvaslatex` | Evitar digitais |
| `sacoevidencia` | Receber evidências coletadas |
| `swabsangue` | Coletar sangue do cadáver |
| `laudopericial` | Ver laudos |
| `marcadorevidencia` | Marcador numerado |

> **Importante:** os nomes dos itens **não usam hífen** (ex.: `marcadorevidencia`, não `marcador-evidencia`).

## Permissões

- Grupo: **Civil** (em serviço se `Config.RequireService = true`)
- Lanterna (`WEAPON_FLASHLIGHT`) obrigatória para ver/coletar evidências

## Coletar evidência no chão

1. Grupo **Civil** em serviço
2. **Lanterna** (`WEAPON_FLASHLIGHT`) na mão
3. Item **kitpericia** no inventário
4. Aproxime-se da evidência e pressione **E**
5. Barra de progresso → **minigame interativo** → evidência vai para o saco

### Minigames de coleta
| Tipo | Minigame |
|------|----------|
| Sangue | Arraste o **cotonete** e limpe as manchas na tela |
| DNA | Arraste o **swab molecular** e colete amostras na **hélice** |
| Cápsulas / projéteis | Arraste a **cápsula** para dentro do **saco de evidência** |
| Pneu | Arraste o molde até o rastro |
| Outros | Arraste a pinça até a evidência |

## Perícia em cadáver (target)

Aponte o **olhinho (target)** no cadáver com a lanterna equipada:

- **Periciar Cadáver** — exame preliminar / painel balístico
- **Coletar Sangue (Swab)** — amostra do cadáver (requer `swabsangue`)

O target registra opções em **peds** e **players** (cadáveres mortos são detectados como ped).

## Abrir / fechar painel

- **Tablet**: item `kitpericia` ou `tabletforense` (via export no Item.lua)
- **Marcador**: item `marcadorevidencia`
- **Fechar**: botão X ou tecla **ESC**
- Comandos: `/tabletforense`, `/cena` (overlay)

| Comando | Ação |
|---------|------|
| `/cena` ou **M** | Overlay de cena do crime |
| `/luvas` | Equipar/remover luvas |
| `/tabletforense` | Abrir tablet |
| `/periciar` | Periciar cadáver próximo |
| `/coletarsangue` | Swab no cadáver |

## Perícia em local de tiro

Ao periciar um cadáver com arma de fogo, abre o **painel 3D** mostrando onde o projétil atingiu (braço, perna, tórax, etc.) e o **estado térmico** do corpo em vez da hora do óbito.

## Exports (Item.lua)

Padrão recomendado — um export para todos os itens usáveis:

```lua
Execute = function(source, Passport, Amount, Slot, Full, Item, Split)
	exports["iml-evidencias"]:UseItem(source, Item or Full or "kitpericia")
end
```

Exports individuais (opcional):

```lua
exports["iml-evidencias"]:UseLuvas(source)
exports["iml-evidencias"]:UseTablet(source)
exports["iml-evidencias"]:UseLaudo(source)
exports["iml-evidencias"]:UseMarcador(source)
```
