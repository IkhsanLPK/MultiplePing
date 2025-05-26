# ========================================
# Multiple Ping Checker with IP from File
# ========================================

# Path file IP list
$ipFilePath = "iplist.txt"

# Cek apakah file iplist.txt tersedia
if (-Not (Test-Path $ipFilePath)) {
    Write-Host "File '$ipFilePath' Not Found!" -ForegroundColor Red
    exit
}

# Membaca IP dari file
$ips = Get-Content -Path $ipFilePath | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' }

# File output hasil ping
$outputFile = "PingResult.txt"
Clear-Content -Path $outputFile -ErrorAction SilentlyContinue

# Counter global dan per subnet
$upCount = 0
$downCount = 0
$subnetSummary = @{}

foreach ($ip in $ips) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $result = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue

    # Ambil subnet dari 3 blok pertama
    $subnet = ($ip.Split(".")[0..2] -join "." + ".x")

    # Inisialisasi subnet jika belum ada
    if (-not $subnetSummary.ContainsKey($subnet)) {
        $subnetSummary[$subnet] = @{ UP = 0; DOWN = 0 }
    }

    if ($result) {
        $line = "$timestamp - $ip is UP"
        Write-Host $line -ForegroundColor Green
        $upCount++
        $subnetSummary[$subnet].UP++
    } else {
        $line = "$timestamp - $ip is DOWN"
        Write-Host $line -ForegroundColor Red
        $downCount++
        $subnetSummary[$subnet].DOWN++
    }

    Add-Content -Path $outputFile -Value $line
}

# Ringkasan total
$globalSummary = @"
===============================
Total IP: $($ips.Count)
UP   : $upCount
DOWN : $downCount
===============================
"@

Write-Host $globalSummary -ForegroundColor Cyan
Add-Content -Path $outputFile -Value $globalSummary

# Ringkasan per subnet
Write-Host "Ringkasan per subnet:" -ForegroundColor Yellow
Add-Content -Path $outputFile -Value "Ringkasan per subnet:"

foreach ($subnet in $subnetSummary.Keys | Sort-Object) {
    $info = "[Subnet: $subnet]  UP: $($subnetSummary[$subnet].UP)  DOWN: $($subnetSummary[$subnet].DOWN)"
    Write-Host $info -ForegroundColor Gray
    Add-Content -Path $outputFile -Value $info
}

Write-Host "Ping selesai. Press Enter to Exit..." -ForegroundColor Cyan
Read-Host
