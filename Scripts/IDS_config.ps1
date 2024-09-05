# Define the output file with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "C:\Logs\audit_results_$timestamp.txt"

# Create directory if it doesn't exist
$outputDir = [System.IO.Path]::GetDirectoryName($outputFile)
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}

# Function to log results
function Log-Result {
    param (
        [string]$message
    )
    Add-Content -Path $outputFile -Value $message
}

# Log the date and time the script ran
Log-Result "Security audit started on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# 1. Detect Unusual Login Times
$loginThreshold = 6  # Set threshold for early morning logins (6 AM)
$logonEvents = Get-EventLog -LogName Security -InstanceId 4624 -ErrorAction SilentlyContinue | 
    Where-Object { $_.TimeGenerated.Hour -lt $loginThreshold -or $_.TimeGenerated.Hour -gt 20 }

if ($logonEvents.Count -gt 0) {
    Log-Result "Unusual login times detected:"
    foreach ($event in $logonEvents) {
        Log-Result "User: $($event.ReplacementStrings[5]), Time: $($event.TimeGenerated)"
    }
} else {
    Log-Result "No unusual login times detected."
}

# 2. Detect High CPU Usage
$cpuThreshold = 80  # Set CPU usage threshold
$highCpuProcesses = Get-Process | Where-Object { $_.CPU -gt $cpuThreshold }

if ($highCpuProcesses.Count -gt 0) {
    Log-Result "`High CPU usage detected:"
    foreach ($process in $highCpuProcesses) {
        Log-Result "Process: $($process.Name), CPU: $($process.CPU)%"
    }
} else {
    Log-Result "No high CPU usage detected."
}

# 3. Detect Unknown Executables
$knownExecutables = @("cmd.exe", "powershell.exe", "wmic.exe", "mshta.exe")  # Add known safe executables
$runningProcesses = Get-Process | Where-Object { $_.Name -in $knownExecutables }

if ($runningProcesses.Count -gt 0) {
    Log-Result "Unknown executables detected:"
    foreach ($process in $runningProcesses) {
        Log-Result "Executable: $($process.Path)"
    }
} else {
    Log-Result "No unknown executables detected."
}

# 4. Detect Privilege Escalation Attempts
$privilegeEscalationEvents = Get-EventLog -LogName Security -InstanceId 4672 -ErrorAction SilentlyContinue

if ($privilegeEscalationEvents.Count -gt 0) {
    Log-Result "Privilege escalation attempts detected:"
    foreach ($event in $privilegeEscalationEvents) {
        Log-Result "User: $($event.ReplacementStrings[1]), Time: $($event.TimeGenerated)"
    }
} else {
    Log-Result "No privilege escalation attempts detected."
}

# Final output check
if ((Get-Content -Path $outputFile).Trim().Length -eq 0) {
    Log-Result "No issues detected."
} else {
    Log-Result "Security audit completed."
}

# Log the completion time
Log-Result "Security audit completed on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Output the file location to the console
Write-Host "Intrusion Detection audit results have been saved to: $outputFile"
