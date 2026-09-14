# Identidade e layout

## O sistema já existe

Antes de escolher cor ou fonte, procure no repositório: `tailwind.config`, `globals.css` com
`@theme`, tema do Flutter (`color_schemes.dart`), logo em `assets/`. O site precisa parecer a mesma
empresa que a plataforma. Reaproveite a cor de marca e a fonte de interface.

Referência visual anexada pelo usuário com seção nomeada ("copie a hero desta imagem") é para
**reproduzir a composição** (grade, sobreposição, hierarquia, ritmo) com o design system do cliente,
não inspiração solta. Declare na entrega "imagem X → seção Y". Tipografia e cor continuam as do
cliente: identidade é uma decisão por site.

## Plano curto, antes de codar

Escreva em poucas linhas e mostre ao usuário:

- **Cores**: tokens por papel (abaixo).
- **Tipografia**: fonte de título e texto, fonte utilitária para número e etiqueta.
- **Layout**: uma frase sobre a grade e o ritmo das seções.
- **Personalidade**: **um** elemento tirado da própria marca (a forma do logo como marcador de
  lista, um fio que atravessa o processo, um selo).
- **Fundos**: a sequência por página e onde as faixas escuras entram.
- **Desenho por seção**: o que cada seção mostra além do texto (`animacao.md`).

## Tokens por papel

```css
:root {
  --paper: #ffffff;        /* fundo */
  --mist: #f1f5f3;         /* fundo alternado, puxado para o acento */
  --mist-deep: #e6ece9;
  --line: #dfe6e2;         /* régua */
  --line-strong: #c8d3ce;
  --ink: #041414;          /* título e faixa escura */
  --ink-soft: #0b2622;
  --body: #3d4c48;         /* texto corrido */
  --muted: #5c6a66;        /* apoio */
  --accent: #2bb38b;       /* acento cheio */
  --accent-deep: #0d5c47;  /* acento para texto pequeno */
  --accent-wash: #e8f5f0;  /* acento lavado */
  --r-sm: 6px; --r-md: 14px; --r-lg: 24px;
  --shell: 1240px; --gutter: 24px;                 /* 40px a partir de 768px */
}
```

Os hex são da marca; a estrutura por papel é a regra. No Tailwind 4, exponha por `@theme inline`
(`bg-paper`, `text-muted`, `rounded-md`); componente nunca escreve hex.

- **Neutro com viés**: cinza puro parece descuido. Puxe todos os neutros para o acento.
- **Acento claro ganha par "deep"** para texto pequeno sobre branco (o verde cheio não passa 4.5:1).
- **Cor com significado**: verde, âmbar e vermelho só para estado real. Acento da marca não é cor
  de status; âmbar só para gargalo ou atenção de verdade.
- `themeColor` do viewport na cor da faixa escura.

## Tipografia

| Classe | Declaração | 400 px | 1440 px |
|---|---|---|---|
| `.t-display` (h1) | `clamp(2.25rem, 4.4vw, 3.75rem)`, peso 600, lh 1.02, tracking -0.035em | 36 px | 60 px |
| `.t-h2` | `clamp(2rem, 4.4vw, 3.5rem)`, lh 1.06, tracking -0.032em | 32 px | 56 px |
| `.t-h3` | `clamp(1.375rem, 2.2vw, 1.875rem)`, lh 1.14 | 22 px | 30 px |
| `.t-lead` | `clamp(1.0625rem, 1.35vw, 1.25rem)`, lh 1.6 | 17 px | 19 px |
| `.t-meta` | mono .75rem, sem caixa alta | 12 px | 12 px |

- O mínimo do `clamp` é o que evita h1 de três linhas em 360 px.
- **Classe tipográfica própria declara cor dentro de `@layer components`.** Fora de camada, no
  Tailwind 4, ela vence `text-white/60` e o texto de apoio sai escuro sobre faixa escura.
- Largura de linha por `ch`: h1 15 a 18ch, h2 14 a 20ch, apoio 46 a 52ch, resposta de FAQ 68ch.
- Quebra de linha escolhida só no desktop: `<br className="hidden sm:block" />`.
- Valor com unidade usa espaço inseparável (`R$ 360 mil`).
- `next/font` com `variable`, `display: "swap"` e só os pesos usados.

## Densidade no celular

O celular usa cerca de **metade do respiro vertical do desktop**. Quanto menos a pessoa rola, mais
cedo ela decide.

| Elemento | Celular | Desktop |
|---|---|---|
| Seção comum | 48 px (`py-12`) | 96 a 128 px (`md:py-24`, `lg:py-32`) |
| Hero | 40 px | 80 a 96 px |
| Título da seção até o conteúdo | 32 px | 56 a 64 px |
| Item de lista com régua | 20 a 24 px | 28 px |
| Margem lateral | 24 px | 40 px |
| Botão | 44 px de altura | 44 px |
| Botão em menu e barra fixa | 52 px | |

- Nunca `py-24` sem prefixo. O espaçamento de seção vive num componente (`Faixa`) ou num token
  (`--secao-y`), nunca repetido à mão em cada página: ritmo cortado por pessoas diferentes fica
  irregular, e respiro irregular incomoda mais que espaço sobrando.
- Ao reduzir, mexa só no valor base e mantenha o `md:`; confira elementos absolutos que dependiam do
  padding.
- **Largura crítica é 360 px** (Android comum), não 400.
- **Grade 2x2 no celular** só para item curto: ícone, título de até 5 palavras e uma frase curta, ou
  rótulo de 2 a 3 palavras. Sem caixa (régua de 1 px entre células) ou caixa sem borda. Parágrafo
  continua em lista. Opções de formulário em duas colunas só se todas têm até 20 caracteres.
- **Desenho ao lado do texto** quando empilhar dobraria a altura (`grid-cols-[7.5rem_minmax(0,1fr)]`).
- **Encolher em vez de esconder**: mídia de prova e elemento de marca aparecem no celular.
- Ação principal de ferramenta ou landing fica **fixa embaixo** no celular (`componentes.md`).

## Ritmo de fundos

- Vizinhas nunca com o mesmo fundo. **O rodapé conta como seção.**
- Uma faixa escura no meio (processo, método, resultado) e o fecho em **cartão colorido sobre papel**,
  com margem de papel embaixo, quando o rodapé é escuro. Chamada final escura colada no rodapé escuro
  parece rodapé gigante.
- Exceções aceitas: a abertura seguida da primeira lista no mesmo fundo quando a lista é continuação
  dela; faixa fina com régua.
- Ao reordenar seções, confira a alternância de novo.
- Duas caixas escuras parecidas fazendo papéis diferentes em páginas diferentes confundem sem a
  pessoa saber dizer por quê.

## Composição

- **Uma moldura por composição.** Cartão com borda no texto e janela na vitrine ao lado viram dois
  cartões competindo.
- **Camada sobreposta contrasta em valor** com o que cobre. Sombra sozinha não separa duas camadas da
  mesma cor.
- **Hierarquia por papel**: borda, preenchimento, raio e sombra custam atenção. Use no bloco que
  precisa se destacar, não em todos.
- **Números grandes** só quando o número é o argumento e foi verificado.
- Textura sem gradiente roxo: pontilhado de 30 px em opacidade baixa (`grain`), brilho radial discreto
  do acento no canto.
- Decoração que atravessa texto se esmaece no traço, não se reposiciona à mão.
- Elemento de marca (selo, desenho, curva) é **igual no celular**. "Adaptar para o celular" nunca
  autoriza empobrecer; reduza o tamanho, não o conteúdo.
- Verbo de layout ambíguo ("abarcar", "abraçar") pede a mudança mínima, ou pergunta.

## Ícones próprios

Emoji é proibido em qualquer texto do site (JSX, conteúdo, metadata, `alt`, prompt de API). Ícone é
SVG, e site de empresa que vende tecnologia ou design tem **conjunto próprio**, não biblioteca
genérica.

- Uma grade (24), um traço (1.6), pontas e junções arredondadas, `currentColor`, `aria-hidden`, a
  mesma geometria do logo. Diagramas usam uma segunda grade fixa (120×56, traço 1.2).
- Registro por nome tipado, para o conteúdo referenciar por string:

```tsx
const base = { viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', strokeWidth: 1.6,
  strokeLinecap: 'round', strokeLinejoin: 'round', 'aria-hidden': true } as const
const ICONES = { busca: IconeBusca, codigo: IconeCodigo /* ... */ }
export type NomeIcone = keyof typeof ICONES
export function Icone({ nome, className }: { nome: NomeIcone; className?: string }) {
  const C = ICONES[nome]; return <C className={className} />
}
```

- Entre Server e Client Component, passe o **nome** do ícone, nunca o componente (erro
  "Functions cannot be passed directly to Client Components").
- Setas, check e play também entram no registro. Sem SVG solto dentro de componente.
- Remova do `package.json` a biblioteca de ícones que sobrar.
- Marca de terceiro (WhatsApp, lojas, redes) usa o desenho oficial, sem redesenho.

### Favicon e logo derivado

- Renderize as candidatas em 512, 64, 32 e 16 px e escolha pelo que fica legível em 16 px (a aba).
  Detalhe bicolor e ponto somem em 16 px.
- Fundo preenchido pede cantos arredondados (raio perto de 23%). `apple-icon.png` **sem**
  arredondar: o iOS aplica a máscara.
- Logo de produto derivado (ferramenta, módulo) = símbolo universal do conceito (pino, mapa dobrado,
  rota) mais o traço da marca, nessa ordem. Teste de 16 a 120 px, no claro e no escuro.
- `useId()` dentro de `url(#...)` precisa de `.replace(/[^\w-]/g, '')`.

## Marcas e credibilidade técnica

- Faixa de clientes: laço contínuo, cinza em repouso, cor no hover, versão negativa onde o contraste
  não passa (`imagens.md`).
- Stack por **disciplina** (web, mobile, backend, dados, nuvem, devops, observabilidade, segurança,
  qualidade, IA), com ferramentas de mercado de logo oficial em cada uma. Ferramenta de mercado que a
  empresa domina pode entrar mesmo sem projeto ativo; "não invente" vale para fato sobre cliente, não
  para o vocabulário de mercado. Não escreva "tudo aqui roda hoje em projeto nosso" se não roda.
- Marca de peso sozinha não diferencia: junte **práticas verificáveis** (homologação, deploy contínuo,
  revisão, testes, migração versionada, monitoração).
- A stack mora na página de processo, não na home: na home ela rouba a cena.

## Acessibilidade que não é opcional

- Contraste 4.5:1 em texto corrido; 3:1 em texto grande e em ícone que carrega sentido.
- Foco visível (`:focus-visible` com contorno de 3 px) **sem `border-radius` na regra global**: raio
  forçado deforma pílula e campo. Seção escura troca a cor do foco (`.on-ink`).
- Ordem de títulos sem pulo (`h1` único por página, depois `h2`, `h3`).
- Toque de 44 px mínimo.
- "Pular para o conteúdo" no topo.
- `aria-live` em painel que muda sozinho; `aria-hidden` no que é só decoração.
