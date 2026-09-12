# Movimento

Animação existe para mostrar relação e ordem. Se a página fica igual com ela desligada, ela era
enfeite.

## Regras

1. **Estado de repouso visível.** O HTML chega legível. A revelação por rolagem é aplicada na
   hidratação, e só no que está abaixo da dobra. Nada nasce com `opacity: 0` esperando observador:
   sem JS, com erro de hidratação ou num print, o conteúdo tem que estar lá.
2. **`prefers-reduced-motion` sempre.** Quem pede menos movimento vê o estado final direto, sem
   animação infinita. Uma regra global que zera durações não basta para `infinite`: desligue com
   `animation: none`.
3. **Só `transform` e `opacity`** no que anima em scroll ou em laço. `width`, `top` e `box-shadow`
   custam layout e pintura.
4. **Duração curta**: 150 a 400 ms em resposta a clique; até 900 ms em entrada de bloco. Escada de
   atraso entre irmãos de 60 a 90 ms, com teto (6 itens), senão o último demora demais.
5. **Laço infinito** só em elemento decorativo pequeno (um pulso, uma onda). Nunca em texto que
   alguém precisa ler.
6. **Cancelamento**: animação disparada por navegação ou por troca de aba precisa ser
   interrompível. Evite prender a rolagem da página.

## Padrões que funcionam

- **Revelação por rolagem**: uma lista central de seletores num componente cliente, com
  `IntersectionObserver`. Para animar um bloco novo, acrescente o seletor. Não espalhe atributo
  pelas páginas.
- **Troca de painel**: entra deslizando poucos pixels na direção do movimento (avançar para a
  esquerda, voltar para a direita).
- **Número que muda**: interpole o valor exibido e deixe o texto para leitor de tela com o valor
  final, via `aria-live`.
- **Diagrama**: o fio entre etapas se desenha com `stroke-dashoffset`; o pulso viaja com
  `animateMotion`. Desenhe em pixels reais, não em viewBox esticado, senão o traço sai errado.

## Armadilhas

- `scroll-behavior: smooth` global conflita com a rolagem que o framework faz na troca de página.
- Captura de tela automatizada trava em elemento que nunca para de se mover: capture a área por
  recorte, não o elemento.
- Animação que muda altura empurra o resto da página. Reserve o espaço.
