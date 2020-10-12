function IsProcessElevated {
    return (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")
    );
}

function PromptActionConfirmation {
    param ([string]$PromptMsg, [ConsoleColor]$Color);
    if ($Color -eq $null) {
        $Color = "Green";
    }
    Write-Host $PromptMsg -ForegroundColor $Color;
    $UserInput = Read-Host -Prompt "Enter Y/N to proceed/skip: ";
    return $UserInput -eq "Y";
}

if (-NOT (IsProcessElevated)) {
    Write-Host "This script requires administrator permissions. It will now terminate." -ForegroundColor Red;
    Break;
}

Write-Host (
    "---- BASIC SETUP ----",
    "This script is a univeral script that should be executed when the machine is first initialized."
    ) -Separator "`r`n";

if (-NOT (PromptActionConfirmation -PromptMsg "This script requires administrator permissions and makes system changes." -Color Red)) {
    Break;
}

if (PromptActionConfirmation -PromptMsg "Install Powershell 7") {
    iex "& { $(irm https://aka.ms/install-powershell.ps1)} -UseMSI -Quiet";
}

if (PromptActionConfirmation -PromptMsg "Update Windows") {
    if (-NOT (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Install-Module PSWindowsUpdate;
    }
    Get-WindowsUpdate;
    Install-WindowsUpdate;
}

if (PromptActionConfirmation -PromptMsg "Enable Optional Features. REQUIRED FOR WSL2 STEPS (includes WSL)") {
    Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName MediaPlayback;
    Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName MicrosoftWindowsPowerShellV2Root;
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName VirtualMachinePlatform;
        Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux;
    if (PromptActionConfirmation -PromptMsg "Proceed with WSL Step 1 and 2 Afterwards.." -Color Red) {
        Restart-Computer
    }
}

if (PromptActionConfirmation -PromptMsg "WSL2") {
    $tmp = "$env:TEMP\wsl_update_x64.msi";
    Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $tmp;
    msiexec /i $tmp /passive /norestart;
    del $tmp;
    wsl --set-default-version 2
}


if (PromptActionConfirmation -PromptMsg "Install Core Programs! REQUIRES WINGET." -Color Red) {
    winget install Microsoft.PowerToys;
    winget install Microsoft.WindowsTerminal;
    winget install Git.Git;
    winget install 7Zip.7Zip;
    winget install Piriform.CCleaner;
    winget install TeamViewer.TeamViewer;
}


if (PromptActionConfirmation -PromptMsg "Install Chocolatey") {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if (PromptActionConfirmation -PromptMsg "Restart is highly reccomended. Can restart?" -Color Red) {
    Restart-Computer
}
