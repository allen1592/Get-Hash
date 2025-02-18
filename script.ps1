# Function to get file hash
function Get-FileHash {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('SHA1', 'SHA256', 'MD5', 'SHA512')]
        [string]$HashType = 'SHA256'
    )

    try {
        # Use built-in Get-FileHash cmdlet in PowerShell
        $fileHash = Microsoft.PowerShell.Utility\Get-FileHash -Path $FilePath -Algorithm $HashType

        # Return the hash value
        return $fileHash.Hash
    }
    catch {
        Write-Error "Error calculating file hash: $_"
        return $null
    }
}

function Get-HardwareHash {
    # Use Win32_ComputerSystemProduct WMI class to retrieve hardware information
    $hardwareInfo = @{}
    
    $computerSystemProduct = Get-WmiObject -Class Win32_ComputerSystemProduct
    
    foreach ($item in $computerSystemProduct) {
        $hardwareInfo['UUID'] = $item.UUID
        $hardwareInfo['Name'] = $item.Name
    }
    
    return $hardwareInfo
}

function Export-HashesToCsv {
    param (
        [Parameter(Mandatory=$false)]
        [hashtable]$Hashes,
        
        [Parameter(Mandatory=$false)]
        [string]$Filename = 'C:\Users\Public\Downloads\hashes.csv'
    )

    # Convert hashtable keys and values to arrays
    $Keys = $Hashes.Keys
    $Values = $Hashes.Values

    # Export to CSV
    $Results = [PSCustomObject]@{
        Keys = $Keys
        Values = $Values
    }

    $Results | Export-Csv -Path $Filename -NoTypeInformation
}

function Get-FileHash {
    param (
        [string]$FilePath
    )
    
    try {
        $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create("SHA256")
        $fileStream = [System.IO.File]::OpenRead($FilePath)
        $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
        $fileStream.Close()
        
        return [BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()
    }
    catch {
        Write-Error "Error hashing file: $_"
        return $null
    }
}

# Function to get hardware hash
function Get-HardwareHash {
    try {
        $computerSystem = Get-WmiObject Win32_ComputerSystem
        $computerBIOS = Get-WmiObject Win32_BIOS
        
        return @{
            'UUID' = $computerBIOS.SerialNumber
            'Name' = $computerSystem.Name
        }
    }
    catch {
        Write-Error "Error retrieving hardware hash: $_"
        return $null
    }
}

# Function to export hashes to CSV
function Export-HashesToCSV {
    param (
        [hashtable]$Hashes
    )
    
    try {
        $csvPath = 'C:\Users\Public\Downloads\hashes.csv'
        $Hashes.GetEnumerator() | Select-Object Name, Value | Export-Csv -Path $csvPath -NoTypeInformation
    }
    catch {
        Write-Error "Error exporting hashes to CSV: $_"
    }
}

# Main script execution
try {
    # Create a sample file to hash
    $sampleFilePath = 'C:\Users\Public\Downloads\example.txt'
    
    # Ensure the directory exists
    $directory = Split-Path $sampleFilePath -Parent
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory | Out-Null
    }
    
    # Write sample content
    "This is a sample file for hashing." | Out-File -FilePath $sampleFilePath -Encoding UTF8
    
    # Check if file exists
    if (-not (Test-Path $sampleFilePath)) {
        Write-Error "Error: The file at $sampleFilePath was not found."
        exit
    }
    
    # Get file hash
    $fileHash = Get-FileHash -FilePath $sampleFilePath
    Write-Host "Hash of the file: $fileHash"
    
    # Get hardware hash
    $hardwareHash = Get-HardwareHash
    
    # Create hash collection
    $allHashes = @{
        'File Hash' = $fileHash
        'UUID' = $hardwareHash['UUID']
        'Name' = $hardwareHash['Name']
    }
    
    # Export hashes to CSV
    Export-HashesToCSV -Hashes $allHashes
    Write-Host "Hashes exported to C:\Users\Public\Downloads\hashes.csv"
}
catch {
    Write-Error "An error occurred: $_"
}