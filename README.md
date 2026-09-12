# yadetech-ws

Ferramenta de criação de sites da Yadetech para o Claude Code. Reúne o método usado no site da
Hook ADS: levantar as regras no código do produto antes de escrever, SEO completo, revisão contra
texto e layout com cara de IA, movimento com propósito, imagens geradas por IA, reprodução de
telas reais do app e publicação no GitHub + Vercel.

## Instalar

**Como plugin (recomendado, atualiza com um comando):**

```
/plugin marketplace add yadetech-core/yadetech-ws
/plugin install yadetech-ws@yadetech
```

Para atualizar depois: `/plugin marketplace update yadetech` e reinicie o Claude Code.

**Direto na pasta pessoal (para editar e testar):**

```bash
./bin/instalar.sh     # copia para ~/.claude/skills/yadetech-ws
```

Escolha **um** dos dois caminhos: plugin e cópia pessoal ao mesmo tempo duplicam o nome e
atrapalham o menu. Nos dois casos, reinicie o Claude Code (no VS Code, recarregue a janela):
skills são lidas quando a sessão começa.

## Usar

- `/yadetech-ws criar o site da <empresa>`
- `/yadetech-ws revisar a home tirando cara de IA`
- `/yadetech-ws publicar na Vercel`
- ou peça em português: "faça o site da X pelo método Yadetech".

## O que tem dentro

| Caminho | Conteúdo |
|---|---|
| `skills/yadetech-ws/SKILL.md` | princípios, fluxo em seis etapas, regras duras, erros conhecidos, checklist |
| `skills/yadetech-ws/referencias/descoberta.md` | levantar regras no código com subagentes |
| `.../design.md` | identidade a partir do produto, ritmo de seções, acessibilidade |
| `.../conteudo.md` | conteúdo separado das páginas, seção que vende e FAQ que detalha |
| `.../nextjs-seo.md` | App Router, metadata, JSON-LD, sitemap, imagens, fontes |
| `.../animacao.md` | estado de repouso visível, movimento reduzido, armadilhas |
| `.../imagens.md` | prompts para o Nano Banana, pipeline WebP, telas reais do app |
| `.../anti-slop.md` | o que tirar e o que colocar no lugar, em texto e em layout |
| `.../verificacao.md` | tipos, capturas, três larguras, medir em vez de achar |
| `.../publicacao.md` | GitHub, Vercel, domínio e conferência do que está no ar |

## Editar

A fonte é este repositório. Mexeu numa referência, rode `./bin/instalar.sh` (ou publique e
atualize o plugin) e reinicie o Claude Code.
