# Verificação

Nada é "pronto" sem evidência. O mínimo: tipos, navegador em três larguras, e a página no ar.

## Tipos e build

```bash
npx tsc --noEmit -p .        # sempre, e é rápido
npm run build                # só se nenhum `next dev` da mesma pasta estiver no ar
```

Os dois escrevem em `.next`. Com um dev server rodando (inclusive de outra sessão), rode só o
`tsc` e deixe o build para a Vercel, ou peça para parar o dev antes.

## Navegador

Playwright já costuma existir no repositório (`front-admin/node_modules/playwright`). Um script
curto resolve:

```js
const { chromium } = require('<repo>/node_modules/playwright');
const p = await b.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
p.on('pageerror', e => console.log('PAGEERROR', e.message));
await p.goto(url, { waitUntil: 'networkidle' });
await p.evaluate(() => document.querySelector('#secao').scrollIntoView());
const box = await p.evaluate(() => { const r = document.querySelector('#secao').getBoundingClientRect();
  return { y: r.top + scrollY, h: r.height, overflow: document.documentElement.scrollWidth - innerWidth }; });
await p.screenshot({ path: 'x.png', fullPage: true, clip: { x: 0, y: box.y, width: 1440, height: box.h } });
```

- **Recorte por área**, não `locator.screenshot()`: elemento que anima nunca fica "estável".
- Meça em vez de achar: largura real da foto, `overflow` horizontal, contagem de itens, texto que
  estourou (`scrollWidth - clientWidth` no título).
- Larguras: **1440** (desktop), **~1280** (notebook), **400** (celular). Em todas,
  `document.documentElement.scrollWidth === window.innerWidth`.
- Página muito alta: recorte por seção. Imagem inteira de 8000 px não se lê.

## O que conferir sempre

- Navegação pelo menu abre a página no topo (teste saindo do topo **e** de página rolada).
- Componente interativo funciona com clique e com teclado, e o estado inicial faz sentido.
- Imagem: qual arquivo o navegador baixou (`currentSrc`), com `w` e `q` coerentes.
- Contraste do texto sobre fundo escuro e sobre foto.
- Links externos abrindo em nova guia; âncoras chegando na seção certa.

## Convivendo com outras sessões

Se outra sessão mexe no mesmo projeto: avise o que você vai editar, releia o arquivo antes de
editar e evite rodar comandos que mexem em pasta compartilhada (`.next`, build da biblioteca de
ícones). Conflito comum: dois agentes adicionando o mesmo import.
