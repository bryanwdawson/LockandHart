# extract-walking-paths.ps1
# Reads EXIF GPS from photos in public/private/japan/photos/, filters to
# Mt. Inari (Apr 25, 09:00-14:00) and Higashiyama (Apr 26, 09:00-15:00),
# dedupes within 30m, writes japan-v2/walking-paths.json.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$repo      = 'C:\Users\Dawson\projects\lockandhart-com'
$photosDir = Join-Path $repo 'public\private\japan\photos'
$outDir    = Join-Path $repo 'public\private\japan-v2'
$outFile   = Join-Path $outDir 'walking-paths.json'

if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

function Get-RationalArray {
    param([byte[]]$bytes)
    $count = [int]($bytes.Length / 8)
    $vals  = New-Object 'double[]' $count
    for ($i = 0; $i -lt $count; $i++) {
        $num = [BitConverter]::ToUInt32($bytes, $i * 8)
        $den = [BitConverter]::ToUInt32($bytes, $i * 8 + 4)
        if ($den -eq 0) { $vals[$i] = 0 } else { $vals[$i] = [double]$num / [double]$den }
    }
    return ,$vals
}

function Get-ExifGps {
    param([string]$path)
    $img = $null
    try {
        $img = [System.Drawing.Image]::FromFile($path)
        $ids = @{}
        foreach ($p in $img.PropertyItems) { $ids[$p.Id] = $p }
        if (-not ($ids.ContainsKey(2) -and $ids.ContainsKey(4))) { return $null }
        $latRef = if ($ids.ContainsKey(1)) { [System.Text.Encoding]::ASCII.GetString($ids[1].Value).TrimEnd("`0") } else { 'N' }
        $lonRef = if ($ids.ContainsKey(3)) { [System.Text.Encoding]::ASCII.GetString($ids[3].Value).TrimEnd("`0") } else { 'E' }
        $latParts = Get-RationalArray $ids[2].Value
        $lonParts = Get-RationalArray $ids[4].Value
        if ($latParts.Length -lt 3 -or $lonParts.Length -lt 3) { return $null }
        $lat = $latParts[0] + $latParts[1] / 60.0 + $latParts[2] / 3600.0
        $lon = $lonParts[0] + $lonParts[1] / 60.0 + $lonParts[2] / 3600.0
        if ($latRef -eq 'S') { $lat = -$lat }
        if ($lonRef -eq 'W') { $lon = -$lon }
        $alt = $null
        if ($ids.ContainsKey(6)) {
            $altParts = Get-RationalArray $ids[6].Value
            if ($altParts.Length -ge 1) { $alt = $altParts[0] }
            if ($ids.ContainsKey(5) -and $ids[5].Value[0] -eq 1) { $alt = -$alt }
        }
        return [pscustomobject]@{ lat = $lat; lon = $lon; alt = $alt }
    }
    catch { return $null }
    finally { if ($img) { $img.Dispose() } }
}

function Haversine-Meters {
    param([double]$lat1, [double]$lon1, [double]$lat2, [double]$lon2)
    $R = 6371000.0
    $toRad = [Math]::PI / 180.0
    $dLat = ($lat2 - $lat1) * $toRad
    $dLon = ($lon2 - $lon1) * $toRad
    $a = [Math]::Sin($dLat/2) * [Math]::Sin($dLat/2) +
         [Math]::Cos($lat1 * $toRad) * [Math]::Cos($lat2 * $toRad) *
         [Math]::Sin($dLon/2) * [Math]::Sin($dLon/2)
    $c = 2 * [Math]::Atan2([Math]::Sqrt($a), [Math]::Sqrt(1 - $a))
    return $R * $c
}

function Parse-FileTime {
    param([string]$name)
    if ($name -match '^(\d{8})_(\d{6})') {
        $d = $matches[1]; $t = $matches[2]
        return [datetime]::ParseExact("$d$t", 'yyyyMMddHHmmss', $null)
    }
    return $null
}

function Process-Window {
    param([string]$dateStr, [int]$startHour, [int]$endHour, [string]$label)
    Write-Host "[$label] scanning $dateStr $startHour`:00 - $endHour`:00"
    $pattern = Join-Path $photosDir "${dateStr}_*.jpg"
    $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
    Write-Host "  found $($files.Count) files for $dateStr"
    $points = New-Object 'System.Collections.Generic.List[object]'
    $rejectedOutOfArea = 0; $noGps = 0
    foreach ($f in $files) {
        $ts = Parse-FileTime $f.Name
        if ($null -eq $ts) { continue }
        if ($ts.Hour -lt $startHour -or $ts.Hour -ge $endHour) { continue }
        $gps = Get-ExifGps $f.FullName
        if ($null -eq $gps) { $noGps++; continue }
        if ($gps.lat -lt 34.90 -or $gps.lat -gt 35.10 -or $gps.lon -lt 135.70 -or $gps.lon -gt 135.85) {
            $rejectedOutOfArea++; continue
        }
        $points.Add([pscustomobject]@{ file = $f.Name; time = $ts; lat = $gps.lat; lon = $gps.lon; alt = $gps.alt })
    }
    $sorted = $points | Sort-Object time
    Write-Host "  GPS-tagged in window: $($sorted.Count)"
    Write-Host "  no-GPS / unreadable: $noGps"
    Write-Host "  rejected (out of Kyoto bbox): $rejectedOutOfArea"
    if ($sorted.Count -eq 0) {
        return [pscustomobject]@{ points = @(); firstTime = $null; lastTime = $null; distance_km = 0; elev_gain_m = 0; raw_count = 0; no_gps = $noGps; rejected = $rejectedOutOfArea }
    }
    $kept = New-Object 'System.Collections.Generic.List[object]'
    $kept.Add($sorted[0])
    for ($i = 1; $i -lt $sorted.Count; $i++) {
        $prev = $kept[$kept.Count - 1]; $cur = $sorted[$i]
        $d = Haversine-Meters $prev.lat $prev.lon $cur.lat $cur.lon
        if ($d -ge 30) { $kept.Add($cur) }
    }
    $dist = 0.0; $elevGain = 0.0
    for ($i = 1; $i -lt $kept.Count; $i++) {
        $a = $kept[$i - 1]; $b = $kept[$i]
        $dist += Haversine-Meters $a.lat $a.lon $b.lat $b.lon
        if ($a.alt -ne $null -and $b.alt -ne $null) {
            $delta = $b.alt - $a.alt
            if ($delta -gt 0) { $elevGain += $delta }
        }
    }
    Write-Host "  kept after 30m dedupe: $($kept.Count)"
    Write-Host "  distance: $([math]::Round($dist/1000,2)) km, elev gain: $([math]::Round($elevGain,0)) m"
    return [pscustomobject]@{ points = $kept; firstTime = $sorted[0].time; lastTime = $sorted[$sorted.Count - 1].time; distance_km = [math]::Round($dist / 1000, 2); elev_gain_m = [math]::Round($elevGain, 0); raw_count = $sorted.Count; no_gps = $noGps; rejected = $rejectedOutOfArea }
}

$inari = Process-Window -dateStr '20260425' -startHour 9 -endHour 14 -label 'Mt. Inari'
$higashi = Process-Window -dateStr '20260426' -startHour 9 -endHour 15 -label 'Higashiyama'

function Build-PathBlock {
    param($result, $id, $name, $label, $color, $dateText)
    $pairs = New-Object 'System.Collections.Generic.List[string]'
    foreach ($p in $result.points) {
        $latR = [math]::Round($p.lat, 6); $lonR = [math]::Round($p.lon, 6)
        $pairs.Add("[$latR, $lonR]")
    }
    $pathJson = '[' + ($pairs -join ', ') + ']'
    $evidence = if ($result.points.Count -gt 0) {
        $t1 = $result.firstTime.ToString('HH:mm'); $t2 = $result.lastTime.ToString('HH:mm')
        "EXIF GPS from $($result.raw_count) photos between $t1 and $t2 on $dateText"
    } else {
        "No EXIF GPS data found in photos on $dateText. Phone may have had location off."
    }
    return @"
    {
      "id": "$id",
      "name": "$name",
      "label": "$label",
      "category": "walking",
      "style": { "color": "$color", "weight": 3, "dashArray": "5 3", "opacity": 0.85 },
      "path": $pathJson,
      "evidence": "$evidence",
      "stats": { "points": $($result.points.Count), "distance_km": $($result.distance_km), "elevation_gain_m": $($result.elev_gain_m) }
    }
"@
}

$inariBlock = Build-PathBlock $inari   'mt-inari-climb'    'Mt. Inari climb'    'Apr 25 - Up the mountain through the torii' '#c0392b' '2026-04-25'
$higashiBlock = Build-PathBlock $higashi 'higashiyama-trail' 'Higashiyama Trail'  'Apr 26 - Kyoto eastern hills, met Max'      '#8e44ad' '2026-04-26'

$json = @"
{
  "_doc": "Real walking paths extracted from photo EXIF GPS. Mt. Inari and Higashiyama Trail.",
  "_generated": "2026-05-16",
  "paths": [
$inariBlock,
$higashiBlock
  ]
}
"@

Set-Content -Path $outFile -Value $json -Encoding UTF8

Write-Host ""
Write-Host "=== SUMMARY ==="
Write-Host "Mt. Inari   : $($inari.points.Count) points, $($inari.distance_km) km, elev gain $($inari.elev_gain_m) m"
Write-Host "Higashiyama : $($higashi.points.Count) points, $($higashi.distance_km) km, elev gain $($higashi.elev_gain_m) m"
Write-Host "Wrote: $outFile"
