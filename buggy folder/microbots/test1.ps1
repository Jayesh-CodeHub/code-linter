# Bad Practice: Hardcoded Credentials
$Server = "192.168.1.50"
$Username = "admin"
$Password = "P@ssword123"  # Security Risk (Hardcoded)

# Logging Setup (Incorrect Usage)
$logFile = "C:\temp\script_log.txt"
if (!(Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile -Force | Out-Null
}

# Function to Log Messages (Poorly Implemented)
Function Write-Log {
    param ($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
}

# Function to Fetch Data from an API (Bad Error Handling)
Function Fetch-Data {
    $url = "http://example.com/api/data"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing  # No timeout set
    return $response.Content
}

# Function to Execute Remote SSH Command (Multiple Issues)
Function Execute-SSHCommand {
    param ($Command)
    
    $session = New-Object -TypeName "SSH.SshClient" -ArgumentList $Server, $Username, $Password
    $session.Connect()  # No Error Handling
    
    $result = $session.RunCommand($Command)  # No Validation
    Write-Host "Command Output: $result"
    
    $session.Disconnect()  # Not in Try-Catch
}

# Function to Write Data to a File (Overwrites without Warning)
Function Write-ToFile {
    param ($Content, $FilePath)
    $Content | Out-File -FilePath $FilePath  # Overwrites without checking
}

# Function with Unnecessary Complexity (Radon Complexity Equivalent)
Function Process-Data {
    $data = Fetch-Data
    if ($data) {
        foreach ($item in $data) {
            foreach ($key in $item.PSObject.Properties.Name) {
                Write-Host "Processing $key -> $($item.$key)"  # Redundant Output
                Start-Sleep -Seconds 1  # Unnecessary Delay
            }
        }
    } else {
        Write-Host "No data received!"  # Poor Logging
    }
}

# Function with Poorly Managed Jobs (Concurrency Issues)
Function Start-BackgroundJobs {
    for ($i=0; $i -lt 5; $i++) {
        Start-Job -ScriptBlock { Start-Sleep -Seconds 10; Write-Host "Job $i Done" }
    }
    
    # No Proper Job Cleanup
}

# Main Execution Flow (Bad Practice: No Function Calls Inside Try-Catch)
Write-Log "Starting Script Execution"

Execute-SSHCommand "ls -l /var/log"

Write-Host "Fetching Data from API..."
$data = Fetch-Data
Write-Host "Received Data: $data"

Write-ToFile -Content $data -FilePath "C:\temp\data.txt"

Start-BackgroundJobs  # Unmanaged Jobs

Write-Log "Script Execution Completed"
