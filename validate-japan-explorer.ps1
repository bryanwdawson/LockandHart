# validate-japan-explorer.ps1
# Checks the Japan Explorer data after edits: JSON validity + photo references.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$base = Join-Path $scriptDir "public\private\japan"
$errLog = Join-Path $scriptDir "validate-japan-explorer.error.log"

function FailWith($msg, $err) {
    [System.IO.File]::WriteAllText($errLog, "$msg`r`n`r`n$($err | Out-String)")
    Write-Host ""
    Write-Host "FAILED: $msg" -ForegroundColor Red
    Write-Host "Details written to: $errLog" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

try {
    Write-Host ""
    Write-Host "Checking Japan Explorer data..." -ForegroundColor Cyan
    Write-Host ""

    $bad = $false

    # 1. days.json parses
    $daysPath = Join-Path $base "days.json"
    $days = $null
    try {
        $days = Get-Content -LiteralPath $daysPath -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "  OK   days.json parses ($($days.days.Count) days, $($days.people.Count) people)" -ForegroundColor Green
    } catch {
        Write-Host "  FAIL days.json does NOT parse as JSON" -ForegroundColor Red
        Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
        $bad = $true
    }

    # 2. pins.json parses
    $pinsPath = Join-Path $base "pins.json"
    $pins = $null
    try {
        $pins = Get-Content -LiteralPath $pinsPath -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "  OK   pins.json parses ($($pins.pins.Count) pins)" -ForegroundColor Green
    } catch {
        Write-Host "  FAIL pins.json does NOT parse as JSON" -ForegroundColor Red
        Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
        $bad = $true
    }

    # 3. photo references exist (only if pins parsed)
    if ($pins) {
        $photoDir = Join-Path $base "photos"
        $missing = New-Object System.Collections.Generic.List[string]
        foreach ($p in $pins.pins) {
            $refs = New-Object System.Collections.Generic.List[string]
            if ($p.hero) { $refs.Add([string]$p.hero) }
            if ($p.photos) { foreach ($ph in $p.photos) { if ($ph) { $refs.Add([string]$ph) } } }
            foreach ($r in $refs) {
                if (-not (Test-Path -LiteralPath (Join-Path $photoDir $r))) {
                    $missing.Add("$($p.id): $r")
                }
            }
        }
        if ($missing.Count -eq 0) {
            Write-Host "  OK   every hero/photos file referenced in pins.json exists" -ForegroundColor Green
        } else {
            Write-Host "  WARN $($missing.Count) photo reference(s) point to missing files:" -ForegroundColor Yellow
            foreach ($m in $missing) { Write-Host "       $m" -ForegroundColor Yellow }
            Write-Host "       (these pins will show a broken image - not fatal, but worth a look)" -ForegroundColor Yellow
        }
    }

    Write-Host ""
    Write-Host "-------------------------------------------" -ForegroundColor Cyan
    if ($bad) {
        Write-Host "RESULT: a JSON file is broken. Do NOT deploy until fixed." -ForegroundColor Red
    } else {
        Write-Host "RESULT: data is valid. Safe to open index.html and deploy." -ForegroundColor Green
    }
    Write-Host "-------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to close"
}
catch {
    FailWith "Unexpected error during validation" $_
}
