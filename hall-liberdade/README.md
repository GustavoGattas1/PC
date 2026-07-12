# Hall Liberdade

Sistema completo de controle de palco para FiveM — telões, holofotes, fumaça, faíscas e reprodução de mídia (YouTube/Twitch).

## Instalação

1. Coloque `hall-liberdade` e `hall-liberdade-stream` na pasta `resources` do servidor
2. Adicione ao `server.cfg`:

```
ensure hall-liberdade-stream
ensure hall-liberdade
```

## Uso

| Comando | Descrição |
|---------|-----------|
| `/hall` | Abre o painel de controle (dentro da área configurada) |
| `hall-liberdade-screen` | Controle de tela (tecla configurável) |
| `hall-liberdade-smoke` | Ativar fumaça manualmente |
| `hall-liberdade-sparklers` | Ativar faíscas manualmente |

## Configuração

Edite `config.lua` — a entrada padrão é `liberdade` com coordenadas em `-1431, -1542`.

Para adicionar novos locais, copie o bloco `['liberdade']` em `config.entries` e ajuste:
- `area.center` e `area.polygons` — zona de detecção
- `monitors`, `screens`, `spotlights`, `smokers`, `sparklers`, `speakers` — props e efeitos

## Exports (server)

```lua
exports['hall-liberdade']:Play('liberdade')
exports['hall-liberdade']:Pause('liberdade')
exports['hall-liberdade']:Stop('liberdade')
exports['hall-liberdade']:AddToQueue('liberdade', url, thumb, thumbTitle, title, icon, duration)
exports['hall-liberdade']:GetPlayer('liberdade')
exports['hall-liberdade']:GetQueue('liberdade')
```

## Dependências

- `hall-liberdade-stream` (assets 3D incluídos)
- OneSync
- Asset packs (GTA Online)

## NUI

Interface redesenhada com tema escuro/dourado, textos em PT-BR, fila lateral, painel de efeitos e player otimizado (sem jQuery).
