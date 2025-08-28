# backup.ps1 - Back up VS Code + LaTeX + Inkscape workflow files
# Usage:
#   PowerShell (not admin):
#     Set-ExecutionPolicy -Scope CurrentUser RemoteSigned   # first time only
#     .\backup.ps1
#
# The script creates a zip on your Desktop with a timestamp.

# backup.ps1
# latex-setup 전체 환경(설정/스니펫/texmf/tex-tools)을
# 현재 디렉토리에 latex-backup-YYYYMMDD.zip 으로 저장

param(
  [string]$UserName = $env:USERNAME
)

$ErrorActionPreference = "Stop"

# 경로 정의
$UserDir   = "C:\Users\$UserName"
$VSUser    = Join-Path $env:APPDATA "Code\User"
$TexTools  = Join-Path $UserDir "tex-tools"
$TexmfRoot = Join-Path $UserDir "texmf"

# 날짜 기반 아카이브 이름
$Date = Get-Date -Format "yyyyMMdd"
$BackupZip = "latex-backup-$Date.zip"

# 임시 백업 폴더 만들기
$TempDir = Join-Path $env:TEMP "latex-backup-$Date"
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
New-Item -ItemType Directory -Path $TempDir | Out-Null

Write-Host "Backing up VSCode settings..."
Copy-Item "$VSUser\settings.json"   $TempDir -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\keybindings.json" $TempDir -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\tasks.json"      $TempDir -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\snippets"        $TempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Backing up tex-tools..."
if (Test-Path $TexTools) {
  Copy-Item $TexTools (Join-Path $TempDir "tex-tools") -Recurse -Force
}

Write-Host "Backing up texmf (personal packages)..."
if (Test-Path $TexmfRoot) {
  Copy-Item $TexmfRoot (Join-Path $TempDir "texmf") -Recurse -Force
}

# 압축 생성
if (Test-Path $BackupZip) { Remove-Item $BackupZip -Force }
Compress-Archive -Path "$TempDir\*" -DestinationPath $BackupZip

# 임시 폴더 삭제
Remove-Item -Recurse -Force $TempDir

Write-Host "`n✅ Backup completed: $BackupZip"


# $ErrorActionPreference = "Stop"

# # Paths
# $UserName = $env:USERNAME
# $UserDir  = "C:\Users\$UserName"
# $VSUser   = Join-Path $env:APPDATA "Code\User"
# $TexTools = Join-Path $UserDir "tex-tools"
# $Texmf    = Join-Path $UserDir "texmf"

# # Temp gather dir
# $Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
# $TmpRoot = Join-Path $env:TEMP "latex-setup-backup-$Stamp"
# $OutZip  = Join-Path "$UserDir\Desktop" "latex-setup-backup-$Stamp.zip"

# # Clean and recreate
# if (Test-Path $TmpRoot) { Remove-Item $TmpRoot -Recurse -Force }
# New-Item -ItemType Directory -Path $TmpRoot | Out-Null

# # Collect VS Code user configs
# $DstVS = Join-Path $TmpRoot "vscode"
# New-Item -ItemType Directory -Path (Join-Path $DstVS "snippets") -Force | Out-Null
# Copy-Item "$VSUser\settings.json"  $DstVS -Force -ErrorAction SilentlyContinue
# Copy-Item "$VSUser\keybindings.json" $DstVS -Force -ErrorAction SilentlyContinue
# Copy-Item "$VSUser\tasks.json"     $DstVS -Force -ErrorAction SilentlyContinue
# Copy-Item "$VSUser\snippets\*.json" (Join-Path $DstVS "snippets") -Force -ErrorAction SilentlyContinue

# # Collect tex-tools scripts
# $DstTools = Join-Path $TmpRoot "tex-tools"
# if (Test-Path $TexTools) {
#   Copy-Item "$TexTools\*" $DstTools -Recurse -Force -ErrorAction SilentlyContinue
# }

# # Collect TEXMF personal style(s)
# $DstTexmf = Join-Path $TmpRoot "texmf\tex\latex"
# if (Test-Path "$Texmf\tex\latex") {
#   New-Item -ItemType Directory -Path $DstTexmf -Force | Out-Null
#   Copy-Item "$Texmf\tex\latex\*" $DstTexmf -Recurse -Force -ErrorAction SilentlyContinue
# }

# # Save VS Code extensions list
# $ExtFile = Join-Path $TmpRoot "extensions.txt"
# try {
#   code --list-extensions > $ExtFile
# } catch {
#   # VS Code CLI not found, skip
# }

# # Save system info for reference
# $Info = @()
# $Info += "User: $UserName"
# $Info += "Date: $(Get-Date)"
# $Info += "VS Code User dir: $VSUser"
# $Info += "tex-tools dir: $TexTools"
# $Info += "texmf dir: $Texmf"
# $Info | Out-File -FilePath (Join-Path $TmpRoot "info.txt") -Encoding UTF8

# # Zip it
# if (Test-Path $OutZip) { Remove-Item $OutZip -Force }
# Compress-Archive -Path (Join-Path $TmpRoot "*") -DestinationPath $OutZip -Force

# Write-Host "`nBackup created: $OutZip"

