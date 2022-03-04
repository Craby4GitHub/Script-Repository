# This script automatically runs the SCCM task sequences 500 times every 20 Minutes.
# It was originally written by Kent DuBack II on 12/5/2019 for Pima Community College.

# With many additions by Craby4Github on occasion

# Relaunch as an elevated process:
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Start-Process powershell.exe "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

#READY SET GO!

#Here is the title and all data afterword tells us if it's functioning.
Write-Host "==== Starting GPUpdate ====" -ForegroundColor Red -BackgroundColor White

#Before we get serious, lets run a GPUpdate:
gpupdate /force

#Alright lets list the cycles in an array and write out to the terminal that we are starting the cycles
Write-Host "==== Starting Configuration Manager Cycles ====" -ForegroundColor Red -BackgroundColor White
$ConfigManCycles = @(
    ('{00000000-0000-0000-0000-000000000121}', 'Application Deployment Evaluation Cycle'),
    ('{00000000-0000-0000-0000-000000000003}', 'Discovery Data Collection Cycle'),
    ('{00000000-0000-0000-0000-000000000010}', 'File Collection Cycle'),
    ('{00000000-0000-0000-0000-000000000001}', 'Hardware Inventory Cycle'),
    ('{00000000-0000-0000-0000-000000000021}', 'Machine Policy Retrieval Cycle'),
    ('{00000000-0000-0000-0000-000000000022}', 'Machine Policy Evaluation Cycle'),
    ('{00000000-0000-0000-0000-000000000002}', 'Software Inventory Cycle'),
    ('{00000000-0000-0000-0000-000000000031}', 'Software Metering Usage Report Cycle'),
    ('{00000000-0000-0000-0000-000000000114}', 'Software Updates Deployment Evaluation Cycle'),
    ('{00000000-0000-0000-0000-000000000113}', 'Software Update Scan Cycle'),
    ('{00000000-0000-0000-0000-000000000032}', 'Windows Installers Source List Update Cycle')
)

# here we have a for loop that runs on an incrementing timer, it then runs through the cycles in the array piece by piece and outputs all the output to null, with the exception of the names. It shows what cycle we are on, and clears the screen repeatedly after each, to show motion on the screen and make it easier to see what it is doing. IT likewise checks for a pending reboot and will reboot as it needs to to help with the update process, though it only does this if the CPU usage of the computer is under 10%.
for ($timer = 1; $timer -le 500; $timer++) {

  # Check for pending reboot
  # https://www.dbtales.com/using-powershell-check-for-pending-reboot-and-last-restart-on-remote-computer/

  $pendingReboot = $false
  if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { $pendingReboot = $true }
  if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { $pendingReboot = $true }
  if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { $pendingReboot = $true }
  try {
    $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
    $status = $util.DetermineIfRebootPending()
    if (($null -ne $status) -and $status.RebootPending) {
      $pendingReboot = $true
    }
  }
  catch {}

  # If a reboot is pending and CPU Useage is under 10%, reboot computer
  if ($pendingReboot) {
    $cpuUseage = Get-CimInstance win32_processor | Measure-Object -Property LoadPercentage -Average
    if ($cpuUseage.Average -le 10) {
      Restart-Computer -Force
      Exit
    }
  }

  ForEach ($Cycle in $ConfigManCycles) {
    write-host "Working on" $Cycle[1]
    Invoke-WMIMethod -ComputerName $env:COMPUTERNAME -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule $Cycle[0] | Out-Null
  }

  Write-Host "`nWe are on Cycle: $timer"
  Write-Host "Ctrl+C to return to Powershell, or just close the window." -ForegroundColor Cyan -BackgroundColor Darkcyan

  # Thank you DrakharD
  # https://gist.github.com/ctigeek/bd637eeaeeb71c5b17f4
  $seconds = 1200
  $doneDT = (Get-Date).AddSeconds($seconds)
  while ($doneDT -gt (Get-Date)) {
    $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
    $percent = ($seconds - $secondsLeft) / $seconds * 100
    Write-Progress -Activity "Waiting for..." -Status "Sleeping" -SecondsRemaining $secondsLeft -PercentComplete $percent
    Start-Sleep -Seconds 1
  }
  Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
  Clear-Host
}
