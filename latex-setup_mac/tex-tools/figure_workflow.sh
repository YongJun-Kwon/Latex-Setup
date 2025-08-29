#!/usr/bin/env bash
set -euo pipefail

name="${1:?usage: figure_workflow.sh <figure_name>}"

figdir="figures/$name"
mkdir -p "$figdir"
svg="$figdir/$name.svg"

# Create empty SVG if missing
if [ ! -f "$svg" ]; then
  cat > "$svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600"/>
EOF
fi

INK="/Applications/Inkscape.app/Contents/MacOS/inkscape"

# 1) Open Inkscape and wait until user closes it
open -W -a Inkscape "$svg"

# 2) Export to PDF+LaTeX
"$INK" --export-type=pdf --export-latex "$svg"

# 3) Copy LaTeX snippet to clipboard
cat <<EOF | pbcopy
\\begin{figure}[H]
\\centering
\\def\\svgwidth{0.35\\linewidth}
\\import{figures/$name/}{$name.pdf_tex}
\\caption{$name}\\label{fig:$name}
\\end{figure}
EOF

echo "DONE: Exported and snippet copied to clipboard. Paste with Cmd+V."
