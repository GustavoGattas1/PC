# IML / Evidências — Creative Uncharted

Sistema completo de **Instituto Médico Legal (IML)** e **perícia forense** para servidores FiveM com base **Creative Uncharted** (vRP Creative Network).

Inspirado em sistemas de evidências de servidores brasileiros com coleta na cena do crime, análise laboratorial, laudos periciais e autópsia.

## Funcionalidades

### Cena do crime (automático)
- **Sangue** — gerado quando jogadores recebem dano
- **Cápsulas de projétil** — geradas ao atirar
- **Pentes abandonados** — chance ao disparar
- **Impressões digitais** — ao entrar em veículos sem luvas
- Evidências expiram após tempo configurável
- Sincronização entre todos os jogadores

### Coleta forense
- Polícia e IML coletam evidências com **Kit de Perícia**
- Evidências lacradas em **Saco de Evidência**
- Coleta de corpos com **Saco Mortuário** (`/coletarcorpo`)
- **Luvas de látex** evitam deixar digitais

### Laboratório IML
- Análise de DNA (sangue)
- Comparação de impressões digitais
- Perícia balística (cápsulas, pentes, projéteis)
- Geração de **Laudo Pericial** oficial (NUI)

### Autópsia
- Entrega de corpos no IML
- Exame médico-legal com laudo completo
- Registro de causa da morte e DNA da vítima

### Interface NUI
- Painel moderno para laboratório, autópsia e laudos
- Design escuro compatível com Creative

---

## Instalação

### 1. Banco de dados

Execute o arquivo SQL no seu MariaDB:

```bash
# Via HeidiSQL ou terminal
source iml-evidencias/sql/install.sql
```

### 2. Copiar o resource

Coloque a pasta `iml-evidencias` em:

```
resources/[scripts]/iml-evidencias
```

### 3. Adicionar itens

Abra `items_reference.lua` e adicione os itens no arquivo de inventário da sua base (geralmente `vrp/config/Item.lua`):

| Item | Função |
|------|--------|
| `kitpericia` | Coletar evidências na cena |
| `saco-evidencia` | Armazenar evidência coletada |
| `luvas-latex` | Evitar impressões digitais |
| `saco-cadaver` | Coletar corpos |
| `laudo-pericial` | Documento de laudo gerado |

### 4. Configurar grupos

Edite `config.lua` e ajuste os grupos conforme sua base:

```lua
Config.Groups = {
    IML = { "IML", "Paramedico" },
    Police = { "Policia", "PC", "PRF", "BOPE" },
    AllForensic = { "IML", "Policia", "PC", "PRF", "BOPE" }
}
```

### 5. Configurar locais

Ajuste as coordenadas do IML em `config.lua` → `Config.Locations`.  
Coordenadas padrão apontam para o hospital de Los Santos (região do IML).

### 6. server.cfg

```cfg
ensure vrp
ensure iml-evidencias
```

---

## Como usar in-game

| Ação | Como fazer |
|------|------------|
| Coletar evidência | Aproxime-se do marcador na cena e pressione **E** (precisa do kit) |
| Analisar evidência | Vá ao **Laboratório Forense** e pressione **E** |
| Coletar corpo | Use `/coletarcorpo` perto de um jogador morto |
| Entregar corpo | Vá ao ponto de **Entrega de Corpos** no IML |
| Autópsia | Vá à **Sala de Autópsia** com corpo entregue |
| Equipar luvas | Use o item `luvas-latex` no inventário |

---

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/coletarcorpo` | Coleta corpo de jogador morto próximo (requer saco mortuário) |

---

## Configuração avançada

### Chances de evidência (`config.lua`)

```lua
Config.Chances = {
    Blood = 85,        -- % ao receber dano
    Fingerprint = 70,  -- % ao entrar em veículo
    Casing = 95,       -- % ao atirar
    Magazine = 40      -- % ao atirar (pente)
}
```

### Expiração

```lua
Config.EvidenceExpire = 3600  -- segundos (1 hora)
```

### Debug

```lua
Config.Debug = true  -- logs no console do servidor
```

---

## Estrutura de arquivos

```
iml-evidencias/
├── fxmanifest.lua
├── config.lua
├── items_reference.lua
├── client/
│   └── main.lua
├── server/
│   ├── database.lua
│   └── main.lua
├── shared/
│   └── utils.lua
├── sql/
│   └── install.sql
└── web/
    ├── index.html
    ├── css/style.css
    └── js/app.js
```

---

## Dependências

- **vrp** (Creative Uncharted)
- **oxmysql** (via vRP)
- MariaDB

---

## Personalização

- **Blip no mapa:** `Config.Blips`
- **Marcadores:** `Config.Marker`
- **Armas no laudo balístico:** `Config.Weapons`
- **Mensagens:** `Config.Lang`

---

## Notas

- Biometria (DNA e digital) é registrada automaticamente ao conectar o personagem.
- Laudos ficam salvos no banco (`iml_reports`) e no `playerdata` do jogador.
- Ajuste os nomes dos grupos se sua base usar nomenclatura diferente (ex: `Policia` vs `Police`).

---

## Suporte

Revise `config.lua` antes de abrir ticket. A maioria dos problemas é grupo/permissão ou item não cadastrado no inventário.
