# Como instalar o +1 RAIO no Roblox Studio

## Caminho A — 1 colar (mais fácil)

1. Abra o Roblox Studio.
2. New → **Baseplate**.
3. Menu **View** → marque **Command Bar**.
4. Abra `INSTALAR_NO_COMMAND_BAR.lua` neste repositório.
5. `Ctrl+A` e `Ctrl+C`.
6. Clique na Command Bar (faixa preta embaixo do Studio).
7. `Ctrl+V` e **Enter**.
8. Espere a mensagem no Output: `+1 RAIO KEYBOARD ESCAPE instalado com sucesso!`
9. Aperte **Play**.

O mapa neon, o teclado, as fases, o dragão e a HUD já estão lá.

Se der erro de "Source is not a valid member" ou a barra não aceitar o texto, use o Caminho B.

## Caminho B — colar 4 scripts no Explorer

Crie a pasta e os scripts **com esses nomes e tipos**. Cole o conteúdo de `COLE_NO_STUDIO/`.

| Arquivo | Tipo no Studio | Onde colocar |
|---------|----------------|--------------|
| `1_Config.lua` | ModuleScript chamado **Config** | ReplicatedStorage → pasta **RaioGame** |
| `2_World.lua` | ModuleScript chamado **World** | ReplicatedStorage → pasta **RaioGame** |
| `3_RaioServer.lua` | Script chamado **RaioServer** | ServerScriptService |
| `4_RaioClient.lua` | LocalScript chamado **RaioClient** | StarterPlayer → StarterPlayerScripts |

Passo a passo:

1. Em ReplicatedStorage, clique direito → Insert Object → **Folder**. Nome: `RaioGame`.
2. Dentro de `RaioGame`, Insert Object → **ModuleScript**. Nome: `Config`. Abra, apague o `return {}` padrão, cole `1_Config.lua`.
3. Outro ModuleScript chamado `World`. Cole `2_World.lua`.
4. Em ServerScriptService, Insert Object → **Script**. Nome: `RaioServer`. Cole `3_RaioServer.lua`.
5. Em StarterPlayer → StarterPlayerScripts, Insert Object → **LocalScript**. Nome: `RaioClient`. Cole `4_RaioClient.lua`.
6. Play.

Não cole ModuleScript como Script comum. O `require` quebra.

## Depois de instalar

- **Game Settings → Security → Enable Studio Access to API Services** se quiser save.
- Teste um código: botão CÓDIGOS → `RAIO`.
- Ande no teclado. O número de VELOCIDADE no canto tem que subir.
- Toque no pad roxo da loja ou no botão LOJA.

## Problemas comuns

**HUD não aparece**  
O LocalScript precisa estar em StarterPlayerScripts (não em ServerScriptService).

**Mapa vazio**  
O Script do servidor precisa estar em ServerScriptService, e os ModuleScripts `Config` + `World` precisam existir em `ReplicatedStorage.RaioGame`.

**Velocidade não sobe**  
Você tem que pisar **em cima** das teclas neon, não no chão escuro.

**Save não grava**  
Publique o jogo e ligue API Services. Sem publish o DataStore recusa, mas o resto funciona.

**Personagem voa / não pula o vão**  
Farm na esteira até o nível da fase (o letreiro de cada fase mostra o LV mínimo).
