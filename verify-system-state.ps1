<#
.SYNOPSIS
    Post-incident verification to confirm clean endpoint baseline.
#>

Write-Host "[*] Executing Post-Remediation Verification..." -ForegroundColor Cyan

$procCheck = Get-Process | Where-Object { $_.ProcessName -match "ScreenConnect|AnyDesk|TeamViewer" }
$serviceCheck = Get-Service | Where-Object { $_.Name -match "ScreenConnect" -and $_.Status -eq "Running" }

$clean = $true

if ($procCheck) {
    Write-Error "[!] Verification Failed: Unauthorized processes still active."
    $clean = $false
}

if ($serviceCheck) {
    Write-Error "[!] Verification Failed: Unauthorized services still running."
    $clean = $false
}

if ($clean) {
    Write-Host "[+] PASS: Zero unauthorized processes or active services detected." -ForegroundColor Green
    Write-Host "[+] System state meets expected security baseline." -ForegroundColor Green
}
