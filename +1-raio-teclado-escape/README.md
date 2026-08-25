# +1 RAIO Keyboard Escape

Jogo Roblox completo, pronto pra colar no Studio. Mesmo vício do **+1 Speed Keyboard Escape**, com tema de **jardim encantado** (dia, grama, madeira, pedra, teclado pastel) — sem neon.

Feito pra criança e streamer: número gigante na tela, combo, transformação, lucky keys, esteira AFK, rebirth e anúncios.

## O que o jogo tem

- Teclado QWERTY pastel (cada passo aumenta a velocidade de verdade)
- 8 fases espaçadas (prado, dunas, vila, canyon, floresta, neve, caverna, castelo)
- Esteiras AFK (madeira, tijolo, mármore, real)
- Loja: trilhas, auras, pets e esteiras
- Combos, lucky keys, transformações
- Rebirth com multiplicador permanente
- Evento Festa Dourada a cada 3 minutos
- HUD clara, pet seguindo, save automático
- Códigos prontos

Não precisa construir mapa. O script gera o mundo inteiro.

---

## Instalação em 1 colar (recomendado)

1. Abra o **Roblox Studio** → lugar novo **Baseplate**.
2. Menu **View** → ative **Command Bar** (barra embaixo).
3. Abra o arquivo `INSTALAR_NO_COMMAND_BAR.lua`, copie **tudo**.
4. Cole na Command Bar e pressione **Enter**.
5. O mapa aparece na viewport. Aperte **Play** (F5).

Pronto. Personagem spawna no hub. **Pise nas teclas coloridas** — o número de VELOCIDADE no canto sobe sozinho.

Se você já tinha a versão neon, cole o instalador de novo: ele apaga o mapa antigo.

Se a Command Bar recusar um texto muito grande, use a instalação manual abaixo.

---

## Instalação manual (4 scripts)

No Explorer do Studio, crie exatamente isto:

```
ReplicatedStorage
  └ RaioGame (Folder)
       ├ Config      (ModuleScript)   ← cole src/ReplicatedStorage/RaioGame/Config.lua
       └ World       (ModuleScript)   ← cole src/ReplicatedStorage/RaioGame/World.lua
ServerScriptService
  └ RaioServer      (Script)         ← cole src/ServerScriptService/RaioServer.server.lua
StarterPlayer
  └ StarterPlayerScripts
       └ RaioClient (LocalScript)    ← cole src/StarterPlayer/StarterPlayerScripts/RaioClient.client.lua
```

**Atenção:** `Config` e `World` têm que ser **ModuleScript**. `RaioServer` é **Script**. `RaioClient` é **LocalScript**.

Depois: **Play**. O servidor monta o mapa sozinho se ele ainda não existir.

Há cópias com cabeçalho pronto em `COLE_NO_STUDIO/`.

---

## Como jogar

1. Corra no teclado do hub. Cada tecla dá velocidade.
2. Quando estiver rápido, siga o caminho neon (+Z) e pule os vãos.
3. Toque no **pad dourado** no fim da fase para ganhar **WINS**.
4. Gaste Wins na **loja roxa** (trilhas, auras, pets, esteiras).
5. Fique parado numa **esteira** pra farmar AFK.
6. No **portal amarelo**, dê Rebirth assim que o nível chegar. Zera a speed, multiplica o ganho pra sempre.
7. Códigos no pad verde ou no botão **CÓDIGOS**.

### Códigos inclusos

| Código | Recompensa |
|--------|------------|
| `RAIO` | +2500 speed e +5 wins |
| `TEMPESTADE` | +8000 speed e +15 wins |
| `DRAGAO` | +15000 speed e +25 wins |
| `STREAMER` | +30000 speed e +50 wins |
| `JARDIM` | +40 wins |
| `COMBO100` | +10000 speed |

Troque os códigos em `Config.lua` → `Config.Codes`.

---

## Save (DataStore)

O jogo salva sozinho (speed, wins, rebirth, itens, códigos usados).

1. Publique o lugar (File → Publish to Roblox).
2. Home → Game Settings → Security → **Enable Studio Access to API Services**.

Sem isso, o jogo **roda normal**, só não guarda progresso entre sessões.

---

## Onde customizar

Tudo em `src/ReplicatedStorage/RaioGame/Config.lua`:

- nomes das fases, wins, gaps, nível mínimo
- preço e multiplicador de trilha / aura / pet / esteira
- intervalo da tempestade
- transformações
- códigos

Depois de editar, rode de novo `python3 tools/pack_installer.py` se você usa o instalador de 1 clique.

---

## Dicas pra prender criança e streamer

- Deixe o evento de tempestade rolando (já vem a cada 3 min).
- Troque os códigos toda semana e jogue no vídeo.
- Primeiro pet já vem grátis (Filhote Faísca).
- Combos x10 / x25 / x50 / x100 gritam no servidor inteiro.
- Lucky key brilha ouro e paga x12.

---

## Estrutura

```
+1-raio-teclado-escape/
  INSTALAR_NO_COMMAND_BAR.lua    ← cole isto no Studio
  README.md
  COMO_INSTALAR.md
  COLE_NO_STUDIO/                ← os 4 scripts, um por arquivo
  src/                           ← fonte organizado (Rojo-friendly)
  tools/pack_installer.py
```
