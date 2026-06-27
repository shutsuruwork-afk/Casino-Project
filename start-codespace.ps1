# Usage: .\start-codespace.ps1 -Repo "owner/repo" [-CodespaceName "name"]
param(
    [string]$Repo,
    [string]$CodespaceName
)

$ErrorActionPreference = "Stop"

foreach ($p in @("C:\Program Files\GitHub CLI", "$env:LOCALAPPDATA\Programs\GitHub CLI")) {
    if (Test-Path $p) { $env:Path += ";$p" }
}

$null = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] gh auth login required." -ForegroundColor Red
    Pause; exit 1
}

# Codespace名が未指定なら一覧から自動選択
if (-not $CodespaceName) {
    $filter = if ($Repo) { @("-R", $Repo) } else { @() }
    $csList = & gh codespace list @filter --json name,state,repository 2>&1 | ConvertFrom-Json
    if ($null -eq $csList -or @($csList).Count -eq 0) {
        # Codespacesが存在しない → 新規作成
        if (-not $Repo) {
            Write-Host "[ERROR] No codespace found. Specify -Repo to create one." -ForegroundColor Red
            Pause; exit 1
        }
        Write-Host "Creating new Codespace for $Repo ..." -ForegroundColor Yellow
        & gh codespace create -R $Repo | Out-Null
        $csList = & gh codespace list -R $Repo --json name,state 2>&1 | ConvertFrom-Json
    }
    $available = @($csList) | Where-Object { $_.state -eq "Available" }
    if ($available) { $CodespaceName = $available[0].name }
    else            { $CodespaceName = $csList[0].name }
}

# Shutdown中なら再起動
$info = & gh codespace list --json name,state 2>&1 | ConvertFrom-Json | Where-Object { $_.name -eq $CodespaceName }
if ($info.state -eq "Shutdown") {
    & gh codespace start -c $CodespaceName 2>&1 | Out-Null
}

# SSH設定更新
$sshDir = "$HOME\.ssh"; $sshConfigPath = "$sshDir\config"
if (!(Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir -Force | Out-Null }
if (Test-Path $sshConfigPath) {
    $lines = Get-Content $sshConfigPath
    $newLines = @(); $skip = $false
    foreach ($line in $lines) {
        if ($line -match "^Host cs\.") { $skip = $true; continue }
        if ($skip -and $line -match "^\S") { $skip = $false }
        if (-not $skip) { $newLines += $line }
    }
    $newLines | Out-File -FilePath $sshConfigPath -Encoding ascii
}
& gh codespace ssh -c $CodespaceName --config | Out-File -FilePath $sshConfigPath -Append -Encoding ascii

"cs.$CodespaceName.main" | Set-Clipboard
