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
4. Adicione ao `server.cfg`: `ensure iml-evidencias` (depois do `vrp`)

## Itens obrigatórios

| Item | Uso |
|------|-----|
| `kitpericia` / `tabletforense` | Tablet forense |
| `luvaslatex` | Evitar digitais |
| `sacocadaver` | Acondicionar corpo |
| `sacoevidencia` | Receber evidências coletadas |
| `swabsangue` | Coletar sangue do cadáver |
| `kitgsr` | Coleta GSR em suspeito |
| `scannergsr` | Scanner portátil GSR |
| `laudopericial` | Ver laudos |
| `marcadorevidencia` | Marcador numerado |
| `fitapolicial` | Isolar perímetro |

> **Importante:** os nomes dos itens **não usam hífen** (ex.: `fitapolicial`, não `fita-policial`).

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
| Sangue / DNA | Arraste o **cotonete** e limpe as manchas na tela |
| Cápsulas / projéteis | Arraste a **cápsula** para dentro do **saco de evidência** |
| Pneu | Arraste o molde até o rastro |
| Outros | Arraste a pinça até a evidência |

## Abrir / fechar painel

- **Tablet**: item `kitpericia` ou `tabletforense` (via export no Item.lua)
- **Fita**: item `fitapolicial`
- **Marcador**: item `marcadorevidencia`
- **Fechar**: botão X ou tecla **ESC**
- Comandos: `/tabletforense`, `/cena` (overlay)

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

Padrão recomendado — um export para todos os itens usáveis:

```lua
Execute = function(source)
	exports["iml-evidencias"]:UseItem(source, "fitapolicial")
end
```

Exports individuais (opcional):

```lua
exports["iml-evidencias"]:UseLuvas(source)
exports["iml-evidencias"]:UseBodyBag(source)
exports["iml-evidencias"]:UseTablet(source)
exports["iml-evidencias"]:UseGsrScanner(source)
exports["iml-evidencias"]:UseLaudo(source)
```
