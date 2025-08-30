# PC Troubleshooting Script
# Author: Muhammed Fajar

Write-Host "Starting PC Troubleshooting..." -ForegroundColor Cyan

# System Uptime
$uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
Write-Host "System Uptime: $((Get-Date) - $uptime)" -ForegroundColor Green

# CPU Usage
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time'
Write-Host "CPU Usage: $($cpuUsage.CounterSamples[0].CookedValue)%"

# Memory Usage
$memory = Get-CimInstance Win32_OperatingSystem
$totalMem = [math]::round($memory.TotalVisibleMemorySize / 1MB, 2)
$freeMem = [math]::round($memory.FreePhysicalMemory / 1MB, 2)
Write-Host "Total Memory: $totalMem MB"
Write-Host "Free Memory: $freeMem MB"

# Disk Space
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
    $freeSpace = [math]::round($disk.FreeSpace / 1GB, 2)
    $totalSpace = [math]::round($disk.Size / 1GB, 2)
    Write-Host "$($disk.DeviceID): $freeSpace GB free of $totalSpace GB"
}

# Internet Connectivity
$ping = Test-Connection -ComputerName google.com -Count 2 -Quiet
if ($ping) {
    Write-Host "Internet Connection: OK" -ForegroundColor Green
} else {
    Write-Host "Internet Connection: FAILED" -ForegroundColor Red
}

# Recent System Errors
Write-Host "`nRecent System Errors (Last 24 Hours):"
Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddDays(-1)} -MaxEvents 5 |
    Format-Table TimeCreated, Message -AutoSize

Write-Host "`nTroubleshooting Complete." -ForegroundColor Cyan
