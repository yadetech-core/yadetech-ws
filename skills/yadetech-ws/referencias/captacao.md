# Ferramenta de captação guiada

Módulo opcional para site de serviço B2B: um percurso de perguntas que devolve algo útil para a
pessoa (um mapa de oportunidades, uma estimativa, um plano) e entrega o lead qualificado. Só entra
com pedido do usuário.

## Nome e promessa

- O nome mostra o que a pessoa ganha, nunca sugere defeito nela. "Diagnóstico" diz que a empresa tem
  algo errado; "Mapa de Possibilidades" diz o que ela está deixando na mesa.
- O nome oficial aparece na barra da ferramenta, nos botões (versão curta) e no título da página.
- Logo próprio simples, derivado da marca (`design.md`).

## Arquitetura

```
content/<ferramenta>.ts        telas, campos, blocos, textos e a validação compartilhada
components/ferramenta/*.tsx    abertura → telas → contato → esperando → resultado | erro
app/api/<ferramenta>/route.ts  valida → chama IA principal → reserva → valida saída → e-mail do lead
```

### Configuração por dados

```ts
type Campo = {
  id: string
  tipo: 'busca-uma' | 'busca-varias' | 'uma' | 'varias' | 'texto'
  obrigatorio?: boolean
  opcoes?: string[]; catalogo?: string[]; placeholder?: string; linhas?: number
  outro?: { opcao: string; placeholder: string }       // toda lista fechada tem "Outra"
}
type Tela = { bloco: 'empresa' | 'operacao' | 'objetivo'; titulo: string; apoio?: string; campos: Campo[] }
```

- **Uma função de validação nas duas pontas**: `campoRespondido()` libera o botão no navegador e
  recusa no servidor. "Outra" marcada sem texto não conta.
- `textoDoCampo()` gera a mesma frase para o prompt e para o e-mail.

### Perguntas

- Sobre como a empresa funciona hoje: setor (busca com dezenas de opções), o que faz (texto livre),
  tamanho e faturamento (escolha), ferramentas que usa (busca múltipla aceitando texto), rotinas que
  se repetem (múltipla com "Outra"), a rotina que mais toma tempo (texto opcional, o sinal mais forte
  para a IA), objetivo, momento, observações.
- **Toda pergunta de lista fechada tem campo aberto.** A pergunta sem espaço para escrever é a que a
  pessoa reclama.
- Porte, faturamento e urgência qualificam o lead sem parecer formulário de vendas.

## Experiência

- **Abertura explica antes de perguntar**: título, o que você responde (3 blocos), o que você recebe
  (3 itens que batem com a tela final), "Gratuito, em cerca de três minutos".
- Chrome próprio, fora da moldura do site: cabeçalho em três colunas com o nome no centro, "Voltar ao
  site" (só seta no celular), barra de progresso de 2 px, "Bloco · 3 de 9".
- **Um toque avança**: tela de escolha única avança sozinha em 320 ms. "Próxima" só aparece quando
  precisa e vira "Pular" em tela opcional vazia. Enter avança; Ctrl ou Cmd + Enter no texto longo.
- **Busca tolerante**: ignora acento e caixa; sem resultado, a primeira opção vira "Usar <texto>".
- **Rascunho** em `sessionStorage` com chave versionada. Nada é gravado na abertura (apagaria o
  rascunho antes de ler); ao clicar em Começar, restaura e pula para a primeira tela incompleta.
- **Contato antes do resultado**, com o motivo: "Você vê o resultado logo em seguida. O contato é
  para conversarmos sobre ele, se você quiser." Nome, empresa, e-mail, WhatsApp com DDD,
  `autoComplete` e `inputMode="tel"`.
- **Espera honesta**: três frases que se revezam a cada 3,2 s em `role="status"`. Uma frase parada
  por 30 s parece travamento.
- **Resultado acionável**: resumo com as palavras da pessoa; três oportunidades com "Hoje" e "Com
  tecnologia", primeiro passo e link para o serviço; CTA para WhatsApp com mensagem pronta com nome e
  empresa; "Refazer com outras respostas".
- **Erro com saída**: mensagem do que aconteceu, botão de WhatsApp, "Tentar de novo".
- Celular: botão Começar fixo embaixo (`componentes.md`). Desktop: duas colunas, sem rolar.
- framer-motion aqui é justificado (saída animada entre telas), com
  `<MotionConfig reducedMotion="user">`.

## Servidor e IA

- **Principal e reserva**: modelo principal com saída em JSON Schema e `AbortController` (35 s);
  reserva de outro fornecedor com esquema estrito (45 s). `export const maxDuration` soma os dois
  limites e o e-mail.
- Modelo e nível de raciocínio por variável de ambiente. **Nunca modelo `-preview` em produção**: é
  desligado sem aviso.
- **Esquema com `enum` dos serviços**: a IA não inventa serviço. Valide a saída de novo no servidor e
  corte no tamanho esperado.
- Leitura robusta: pegue o último bloco de texto (os anteriores podem ser raciocínio), tire cercas de
  código antes do `JSON.parse`, registre desvios com prefixo (`[mapa]`) e os primeiros 1500
  caracteres.
- Valide a entrada antes de gastar token: JSON, contato mínimo, obrigatórios.
- Prompt em blocos: papel e intenção; catálogo de serviços **gerado do conteúdo do site**; como
  analisar (texto livre pesa mais, cruze rotina com ferramenta citada, calibre por porte, prefira o
  que já usam); como escrever (frases curtas, palavras da pessoa, vocabulário banido da marca,
  nenhum número inventado, nenhuma promessa de prazo ou preço); especificação campo a campo com
  exemplo bom e ruim.

## Lead

- **E-mail enviado e aguardado antes de responder**: em função serverless, trabalho depois da
  resposta pode ser encerrado.
- Resend (ou equivalente) com `reply_to` do lead: responder o e-mail responde a pessoa. Assunto em
  ordem de decisão (`Lead: Empresa · setor · urgência`). Ficha em HTML escapado: quem é, a empresa,
  como funciona hoje, o resultado, e qual modelo gerou. Campo vazio aparece como "não respondeu".
- Remetente do domínio verificado. O endereço de teste do provedor só entrega ao dono da conta.
- Sem chave ou com falha de envio, a ficha inteira vai para o log (`[lead]`). Nunca `catch {}` vazio.
- **A tela diz a verdade**: "seu contato chegou" só quando o e-mail saiu. A função de envio devolve
  se deu certo.
- Nunca grave lead em SQLite ou arquivo local na Vercel.

## Variáveis e segredos

- Tabela no README: nome, obrigatória ou não, para que serve, efeito da ausência.
- Chave só em `.env.local` (conferido com `git check-ignore -v .env.local`) e na Vercel. Nunca em
  arquivo versionado, nunca repetida em resposta ou log. Mascare ao imprimir.
- Chave colada pelo usuário na conversa: use, não repita, e lembre de girar se ela circulou em lugar
  público.
- Suba as variáveis **antes** do push (ou redeploy depois): o push dispara build sem elas. O `next dev`
  só lê `.env.local` ao iniciar.
- 429 com "credits depleted" é cobrança do projeto, trocar de chave não resolve; limite de zero
  requisições por minuto é plano inativo. Diga ao usuário o que não foi validado ao vivo.

## Testar sem gastar chamada

- Tela de resultado: `page.route('**/api/<ferramenta>', r => r.fulfill({ status: 200, contentType:
  'application/json', body: JSON.stringify(MOCK) }))`, com o objeto no formato exato do esquema. A
  captura enviada ao usuário leva a legenda "resposta simulada".
- Rota sem subir servidor: `npx --no-install tsx --tsconfig tsconfig.json teste.mts` importando o
  `POST` e chamando com `new Request(...)`.
- Percurso completo em 1440 e 400 px, interceptando o POST para conferir o JSON, "Outra" com texto,
  rascunho depois de `reload`.
- **"Pronto" só depois de ver a tela final com resposta real**, ou dizendo que foi simulada. "O código
  está pronto" sem ver a tela é o erro que o usuário pega.

## SEO

A página de entrada é conteúdo (o que entrega, exemplo de resultado, dúvidas, links para serviços);
sem isso, `noindex`. Resultado da pessoa nunca ganha URL indexável. API em `/api/`.
