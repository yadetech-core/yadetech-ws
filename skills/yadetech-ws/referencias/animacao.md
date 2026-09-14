# Movimento

Melhor do que ler é ver. Site de empresa que vende tecnologia ou serviço é julgado pelo que
mostra funcionando: toda abertura e toda seção de processo têm um desenho que se move e explica.
Contenção não é ausência. O que se corta é o enfeite sem assunto (brilho, gradiente, pisca), nunca
o desenho que conta como a coisa funciona.

As receitas de cada tipo de desenho estão em `explicadores.md`.

## Onde o movimento é obrigatório

| Lugar | O que precisa ter |
|---|---|
| Hero de toda página de oferta | representação animada do que se compra: aparelho com tela viva, história em passos, antes e depois |
| Seção de processo, etapas, "como funciona" | um mini-diagrama animado por etapa (home) ou uma tela de exemplo por etapa (página dedicada) |
| Lista de capacidades ou possibilidades | palco que conta cada uma acontecendo, com o visitante escolhendo |
| Prova de site ou produto entregue | a página rolando em miniatura, a tela real, o vídeo sob demanda |
| Faixa de marcas | laço contínuo lento, cinza em repouso |

Seção que ficou só com título e parágrafo precisa de justificativa. Texto sozinho explicando
sequência é falha.

## Regras

1. **Repouso é o quadro final.** O CSS base de cada peça descreve o último estado do desenho; a
   animação só existe dentro do seletor ativado (`.is-in`, `[data-ativo]`, `.js-reveal`). Sem JS, com
   movimento reduzido, numa captura ou para um robô, o desenho aparece completo e diz a mesma coisa.
   Escreva primeiro o desenho parado e completo; depois anime a chegada até ele.
2. **Nada nasce invisível esperando JS.** A revelação por rolagem só entra com a classe
   `js-reveal` no `<html>`, posta na hidratação e só sem `prefers-reduced-motion`. O que já está na
   primeira tela recebe `is-in` na hora. **O h1 da abertura nunca fica dentro de `data-reveal`**:
   atrasa o LCP.
3. **Nada essencial depende de medida em JS para aparecer.** Reserve o espaço por CSS
   (`aspect-ratio`) em tudo que mede antes de pintar. Exceção aceita: a tela viva dentro do aparelho
   espera a medida (`mockups.md`), por isso a mensagem da abertura nunca mora só nela.
4. **Processo continua.** Diagrama de etapa segue em laço lento depois de visto: ciclo de 8 a 15 s,
   cerca de 70% do ciclo parado no estado final, reconstrução num instante de uns 10%. Durações
   diferentes por peça (11, 13, 15 s) para não recomeçarem juntas. Escada entre etapas para o sinal
   atravessar uma a uma. O redesenho é o instante, não a regra, senão a seção pisca.
5. **Nada anda sem ser visto.** Todo `setInterval`, `setTimeout` e laço roda só com o elemento na
   tela (`IntersectionObserver` sem `unobserve` quando o laço precisa parar depois) e com
   `!document.hidden`. Laço CSS depende de um atributo ligado e desligado pelo observador, ou usa
   `animation-play-state: paused` fora de cena.
6. **Quem clicou manda.** Troca automática para no primeiro clique ou toque e não volta sozinha.
   Cursor em cima pausa a troca, não a história da vez. Um nome só para esse estado no projeto
   (`manual`).
7. **Movimento reduzido de verdade.** CSS: a regra global
   `*, *::before, *::after { animation: none !important; transition-duration: .01ms !important }`
   (com `!important`, senão perde para a classe animada) só funciona porque o repouso é o quadro final. Laço que precisa de outro estado parado
   (faixa de marcas quebra linha e esconde a cópia; antes e depois fica metade de cada) ganha regra
   própria. JS: hook reativo com `useSyncExternalStore` sobre `matchMedia`; a história recebe o
   último passo (`p = FIM`). framer-motion não obedece ao CSS: envolva com
   `<MotionConfig reducedMotion="user">`.
8. **Propriedades.** Em laço e em rolagem: `transform`, `opacity` e, em SVG pequeno,
   `stroke-dashoffset`, `stroke-dasharray` e `clip-path`. Nunca `left`, `top`, `width`, `height` ou
   `flex-grow` em laço: use `translate`. Transição única de estado pode mexer em `flex-grow`.
9. **Escopo.** Laço aplicado a classe compartilhada fica sob o `#id` da seção
   (`.js-reveal #metodo [data-reveal].is-in .mini-peca`), senão vaza para outros desenhos.
10. **Entrada e laço em elementos separados.** Duas animações no mesmo `transform` brigam: o pai
    entra, o filho flutua.
11. **Altura reservada.** Palco que troca de conteúdo tem altura fixa por breakpoint. Nada empurra
    a página.
12. **Acessibilidade do desenho.** Ilustração animada inteira com `aria-hidden`; uma legenda em
    texto com `aria-live="polite"` diz o que acontece na vez. Número que conta entrega o valor final
    no HTML. Seletor de histórias usa `role="tab"` com `aria-label`.

## Revelação por rolagem

```tsx
// RevealProvider, montado uma vez no layout e reexecutado a cada pathname
useEffect(() => {
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return
  document.documentElement.classList.add('js-reveal')
  const io = new IntersectionObserver((es) => es.forEach((e) => {
    if (e.isIntersecting) { e.target.classList.add('is-in'); io.unobserve(e.target) }
  }), { rootMargin: '0px 0px -8% 0px', threshold: 0.08 })
  document.querySelectorAll('[data-reveal]').forEach((el) => {
    if (el.getBoundingClientRect().top < innerHeight * 0.92) el.classList.add('is-in')
    else io.observe(el)
  })
  return () => io.disconnect()
}, [pathname])
```

```css
[data-reveal] { opacity: 1; }
.js-reveal [data-reveal] { opacity: 0; transform: translateY(18px); }
.js-reveal [data-reveal].is-in {
  opacity: 1; transform: none;
  transition: opacity .62s var(--ease-saida), transform .62s var(--ease-saida);
  transition-delay: var(--reveal-delay, 0ms);
}
```

Atraso em escada por um helper (`atraso(i, 80, 6)` devolve `{ '--reveal-delay': '...' }`), nunca
número solto em cada arquivo. O observador só vê o que estava no DOM na navegação: o que remonta
(troca de slide) anima na montagem.

A revelação acontece uma vez (`unobserve`), mas laço não pode rodar para sempre fora da tela. Um
segundo observador, sem `unobserve`, liga e desliga `data-em-cena` nas seções com laço:

```tsx
const io = new IntersectionObserver((es) => es.forEach((e) =>
  e.target.setAttribute('data-em-cena', String(e.isIntersecting))))
document.querySelectorAll('[data-laco]').forEach((el) => io.observe(el))
```

```css
[data-em-cena="false"] *, [data-em-cena="false"] { animation-play-state: paused !important; }
```

Vale para mini-diagramas em laço, página rolando no cartão, faixa de marcas, vitrine flutuante.

Hooks que os componentes com JS usam, em `src/lib/movimento.ts`:

```ts
const PEDE_PARADO = '(prefers-reduced-motion: reduce)'
export function useReduzMovimento() {
  return useSyncExternalStore(
    (aviso) => { const mq = matchMedia(PEDE_PARADO); mq.addEventListener('change', aviso)
      return () => mq.removeEventListener('change', aviso) },
    () => matchMedia(PEDE_PARADO).matches, () => false)
}
export function useAbaVisivel() {
  return useSyncExternalStore(
    (aviso) => { document.addEventListener('visibilitychange', aviso)
      return () => document.removeEventListener('visibilitychange', aviso) },
    () => !document.hidden, () => true)
}
export function useVisivel(ref: React.RefObject<Element | null>, limiar = 0.35, inicial = false) {
  const [visivel, setVisivel] = useState(inicial)            // true no hero, que já nasce na tela
  useEffect(() => {
    const el = ref.current
    if (!el) return
    const io = new IntersectionObserver(([e]) => setVisivel(e.isIntersecting), { threshold: limiar })
    io.observe(el)
    return () => io.disconnect()
  }, [ref, limiar])
  return visivel
}
```

## Qual ferramenta

| Situação | Escolha |
|---|---|
| Entrada de bloco, traço que se desenha, diagrama com sequência fixa | CSS disparado pela revelação |
| Diagrama que continua depois de visto | CSS `infinite` dentro do seletor ativado, escopado por `#secao` |
| História com passos que dependem uns dos outros | JS: um número de passo `p` num intervalo; cada peça é função pura de `p` |
| Dois estados do mesmo DOM (rascunho e pronto) | JS troca `data-estado`; o visual é CSS |
| Palco que acompanha a leitura | `IntersectionObserver` com `rootMargin` em faixa |
| Número que conta | `requestAnimationFrame` com easing cúbico, partindo do valor anterior |
| Interação por proximidade do cursor | `pointermove` + rAF escrevendo variável CSS; cor com `color-mix` |
| Componente que desmonta com saída animada (formulário em etapas) | framer-motion `AnimatePresence`, só nessa página |
| Repetir uma entrada CSS | trocar a `key` do elemento |

framer-motion não entra na home por conveniência: pesa no INP e ignora o CSS de movimento reduzido.

## Tokens

Guarde como variáveis CSS e use pelo nome.

| Nome | Curva | Uso |
|---|---|---|
| `--ease-saida` | `cubic-bezier(0.22, 1, 0.36, 1)` | entrada, revelação, camadas, troca de palco, barras |
| `--ease-traco` | `cubic-bezier(0.33, 1, 0.68, 1)` | traço que se desenha, fio |
| `--ease-vaivem` | `cubic-bezier(0.65, 0, 0.35, 1)` | deslocamento em laço com paradas (lupa, varredura) |
| linear | | faixa de marcas, rotação, pulso no fio, transição que acompanha o passo |

| Faixa | Duração |
|---|---|
| Resposta a hover e clique | 200 a 320 ms |
| Mudança de estado, troca de aba | 300 a 500 ms |
| Entrada de bloco | 450 a 720 ms (revelação 620 ms) |
| Entrada longa, cartão que atravessa | 800 a 950 ms |
| Troca de palco | 650 ms |
| Contagem de número | 850 ms |
| Traço que se desenha | 1,1 a 1,5 s |
| Pulso de "está vivo" | 2,4 a 2,8 s |
| Flutuar e orbitar | 7 a 15 s |
| Laço de etapa | 8 a 15 s |
| Antes e depois, carrossel de histórias | 12 s |
| Ambiente longo (página rolando, selo girando, marcas) | 16 a 44 s |
| Passo de máquina de passos (`TICK`) | 600 a 650 ms |
| Troca automática de vitrine | 6 s |

Escadas: 50 a 90 ms entre irmãos, com teto de 4 a 6 itens. Peças dentro de um desenho: `--i × 90 a
140 ms` mais 150 a 250 ms de folga. Entre etapas em laço: cerca de 1,2 s. Keyframe de laço: entrada
de 0 a 12%, estado final de 12 a 18% até 82 a 90%, saída curta no fim.

O estado que é a promessa fica mais tempo que o anterior: rascunho 1,5 s, pronto 6,5 s.

## Home enxuta, página detalhada

- Na home, cada etapa é uma frase curta e um mini-diagrama de um gesto.
- A página dedicada (`/como-trabalhamos`, `/processo`) tem o palco preso na rolagem, uma tela de
  exemplo interativa por etapa e o texto completo.
- O conteúdo sai do mesmo arquivo: `curto` para a home, `resumo` e `detalhe` para a página.
- Copy recebida com "ao ver em detalhe" separa as duas coisas. Não aplique o detalhe na home e não
  remova seção da home sem confirmar.

## Mostrar ao usuário

Pedido de animação só é entregue depois de visto rodando. Grave um vídeo curto da seção (receita
em `verificacao.md`) e mande com `SendUserFile`, junto das capturas em repouso.

## Armadilhas

| Armadilha | Sintoma | Como evitar |
|---|---|---|
| Revelação só na entrada | "falta animação": quem chega depois não vê nada se mexer | desenho de processo em laço lento (regra 4) |
| `IntersectionObserver` em SVG de altura quase zero ou em camada que remonta a cada slide | traço nunca aparece | animar na montagem (`@keyframes` com atraso) |
| `position: fixed` dentro de ancestral com `transform` | botão "fixo" anda com o bloco | elemento fixo fora de qualquer bloco animado |
| Dev server servindo CSS velho | "a animação não está no ar" | comparar o CSS servido com o fonte antes de medir (`verificacao.md`) |
| Troca de painel com crossfade de 2 px | ninguém percebe a troca | a tela que sai desce, encolhe 1,5% e desfoca, em 650 ms |
| Texto "digitado" com `clip-path` | segunda linha cortada | revelar palavra por palavra com `opacity`, espaço reservado desde o início |
| SVG com `preserveAspectRatio="none"` | traço engorda ou afina | `vectorEffect="non-scaling-stroke"`, ou barras em `div` |
| `scroll-behavior: smooth` global | troca de página abre no meio | `data-scroll-behavior="smooth"` no `<html>` |
| Captura de elemento que nunca para | Playwright estoura o tempo | recorte por área, ou contexto com `reducedMotion: 'reduce'` |
| Colisão medida numa captura só | camada que orbita cobre o título em algum instante | amostrar posições a cada 250 ms por um ciclo e achar o pior instante |
| `hashchange` e `matchMedia` sem remoção no cleanup | ouvinte duplicado a cada navegação | remova no retorno do efeito |
| Entrada amarrada à montagem num palco com todas as telas montadas | barras já prontas quando a tela aparece | amarrar a entrada a `ativo` (key ou `data-ativo`) |
