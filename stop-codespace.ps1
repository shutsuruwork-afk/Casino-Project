# Usage: .\stop-codespace.ps1 [codespace-name]
param([string]$CodespaceName)

$ErrorActionPreference = "Stop"

foreach ($p in @("C:\Program Files\GitHub CLI", "$env:LOCALAPPDATA\Programs\GitHub CLI")) {
    if (Test-Path $p) { $env:Path += ";$p" }
}

$null = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] gh auth login required." -ForegroundColor Red
    Pause; exit 1
}

if (-not $CodespaceName) {
    $running = & gh codespace list --json name,state 2>&1 | ConvertFrom-Json | Where-Object { $_.state -eq "Available" }
    if ($null -eq $running -or @($running).Count -eq 0) {
        Write-Host "[ERROR] No running codespace found." -ForegroundColor Red
        Pause; exit 1
    }
    if ($running -is [array]) { $CodespaceName = $running[0].name }
    else { $CodespaceName = $running.name }
}

& gh codespace stop -c $CodespaceName 2>&1 | Out-Null
