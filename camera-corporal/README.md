# Câmera Corporal Policial

Sistema profissional de **bodycam** para servidores FiveM com base **vRP / Creative Uncharted**. Gravação com overlay estilo Axon Body 3, **monitoramento ao vivo**, reprodução de gravações, detecção automática de eventos e central forense completa.

## Funcionalidades

| Recurso | Descrição |
|---------|-----------|
| **Central Bodycam** | Painel unificado com abas Ao Vivo e Gravações (`/bodycamcentral`) |
| **Ao vivo** | Supervisores assistem a POV da bodycam de oficiais em tempo real |
| **Reprodução** | Player in-game que percorre a rota gravada com timeline de eventos |
| Overlay HUD | REC, timestamp, oficial, crachá, unidade, GPS, velocidade e bateria |
| Gravação inteligente | Logs de arma, disparos, perseguição, sirene, dano e snapshots |
| Marcações | Tecla `G` ou `/bodycammarcar` para marcar incidentes |
| Painel forense | Linha do tempo, marcações, exportação de relatório |
| Supervisores | Comandantes monitoram ao vivo e revisam todas as gravações |

## Instalação

1. Copie a pasta `camera-corporal` para `resources/`
2. Execute o SQL em `sql/install.sql` no banco MariaDB/MySQL
3. Adicione ao `server.cfg`:

```cfg
ensure camera-corporal
```

4. (Opcional) Cadastre o item `cameracorporal` no inventário da base

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/bodycam` | Liga/desliga a câmera corporal |
| `/bodycamcentral` | Abre a central (ao vivo + gravações) |
| `/bodycamreview` | Alias da central de gravações |
| `/bodycammarcar` | Marca um incidente na gravação ativa |
| `F9` | Atalho para alternar bodycam |
| `G` | Atalho para marcar incidente |
| `ESC` | Sair do modo ao vivo ou reprodução |

## Configuração

Edite `config.lua` para ajustar:

- **Config.Groups** — grupos policiais com acesso
- **Config.SupervisorGroups** — quem pode ver ao vivo e revisar gravações de outros
- **Config.LiveView** — telemetria, FOV da câmera, notificar oficial monitorado
- **Config.Playback** — velocidade e suavidade da reprodução
- **Config.Item** — item obrigatório (`nil` para desativar)
- **Config.Recording** — duração máxima, bateria, snapshots
- **Config.Events** — quais eventos detectar automaticamente
- **Config.ReviewLocations** — pontos físicos para abrir o painel

## Exports

### Client

```lua
exports["camera-corporal"]:IsBodycamActive()
exports["camera-corporal"]:IsRecording()
exports["camera-corporal"]:GetSessionId()
```

### Server

```lua
exports["camera-corporal"]:IsRecording(source)
exports["camera-corporal"]:GetActiveSession(source)
exports["camera-corporal"]:ForceStopRecording(source)
```

## Integração com outros scripts

Outros resources podem registrar eventos na gravação ativa:

```lua
-- Client-side
if exports["camera-corporal"]:IsRecording() then
    TriggerServerEvent("camera-corporal:LogEvent",
        exports["camera-corporal"]:GetSessionId(),
        "arrest",
        "Prisão efetuada — suspeito detido",
        { coords = { x = 0, y = 0, z = 0 }, street = "Rua Exemplo", elapsed = 0 }
    )
end
```

## Dependências

- [vrp](https://github.com) — framework base Creative Uncharted

## Licença

Uso exclusivo Creative Uncharted.
