# Levantar o produto antes de escrever

O site erra feio quando o texto sai da cabeça de quem escreve. Todo número, prazo e regra sai do
código da plataforma.

## Como levantar

Dispare subagentes `Explore` **em paralelo**, um por público ou por área (ex.: jornada do
influenciador, jornada do anunciante, cobrança, antifraude). No prompt de cada um, peça:

- resposta em português, com `arquivo:linha` em cada afirmação;
- separação explícita entre **[S] regra aplicada no servidor**, **[UX] texto ou validação só de
  tela** e **[P] parâmetro configurável** (com o valor padrão e onde é editado);
- limites, prazos, formatos de arquivo, status possíveis (com id e nome), fórmulas de cálculo;
- links reais: lojas de app, URL da plataforma, contatos, domínios;
- o que **não existe** no código, dito com essas palavras.

## O que fazer com o resultado

1. **Regra [S]** pode virar promessa no site.
2. **Texto [UX]** descreve o que a pessoa vê, não o que o sistema garante. Use com cuidado
   ("o app mostra o prazo"), nunca como garantia.
3. **Parâmetro [P]** nunca vira número fixo no site. Escreva o processo e mande olhar no app.
4. **Divergência entre sistemas** (legado x novo, app x API) vira pergunta ao usuário. Escolha a
   versão mais conservadora enquanto não houver resposta, e liste a pendência na entrega.
5. **Defeito encontrado no caminho** (campo que nunca é preenchido, texto com erro de digitação)
   entra na entrega como recomendação, separado do site.

## Perguntas que o levantamento precisa responder

- Quem pode se cadastrar, com que documento, e o que bloqueia o cadastro.
- O que a pessoa vê antes de decidir, e o que fica congelado depois da decisão.
- Prazos: de envio, de análise, de refação, de pagamento. Quais o servidor aplica de fato.
- Como o dinheiro entra, é reservado, é consumido e sai. Quem paga o quê.
- O que invalida a operação (antifraude, reprovação, expiração) e o efeito para cada lado.
- Onde o usuário acompanha o resultado (telas, relatórios, números disponíveis).
