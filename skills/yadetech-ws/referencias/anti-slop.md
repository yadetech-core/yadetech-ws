# Revisão anti "AI slop"

Passe esta lista antes de mostrar a página. Cada item tem o que fazer no lugar.

Anti-slop não é minimalismo. Tirar o enfeite genérico não autoriza deixar a seção só com texto: o que
entra no lugar é o desenho específico do negócio, animado (`animacao.md`). Página limpa e muda também
tem cara de IA.

## Texto

| Tirar | Colocar |
|---|---|
| Rótulo em MAIÚSCULAS sobre todo título ("COMO FUNCIONA") | o título sozinho, ou rótulo curto em caixa normal com o elemento da marca |
| Título picotado de efeito ("Nem todo clique vale. Veja o caminho.") | título que diz o assunto ("Como um clique é validado") |
| Travessão (—) no meio da frase | vírgula, dois-pontos ou ponto |
| "Não é X, é Y", "mais do que um Z", "X, não Y" em série | a afirmação direta |
| Título e apoio repetindo a mesma ideia | título afirma, apoio acrescenta informação nova com verbo |
| Três adjetivos em fila; "simples, rápido e seguro" | um fato verificável |
| "Descubra", "Transforme", "Eleve", "Potencialize" | o verbo do que acontece |
| Emoji como marcador | ícone próprio em SVG, ou nada |
| Número decorativo (01 / 02 / 03) em lista sem ordem | numerar só sequência real |
| Número bonito sem origem ("+300% de eficiência") | compromisso verificável, ou nada |
| Bloco de oito parágrafos explicando capacidades | uma linha por capacidade e a prova ao lado |
| Hero que fala com um público só quando há dois | uma história por público no desenho |
| Substantivo sem verbo ("Tempo e dinheiro.") | frase com sujeito e verbo |

## Layout

| Tirar | Colocar |
|---|---|
| Tudo virou card com borda, raio e sombra iguais | borda só no que precisa se separar; o resto respira |
| Grade 2×2 de cards com parágrafo | lista ou definição (2×2 sem caixa segue válida para item curto no celular, `design.md`) |
| Fundo verde, vermelho ou amarelo preenchendo o card de status | fundo neutro, cor no título e no ícone |
| Ícone dentro de círculo colorido em todo item | ícone só onde ele distingue |
| Ícone de biblioteca genérica | conjunto próprio com a geometria da marca |
| Selo falso sobre foto ("+1 clique", "REC" piscando), campo de busca que não busca | a foto limpa, ou interface verdadeira |
| Trio de bullets com bolinha embaixo do título | nada, ou uma frase |
| Herói de 100vh | altura do que ele contém |
| Gradiente roxo-azul, vidro fosco, sombra colorida forte | cor sólida da marca, textura discreta |
| Rótulo mono em caixa alta em cada bloco (procure `uppercase` no CSS) | texto normal, tamanho menor |
| Duas molduras lado a lado (cartão do texto + janela da vitrine) | uma moldura por composição |
| Wireframe feito de barras cinza cheias | contorno, X de imagem, anotação (barra cheia é skeleton de carregamento) |
| Robô, cérebro brilhando, circuito para falar de IA | a tarefa acontecendo, com uma pessoa aprovando |
| Seção só com título e parágrafo | o desenho do que o parágrafo explica |
| Logos com caixa branca atrás | logo sem margem, cinza em repouso, negativo onde precisar |

## Imagem

| Tirar | Colocar |
|---|---|
| Foto encaixada porque havia espaço | só imagem que prova algo naquela frase |
| Pessoa gerada apresentada como a equipe | tela real, trabalho real, ou pessoa real |
| Foto institucional com cara de um setor | cenário neutro; setor só no case |
| Mockup com interface desenhada pela IA | moldura com tela viva em HTML |

## Prova de fogo

- Trocando o logo e as fotos, a página poderia ser de qualquer empresa? Falta o específico do negócio:
  termos reais, telas reais, o desenho do processo real.
- Alguma seção existe só para preencher? Corte.
- Dois blocos dizem a mesma coisa com palavras diferentes? Junte.
- O texto promete algo que o produto não faz? Corrija antes de publicar.
- Alguma seção de processo ou abertura ficou parada? Desenhe.

## Como aplicar

Faça a passagem em uma leva: reescreva o conteúdo nos arquivos de `src/content`, ajuste os componentes e
o CSS, e só então rode os tipos, as capturas e `scripts/varrer-projeto.sh`. Revisar item a item espalha
a inconsistência.

Substituição em massa por script (regex, fatia de string) tem dois riscos que já quebraram site:
`\b` casa depois de `:` e gera `md:mt-8 md:mt-12` na mesma classe; `s[:ini] + novo` sem `+ s[fim:]`
trunca o resto do arquivo. Copie `src` para o scratchpad antes, confira o `diff` e rode um verificador
de classe duplicada no mesmo breakpoint.
