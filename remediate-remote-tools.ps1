<#
.SYNOPSIS
    Remediates unauthorized remote access tools by halting processes and purging file paths.
#>

[CmdletBinding()]
param()

Write-Host "[*] Initiating Containment: Terminating Flagged Processes..." -ForegroundColor Cyan
$targets = "ScreenConnect|AnyDesk|TeamViewer"
$running = Get-Process | Where-Object { $_.ProcessName -match $targets }

if ($running) {
    foreach ($proc in $running) {
        Write-Host "Stopping Process: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Yellow
        Stop-Process -Id $proc.Id -Force
    }
} else {
    Write-Host "[+] No target processes running." -ForegroundColor Green
}

Write-Host "`n[*] Initiating Eradication: Purging File Artifacts..." -ForegroundColor Cyan
$paths = @(
    "$env:ProgramData\ScreenConnect",
    "$env:LOCALAPPDATA\ScreenConnect",
    "$env:TEMP\ScreenConnect*",
    "$env:SystemDrive\Windows\Temp\ScreenConnect*"
)

foreach ($target in $paths) {
    if (Test-Path $target) {
        Write-Host "Deleting: $target" -ForegroundColor Yellow
        Remove-Item -Path $target -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`n[*] Disabling Related Services..." -ForegroundColor Cyan
$services = Get-Service | Where-Object { $_.Name -match "ScreenConnect" }
if ($services) {
    foreach ($svc in $services) {
        Write-Host "Stopping and disabling service: $($svc.Name)" -ForegroundColor Yellow
        Stop-Service -Name $svc.Name -Force
        Set-Service -Name $svc.Name -StartupType Disabled
    }
} else {
    Write-Host "[+] No matching services found." -ForegroundColor Green
}

Write-Host "`n[+] Remediation sequence completed." -ForegroundColor Green
