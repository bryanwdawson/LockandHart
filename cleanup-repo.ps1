# cleanup-repo.ps1
# Untracks one-shot scratch files that got swept into the repo, then commits
# and pushes. Files stay on your disk - this only removes them from git.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$scratch = @(
    "add_sukiyaki_pin.py",
    "build_cards.py",
    "build_wagyu.py",
    "check_kaiseki.py",
    "check_pins.py",
    "fix_pins.py",
    "fix_quotes.py",
    "commit_msg.txt",
    "preview-japan.js"
)

Write-Host ""
Write-Host "=== Untracking scratch files (kept on disk, removed from git) ===" -ForegroundColor Cyan
$any = $false
foreach ($f in $scratch) {
    git ls-files --error-unmatch $f 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        git rm --cached --quiet $f
        Write-Host "  untracked: $f" -ForegroundColor Green
        $any = $true
    } else {
        Write-Host "  skipped (not tracked): $f" -ForegroundColor DarkGray
    }
}

git add .gitignore

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host ""
    Write-Host "Nothing to clean up - repo is already tidy." -ForegroundColor Yellow
    Read-Host "Press Enter to close"
    exit 0
}

Write-Host ""
Write-Host "=== Commit + push ===" -ForegroundColor Cyan
git commit -m "Repo cleanup: untrack one-shot scratch scripts, extend .gitignore"
if ($LASTEXITCODE -ne 0) {
    Write-Host "git commit failed." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "git push failed - check internet / GitHub login." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host ""
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host "DONE. Repo cleaned and pushed. Netlify will rebuild." -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
Read-Host "Press Enter to close"
