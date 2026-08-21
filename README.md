# Keu Semijoias

Site modelo de e-commerce para apresentação à cliente. Paleta lilás e branco.

Projeto isolado: só este site, sem misturar com outros repositórios.

## No seu computador

Clone em uma pasta nova (não use a pasta do PC/FiveM):

```bat
cd %USERPROFILE%\Documents
git clone -b cursor/keu-semijoias-standalone-4608 --single-branch https://github.com/GustavoGattas1/PC.git keu-semijoias
cd keu-semijoias
```

A pasta de trabalho fica em `Documents\keu-semijoias`.

## Como abrir a loja

Dois cliques em `abrir-site.bat`, ou:

```bat
python -m http.server 4173
```

- Loja: http://localhost:4173
- Admin: http://localhost:4173/admin.html
- Admin: `admin@keusemijoias.com.br` / `keu123`

## Repositório GitHub só deste site

1. No GitHub, crie um repositório vazio chamado `keu-semijoias` (sem README).
2. Nesta pasta:

```bat
git checkout -b main
git remote remove origin
git remote add origin https://github.com/GustavoGattas1/keu-semijoias.git
git push -u origin main
```

Depois abra essa pasta no Cursor e trabalhe só nela.

## Vercel

Na Vercel, importe o repositório `keu-semijoias`. Root Directory: `.` (raiz). O arquivo `vercel.json` já está pronto.

## Arquivos

| Arquivo | Função |
|---------|--------|
| `index.html` | Home |
| `colecoes.html` / `colecao.html` | Coleções |
| `produto.html` | Página de produto |
| `sobre.html` / `contato.html` / `conta.html` | Institucional |
| `admin.html` | Painel admin |
| `css/style.css` | Visual (lilás e branco) |
| `js/data.js` | Produtos e textos |
| `js/app.js` | Loja e sacola |
| `js/admin.js` | Painel |

Protótipo estático, sem backend nem pagamento real.
