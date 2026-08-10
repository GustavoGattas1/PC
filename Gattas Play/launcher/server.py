#!/usr/bin/env python3
"""
Gattas Play local launcher
- Serve a UI
- Escaneia roms/<plataforma>/
- Lança emuladores configurados em config.json

Uso:
  cd "Gattas Play"
  cp launcher/config.example.json launcher/config.json
  # edite caminhos dos emuladores se preciso
  python3 launcher/server.py
  # abra http://127.0.0.1:5173
"""
from __future__ import annotations

import json
import mimetypes
import os
import re
import subprocess
import sys
import threading
import urllib.parse
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "launcher" / "config.json"
EXAMPLE_PATH = ROOT / "launcher" / "config.example.json"

PLATFORM_FOLDERS = {
    "atari2600": "atari2600",
    "nes": "nes",
    "snes": "snes",
    "n64": "n64",
    "gamecube": "gamecube",
    "wii": "wii",
    "wiiu": "wiiu",
    "switch": "switch",
    "gb": "gb",
    "gbc": "gbc",
    "gba": "gba",
    "nds": "nds",
    "3ds": "3ds",
    "mastersystem": "mastersystem",
    "genesis": "genesis",
    "saturn": "saturn",
    "dreamcast": "dreamcast",
    "ps1": "ps1",
    "ps2": "ps2",
    "ps3": "ps3",
    "psp": "psp",
    "psvita": "psvita",
    "xbox": "xbox",
    "xbox360": "xbox360",
    "arcade": "arcade",
    "neogeo": "neogeo",
    "pcengine": "pcengine",
    "wonderswan": "wonderswan",
    "msx": "msx",
}

EXTS = {
    "atari2600": {".a26", ".bin", ".zip"},
    "nes": {".nes", ".zip"},
    "snes": {".sfc", ".smc", ".zip"},
    "n64": {".z64", ".n64", ".v64"},
    "gamecube": {".iso", ".gcm", ".rvz", ".gcz"},
    "wii": {".iso", ".wbfs", ".rvz", ".gcm"},
    "wiiu": {".rpx", ".wud", ".wux"},
    "switch": {".nsp", ".xci"},
    "gb": {".gb", ".zip"},
    "gbc": {".gbc", ".zip"},
    "gba": {".gba", ".zip"},
    "nds": {".nds"},
    "3ds": {".cia", ".3ds", ".cxi"},
    "mastersystem": {".sms", ".zip"},
    "genesis": {".md", ".gen", ".bin", ".zip", ".smd"},
    "saturn": {".cue", ".chd", ".iso"},
    "dreamcast": {".chd", ".gdi", ".cdi", ".iso"},
    "ps1": {".cue", ".bin", ".chd", ".pbp", ".iso"},
    "ps2": {".iso", ".bin", ".chd", ".cso"},
    "ps3": {".iso", ".pkg"},
    "psp": {".iso", ".cso", ".pbp"},
    "psvita": {".vpk", ".zip"},
    "xbox": {".iso", ".xiso"},
    "xbox360": {".iso", ".xex", ".zar"},
    "arcade": {".zip", ".7z"},
    "neogeo": {".zip"},
    "pcengine": {".pce", ".cue", ".chd", ".zip"},
    "wonderswan": {".ws", ".wsc", ".zip"},
    "msx": {".rom", ".dsk", ".zip"},
}


def load_config() -> dict:
    path = CONFIG_PATH if CONFIG_PATH.exists() else EXAMPLE_PATH
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def slugify(name: str) -> str:
    s = name.lower()
    s = re.sub(r"\.[^.]+$", "", s)
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s


def title_from_filename(name: str) -> str:
    base = re.sub(r"\.[^.]+$", "", name)
    base = re.sub(r"[_\.]+", " ", base)
    base = re.sub(r"\s*\([^)]*\)", "", base)
    base = re.sub(r"\s*\[[^\]]*\]", "", base)
    return base.strip() or name


def scan_roms(cfg: dict) -> list[dict]:
    root = (ROOT / cfg.get("roms_root", "roms")).resolve()
    found: list[dict] = []
    for platform, folder in PLATFORM_FOLDERS.items():
        directory = root / folder
        if not directory.is_dir():
            continue
        allowed = EXTS.get(platform, set())
        for path in sorted(directory.rglob("*")):
            if not path.is_file() or path.name.startswith("."):
                continue
            if path.suffix.lower() not in allowed and allowed:
                continue
            rel = str(path.relative_to(root))
            found.append(
                {
                    "id": f"local-{platform}-{slugify(path.name)}",
                    "title": title_from_filename(path.name),
                    "platform": platform,
                    "year": 0,
                    "genre": "ROM local",
                    "source": "disk",
                    "file": rel,
                    "filename": path.name,
                    "hasRom": True,
                    "color": ["#102030", "#3dffc0"],
                }
            )
    return found


def which(cmd: str) -> str | None:
    from shutil import which as _which

    return _which(cmd)


def build_launch_command(cfg: dict, platform: str, rom_path: Path) -> list[str]:
    emus = cfg.get("emulators", {})
    # Map platform -> emulator key
    mapping = {
        "ps2": ("pcsx2", "pcsx2"),
        "ps3": ("rpcs3", "rpcs3"),
        "gamecube": ("dolphin", "dolphin"),
        "wii": ("dolphin", "dolphin"),
        "xbox360": ("xenia", "xenia"),
        "xbox": ("xemu", "xemu"),
        "3ds": ("citra", "citra"),
        "wiiu": ("cemu", "cemu"),
        "switch": ("ryujinx", "ryujinx"),
        "psvita": ("vita3k", "vita3k"),
    }

    if platform in mapping:
        key, _ = mapping[platform]
        emu = emus.get(key, {})
        path = emu.get("path", key)
        args = list(emu.get("args", []))
        # dolphin uses -e GAME
        if key == "dolphin":
            return [path, *args, str(rom_path)]
        if key == "xemu":
            return [path, *args, str(rom_path)]
        if key == "cemu":
            return [path, *args, str(rom_path)]
        return [path, *args, str(rom_path)]

    # Default: RetroArch
    ra = emus.get("retroarch", {})
    cores = ra.get("cores", {})
    core = cores.get(platform)
    if not core:
        raise ValueError(f"Sem emulador configurado para plataforma '{platform}'")
    ra_path = ra.get("path", "retroarch")
    cores_dir = ra.get("cores_dir") or ""
    core_file = core if core.endswith(".so") or core.endswith(".dll") else f"{core}.so"
    if cores_dir:
        core_path = str(Path(cores_dir) / core_file)
    else:
        core_path = core_file
    return [ra_path, "-L", core_path, str(rom_path)]


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def log_message(self, fmt: str, *args) -> None:
        sys.stderr.write("[gattas-play] " + (fmt % args) + "\n")

    def _json(self, code: int, payload: dict | list) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def _read_json(self) -> dict:
        length = int(self.headers.get("Content-Length", "0"))
        raw = self.rfile.read(length) if length else b"{}"
        return json.loads(raw.decode("utf-8") or "{}")

    def do_GET(self) -> None:  # noqa: N802
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path == "/api/status":
            cfg = load_config()
            roms = scan_roms(cfg)
            emu_status = {}
            for name, meta in cfg.get("emulators", {}).items():
                path = meta.get("path", name)
                resolved = which(path) if "/" not in path and "\\" not in path else (
                    path if Path(path).exists() else None
                )
                emu_status[name] = {"path": path, "found": bool(resolved), "resolved": resolved}
            self._json(
                200,
                {
                    "ok": True,
                    "root": str(ROOT),
                    "roms_root": str((ROOT / cfg.get("roms_root", "roms")).resolve()),
                    "rom_count": len(roms),
                    "platforms": list(PLATFORM_FOLDERS.keys()),
                    "emulators": emu_status,
                    "notes": cfg.get("notes", {}),
                    "config": "launcher/config.json" if CONFIG_PATH.exists() else "launcher/config.example.json",
                },
            )
            return

        if parsed.path == "/api/library":
            cfg = load_config()
            self._json(200, {"games": scan_roms(cfg)})
            return

        if parsed.path == "/api/platforms":
            self._json(200, {"platforms": PLATFORM_FOLDERS, "exts": {k: sorted(v) for k, v in EXTS.items()}})
            return

        return super().do_GET()

    def do_POST(self) -> None:  # noqa: N802
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path != "/api/launch":
            self._json(404, {"ok": False, "error": "not found"})
            return

        cfg = load_config()
        data = self._read_json()
        platform = data.get("platform")
        rel = data.get("file")
        if not platform or not rel:
            self._json(400, {"ok": False, "error": "platform e file são obrigatórios"})
            return

        if platform in {"ps5", "ps4", "xbox-series", "xbox-one"}:
            self._json(
                400,
                {
                    "ok": False,
                    "error": "Sem emulação PC madura para esta geração. Use o console ou serviço oficial.",
                },
            )
            return

        roms_root = (ROOT / cfg.get("roms_root", "roms")).resolve()
        rom_path = (roms_root / rel).resolve()
        if not str(rom_path).startswith(str(roms_root)) or not rom_path.is_file():
            self._json(404, {"ok": False, "error": "Arquivo ROM/ISO não encontrado"})
            return

        try:
            cmd = build_launch_command(cfg, platform, rom_path)
        except ValueError as exc:
            self._json(400, {"ok": False, "error": str(exc)})
            return

        # Dry-run support for UI testing without emulators installed
        if data.get("dryRun"):
            self._json(200, {"ok": True, "dryRun": True, "command": cmd})
            return

        try:
            subprocess.Popen(cmd, cwd=str(ROOT))  # noqa: S603
        except FileNotFoundError:
            self._json(
                500,
                {
                    "ok": False,
                    "error": f"Emulador não encontrado: {cmd[0]}. Edite launcher/config.json",
                    "command": cmd,
                },
            )
            return
        except OSError as exc:
            self._json(500, {"ok": False, "error": str(exc), "command": cmd})
            return

        self._json(200, {"ok": True, "launched": True, "command": cmd, "file": rel})


def main() -> None:
    if not CONFIG_PATH.exists() and EXAMPLE_PATH.exists():
        CONFIG_PATH.write_text(EXAMPLE_PATH.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"[gattas-play] Criado {CONFIG_PATH} a partir do example")

    cfg = load_config()
    host = cfg.get("host", "127.0.0.1")
    port = int(cfg.get("port", 5173))
    os.chdir(ROOT)
    server = ThreadingHTTPServer((host, port), Handler)
    print(f"[gattas-play] UI + API em http://{host}:{port}")
    print(f"[gattas-play] ROMs em {(ROOT / cfg.get('roms_root', 'roms')).resolve()}")
    print("[gattas-play] Coloque dumps próprios nas pastas. Ctrl+C para sair.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n[gattas-play] encerrado")


if __name__ == "__main__":
    main()
