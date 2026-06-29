# IML / Evidências — Creative Uncharted (Completo)

Sistema **completo** de Instituto Médico Legal e perícia forense para FiveM com base **Creative Uncharted**.

## Funcionalidades Completas

### Cena do Crime (automático)
| Evidência | Como é gerada |
|-----------|---------------|
| Sangue | Jogador recebe dano |
| Poça de sangue | Jogador morre |
| Cápsula de projétil | Disparo de arma de fogo |
| Pente abandonado | Chance ao disparar |
| Projétil impactado | Raycast do tiro |
| Marca de tiro em veículo | Projétil atinge veículo |
| Impressão digital | Entrar em veículo sem luvas |
| Resíduo de pólvora (GSR) | Disparo (fica no jogador) |

### Rastreamento de Morte
- **Arma que matou** (nome + hash + serial balístico)
- **Calibre/munição** (9mm, 5.56, .50, 12ga, etc.)
- **Autor do crime** (passaporte do killer)
- **Região do impacto** (cabeça, tórax, etc.)
- **Distância do disparo** em metros
- **Headshot** detectado
- **Hora do óbito**

### Perícia no Cadáver
| Tecla | Ação |
|-------|------|
| `E` | Perícia preliminar (arma, munição, killer, causa) |
| `G` | Coletar sangue com swab |
| `H` | Acondicionar corpo no saco mortuário |

### Comandos
| Comando | Descrição |
|---------|-----------|
| `/periciar` | Perícia preliminar do cadáver próximo |
| `/coletarsangue` | Coletar swab de sangue do cadáver |
| `/coletarcorpo` | Acondicionar corpo |
| `/coletargsr` | Coletar resíduo de pólvora de suspeito |

### Laboratório / IML
- Análise de **DNA** (sangue, poça, swab de cadáver)
- **Perícia balística** (cápsula, pente, projétil) com serial e dono da arma
- **Impressão digital** com match na base
- **GSR** com identificação do suspeito e arma
- **Autópsia completa** com arma, calibre, killer e laudo médico-legal

### Registro Balístico
- Cada arma de fogo recebe **serial único** por jogador
- Cápsulas/pentes/projéteis carregam o serial
- Laboratório identifica **dono registrado** da arma

---

## Instalação

1. Execute `sql/install.sql` no MariaDB
2. Copie para `resources/[scripts]/iml-evidencias`
3. Adicione os 7 itens do `items_reference.lua`
4. Ajuste `config.lua` (grupos + coordenadas do IML)
5. `ensure iml-evidencias` no server.cfg

## Itens necessários

| Item | Função |
|------|--------|
| `kitpericia` | Coletar evidências e periciar corpo |
| `saco-evidencia` | Armazenar evidência coletada |
| `luvas-latex` | Evitar digitais |
| `swab-sangue` | Coletar sangue do cadáver |
| `kit-gsr` | Coletar pólvora das mãos |
| `saco-cadaver` | Transportar corpo |
| `laudo-pericial` | Laudo gerado pela perícia |

## Fluxo completo de homicídio

1. Criminoso atira → gera cápsulas, projéteis, GSR (serial da arma registrado)
2. Vítima morre → sistema registra arma, calibre, killer, distância, headshot
3. Poça de sangue aparece na cena
4. Polícia/IML chega → pericia corpo (`E`), coleta sangue (`G`), coleta cápsulas no chão
5. Corpo é acondicionado (`H` ou `/coletarcorpo`) e entregue no IML
6. Laboratório analisa evidências → laudos com DNA, balística e dono da arma
7. Legista faz autópsia → laudo médico-legal com arma do crime e suspeito
8. `/coletargsr` no suspeito confirma disparo recente

---

## Estrutura

```
iml-evidencias/
├── client/
│   ├── main.lua       # Evidências na cena, IML, NUI
│   ├── death.lua      # Morte, tiros, balística, sangue
│   └── forensics.lua  # Perícia de cadáver, comandos
├── server/
│   ├── database.lua   # SQL prepares
│   ├── weapons.lua    # Registro balístico
│   ├── death.lua      # Mortes, laudos, análises
│   └── main.lua       # Eventos principais
└── web/               # Interface NUI
```

## Configuração

- `Config.Groups` — grupos da sua base
- `Config.Locations` — coordenadas do IML
- `Config.Weapons` / `Config.AmmoTypes` — armas e calibres
- `Config.Chances` — probabilidade de cada evidência
