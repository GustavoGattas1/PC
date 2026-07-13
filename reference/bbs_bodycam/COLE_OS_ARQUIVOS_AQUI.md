# Referência bbs_bodycam (Big Bang Studios)

Cole aqui a pasta **completa** do script comprado, sem alterar os arquivos originais:

```
C:\caminho\para\bbs_bodycam\
```

Para:

```
PC\reference\bbs_bodycam\original\
```

Arquivos importantes (mantenha a estrutura original do BBS):
- `fxmanifest.lua`
- `config.lua` (ou pasta `configs/`)
- `bridge/` ou `framework/` (arquivos QB/ESX originais)
- `client/`, `server/`, `web/`
- `README.md` do BBS

## Após colar os arquivos

1. Faça `git add .` e `git push`
2. Reabra o agente — ele integrará usando a ponte vRP em `bridge/vrp/` **sem modificar a lógica escrow do BBS**

## Integração vRP (já preparada)

A ponte Creative Uncharted está em:

```
reference/bbs_bodycam/bridge/vrp/
```

No `config.lua` do BBS, selecione o framework **custom/vrp** conforme o README do script e aponte para esses arquivos.
