# Ensure the script is run as an administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Please run this script as Administrator."
    exit
}

Write-Host "**********Harden Your Operating System***********" -ForegroundColor Green
Write-Host "Please wait..." -ForegroundColor Yellow

# Function to apply deny permissions to a file or folder
function Deny-Permissions {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        icacls $Path /deny "Everyone:F" | Out-Null
        Write-Host "$Path - Secured" -ForegroundColor Green
    } else {
        Write-Host "$Path - Not Found" -ForegroundColor Red
    }
}

# Start hardening specific files
Deny-Permissions "C:\Windows\wininit.exe"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Local\svchost.exe"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Local\MicrosoftExplorer\msexpert.exe"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Local\Cyber\CUZ.exe"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Local\Cyber\ZIPDLL.dll"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Roaming\Ground.exe"
Deny-Permissions "C:\Users\$env:USERNAME\AppData\Roaming\spoolsv.exe"
Deny-Permissions "C:\Windows\Resources\spoolsv.exe"
Deny-Permissions "C:\Windows\Resources\svchost.exe"
Deny-Permissions "C:\Windows\Resources\Themes\explorer.exe"
Deny-Permissions "C:\Windows\Resources\Themes\icsys.icn.exe"
Deny-Permissions "C:\ProgramData\AvastSvcpCP\AvastSvc.exe"
Deny-Permissions "C:\ProgramData\AvastSvcpCP\wsc.dll"
Deny-Permissions "C:\ProgramData\AvastSvcpCP"
Deny-Permissions "C:\ProgramData\AcroRd32.exe"
Deny-Permissions "C:\ProgramData\AdobeHelp.exe"
Deny-Permissions "C:\ProgramData\adobeupdate.dat"
Deny-Permissions "C:\ProgramData\hex.dll"
Deny-Permissions "C:\ProgramData\AcroRd32cWP"
Deny-Permissions "C:\ProgramData\Vivaldi"
Deny-Permissions "C:\ProgramData\SymantecSEndponit"

Write-Host "File Hardening Completed" -ForegroundColor Green

# Function to add or modify registry values
function Set-RegistryValue {
    param (
        [string]$KeyPath,
        [string]$Name,
        [string]$Value
    )
    try {
        if (-not (Test-Path "HKLM:\$KeyPath")) {
            New-Item -Path "HKLM:\$KeyPath" -Force | Out-Null
        }
        New-ItemProperty -Path "HKLM:\$KeyPath" -Name $Name -Value $Value -PropertyType String -Force | Out-Null
        Write-Host "Registry Key '$KeyPath' with Value '$Name=$Value' - Secured" -ForegroundColor Green
    } catch {
        Write-Host "Failed to set registry key '$KeyPath': $_" -ForegroundColor Red
    }
}

# Registry Hardening Entries
Set-RegistryValue -KeyPath "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Telegram.exe" -Name "Debugger" -Value "11111"
Set-RegistryValue -KeyPath "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\AvastSvc.exe" -Name "Debugger" -Value "11111"

Write-Host "Registry Hardening Completed" -ForegroundColor Green
Write-Host "Hardening Process Completed Successfully" -ForegroundColor Green
