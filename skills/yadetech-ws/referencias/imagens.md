# Imagens

Toda imagem prova alguma coisa ou sai. Antes de ocupar um espaço, escreva numa linha **o que ela
prova naquela frase** e quem ela representa. Imagem encaixada só porque havia espaço é o erro que
mais se repete.

Origens, em ordem de força como prova:

1. **Tela e site reais do cliente**: prints, página rolando, vídeo da plataforma.
2. **Tela refeita em HTML** a partir do código do produto, ou tela de exemplo com dados fictícios
   marcados.
3. **Foto real** do cliente, da equipe, do lugar.
4. **Imagem gerada por IA**: cena, estado de quem vai clicar, textura, recorte de pessoa, moldura de
   aparelho (`mockups.md`).

Nunca banco de imagem genérico. Foto gerada nunca representa a equipe da empresa: gente inventada
apresentada como "quem vai te atender" é ficção sobre pessoas.

## 1. O vai e volta com o gerador (ChatGPT, Gemini)

1. **Crie o espaço antes da imagem existir.** Um registro único (`src/lib/imagens.ts`) com nome
   versionado e o papel de cada imagem. O bloco usa a imagem se o arquivo existe e cai para uma
   composição sem foto (tela real, desenho) enquanto não existe. O usuário ativa soltando o arquivo,
   sem código.

   ```ts
   export function temImagem(relativo: string) {
     return existsSync(path.join(process.cwd(), 'public', relativo))
   }
   ```

   Só em página estática: em rota dinâmica servida por função, `public/` não vai no pacote e o teste
   dá `false` em produção sem erro. O layout prevê os dois estados, e a identidade do cartão (ícone,
   rótulo) fica fora do condicional de imagem.
2. **Escreva `PROMPTS-IMAGENS.md` na raiz do site na primeira entrega**, junto com os espaços. Cada
   item traz: nome exato do arquivo, onde entra, o que precisa provar, proporção, tamanho mínimo,
   estado ("no ar", "a gerar", "sem uso" e o porquê) e o prompt em inglês.
3. **O usuário gera e larga o arquivo** em `public/images/` com o nome do gerador
   ("ChatGPT Image 12 de set. de 2026, 21_10_22.png") e avisa.
4. **Identifique pelo conteúdo e pela proporção** (1915×821 é o hero 21:9; 1086×1448 é o cartão
   3:4), olhe a imagem inteira e com zoom nas bordas, e siga o checklist da seção 3.
5. **O usuário critica e o prompt volta revisado** no mesmo arquivo, com o que mudou e por quê.

## 2. Prompts

### Regras de todo prompt

- **Proporção** igual à moldura onde a imagem entra; sujeito longe das bordas que o recorte come.
- **Paleta fechada em hex** e cores proibidas por nome: "the only colours in the image are natural
  skin and hair tones, off-white (<#papel>) and charcoal (<#tinta>). No blue, no orange". Cor que não
  existe na página parece banco de imagem; roupa na cor do cartão funde com o fundo.
- **Cor de acento citada em hex** como luz discreta no fundo amarra a foto à identidade.
- **Sem texto e sem marca**: "No readable text, no posters, no whiteboard, no logos, no watermarks".
  Nunca peça logo da empresa na roupa ou em objeto: o gerador deforma letra. Marca se compõe depois,
  com o arquivo real.
- **Imagem institucional sem setor**: "Neutral office with no props that identify an industry". Se
  parecer de um ramo só, o site parece de um ramo só. Cenário de setor fica na página do case.
- **Encene o estado de quem vai clicar**, não só a atividade ("Ainda não sei o que preciso" pede
  alguém procurando onde está o problema, não alguém trabalhando).
- **Idade, gênero e jeito** explícitos, pensando em quem a pessoa representa (o cliente, não a
  empresa).
- Peça uma ou duas variações a mais do que precisa.
- O ChatGPT entrega em tamanhos fixos, qualquer que seja o pedido: 1536×1024 (3:2), 1672×941
  (16:9), 1915×821 (21:9), 1448×1086 (4:3), 1402×1122 (5:4) e 1086×1448 (3:4). Faixa de `100vw` fica
  esticada em retina: planeje para esse tamanho ou use a imagem como textura.

### A. Cena como textura de fundo (hero sob véu)

A 35% de opacidade só sobrevive estrutura: luz, profundidade, linhas. Rosto é desperdício. No site,
`alt=""` e `aria-hidden`.

```
Wide horizontal photorealistic photo, 21:9 aspect ratio. An empty small company office seen in
depth: a row of desks with monitors receding toward a large window wall, a glass partition catching
the light, a few chairs and plants, no people in the frame. Strong natural daylight raking in from
the left, long soft shadows across the floor. A subtle <#acento> accent light deep in the
background. Architectural depth, clean horizontal lines, calm and spacious. Editorial interior
photography, natural colors, sharp throughout rather than shallow depth of field. Neutral office
with no props that identify an industry. No readable text, no posters, no whiteboard, no logos, no
watermarks.
```

### B. Estado mental de quem clica

```
Vertical photorealistic photo, 3:4 aspect ratio. A Brazilian business owner in her 50s standing in
the back office of a small company, one hand on her chin, looking up at a wall covered with blank
colored sticky notes, printed sheets and a paper calendar, some notes crossed out in pen. On the
counter in front of her: two open folders, a stack of paper order forms, a calculator and a mug.
Shelves with boxes behind. Her expression is of someone trying to find where the problem is, not
solving it yet. Soft daylight from a side window. A subtle <#acento> accent light in the background.
Candid, unstaged. Editorial photography, natural colors, shallow depth of field. No readable text
anywhere (notes and sheets blank or scribbled), no posters, no logos, no watermarks.
```

Para o caminho oposto ("Já sei o que preciso"), rostos fora do quadro: por cima do ombro, papel com
wireframes à mão, mãos apontando.

### C. Pessoa recortada que sai do cartão

```
Vertical photorealistic cutout of a single person, 3:4 aspect ratio, on a fully transparent
background (alpha channel). A Brazilian man in his late twenties, short dark hair, clean and current
look, wearing a plain off-white shirt with the sleeves rolled up and charcoal near-black trousers.
Standing, arms relaxed, body turned three quarters to his right so he faces toward the left side of
the frame, calm and attentive, looking slightly down and to the left as if following something on a
screen that is not in the picture. Framed from the waist up, centered, with generous empty margin
above his head. Soft even studio light from the left, gentle contact shadow on the body only.
Restrained colour palette: the only colours in the image are natural skin and hair tones, off-white
(<#papel>) and charcoal (<#tinta>). No blue, no orange, no brown, no red, no pattern, no print, no
visible branding on the clothes. Low saturation, natural editorial grade, sharp focus. No
background, no floor, no desk, no chair, no monitor, no laptop, no plants, no props of any kind. No
<cor do cartão> anywhere in the clothing. No drop shadow cast onto the background. No readable
text, no logos, no watermarks.
```

- Sem alfa na ferramenta: fundo `#FF00FF` chapado (magenta não existe em pele, cabelo e roupa; branco
  come camisa clara).
- Folga acima da cabeça: é o que ultrapassa a borda. Nada na mão que a borda corte; objeto só dentro
  da silhueta (tablet no peito, tela virada para as pessoas, sem interface falsa). Duas pessoas com
  cores de roupa diferentes, senão viram uma mancha só. Corpo virado para o texto.
- No site: `overflow-hidden` e raio **só na camada de fundo** do cartão (senão corta a cabeça),
  imagem `absolute bottom-0 h-[calc(100%+5rem)] w-auto object-contain object-bottom` no desktop,
  contida no celular.

### D. Foto de cena do negócio (página de público, case)

```
Vertical 9:16 photorealistic photo. <sujeito brasileiro, idade, ação concreta>, em <cenário
específico do negócio>. <Luz: bright natural daylight / soft window light>. A subtle <#acento>
accent light in the background. Candid, joyful, authentic. Editorial photography, shallow depth of
field, natural colors. No readable text, no posters, no whiteboard, no logos, no watermarks.
```

Cena do negócio, não "pessoa feliz com celular": mesa de estúdio, palco pequeno, balcão de loja.

### E. Moldura de aparelho

`mockups.md`.

## 3. Do arquivo devolvido ao site

1. Olhe a imagem inteira e com zoom: texto embaralhado, mão com seis dedos, marca d'água, **marca de
   terceiro** (maçã num tablet) e interface falsa (campo de busca que não busca, selo de verificado).
   Achou: peça para regerar e diga o motivo.
2. Recorte com alfa: meça o canal alfa e componha sobre a cor real do fundo, com zoom em cabelo e
   ombro, para caçar halo. O PNG "transparente" do ChatGPT vem com o sujeito em alfa 253: normalize
   `alfa ≥ 250 → 255`.
3. Converta com nome semântico versionado:

   ```bash
   cwebp -quiet -q 92 -m 6 original.png -o public/images/<nome-semantico>-v1.webp
   cwebp -quiet -q 92 -m 6 -alpha_q 100 recorte.png -o public/images/<pessoa-recorte>-v1.webp
   sips -g pixelWidth -g pixelHeight -g hasAlpha public/images/<arquivo>
   ```

   Qualidade 92 no tamanho cheio; quem reduz é o `next/image`. Comprimir duas vezes suja pele e
   textura. Sem `cwebp` nem `sharp`: `canvas.toDataURL('image/webp', 0.92)` dentro do Chromium.
4. **Original para `assets/imagens-site-originais/`**, fora de `public/`, no mesmo passo. Original em
   `public/` sobe no deploy.
5. Chave no registro, `width` e `height` reais, `sizes` pela largura medida, `alt` que descreve a cena
   e o papel dela (ou `alt=""` se decorativa), `object-position` conferido a 400 px.
6. Atualize o estado do item no `PROMPTS-IMAGENS.md`.
7. **Trocou o conteúdo, troca o nome** (`-v2`). Navegador e otimizador guardam por nome.

## 4. Prints de sites e plataformas reais

### Capturar

- Fonte: site publicado, ou `next build && next start`. Nunca o dev (indicador na tela).
- Sem barra de navegador no print: a barra é desenhada em CSS no site.
- Contexto com `reducedMotion: 'reduce'`: cada bloco no estado final.
- Role a página inteira devagar antes (dispara lazy-load): 500 px a cada 140 ms.
- Componente interativo no estado inicial. Descubra as rotas pelos `a[href]` da mesma origem.
- **Privacidade**: nome, e-mail e dado de pessoa real não aparecem. Troque o texto no DOM antes da
  captura (`p.evaluate` com texto fictício, ou `filter: blur` no elemento); se estiver na borda, corte
  com `cwebp -crop`. Nunca a URL de admin, nem em print nem em texto. Tela de login não prova nada.
- Plataforma com dados sintéticos coerentes entre telas, em ambiente local, nunca produção.

```js
async function captura(url, arquivo, { escala, inteira, celular = false }) {
  const ctx = await browser.newContext({
    viewport: celular ? { width: 390, height: 844 } : { width: 1440, height: 900 },
    isMobile: celular, hasTouch: celular, deviceScaleFactor: escala, reducedMotion: 'reduce' })
  const p = await ctx.newPage()
  await p.goto(url, { waitUntil: 'networkidle', timeout: 90000 })
  await p.evaluate(async () => {
    for (let y = 0; y < document.documentElement.scrollHeight; y += 500) {
      scrollTo(0, y); await new Promise((r) => setTimeout(r, 140))
    }
    scrollTo(0, 0); await new Promise((r) => setTimeout(r, 400))
  })
  await p.screenshot({ path: arquivo, fullPage: inteira })
  await ctx.close()
}
await captura(url, 'desktop/home-dobra.png', { escala: 2, inteira: false })
await captura(url, 'desktop/home-completo.png', { escala: 1, inteira: true })   // 2x estoura o limite do WebP
await captura(url, 'celular/home-dobra.png', { escala: 3, inteira: false, celular: true })
await captura(url, 'celular/home-completo.png', { escala: 2, inteira: true, celular: true })
```

Peça interativa (simulador, orçamento): ache `[role="tab"]` ou `form`, suba até o bloco visual e
recorte com 24 px de folga.

### Organizar

```
prints-site/
  desktop/<pagina>-dobra.png       1440×900 @2x
  desktop/<pagina>-completo.png    1440×altura @1x
  celular/<pagina>-dobra.png       390×844 @3x
  celular/<pagina>-completo.png    390×altura @2x
  pecas/<peca>.png                 recorte do elemento @2x
  README.md                        medidas CSS, como foi feito, sugestão de uso
```

Plataforma: `computador/NN-tela.png`, `celular/NN-tela.png`; o prefixo numérico mantém a ordem do
percurso. A pasta de prints brutos fica fora de `public/`.

### Publicar

| Uso | Arquivo | Regra |
|---|---|---|
| Capa do case | dobra desktop 2880×1800 | tamanho cheio, q92 |
| Celular do case | dobra celular 1170×2532 | tamanho cheio |
| Tira que rola (desktop) | completo, reduzido a 720 px de largura | ~2x da exibição |
| Tira que rola (celular) | completo, reduzido a 264 px | ~3x da exibição |
| Tela de plataforma em página | 1600×1000 ou 1200×750 | `-resize` |

```bash
cwebp -quiet -q 90 -m 6 -resize 720 0 desktop/home-completo.png -o public/cases/<slug>/<slug>-rolo-desktop-v1.webp
```

- **WebP aceita no máximo 16383 px por lado.** Reduza antes, ou escolha uma página mais curta.
- `width` e `height` reais de cada arquivo vão no conteúdo.
- Tela de produto entra **no tamanho real, sem corte** na página do case ("tela cortada vira tela
  quebrada"): `w-auto h-auto max-w-full` com `maxHeight: 72vh`. Em cartão, `object-cover` com
  `objectPosition` escolhido por imagem. Tela em pé ganha teto de largura pela proporção
  (`maxWidth = 620 × w/h`).
- Mídia de prova nunca some no celular (`hidden sm:block` em miniatura é o erro clássico): encolha.

### Página inteira rolando no cartão

```ts
const percurso = (w: number, h: number, janela: number) =>
  `${Math.max(0, 100 * (1 - (janela * w) / h)).toFixed(1)}%`     // janela = altura/largura visível
const duracao = (w: number, h: number) => `${Math.min(34, Math.max(16, (h / w) * 4.2))}s`
```

```css
.rolo-quadro { position: relative; overflow: hidden; }              /* área visível 16:10 ou 9:18 */
.rolo-tira {
  position: absolute; inset-inline: 0; top: 0; width: 100%; height: auto;
  animation: rolo-descer var(--dur, 20s) ease-in-out infinite alternate;
}
@keyframes rolo-descer {
  0%, 6% { transform: translateY(0) }
  94%, 100% { transform: translateY(calc(-1 * var(--percurso, 0%))) }
}
```

A seção leva `data-laco` para a tira parar fora da tela (`animacao.md`).

- `translateY(%)` é relativo à altura do próprio elemento: nada é medido em JS.
- Duração proporcional ao comprimento, com piso e teto; com valor fixo uma arrasta e a outra corre.
- Ida e volta com pausas nas pontas; voltar ao topo de uma vez dá um tranco.
- Desktop e celular com a mesma duração, juntos. `quality={75}` e `sizes` pequenos.
- Sem logo da marca no cartão: a tela já mostra de quem é. O link vai para o bloco interno do case,
  não para fora.

## 5. Logos

### De clientes

1. Origem com alfa, sem fundo. Detecte fundo chapado (alfa dos quatro cantos acima de 200) e peça a
   versão certa.
2. **Corte a margem transparente até o desenho** (margens de até 84% foram achadas). É o que faz a
   mesma classe de altura controlar o desenho, não a caixa.
3. WebP com alfa (`cwebp -q 90 -m 6`), `-v1` no nome.
4. Altura por logo (`h-5`, `h-7`, `h-9`) para igualar o peso visual; logo quadrado ganha mais altura.
5. **Meça o contraste de cada arte sobre o fundo real.** Onde não passa, gere a **versão negativa**
   que troca só o escuro por branco e preserva o acento (campo `srcClaro`). Nunca caixa branca atrás
   do logo. Nunca `filter: brightness(0) invert(1)` em SVG colorido: apaga as cores.
6. Repouso cinza e cor no hover:

```css
.marca-arte { filter: grayscale(1); opacity: .5; transition: filter 320ms, opacity 320ms; }
.marca-arte--escura { filter: brightness(0) invert(1); opacity: .5; }   /* arte preta monocromática */
.marca-item:hover .marca-arte, .marca-item:focus-within .marca-arte { filter: none; opacity: 1; }
```

7. `next/image` com `className="h-7 w-auto max-w-none"` e `sizes="200px"`.
8. Texto da faixa abrange todo tipo de cliente ("Empresas e instituições que confiam"), não só
   "empresas".

### De tecnologia

- SVG oficial do Simple Icons (CC0) inline, com a cor oficial guardada: repouso `fill: var(--muted)`,
  hover `fill: var(--cor)`.

```bash
curl -sS "https://cdn.jsdelivr.net/npm/simple-icons@15/icons/react.svg"      # copie o d do <path>
```

- Marca retirada do Simple Icons (AWS, OpenAI, Playwright): SVG oficial do Wikimedia ou do kit de
  imprensa, com `viewBox` próprio e `fill-rule` preservado. Nunca a palavra no lugar do logo: uma
  exceção silenciosa numa grade de marcas é defeito.
- Estratégia que não é produto ("PWA", "revisão de código") entra como chip tracejado com ícone
  próprio. Ferramenta de mercado tem prioridade sobre estratégia.
- WhatsApp e lojas de app: desenho oficial, sem redesenho.

## 6. Vídeo

- Antes do clique, só o cartaz (`next/image`) e um botão; o `<video>` nem é montado. Depois,
  `autoPlay playsInline controls`.
- Pedido ao usuário: MP4 H.264 com AAC, 16:9, 1080p, abaixo de 30 MB (acima disso, hospedagem fora e
  embed), nome com versão ao regravar, capa 16:9.
- Espaço de vídeo que depende de gravação futura só aparece quando o arquivo existe. Nada de
  "em breve".
- Vídeo na página do case; no cartão, imagem parada.

## 7. Tela real do app refeita em HTML

Melhor que foto de celular e melhor que mockup inventado.

1. Um subagente `Explore` extrai a especificação da tela do código (Flutter, React Native ou web):
   árvore de componentes, textos literais, tamanhos, cores resolvidas em hex, espaçamentos, ícones e
   o conteúdo dos SVGs pequenos.
2. Monte o HTML no tamanho lógico do aparelho (390×846), com a mesma fonte do app, barra de status e
   barra inferior. Dentro do site, use como tela viva no mockup (`mockups.md`); como arquivo, capture
   com Playwright em `deviceScaleFactor: 3`.
3. Onde o app tem defeito que deixa a tela vazia, mostre o que a tela pretende mostrar e **avise o
   usuário** com arquivo e linha.
4. Mesmos nomes e valores de exemplo em todas as telas: elas contam a mesma história.

Verificações: fontes carregadas (`document.fonts.ready`), nenhuma imagem quebrada, textos que não
couberam em uma linha ajustados.

## 8. Limpeza

Antes do commit final, liste o que está em `public/` sem referência (`scripts/varrer-projeto.sh`).

- Mova para uma pasta fora do repositório **preservando os caminhos**, com `LISTA-DE-ARQUIVOS.txt`.
- **Originais de geração e prints brutos não vão para a lixeira**: ficam na pasta de originais
  declarada, porque os scripts de mockup precisam deles para reprocessar.
- No mesmo passo, tire as chaves do registro de imagens e atualize o `PROMPTS-IMAGENS.md`. Chave
  apontando para arquivo ausente passa despercebida porque o fallback esconde.
- Pastas em minúsculas e nomes sem espaço nem acento.
