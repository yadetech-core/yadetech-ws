# Mockups de aparelho com tela viva

Print colado numa moldura de CSS parece protótipo. Pedir à IA o mockup com a interface dentro faz o
modelo redesenhar a tela, com letra trocada: o mockup mente. O caminho que funciona:

- **o aparelho é só moldura**: PNG gerado por IA com a tela furada (transparente);
- **a tela continua HTML** atrás do furo, nítida em qualquer zoom e animada;
- **os cantos são medidos por script**, e a tela entra por escala (aparelho de frente) ou por
  homografia (aparelho em ângulo).

Scripts anexos: `scripts/mockup-vazado.py`, `scripts/medir-furo.py`, `scripts/homografia.ts`.

## 1. Pedir o mockup

### Contrato do prompt

1. Tela preenchida com **uma cor chapada `#FF00FF`**, que não aparece em mais nada da imagem.
2. **Sem brilho, reflexo ou gradiente na tela**: reflexo impede o recorte.
3. **Foco nítido no aparelho inteiro**: desfoque serrilha a borda do furo.
4. **Fundo branco chapado**, sem mesa, chão, sombra projetada, mão ou planta.
5. **Sem marca**: sem maçã, logo na tampa ou texto.
6. **Corpo grafite escuro**: aparelho prata sobre branco faz o script comer a moldura.
7. Proporção do **aparelho real**, não a do espaço no site ("a IA gera um celular atarracado").
8. Peça 3 ou 4 variações.

A cor de croma vai **onde a geometria precisa ser exata**: na tela, para aparelho. Para pessoa
recortada é o contrário: magenta no fundo, porque branco come camisa clara (`imagens.md`).

### Prompt base (monitor de frente)

```
Studio product photograph of a modern unbranded 27-inch desktop monitor on a slim aluminium stand,
seen perfectly straight on in pure front view, with no rotation, no tilt and no perspective: the
screen is an exact rectangle with perfectly straight edges and 90-degree corners. Dark graphite
body, very thin bezels, 16:9 screen. The screen is filled with one single flat uniform pure magenta
color (#FF00FF), completely solid: no content, no icons, no wallpaper, no gradient, no reflection,
no glare, no glass shine. Isolated on a seamless pure white (#FFFFFF) background, no desk, no
floor, no cast shadow, no props, no hands, no plants, no keyboard, no mouse. Even soft studio
lighting, no harsh specular highlights on the bezel. Sharp focus across the entire device, no depth
of field blur. The whole monitor and its stand fully inside the frame with generous empty margin
around it. No logos, no brand marks, no text anywhere, no watermark.
```

Variações, trocando só o aparelho e o ângulo:

- **Tablet de frente**: "10-inch tablet in landscape orientation, no stand".
- **Celular de frente**: "modern smartphone with thin even bezels, portrait, no notch visible on the
  magenta area". Meça pelo `medir-furo.py` se os cantos forem muito arredondados.
- **Perspectiva mansa**: "rotated about 15 degrees around its vertical axis, so the right edge of the
  screen is further from the camera", "camera exactly at screen height, dead level", "long lens
  (about 100mm equivalent)", "The screen must remain a clean flat quadrilateral with perfectly
  straight edges and sharp corners", "must occupy at least 75 percent of the frame height and at least
  70 percent of the frame width".
- **Notebook**: "lid open at about 92 degrees", "camera no more than 5 degrees above the screen".
  Tampa reclinada e câmera alta abrem o teclado e encolhem a tela.

### Escolha do aparelho, por conta e não por gosto

| Aparelho | Tela útil na largura do arquivo | Quando |
|---|---|---|
| Monitor ou tablet de frente | cerca de 98% | tela densa (painel, tabela), espaço pequeno |
| Notebook de frente | cerca de 77% | desktop com espaço, quando o notebook conta a história |
| Notebook em três quartos | cerca de 59% | só com tela de pouco texto e espaço largo |
| Notebook visto de cima | pior caso | não use |

- Perspectiva até uns 15°, e só em tela esparsa: o texto amolece na borda que se afasta.
- No celular do visitante, o celular do mockup é medido contra o aparelho de referência (filho do
  notebook), não contra o palco, senão fica maior que o notebook a 400 px.
- Hero de site: notebook e celular juntos mostram as duas versões.

### Conferir a geração

Descarte a variação com borda de tela curva, canto arredondado demais, moldura assimétrica, duas
fileiras de teclado, reflexo na tela, sombra no fundo ou marca. **Escolha pela retidão das arestas
da tela, não pela beleza.** Guarde o arquivo cru em `assets/imagens-site-originais/`, fora de
`public/`.

O ChatGPT entrega em tamanhos fixos, qualquer que seja o pedido de resolução (lista em
`imagens.md`). Para moldura exibida a 500 ou 600 px CSS, basta.

## 2. Recortar e medir

```bash
sips -s format png gerado.jpg --out gerado.png        # se não veio PNG
python3 scripts/mockup-vazado.py assets/imagens-site-originais/gerado.png public/images/mockup-monitor-v1.png
```

Saída:

```
public/images/mockup-monitor-v1.png  1138x809
  tl: 0.879% , 0.989%
  tr: 98.946% , 0.989%
  br: 98.946% , 73.424%
  bl: 0.879% , 73.300%
  tela média: 1116x585 px  (proporção 1.906)
```

O que o script faz, sem dependência (só biblioteca padrão do Python, cerca de 4 s por imagem):

1. máscara da tela por croma (`r-g > 40 and b-g > 40`), que pega também o pixel meio magenta da
   borda;
2. engorda o furo 1 px, para o HTML cobrir a franja rosa;
3. fundo por enchente a partir das bordas (limiar 232), para não furar reflexo claro dentro do
   aparelho;
4. recorta no aparelho;
5. cantos por diagonais extremas (`tl` menor x+y, `br` maior x+y, `tr` maior x-y, `bl` menor x-y);
6. alfa: transparente com RGB preto (o navegador mistura vizinhos ao reduzir) e borda clara
   **desmisturada do branco** (`c' = (c - 255·(1-f)) / f`), senão vira halo claro no fundo escuro.

Mockup que já chegou transparente:

```bash
python3 scripts/medir-furo.py public/images/mockup-celular-v1.png
#   tela: { left: '4.430%', top: '1.777%', width: '90.981%', height: '96.445%' }
```

Não converta o PNG da moldura para WebP à mão: o `next/image` serve WebP com alfa a partir do PNG
(AVIF só com `images.formats`). Não meça com o `medir-furo.py` o que saiu do `mockup-vazado.py`: o
furo engordado dá números um pouco diferentes; use os cantos impressos. Trocou o PNG, meça de novo e suba a versão do nome (`-v2`).

## 3. Descrever o mockup no código

```ts
export type Ponto = { x: number; y: number }
export type Mockup = {
  src: string; w: number; h: number                    // PNG recortado
  tela?: { left: string; top: string; width: string; height: string }   // de frente, em %
  quad?: [Ponto, Ponto, Ponto, Ponto]                  // em ângulo: tl, tr, br, bl em %
  logico: { w: number; h: number; raio: number }       // tamanho em que a tela é desenhada
  tamanhos: string                                     // sizes do next/image, medido no palco
  prioridade?: boolean                                 // aparelho da primeira tela (LCP)
}
```

- **De frente**: `left = tl.x`, `top = tl.y`, `width = tr.x − tl.x`, `height = média(bl.y − tl.y,
  br.y − tr.y)`.
- **Em ângulo**: `quad` com os quatro cantos exatamente como impressos.
- **`logico`**: largura 1000 e `h = 1000 / proporção` impressa (monitor 1.906 dá 1000×524).
  Celular no tamanho real do app, 390×846, com `raio` acompanhando o canto da tela.
- **`tamanhos`**: medido no navegador, não chutado ("207 px no desktop, 143 px no celular" vira
  `'(min-width: 640px) 210px, 145px'`).
- **`prioridade`**: o aparelho da abertura carrega com `priority`. Nunca `loading="lazy"` no
  elemento de LCP.

## 4. Pintar a tela atrás do furo

```tsx
'use client'

export function Superficie({ mockup, children }: { mockup: Mockup; children: React.ReactNode }) {
  const raiz = useRef<HTMLDivElement>(null)
  const [caixa, setCaixa] = useState({ w: 0, h: 0 })
  useEffect(() => {
    const el = raiz.current
    if (!el) return
    const ro = new ResizeObserver(([e]) => setCaixa({ w: e.contentRect.width, h: e.contentRect.height }))
    ro.observe(el)
    return () => ro.disconnect()
  }, [])

  const { logico, quad, tela } = mockup
  const projecao = quad && caixa.w
    ? matrizParaQuadrilatero(logico.w, logico.h,
        quad.map((p) => ({ x: (p.x / 100) * caixa.w, y: (p.y / 100) * caixa.h })) as Quadrilatero)
    : null
  const escala = tela && caixa.w ? ((parseFloat(tela.width) / 100) * caixa.w) / logico.w : 0
  const transformacao = quad ? projecao : escala ? `scale(${escala})` : null

  const conteudo = (
    <div className="absolute left-0 top-0 origin-top-left overflow-hidden"
         style={{ width: logico.w, height: logico.h, borderRadius: logico.raio,
                  transform: transformacao ?? undefined,
                  visibility: transformacao ? 'visible' : 'hidden' }}>
      {children}
    </div>
  )
  return (
    <div ref={raiz} className="relative" style={{ aspectRatio: `${mockup.w} / ${mockup.h}` }}>
      {quad ? <div className="absolute inset-0 overflow-hidden">{conteudo}</div>
            : <div className="absolute overflow-hidden" style={tela}>{conteudo}</div>}
      <Image src={mockup.src} alt="" aria-hidden="true" width={mockup.w} height={mockup.h}
             sizes={mockup.tamanhos} priority={mockup.prioridade}
             className="pointer-events-none relative block h-full w-full select-none" />
    </div>
  )
}
```

- Container com `aspect-ratio` do PNG: sem salto de layout.
- **O PNG vem por cima e o conteúdo por trás**: se a escala errar por um fio, vaza o fundo escuro, não
  uma borda clara.
- `transform-origin: 0 0` obrigatório, e o conteúdo no tamanho lógico exato usado na conta.
- `matrizParaQuadrilatero` (em `scripts/homografia.ts`) resolve as oito incógnitas por Gauss e
  devolve `matrix3d`. Devolve `null` para quadrilátero degenerado: não pinte.
- Antes da primeira medida o conteúdo tem 1000 px sem escala: `visibility: hidden` até existir
  transformação, e `overflow-hidden` no embrulho para nada vazar. É a exceção aceita à regra "nada
  depende de JS para aparecer": sem JS o aparelho aparece com a tela escura, então o aparelho não
  pode ser o único lugar onde a proposta está escrita. O h1 e o texto da abertura carregam a mensagem.
- Confira no Safari do iPhone: perspectiva com `matrix3d` é onde navegador de celular mais falha.

### Desenhar a tela lógica

- Unidades em px lógicos (`text-[20px]`, `px-[34px]`): tudo é reduzido depois. O texto nasce no
  tamanho de app de verdade e nada é reduzido duas vezes.
- `sm:` e `md:` dentro da tela reagem ao viewport, não ao aparelho. Não use breakpoint dentro da tela
  lógica.
- Rótulos e legendas fora da tela: dentro, reduzidos, ficam ilegíveis.
- Cromo desenhado junto: barra de navegador com URL fictícia, barra de status do celular em SVG.
- Print também serve dentro do aparelho: `next/image fill` com `object-cover object-left-top` e
  `sizes` igual à largura lógica.
- Tela de produto real: especificação extraída do código (`imagens.md`, telas reais).

## 5. Composição com o resto da página

- Aparelho encosta na base do palco; etiqueta e cartão de resultado são camadas (`explicadores.md`,
  vitrine).
- Antes e depois dentro de dois aparelhos sincronizados: `explicadores.md`, receita 7.
- Legenda "Telas de exemplo, com dados fictícios" sempre que a tela não é de cliente.

## Armadilhas

| Armadilha | Sintoma | Como evitar |
|---|---|---|
| Mockup pedido com a interface dentro | letra trocada, interface inventada | aparelho como moldura, tela em HTML atrás do furo |
| Tela com reflexo ou gradiente | recorte falha, mancha sobre o conteúdo | "flat uniform #FF00FF, no glare, no glass shine" |
| Desfoque de profundidade | furo serrilhado | "sharp focus across the entire device" |
| Aparelho prata sobre branco | enchente come a moldura | "dark graphite body" |
| Sombra projetada | mancha cinza opaca no PNG | "no cast shadow" e conferir antes |
| Qualquer roxo ou rosa no aparelho | entra na máscara da tela | conferir a geração; regerar |
| Notebook com câmera alta | tela pequena, teclado enorme | tampa a 92°, câmera no nível, lente longa; ou monitor |
| Perspectiva forte em tela densa | texto mole na borda | até 15° e tela esparsa |
| Perspectiva ajustada a olho com `rotateY` | cantos não batem | homografia exata com os cantos do script |
| Celular posicionado contra o palco | celular maior que o notebook a 400 px | aninhar no aparelho de referência |
| Pedir 2400 px ao ChatGPT | vem em tamanho fixo menor (`imagens.md`) | planejar para esse tamanho |
| Original movido junto na limpeza | não dá para reprocessar | originais em pasta declarada, fora de `public/` e fora da lixeira |
