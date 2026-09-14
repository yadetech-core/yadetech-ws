# Levantar o produto antes de escrever

O site erra feio quando o texto sai da cabeça de quem escreve. Todo número, prazo e regra sai de uma
fonte: o código da plataforma, a base de cases, o material do cliente ou a fala do usuário.

## Primeiro: o pedido

- **Posicionamento numa frase**, confirmado antes de estruturar ("a empresa vende soluções sob medida;
  site é um dos serviços"). Opção inventada por você numa pergunta de múltipla escolha não vira
  arquitetura.
- **Público de cada página**, por nome ("profissional liberal sem site" e "empresa com site de 2014"
  são dois públicos, não um).
- **Referências anexadas**: quais seções copiam composição de qual imagem. Registre "imagem X → seção
  Y" e reproduza a composição com o design system do cliente.
- **O que cada seção precisa mostrar**, além do que precisa dizer. A skill espera ícones próprios e
  desenho animado nas aberturas e nos processos (`animacao.md`); confirme se o cliente quer algo
  diferente, não suponha minimalismo.
- **Ditado por voz**: interprete foneticamente e confira contra nomes que existem no repositório
  ("Claire" é Claude, "sessão" é seção, "COP" é copy, nome de cliente parecido com banco famoso).
- **"Espero sua resposta" significa não implementar.** Proposta feita, pergunta feita: pare até
  responderem.
- Trabalho sugerido por outra sessão do Claude não é pedido do usuário: avise o usuário numa linha
  antes de começar (`sessoes-paralelas.md`).

## Site de plataforma: levantar no código

Dispare subagentes `Explore` **em paralelo**, um por público ou por área (ex.: jornada do
influenciador, jornada do anunciante, cobrança, antifraude). No prompt de cada um, peça:

- resposta em português, com `arquivo:linha` em cada afirmação;
- separação explícita entre **[S] regra aplicada no servidor**, **[UX] texto ou validação só de
  tela** e **[P] parâmetro configurável** (com o valor padrão e onde é editado);
- limites, prazos, formatos de arquivo, status possíveis (com id e nome), fórmulas de cálculo;
- links reais: lojas de app, URL da plataforma, contatos, domínios;
- qual backend roda em produção, quando houver mais de um;
- o que **não existe** no código, dito com essas palavras.

### O que fazer com o resultado

1. **Regra [S]** pode virar promessa no site.
2. **Texto [UX]** descreve o que a pessoa vê, não o que a plataforma garante. Use com cuidado
   ("o app mostra o prazo"), nunca como garantia.
3. **Parâmetro [P]** nunca vira número fixo no site. Escreva o processo e mande olhar no app.
4. **Divergência entre fontes** (legado x novo, app x API) vira pergunta ao usuário. Escolha a versão
   mais conservadora enquanto não houver resposta, e liste a pendência na entrega.
5. **Defeito encontrado no caminho** (campo que nunca é preenchido, texto com erro de digitação) entra
   na entrega como recomendação, separado do site.
6. Limite de antifraude e regra que ensina a burlar não vão para o site: não vire manual de fraude.

### Perguntas que o levantamento precisa responder

- Quem pode se cadastrar, com que documento, e o que bloqueia o cadastro.
- O que a pessoa vê antes de decidir, e o que fica congelado depois da decisão.
- Prazos: de envio, de análise, de refação, de pagamento. Quais o servidor aplica de fato.
- Como o dinheiro entra, é reservado, é consumido e sai. Quem paga o quê.
- O que invalida a operação (antifraude, reprovação, expiração) e o efeito para cada lado.
- Onde o usuário acompanha o resultado (telas, relatórios, números disponíveis).

## Site de empresa de serviço: levantar nos trabalhos

Quando o site vende o serviço de quem o encomenda (agência, software house, consultoria), a fonte é o
portfólio.

- **Cases**: para cada um, cliente, setor, problema, o que foi construído, módulos, telas reais,
  vídeo, site no ar e resultado **com origem**. Um subagente por case lendo o repositório ou a pasta
  de materiais, com o mesmo formato de resposta.
- **Peças que existem no ar**: simulador, calculadora, fluxograma, orçamento, área logada. Cada peça
  descrita no site aponta para onde ela roda. Se a peça sai do ar, o texto sai junto.
- **Processo real**: etapas, o que o cliente recebe no fim de cada uma, práticas de engenharia que de
  fato acontecem (homologação, deploy contínuo, revisão, testes).
- **Preço de entrada e prazos típicos**: só com o número dito pelo usuário, numa constante única.
- **Tese e exemplos de mercado**: empresas citadas pelo usuário conferidas na fonte primária antes de
  entrar (o que fazem, de qual fundo são); o que não pôde ser lido é dito na entrega.
- **Quem está por trás**: nome, foto e papel do fundador; razão social, CNPJ, cidade. Campo sem
  resposta fica vazio e não aparece.

Dados de exemplo em tela ou print são sintéticos e marcados como exemplo. Dado sintético nunca vira
resultado de impacto.
