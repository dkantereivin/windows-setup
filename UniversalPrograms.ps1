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
    $UserInput = Read-Host -Prompt "Enter Y/N: ";
    return $UserInput -eq "Y";
}

if (-NOT (IsProcessElevated)) {
    Write-Host "This script requires administrator permissions. It will now terminate." -ForegroundColor Red;
    Break;
}

Write-Host (
    "---- UNIVERSAL PROGRAMS ----",
    "This script installs programs for all installations via Winget and Chocolatey. Requires Winget (preferred) and Chocolatey from BasicSetup."
    ) -Separator "`r`n";

if (-NOT (PromptActionConfirmation -PromptMsg "CONFIRM: Once you accept, this utility will install many 'universal' programs to your system." -Color Red)) {
    Break;
}

$Desktop = PromptActionConfirmation -PromptMsg "Is this a desktop PC?";

winget install Microsoft.Edge;
winget install Videolan.Vlc;
winget install Canonical.Ubuntu;
winget install Python.Python;
winget install Microsoft.VisualStudioCode;
winget install Spotify.Spotify;
winget install Discord.Discord;
winget install Microsoft.Teams;
winget install Zoom.Zoom;
winget install GIMP.GIMP;
winget install Zotero.Zotero;
winget install Audacity.Audacity;
winget install WhatsApp.WhatsApp;
winget install Malwarebytes.Malwarebytes;
if ($Desktop) {
    winget install Lexikos.AutoHotKey;
    winget install calibre.calibre;
}
