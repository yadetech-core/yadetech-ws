# SEO de conteúdo, local, confiança e busca por IA

O técnico está em `nextjs-seo.md`. Aqui fica o que decide se a página merece aparecer e ser clicada.

## Palavra-chave e intenção

- Antes de escrever, liste os termos que o comprador usa, em português do Brasil. Fontes: Search
  Console (se o site já existe), Planejador de Palavras-chave do Google Ads, Google Trends Brasil,
  autocompletar e "As pessoas também perguntam".
- Classifique a intenção: informar ("quanto custa um site"), comparar ("site pronto ou sob medida"),
  contratar ("empresa de criação de site em São Paulo").
- **Uma intenção principal por URL.** Duas páginas brigando pelo mesmo termo dividem força. Hub
  (`/sites`) responde o termo amplo; filhas respondem o tipo.
- Guarde o mapa junto do texto:

```ts
export const SEO_SERVICO = {
  termo: 'automação de processos',
  intencao: 'contratar',
  tituloSeo: 'Automação de processos para empresas',
  descricaoSeo: 'Automatizamos a rotina repetida da operação...',
  atualizadoEm: '2026-09-12',
}
```

- Use a palavra do comprador, mesmo quando a marca prefere outra. Se a regra de copy proíbe o termo mais
  buscado, leve o volume ao usuário e decida junto (termo buscado no `<title>` e na descrição, termo da
  marca no texto, por exemplo).
- Não crie uma página por variação de termo ou por cidade sem conteúdo próprio: é abuso de conteúdo em
  escala e doorway na política de spam.
  ([Fonte](https://developers.google.com/search/docs/essentials/spam-policies))

## On-page

- **Título**: termo principal no começo, marca no fim, único por página. Na prática, até uns 60
  caracteres. ([Fonte](https://developers.google.com/search/docs/appearance/title-link))
- **H1**: um por página, com o termo ou variação próxima. Frase de efeito sem o termo vai para o apoio;
  em landing de anúncio o h1 é o benefício, e o termo entra no `<title>`, na descrição e no primeiro
  parágrafo.
- **Descrição**: escrita à mão, 120 a 160 caracteres, com o termo e o motivo para clicar.
- **Primeiro parágrafo** responde o que é, para quem e o próximo passo.
- **Hierarquia**: h2 por seção, h3 dentro de h2, sem pular nível.
- **Links internos** com âncora descritiva ("automação de processos", não "ver mais"). Case liga para
  os serviços usados; serviço liga para os cases; exemplo por setor liga para o serviço.
- **Imagem**: nome de arquivo descritivo, `alt` com a cena.
- **Data**: página que envelhece (case, preço) mostra "atualizado em".

## Confiança (E-E-A-T)

O Google recompensa conteúdo feito por quem tem experiência real.
([Fonte](https://developers.google.com/search/docs/fundamentals/creating-helpful-content))

- Pessoa com nome, foto e LinkedIn na página Sobre. Empresa sem rosto perde para concorrente com rosto.
- Case com cliente nomeado (com autorização), período, papel da empresa, telas reais e resultado com
  origem. Número sem origem não entra.
- Depoimento só real, com nome e cargo.
- Rodapé com razão social, CNPJ, cidade e canais.
- **Política de privacidade** sempre que houver formulário ou ferramenta que coleta dados (LGPD), com
  link visível no formulário.
- Fonte externa citada com link.

## SEO local para empresa brasileira

- **Google Business Profile** só se a empresa atende pessoalmente: tem local que recebe cliente ou vai
  até o cliente. Escritório virtual não é elegível. Quem atende no local do cliente esconde o endereço
  e define área de atendimento. ([Fonte](https://support.google.com/business/answer/3038177))
- Nome no perfil igual ao nome real, sem palavra-chave. Categoria principal que completa "esta empresa
  é uma...". Site do perfil aponta para a home canônica.
- **NAP idêntico** (nome, endereço, telefone) no site, no perfil, no JSON-LD, no Bing Places, no Apple
  Business Connect, no LinkedIn e em diretórios do setor.
- Cidade e região escritas no site (contato, rodapé, Sobre) e em `areaServed`.
- Avaliações: peça a clientes reais. Nunca compre.
- O Google usa o Business Profile também nas respostas de IA com empresas locais.
  ([Fonte](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide))

## Busca por IA (AI Overviews, AI Mode, ChatGPT, Copilot, Claude, Perplexity)

Google:

- Não há requisito extra para aparecer em AI Overviews e AI Mode: página indexável, com snippet, e SEO
  normal. ([Fonte](https://developers.google.com/search/docs/appearance/ai-features))
- `llms.txt` não é usado pelo Google. Dividir o texto "para a IA" e dado estruturado específico também
  não são necessários. ([Fonte](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide))
- No Search Console, Configurações, "Search generative AI": o padrão inclui o site. Confira que ninguém
  desligou. ([Fonte](https://support.google.com/webmasters/answer/16908024))
- `nosnippet`, `data-nosnippet` e `max-snippet` controlam trechos. Sem snippet, a página sai também das
  respostas de IA.

Outros:

- ChatGPT busca com `OAI-SearchBot`; `GPTBot` é treino. Claude busca com `Claude-SearchBot`; `ClaudeBot`
  é treino; `Claude-User` é pedido de usuário.
  ([OpenAI](https://developers.openai.com/api/docs/bots),
  [Anthropic](https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler))
- Robôs de busca liberados sempre. Treino é decisão do dono:

```ts
rules: [
  { userAgent: '*', allow: '/', disallow: ['/api/'] },
  // só se o dono pedir para não treinar modelos:
  { userAgent: ['GPTBot', 'ClaudeBot', 'Google-Extended', 'Applebot-Extended', 'CCBot'], disallow: '/' },
]
```

- Copilot e vários buscadores usam o índice do Bing: Bing Webmaster Tools e IndexNow contam.

O que faz a IA citar a página:

- Fato claro e verificável no texto: o que a empresa faz, para quem, preço de entrada, prazo típico,
  processo, cidade.
- Mesma informação da empresa em todo lugar (site, perfil, LinkedIn, diretórios).
- Menção real em terceiros (cliente, imprensa, parceiro).
- `llms.txt` é opcional e barato, útil para ferramentas que o leem. Não prometa ganho no Google.

## Landing de anúncio

- Página que também serve ao orgânico: indexável, canonical para ela mesma, no sitemap e no menu.
- Variação só para anúncio (teste A/B, oferta de campanha, texto duplicado): `noindex`, fora do sitemap,
  ou canonical para a página orgânica.
- `utm_*` e `gclid` não criam duplicata: o canonical sem parâmetro resolve. Não crie rota por campanha.
- A oferta do anúncio aparece na primeira tela, igual. Robô e pessoa veem a mesma página.
- Nunca manipule o histórico para prender a pessoa: sequestro do botão voltar virou política de spam em
  abril de 2026. ([Fonte](https://developers.google.com/search/docs/essentials/spam-policies))
- Velocidade conta para o anúncio também. Política de privacidade visível quando há coleta; evento de
  conversão (clique no WhatsApp, envio) com consentimento.

## Ferramenta interativa de captação

- A página de entrada é conteúdo: o que a ferramenta entrega, exemplo real de resultado, dúvidas, links
  para serviços. Sem isso, `noindex`.
- Título com o nome que alguém buscaria, não só a chamada.
- Resultado da pessoa não ganha URL indexável.
- Rota de API em `/api/`, bloqueada no robots.
- Mesmo sem o menu completo, a página tem caminho de volta.

## Internacional (só se houver segunda língua)

- Subpasta (`/en`), não domínio novo nem parâmetro.
- `alternates: { languages: { 'pt-BR': '/', en: '/en', 'x-default': '/' } }` nas duas versões.
- Nunca redirecione por IP ou idioma do navegador: ofereça a troca.

## Decisões que são do usuário

Leve na entrega, com recomendação:

- www ou sem www como domínio principal;
- endereço, CNPJ e elegibilidade ao Google Business Profile;
- nome e foto do fundador na página Sobre;
- termo banido pela marca que é o mais buscado;
- permitir ou bloquear crawlers de treino de IA;
- ferramenta de captação indexável (com conteúdo) ou fora do índice.
