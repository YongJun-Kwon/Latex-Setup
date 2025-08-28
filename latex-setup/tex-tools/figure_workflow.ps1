param(
  [Parameter(Mandatory=$true)][string]$name,
  [string]$ink = "C:\Program Files\Inkscape\bin\inkscape.com"
)

# 0) 폴더/SVG 준비
$figDir = Join-Path -Path "figures" -ChildPath $name
New-Item -ItemType Directory -Path $figDir -Force | Out-Null
$svg = Join-Path $figDir ($name + ".svg")
if (!(Test-Path $svg)) {
  $svgContent = @'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600"/>
'@
  $svgContent | Out-File -FilePath $svg -Encoding utf8 -NoNewline
}

# 1) Inkscape 실행 → 종료까지 대기
if (!(Test-Path $ink)) { $ink = "C:\Program Files\Inkscape\bin\inkscape.exe" }
$proc = Start-Process -FilePath $ink -ArgumentList "`"$svg`"" -PassThru
Wait-Process -Id $proc.Id

# 2) 저장된 SVG를 PDF+LaTeX로 내보내기
& $ink --export-type=pdf --export-latex $svg

# 3) LaTeX figure 블록을 클립보드에 준비
$snippet = @"
\begin{figure}[H]
\centering
\def\svgwidth{0.35\linewidth}
\import{figures/$name/}{$name.pdf_tex}
\caption{$name}\label{fig:$name}
\end{figure}
"@
Set-Clipboard -Value $snippet
Write-Host "DONE: figure exported and snippet copied to clipboard."
