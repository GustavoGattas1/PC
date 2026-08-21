# Keu Semijoias — site modelo

E-commerce de apresentação para a cliente **Keu Semijoias**. Paleta lilás e branco. Pasta no repositório `PC`, no mesmo esquema de `loja-vip` e `iml-evidencias`.

GitHub: pasta [`keu-semijoias`](https://github.com/GustavoGattas1/PC/tree/cursor/keu-semijoias-site-4608/keu-semijoias)  
Pull request: https://github.com/GustavoGattas1/PC/pull/17

## No seu computador

Este agente trabalha na nuvem. Os arquivos entram no seu PC pelo Git, igual aos outros resources.

### GitHub Desktop

1. Abra o repositório **PC**
2. Fetch origin
3. Troque para a branch `cursor/keu-semijoias-site-4608`
4. A pasta aparece em `PC\keu-semijoias`

Depois de mergear o PR na `main`, um `pull` na main já traz a pasta, como `loja-vip`.

### Terminal

```bat
cd C:\caminho\do\PC
git fetch origin
git checkout cursor/keu-semijoias-site-4608
```

A pasta para editar é:

`PC\keu-semijoias`

## Como abrir a loja

Dê dois cliques em `abrir-site.bat`, ou:

```bat
cd keu-semijoias
python -m http.server 4173
```

- Loja: http://localhost:4173
- Admin: http://localhost:4173/admin.html

Admin de demonstração: `admin@keusemijoias.com.br` / `keu123`

## Manutenção

| Arquivo | Função |
|---------|--------|
| `index.html` | Home |
| `colecoes.html` / `colecao.html` | Coleções |
| `produto.html` | Página de produto |
| `sobre.html` / `contato.html` / `conta.html` | Institucional |
| `admin.html` | Painel admin |
| `css/style.css` | Cores, layout (lilás e branco) |
| `js/data.js` | Produtos, coleções, textos |
| `js/app.js` | Loja, sacola, header |
| `js/admin.js` | Painel administrativo |
| `vercel.json` | Pronto para publicar na Vercel |

Edite, faça commit e push nesta pasta. A Vercel pode usar `keu-semijoias` como Root Directory.

Protótipo estático: sem backend nem pagamento real. Catálogo, pedidos do admin e aparência usam o navegador (localStorage) na apresentação.
