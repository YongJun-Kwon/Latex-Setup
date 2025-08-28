param(
  [string]$UserName = $env:USERNAME
)

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────────────────────────────────────
# 0) 경로 정의
# ─────────────────────────────────────────────────────────────────────────────
$UserDir   = "C:\Users\$UserName"
$VSUser    = Join-Path $env:APPDATA "Code\User"
$VSUserSn  = Join-Path $VSUser "snippets"
$Here      = Split-Path -Parent $MyInvocation.MyCommand.Path
$TexTools  = Join-Path $UserDir "tex-tools"
$TexmfRoot = Join-Path $UserDir "texmf"
$MyStyle   = Join-Path $TexmfRoot "tex\latex\mystyle"

# ─────────────────────────────────────────────────────────────────────────────
# 1) 디렉토리 생성
# ─────────────────────────────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $VSUser,$VSUserSn,$TexTools,$MyStyle | Out-Null

# ─────────────────────────────────────────────────────────────────────────────
# 2) 파일 차단 해제(Windows에서 “인터넷에서 가져옴” 차단 제거)
# ─────────────────────────────────────────────────────────────────────────────
Get-ChildItem -Recurse -File $Here | ForEach-Object {
  try { Unblock-File -Path $_.FullName } catch {}
}

# ─────────────────────────────────────────────────────────────────────────────
# 3) VS Code 설정/키/태스크/스니펫 복사
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "Copying VS Code configs..."
Copy-Item "$Here\vscode\settings.json"        "$VSUser\settings.json"        -Force -ErrorAction SilentlyContinue
Copy-Item "$Here\vscode\keybindings.json"     "$VSUser\keybindings.json"     -Force -ErrorAction SilentlyContinue
Copy-Item "$Here\vscode\tasks.json"           "$VSUser\tasks.json"           -Force -ErrorAction SilentlyContinue
# ⬇⬇⬇ 스니펫 자동 복사 (핵심)
if (Test-Path "$Here\vscode\snippets") {
  Copy-Item "$Here\vscode\snippets\*.json"    "$VSUserSn\"                  -Force -ErrorAction SilentlyContinue
}

# ─────────────────────────────────────────────────────────────────────────────
# 4) tex-tools 배포 (figure_workflow.ps1)
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "Installing tex-tools..."
Copy-Item "$Here\tex-tools\figure_workflow.ps1" "$TexTools\figure_workflow.ps1" -Force -ErrorAction SilentlyContinue

# ─────────────────────────────────────────────────────────────────────────────
# 5) PATH에 tex-tools 추가(사용자 PATH)
# ─────────────────────────────────────────────────────────────────────────────
$path = [Environment]::GetEnvironmentVariable("PATH","User")
if ($path -notlike "*$TexTools*") {
  [Environment]::SetEnvironmentVariable("PATH", "$path;$TexTools", "User")
  Write-Host "PATH updated with $TexTools (VS Code/터미널 재시작 필요)"
}

# ─────────────────────────────────────────────────────────────────────────────
# 6) 개인 패키지(mystyle.sty) 설치 (TEXMFHOME)
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "Installing mystyle.sty..."
Copy-Item "$Here\texmf\tex\latex\mystyle\mystyle.sty" "$MyStyle\mystyle.sty" -Force -ErrorAction SilentlyContinue

# MiKTeX 파일 DB 갱신
try { & initexmf --update-fndb | Out-Null } catch {}

# ─────────────────────────────────────────────────────────────────────────────
# 7) VS Code 확장 설치(옵션) + 확장 목록 처리
# ─────────────────────────────────────────────────────────────────────────────
if (Get-Command code -ErrorAction SilentlyContinue) {
  $extList = Join-Path $Here "extensions.txt"
  if (Test-Path $extList) {
    Get-Content $extList | ForEach-Object {
      if ($_ -and $_.Trim().Length -gt 0) { code --install-extension $_ }
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 8) 사전 조건 점검(친절 경고) : latexmk / perl / inkscape
# ─────────────────────────────────────────────────────────────────────────────
function Test-Cmd($cmd) {
  try { (Get-Command $cmd -ErrorAction Stop) | Out-Null; return $true } catch { return $false }
}

$warns = @()
if (-not (Test-Cmd "latexmk")) { $warns += "MiKTeX에서 latexmk 패키지를 설치하세요 (MiKTeX Console → Packages → latexmk)." }
if (-not (Test-Cmd "perl"))    { $warns += "Perl이 필요합니다. Strawberry Perl 권장: https://strawberryperl.com/" }
if (-not (Test-Cmd "inkscape")){ $warns += "Inkscape를 설치하세요: https://inkscape.org/release/" }

Write-Host ""
if ($warns.Count -gt 0) {
  Write-Warning "⚠ 필수 구성요소 점검:"
  $warns | ForEach-Object { Write-Warning " - $_" }
} else {
  Write-Host "✅ 필수 구성요소 OK (latexmk / perl / inkscape 발견됨)"
}

Write-Host "`n설치 완료! VS Code를 재시작한 뒤:"
Write-Host " - LaTeX 문서에서 \usepackage{mystyle}"
Write-Host " - Ctrl+Shift+I → Inkscape에서 저장/닫기 → 에디터에서 Ctrl+V"


# param(/
#  [string]$UserName = $env:USERNAME
# )

# $UserDir   = "C:\Users\$UserName"
# $VSUser    = Join-Path $env:APPDATA "Code\User"
# $TexTools  = Join-Path $UserDir "tex-tools"
# $TexmfRoot = Join-Path $UserDir "texmf"
# $MyStyle   = Join-Path $TexmfRoot "tex\latex\mystyle"

# # Create dirs
# New-Item -ItemType Directory -Force -Path $TexTools,$MyStyle | Out-Null
# New-Item -ItemType Directory -Force -Path (Join-Path $VSUser "snippets") | Out-Null

# # Copy VS Code configs from this repo folder
# $Here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Copy-Item "$Here\vscode\settings.json"      "$VSUser\settings.json"      -Force
# Copy-Item "$Here\vscode\keybindings.json"   "$VSUser\keybindings.json"   -Force
# Copy-Item "$Here\vscode\tasks.json"         "$VSUser\tasks.json"         -Force
# Copy-Item "$Here\vscode\snippets\latex.json" "$VSUser\snippets\latex.json" -Force -ErrorAction SilentlyContinue

# # Copy tools
# Copy-Item "$Here\tex-tools\figure_workflow.ps1" "$TexTools\figure_workflow.ps1" -Force

# # Add PATH (user)
# $path = [Environment]::GetEnvironmentVariable("PATH","User")
# if ($path -notlike "*$TexTools*") {
#   [Environment]::SetEnvironmentVariable("PATH", "$path;$TexTools", "User")
#   Write-Host "PATH updated with $TexTools (restart VS Code/terminal)"
# }

# # Install mystyle.sty into TEXMFHOME
# Copy-Item "$Here\texmf\tex\latex\mystyle\mystyle.sty" "$MyStyle\mystyle.sty" -Force

# # Refresh MiKTeX filename DB
# try { & initexmf --update-fndb } catch {}

# # Install VS Code extensions if code CLI available
# if (Get-Command code -ErrorAction SilentlyContinue) {
#   $extList = Join-Path $Here "extensions.txt"
#   if (Test-Path $extList) {
#     Get-Content $extList | ForEach-Object {
#       if ($_ -and $_.Trim().Length -gt 0) { code --install-extension $_ }
#     }
#   }
# }

# Write-Host "`nAll set. In VS Code: Ctrl+Shift+I to start figure workflow, then Ctrl+V to paste."
