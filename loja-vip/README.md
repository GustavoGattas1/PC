# Loja VIP — Premium Store

Sistema completo de loja VIP para servidores **Creative Uncharted (vRP)** com NUI moderna, venda de planos VIP, veículos, casas, itens, packs e extras.

## Funcionalidades

- **Comando `/loja`** — abre a loja de qualquer lugar da cidade
- **Aliases:** `/vip`, `/store`, `/donate`
- **Ponto físico** com blip e marker (configurável em `config.lua`)
- **NUI moderna** — sidebar, busca, grid de produtos, modal de compra, histórico
- **Categorias:** VIP, Veículos, Casas, Itens, Packs, Extras
- **Moedas:** diamantes (gems) e banco in-game
- **Histórico de compras** no banco de dados
- **Packs com desconto** — combos de múltiplos produtos

## Instalação

1. Copie a pasta `loja-vip` para `resources/[scripts]/`
2. Adicione no `server.cfg`:
   ```
   ensure loja-vip
   ```
3. As tabelas SQL são criadas automaticamente no primeiro start
4. Ajuste `Config.Locations` com as coordenadas da sua cidade
5. Ajuste `Config.Products` com os veículos, casas e grupos VIP da sua base

## Configuração

### Coordenadas da loja

```lua
Config.Locations = {
    {
        Coords = vec3(-1082.22, -247.52, 37.76),
        Heading = 210.0,
        Label = "Loja VIP — Premium Store"
    }
}
```

### Adicionar produto

```lua
{
    id = "meu_produto",
    category = "vehicles",
    type = "vehicle",
    name = "Nome do Veículo",
    description = "Descrição...",
    price = 200,
    currency = "gems",
    data = { model = "adder", work = false }
}
```

### Tipos de produto

| type | Descrição | data |
|------|-----------|------|
| `vip` | Plano VIP | `group`, `level`, `days`, `salary`, `garageSlots` |
| `vehicle` | Veículo na garagem | `model`, `work` |
| `house` | Propriedade | `property`, `interior` |
| `item` | Itens / dinheiro | `items[]`, `bank` |
| `pack` | Combo | `products[]` (IDs) |
| `extra` | Upgrade | `extra`, `amount` |

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/loja` | Abre a loja VIP |
| `/vip` | Alias da loja |
| `/lojareload` | Admin — recarrega catálogo |

## Dependências

- `vrp` (Creative Uncharted)
- Tabelas `vehicles` e `propertys` da base (para veículos e casas)

## Integração com a base

O resource **não usa** `vRP.Identity`, `vRP.UserGemstone` nem `vRP.GetBank` — essas funções quebram em algumas bases (ex: Base Cliente). Em vez disso, consulta direto as tabelas `characters` e `accounts`.

Ajuste os nomes das colunas em `Config.Database` se sua base for diferente:

```lua
Config.Database = {
    CharacterName = "name",
    CharacterName2 = "name2",
    CharacterBank = "bank",
    AccountGems = "gemstone"
}
```

Funções vRP ainda usadas (seguras):
- `vRP.Passport`, `vRP.HasGroup`, `vRP.SetPermission`
- `vRP.GenerateItem`, `vRP.GeneratePlate`
- `vRP.Query` / `vRP.Prepare`

## Estrutura

```
loja-vip/
├── fxmanifest.lua
├── config.lua
├── shared/utils.lua
├── client/main.lua
├── server/main.lua
├── server/database.lua
├── sql/install.sql
└── web/
    ├── index.html
    ├── css/style.css
    └── js/app.js
```
