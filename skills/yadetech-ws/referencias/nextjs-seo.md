# Next.js (App Router) e SEO técnico

Testado com Next 16. Tudo estático: nenhuma página pública precisa de servidor para renderizar.
Palavra-chave, conteúdo, SEO local e busca por IA estão em `seo-conteudo.md`. Conferência no ar em
`verificacao.md` (`scripts/seo-no-ar.sh`).

## Esqueleto

```
src/app/layout.tsx          fontes, metadata base, Moldura
src/app/page.tsx            home: canonical "/", JSON-LD Organization + WebSite
src/app/<rota>/page.tsx     uma pasta por página, slug em português
src/app/sitemap.ts | robots.ts | manifest.ts | favicon.ico | icon.png | apple-icon.png
src/app/opengraph-image.tsx e um por rota importante
src/app/admin/layout.tsx    noindex de tudo que é restrito
src/content/*.ts            texto, tituloSeo, descricaoSeo, atualizadoEm
src/lib/seo.ts              metadados(), JSON-LD
```

Pasta que começa com `_` é privada no App Router (não vira rota).

## Domínio canônico

- Escolha um host: `www.dominio.com.br` (recomendação da Vercel) ou sem `www`. O outro responde 308
  para ele. ([Fonte](https://vercel.com/docs/domains/working-with-domains/deploying-and-redirecting))
- **`SITE.url` é o host que responde 200**, nunca o que redireciona. Canonical, sitemap, robots,
  `og:url` e JSON-LD saem dele.
- Confira antes de publicar: `curl -sI https://dominio.com.br | grep -i location`. Se houver
  `location`, o `SITE.url` é o destino.
- Leia de variável: `url: process.env.NEXT_PUBLIC_SITE_URL ?? 'https://www.dominio.com.br'`.
- `*.vercel.app` de produção não recebe `noindex` sozinho: o canonical para o domínio final resolve.
  ([Fonte](https://vercel.com/kb/guide/avoiding-duplicate-content-with-vercel-app-urls))

## Metadata

O Next junta metadados de layout e página com **merge raso**. Se a página define `openGraph`,
`twitter` ou `robots`, o objeto do layout some inteiro, inclusive a imagem.
([Fonte](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#merging))

No `layout.tsx`, só o que vale para todas as rotas. **Sem `alternates.canonical`**: canonical no
layout é herdado pelo 404, pelo admin e por qualquer página que esquecer o helper.

```ts
export const metadata: Metadata = {
  metadataBase: new URL(SITE.url),
  title: { default: 'Marca | Termo principal', template: '%s | Marca' },
  description: SITE.descricao,
  openGraph: { type: 'website', locale: 'pt_BR', siteName: SITE.nome },
  robots: { index: true, follow: true, googleBot: { 'max-image-preview': 'large', 'max-snippet': -1 } },
  formatDetection: { telephone: false },
  // itunes: { appId: '...' },     // banner do app no Safari iOS, quando há app
}
export const viewport: Viewport = { themeColor: '<cor da faixa escura>', colorScheme: 'light' }
```

Em cada página, o helper. Ele sempre devolve imagem e aceita `noindex`:

```ts
const OG_PADRAO = { url: '/opengraph-image', width: 1200, height: 630 }

export function metadados({ titulo, descricao, caminho, imagem, indexar = true }: {
  titulo: string; descricao: string; caminho: string; imagem?: string; indexar?: boolean
}): Metadata {
  const images = [imagem ? { url: imagem } : OG_PADRAO]
  return {
    title: titulo,
    description: descricao,
    alternates: { canonical: caminho },
    ...(indexar ? {} : { robots: { index: false, follow: true } }),
    openGraph: { title: titulo, description: descricao, url: caminho, siteName: SITE.nome,
      locale: 'pt_BR', type: 'website', images },
    twitter: { card: 'summary_large_image', title: titulo, description: descricao, images },
  }
}
```

- Título e descrição saem de campos próprios do conteúdo (`tituloSeo`, `descricaoSeo`), escritos à
  mão. **Nunca** `resumo.slice(0, 155)`: corta palavra.
- Página cujo nome já tem a marca usa `title: { absolute: 'Sobre a Marca' }`.
- Canonical relativo resolve pelo `metadataBase`. Parâmetro de campanha (`utm_*`, `gclid`) não entra no
  canonical.
- `keywords` não serve para o Google.
- `<html lang="pt-BR">` sempre. Com rolagem suave no CSS, `data-scroll-behavior="smooth"` no `<html>`:
  sem ele, a troca de página para no meio.
- Prefira páginas estáticas: `generateMetadata` lento em página dinâmica pode transmitir o metadado no
  `<body>`. ([Fonte](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#streaming-metadata))

## Indexação

- `noindex` em: admin, login, página de obrigado, resultado de ferramenta, variação de anúncio que
  duplica uma página orgânica.
- Área restrita inteira por layout e por cabeçalho, porque página cliente não exporta `metadata`:

```ts
// src/app/admin/layout.tsx
export const metadata: Metadata = { robots: { index: false, follow: false } }

// next.config.ts
async headers() {
  return [{ source: '/admin/:path*', headers: [{ key: 'X-Robots-Tag', value: 'noindex, nofollow' }] }]
}
```

- **Não** bloqueie no `robots.txt` o que tem `noindex`: bloqueado, o Google não lê o `noindex` e pode
  indexar a URL sem conteúdo. ([Fonte](https://developers.google.com/search/docs/crawling-indexing/block-indexing))
- Rota dinâmica com lista fechada: `export const dynamicParams = false` e `generateStaticParams`. Slug
  desconhecido vira 404 real.
- `notFound()` quando o dado não existe. 404 próprio (`not-found.tsx`) com caminho de volta.

## Sitemap e robots

```ts
// src/app/sitemap.ts
export default function sitemap(): MetadataRoute.Sitemap {
  return PAGINAS.filter((p) => p.indexar !== false).map((p) => ({
    url: `${SITE.url}${p.caminho}`,
    lastModified: p.atualizadoEm,          // data real da última mudança de conteúdo
  }))
}
```

- Derivado dos arrays de conteúdo (serviços sem página própria, cases). Só URL canônica, 200, sem
  redirect e sem `noindex`.
- `lastModified` verdadeiro: `new Date()` no build marca tudo como novo e o Google passa a ignorar a
  data. O Google ignora `priority` e `changefreq`.
  ([Fonte](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap))

```ts
// src/app/robots.ts
export default function robots(): MetadataRoute.Robots {
  return { rules: [{ userAgent: '*', allow: '/', disallow: ['/api/'] }], sitemap: `${SITE.url}/sitemap.xml` }
}
```

- Nunca bloqueie `/_next/`, CSS ou JS. Sem `host`: o Google não usa.
- Crawlers de IA: decisão do dono (`seo-conteudo.md`).

## URLs e renomeação

- Slug em português, minúsculo, com hífen, sem acento, sem barra final. Confira a grafia do slug antes
  de publicar: erro de digitação vira URL pública e depois exige redirect.
- Renomeou: redirect permanente em `next.config.ts`, no mesmo commit, com o motivo em comentário.

```ts
async redirects() {
  return [
    // <motivo da troca de nome>
    { source: '/servicos/nome-antigo', destination: '/servicos/nome-novo', permanent: true },
  ]
}
```

- Sem cadeia: se A apontava para B e B virou C, troque A para C.
- Mantenha o redirect por no mínimo um ano. Atualize links internos e sitemap. Nunca mande URL morta
  para a home: vira soft 404.
  ([Fonte](https://developers.google.com/search/docs/crawling-indexing/site-move-with-url-changes))
- `permanent: true` gera 308, que o Google trata como 301.

## Dados estruturados (JSON-LD)

```tsx
<script type="application/ld+json"
  dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, '\\u003c') }} />
```

| Página | Tipo | Observação |
|---|---|---|
| Home | `Organization` + `WebSite` | `@id` fixos (`${SITE.url}/#organizacao`) para as outras referenciarem |
| Sobre | `AboutPage`, `Person` do fundador | `Person` com `sameAs` do LinkedIn |
| Serviço e landing | `Service` | `provider` pelo `@id`; `offers` só com preço publicado na página |
| Case | `Article` | `headline`, `image`, `datePublished`, `dateModified`, `author` |
| FAQ | `FAQPage` | uma por site, resposta em texto plano |
| Página com vídeo | `VideoObject` | `name`, `thumbnailUrl`, `uploadDate` |
| Internas | `BreadcrumbList` | começa em Início |
| App | `MobileApplication` | na página do app |

`Organization` completa:

```ts
{
  '@type': 'Organization', '@id': `${SITE.url}/#organizacao`,
  name: SITE.nome, legalName: SITE.razaoSocial, url: SITE.url,
  logo: { '@type': 'ImageObject', url: `${SITE.url}/logo.png`, width: 512, height: 512 },
  email: SITE.email, telephone: '+55...', taxID: SITE.cnpj, foundingDate: '2024',
  address: { '@type': 'PostalAddress', addressLocality: 'Cidade', addressRegion: 'UF', addressCountry: 'BR' },
  areaServed: { '@type': 'Country', name: 'Brasil' },
  sameAs: ['https://www.linkedin.com/company/...', 'https://www.instagram.com/...'],
  contactPoint: { '@type': 'ContactPoint', telephone: '+55...', contactType: 'sales', availableLanguage: 'Portuguese' },
}
```

- Logo com pelo menos 112 px, rastreável.
  ([Fonte](https://developers.google.com/search/docs/appearance/structured-data/organization))
- `WebSite` na home, com `name` igual à marca. ([Fonte](https://developers.google.com/search/docs/appearance/site-names))
- `LocalBusiness` ou `ProfessionalService` só com endereço real e Google Business Profile. Sem endereço,
  `Organization` com `areaServed`.
- Preço "a partir de": `offers: { '@type': 'Offer', priceCurrency: 'BRL', priceSpecification:
  { '@type': 'PriceSpecification', minPrice: 2997, priceCurrency: 'BRL' } }`, só se o número está na
  página.
- **FAQ não gera mais resultado expandido no Google desde 07/05/2026.** A marcação continua válida;
  mantenha só onde a página é de perguntas. ([Fonte](https://developers.google.com/search/updates))
- Nada marcado que não esteja visível. Breadcrumb sem trilha visível (escolha de design comum aqui) é
  tolerado, mas não garante a trilha no resultado: se o usuário quiser o rich result, mostre uma trilha
  discreta.
- Valide cada tipo no [Rich Results Test](https://search.google.com/test/rich-results) e no
  [validador do schema.org](https://validator.schema.org/).

## Imagem de compartilhamento

- `opengraph-image.tsx` por rota importante, com `ImageResponse` (PNG 1200×630). Arquivo de rota vence o
  objeto de metadata e vale para as rotas abaixo.
  ([Fonte](https://nextjs.org/docs/app/getting-started/metadata-and-og-images))
- Case dinâmico: `src/app/cases/[slug]/opengraph-image.tsx` recebe `params` e desenha nome e tagline.
- Sem fonte externa, sem imagem remota: fundo, logo em vetor e título. Print em WebP de tamanho qualquer
  não serve como `og:image`.
- Confira no ar que toda página tem `og:image` e `twitter:image`.

## Favicon e manifest

- `src/app/favicon.ico` e `src/app/icon.png` quadrado de 48 px ou mais; `apple-icon.png` de 180 px, sem
  cantos arredondados (o iOS aplica a máscara).
- O Google aceita ICO, PNG, JPEG, GIF, BMP e TIFF. SVG só como extra.
  ([Fonte](https://developers.google.com/search/docs/appearance/favicon-in-search))
- `icon.png` e `icon.svg` juntos disputam a rota `/icon`. Use `icon1.png`, `icon2.svg`. `icon_2.png` não é
  detectado. ([Fonte](https://nextjs.org/docs/app/api-reference/file-conventions/metadata/app-icons))
- `manifest.ts` com nome, cores e ícones.

## Core Web Vitals

Metas no percentil 75, celular: **LCP até 2,5 s, INP até 200 ms, CLS até 0,1**.
([Fonte](https://web.dev/articles/vitals))

LCP:

- Descubra o elemento de LCP (Lighthouse) em cada modelo de página.
- Imagem de LCP com `priority`. **Nunca** `loading="lazy"`: componente de aparelho ou carrossel
  reaproveitado na abertura precisa aceitar `prioridade`.
- `priority` só no elemento de LCP. Três preloads de imagem competem entre si.
- **Título de abertura fora de `data-reveal`** e de animação que começa em opacidade 0.
- Foto decorativa sob véu: `quality` 60 a 75 e `sizes` real. 90 fica para tela de produto e rosto.

INP:

- Server Component por padrão; `'use client'` só onde há interação.
- framer-motion só na página que precisa dele.
- Resposta ao clique primeiro, trabalho pesado depois (`useTransition`).
- Sem ouvinte de `scroll` para revelar: `IntersectionObserver` e CSS.
- Nenhum laço de animação rodando fora da tela (`animacao.md`).

CLS:

- `next/image` com `width` e `height`, ou `fill` em caixa com `aspect-ratio`. Imagem `w-auto h-auto` sem
  altura reservada faz âncora errar o alvo em centenas de pixels.
- Palco animado com altura fixa.
- `next/font` com `display: "swap"`.
- Nada injetado acima do conteúdo depois de carregar.

## Imagens

- `next/image` sempre; `sizes` **igual à largura real** em cada quebra (medida no navegador).
- **Next 16 só aceita as qualidades listadas**: sem `images: { qualities: [75, 90] }` no
  `next.config.ts`, todo `quality={90}` vira 75 sem erro, e um `quality={85}` vira a mais próxima com
  aviso só em dev. Use só os valores da lista.
- O otimizador não amplia: arquivo de 1915 px servido para `w=3840` sai com 1915 px.
- GIF com `unoptimized`.
- `alt` descreve a cena; imagem decorativa com `alt=""`.
- Não configure `Cache-Control` próprio em `/images`. Troca de foto pede nome de arquivo novo.
- Confira o que o navegador baixou: `new URL(img.currentSrc).searchParams` mostra `w` e `q`.

## Fontes

`next/font/google` com `variable` e `display: "swap"`, uma variável CSS por papel, subset `latin`,
pesos só os usados.

## Renderização

- Todo texto que deve ranquear está no HTML do servidor. Aba, acordeão e carrossel renderizam todos os
  painéis e escondem com CSS ou `<details>`.
- Texto escondido no celular por CSS continua no DOM e é lido.
- Link interno com `next/link`. Botão que navega por `onClick` não é seguido.
- Link externo que tira a pessoa do site abre em nova guia com `rel="noopener"`.
