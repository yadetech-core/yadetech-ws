---
name: yadetech-ws
description: "Cria e evolui sites institucionais e landing pages em Next.js (App Router), do levantamento até o deploy na Vercel e o Search Console: conteúdo apurado no código ou nos cases reais, SEO técnico e de conteúdo completo, design sem cara de IA com ícones próprios, desenhos animados que explicam etapas e processos, mockups de aparelho com tela viva, imagens geradas por IA com prompts prontos, prints de sites reais, texto enxuto no celular e ferramenta de captação com IA. Use em pedidos como 'faça o site da X', 'crie a landing de Y', 'reescreva a home', 'anime a seção de etapas', 'coloque mockups reais', 'tire a cara de IA do site', 'revise o SEO', 'publique o site na Vercel'. Não usar para apps de produto, dashboards internos, e-commerce com catálogo ou blog com CMS."
---

# Yadetech WS: sites em Next.js

Site de empresa é vitrine e prova ao mesmo tempo: quem entra decide ali se chama. Ele só presta se o
que está escrito é verdade, se a página mostra funcionando em vez de só explicar, se não parece gerada
por IA e se cada afirmação foi vista no navegador.

## Princípios

1. **Conteúdo vem de fonte, não da imaginação.** Regra, prazo, limite e valor saem do código da
   plataforma, da base de cases ou da fala do usuário, com origem. O que não tem fonte não entra.
2. **Parâmetro configurável não vira texto fixo.** Se o backoffice muda o número, o site explica o
   processo e manda olhar no app.
3. **Melhor do que ler é ver.** Toda abertura e toda seção de processo têm um desenho animado que
   explica; toda capacidade tem prova visual ao lado. Seção só com texto precisa de justificativa.
   Contenção corta enfeite, nunca o desenho do negócio.
4. **Uma identidade por site, executada com disciplina.** Cores e fonte do produto que já existe,
   ícones próprios com a geometria da marca, um elemento de personalidade tirado do logo.
5. **Celular primeiro na densidade.** No máximo 3 linhas de corpo por bloco a 400 px, metade do respiro
   vertical do desktop, nenhuma prova escondida no celular.
6. **A seção vende, o FAQ detalha.** Home enxuta; o detalhe mora na página própria e no FAQ.
7. **Verificar antes de afirmar.** Tipos, capturas em cinco larguras, movimento reduzido, vídeo da
   animação, SEO no ar. "Pronto" só depois de ver a tela final.

## Fluxo

### 1. Levantar
Confirme o posicionamento numa frase, os públicos e as referências anexadas ("imagem X → seção Y").
Depois levante as regras em paralelo com subagentes `Explore`: no código da plataforma (regra de
servidor, texto de tela, parâmetro configurável) ou nos cases e peças no ar, quando o site vende
serviço. Divergência vira pergunta.
→ `referencias/descoberta.md`

### 2. Identidade e estrutura
Plano curto antes de codar: tokens por papel, tipografia com mínimo de celular, elemento de
personalidade, sequência de fundos por página e **o que cada seção mostra além do texto**. Estruture
pelo mapa de seções do tipo de página. Palavra-chave e intenção por URL definidas aqui.
→ `referencias/design.md`, `referencias/conteudo.md`, `referencias/seo-conteudo.md`

### 3. Construir
Next.js App Router, conteúdo em `src/content/*.ts` com `Texto` curto e extra, páginas só montam
componentes padronizados. SEO desde o primeiro commit: domínio canônico, helper de metadados com
imagem, sitemap com data real, JSON-LD. Desenhos animados com repouso no quadro final. Espaços de
imagem criados antes das imagens, com `PROMPTS-IMAGENS.md` entregue junto.
→ `referencias/componentes.md`, `referencias/nextjs-seo.md`, `referencias/animacao.md`,
`referencias/explicadores.md`, `referencias/imagens.md`, `referencias/mockups.md`,
`referencias/captacao.md` (se houver ferramenta de captação)

### 4. Revisar contra "AI slop"
Em uma leva: rótulos em caixa alta, títulos picotados, travessões, "X, não Y", cards iguais, ícone de
biblioteca, seção muda, imagem sem papel, mockup com interface inventada.
→ `referencias/anti-slop.md`

### 5. Verificar
Servidor servindo o código novo, tipos, capturas em 1440, ~1280, 1024, 400 e 360 px, rolagem
horizontal zero, movimento reduzido e sem JS, texto medido no celular, links "ver exemplo" clicados,
vídeo da animação enviado ao usuário, `scripts/varrer-projeto.sh`.
→ `referencias/verificacao.md`

### 6. Publicar
GitHub privado, variáveis na Vercel antes do push, deploy automático, `scripts/seo-no-ar.sh`, Search
Console e Bing com sitemap, entrega com o que ficou pendente.
→ `referencias/publicacao.md`

Várias sessões no mesmo repositório: `referencias/sessoes-paralelas.md`.

## Scripts

| Script | Para quê |
|---|---|
| `scripts/mockup-vazado.py` | mockup gerado com tela magenta vira PNG com a tela furada e imprime os 4 cantos em % (Python puro) |
| `scripts/medir-furo.py` | mede a tela de um mockup que já veio transparente (usa o `mockup-vazado.py` ao lado) |
| `scripts/homografia.ts` | `matrix3d` que encaixa a tela HTML num aparelho em perspectiva |
| `scripts/varrer-projeto.sh` | emoji, travessão, caixa alta, palavras banidas, imagens órfãs, originais em `public/`, segredos, `.gitignore` |
| `scripts/seo-no-ar.sh` | percorre o sitemap no ar: status, canonical, og:image, h1, robots, 404 |
| `scripts/dev-tunel.sh` | `next dev` com túnel ngrok para testar no celular |

Rode os scripts a partir da pasta da skill, ou copie para `scripts/` do projeto os dois `.py` juntos;
`homografia.ts` vai para `src/lib/`.

## Regras duras

- **Nunca** invente número, prazo, percentual, depoimento ou pessoa. Sem fonte, não publique.
- **Nunca** deixe no site data ou valor que o backoffice controla.
- **Nunca** emoji em texto do site (JSX, conteúdo, metadata, `alt`, prompt): ícone é SVG próprio.
- **Nunca** seção de processo ou hero de oferta sem desenho animado; **nunca** h1 da abertura dentro de
  animação de entrada.
- **Nunca** peça à IA mockup com a interface dentro nem imagem com texto ou marca: aparelho é moldura
  com tela viva em HTML.
- **Nunca** use imagem sem escrever o que ela prova naquela frase; foto gerada não representa a equipe.
- **Nunca** a chamada final com a cor do rodapé; vizinhas nunca com o mesmo fundo.
- **Nunca** troque o conteúdo de uma imagem mantendo o nome do arquivo; nunca deixe original em
  `public/`.
- **Nunca** imite marca de terceiro (WhatsApp, lojas, redes): desenho oficial.
- **Nunca** `SITE.url` num host que redireciona; nunca canonical no layout.
- **Nunca** `position: fixed` dentro de bloco com `transform`; nunca laço rodando fora da tela.
- **Nunca** `next build` com `next dev` da mesma pasta no ar; nunca mate servidor por `lsof -ti`.
- **Nunca** chave de API em arquivo versionado ou repetida em resposta; nunca lead em arquivo local na
  Vercel.
- **Nunca** implemente o que ficou "aguardando resposta"; nunca remova seção existente sem confirmar.
- **Sempre** confira o posicionamento e o público antes de estruturar.
- **Sempre** repouso no quadro final, movimento reduzido real e quem clicou manda.
- **Sempre** elemento de marca igual no celular; encolha, não esconda nem simplifique.
- **Sempre** redirect permanente ao renomear rota; vocabulário da marca no `CLAUDE.md` do projeto.
- **Sempre** releia o arquivo antes de editar se outra sessão pode estar mexendo nele.
- **Sempre** teste em 400 e 360 px e mande o vídeo da animação antes de dizer que está pronto.

## Erros que já custaram retrabalho

| Erro | Sintoma | Como evitar |
|---|---|---|
| Skill lida como minimalismo: biblioteca de ícones, só revelação, seções de texto | "muita coisa só texto, sem nada desenhado animado"; site refeito | ícones próprios e desenho animado por seção principal (`animacao.md`) |
| Opção inventada numa pergunta virou arquitetura ("duas frentes") | posicionamento errado em menu, home e Sobre | posicionamento numa frase confirmado antes |
| Referência anexada tratada como inspiração solta | "pedi explicitamente para copiar o layout" | reproduzir a composição, mapear imagem → seção |
| Animação só na entrada | "falta animação" | laço lento com 70% no estado final |
| Wireframe feito de barras cinza | "parece um skeleton" | contorno, X de imagem, anotações que apontam para o bloco |
| Selo e desenho simplificados no celular | "não seja preguiçoso" | igual ao desktop, só menor |
| Copy detalhada aplicada na home | seção quebrada e desfeita | resumo na home, detalhe na página própria |
| Imagem encaixada sem estudo, prompt ancorado num case | "por que essa imagem? pra usar onde?" | escrever o que a imagem prova; institucional sem setor |
| Mockup com interface desenhada pela IA | letra trocada, tela mentindo | moldura com furo + tela HTML + cantos medidos |
| Logos com `invert` e caixa branca | marca sem cor, fundo branco atrás | margem cortada, negativo onde o contraste não passa |
| Chamada final escura colada no rodapé escuro | "parece rodapé gigante" | cartão colorido sobre papel |
| Texto longo e respiro de desktop no celular | cliente rola demais | `Trecho` curto/extra, régua de 3 linhas, seção a 48 px |
| Contagem escrita na copy ("quatro plataformas") | mentira quando entra um case | derivar de `CASES.length` |
| "Ver exemplo" levando a `<details>` fechado | link cai em altura zero | abrir ancestrais antes de rolar; testar clicando |
| `SITE.url` sem `www` com a Vercel redirecionando | sitemap e canonical em URL que redireciona | host que responde 200 (`seo-no-ar.sh`) |
| Helper de metadados com `openGraph` sem imagem | 19 de 25 páginas sem prévia | merge raso: o helper sempre devolve imagem |
| Aparelho da abertura sem `priority`; h1 em `data-reveal` | LCP lento | elemento de LCP sem lazy e sem animação de entrada |
| `quality={90}` sem `images.qualities` no Next 16 | foto e tela borradas sem erro | `qualities: [75, 90]` e só esses valores |
| `.t-lead` com cor fora de `@layer` (Tailwind 4) | apoio escuro sobre faixa escura no site todo | classe própria dentro de `@layer components` |
| `:focus-visible` global com `border-radius` | pílula e campo deformados | foco sem raio na regra global |
| Dev server servindo CSS velho | "a animação não está no ar" | comparar CSS servido com o fonte |
| Troca de bloco por script sem `+ s[fim:]`; regex com `\b` | CSS de outra sessão apagado; classes conflitantes | início e fim explícitos, `assert`, `diff` |
| Leads em SQLite na Vercel com `catch {}` | nenhum lead salvo, tela dizendo que chegou | e-mail aguardado, tela fiel ao resultado |
| "O código está pronto" sem ver a tela final | APIs recusando em produção | ver a resposta real ou declarar simulação |
| Push antes das variáveis na Vercel | deploy sem chaves | variáveis antes, ou redeploy |
| Limpeza de imagens levou os originais | mockup não dá para reprocessar; doc desatualizado | pasta de originais declarada; registro e prompts atualizados juntos |
| `Cache-Control: immutable` com nome repetido | foto trocada não aparece | nome novo a cada troca |
| `scroll-behavior: smooth` sem `data-scroll-behavior` | página abre no meio | atributo no `<html>` |
| Regra copiada de backend que não roda em produção | site promete o que a plataforma não faz | confirmar o backend no ar |

## Checklist final

### Conteúdo
- [ ] Posicionamento e públicos confirmados; referências mapeadas imagem → seção.
- [ ] Toda regra, número e case com fonte; divergências levadas ao usuário.
- [ ] Nada que o backoffice controla como texto fixo; contagens derivadas dos dados.
- [ ] Vocabulário da marca aplicado e escrito no `CLAUDE.md`; `varrer-projeto.sh` limpo.

### Visual e movimento
- [ ] Toda hero de oferta e toda seção de processo com desenho animado; ícones próprios, zero emoji.
- [ ] Repouso no quadro final: capturas com movimento reduzido e sem JS mostram tudo completo.
- [ ] Laços pausam fora da tela e na aba oculta; clique assume o controle.
- [ ] Vídeo da animação enviado ao usuário.
- [ ] Ritmo de fundos por página, com o rodapé contando; chamada final contrasta com ele.

### Celular
- [ ] Capturas em 1440, ~1280, 1024, 400 e 360 px; `scrollWidth == innerWidth` em todas.
- [ ] Nenhum bloco de corpo acima de 3 linhas a 400 px; seções a 48 px.
- [ ] Mídia de prova e elementos de marca presentes no celular; ação principal fixa onde precisa.

### Imagens
- [ ] Cada imagem com papel escrito, `alt` descritivo ou vazio se decorativa, `sizes` medido.
- [ ] Mockups medidos por script; logos sem margem e com contraste medido sobre o fundo real.
- [ ] Originais fora de `public/`; nenhuma chave do registro apontando para arquivo ausente;
      `PROMPTS-IMAGENS.md` atualizado.

### SEO
- [ ] `SITE.url` é o host que responde 200; o outro redireciona em 308 para ele.
- [ ] `seo-no-ar.sh` sem marcas: 200, canonical igual à URL, `og:image`, `twitter:image` e um h1 em todo o sitemap.
- [ ] Título com termo no começo e único; descrição escrita à mão; uma intenção por URL.
- [ ] Layout sem canonical; admin, login e variações de anúncio com `noindex` e fora do `Disallow`.
- [ ] Sitemap com rotas dinâmicas e `lastModified` real; redirects em um salto.
- [ ] JSON-LD validado (Organization e WebSite na home, Service, Article nos cases, BreadcrumbList).
- [ ] Favicon PNG ou ICO de 48 px ou mais sem colisão de nome; `opengraph-image` por rota importante.
- [ ] Lighthouse mobile: LCP até 2,5 s, CLS até 0,1, elemento de LCP sem lazy e sem animação.
- [ ] Sobre com pessoa nomeada; rodapé com razão social, CNPJ e cidade; privacidade se há coleta.

### Publicação
- [ ] `tsc --noEmit` limpo e build verde na Vercel; variáveis cadastradas; integrações testadas no ar.
- [ ] Search Console (domínio) e Bing com sitemap enviado.
- [ ] Entrega com verificado, não verificado e decisões pendentes do usuário.
