# Componentes padronizados

Peças que todo site institucional repete. Construa cada uma uma vez em `src/components/ui` ou
`src/components/layout` e use sempre; página que reescreve a seção à mão é onde o espaçamento e o
fundo começam a divergir.

O que segue é o comportamento de cada peça. Forma, cor, raio e canal de contato vêm da identidade do
site (`design.md`): os exemplos usam os valores do site da Yadetech (botão em pílula, faixa tinta,
acento verde, WhatsApp).

## Estrutura

```
src/components/layout/  Moldura, Cabecalho, Rodape, ChamadaFinal
src/components/ui/      Faixa, CabecalhoSecao, CabecalhoPagina, Botao, LinkSeta, BotaoFlutuante,
                        Trecho, Icones, Diagrama (Mini, ordem), ListaFAQ, CartaoCase, CartaoSite,
                        Superficie (aparelho), Reprodutor (vídeo), FaixaMarcas, DadosEstruturados,
                        RevealProvider
src/components/<pagina>/ só o que é daquela página (Hero, Vitrine, PassoAPasso)
src/lib/                seo.ts, imagens.ts, homografia.ts,
                        movimento.ts (useReduzMovimento, useVisivel, useAbaVisivel: código em animacao.md)
```

## Moldura

Envolve cabeçalho, `<main id="conteudo">`, rodapé e botão flutuante, com "Pular para o conteúdo".
Rotas com chrome próprio (ferramenta guiada, admin) ficam de fora, para não ter rodapé e botão
flutuante competindo com o fluxo.

```tsx
const SEM_MOLDURA = ['/admin', ROTA_FERRAMENTA]
if (SEM_MOLDURA.some((p) => pathname.startsWith(p))) return <>{children}</>
```

## Cabeçalho

- `sticky top-0 z-50`, fundo papel a 95% com `backdrop-blur`; a borda inferior só aparece depois de
  rolar 8 px.
- Desktop: navegação com item ativo marcado por traço fino no acento e **um** CTA escuro com a marca
  do WhatsApp. Sete itens mais botão estouram entre 1024 e 1100 px: aperte abaixo de `xl` e use
  `whitespace-nowrap`. Meça em 1024, 1100, 1279, 1280 e 1440.
- Celular: botão de 44 px abre painel `fixed inset-0` com logo e fechar próprios, itens grandes com
  descrição curta vinda de `NAV[].descricao`, e dois botões de 52 px no fim. Trava a rolagem do body e
  fecha ao trocar de rota.
- Faixa de captação acima da barra é opcional: só quando existe oferta que não é "fale conosco"
  (ferramenta, simulador, material). No celular, quebra fixa escolhida à mão para caber ao lado do CTA
  em 360 px.

## Faixa (seção)

Toda seção passa por ela. O padding e o fundo são props, não classes repetidas.

```tsx
export function Faixa({ fundo = 'papel', id, children, className }: {
  fundo?: 'papel' | 'nevoa' | 'tinta'; id?: string; children: React.ReactNode; className?: string
}) {
  return (
    <section id={id} className={clsx(FUNDO[fundo], fundo === 'tinta' && 'on-ink',
      'py-12 md:py-24 scroll-mt-24', className)}>
      <div className="shell">{children}</div>
    </section>
  )
}
```

`scroll-mt` compensa o cabeçalho fixo nas âncoras.

## Cabeçalho de seção e de página

- `CabecalhoSecao`: título à esquerda, apoio e ação à direita no `lg`
  (`grid-cols-[minmax(0,1.15fr)_minmax(0,0.85fr)] items-end gap-16`); empilhado com `gap-6` no
  celular. Rótulo opcional em caixa normal, `text-sm text-muted`, com o elemento da marca ao lado.
  Variante `claro` para faixa escura.
- `CabecalhoPagina`: abertura de página interna, logo abaixo do cabeçalho (`pt-8 pb-10 md:pt-14
  md:pb-20`), **sem breadcrumb visual**, h1 `t-display max-w-[18ch]`, apoio `t-lead`, ações e um
  `aside` opcional. Brilho radial do acento no canto e curvas da marca que se desenham.
- Hero de landing de anúncio é outro componente (`conteudo.md`): proposta, prova animada, CTA.

## Botão

- Pílula, `min-h-[44px] px-6`, 15 px, `active:scale-[0.98]`.
- Variantes por fundo: `tinta` (primário no claro), `acento` (primário no escuro), `contorno`,
  `contorno-claro`, `texto`.
- `seta` acrescenta a seta que anda 4 px no hover; `externo` troca `Link` por `<a target="_blank"
  rel="noopener noreferrer">`.
- `LinkSeta` para fim de bloco: sublinhado fraco que enche no hover.
- Botão de WhatsApp é composição: `<Botao><WhatsAppMark className="h-[18px] w-[18px]
  text-[#25D366]" />Falar com a gente</Botao>`. Sobre fundo verde a marca herda a cor do texto (verde
  sobre verde some). O destino bate com o ícone (`conteudo.md`).

## Botão flutuante

- Aparece depois de 700 px de rolagem, para não cobrir o hero; some com `translate-y-4 opacity-0
  pointer-events-none`.
- `fixed bottom-5 right-5 md:bottom-7 md:right-7`, abaixo do cabeçalho e do menu no `z-index`.
- Duas variantes, decididas com o usuário:
  - **direto**: marca do WhatsApp, abre `wa.me` com mensagem pronta;
  - **dois caminhos**: ícone de atendimento, abre um painel ("Como prefere começar?") com a
    ferramenta de captação e o WhatsApp.
- Largura do painel `w-[min(19rem,calc(100vw-2.5rem))]`.

## Chamada final

O último bloco antes do rodapé **contrasta com o rodapé**. Com rodapé escuro, é um cartão colorido
arredondado sobre papel, com margem de papel embaixo.

```tsx
<section className="bg-paper py-12 md:py-20">          {/* não tire o pb: é o que separa do rodapé */}
  <div className="shell">
    <div className="on-ink relative overflow-hidden rounded-[var(--r-lg)] px-7 py-10 md:px-12 md:py-16"
         style={{ background: 'linear-gradient(100deg, #0a4d3c, #0d5c47 50%, #137a60)' }}>
         {/* três tons escuros do acento: texto branco precisa de 4.5:1 também no lado mais claro */}
      {/* título por página, Trecho, CTA WhatsApp + ferramenta, "Ou chame direto no WhatsApp (11) ..." */}
```

- Props `titulo` e `texto: Texto`; cada página troca a frase para o assunto dela ("Seu caso ainda não
  está aqui", "Ficou uma dúvida que não está aqui").
- Desenho da marca por cima do gradiente em opacidade baixa, no lugar de gradiente liso.

## Rodapé

Fundo tinta, logo invertido, frase de posicionamento, e-mail e WhatsApp, colunas geradas do conteúdo
(serviços, cases, páginas), linha final com razão social, CNPJ e cidade. Links em 2 colunas no
celular. Assinatura de agência como prova ("Site construído por nós, como todos os outros que
entregamos") quando fizer sentido.

## Cartões

- **CartaoCase**: moldura com forma própria (`clip-path`) no tom pastel do cliente; a tela real passa
  da moldura em cima e embaixo; no hover a moldura cresce 1,5% e a tela sobe 8 px. Manchete em duas
  partes (forte em tinta, resto em muted). Imagem parada no cartão, vídeo só na página do case.
  Grade desencontrada (ímpares com `md:mt-24`).
- **CartaoSite**: navegador desenhado em CSS (três pontos numa barra de 16 px) com a home inteira
  rolando, e celular sobreposto no canto rolando junto (`imagens.md`).
- **CaseSite**: case recolhido em `<details>` com miniatura e `line-clamp-2` no celular; conteúdo
  inteiro no HTML. Abre sob demanda pelo link "ver exemplo".
- Próximo case circular no fim de cada case.

## Formulário e barra fixa no celular

- Ação principal fixa embaixo no celular, na fase que precisa dela:

```tsx
<div className="fixed inset-x-0 bottom-0 z-40 border-t border-white/10 bg-ink/90 px-5 pt-3
  pb-[max(0.75rem,env(safe-area-inset-bottom))] backdrop-blur-md lg:hidden">
  <button className="min-h-[52px] w-full ...">Começar</button>
</div>
```

- Fica **fora** de qualquer bloco animado com `transform`; o conteúdo reserva a altura
  (`pb-24 lg:pb-0`); some quando a fase termina; no `lg` o botão volta para junto do título.
- Tela de entrada cabe sem rolar em 1366×657 no desktop: aproveite a largura em duas colunas.
- Arquitetura da ferramenta de captação: `captacao.md`.

## Vídeo sob demanda

`Reprodutor`: cartaz com `next/image` e botão; o `<video autoPlay playsInline controls>` só monta no
clique.

## Dev no celular de verdade

`scripts/dev-tunel.sh` sobe o `next dev` (ou reaproveita o que já está no ar) e abre um túnel ngrok
para testar no aparelho. Porta própria por projeto no `package.json` (`next dev -p 4287`), para não
disputar a 3000 com outros projetos.

## Analytics e leads

- Medição: Vercel Web Analytics e Speed Insights, ou GA4 por variável de ambiente, com consentimento.
- **Nunca** SQLite ou arquivo local na Vercel: o disco da função é somente leitura e efêmero, o dado
  some sem erro. Lead vai por e-mail no envio (`captacao.md`) ou para banco gerenciado.
- Painel de admin, se existir: sessão assinada (nunca cookie com valor fixo), `noindex`, e nada de IP
  de visitante sem aviso de privacidade.
- Banco local e `.env*` no `.gitignore` antes do primeiro commit.
