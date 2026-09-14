# Verificação

Nada é "pronto" sem evidência. O mínimo: tipos, navegador em cinco larguras, movimento reduzido, a
tela final vista e a página no ar. "O código está pronto" sem ter visto a tela é o erro que o usuário
pega.

## Ferramental da máquina

Descubra antes de começar, sem supor:

```bash
which cwebp sips ffmpeg magick 2>/dev/null
node -e "console.log(require('sharp').versions)"     # dentro do projeto Next: sharp vem com ele
python3 -c "from PIL import Image" 2>&1 | tail -1     # costuma faltar
ls ~/Library/Caches/ms-playwright 2>/dev/null         # navegadores do Playwright
```

- Sem Pillow nem ImageMagick: `sharp` via `node -e`, canvas dentro do Chromium, ou os scripts em Python
  puro da skill.
- `require('playwright')` falha num script solto: `npm i playwright-core` no scratchpad e
  `chromium.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' })`.
- macOS e zsh: não há `timeout` (rode em segundo plano); `--include="*.tsx"` entre aspas; no zsh,
  `$par` sem aspas não se divide em palavras (`set -- $par` deixa `$1="a b"`): use `${=par}` ou uma
  chamada por linha.

## Tipos e build

```bash
npx tsc --noEmit -p .        # sempre
npm run build                # só se nenhum `next dev` da mesma pasta estiver no ar
```

Os dois escrevem em `.next`. Com um dev server rodando (inclusive de outra sessão ou do usuário), rode
só o `tsc` e deixe o build para a Vercel, ou peça para parar o dev. `.next` corrompido (home em 500 com
`SyntaxError ... JSON`): pare tudo e `rm -rf .next`.

## O servidor está servindo o código novo?

Antes de medir qualquer coisa no navegador:

```bash
P=$(grep -oE '"dev": *"[^"]*-p *[0-9]+' package.json | grep -oE '[0-9]+$'); P=${P:-3000}
CSS=$(curl -s localhost:$P/ | grep -o '/_next/static/[^"]*\.css' | head -1)
curl -s localhost:$P$CSS | grep -c classe-nova          # compare com: grep -c classe-nova src/app/globals.css
curl -s "localhost:$P/?x=$RANDOM" | grep -c "texto novo"
```

Watcher que não recompilou é causa comum de "a animação não está no ar". Reinicie o dev (e `rm -rf
.next` se o CSS continuar preso).

Parar o dev: liste quem **escuta** a porta e mate por PID.

```bash
lsof -nP -iTCP:$P -sTCP:LISTEN
ps -Ao pid,ppid,command | grep next
```

`kill $(lsof -ti :$P)` mata também o Chrome de captura conectado à porta. Quando o usuário diz "vou
subir a aplicação", pare de subir servidor e valide só com `tsc` até ele liberar.

## Navegador

```js
const b = await chromium.launch()
const ctx = await b.newContext({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 })
const p = await ctx.newPage()
p.on('pageerror', (e) => console.log('PAGEERROR', e.message))
await p.goto(url, { waitUntil: 'networkidle' })
await p.addStyleTag({ content: 'nextjs-portal{display:none!important}' })     // overlay do Next
// role devagar: 500 px a cada 140 ms dispara revelação e lazy-load
const alt = await p.evaluate(() => document.body.scrollHeight)
for (let y = 0; y < alt; y += 500) { await p.evaluate((y) => scrollTo(0, y), y); await p.waitForTimeout(140) }
const box = await p.evaluate(() => { const r = document.querySelector('#secao').getBoundingClientRect()
  return { y: r.top + scrollY, h: Math.ceil(r.height), overflow: document.documentElement.scrollWidth - innerWidth } })
await p.screenshot({ path: 'secao.png', fullPage: true, clip: { x: 0, y: box.y, width: 1440, height: Math.min(box.h, 1500) } })
```

- **Recorte por área**, não `locator.screenshot()`: elemento que anima nunca fica estável.
- Rolagem rápida (700 px a cada 60 ms) deixa blocos sem revelar. Conte
  `document.querySelectorAll('[data-reveal]:not(.is-in)').length`: tem de dar zero.
- Carrossel que troca sozinho: `mouse.move` sobre o palco antes de clicar na aba, senão a captura pega a
  seguinte. Meio de transição: capture de 350 a 380 ms depois do clique.
- `clip` com números; página alta em fatias de 1500 px ou uma captura por `section`.
- Chrome headless não abre janela menor que ~500 px com `--window-size`: use o `viewport` do Playwright,
  ou uma página local com `<iframe style="width:360px">`.

### Larguras

**1440** (desktop), **~1280** (notebook), **1024** (tablet, onde o menu estoura), **400** e **360**
(celular). Em todas, `document.documentElement.scrollWidth === window.innerWidth`.

### Estados

```js
// Playwright
const reduzido = await b.newContext({ reducedMotion: 'reduce' })
const semJs = await b.newContext({ javaScriptEnabled: false })
const toque = await b.newContext({ hasTouch: true, isMobile: true, viewport: { width: 390, height: 844 } })
// puppeteer (não aceita `hover`: para toque, use o contexto `toque` do Playwright)
await p.emulateMediaFeatures([{ name: 'prefers-reduced-motion', value: 'reduce' }])
```

- **Movimento reduzido**: tudo no estado final, nada a meio caminho, nenhum laço rodando
  (`getComputedStyle(el).animationName === 'none'`). Exemplo real: o cartão do kanban ficava parado na
  coluna de origem porque o repouso não era o quadro final.
- **JS desligado** (`javaScriptEnabled: false`): conteúdo visível e desenhos completos. A tela viva do
  aparelho pode ficar escura (exceção aceita), mas a mensagem da abertura está no texto.
- **Toque** (`hover: none`): nada depende de passar o mouse.

## Medir em vez de achar

| O quê | Como |
|---|---|
| Texto longo no celular | a 400 px, para cada bloco folha (filhos sem `display` block, flex, grid ou list-item), fora de `<details>`: `Math.round(altura / lineHeight)`; liste os acima de 3 |
| Espaço vertical desperdiçado | some `padding` de seção e vãos acima de 20 px entre irmãos; liste os maiores (36 px ou mais) com o texto do bloco seguinte |
| Sobreposição | pares com `bottom` maior que o `top` do seguinte; selo sobre quadro (`quadro.bottom - selo.top`) |
| Colisão ao longo de um laço | amostre `getBoundingClientRect` a cada 250 ms por um ciclo inteiro; ache o pior instante |
| Anotação apontando para o bloco | distância entre a anotação e o centro do bloco que ela descreve, em cada breakpoint |
| Animação rodando | amostre `getComputedStyle(el).transform` e `opacity` a cada 1,5 s |
| Qual regra CSS vence | percorra `document.styleSheets` filtrando `el.matches(r.selectorText)`, ou CDP `CSS.getMatchedStylesForNode` |
| Imagem baixada | depois de `img.decode()`: `new URL(img.currentSrc).searchParams.get('w')` contra largura exibida × `devicePixelRatio` |
| Mídia sumida no celular | `img` com caixa 0×0 a 400 px |
| Contraste | razão WCAG entre `color` e o primeiro `backgroundColor` não transparente dos ancestrais (compare com a string `rgba(0, 0, 0, 0)`, com espaços) |
| Largura de texto numa fonte | página local com a fonte carregada, `document.fonts.ready`, `getBoundingClientRect().width` de cada candidata a quebra |
| CLS | `PerformanceObserver` de `layout-shift`; `goto('/pagina#alvo')`, esperar 4 s, `getBoundingClientRect().top` do alvo perto da altura do cabeçalho |
| Requisição pendurada | registre `request`, `requestfinished` e `requestfailed` |

Falsos positivos que já enganaram: `!img.alt` é verdadeiro para `alt=""` (use `hasAttribute('alt')` e
`aria-hidden` no ancestral); `li` com filhos em bloco medido inteiro; leitura durante a animação.

## O que conferir sempre

- Navegação pelo menu abre a página no topo (teste saindo do topo **e** de página rolada).
- Todo link "ver exemplo" e toda âncora clicados até o destino visível, inclusive os que abrem
  `<details>`.
- Todos os links internos de todas as rotas respondem abaixo de 400.
- Componente interativo funciona com clique e com teclado; estado inicial faz sentido.
- Ritmo de fundos por página, contando o rodapé; última seção contrasta com ele.
- Contraste do texto sobre faixa escura e sobre foto.
- Links externos em nova guia.
- `scripts/varrer-projeto.sh . <palavra-banida>`: emoji, travessão, caixa alta, palavras banidas,
  imagens órfãs, originais em `public/`, arquivos pesados, segredos, `.gitignore`.

## Vídeo da animação para o usuário

Pedido de animação se entrega com vídeo. Receita com `puppeteer-core`, o Chrome instalado e
`ffmpeg-static` no scratchpad:

```js
await p.setViewport({ width: 1440, height: Math.min(alturaDaSecao, 1400), deviceScaleFactor: 2 })
await p.evaluate((y) => scrollTo(0, y), topoDaSecao)
await p.waitForFunction(() => document.querySelector('#metodo [data-reveal].is-in'))
const cdp = await p.createCDPSession()
const quadros = []
cdp.on('Page.screencastFrame', async ({ data, sessionId, metadata }) => {
  quadros.push({ data, t: metadata.timestamp })
  await cdp.send('Page.screencastFrameAck', { sessionId })
})
await cdp.send('Page.startScreencast', { format: 'jpeg', quality: 92, everyNthFrame: 1 })
await new Promise((r) => setTimeout(r, SEGUNDOS * 1000))
await cdp.send('Page.stopScreencast')
// grave cada quadro como q00001.jpg na pasta quadros/ e uma lista.txt com
//   file 'q00001.jpg'
//   duration <t do próximo - t deste>
execFileSync(ffmpeg, ['-y', '-f', 'concat', '-safe', '0', '-i', 'quadros/lista.txt',
  '-vf', 'scale=1440:-2:flags=lanczos,fps=30', '-c:v', 'libx264', '-preset', 'slow', '-crf', '23',
  '-pix_fmt', 'yuv420p', '-movflags', '+faststart', 'animacao.mp4'])
```

- Na lista do concat, o caminho é **relativo ao arquivo da lista** (`file 'q00001.jpg'`, não
  `quadros/q00001.jpg`).
- O `ffmpeg` do cache do Playwright é mínimo e não serve: `npm i ffmpeg-static`.
- Confira o enquadramento: `ffmpeg -ss 3 -i animacao.mp4 -frames:v 1 amostra.jpg`.
- Mande com `SendUserFile`, junto das capturas em repouso.

## SEO no ar

```bash
bash scripts/seo-no-ar.sh https://www.dominio.com.br
```

Percorre o sitemap e marca: URL que não responde 200, canonical diferente da própria URL, falta de
`og:image` e `twitter:image`, número de h1 diferente de 1, `noindex` no sitemap, host alternativo sem
redirect, robots sem sitemap, rota inexistente sem 404. Depois, à mão:

- admin e login com `noindex` no HTML e `X-Robots-Tag` no cabeçalho;
- redirect antigo em um salto só (`curl -sI $D/rota-antiga | grep -i location`);
- o arquivo que `<link rel="icon">` anuncia tem o tipo anunciado;
- JSON-LD de uma página de cada modelo no [Rich Results Test](https://search.google.com/test/rich-results);
- Lighthouse mobile nas páginas de entrada (home, landing, um serviço, um case):

```bash
npx -y lighthouse@12 "$D/pagina" --form-factor=mobile --only-categories=performance,seo \
  --output=json --output-path=lh.json --quiet --chrome-flags="--headless=new"
```

Anote LCP, CLS, TBT e o **elemento de LCP**. Elemento de LCP com `loading="lazy"` ou dentro de animação
de entrada é erro.

## Smoke test em produção

```bash
D=https://www.dominio.com.br
for p in / /servicos /sitemap.xml /robots.txt /icon.png /opengraph-image /nao-existe; do
  curl -s -o /dev/null -L -w "$p %{http_code} %{time_total}s\n" "$D$p"; done
curl -s "$D/" | grep -c "trecho da copy nova"
```

## Relatório de entrega

Estrutura que funcionou: **o que mudou**, **defeito que isso revelou**, **verificado** (com números e
larguras), **o que não foi verificado** e **o que depende do usuário**. Erro seu vai com a causa, e com
uma reversão barata quando a leitura do pedido foi interpretação.
