# Vehicle Photos — Estúdio Automático de Fotos

Gera fotos PNG **16:9** de todos os veículos da base para usar em NUI (loja, garagem, catálogo).

## Resultado

| Spec | Valor |
|------|-------|
| Formato | `.png` |
| Tamanho | **800×450** px (configurável) |
| Peso | **< 300 KB** por imagem |
| Ângulo | **3/4 de frente** |
| Iluminação | Meio-dia |
| Fundo | Escuro/cinza |
| HUD | Oculto |
| Placa | Minimizada |
| Veículo | ~70% da imagem |

## Instalação

### 1. Dependências

```
ensure vrp
ensure screenshot-basic
ensure vehicle-photos
```

Baixe **screenshot-basic**: https://github.com/citizenfx/screenshot-basic

### 2. server.cfg

```
ensure screenshot-basic
ensure vehicle-photos
```

## Onde ficam as fotos

As imagens são salvas em:

```
resources/vehicle-photos/output/vehicles/NOMEDOSPAWN.png
```

Exemplo:
```
resources/vehicle-photos/output/vehicles/bati.png
resources/vehicle-photos/output/vehicles/adder.png
```

Copie essa pasta para o seu computador após a captura.

## Como usar

| Comando | Descrição |
|---------|-----------|
| `/fotosveiculos` | Fotografa **todos** os veículos da lista |
| `/fotoveiculo bati` | Foto de **um** veículo |
| `/fotosveiculosstop` | Interrompe a captura em lote |

Somente **Admin** (configurável em `Config.Groups`).

## Lista de veículos

O script coleta spawn names de 4 fontes (ativáveis em `Config.Sources`):

1. **`Config.Vehicles`** — lista manual no `config.lua`
2. **`vehicles.txt`** — um spawn por linha
3. **`loja-vip`** — lê modelos do config da loja (se estiver rodando)
4. **`@vrp/config/Vehicle.lua`** — tabela `List` do vRP (opcional)

### Carregar TODOS os veículos do vRP

No `fxmanifest.lua`, adicione **antes** do config:

```lua
shared_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Vehicle.lua",
    "config.lua",
    "shared/*.lua"
}
```

E no `config.lua`:

```lua
Config.Sources.VRPVehicleList = true
```

### Adicionar veículos manualmente

Edite `vehicles.txt`:

```
akuma
bati
adder
zentorno
```

## Configuração de imagem

```lua
Config.Image = {
    Width = 800,       -- ou 512
    Height = 450,      -- ou 288
    MaxSizeKB = 300,
    Quality = 0.88
}
```

## Configuração da câmera (3/4)

```lua
Config.Camera = {
    OffsetX = -3.2,      -- frente-esquerda
    OffsetY = 3.2,
    OffsetZ = 0.65,
    Fov = 38.0,
    FillRatio = 0.70,    -- 70% da imagem
    VehicleHeading = 45.0
}

Config.Motorcycle = {
    -- ajustes específicos para motos
    OffsetX = -2.4,
    OffsetY = 2.4,
    Fov = 42.0,
    FillRatio = 0.72
}
```

## Usar na NUI

Após gerar, copie as imagens para o resource da loja:

```
loja-vip/web/images/vehicles/adder.png
```

E referencie no HTML/JS:

```javascript
const img = `images/vehicles/${model}.png`;
```

## Dicas

- Rode em horário de **poucos jogadores** (teleporta para estúdio isolado)
- Fotos já existentes são **puladas** (`Config.Capture.SkipExisting = true`)
- Para refazer tudo, apague a pasta `output/vehicles/`
- Se a foto ficar escura/clara, ajuste `Config.Studio.Timecycle`

## Estrutura

```
vehicle-photos/
├── config.lua
├── client.lua
├── server.lua
├── vehicles.txt
├── output/vehicles/    ← fotos salvas aqui
└── html/               ← processamento 16:9 + compressão
```
