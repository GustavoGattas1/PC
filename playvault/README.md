# PlayVault — launcher caseiro

Hub local com **30+ consoles**, catálogo curado (~500 títulos) e **importação automática** das suas pastas de ROMs/ISOs.

## Uso pessoal

- Não inclui ROMs, ISOs nem BIOS
- Coloque apenas dumps de jogos que **você possui**
- PS4 / PS5 / Xbox One / Series: sem emulação PC madura (console / Game Pass / PS Plus)

## Subir

```bash
cd playvault
cp launcher/config.example.json launcher/config.json   # se ainda não existir
# edite caminhos dos emuladores no config.json se precisar
python3 launcher/server.py
# http://127.0.0.1:5173
```

## Onde colocar os jogos

```
playvault/roms/
  nes/  snes/  n64/  gamecube/  wii/  wiiu/  switch/
  gb/  gbc/  gba/  nds/  3ds/
  mastersystem/  genesis/  saturn/  dreamcast/
  ps1/  ps2/  ps3/  psp/  psvita/
  xbox/  xbox360/
  arcade/  neogeo/  pcengine/  atari2600/  wonderswan/  msx/
```

Qualquer arquivo com extensão válida vira jogo na biblioteca (badge **ROM**).

## Emuladores sugeridos

| Plataforma | Emulador |
|---|---|
| Retrô (NES→PS1, Sega, Arcade…) | RetroArch + cores |
| PS2 | PCSX2 |
| PS3 | RPCS3 |
| GameCube / Wii | Dolphin |
| Xbox 360 | Xenia |
| Xbox clássico | Xemu |
| 3DS | Citra (forks) |
| Wii U | Cemu |
| Switch | Ryujinx (firmware do seu console) |
| PS Vita | Vita3K |

Caminhos em `launcher/config.json`.

## API local

- `GET /api/status` — emuladores detectados + contagem de ROMs
- `GET /api/library` — arquivos no disco
- `POST /api/launch` — `{ "platform", "file" }` (opcional `dryRun: true`)

## Gerar catálogo de novo

```bash
python3 scripts/generate_catalog.py
```
