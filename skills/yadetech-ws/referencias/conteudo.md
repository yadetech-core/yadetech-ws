# Conteúdo e arquitetura de páginas

## Posicionamento antes de estrutura

Escreva o posicionamento numa frase e confirme com o usuário antes de desenhar menu e páginas: "a
empresa X vende Y para Z; site é um dos serviços". Opção de múltipla escolha inventada por você
("duas frentes com peso igual") não vira arquitetura sem essa confirmação. O posicionamento mora num
dado único (`site.ts`), não espalhado em componentes.

## Separação

- `src/content/*.ts` guarda texto e dados. Um arquivo por domínio (`servicos`, `cases`, `faq`) e um
  por landing, com blocos nomeados na ordem da página (`ABERTURA`, `POR_QUE`, `COMO`, `PROVA`,
  `DUVIDAS`, `FECHO`).
- `src/content/site.ts` guarda nome, domínio, contatos (WhatsApp em três formatos: número, URL com
  mensagem e rótulo), `NAV` com descrição curta por item e as constantes perecíveis.
- Páginas só montam componentes.
- **Relação por id, não por cópia**: serviço lista `perguntasRelacionadas: string[]` e
  `casesRelacionados`; landing aponta `DUVIDAS` para ids do FAQ.
- **Constante única para o que é perecível ou repetido**: preço de entrada, CTA principal, rota e nome
  da ferramenta de captação. Renomear uma rota espalhada em 15 strings é como a regra quebra.
- **Contagem derivada dos dados**: "quatro plataformas" escrito à mão vira mentira quando entra o
  quinto case. Use `CASES.length`, ou não conte.
- **Dado separado da apresentação**: fatos do case num objeto, manchete, cor e imagem do cartão em
  outro, mesclados numa lista. Ordem editorial por página derivada no componente, sem mexer na lista.
- Campo que ainda não existe fica vazio e não aparece (nome do fundador, CNPJ). Nunca um valor
  inventado para preencher.
- Catálogo usado por prompt de IA vem do mesmo arquivo do site: nome escrito à mão no prompt diverge.

## Menos texto: uma redação, duas densidades

```ts
export type Texto = string | { curto: string; extra: string }

export function Trecho({ t }: { t: Texto }) {
  if (typeof t === 'string') return <>{t}</>
  return <>{t.curto}<span className="hidden md:inline"> {t.extra}</span></>
}
export const soCurto = (t: Texto) => (typeof t === 'string' ? t : t.curto)          // alt, title
export const inteiro = (t: Texto) => (typeof t === 'string' ? t : `${t.curto} ${t.extra}`)
```

- `curto` é frase completa sozinha, que vale para todos e cabe no celular. `extra` é **uma frase a
  mais**, só no desktop, nunca a continuação da mesma frase.
- Nada some do HTML: o buscador lê o texto inteiro.
- Se o `curto` sozinho vira promessa sem prova, reescreva em vez de dividir. Se o `extra` sustenta
  algo verificável, fica no desktop; se só repete o que a seção mostra, sai.

Medidas que funcionaram:

| Campo | Tamanho |
|---|---|
| Corpo a 400 px | **no máximo 3 linhas** por bloco (títulos e FAQ fora da régua) |
| `curto` | até ~15 palavras (mediana), teto 28 |
| `extra` | uma frase, até ~25 palavras |
| Título de item | até 5 palavras |
| Título de seção | 4 a 9 palavras |
| h1 | 6 a 10 palavras |
| Texto de apoio | uma frase de até ~15 palavras no celular |

Meça antes de cortar (`verificacao.md`): altura de cada bloco de texto dividida pela altura de linha.

## Escrita

- Frase curta, voz ativa, verbo no presente. "Você recebe", não "o recebimento é efetuado". Tom:
  "você", "sua empresa", "a gente".
- **Título diz o assunto**, sem ponto final, em caixa normal. Varie a abertura: uma dúzia de títulos
  começando com "O que..." cansa.
- **Título afirma, apoio acrescenta** informação nova com verbo. Leia a manchete acima antes de
  escrever a faixa de baixo; "X, não Y" em série soa como charada.
- Nomeie o objeto concreto ("o software perfeito para a sua empresa não existe pronto", não "o que a
  sua empresa precisa").
- **Capacidade se menciona em uma linha e se mostra.** A explicação mora junto da prova, não num
  bloco de oito parágrafos antes dela.
- Um número por parágrafo, no máximo, e só verificado. Onde não há número verificado, use
  compromisso que aparece em contrato ("escopo escrito antes", "código no seu repositório").
- Texto de botão descreve o que acontece: "Falar com a gente", "Abrir o site", "Ver o case da X".
- Erro e limite aparecem com naturalidade ("O que a gente não vende como IA").
- Nome de isca ou ferramenta nunca sugere defeito no cliente ("diagnóstico" sugere que algo está
  errado; "mapa de possibilidades" mostra o que está na mesa).
- Tese sobre terceiros (empresas citadas como exemplo) leva nome e fonte verificada na fonte
  primária. Esconder os nomes deixa a seção abstrata; citar sem conferir arrisca afirmar errado.

## Vocabulário da marca

Palavra banida ou exigida pelo cliente ("nunca 'sistema', sempre 'solução'") vira regra escrita no
`CLAUDE.md` do projeto, com escopo explícito: JSX, conteúdo, metadata, `alt` e prompts de API.

- Troca em uma leva, com concordância de gênero ("o sistema novo" vira "a solução nova"), e a
  alternativa para o que o cliente já usa ("ferramenta", o nome dela).
- Slug que continha a palavra ganha redirect permanente.
- Avise o impacto de SEO: se a palavra banida é o termo mais buscado, leve o volume ao usuário
  (`seo-conteudo.md`).
- Varredura antes da entrega: `scripts/varrer-projeto.sh . <palavra>`.

## A seção vende, o FAQ detalha

Seção de página é argumento: um conceito, poucos passos, uma frase por passo, um desenho e uma ação.
Número solto, exceção e prazo vão para o FAQ, que é a fonte única. Seção que precisa de quatro
parágrafos virou documentação no lugar errado.

## Home enxuta, página detalhada

- Home: o que é, para quem, prova visual, processo em mini-diagramas, cases, dúvidas mais comuns.
- O detalhe de cada tema mora na página própria, com link "Ver o processo em detalhe".
- Copy longa recebida para uma seção separa resumo (home) e detalhe (página própria).
- Não remova nem substitua seção existente da home sem confirmar.

## Mapa de seções por tipo de página

Fundos: P papel, N névoa, T tinta, C cartão colorido sobre papel.

Os mapas abaixo são os do site de uma software house (Yadetech). Servem de exemplo de ordem e ritmo;
itens marcados com * dependem do negócio.

### Home de empresa de serviço digital (exemplo)

| # | Seção | Fundo |
|---|---|---|
| 1 | Hero: h1, apoio curto, CTA principal, âncora "O que a gente faz", vitrine animada | T |
| 2 | Faixa de diferenciais (4 itens curtos, 2x2 no celular, sem número não verificado) | P |
| 3 | Tese com desenho* (ex.: protótipo que vira software) + faixa de marcas no pé | P, separada da faixa 2 por régua |
| 4 | Serviços em lista com ícone próprio | N |
| 5 | Cases em destaque | P |
| 6 | Sites entregues rolando* (se vende site) | N |
| 7 | Processo em mini-diagramas animados | T |
| 8 | Chamada no meio da página (cartão com pessoa recortada) | C |
| 9 | Práticas de engenharia verificáveis* | P |
| 10 | Dois caminhos: "ainda não sei o que preciso" (ferramenta) e "já sei" (contato) | N |
| 11 | Dúvidas (6 perguntas + "Ver todas") | P |
| 12 | Chamada final (opcional na home, que já tem a do item 8) | C |

Ordem de fim de página: ... → Dúvidas → Chamada final → rodapé. Na home, que já tem chamada no meio,
o FAQ pode ser a última seção antes do rodapé.

### Serviço individual

Abertura com rótulo = categoria e **h1 = a situação do cliente** (o nome do serviço fica no rótulo e
no `<title>`) → Quando faz sentido (sinais) N → O que entra na entrega P → Como o projeto anda T →
Onde já foi construído N (só com cases) → Dúvidas P (só com perguntas) → Chamada final C.

Serviço com página própria (IA → `/ia`) fica fora da rota genérica e ela faz `permanentRedirect`.

### Landing de anúncio (ex.: `/sites`, `/ia`)

Hero com proposta, prova animada e CTA → Por que importa (3 itens) → Como é feito (etapas com
desenho, T) → Possibilidades (grade curta, cada item com "ver exemplo") → Prova (cases recolhidos em
`<details>`) → Fecho T → Dúvidas N → Chamada final C.

A ordem é para quem não conhece a empresa: primeiro o que muda, depois como é feito, só então os
trabalhos no ar.

### Case individual

Abertura com logo do cliente, categoria, h1 = tagline, resumo e mídia principal → O problema e o que
construímos N → O que a plataforma faz P → Por dentro (galeria no tamanho real, vídeo) N → O que
mudou T → Próximo case P → Chamada final C.

### Sobre

h1 **com o nome da empresa** → Contexto com fontes linkadas T → O que a empresa propõe P → Vídeo do
fundador (só se o arquivo existe) → Preço de entrada (constante única) N → Como pensamos o trabalho P
→ Chamada final C. Pessoa com nome e rosto (`seo-conteudo.md`).

### Processo (`/como-trabalhamos`)

Abertura → Palco preso com uma tela por etapa P → O que precisamos do seu lado N → Stack por
disciplina* P → Vale para todo projeto T → Chamada final C.

### FAQ, Contato, 404

- FAQ: um bloco por grupo alternando N e P, título do grupo `sticky` no desktop, `FAQPage` só aqui.
- Contato: canais (WhatsApp com mensagem pronta, e-mail, ferramenta) → O que ajuda contar → O que
  acontece depois → **chamada final em cartão**, nunca seção escura encostada no rodapé escuro.
- 404: "Esta página não existe mais", "O endereço pode ter mudado de nome", botão para o início e a
  `NAV` inteira com descrições.

## Landing de anúncio x página institucional

| Aspecto | Institucional | Landing de anúncio |
|---|---|---|
| Quem chega | já está no site | vem do anúncio, não conhece a empresa |
| Abertura | cabeçalho de página: rótulo, h1 do assunto, apoio | hero: benefício, subtítulo, prova animada na mesma tela |
| h1 | assunto da página | **benefício que o cliente quer** ("Seu próximo cliente está procurando agora") |
| Chips, tags, rótulo acima do h1 | opcional | não; só título e subtítulo |
| CTA na abertura | opcional, contorno | obrigatório: WhatsApp principal + âncora para a prova |
| Público duplo | seções separadas | uma história por público alternando no desenho; o detalhe de cada um nas seções abaixo |
| Prova | em outra página | na própria página, recolhida em `<details>` |
| Breadcrumb visual | não | não |

- Toda página interna abre **direto na hero**, sem breadcrumb visual. A trilha fica no JSON-LD.
- Landing com menu inteiro tem seis saídas contra "uma página, um objetivo": leve ao usuário a opção
  de cabeçalho só com marca e botão, e meça o funil.

## Links que prometem destino

- "Ver exemplo" abre **o exemplo exato**, testado por clique até o destino visível. Alvo dentro de
  `<details>` fechado precisa abrir os ancestrais antes de rolar (clique, hash inicial e `hashchange`).
  Cartão sem exemplo correspondente sai: prometer um exemplo e entregar outro bloco é pior que não ter.
- Ícone de canal promete o canal: botão com a marca do WhatsApp leva ao WhatsApp (`wa.me` com
  mensagem pronta). Se leva a `/contato`, avise o usuário ou troque o ícone.
- Link para site de cliente no ar: "Abrir o site", nova guia. Cartão de site na home leva para o bloco
  interno do case, não para fora: quem está aqui ainda não decidiu sair.

## FAQ como espinha dorsal

- Agrupe por público e por tema; cada pergunta com `id` estável (âncora e link de suporte).
- Resposta em blocos (`{ tipo: 'p' } | { tipo: 'lista' }`). Sem parede de texto.
- `<details>` nativo, sem JS, marcador próprio.
- Página de oferta mostra 6 perguntas relacionadas e "Ver todas as dúvidas".
- A resposta longa mora no FAQ; a página só resume. Isso evita repetição contraditória.

## Diagramas explicam melhor que parágrafo

Quando o processo tem lados e ordem, desenhe: raias (quem faz o quê), linha do tempo, teste
interativo (o que passa e o que é barrado), simulador. O diagrama carrega informação real, com os
termos do produto, e funciona com teclado. Receitas em `explicadores.md`.

## Renomear

Página ou termo renomeado ganha redirect permanente em `next.config.ts` no mesmo commit, com o
motivo em comentário. Detalhes em `nextjs-seo.md`.
