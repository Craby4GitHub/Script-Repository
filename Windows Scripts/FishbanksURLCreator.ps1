# This is a script that creates a function to create URL shortcuts and places them on the public desktop, designed in this case for the MIT Fishbanks Simulation.
# It was originally written by Kent DuBack II on 1.24.22 for Pima Community College.


######################################################################
# Pre-Run - Lets run this as Administrator:
######################################################################
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

######################################################################
# First lets set some variables:
######################################################################
$Chromeroot = 'C:\Program Files\Google\Chrome'
$Destination = "C:\Users\Public\Desktop\"
$Installedstatus = Test-Path -Path 'C:\Users\Public\Desktop\MIT Fishbanks Software.lnk' -PathType leaf
$URLTitle = "MIT Fishbanks Software"
$URL = "https://forio.com/simulate/mit/fishbanks/simulation/login.html"

######################################################################
# Now lets create a function to create URL's:
######################################################################
function Create-Shortcut
{
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut("$Destination\$URLTitle.lnk")
$ShortCut.TargetPath="$Chromeroot\Application\chrome.exe"
$ShortCut.Arguments="--app $URL"
$ShortCut.WorkingDirectory = "$Chromeroot\Application";
$ShortCut.WindowStyle = 1;
$ShortCut.IconLocation = "$Chromeroot\Application\chrome.exe, 0";
$ShortCut.Description = "";
$ShortCut.Save()
}

######################################################################
# Now the Actual Script:
######################################################################
if ($Installedstatus -eq 'True') {
  Write-Host "Fishbanks is installed, Removing..."
  Remove-Item "$Destination$URLTitle.lnk"
  Write-Host "Fishbanks has been Removed."
  start-sleep 3
  exit
}
else {
  write-host 'Creating and placing Shortcut for MIT Fishbanks Software:'
  Create-Shortcut
}
