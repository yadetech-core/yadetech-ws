#!/usr/bin/env bash
# Instala (ou atualiza) a skill e o comando na pasta pessoal do Claude Code desta máquina.
# Alternativa ao plugin: útil quando você quer editar e testar sem publicar.
set -euo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESTINO="${CLAUDE_HOME:-$HOME/.claude}"

mkdir -p "$DESTINO/skills" "$DESTINO/commands"
rm -rf "$DESTINO/skills/yadetech-ws"
cp -R "$RAIZ/skills/yadetech-ws" "$DESTINO/skills/yadetech-ws"
cp "$RAIZ/commands/yadetech-ws.md" "$DESTINO/commands/yadetech-ws.md"

echo "Instalado em $DESTINO"
echo "  skills/yadetech-ws/   ($(find "$DESTINO/skills/yadetech-ws" -name '*.md' | wc -l | tr -d ' ') arquivos)"
echo "  commands/yadetech-ws.md"
echo "Reinicie o Claude Code para o comando aparecer no menu do /."
