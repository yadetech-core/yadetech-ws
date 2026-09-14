# GitHub, Vercel e buscadores

## Antes

- `.gitignore` com `node_modules/`, `.next/`, `out/`, `next-env.d.ts`, `*.tsbuildinfo`, `.env*`,
  `.vercel`, `.DS_Store`, `*.db`, `assets/imagens-site-originais/` e a pasta de prints brutos.
- Nenhum segredo no repositório. Variáveis públicas usam prefixo `NEXT_PUBLIC_`.
- `bash scripts/varrer-projeto.sh .` limpo: sem segredo em arquivo versionável, sem banco local, sem
  original de imagem em `public/`, sem arquivo pesado sem intenção.
- `git status --short` revisado. Banco local já versionado sai com `git rm --cached sqlite.db`, `*.db`
  no `.gitignore` e aviso ao usuário (`git reset` só tira do stage; ele volta no próximo `add`).
- README com a tabela de variáveis de ambiente: nome, obrigatória ou não, para que serve, efeito da
  ausência, prefixo de log de cada integração.

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
```

Variáveis **antes** do primeiro push com integração ligada, ou redeploy depois:

```bash
grep -rhoE "process\.env\.[A-Z0-9_]+" src | sort -u            # só os nomes
# para cada nome, leia do .env.local sem ecoar o valor:
printf '%s' "$VALOR" | vercel env add NOME production --scope <time>
vercel deploy --prod --yes --scope <time>
```

- O `vercel link` cria `.env.local` com token temporário e acrescenta `.env*` ao `.gitignore`. Confirme
  que o arquivo não foi para o repositório.
- Nunca imprima a chave: mostre só o tamanho ou os quatro primeiros caracteres.
- Modelo de IA estável em produção, nunca `-preview`.
- Remetente de e-mail do domínio verificado no provedor.

## Conferir o que está no ar

```bash
bash scripts/seo-no-ar.sh https://www.dominio.com.br
```

- Todas as rotas do sitemap em 200, sem proteção de deploy barrando o acesso público.
- Canonical, sitemap e JSON-LD apontando para o host que responde 200. Se a Vercel redireciona o domínio
  sem `www` para `www`, `SITE.url` é o `www`.
- Domínio ainda não ligado: ou liga o domínio na Vercel, ou aponta `NEXT_PUBLIC_SITE_URL` para a URL da
  Vercel. Canonical para um domínio que não serve o site atrapalha a indexação.
- Depois de ligar o domínio: host alternativo redirecionando e HTTPS emitido.
- Integrações testadas no ar (e-mail do lead chegou, IA respondeu), ou declaradas como não validadas.

## Buscadores

No dia do deploy com domínio final:

- **Search Console**: propriedade de **domínio** por registro TXT no DNS (cobre www, sem www, http e
  https). Envie `sitemap.xml`. Inspecione a home e duas páginas principais e peça indexação.
  ([Fonte](https://support.google.com/webmasters/answer/9008080))
- Em Configurações, confira "Search generative AI" incluído (padrão).
- **Bing Webmaster Tools**: importe do Search Console e envie o sitemap. O índice do Bing alimenta
  Copilot e outros buscadores de IA.
- **IndexNow** (opcional): `public/<chave>.txt` e POST para `api.indexnow.org` com as URLs alteradas.
  Atende Bing, Yandex, Naver e outros; o Google não participa.
  ([Fonte](https://www.bing.com/indexnow/getstarted))
- **Google Business Profile**: se a empresa é elegível, site do perfil apontando para a home canônica.
- `*.vercel.app`: confirme que não concorre com o domínio.

## Depois do deploy

| Quando | O que olhar |
|---|---|
| 3 a 7 dias | sitemap processado; Indexação sem "Página com redirecionamento" nem "Cópia sem canônica"; home indexada |
| 2 a 4 semanas | Desempenho: consultas e páginas com impressão; Ações manuais vazio |
| Todo mês | consulta com muita impressão e CTR baixo: reescreva título e descrição; "Rastreada, mas não indexada": melhore a página; 404 novos depois de renomear; Core Web Vitals; desempenho em IA; Bing; perfil da empresa |
| A cada mudança de URL | redirect no ar em um salto, sitemap atualizado, inspeção da URL nova |

Medição de campo: `@vercel/speed-insights` ou o relatório de Core Web Vitals. Lighthouse é laboratório.

## Entregar

Na mensagem final: URL pública, repositório, o que foi verificado (com números), o que **não** foi
verificado e as decisões pendentes do usuário (domínio, contatos, CNPJ, fundador, termos banidos x
termos buscados, crawlers de IA, imagens que faltam com o `PROMPTS-IMAGENS.md`).
