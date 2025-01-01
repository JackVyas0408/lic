# Check if the script is running as an administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script as an administrator
    Write-Output "Script is not running as administrator. Relaunching with elevated privileges..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Define the registry paths and values
$baseKey = "HKLM:\SOFTWARE\Policies\Google"
$chromeKey = "$baseKey\Chrome"
$valueName = "AllowFileSelectionDialogs"

# Check if the Chrome key exists
if (-not (Test-Path $chromeKey)) {
    Write-Output "The Chrome policy key does not exist. Creating it..."
    New-Item -Path $chromeKey -Force | Out-Null
}

# Check if the value exists
if (Get-ItemProperty -Path $chromeKey -Name $valueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $chromeKey).$valueName
    Write-Output "The current value of '$valueName' is: $currentValue"

    # Prompt the user to enable or disable the setting
    Write-Output "Choose an option:"
    Write-Output "1. Enable (Set to 1)"
    Write-Output "2. Disable (Set to 0)"
    $choice = Read-Host "Enter your choice (1 or 2)"

    if ($choice -eq "1") {
        Set-ItemProperty -Path $chromeKey -Name $valueName -Value 1 -Force
        Write-Output "The setting has been enabled (set to 1)."
    } elseif ($choice -eq "2") {
        Set-ItemProperty -Path $chromeKey -Name $valueName -Value 0 -Force
        Write-Output "The setting has been disabled (set to 0)."
    } else {
        Write-Output "Invalid choice. No changes were made."
    }
} else {
    # If the value does not exist, create it and set it to disabled by default
    Write-Output "The value '$valueName' does not exist. Creating it with default disabled (0)."
    Set-ItemProperty -Path $chromeKey -Name $valueName -Value 0 -Force
    Write-Output "The value has been created and set to disabled (0)."
}
