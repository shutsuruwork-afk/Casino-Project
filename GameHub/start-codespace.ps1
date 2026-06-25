$ErrorActionPreference = "Stop"

# ============================================
# GameHub Codespace Auto Launcher
# ============================================
# !! ここだけ書き換えてください !!
$REPO = "shutsuruwork-afk/Casino-Project"
# ============================================

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  GameHub Codespace Auto Launcher  " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# GitHub CLIのパスを確実に通す
$ghPath = "C:\Program Files\GitHub CLI"
if (Test-Path $ghPath) {
    $env:Path += ";$ghPath"
}

# 1. GitHub CLIのログインチェック
$authResult = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] GitHub CLI not logged in." -ForegroundColor Red
    Write-Host "Run 'gh auth login' first." -ForegroundColor Yellow
    Pause
    exit 1
}
Write-Host "[OK] GitHub CLI logged in." -ForegroundColor Green

# 2. Codespaceの検索・作成
Write-Host "Checking for existing Codespace..." -ForegroundColor Yellow
$csJson = & gh codespace list -R $REPO --json name,state 2>&1
$csList = $csJson | ConvertFrom-Json

$csName = ""

if ($null -eq $csList -or $csList.Count -eq 0) {
    Write-Host "No Codespace found. Creating a new one (this may take a few minutes)..." -ForegroundColor Yellow
    & gh codespace create -R $REPO
    $csJson = & gh codespace list -R $REPO --json name 2>&1
    $csList = $csJson | ConvertFrom-Json
    $csName = $csList[0].name
} else {
    # Available(稼働中)のものを優先、なければ最初のものを使う
    $available = $csList | Where-Object { $_.state -eq "Available" }
    if ($available) {
        $csName = $available[0].name
    } else {
        $csName = $csList[0].name
    }
    Write-Host "[OK] Found Codespace: $csName" -ForegroundColor Green
}

# 3. SSH設定の更新（重複を防ぐため、既存のCodespace設定を一度削除してから追記）
Write-Host "Updating SSH config..." -ForegroundColor Yellow
$sshDir = "$HOME\.ssh"
$sshConfigPath = "$sshDir\config"

# .sshフォルダが無ければ作成
if (!(Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
}

# 既存のCodespace用SSH設定を除去してからクリーンに書き直す
if (Test-Path $sshConfigPath) {
    $existingConfig = Get-Content $sshConfigPath -Raw
    # "Host cs." で始まるCodespaceブロックを全て除去
    $cleanedConfig = $existingConfig -replace '(?s)Host cs\..*?(?=Host |$)', ''
    $cleanedConfig = $cleanedConfig.Trim()
    if ($cleanedConfig) {
        $cleanedConfig | Out-File -FilePath $sshConfigPath -Encoding ascii
    } else {
        "" | Out-File -FilePath $sshConfigPath -Encoding ascii
    }
}

# 新しいSSH設定を追記
& gh codespace ssh -c $csName --config | Out-File -FilePath $sshConfigPath -Append -Encoding ascii
Write-Host "[OK] SSH config updated." -ForegroundColor Green

# 4. Cursorを起動
$repoDir = ($REPO -split '/')[1]
$hostName = "cs.$csName.main"
$remoteUri = "vscode-remote://ssh-remote+$hostName/workspaces/$repoDir"

Write-Host "Launching Cursor -> $hostName ..." -ForegroundColor Cyan
& cursor --folder-uri "$remoteUri"

Write-Host "[DONE] Launcher finished!" -ForegroundColor Green
Start-Sleep -Seconds 3
