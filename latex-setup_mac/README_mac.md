# LaTeX + Inkscape Workflow (macOS)

## Prerequisites
- Visual Studio Code
- MacTeX (TeX Live)
  - Ensure PATH includes `/Library/TeX/texbin`:
    ```bash
    echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    latexmk -v
    ```
- Inkscape

## Install
```bash
cd latex-setup-mac
chmod +x install_mac.sh
./install_mac.sh
```

## Usage
1. In your LaTeX preamble: `\usepackage{mystyle}`
2. In VS Code (LaTeX file): **Cmd+Shift+I** → enter figure name → Inkscape opens
3. Draw, save, and close Inkscape
4. Back in VS Code, **Cmd+V** to paste the prepared figure block
5. Build with `latexmk`

## Snippet
Type `figi` → Tab to insert:
```
\figinclude{name}{caption}{0.35}
```
