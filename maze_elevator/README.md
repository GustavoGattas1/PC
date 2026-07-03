# Maze Elevator

Sistema completo de elevadores para **FiveM** com base **Creative/vRP**. Interface NUI moderna, validação server-side, teleporte seguro com fade, sons e permissões por grupo.

## Instalação

1. Copie a pasta `maze_elevator` para `resources/`
2. Adicione ao `server.cfg`:

```
ensure vrp
ensure maze_elevator
```

3. Reinicie o servidor ou execute:

```
refresh
ensure maze_elevator
```

Pronto. Não é necessário alterar código para usar os elevadores padrão.

---

## Como usar in-game

- Aproxime-se do **marker azul** do elevador
- Pressione **E** para abrir o painel
- Selecione o andar desejado
- Aguarde a animação de viagem (fade + som)
- Você será teleportado com colisão carregada

### Comando de teste

```
/elevador
```

Abre o painel do **Maze Bank** sem precisar estar no local (apenas para testes).

---

## Export

### Client

```lua
exports["maze_elevator"]:OpenElevator("MazeBank", 1)
```

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `elevatorId` | string | ID do elevador no config |
| `floorIndex` | number | Andar atual (painel usado) |

### Server

```lua
exports["maze_elevator"]:OpenElevatorForPlayer(source, "MazeBank", 1)
```

---

## Eventos

| Evento | Direção | Descrição |
|--------|---------|-----------|
| `maze_elevator:Open` | Client → Server | Solicita abertura do painel |
| `maze_elevator:OpenUI` | Server → Client | Envia dados seguros para NUI |
| `maze_elevator:Teleport` | Client → Server | Solicita viagem para um andar |
| `maze_elevator:DoTeleport` | Server → Client | Executa teleporte validado |
| `maze_elevator:Close` | Server/Client | Fecha a interface |

---

## Criar um novo elevador

Edite `config.lua` e adicione uma nova entrada em `Config.Elevators`:

```lua
MeuPredio = {
    Label = "Meu Prédio",
    Permission = false, -- ou "Admin", "Policia", "Hospital"

    Floors = {
        {
            Label = "Térreo",
            Description = "Entrada principal",
            Icon = "fa-door-open",
            Permission = false,
            Coords = vec4(x, y, z, heading),
            Panel = vec3(x, y, z)
        }
    }
}
```

| Campo | Descrição |
|-------|-----------|
| `Label` | Nome exibido na NUI |
| `Permission` | Grupo vRP ou `false` |
| `Coords` | Destino do teleporte (`vec4` com heading) |
| `Panel` | Onde o jogador pressiona **E** |
| `Icon` | Classe Font Awesome (`fa-building`, etc.) |

Se `Panel` for omitido, usa o XYZ de `Coords`.

---

## Criar novos andares

Basta adicionar mais itens em `Floors`:

```lua
{
    Label = "Cobertura",
    Description = "Área VIP",
    Icon = "fa-star",
    Permission = "Admin",
    Coords = vec4(-75.0, -820.0, 326.0, 250.0),
    Panel = vec3(-74.7, -819.7, 326.0)
}
```

---

## Permissões

Toda verificação é feita no **servidor** com:

```lua
vRP.HasPermission(Passport, Permission)
```

Fallback opcional para `vRP.HasGroup` via:

```lua
Config.UseHasGroupFallback = true
```

Permissões podem ser definidas em:

- **Elevador inteiro** → `Permission` na raiz do elevador
- **Andar específico** → `Permission` no andar

---

## Personalizar cores e marker

```lua
Config.MarkerColor = { r = 0, g = 150, b = 255, a = 160 }
Config.MarkerType = 1
Config.MarkerScale = vec3(0.55, 0.55, 0.35)
```

Cores da NUI: edite as variáveis CSS em `html/style.css`:

```css
:root {
    --accent: #3d8bff;
    --panel: rgba(14, 20, 34, 0.92);
}
```

---

## Trocar sons

Substitua os arquivos em `html/sounds/`:

| Arquivo | Uso |
|---------|-----|
| `button.mp3` | Clique em andar |
| `elevator.mp3` | Durante a viagem |
| `ding.mp3` | Chegada |

Ajuste volume em:

```lua
Config.Sounds = {
    Button = "sounds/button.mp3",
    Elevator = "sounds/elevator.mp3",
    Ding = "sounds/ding.mp3",
    Volume = 0.45
}
```

---

## Adicionar imagens

Coloque arquivos em `html/images/` e referencie no config:

```lua
Config.NUI = {
    Logo = "images/meu_logo.svg"
}
```

---

## Teleporte seguro

O client garante:

- Fade out / fade in
- Congelamento durante viagem
- `RequestCollisionAtCoord`
- Verificação de chão (`GetGroundZFor_3dCoord`)
- Vibração de câmera opcional
- Blur de tela

O servidor **nunca** aceita coordenadas enviadas pelo client — sempre usa `config.lua`.

---

## Performance

- Loop idle: **1000ms** longe dos elevadores
- **0ms** apenas quando próximo ao marker
- Indexação de painéis feita uma vez na inicialização
- Distância calculada ao quadrado (sem `sqrt` desnecessário)

---

## Estrutura

```
maze_elevator/
├── fxmanifest.lua
├── config.lua
├── client.lua
├── server.lua
├── README.md
└── html/
    ├── index.html
    ├── style.css
    ├── app.js
    ├── sounds/
    │   ├── button.mp3
    │   ├── elevator.mp3
    │   └── ding.mp3
    └── images/
        └── maze_bank.svg
```

---

## Dependências

- `vrp` (Creative Uncharted)
- OneSync compatível

Sem ox_lib, qb-menu, NativeUI ou RageUI.
