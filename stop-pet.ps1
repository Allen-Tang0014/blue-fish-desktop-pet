# Stop the desktop pet: the standalone server first, then its Electron windows.
$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$homeDir = Join-Path $root '.dsh-home'
$killed = 0

Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction SilentlyContinue |
  Where-Object { $_.CommandLine -and $_.CommandLine -like '*dsh-pet*standalone.js*' } |
  ForEach-Object {
    Write-Host "stopping pet server pid=$($_.ProcessId)"
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    $killed++
  }

Get-Process -Name electron -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($homeDir, [System.StringComparison]::OrdinalIgnoreCase) } |
  ForEach-Object {
    Write-Host "stopping pet window pid=$($_.Id)"
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    $killed++
  }

Write-Host "done, stopped $killed process(es)."
