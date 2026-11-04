# First-run setup: install dependencies, apply the patches, create desktop shortcuts.
# ASCII only on purpose (Windows PowerShell 5.1 reads BOM-less files as ANSI).
param(
  [switch]$SkipInstall,
  [switch]$SkipElectron
)
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
function Say([string]$m) { Write-Host $m }

# ---- 1. Node.js ----
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) {
  Say '[x] Node.js was not found. Install Node.js 22+ (https://nodejs.org), then run setup.cmd again.'
  exit 1
}
$ver = (& node -v) -replace '^v', ''
$major = 0
[void][int]::TryParse(($ver -split '\.')[0], [ref]$major)
Say "[i] Node.js $ver"
if ($major -lt 22) {
  Say '[x] Node.js 22 or newer is required (dsh-pet needs >= 22.12).'
  exit 1
}

# ---- 2. dependencies ----
if (-not $SkipInstall) {
  Say '[i] Installing dependencies (dsh-pet + its runtime deps) ...'
  Push-Location $root
  & npm install --no-audit --no-fund
  Pop-Location
}

# ---- 3. patches ----
$helper = Join-Path $root 'node_modules\dsh-pet\runtime\electron-helper'
if (-not (Test-Path $helper)) {
  Say '[x] node_modules\dsh-pet is missing - npm install did not finish.'
  exit 1
}
Get-ChildItem (Join-Path $root 'patches') -Filter '*.js' | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $helper $_.Name) -Force
  Say "[i] patched runtime/electron-helper/$($_.Name)"
}

# ---- 4. default config ----
$homeDir = Join-Path $root '.dsh-home'
$cfgDir = Join-Path $homeDir 'dsh-pet'
New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$cfg = Join-Path $cfgDir 'main-config.jsonc'
if (-not (Test-Path $cfg)) {
  Copy-Item -LiteralPath (Join-Path $root 'config\main-config.jsonc') -Destination $cfg
  Say "[i] default config: $cfg"
} else {
  Say "[i] keeping the existing config: $cfg"
}

# ---- 5. desktop shortcuts ----
$namesRaw = [System.IO.File]::ReadAllText((Join-Path $root 'config\names.json'), [System.Text.Encoding]::UTF8)
$names = $namesRaw | ConvertFrom-Json
$desk = [Environment]::GetFolderPath('Desktop')
$icon = Join-Path $root 'assets\pet.ico'
$shell = New-Object -ComObject WScript.Shell
function New-Shortcut([string]$Path, [string]$Target, [string]$Desc) {
  if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Force }
  $lnk = $shell.CreateShortcut($Path)
  $lnk.TargetPath = $Target
  $lnk.WorkingDirectory = $root
  if (Test-Path -LiteralPath $icon) { $lnk.IconLocation = "$icon,0" }
  $lnk.Description = $Desc
  $lnk.Save()
}
New-Shortcut (Join-Path $desk $names.start) (Join-Path $root 'start-pet.vbs') 'Start the desktop pet'
New-Shortcut (Join-Path $desk $names.stop) (Join-Path $root 'stop-pet.cmd') 'Stop the desktop pet'
Say "[i] desktop shortcuts: $($names.start) / $($names.stop)"

# ---- 6. Electron runtime ----
if (-not $SkipElectron) {
  $env:DSH_HOME = $homeDir
  $ensure = Join-Path $root 'node_modules\dsh-pet\scripts\ensure-electron.mjs'
  if (Test-Path $ensure) {
    Say '[i] Preparing the Electron runtime (first time only, ~100 MB, mirror: npmmirror) ...'
    Push-Location $root
    try { & node $ensure } catch { Say "[!] Electron pre-download failed: $($_.Exception.Message)" }
    Pop-Location
  }
}

Say ''
Say '=================================================================='
Say ' Done. Double-click the blue-fish shortcut on your desktop.'
Say ' Right-click the pet -> "退出桌宠" (Quit) to close it.'
Say '=================================================================='
