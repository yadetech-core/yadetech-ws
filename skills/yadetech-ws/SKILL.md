---
name: yadetech-ws
description: "Cria e evolui sites institucionais e landing pages em Next.js (App Router), do levantamento do produto até o deploy na Vercel: conteúdo apurado no código real da plataforma, SEO completo, design sem cara de IA, movimento com propósito, imagens geradas por IA (Nano Banana) e telas reais do app reproduzidas em HTML. Use em pedidos como 'faça o site da X', 'crie a landing de Y', 'reescreva a home', 'tire a cara de IA do site', 'publique o site na Vercel'. Não usar para apps de produto, dashboards internos, e-commerce com catálogo ou blog com CMS."
---

# Yadetech WS — sites em Next.js

Site de produto é vitrine e documentação ao mesmo tempo: quem entra decide se cria conta.
Ele só presta se o que está escrito é verdade, se a página não parece gerada por IA e se cada
afirmação foi vista funcionando no navegador.

## Princípios

1. **Conteúdo vem do código, não da imaginação.** Toda regra, prazo, limite e valor sai do
   repositório da plataforma, com arquivo e linha. O que não existe no código não entra no site.
2. **Parâmetro configurável não vira texto fixo.** Se o backoffice muda o número, o site explica o
   processo e manda olhar no app. Data e valor cravados viram mentira em três meses.
3. **Uma decisão de design por site, executada com disciplina.** Identidade sai do produto que já
   existe (cores do admin, fonte do app), não de um tema genérico.
4. **Movimento serve à leitura.** Nada nasce invisível esperando scroll; nada pisca sem motivo.
5. **A seção vende, o FAQ detalha.** Cada seção da página é conceitual: poucos passos, pouco
   texto e uma ação. Prazo, limite e exceção moram no FAQ, não no meio do argumento.
6. **Verificar antes de afirmar.** Build, tipos, capturas em desktop e celular, páginas no ar
   respondendo 200. Relate o que falhou junto com a saída.

## Fluxo

### 1. Levantar o produto
Antes de escrever qualquer palavra, descubra as regras reais. Dispare subagentes `Explore` em
paralelo, um por público (ex.: influenciador e anunciante), pedindo evidência `arquivo:linha` e a
separação entre regra aplicada no servidor, texto só de interface e parâmetro configurável.
Divergências entre sistemas viram pergunta para o usuário, não escolha silenciosa.
→ `referencias/descoberta.md`

### 2. Identidade e estrutura
Reaproveite o design system que já existe. Defina em poucas linhas: 4 a 6 cores, 2 ou 3 fontes com
papéis, conceito de layout e **um** elemento de personalidade. Estruture as páginas por público e
deixe o detalhe todo no FAQ.
→ `referencias/design.md`, `referencias/conteudo.md`

### 3. Construir
Next.js App Router, conteúdo em `src/content/*.ts`, páginas só montam. SEO desde o primeiro
commit, não no fim.
→ `referencias/nextjs-seo.md`, `referencias/animacao.md`, `referencias/imagens.md`

### 4. Revisar contra "AI slop"
Passe a régua antes de mostrar: rótulos decorativos, títulos picotados, travessões, grades de
cards iguais, fundos coloridos de status, ícones em círculo por toda parte.
→ `referencias/anti-slop.md`

### 5. Verificar
Tipos, build, capturas em 1440, ~1280 e 400 px, rolagem horizontal zero, links e âncoras.
→ `referencias/verificacao.md`

### 6. Publicar
GitHub privado, projeto na Vercel, deploy automático por push, e conferência do que está no ar.
→ `referencias/publicacao.md`

## Regras duras

- **Nunca** invente número, prazo, percentual ou depoimento. Sem evidência, não publique.
- **Nunca** deixe no site data específica que o backoffice controla ("dia 15", "até o dia 10").
- **Nunca** troque o conteúdo de uma imagem mantendo o nome do arquivo: dê nome novo.
- **Nunca** imite marca de terceiro (Pix, lojas de app, redes): use o desenho oficial.
- **Nunca** rode `next build` enquanto um `next dev` da mesma pasta está no ar: os dois escrevem
  em `.next`. Verifique com `tsc --noEmit` e deixe o build para a Vercel, ou pare o dev antes.
- **Sempre** releia o arquivo antes de editar se outra sessão pode estar mexendo nele, e avise
  quem está trabalhando perto.
- **Sempre** escreva `alt` que descreve a cena, e marque valor de exemplo como exemplo.
- **Sempre** teste em 400 px de largura antes de dizer que está pronto.

## Erros que já custaram retrabalho

| Erro | Sintoma | Como evitar |
|---|---|---|
| `Cache-Control: immutable` em `/images` com nome de arquivo repetido | trocou a foto e o site continua mostrando a antiga | sem cabeçalho próprio; nome novo a cada troca |
| `sizes` do `next/image` desatualizado depois de aumentar a imagem | foto borrada em tela retina | `sizes` bate com a largura real; confira o `w=` que o navegador baixa |
| `scroll-behavior: smooth` sem `data-scroll-behavior="smooth"` no `<html>` | trocar de página abre no meio dela | atributo no `<html>`; teste navegando do topo e de página rolada |
| Fonte da imagem comprimida duas vezes (WebP q80 + otimizador) | textura suja em foto de rosto | gere o WebP em q92 no tamanho cheio e deixe o Next reduzir |
| Texto gerado por IA dentro da imagem | pôster com letras trocadas no fundo | proíba texto no prompt e confira a imagem antes de usar |
| Regra copiada de um backend que não roda em produção | site promete o que o sistema não faz | confirme qual backend está no ar antes de escrever a regra |
| Seção "Regras da plataforma" com números soltos | vira lista de trivialidades e envelhece mal | número só aparece onde muda a decisão de quem lê |

## Checklist final

- [ ] Toda regra publicada tem origem no código, e as divergências foram levadas ao usuário.
- [ ] Nenhuma data ou valor que o backoffice controla aparece como texto fixo.
- [ ] `npx tsc --noEmit` limpo e build de produção verde (local ou na Vercel).
- [ ] Capturas conferidas em 1440, ~1280 e 400 px; `scrollWidth == innerWidth` nas três.
- [ ] Navegação pelo menu abre as páginas no topo.
- [ ] `sitemap.xml`, `robots.txt`, canonical e Open Graph respondendo no ar.
- [ ] Imagens com `alt` descritivo, peso conferido e nomes versionados.
- [ ] Passagem anti-slop feita, com a lista de `referencias/anti-slop.md`.
