# deploy-lockandhart.ps1
# Builds the React site locally to catch errors, then commits and pushes to
# GitHub. Netlify (if connected to the repo) auto-builds and publishes on push.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

function Fail($msg) {
    Write-Host ""
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Write-Host "Nothing was pushed. Fix the issue above and run again." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host ""
Write-Host "=== Step 1 of 4: Build the site locally ===" -ForegroundColor Cyan
Write-Host "(this catches errors before anything goes live)"
npm run build
if ($LASTEXITCODE -ne 0) { Fail "The build failed. The site was NOT pushed." }
Write-Host "Build OK." -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 2 of 4: Stage changes ===" -ForegroundColor Cyan
git add -A
if ($LASTEXITCODE -ne 0) { Fail "git add failed." }

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host ""
    Write-Host "No changes to commit - the repo is already up to date." -ForegroundColor Yellow
    Write-Host "If the site still looks old, the issue is on Netlify's side, not here."
    Read-Host "Press Enter to close"
    exit 0
}
Write-Host "Files staged:" -ForegroundColor Green
git status --short

Write-Host ""
Write-Host "=== Step 3 of 4: Commit ===" -ForegroundColor Cyan
$msg = "Japan Explorer: photo review corrections, pin splits, goshuin alignment, crow + children shrines, hotel coords"
git commit -m $msg
if ($LASTEXITCODE -ne 0) { Fail "git commit failed." }

Write-Host ""
Write-Host "=== Step 4 of 4: Push to GitHub (origin/main) ===" -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) { Fail "git push failed. Check your internet / GitHub login." }

Write-Host ""
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host "PUSHED. If the repo is connected to a Netlify site," -ForegroundColor Green
Write-Host "Netlify is now building it. Check your Netlify dashboard" -ForegroundColor Green
Write-Host "for the deploy progress and the live URL." -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to close"
