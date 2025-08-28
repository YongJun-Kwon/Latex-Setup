# backup.ps1 - Back up VS Code + LaTeX + Inkscape workflow files
# Usage:
#   PowerShell (not admin):
#     Set-ExecutionPolicy -Scope CurrentUser RemoteSigned   # first time only
#     .\backup.ps1
#
# The script creates a zip on your Desktop with a timestamp.

$ErrorActionPreference = "Stop"

# Paths
$UserName = $env:USERNAME
$UserDir  = "C:\Users\$UserName"
$VSUser   = Join-Path $env:APPDATA "Code\User"
$TexTools = Join-Path $UserDir "tex-tools"
$Texmf    = Join-Path $UserDir "texmf"

# Temp gather dir
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$TmpRoot = Join-Path $env:TEMP "latex-setup-backup-$Stamp"
$OutZip  = Join-Path "$UserDir\Desktop" "latex-setup-backup-$Stamp.zip"

# Clean and recreate
if (Test-Path $TmpRoot) { Remove-Item $TmpRoot -Recurse -Force }
New-Item -ItemType Directory -Path $TmpRoot | Out-Null

# Collect VS Code user configs
$DstVS = Join-Path $TmpRoot "vscode"
New-Item -ItemType Directory -Path (Join-Path $DstVS "snippets") -Force | Out-Null
Copy-Item "$VSUser\settings.json"  $DstVS -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\keybindings.json" $DstVS -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\tasks.json"     $DstVS -Force -ErrorAction SilentlyContinue
Copy-Item "$VSUser\snippets\*.json" (Join-Path $DstVS "snippets") -Force -ErrorAction SilentlyContinue

# Collect tex-tools scripts
$DstTools = Join-Path $TmpRoot "tex-tools"
if (Test-Path $TexTools) {
  Copy-Item "$TexTools\*" $DstTools -Recurse -Force -ErrorAction SilentlyContinue
}

# Collect TEXMF personal style(s)
$DstTexmf = Join-Path $TmpRoot "texmf\tex\latex"
if (Test-Path "$Texmf\tex\latex") {
  New-Item -ItemType Directory -Path $DstTexmf -Force | Out-Null
  Copy-Item "$Texmf\tex\latex\*" $DstTexmf -Recurse -Force -ErrorAction SilentlyContinue
}

# Save VS Code extensions list
$ExtFile = Join-Path $TmpRoot "extensions.txt"
try {
  code --list-extensions > $ExtFile
} catch {
  # VS Code CLI not found, skip
}

# Save system info for reference
$Info = @()
$Info += "User: $UserName"
$Info += "Date: $(Get-Date)"
$Info += "VS Code User dir: $VSUser"
$Info += "tex-tools dir: $TexTools"
$Info += "texmf dir: $Texmf"
$Info | Out-File -FilePath (Join-Path $TmpRoot "info.txt") -Encoding UTF8

# Zip it
if (Test-Path $OutZip) { Remove-Item $OutZip -Force }
Compress-Archive -Path (Join-Path $TmpRoot "*") -DestinationPath $OutZip -Force

Write-Host "`nBackup created: $OutZip"
