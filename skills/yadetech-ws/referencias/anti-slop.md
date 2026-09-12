# Revisão anti "AI slop"

Passe esta lista antes de mostrar a página. Cada item tem o que fazer no lugar.

## Texto

| Tirar | Colocar |
|---|---|
| Rótulo em maiúsculas sobre todo título ("COMO FUNCIONA", "DICAS") | o título sozinho |
| Título picotado de efeito ("Nem todo clique vale. Veja o caminho.") | título que diz o assunto ("Como um clique é validado") |
| Travessão (—) no meio da frase | vírgula, dois-pontos ou ponto |
| "Não é X, é Y" e "mais do que um Z" | a afirmação direta |
| Três adjetivos em fila; "simples, rápido e seguro" | um fato verificável |
| "Descubra", "Transforme", "Eleve" | o verbo do que acontece |
| Emoji como marcador de seção | ícone da biblioteca do produto, ou nada |
| Número decorativo (01 / 02 / 03) em lista sem ordem | numerar só sequência real |

## Layout

| Tirar | Colocar |
|---|---|
| Tudo virou card com borda, raio e sombra iguais | borda só no que precisa se separar; o resto respira |
| Grade 2×2 de cards de texto | lista, definição ou tabela |
| Fundo verde/vermelho/amarelo preenchendo o card de status | fundo branco, cor no título e no ícone |
| Ícone dentro de círculo colorido em todo item | ícone só onde ele distingue |
| Selo falso sobre foto ("+1 clique", "REC" piscando) | a foto limpa |
| Trio de bullets com bolinha embaixo do título | nada, ou uma frase |
| Herói de 100vh | altura do que ele contém |
| Gradiente roxo-azul, vidro fosco, sombra colorida forte | cor sólida da marca |
| Rótulo mono em maiúscula em cada bloco | texto normal, tamanho menor |

## Prova de fogo

- Trocando o logo e as fotos, a página poderia ser de qualquer empresa? Então falta o específico
  do negócio: termos reais, números reais, o desenho do processo real.
- Alguma seção existe só para preencher? Corte.
- Dois blocos dizem a mesma coisa com palavras diferentes? Junte.
- O texto promete algo que o produto não faz? Corrija antes de publicar.

## Como aplicar

Faça a passagem em uma leva: reescreva o conteúdo nos arquivos de `src/content`, ajuste os
componentes afetados e o CSS, e só então rode os tipos e as capturas. Revisar de item em item
espalha a inconsistência.
