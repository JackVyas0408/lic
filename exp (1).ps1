# Set script execution policy to require administrative privileges
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

Write-Host "Hardening Completed" -ForegroundColor Green
