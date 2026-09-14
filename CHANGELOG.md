# Histórico de versões

O número segue [versionamento semântico](https://semver.org/lang/pt-BR/): a versão maior muda quando
o método quebra o que já funcionava, a menor quando entra capacidade nova, o patch em correção. A
versão fica em `.claude-plugin/plugin.json` e cada uma ganha uma tag `vX.Y.Z` com release no GitHub.

## [1.1.0] - 2026-09-14

O que o site da Yadetech ensinou, levado para o método.

### Adicionado

- **Movimento obrigatório onde explica** (`animacao.md`): toda hero de oferta e toda seção de processo
  com desenho animado. Repouso no quadro final, laço lento com 70% do tempo parado, pausa fora da tela
  e na aba oculta, controle do visitante, tokens de tempo e hooks prontos.
- **Receitas de desenhos que explicam** (`explicadores.md`): mini-diagramas de etapa em laço, máquina
  de passos, protótipo que vira software no mesmo DOM, palco preso na rolagem, vitrine de camadas
  flutuando, antes e depois com varredura, laços ambientes.
- **Mockups com tela viva** (`mockups.md`): contrato do prompt com tela magenta, escolha do aparelho
  pela área útil, recorte e medição por script, tela em HTML atrás do furo, homografia para aparelho
  em ângulo.
- **Componentes padronizados** (`componentes.md`): moldura, cabeçalho, faixa de seção, botões com
  WhatsApp, botão flutuante, chamada final que contrasta com o rodapé, cartões de case e de site, barra
  fixa no celular.
- **Ferramenta de captação guiada** (`captacao.md`): percurso configurado por dados, IA principal com
  reserva, validação compartilhada, lead por e-mail aguardado, testes sem gastar chamada.
- **SEO de conteúdo** (`seo-conteudo.md`): palavra-chave e intenção, on-page, confiança, SEO local
  brasileiro, busca por IA, landing de anúncio.
- **Várias sessões no mesmo repositório** (`sessoes-paralelas.md`).
- **Scripts** em `skills/yadetech-ws/scripts/`: `mockup-vazado.py`, `medir-furo.py`, `homografia.ts`,
  `varrer-projeto.sh`, `seo-no-ar.sh`, `dev-tunel.sh`.

### Alterado

- `SKILL.md`: princípio "melhor do que ler é ver", celular primeiro na densidade, regras duras e
  tabela de erros ampliadas, checklist por área.
- `nextjs-seo.md`: domínio canônico, merge raso de metadados, indexação e `noindex`, sitemap com data
  real, JSON-LD completo, favicon, Core Web Vitals, qualidades de imagem do Next 16.
- `imagens.md`: fluxo com ChatGPT e Gemini, prompts que funcionaram, prints de sites reais, página
  rolando no cartão, logos, vídeo, limpeza.
- `design.md`: tokens por papel, tipografia com mínimo de celular, densidade no celular, ritmo de
  fundos, ícones próprios, marcas e credibilidade técnica.
- `conteudo.md`: posicionamento antes de estrutura, texto curto e extra, mapa de seções por tipo de
  página, landing de anúncio x institucional, links que prometem destino.
- `descoberta.md`: levantamento para site de empresa de serviço, a partir dos cases.
- `anti-slop.md`, `verificacao.md`, `publicacao.md`: exceções válidas, medições, vídeo da animação,
  SEO no ar, Search Console e Bing.

## [1.0.1] - 2026-09-11

- Só a skill fica no plugin; o comando legado saiu.

## [1.0.0] - 2026-09-11

- Primeira versão: levantamento no código, SEO, anti AI slop, movimento, imagens geradas, telas reais
  do app e publicação na Vercel.

[1.1.0]: https://github.com/yadetech-core/yadetech-ws/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/yadetech-core/yadetech-ws/compare/f0bae63...v1.0.1
