# PlayVault

Interface web moderna de **launcher / biblioteca multiplataforma**, inspirada no conceito de hubs tipo GPBOX — com visual contemporâneo e catálogo de **Xbox (clássico → Series X|S)**, **PlayStation (PS1 → PS5)** e clássicos retrô.

## O que é

- Landing com hero full-bleed, plataformas e recursos
- Biblioteca com filtros, busca, ordenação e ficha do jogo
- Ações simuladas: Jogar / Salvar / Carregar

## O que **não** é

- Não inclui ROMs, ISOs, dumps ou downloads
- Não emula de fato Xbox Series / PS5 (isso exige stack oficial/licenciada)
- Títulos no catálogo são **metadados de demonstração de UI**

## Como abrir

```bash
# na pasta playvault
python3 -m http.server 5173
# abra http://localhost:5173
```

Ou abra `index.html` direto no navegador.

## Estrutura

```
playvault/
  index.html
  css/styles.css
  js/games.js      # catálogo (metadados)
  js/app.js        # navegação, filtros, modal
  README.md
```
