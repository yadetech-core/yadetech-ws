#!/usr/bin/env bash
# Instala (ou atualiza) a skill na pasta pessoal do Claude Code desta máquina.
# Use só se NÃO tiver o plugin instalado: os dois juntos duplicam o nome no menu.
set -euo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESTINO="${CLAUDE_HOME:-$HOME/.claude}"

mkdir -p "$DESTINO/skills"
rm -rf "$DESTINO/skills/yadetech-ws"
cp -R "$RAIZ/skills/yadetech-ws" "$DESTINO/skills/yadetech-ws"

echo "Instalado em $DESTINO/skills/yadetech-ws"
echo "Reinicie o Claude Code (ou recarregue a janela do VS Code)."
