<#
.SYNOPSIS
    Audits active processes, network connections, and startup registry items for unauthorized remote access software.
.DESCRIPTION
    Scans for signatures of ScreenConnect, AnyDesk, and TeamViewer.
#>

Write-Host "[*] Auditing Running Processes for Remote Management Tools..." -ForegroundColor Cyan
$flaggedProcesses = Get-Process | Where-Object { $_.ProcessName -match "ScreenConnect|AnyDesk|TeamViewer" }
if ($flaggedProcesses) {
    Write-Warning "[!] Unauthorized process(es) identified:"
    $flaggedProcesses | Format-Table Id, ProcessName, Path -AutoSize
} else {
    Write-Host "[+] No unauthorized remote access processes currently running." -ForegroundColor Green
}

Write-Host "`n[*] Auditing Active Network Sockets..." -ForegroundColor Cyan
$activeConnections = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | Where-Object {
    $_.RemotePort -in @(80, 443, 8040, 8041)
}
if ($activeConnections) {
    Write-Host "[!] Open connections detected on common remote tool ports:" -ForegroundColor Yellow
    $activeConnections | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess | Format-Table -AutoSize
} else {
    Write-Host "[+] No suspicious active outbound sockets identified." -ForegroundColor Green
}

Write-Host "`n[*] Checking Registry Persistence (Run Keys)..." -ForegroundColor Cyan
$regKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
)
foreach ($key in $regKeys) {
    Write-Host "-> $key"
    Get-ItemProperty -Path $key -ErrorAction SilentlyContinue | Format-List
}
