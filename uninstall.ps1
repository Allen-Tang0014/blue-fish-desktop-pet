# Remove the desktop shortcuts created by setup.ps1 (the project folder itself is left alone).
$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$namesRaw = [System.IO.File]::ReadAllText((Join-Path $root 'config\names.json'), [System.Text.Encoding]::UTF8)
$names = $namesRaw | ConvertFrom-Json
$desk = [Environment]::GetFolderPath('Desktop')
foreach ($n in @($names.start, $names.stop)) {
  $p = Join-Path $desk $n
  if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; Write-Host "removed shortcut: $n" }
}
Write-Host ''
Write-Host 'Shortcuts removed. To delete the pet completely, stop it first (stop-pet.cmd)'
Write-Host 'and then delete this whole folder - config, memory and the Electron runtime all live inside it.'
