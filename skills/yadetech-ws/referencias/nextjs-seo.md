# Next.js (App Router) e SEO

Testado com Next 16. Tudo estático: nenhuma página precisa de servidor para renderizar.

## Esqueleto

```
src/app/layout.tsx        fontes, metadata base, header/footer, JSON-LD do site
src/app/page.tsx          home
src/app/<rota>/page.tsx   uma pasta por página, slug em português
src/app/sitemap.ts | robots.ts | manifest.ts
src/app/opengraph-image.tsx          e um por rota importante
src/components, src/content, src/lib
```

## Metadata

No `layout.tsx`:

```ts
export const metadata: Metadata = {
  metadataBase: new URL(SITE.url),
  title: { default: "Marca | Frase curta", template: "%s | Marca" },
  description: SITE.descricao,
  alternates: { canonical: "/" },
  openGraph: { type: "website", locale: "pt_BR", siteName: SITE.nome, url: "/" },
  twitter: { card: "summary_large_image" },
  robots: { index: true, follow: true, googleBot: { "max-image-preview": "large", "max-snippet": -1 } },
  itunes: { appId: "..." },            // banner do app no Safari iOS
  formatDetection: { telephone: false },
};
export const viewport: Viewport = { themeColor: "#ffffff", colorScheme: "light" };
```

Em cada página, um helper `metadados({ titulo, descricao, caminho, palavras })` devolve título,
descrição, canonical relativo e Open Graph. Canonical relativo resolve sozinho pelo `metadataBase`.

`<html lang="pt-BR">` sempre. E, se o CSS tiver rolagem suave,
**`data-scroll-behavior="smooth"` no `<html>`**: sem ele, a troca de página para no meio.

## Dados estruturados (JSON-LD)

Um componente que serializa e escapa `<`:

```tsx
<script type="application/ld+json"
  dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, "\\u003c") }} />
```

- `Organization` + `WebSite` no layout, com `@id` para as páginas referenciarem.
- `BreadcrumbList` nas internas.
- `FAQPage` só na página de FAQ (uma por site), com a resposta em texto plano.
- `MobileApplication` na página do app; `Service` na página comercial.

## Imagem de compartilhamento

`opengraph-image.tsx` por rota, gerado no build com `ImageResponse` (1200×630). Sem fonte externa,
sem imagem remota: fundo, logo em vetor e o título da página. Vale mais que uma foto genérica e
não quebra quando o texto muda.

## Imagens

- `next/image` sempre; `sizes` **igual à largura real** em cada quebra; `quality` 90 em foto com
  rosto (libere no `next.config.ts` com `images: { qualities: [75, 90] }`).
- `priority` só no que aparece sem rolar.
- Não configure `Cache-Control` próprio em `/images`. Troca de foto pede nome de arquivo novo.
- Confira o que o navegador baixou: `new URL(img.currentSrc).searchParams` mostra `w` e `q`.

## Fontes

`next/font/google` com `variable` e `display: "swap"`, uma variável CSS por papel. Pesos só os
usados. Isso evita FOUT e mantém a fonte fora da rede crítica do usuário.

## Cuidados de rota

- `sitemap.ts` lista as rotas com `lastModified`; `robots.ts` aponta para ele.
- Slug em português, minúsculo, com hífen.
- 404 próprio (`not-found.tsx`) com caminho de volta.
- Link externo que tira a pessoa do site abre em nova guia com `rel="noopener"`.
