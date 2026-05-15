# audit-pins.ps1
# Lists every pin with its photo + story-card counts so imbalances are obvious.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pinsPath = Join-Path $scriptDir "public\private\japan\pins.json"
$errLog = Join-Path $scriptDir "audit-pins.error.log"

function FailWith($msg, $err) {
    [System.IO.File]::WriteAllText($errLog, "$msg`r`n`r`n$($err | Out-String)")
    Write-Host ""
    Write-Host "FAILED: $msg" -ForegroundColor Red
    Write-Host "Details: $errLog" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

try {
    $pins = (Get-Content -LiteralPath $pinsPath -Raw -Encoding UTF8 | ConvertFrom-Json).pins

    $rows = foreach ($p in $pins) {
        $pc = if ($p.photos) { @($p.photos).Count } else { 0 }
        $cc = if ($p.extra_cards) { @($p.extra_cards).Count } else { 0 }
        [PSCustomObject]@{
            Photos = $pc
            Cards  = $cc
            Id     = [string]$p.id
            Title  = [string]$p.title
        }
    }

    Write-Host ""
    Write-Host "=== ALL PINS, sorted by photo count ===" -ForegroundColor Cyan
    $rows | Sort-Object Photos -Descending | Format-Table Photos, Cards, Id, Title -AutoSize

    Write-Host "=== TOO MUCH - 20+ photos (split candidates) ===" -ForegroundColor Yellow
    $heavy = $rows | Where-Object { $_.Photos -ge 20 } | Sort-Object Photos -Descending
    if ($heavy) { $heavy | Format-Table Photos, Cards, Id -AutoSize } else { Write-Host "  (none)" }

    Write-Host "=== TOO LITTLE - under 3 photos (thin pins) ===" -ForegroundColor Yellow
    $thin = $rows | Where-Object { $_.Photos -lt 3 } | Sort-Object Photos
    if ($thin) { $thin | Format-Table Photos, Cards, Id -AutoSize } else { Write-Host "  (none)" }

    Write-Host ("Total pins: {0}   |   Total photo slots: {1}" -f $rows.Count, (($rows | Measure-Object Photos -Sum).Sum)) -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to close"
}
catch {
    FailWith "Unexpected error during pin audit" $_
}
