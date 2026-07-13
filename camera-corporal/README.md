# Câmera Corporal Policial

Sistema profissional de **bodycam** para servidores FiveM com base **vRP / Creative Uncharted**. Gravação com overlay estilo Axon Body 3, detecção automática de eventos, marcações de incidente e painel forense de revisão.

## Funcionalidades

| Recurso | Descrição |
|---------|-----------|
| Overlay HUD | REC piscando, timestamp, oficial, crachá, unidade, GPS, velocidade e bateria |
| Gravação inteligente | Logs de arma sacada, disparos, perseguição, sirene, dano e snapshots periódicos |
| Marcações | Tecla `G` ou `/bodycammarcar` para marcar incidentes na gravação |
| Bateria simulada | Drenagem realista com alerta de bateria baixa e desligamento automático |
| Prop físico | Câmera corporal visível no peito do uniforme |
| Painel de revisão | NUI moderna com linha do tempo, marcações e exportação de relatório |
| Supervisores | Comandantes podem revisar gravações de todos os oficiais |
| Auto start/stop | Liga ao entrar em serviço e desliga ao sair (configurável) |

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
| `/bodycammarcar` | Marca um incidente na gravação ativa |
| `/bodycamreview` | Abre o painel de revisão de gravações |
| `F9` | Atalho para alternar bodycam |
| `G` | Atalho para marcar incidente |

## Configuração

Edite `config.lua` para ajustar:

- **Config.Groups** — grupos policiais com acesso
- **Config.SupervisorGroups** — quem pode revisar gravações de outros
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
