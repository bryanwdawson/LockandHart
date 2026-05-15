# resize-all-photos.ps1
# Shrinks any oversized photo in the explorer's photos folder to max 1400px,
# in place, so the folder is light enough for Netlify Drop. Photos already
# at or under 1400px are left untouched.

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$photoDir = Join-Path $scriptDir "public\private\japan\photos"
$errLog = Join-Path $scriptDir "resize-all-photos.error.log"

function FailWith($msg, $err) {
    [System.IO.File]::WriteAllText($errLog, "$msg`r`n`r`n$($err | Out-String)")
    Write-Host ""
    Write-Host "FAILED: $msg" -ForegroundColor Red
    Write-Host "Details written to: $errLog" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

try {
    Add-Type -AssemblyName System.Drawing

    $maxEdge = 1400
    $quality = 85

    if (-not (Test-Path -LiteralPath $photoDir)) {
        FailWith "Photos folder not found: $photoDir" "Check the repo layout."
    }

    $files = Get-ChildItem -LiteralPath $photoDir -File |
             Where-Object { $_.Extension -match '^\.(jpg|jpeg|png)$' }

    Write-Host ""
    Write-Host "Scanning $($files.Count) photos in the explorer folder..." -ForegroundColor Cyan
    Write-Host "Resizing anything over $maxEdge px, in place." -ForegroundColor Cyan
    Write-Host ""

    $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
                 Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)

    $resized = 0; $skipped = 0; $errors = 0
    $bytesBefore = 0; $bytesAfter = 0

    foreach ($f in $files) {
        $bytesBefore += $f.Length
        try {
            $img  = [System.Drawing.Image]::FromFile($f.FullName)
            $w    = $img.Width
            $h    = $img.Height
            $long = [Math]::Max($w, $h)

            if ($long -le $maxEdge) {
                $img.Dispose()
                $skipped++
                $bytesAfter += $f.Length
            } else {
                $scale = $maxEdge / $long
                $nw = [int]($w * $scale)
                $nh = [int]($h * $scale)
                $bmp = New-Object System.Drawing.Bitmap($nw, $nh)
                $g = [System.Drawing.Graphics]::FromImage($bmp)
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.DrawImage($img, 0, 0, $nw, $nh)
                $g.Dispose()
                $img.Dispose()
                $tmp = $f.FullName + ".tmp"
                $bmp.Save($tmp, $jpegCodec, $encParams)
                $bmp.Dispose()
                Move-Item -LiteralPath $tmp -Destination $f.FullName -Force
                $resized++
                $bytesAfter += (Get-Item -LiteralPath $f.FullName).Length
                Write-Host "  resized  $($f.Name)  ($w x $h)" -ForegroundColor Green
            }
        } catch {
            $errors++
            $bytesAfter += $f.Length
            Write-Host "  ERR      $($f.Name) - $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }

    $mbBefore = [Math]::Round($bytesBefore / 1MB, 1)
    $mbAfter  = [Math]::Round($bytesAfter / 1MB, 1)

    Write-Host ""
    Write-Host "-------------------------------------------" -ForegroundColor Cyan
    Write-Host "Done. Resized: $resized   Already small: $skipped   Errors: $errors" -ForegroundColor Cyan
    Write-Host "Photos folder: $mbBefore MB  ->  $mbAfter MB" -ForegroundColor Cyan
    Write-Host "Now retry the Netlify Drop." -ForegroundColor Cyan
    Write-Host "-------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to close"
}
catch {
    FailWith "Unexpected error while resizing" $_
}
