# Desenhos que explicam

Receitas de desenho animado para abertura, etapas, capacidades e prova. As regras gerais (repouso
final, pausa fora da tela, movimento reduzido, tokens) estão em `animacao.md`.

## Método

1. **Liste em verbos o que a seção precisa explicar**: "o pedido trava na aprovação", "o rascunho
   vira tela", "a IA lê a nota e preenche". Cada verbo vira um gesto de desenho, não um parágrafo.
   O desenho é literal ao verbo: etapa de "entender o que perguntam" ganha uma lupa que procura.
2. **Escolha a escala.** Home: mini-diagrama SVG de um gesto por etapa. Página dedicada: tela de
   exemplo interativa por etapa, em HTML.
3. **Desenhe o estado final parado** e confira que ele sozinho conta a história.
4. **Escolha o motor** (tabela em `animacao.md`).
5. **Escreva a timeline em porcentagem do ciclo**, com o estado final ocupando a maior parte;
   paradas nos extremos quando há comparação.
6. **Ligue as proteções**: observador de visibilidade, `document.hidden`, movimento reduzido
   reativo, clique assume o controle, altura fixa do palco, `aria-hidden` no desenho e legenda viva.
7. **Mobile**: desenho ao lado do texto quando empilhar dobraria a altura; lista de escolhas vira
   grade de botões curtos acima do palco; `hover: none` chega no estado "aceso". Elemento de marca
   (selo, desenho) fica **igual** ao do desktop; reduza de tamanho, nunca de conteúdo.
8. **Verifique** a 400 px e a 360 px, com movimento reduzido emulado, com JS desligado, e grave o
   vídeo para o usuário.

Os dados do desenho (etapas, cartões, anotações, posições por breakpoint) ficam em `src/content`; o
componente só anima. Todo arquivo animado abre com um comentário dizendo o que o desenho explica e
por que se move assim.

## 1. Traço que se desenha

Explica direção e continuidade: fio entre etapas, curva que sobe, a marca se desenhando.

```tsx
<path d="..." pathLength={100} className="desenha" />
```

```css
.desenha { stroke-dasharray: 100; stroke-dashoffset: 0; }                  /* repouso: desenhado */
.js-reveal [data-reveal] .desenha { stroke-dashoffset: 100; }
.js-reveal [data-reveal].is-in .desenha {
  stroke-dashoffset: 0; transition: stroke-dashoffset 1.5s var(--ease-traco) .15s;
}
```

- `pathLength={100}` normaliza o caminho: nada de medir `getTotalLength` nem chutar comprimento.
- Elemento que remonta (dentro de carrossel) usa `@keyframes` na montagem, com
  `animation-delay: var(--atraso-traco, .25s)`, porque o observador não o vê.
- Traço decorativo que cruza texto nasce transparente onde passa sobre o título
  (`linearGradient` com opacidade 0 até 30% da largura). Não reposicione à mão.

## 2. Mini-diagrama de etapa em laço lento

Explica cada etapa de um processo em um gesto, antes de o texto ser lido. É o padrão da home.

Moldura única, num componente compartilhado (`ui/Diagrama.tsx`), nunca copiada por arquivo:

```tsx
export function Mini({ children }: { children: React.ReactNode }) {
  return (
    <svg viewBox="0 0 120 56" className="h-14 w-[7.5rem]" fill="none" strokeWidth="1.2"
         strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{children}</svg>
  )
}
export const ordem = (i: number) => ({ '--i': i }) as React.CSSProperties
```

Cor: traço claro fraco para estrutura, acento só no que importa, âmbar só para gargalo real.

Vocabulário de peças:

| Classe | Gesto | Entrada | Laço (escopado por `#secao`) |
|---|---|---|---|
| `mini-peca` | peça chega | opacity .55 s, atraso `--i × 90ms + 150ms` | 13 s: some de 0 a 4%, visível de 12 a 86%, some de 96 a 100% |
| `mini-vira` | tracejado de rascunho fecha em contorno | `stroke-dasharray: 3 3` para `90 0` | 13 s |
| `mini-vai` | cartão atravessa colunas até "no ar" | `translateX(0)` para `var(--vai)` .95 s | 11 s: chega aos 38%, fica até 82% |
| `desenha` | fio ou curva | receita 1 | 15 s: desenha até 22%, parado até 90%, recua rápido |
| `mini-anel` | ponto pulsando | `scale 1 → 2.4`, `opacity .55 → 0`, 2,8 s | desacelera para 4,6 s |

```css
.js-reveal #metodo [data-reveal].is-in .mini-peca {
  animation: metodo-peca 13s ease-in-out infinite;
  animation-delay: calc(var(--i, 0) * 120ms + var(--reveal-delay, 0ms) * 15);
}
@keyframes metodo-peca { 0%, 4% { opacity: 0 } 12%, 86% { opacity: 1 } 96%, 100% { opacity: 0 } }
```

- A seção leva `data-laco`: fora da tela o laço pausa (`animacao.md`, revelação por rolagem). `.is-in`
  sozinho nunca sai, e o laço rodaria para sempre.
- `--reveal-delay` do item (0, 80, 160, 240 ms) × 15 dá 1,2 s entre etapas: um sinal que atravessa.
- Tracejado que vira contínuo: escreva o contínuo como lista (`90 0`), senão a transição pisca.
- `transform` num `<g>` SVG anda em unidades do `viewBox`.
- `transform-box: fill-box; transform-origin: center` (ou `bottom`) para escalar em volta da forma.

Gestos que funcionaram: fila de caixas com a terceira em âmbar acumulando traços (gargalo);
retângulos tracejados fechando contorno (rascunho vira tela); kanban com cartão atravessando até
"no ar"; curva subindo com anel no topo (evolução); lupa varrendo três linhas e parando
de 52% a 88% do ciclo na linha certa (entender o que perguntam); a mesma tarefa acendendo em cinco
dias (repetição); a linha do jeito antigo não chega ao fim, a do piloto chega aos 36% do ciclo
(ganho); ponto que
passa por uma pessoa com anel de conferência antes da caixa (aprovação humana); barras de horas
caindo (economia).

## 3. Máquina de passos: a história que se conta sozinha

Explica um trabalho do começo ao fim: áudio vira pedido lançado, nota vira conta a pagar, pergunta
vira número. Serve para hero de IA e para palco de capacidades.

```tsx
const TICK = 650
const FIM = 13                                   // o último passo segura a tela pronta
const [estado, setEstado] = useState({ atual: 0, passo: 0 })
const reduz = useReduzMovimento()                // hooks em animacao.md
const visivel = useVisivel(ref, 0.35)            // no hero: useVisivel(ref, 0.2, true)
const abaVisivel = useAbaVisivel()

useEffect(() => {
  if (reduz || !visivel || !abaVisivel) return
  const t = setInterval(() => setEstado((e) => e.passo < FIM
    ? { ...e, passo: e.passo + 1 }
    : { atual: manual ? e.atual : (e.atual + 1) % HISTORIAS.length, passo: 0 }), TICK)
  return () => clearInterval(t)
}, [reduz, visivel, abaVisivel, manual])

const p = reduz ? FIM : estado.passo
const surge = (quando: number) => clsx('transition-[opacity,transform] duration-500',
  p >= quando ? 'translate-y-0 opacity-100' : 'translate-y-1.5 opacity-0')
```

- Um número só controla tudo; cada peça é função pura de `p`. A história recomeça limpa na troca e o
  movimento reduzido recebe a tela pronta.
- Roteiro típico: 0 a 4 a entrada sendo lida; 4 a 6 a IA trabalhando; 7 a 9 os campos do resultado
  chegam um por passo; 10 status "aguardando aprovação"; 11 "aprovado"; 12 e 13 segura.
- Toda história de IA termina com uma pessoa aprovando. Mostre a tarefa, nunca robô ou cérebro
  brilhando.
- Troca de história: `key={historia.id}` remonta e roda a entrada.
- Palco com altura fixa; legenda da vez em `aria-live`; pontos `role="tab"`.
- Indicador do tempo até a próxima: linha de 1 px crescendo sob o item ativo, só no desktop.

Micro-gestos:

| Gesto | Como |
|---|---|
| Áudio sendo ouvido | duas ondas sobrepostas; a de cima com `clip-path: inset(0 X% 0 0)` e transição linear igual ao `TICK` |
| Documento sendo lido | faixa em gradiente descendo (com `translateY`); as linhas que viram campo acendem |
| Digitação | palavra por palavra com `opacity` e atraso distribuído; as palavras ocupam o espaço desde o início |
| Marca-texto | `<mark>` com fundo do acento quando `p >= n` |
| Esqueleto vira dado | barra cinza troca pelo valor com entrada curta |
| Clique fantasma | um passo antes de mudar o estado, o botão fica `scale-95` |
| Barras crescendo | `scaleY(0 → 1)` com `origin-bottom` e atraso `i × 90ms` |
| Lista reordenada | linhas `absolute` com `translateY(índice × altura)`; muda só o índice |

## 4. Protótipo que vira software (mesmo DOM, dois estados)

Explica "o que você aprova no protótipo é exatamente o que vai para o ar".

- Um DOM só. Cada elemento recebe uma classe de papel: `morf-t` (texto), `morf-dot` (avatar),
  `morf-tag`, `morf-btn`, `morf-box`, `morf-bar`.
- `data-estado="rascunho"` muda só aparência, nunca tamanho:
  - texto vira contorno do tamanho exato: `color: transparent; box-shadow: inset 0 0 0 1px`;
  - avatar e imagem viram o X de "imagem aqui": dois `linear-gradient` a 45° e -45°;
  - caixa fica tracejada, barra fica oca.
- **Linguagem de concepção, nunca de carregamento.** Barra cinza cheia parece skeleton. Rascunho
  tem papel pontilhado, contorno, X, rótulo "rascunho 2 · tela inicial" e anotações numeradas.
- Cada anotação descreve **o bloco exato que vira** e aponta para ele em cada breakpoint
  (`--topo` e `--topo-cel` medidos), senão o texto do protótipo não bate com o resultado.
- Acabamento em escada de cima para baixo (`transition-delay: calc(var(--i) * 55ms)`, .55 s);
  voltar ao rascunho é reset rápido (.3 s, sem escada).
- Quando o acabamento chega, nada se move: só `color`, `background-color`, `border-color`,
  `box-shadow` e `opacity` transitam.
- Timeline: entrou na tela, rascunho, 900 ms, pronto por 6,5 s, rascunho por 1,5 s, repete. Saiu
  da tela, limpa os timers. Clique em "Protótipo" ou "No ar" fixa o estado.
- Prop `ativo` quando vive dentro de um palco: estar na janela não basta.
- Dados de exemplo marcados: "Tela de exemplo, dados fictícios".

## 5. Palco preso na rolagem, uma tela por etapa

Explica o processo completo na página dedicada.

```tsx
const faixa = desktop ? '-48% 0px -48% 0px' : '-72% 0px -14% 0px'   // faixa de leitura
// recrie o observador quando cruzar min-width: 1024px
```

- Duas colunas no desktop: palco `sticky` e etapas com `lg:min-h-[82vh]`. No celular o palco gruda
  no alto (`top` abaixo do cabeçalho) e a faixa de leitura desce.
- **Todas as telas montadas**, cruzando opacidade; a da vez recebe `ativo`, as outras
  `aria-hidden` e `pointer-events-none`:

```tsx
'absolute inset-0 transition-[opacity,transform,filter] duration-[650ms]',
n === etapa ? 'translate-y-0 scale-100 opacity-100 blur-0'
            : 'pointer-events-none translate-y-4 scale-[0.985] opacity-0 blur-[2px]'
```

- Trilha "Etapa 01 · Título" em `aria-live`, traços clicáveis que rolam até a etapa
  (`block: 'center'` no desktop, `'start'` no celular) e `scroll-mt` para a etapa não ficar sob o
  palco.
- Moldura comum para todas as telas (título, "Tela de exemplo, dados fictícios", fio): faz parecerem
  o mesmo software.
- Telas que funcionaram: fluxo com travas em âmbar que abrem uma a cada 3,4 s e custo semanal
  contando; protótipo que vira software (receita 4); quadro de entregas andando por um contador;
  painel com números contando e barras crescendo, com alternância "Este mês / No trimestre".
- Texto expansível dentro da etapa dimensiona a fatia ativa, senão vaza sobre a seguinte.

## 6. Vitrine de camadas flutuando (hero de quem vende soluções)

Explica "construímos estes tipos de solução", com a tela dentro de aparelho real.

- Composição fixa repetida em todas as cenas: etiqueta específica da cena no alto à direita,
  aparelho encostado na base, cartão de resultado sobrevoando embaixo à esquerda. Encaixes em
  constantes. Se tudo flutua sem regra, fica inconsistente.
- Janela de navegador só no que é tela de desktop; app, notificação e fluxo flutuam soltos.
- Uma moldura por composição: texto da abertura direto na faixa, sem cartão com borda competindo
  com a janela da vitrine.
- Camada sobreposta contrasta em valor com o que cobre (cartão escuro sobre tela clara). Sombra
  sozinha não separa duas camadas da mesma cor.

```tsx
<div className="camada absolute ..." style={{ '--atraso': `${atraso}ms` } as React.CSSProperties}>
  <div className={orbita ? 'orbitando' : 'flutuando'}
       style={{ '--dur': dur, '--fase': fase, '--amp': amp, '--rx': rx, '--ry': ry } as React.CSSProperties}>
```

- Flutuar: sobe e desce 5 a 7 px em 8,5 a 10,5 s. Orbitar: elipse de 6 a 9 px em 11 a 15 s. Fase
  negativa diferente por camada para não subirem em bloco. Entrada: aparelho 0, celular 200,
  resultado 280, etiqueta 520 ms.
- Cena troca a cada 6 s com `key={atual}`; pausa com cursor ou foco; para fora da tela e na aba
  oculta.
- Tela sem vazio: fluxo sem resultado não prova nada. Acrescente o resultado (nota lançada,
  responsável, valor).
- Legenda: "Telas de exemplo, com dados fictícios, do tipo de solução que construímos". Prova com
  cliente real fica nos cases.
- Aparelho e tela viva: `mockups.md`.

## 7. Antes e depois com varredura

Explica o site velho (ou a falta de site) virando o novo, no computador e no celular juntos.

- "Depois" embaixo, "antes" por cima com `clip-path: inset(0 X 0 0)`. O fio de 3 px fica na borda
  esquerda de um embrulho `absolute inset-0` que anda de `translateX(100%)` a `translateX(0)` no mesmo
  keyframe (porcentagem do fio sozinho andaria só 3 px).
- Keyframe de 12 s com paradas nos extremos, onde a leitura acontece: 0 a 16% antes inteiro, 46 a
  62% depois inteiro, 92 a 100% volta. Rótulos "antes" e "depois" fora da tela, cruzando opacidade no
  mesmo ciclo.
- Mesmo keyframe no notebook e no celular: uma cortina só atravessando a composição.
- Só o quadro visível anima; o de trás e o movimento reduzido ficam metade de cada lado, com os dois
  rótulos.
- Carrossel de histórias troca a cada 12 s, o tempo de uma varredura. Público duplo = uma história
  por público alternando (quem não tem site; quem tem site velho), não um desenho que tenta cobrir os
  dois.
- Tela "antes" é caricatura em HTML (serifa, sublinhado, "Copyright © 2014"), nunca print de
  cliente.

## 8. Página rolando dentro do cartão

Prova de site entregue: a página inteira descendo e subindo em miniatura, desktop e celular juntos.
Receita de captura e cálculo em `imagens.md`.

## 9. Laços ambientes pequenos

| Laço | Uso | Receita |
|---|---|---|
| Pulso de anel | "está vivo", "no ar" | `scale 1 → 2.4`, `opacity .55 → 0` até 70%, 2,4 s; em SVG com `fill-box` |
| Pulso no fio | dado andando | embrulho com a largura do fio, filho com `translateX(0 → 100%)`, fade nas pontas, 3,6 s linear |
| Selo girando | assinatura da marca | texto em `textPath` circular, rotação de 28 s |
| Faixa de marcas | prova social | dois grupos idênticos, `translateX(-50%)`, 40 a 44 s linear, máscara nas bordas, pausa em `:hover`, `:focus-within` e fora da tela (`data-laco`), cópia `aria-hidden` com `alt=""`; movimento reduzido quebra linha e esconde a cópia |
| Linha que cresce no hover | item de lista clicável | `scale-x-0 → 100` a partir da esquerda em 500 ms; seta anda 4 px |
| Número que conta | painel | rAF 850 ms, `1 - (1 - t)^3`, `toLocaleString('pt-BR')` |
| Título riscado | "onde a gente não entra" | pseudo-elemento `scaleX(0 → 1)` .7 s, uma vez |
| Detalhe que abre | `<details>` de case | corpo entra `translateY(-6px)` .45 s ao abrir; fechar é instantâneo |
