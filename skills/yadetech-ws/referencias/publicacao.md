# GitHub e Vercel

## Antes

- `.gitignore` com `node_modules/`, `.next/`, `out/`, `next-env.d.ts`, `*.tsbuildinfo`,
  `.env*`, `.vercel`, `.DS_Store`.
- Nenhum segredo no repositório. Variáveis públicas usam prefixo `NEXT_PUBLIC_`.
- `git status --short` revisado: imagem gigante ou arquivo solto não entra sem intenção.

## Subir

```bash
git init -b main && git add -A && git commit -m "..."
gh repo create <org>/<repo> --private --source=. --remote=origin --push
```

Siga o padrão de nome dos repositórios que já existem na organização. Privado por padrão.

## Publicar

```bash
vercel link --yes --project <projeto> --scope <time>
vercel git connect <url-do-repo> --yes --scope <time>   # push em main passa a publicar sozinho
vercel deploy --prod --yes --scope <time>
```

O `vercel link` cria `.env.local` com um token temporário e acrescenta `.env*` ao `.gitignore`.
Confirme que esse arquivo não foi para o repositório.

## Conferir o que está no ar

```bash
for p in / /pagina /sitemap.xml /robots.txt /opengraph-image; do
  curl -s -o /dev/null -w "$p %{http_code} %{content_type}\n" "https://<dominio>$p"; done
curl -s https://<dominio>/ | grep -oE '<link rel="canonical"[^>]*>'
```

- Todas as rotas em 200, sem proteção de deploy barrando o acesso público.
- Canonical e sitemap apontando para o domínio final. Se o domínio ainda não está ligado ao
  projeto, ou liga o domínio na Vercel, ou aponta `NEXT_PUBLIC_SITE_URL` para a URL da Vercel.
  Canonical para um domínio que não serve o site atrapalha a indexação.
- Depois de ligar o domínio: `www` redirecionando para o domínio principal e HTTPS emitido.

## Entregar

Na mensagem final, informe: URL pública, repositório, o que foi verificado, o que **não** foi
verificado e as decisões pendentes do usuário (domínio, contatos, termos, imagens que faltam).
