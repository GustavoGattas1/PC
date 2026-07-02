# Sistema Wall — Creative Uncharted

Sistema de **Wall (ESP)** para staff em servidores FiveM com base **vRP Creative Uncharted**.

Exibe acima da cabeça dos jogadores: ID da cidade, nome Steam, vida, colete, arma, distância e linhas de rastreamento.

## Instalação

1. Copie a pasta `sistema-wall` para o diretório `resources` do servidor
2. Adicione ao `server.cfg`:

```
ensure vrp
ensure sistema-wall
```

3. Ajuste os grupos permitidos em `config.lua` conforme sua cidade

## Comando

| Comando | Descrição |
|---------|-----------|
| `/wall` | Alterna o wall ligado/desligado |

**Tecla padrão:** `DELETE` (configurável em `Config.Key`)

## O que aparece

```
#43 Glimys1
100% | 0% | Desarmado | 15.3m
```

- **Linha 1:** ID da cidade + nome Steam
- **Linha 2:** vida | colete | arma | distância
- **Linhas ESP:** do staff até a cabeça do jogador

## Configuração

Edite `config.lua` para ajustar o que é exibido:

```lua
Config.Display = {
    Passport = true,
    SteamName = true,
    Health = true,
    Armor = true,
    Weapon = true,
    Distance = true,
    Line = true
}

Config.TextScale = 0.22      -- tamanho do texto
Config.HeadOffset = 0.35     -- altura acima da cabeça
Config.DrawDistance = 250.0  -- distância máxima
```

## Permissões

Grupos com acesso padrão: `Admin`, `Moderador`, `Suporte`

## Exports

```lua
exports["sistema-wall"]:IsWallActive(source)       -- server
exports["sistema-wall"]:HasWallPermission(passport) -- server
exports["sistema-wall"]:IsWallActive()              -- client
```
