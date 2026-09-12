# Conteúdo e arquitetura de páginas

## Separação

- `src/content/*.ts` guarda texto e dados (FAQ, jornadas, etapas de diagrama).
- `src/content/site.ts` guarda link, contato, domínio e flags. Campo vazio não aparece na página.
- Páginas só montam componentes. Nada de texto solto espalhado em JSX quando ele se repete.

Ganho concreto: mudou uma regra na plataforma, você edita um arquivo e o site inteiro acompanha.

## Estrutura típica

| Página | Papel |
|---|---|
| Home | o que é, para quem, como funciona, prova, dúvidas mais comuns |
| Uma por público | jornada completa, regras, simulação, FAQ do público |
| FAQ | fonte única de parâmetros e regras, com busca |

Cada página abre com o problema de quem chega, não com a empresa.

## A seção vende, o FAQ detalha

Seção de página é argumento: um conceito, poucos passos, uma frase por passo e uma ação no fim.
Número solto, exceção e prazo tiram a força do argumento e envelhecem: mande tudo para o FAQ, que
é a fonte única. Se a seção precisa de quatro parágrafos para se explicar, ela virou documentação
no lugar errado.

## Escrita

- Frase curta, voz ativa, verbo no presente. "Você recebe", não "o recebimento é efetuado".
- Título diz o assunto, não faz suspense. Sem travessão, sem frase picotada de efeito.
- Um número por parágrafo, no máximo. Número sem consequência é ruído.
- Texto de botão descreve o que acontece ao clicar.
- Erro e limitação aparecem com naturalidade: quem lê confia mais no site que admite o limite.

## FAQ como espinha dorsal

- Agrupe por público e por tema; cada pergunta com `id` estável (vira âncora e link de suporte).
- Resposta em blocos: parágrafo, lista, parágrafo. Sem parede de texto.
- Em página de público, mostre 6 perguntas e um botão para expandir todas no mesmo lugar.
- A resposta longa mora no FAQ; a página só resume. Isso evita repetição contraditória.

## Diagramas explicam melhor que parágrafo

Quando o processo tem lados e ordem, desenhe: raias (quem faz o quê), linha do tempo (etapas),
teste interativo (o que passa e o que é barrado). O diagrama precisa carregar informação real,
com os mesmos termos do produto, e funcionar com teclado.
