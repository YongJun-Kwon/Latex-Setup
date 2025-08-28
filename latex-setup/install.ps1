param(
  [string]$UserName = $env:USERNAME
)

$UserDir   = "C:\Users\$UserName"
$VSUser    = Join-Path $env:APPDATA "Code\User"
$TexTools  = Join-Path $UserDir "tex-tools"
$TexmfRoot = Join-Path $UserDir "texmf"
$MyStyle   = Join-Path $TexmfRoot "tex\latex\mystyle"

# Create dirs
New-Item -ItemType Directory -Force -Path $TexTools,$MyStyle | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $VSUser "snippets") | Out-Null

# Copy VS Code configs from this repo folder
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$Here\vscode\settings.json"      "$VSUser\settings.json"      -Force
Copy-Item "$Here\vscode\keybindings.json"   "$VSUser\keybindings.json"   -Force
Copy-Item "$Here\vscode\tasks.json"         "$VSUser\tasks.json"         -Force
Copy-Item "$Here\vscode\snippets\latex.json" "$VSUser\snippets\latex.json" -Force -ErrorAction SilentlyContinue

# Copy tools
Copy-Item "$Here\tex-tools\figure_workflow.ps1" "$TexTools\figure_workflow.ps1" -Force

# Add PATH (user)
$path = [Environment]::GetEnvironmentVariable("PATH","User")
if ($path -notlike "*$TexTools*") {
  [Environment]::SetEnvironmentVariable("PATH", "$path;$TexTools", "User")
  Write-Host "PATH updated with $TexTools (restart VS Code/terminal)"
}

# Install mystyle.sty into TEXMFHOME
Copy-Item "$Here\texmf\tex\latex\mystyle\mystyle.sty" "$MyStyle\mystyle.sty" -Force

# Refresh MiKTeX filename DB
try { & initexmf --update-fndb } catch {}

# Install VS Code extensions if code CLI available
if (Get-Command code -ErrorAction SilentlyContinue) {
  $extList = Join-Path $Here "extensions.txt"
  if (Test-Path $extList) {
    Get-Content $extList | ForEach-Object {
      if ($_ -and $_.Trim().Length -gt 0) { code --install-extension $_ }
    }
  }
}

Write-Host "`nAll set. In VS Code: Ctrl+Shift+I to start figure workflow, then Ctrl+V to paste."
