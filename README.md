# yadetech-ws

Ferramenta de criação de sites da Yadetech para o Claude Code. Reúne o método usado nos sites da
Hook ADS e da própria Yadetech: levantar as regras no código ou nos cases antes de escrever, SEO
técnico e de conteúdo, revisão contra texto e layout com cara de IA, ícones próprios, desenhos
animados que explicam etapas, mockups de aparelho com tela viva, imagens geradas por IA com prompts
prontos, prints de sites reais, texto enxuto no celular, ferramenta de captação com IA e publicação
no GitHub + Vercel + Search Console.

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
- `/yadetech-ws animar a seção de etapas`
- `/yadetech-ws colocar mockups reais no hero`
- `/yadetech-ws revisar o SEO do site no ar`
- ou peça em português: "faça o site da X pelo método Yadetech".

## O que tem dentro

| Caminho | Conteúdo |
|---|---|
| `skills/yadetech-ws/SKILL.md` | princípios, fluxo em seis etapas, scripts, regras duras, erros conhecidos, checklist |
| `skills/yadetech-ws/referencias/descoberta.md` | posicionamento, públicos, referências; regras no código ou nos cases |
| `.../design.md` | tokens por papel, tipografia, densidade no celular, fundos, ícones próprios, marcas |
| `.../conteudo.md` | texto curto e extra, mapa de seções por tipo de página, landing x institucional, FAQ |
| `.../componentes.md` | cabeçalho, seção, botões, WhatsApp, chamada final, cartões, barra fixa, analytics |
| `.../animacao.md` | onde o movimento é obrigatório, regras, ferramenta certa, tokens de tempo |
| `.../explicadores.md` | receitas: mini-diagramas em laço, máquina de passos, protótipo que vira software, palco preso, vitrine, antes e depois |
| `.../imagens.md` | fluxo com ChatGPT e Gemini, prompts, prints de sites reais, página rolando, logos, vídeo |
| `.../mockups.md` | aparelho gerado com tela magenta, recorte, medidas, tela viva e homografia |
| `.../captacao.md` | ferramenta guiada com IA principal e reserva, lead por e-mail, testes |
| `.../nextjs-seo.md` | domínio canônico, metadata, indexação, sitemap, JSON-LD, Core Web Vitals |
| `.../seo-conteudo.md` | palavra-chave, on-page, confiança, SEO local, busca por IA, anúncio |
| `.../anti-slop.md` | o que tirar e o que colocar no lugar, em texto, layout e imagem |
| `.../verificacao.md` | servidor atualizado, capturas, medições, vídeo da animação, SEO no ar |
| `.../publicacao.md` | GitHub, Vercel, variáveis, Search Console, Bing, acompanhamento |
| `.../sessoes-paralelas.md` | várias sessões do Claude no mesmo repositório |
| `skills/yadetech-ws/scripts/` | `mockup-vazado.py`, `medir-furo.py`, `homografia.ts`, `varrer-projeto.sh`, `seo-no-ar.sh`, `dev-tunel.sh` |

## Editar

A fonte é este repositório. Mexeu numa referência, rode `./bin/instalar.sh` (ou publique e
atualize o plugin) e reinicie o Claude Code.

## Versões

O histórico está no [CHANGELOG.md](CHANGELOG.md) e nas
[releases](https://github.com/yadetech-core/yadetech-ws/releases). Para publicar uma versão nova:

1. suba o `version` em `.claude-plugin/plugin.json` (maior, menor ou patch);
2. registre as mudanças no `CHANGELOG.md`;
3. faça o commit, crie a tag `vX.Y.Z`, envie com `git push --follow-tags` e crie a release com
   `gh release create vX.Y.Z --notes-file <notas>`.

Quem instalou pelo plugin recebe com `/plugin marketplace update yadetech`.
