#!/usr/bin/env bash
set -euo pipefail

# Paths
VSUSER="$HOME/Library/Application Support/Code/User"
SNIPS="$VSUSER/snippets"
TEXTLS="$HOME/tex-tools"
TEXMF="$HOME/texmf/tex/latex/mystyle"

# Make dirs
mkdir -p "$VSUSER" "$SNIPS" "$TEXTLS" "$TEXMF"

# Determine repo root (this script is at repo root)
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Copy VS Code configs
cp -f "$REPO_ROOT/vscode/settings.json"       "$VSUSER/settings.json"       || true
cp -f "$REPO_ROOT/vscode/keybindings.json"    "$VSUSER/keybindings.json"    || true
cp -f "$REPO_ROOT/vscode/tasks.json"          "$VSUSER/tasks.json"          || true
cp -f "$REPO_ROOT/vscode/snippets/latex.json" "$SNIPS/latex.json"           || true

# Copy tools
cp -f "$REPO_ROOT/tex-tools/figure_workflow.sh" "$TEXTLS/figure_workflow.sh"
chmod +x "$TEXTLS/figure_workflow.sh"

# Copy personal style into TEXMFHOME
cp -f "$REPO_ROOT/texmf/tex/latex/mystyle/mystyle.sty" "$TEXMF/mystyle.sty"

echo "INSTALL OK (mac)."
echo "Prereqs:"
echo " - MacTeX installed. PATH must include /Library/TeX/texbin (export PATH=\\\"/Library/TeX/texbin:\\$PATH\\\")."
echo " - Inkscape installed."
echo "Restart VS Code. In LaTeX: Cmd+Shift+I → draw in Inkscape → save & close → Cmd+V."
