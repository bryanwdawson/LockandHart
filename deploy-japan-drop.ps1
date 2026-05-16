# deploy-japan-drop.ps1
# Redeploys the standalone Japan explorer to dawson-japan-2026.netlify.app
# (the no-gate share link). That site is NOT connected to the GitHub repo,
# so a git push won't update it - we ship the folder directly via Netlify CLI.
#
# Auth: reads a Personal Access Token from .netlify-token (gitignored)
# next to this script. Avoids the netlify-login token-persistence issue
# (Norton blocks writes to %APPDATA%\netlify).
#
# One-time setup:
#   1. Install Netlify CLI in a regular terminal (one time):
#        npm install -g netlify-cli
#   2. Generate a Personal Access Token at:
#        https://app.netlify.com/user/applications
#   3. Save the token to .netlify-token in this folder (see RUN-ME-deploy-drop.bat
#      output for an exact PowerShell one-liner if missing).

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$siteName = "dawson-japan-2026"
$siteId = "8d3c3fe5-7e69-432d-b3f8-f1f9bc84591f"
# Publish public/private/ so BOTH japan/ (v1) and japan-v2/ are reachable.
# The minimal index.html at public/private/ redirects the bare URL to v2.
$publishDir = "public/private"
$tokenFile = Join-Path $scriptDir ".netlify-token"

function Fail($msg) {
    Write-Host ""
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host ""
Write-Host "=== Deploy Japan Explorer (Drop site) ===" -ForegroundColor Cyan
Write-Host ""

# Verify Netlify CLI is present.
$cli = Get-Command netlify -ErrorAction SilentlyContinue
if ($null -eq $cli) {
    Write-Host "Netlify CLI not found." -ForegroundColor Yellow
    Write-Host "One-time setup: open a regular terminal and run:" -ForegroundColor Cyan
    Write-Host "  npm install -g netlify-cli" -ForegroundColor White
    Read-Host "Press Enter to close"
    exit 1
}

# Verify token file exists.
if (-not (Test-Path $tokenFile)) {
    Write-Host "Auth token file missing: .netlify-token" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Generate a Personal Access Token at:" -ForegroundColor Cyan
    Write-Host "  https://app.netlify.com/user/applications" -ForegroundColor White
    Write-Host ""
    Write-Host "Then save it to .netlify-token in this folder. Fastest way:" -ForegroundColor Cyan
    Write-Host "Open a regular PowerShell terminal here and run (paste your token in place of YOUR_TOKEN):" -ForegroundColor White
    Write-Host "  'YOUR_TOKEN' | Out-File -FilePath '$tokenFile' -Encoding ASCII -NoNewline" -ForegroundColor White
    Read-Host "Press Enter to close"
    exit 1
}

$token = (Get-Content -Path $tokenFile -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($token)) { Fail ".netlify-token is empty." }

if (-not (Test-Path $publishDir)) { Fail "Folder not found: $publishDir" }

# Set env var for this process only - netlify CLI will pick it up.
$env:NETLIFY_AUTH_TOKEN = $token

Write-Host "Deploying $publishDir -> $siteName.netlify.app ..." -ForegroundColor Cyan
Write-Host ""

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
netlify deploy --prod --dir $publishDir --site $siteId --message "drop redeploy $stamp"
$deployExit = $LASTEXITCODE

# Clear token from env immediately.
Remove-Item Env:\NETLIFY_AUTH_TOKEN -ErrorAction SilentlyContinue

if ($deployExit -ne 0) {
    Fail "Deploy failed. If 'Unauthorized: could not retrieve project', the token may belong to a different account than the one that owns $siteName."
}

Write-Host ""
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host "DEPLOYED. Live in ~5-10 seconds at:" -ForegroundColor Green
Write-Host "  v2 (new): https://$siteName.netlify.app/japan-v2/" -ForegroundColor Green
Write-Host "  v1 (old): https://$siteName.netlify.app/japan/" -ForegroundColor Green
$bust = Get-Date -Format "yyyyMMddHHmm"
Write-Host "Bare URL auto-redirects to v2. Hard-refresh phone, or use ?v=$bust to bust cache." -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to close"
