<#
.SYNOPSIS
    Server Health Check Script
.DESCRIPTION
    This script checks CPU, memory, disk, services, and network health.
    Logs results to a file and optionally sends email alerts.
#>

param (
    [string]$LogFile = "C:\Logs\ServerHealthCheck.log",
    [string]$EmailRecipient = "admin@example.com",
    [switch]$SendEmail
)

# Ensure Log Directory Exists
$LogDir = Split-Path $LogFile
if (!(Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
}

# Function to Log Messages
function Write-Log {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

Write-Log "Starting Server Health Check"

# Check CPU Usage
function Get-CPUUsage {
    $CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average
    $Usage = $CPU.Average
    Write-Log "CPU Usage: $Usage%"
    if ($Usage -gt 90) {
        Write-Log "WARNING: High CPU Usage detected ($Usage%)"
    }
}

# Check Memory Usage
function Get-MemoryUsage {
    $OS = Get-WmiObject Win32_OperatingSystem
    $TotalMemory = [math]::round($OS.TotalVisibleMemorySize / 1MB, 2)
    $FreeMemory = [math]::round($OS.FreePhysicalMemory / 1MB, 2)
    $UsedMemory = $TotalMemory - $FreeMemory
    $UsagePercent = [math]::round(($UsedMemory / $TotalMemory) * 100, 2)

    Write-Log "Memory Usage: $UsagePercent% ($UsedMemory GB used of $TotalMemory GB)"
    if ($UsagePercent -gt 85) {
        Write-Log "WARNING: High Memory Usage detected ($UsagePercent%)"
    }
}

# Check Disk Usage
function Get-DiskUsage {
    $Disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($Disk in $Disks) {
        $FreeSpace = [math]::round($Disk.FreeSpace / 1GB, 2)
        $TotalSpace = [math]::round($Disk.Size / 1GB, 2)
        $UsedSpace = $TotalSpace - $FreeSpace
        $UsagePercent = [math]::round(($UsedSpace / $TotalSpace) * 100, 2)
        
        Write-Log "Disk Usage on $($Disk.DeviceID): $UsagePercent% ($UsedSpace GB used of $TotalSpace GB)"
        if ($UsagePercent -gt 90) {
            Write-Log "WARNING: Low disk space on $($Disk.DeviceID) ($FreeSpace GB left)"
        }
    }
}

# Check Network Connectivity
function Get-NetworkStatus {
    $Hosts = @("8.8.8.8", "1.1.1.1", "google.com")
    foreach ($Host in $Hosts) {
        $Ping = Test-Connection -ComputerName $Host -Count 2 -Quiet
        if ($Ping) {
            Write-Log "Network OK: Able to reach $Host"
        } else {
            Write-Log "WARNING: Unable to reach $Host"
        }
    }
}

# Check Running Services
function Get-ImportantServices {
    $Services = @("Spooler", "wuauserv", "WinDefend", "MSSQLSERVER")
    foreach ($Service in $Services) {
        $Status = Get-Service -Name $Service -ErrorAction SilentlyContinue
        if ($Status.Status -ne "Running") {
            Write-Log "ALERT: Service $Service is not running!"
        } else {
            Write-Log "Service Check: $Service is running."
        }
    }
}

# Email Alert Function
function Send-EmailAlert {
    param([string]$Subject, [string]$Body)
    if (-not $SendEmail) { return }
    
    $SMTP = "smtp.example.com"
    $From = "server-monitor@example.com"

    try {
        Send-MailMessage -To $EmailRecipient -From $From -Subject $Subject -Body $Body -SmtpServer $SMTP
        Write-Log "Email sent to $EmailRecipient: $Subject"
    } catch {
        Write-Log "ERROR: Failed to send email - $_"
    }
}

# Run Checks
Get-CPUUsage
Get-MemoryUsage
Get-DiskUsage
Get-NetworkStatus
Get-ImportantServices

Write-Log "Server Health Check Completed"

# Send Email Report if Enabled
if ($SendEmail) {
    $ReportBody = Get-Content -Path $LogFile -Raw
    Send-EmailAlert -Subject "Server Health Report" -Body $ReportBody
}

# Deliberate Linting Issues for Testing
$testVar = "Unused Variable"  # This is an unused variable (will be flagged)
$bad_spacing  =  "Too much spacing here"  # Inconsistent spacing
$incorrect_case = "Variable should use PascalCase or camelCase"  
if($bad_spacing -eq "Too much spacing here") {Write-Log "Spacing test"}

# EOF
