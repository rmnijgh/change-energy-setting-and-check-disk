#admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

#give permission
Set-ExecutionPolicy -Scope Process -ExecutionPolicy AllSigned

#log file chkdsk
New-Item c:\sec.txt -type file
$file = "c:\sec.tx"

#high performance
Get-WmiObject -Class Win32_PowerPlan -Namespace root\cimv2\power -Filter "ElementName= 'High Performance'" | Invoke-WmiMethod -Name Activate
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
$exe = "C:\Windows\system32\powercfg.exe"
$arguments = "-x -standby-timeout-ac 0"
$proc = [Diagnostics.Process]::Start($exe, $arguments)
$proc.WaitForExit()

#turn hard drive off never
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

#disable fast boot
powercfg -h off

#chkdsk
$sec = chkdsk /r
$sec | Add-Content -Path $file

#done
echo "Complete!"