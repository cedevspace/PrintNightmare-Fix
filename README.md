# PrintNightmare Fix
This simple PowerShell script will check if the Print Spooler is running, stop the Print Spooler, then disable the service. This should stop you from being vulnerable to the current issue with the Windows Print Spooler. NOTE: You will not be able to print after applying this fix. Run the script again but use the 'Temp Run' mode to temporarily enable printing. 
# How To Use
You will need to run this script as an administrator. To start we need to open an elevated PowerShell terminal; you can do this through searching 'PowerShell' from the Windows 10 start menu, then right click on 'Windows PowerShell' and select 'Run as administrator'. Or type 'Win+R' to open the run dialog, type 'PowerShell', press enter. In this PowerShell terminal, type the following command: 
```
Start-Process PowerShell -Verb RunAs
```
This will prompt you to allow access, then open a new elevated PS terminal. 
## Getting To the Script
Open file explorer to the location of the 'PrintNightmare-Fix.ps1' file, click in the address bar at the top, and copy the path to this folder. In our elevated PowerShell terminal, type the following command, but replace 'LOC' with the folder path we copied. 
```
CD "LOC"
```
## Fix PowerShell Blocking Script
Unless you are a server admin, your default settings in Windows 10 probably will stop this script if you downloaded it from GitHub or Discord. To fix this, use the following command in the elevated PowerShell terminal, using the path we copied in the previous step in place of "LOC" below:
```
Get-ChildItem "LOC" -recurse | Unblock-File
```
NOTE: If you get the error message: "File C:\Something\PrintNightmare-Fix.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see get-help about_signing for more details.", then in that Admin PowerShell terminal, enter this command:

Set-ExecutionPolicy RemoteSigned

Once you no longer need to use this script, use the following command to secure PowerShell again:

Set-ExecutionPolicy Restricted
## Run The Script
Once in the correct folder and the PowerShell issue above fixed, type the following command to run the script:
```
.\PrintNightmare-Fix.ps1
```
## Script Options
The script will prompt you on what mode you want to run. Simply type the number associated with the mode you want to use. The modes available are as follows:
- Mode 1: Fix
- Mode 2: Temp Enable
- Mode 3: Restore
### Mode 1: Fix
Mode one is the main mode that will disable the Print Spooler service and stop it from running on system startup. 
### Mode 2: Temp Enable
As stated, this will kill your ability to print for the time being. If you need to print a document, you can use Mode 2 to enable the service, print, then continue in the script to re-apply the fix. 
### Mode 3: 
This mode will restore the changes we made once Microsoft has issued a security update fixing this vulnerability. 
# Questions
If you need help running this script, or have any questions come to my old Discord:
```
https://discord.gg/Nt6EgUSXX2
```
# Disclaimer 
The following is the disclaimer that applies to all scripts, functions, one-liners, etc. This disclaimer supersedes any disclaimer included in any script, function, one-liner, etc.

You running this script/function means you will not blame the author(s) if this breaks your stuff. This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall author(s) be held liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the script or documentation. Neither this script/function, nor any part of it other than those parts that are explicitly copied from others, may be republished without author(s) express written permission. Author(s) retain the right to alter this disclaimer at any time. For the most up to date version of the disclaimer, see https://ucunleashed.com/code-disclaimer.
