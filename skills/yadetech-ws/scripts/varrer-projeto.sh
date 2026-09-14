#!/usr/bin/env bash
# Varredura antes de entregar ou fazer commit. Só lê; não altera nada.
#
#   bash scripts/varrer-projeto.sh [pasta-do-site] [palavra-banida ...]
#   bash scripts/varrer-projeto.sh . sistema sistemas
#
# Confere: emoji e travessão em texto do site, palavras banidas pela marca,
# caixa alta em classe, imagens de public/ sem referência, originais gerados
# esquecidos em public/, arquivos pesados, segredos e arquivos que precisam
# estar no .gitignore.
set -uo pipefail
RAIZ="${1:-.}"
shift || true
cd "$RAIZ" || exit 1
[ -d src ] || { echo "Rode na raiz do site (pasta com src/)."; exit 1; }

secao() { printf '\n== %s\n' "$1"; }

secao "Emoji e travessão (—) em texto do site (comentários ignorados)"
find src -type f \( -name '*.ts' -o -name '*.tsx' \) -not -path '*/admin/*' -print0 |
python3 -c '
import re, sys
arquivos = [a for a in sys.stdin.buffer.read().decode().split("\0") if a]
emoji = re.compile("[\U0001F300-\U0001FAFF☀-➿⬀-⯿️]")
comentario = re.compile(r"/\*.*?\*/|//[^\n]*|\{/\*.*?\*/\}", re.S)
achou = 0
for f in arquivos:
    texto = open(f, encoding="utf-8", errors="ignore").read()
    # apaga comentários mantendo as quebras de linha, para os números de linha baterem
    limpo = comentario.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), texto)
    if "/api/" in f:           # prompts de API: só emoji importa
        alvo = emoji
    else:
        alvo = re.compile(emoji.pattern[:-1] + "—]")
    for n, linha in enumerate(limpo.split("\n"), 1):
        if alvo.search(linha):
            print(f"{f}:{n}: {texto.split(chr(10))[n-1].strip()[:110]}")
            achou += 1
print("nenhum" if not achou else f"{achou} linha(s)")
'

secao "Caixa alta em classe (rótulo com cara de IA)"
grep -rn --include='*.tsx' --include='*.ts' --include='*.css' 'uppercase' src | grep -v '/admin/' | head -20 || true

for palavra in "$@"; do
  secao "Palavra banida: $palavra"
  grep -rniw --include='*.ts' --include='*.tsx' "$palavra" src | grep -v '/admin/' | head -40 || true
done

secao "Imagens e vídeos em public/ sem referência no código"
[ -d public ] && find public -type f \( -name '*.webp' -o -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \
  -o -name '*.svg' -o -name '*.gif' -o -name '*.mp4' -o -name '*.avif' \) -print0 |
while IFS= read -r -d '' f; do
  rel="${f#public}"
  grep -rqF "$rel" src next.config.* 2>/dev/null || echo "sem referência: $f"
done

secao "Originais gerados esquecidos em public/ (nome de ferramenta, espaço ou acento)"
[ -d public ] && find public -type f \( -iname '*chatgpt*' -o -iname '*gemini*' -o -iname '*image [0-9]*' -o -name '* *' \
  -o -name '*[áàâãéêíóôõúçÁÀÂÃÉÊÍÓÔÕÚÇ]*' \) | head -20

secao "Arquivos acima de 1 MB em public/"
[ -d public ] && find public -type f -size +1M -exec du -h {} + | sort -h | tail -20

secao "Segredos em arquivos do projeto"
PADRAO='AIza[0-9A-Za-z_-]{20,}|AQ\.[A-Za-z0-9_-]{30,}|re_[A-Za-z0-9]{16,}|sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|BEGIN (RSA|OPENSSH|EC) PRIVATE'
if git rev-parse --git-dir >/dev/null 2>&1; then
  achados=$(git ls-files -z -co --exclude-standard |
    xargs -0 grep -lIE "$PADRAO" 2>/dev/null || true)
else
  achados=$(grep -rlIE "$PADRAO" --exclude-dir=node_modules --exclude-dir=.next --exclude-dir=.git \
    --exclude='.env*' . 2>/dev/null || true)
fi
[ -n "$achados" ] && echo "$achados" || echo "nenhum"

secao "Arquivos que precisam estar no .gitignore"
if git rev-parse --git-dir >/dev/null 2>&1; then
  for f in .env.local .env .vercel node_modules .next assets/imagens-site-originais prints-site $(ls *.db 2>/dev/null); do
    [ -e "$f" ] || continue
    if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
      echo "ATENÇÃO: $f está versionado (git rm --cached $f e acrescente ao .gitignore)"
    elif git check-ignore -q "$f"; then
      echo "ok: $f ignorado"
    else
      echo "ATENÇÃO: $f não está no .gitignore"
    fi
  done
else
  echo "(sem git ainda: confira o .gitignore antes do primeiro commit)"
fi
