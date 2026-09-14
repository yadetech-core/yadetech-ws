#!/usr/bin/env bash
# Sobe o `next dev` e um túnel ngrok para abrir o site no celular de verdade.
#
#   bash scripts/dev-tunel.sh [porta]        # padrão: a porta do "dev" no package.json, ou 3000
#
# Um dev por pasta: se a porta já responde, reaproveita o servidor em vez de
# matar (pode ser de outra sessão ou do usuário). Nunca rode `next build` na
# mesma pasta com este dev no ar.
set -uo pipefail
PORTA="${1:-$(grep -oE '"dev": *"[^"]*-p *[0-9]+' package.json 2>/dev/null | grep -oE '[0-9]+$' || true)}"
PORTA="${PORTA:-3000}"
PIDS=()
trap 'for p in "${PIDS[@]:-}"; do [ -n "$p" ] && kill "$p" 2>/dev/null; done; echo "Encerrado."' EXIT INT TERM

responde() { curl -s -o /dev/null --max-time 5 "http://localhost:$PORTA"; }   # qualquer status HTTP conta

if responde; then
  echo "Já existe servidor em http://localhost:$PORTA: vou usar esse."
else
  dono=$(lsof -nP -iTCP:"$PORTA" -sTCP:LISTEN -t 2>/dev/null | head -1)
  if [ -n "$dono" ]; then
    echo "A porta $PORTA está ocupada por outro processo ($(ps -o command= -p "$dono" | cut -c1-80))."
    echo "Libere a porta ou passe outra: bash scripts/dev-tunel.sh 4300"
    exit 1
  fi
  echo "Subindo next dev na porta $PORTA..."
  npx next dev -p "$PORTA" &
  PIDS+=($!)
  pronto=0
  for _ in $(seq 1 90); do responde && { pronto=1; break; }; sleep 1; done
  [ "$pronto" = 1 ] || { echo "O next dev não respondeu em 90 s."; exit 1; }
fi
echo "Local: http://localhost:$PORTA"

if ! command -v ngrok >/dev/null 2>&1; then
  echo "ngrok não encontrado (brew install ngrok/ngrok/ngrok). Seguindo só local."
  wait
  exit 0
fi

LOG="${TMPDIR:-/tmp}/ngrok-$PORTA.log"
ngrok http "$PORTA" --log=stdout >"$LOG" 2>&1 &
PIDS+=($!)
URL=""
for _ in $(seq 1 15); do
  sleep 1
  URL=$(grep -oE 'url=https://[^ ]+' "$LOG" | head -1 | cut -d= -f2)
  [ -n "$URL" ] && break
done
echo "Celular: ${URL:-(não saiu a URL; veja $LOG)}"
wait
