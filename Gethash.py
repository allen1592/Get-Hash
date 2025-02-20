import subprocess
import csv
import os

# Function to run PowerShell script and get output
def get_hardware_hash():
    # Path to the PowerShell script
    script_path = r'C:\Path\To\Get-WindowsAutoPilotInfo.ps1'
    
    # Run the PowerShell script
    try:
        result = subprocess.run(['powershell', '-ExecutionPolicy', 'Bypass', '-File', script_path], 
                                capture_output=True, text=True, check=True)
        # The output will be in CSV format
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while running the PowerShell script: {e}")
        return None



# Running the functions
if __name__ == "__main__":
    # Get hardware hash using PowerShell script
    hardware_hash = get_hardware_hash()
    
