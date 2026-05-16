# list-netlify-sites.ps1
# One-shot diagnostic: lists every Netlify site your token can access.
# Reads the same .netlify-token file the deploy script uses.

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$tokenFile = Join-Path $scriptDir ".netlify-token"
if (-not (Test-Path $tokenFile)) {
    Write-Host "Token file missing: .netlify-token" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$token = (Get-Content -Path $tokenFile -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Token file is empty." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$env:NETLIFY_AUTH_TOKEN = $token

Write-Host ""
Write-Host "=== Looking up dawson-japan-2026 site ID ===" -ForegroundColor Cyan
Write-Host ""

$json = netlify sites:list --json 2>$null | Out-String
try {
    $sites = $json | ConvertFrom-Json
} catch {
    Write-Host "Could not parse site list. Full output:" -ForegroundColor Yellow
    Write-Host $json
    Remove-Item Env:\NETLIFY_AUTH_TOKEN -ErrorAction SilentlyContinue
    Read-Host "Press Enter to close"
    exit 1
}

$match = $sites | Where-Object { $_.name -eq "dawson-japan-2026" -or $_.url -match "dawson-japan-2026" }

if ($null -eq $match) {
    Write-Host "No site matched 'dawson-japan-2026' in your account." -ForegroundColor Red
    Write-Host "All sites your token can access:" -ForegroundColor Yellow
    $sites | ForEach-Object { Write-Host ("  " + $_.name + "  ->  " + $_.url) }
} else {
    Write-Host "MATCH FOUND" -ForegroundColor Green
    Write-Host ""
    Write-Host ("  Site name : " + $match.name)
    Write-Host ("  Site ID   : " + $match.id) -ForegroundColor Cyan
    Write-Host ("  URL       : " + $match.url)
    Write-Host ("  Admin URL : " + $match.admin_url)
    Write-Host ""
    Write-Host "Paste the Site ID line to Claude." -ForegroundColor Yellow
}

Remove-Item Env:\NETLIFY_AUTH_TOKEN -ErrorAction SilentlyContinue
Write-Host ""
Read-Host "Press Enter to close"
