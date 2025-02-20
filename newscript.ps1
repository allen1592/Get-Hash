# Check if the script is running with administrative privileges
function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Install the Get-WindowsAutoPilotInfo script if it's not already installed
try {
    Install-Script -Name Get-WindowsAutoPilotInfo -Force -Scope CurrentUser  
} catch {
    Write-Host "Failed to install Get-WindowsAutoPilotInfo. Please check your internet connection and try again."
    exit
}

# Set the execution policy to RemoteSigned
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  -Force
} catch {
    Write-Host "Failed to set execution policy. Please run PowerShell as an administrator."
    exit
}

# Define the output file path
$outputFilePath = "C:\Users\Public\Win10Hash.csv"

# Run the Get-WindowsAutoPilotInfo command and output to the specified file
try {
    Get-WindowsAutoPilotInfo -OutputFile $outputFilePath
    Write-Host "Hardware hash has been successfully exported to $outputFilePath"
} catch {
    Write-Host "An error occurred while running Get-WindowsAutoPilotInfo: $_"
}