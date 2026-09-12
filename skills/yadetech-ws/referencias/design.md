# Identidade e layout

## O sistema já existe

Antes de escolher cor ou fonte, procure no repositório: `tailwind.config`, `index.css` com
`@theme`, tema do Flutter (`color_schemes.dart`), logo em `assets/`. O site precisa parecer a
mesma empresa que a plataforma. Reaproveite a cor de marca e a fonte de interface; guarde a fonte
de display só para os títulos.

## Plano curto, antes de codar

Escreva em 5 linhas:

- **Cores**: 4 a 6 valores com papel (papel, tinta, névoa, acento, escuro, semânticas).
- **Tipografia**: fonte de título, fonte de texto, fonte utilitária para números e rótulos.
- **Layout**: uma frase sobre a grade e o ritmo das seções.
- **Personalidade**: **um** elemento que só este site tem (uma moldura, um diagrama, um gesto).
- **Fundo das seções**: a alternância (branco, tom claro, escuro) e onde as escuras entram.

## Regras de composição

- **Neutro com viés**: cinza puro parece descuido. Puxe o neutro levemente para o acento.
- **Ritmo de fundo**: nunca duas seções seguidas com o mesmo fundo. Faixas escuras bem separadas,
  tipicamente uma no meio e outra no fim.
- **Cor com significado**: verde, âmbar e vermelho só para estado real (aprovado, ajuste, recusa).
  Acento da marca não é cor de status.
- **Hierarquia por papel**: borda, preenchimento, raio e sombra custam atenção. Use no bloco que
  precisa se destacar, não em todos.
- **Números grandes** só quando o número é o argumento.
- **Tokens**: cor, raio e espaçamento vivem em variáveis CSS no `:root`. Componente não inventa
  valor solto.

## Acessibilidade que não é opcional

- Contraste 4.5:1 em texto corrido; 3:1 em texto grande e em ícone que carrega sentido.
- Foco visível em tudo que recebe teclado (`:focus-visible` com contorno de 3 px).
- Ordem de títulos sem pulo (`h1` único por página, depois `h2`, `h3`).
- Toque de 44 px mínimo em botão e item de menu.
- `aria-live` em painel que muda sozinho; `aria-hidden` no que é só decoração.
