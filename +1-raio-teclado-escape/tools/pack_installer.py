#!/usr/bin/env python3
"""Gera INSTALAR_NO_COMMAND_BAR.lua a partir dos fontes."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

FILES = [
    ("Config", SRC / "ReplicatedStorage/RaioGame/Config.lua", "ModuleScript"),
    ("World", SRC / "ReplicatedStorage/RaioGame/World.lua", "ModuleScript"),
    ("RaioServer", SRC / "ServerScriptService/RaioServer.server.lua", "Script"),
    ("RaioClient", SRC / "StarterPlayer/StarterPlayerScripts/RaioClient.client.lua", "LocalScript"),
]


def wrap(source: str) -> str:
    for n in range(3, 8):
        open_eq = "[" + "=" * n + "["
        close_eq = "]" + "=" * n + "]"
        if close_eq not in source:
            return open_eq + source + close_eq
    raise SystemExit("source contains all long-string delimiters")


def main() -> None:
    chunks = {}
    for name, path, _ in FILES:
        text = path.read_text(encoding="utf-8")
        if not text.endswith("\n"):
            text += "\n"
        chunks[name] = wrap(text)

    installer = f"""--[[
	+1 RAIO KEYBOARD ESCAPE  —  instalador 1 clique
	================================================
	COMO USAR (30 segundos):
	1. Abra o Roblox Studio em uma Baseplate
	2. View  >  Command Bar  (barra de comando embaixo)
	3. Cole ESTE arquivo INTEIRO na Command Bar
	4. Pressione Enter
	5. Aperte Play (F5)

	O mapa, a HUD, o dragão, a loja e os scripts nascem sozinhos.
	Pode colar de novo: o instalador apaga a versão antiga antes.
]]

local function wipe(parent, name)
	local old = parent:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local SP = game:GetService("StarterPlayer")
local SPS = SP:WaitForChild("StarterPlayerScripts")

wipe(RS, "RaioGame")
wipe(SSS, "RaioServer")
wipe(SPS, "RaioClient")
wipe(workspace, "RaioWorld")

local folder = Instance.new("Folder")
folder.Name = "RaioGame"
folder.Parent = RS

local function makeModule(name, source)
	local m = Instance.new("ModuleScript")
	m.Name = name
	m.Source = source
	m.Parent = folder
end

local function makeScript(className, name, source, parent)
	local s = Instance.new(className)
	s.Name = name
	s.Source = source
	s.Parent = parent
end

makeModule("Config", {chunks["Config"]})
makeModule("World", {chunks["World"]})
makeScript("Script", "RaioServer", {chunks["RaioServer"]}, SSS)
makeScript("LocalScript", "RaioClient", {chunks["RaioClient"]}, SPS)

task.wait(0.1)
local World = require(folder:WaitForChild("World"))
World.Build()

local lighting = game:GetService("Lighting")
lighting.ClockTime = 21.4

print("================================================")
print("+1 RAIO KEYBOARD ESCAPE instalado com sucesso!")
print("Aperte Play. Ande em cima do teclado gigante.")
print("Codigos: RAIO  TEMPESTADE  DRAGAO  STREAMER  NEON  COMBO100")
print("================================================")
"""

    out = ROOT / "INSTALAR_NO_COMMAND_BAR.lua"
    out.write_text(installer, encoding="utf-8")
    print(f"wrote {out} ({out.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
