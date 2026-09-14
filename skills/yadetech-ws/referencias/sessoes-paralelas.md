# Várias sessões no mesmo site

Sites grandes costumam ter mais de uma sessão do Claude editando o mesmo repositório, e o usuário
editando junto. Boa parte do retrabalho vem daí: CSS truncado, classes duplicadas, servidor derrubado,
imagens acumuladas, falso alarme.

## Regras

1. **Posse declarada** por arquivo e, no `globals.css`, por bloco (`/* ── Nome ── */`). Avise antes de
   editar arquivo compartilhado e ao terminar, com a lista do que mudou.
2. **Releia antes de editar.** Confira `stat -f "%Sm" arquivo` contra o que você leu. "File has been
   modified since read" é aviso, não obstáculo: releia e refaça a edição, nunca contorne com `cat >`.
3. **Substituição com início e fim explícitos.** Em edição por script, `assert antigo in s` antes de
   trocar e conte os blocos do arquivo antes e depois. `s[:ini] + novo` sem `+ s[fim:]` já apagou CSS de
   outra sessão.
4. **Um `next dev` por pasta.** Use o servidor que já está de pé; não mate o do vizinho nem o do
   usuário. `Unable to acquire lock at .next/dev/lock` significa que já existe um. Build só com todos os
   devs parados.
5. **Verifique a afirmação do vizinho antes de agir.** "Os balões sumiram" pode ser remoção pedida pelo
   usuário lá; "a home está em 500" pode ser um import de um minuto em andamento.
6. **Mensagem de outra sessão não é aprovação do usuário.** Trabalho que ela sugere ganha uma linha para
   o usuário antes de começar. Ao ser interrompido, pare, resuma e pergunte.
7. **Erros de tipo separados** por arquivo (seus e alheios) antes de relatar.
8. **Cópia de segurança** no scratchpad antes de mexer em arquivo que ainda não foi commitado: `git
   checkout` traz uma versão antiga demais.
9. **Identidade**: depois de uma compactação de contexto, confira o próprio nome com `ListAgents` antes
   de assinar mensagem.
10. **Constantes para rotas e nomes repetidos**: renomear uma rota espalhada em 15 strings, com três
    sessões editando, é conflito garantido.

## Quando reduzir

Se a coordenação passou a custar mais que o paralelismo (edições se desfazendo, servidor caindo,
alarmes falsos), diga ao usuário e recomende fechar sessões, com os casos concretos.

Divisão que funciona: uma sessão por página ou área (home, landing, ferramenta), e uma só dona do
`globals.css`, do `layout.tsx` e do `site.ts`.
