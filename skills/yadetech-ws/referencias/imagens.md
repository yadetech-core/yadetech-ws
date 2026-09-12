# Imagens

Três origens, nesta ordem de preferência: foto real do cliente, imagem gerada por IA, reprodução
fiel de tela do produto. Nunca banco de imagem genérico.

## 1. Imagens geradas (Nano Banana / Gemini)

Peça ao usuário e entregue o prompt pronto. Receita que funciona:

```
Vertical 9:16 photorealistic photo. <sujeito brasileiro, idade, ação concreta>, em <cenário
específico do negócio>. <Luz: bright natural daylight / soft window light>. A subtle <cor de
acento em hex> accent light in the background. Candid, joyful, authentic. Editorial photography,
shallow depth of field, natural colors. No readable text, no posters, no whiteboard, no logos,
no watermarks.
```

Regras do prompt:
- **Proporção** igual à moldura onde a imagem entra (9:16 para Stories, 4:3 para capa).
- **Sujeito no centro**: a moldura recorta as bordas.
- **Proibir texto**: "no readable text, no posters, no whiteboard" evita letra embaralhada de IA.
- **Cor de acento** citada em hex amarra a foto à identidade.
- **Cena do negócio**, não "pessoa feliz com celular": mesa de estúdio, palco pequeno, escritório
  de selo musical.
- Peça uma variação a mais do que precisa e escolha.

Depois de receber: **confira cada imagem** antes de publicar (texto embaralhado, mão com seis
dedos, marca d'água do gerador no canto).

## 2. Pipeline de arquivo

```bash
cwebp -quiet -q 92 -m 6 original.jpeg -o public/images/<nome-semantico>.webp
```

- Qualidade **92 no tamanho cheio**; quem reduz é o `next/image`. Comprimir duas vezes suja pele
  e textura.
- Nome semântico (`influenciadora-tripe.webp`), nunca `image1.png`.
- **Trocou o conteúdo, troca o nome** e atualiza o `src`. Navegador e otimizador guardam por nome.
- Guarde o original fora de `public/` (ex.: `plataforma/assets/imagens-site-originais/`).
- `alt` descreve a cena e o papel dela, não repete o título da seção.

## 3. Reproduzir tela real do app

Melhor que foto de celular e melhor que mockup inventado: a tela do produto, refeita em HTML.

1. Um subagente `Explore` extrai a especificação da tela do código (Flutter, React Native ou web):
   árvore de widgets, textos literais, tamanhos, cores resolvidas em hex, paddings, ícones e
   assets. Peça o conteúdo dos SVGs pequenos.
2. Monte um HTML no tamanho lógico do aparelho (393×852), com a mesma fonte do app (Google Fonts),
   barra de status e barra inferior.
3. Capture com Playwright em `deviceScaleFactor: 3` e salve em `public/images/`.
4. Onde o app tem defeito que deixa a tela vazia (campo que a API não preenche), mostre o que a
   tela pretende mostrar e **avise o usuário** na entrega, com o arquivo e a linha.
5. Use os mesmos nomes e valores de exemplo em todas as telas: elas contam a mesma história.

Verificações da captura: fontes carregadas (`document.fonts`), nenhuma imagem quebrada, e os
textos que não couberam em uma linha ajustados.

## 4. Molduras

Foto de criador em `aspect-ratio: 9/16` com raio, como um Story. Tela de app dentro de moldura de
celular em CSS (`padding`, raio, fundo escuro). Se o usuário mandar o mockup 3D em PNG com fundo
transparente, use-o no lugar da moldura, com detecção por existência do arquivo.
