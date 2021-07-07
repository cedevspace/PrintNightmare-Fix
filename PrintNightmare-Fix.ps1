<#
[SCRIPT] 
    PrintNightmare-Fix
[VERSION]
    1.07.06.21
[AUTHOR]
    Corey Eacret 
[DESCRIPTION]
    This simple PowerShell script will check if the Print 
    Spooler is running, stop the Print Spooler, then disable 
    the service. This should stop you from being vulnerable 
    to the current issue with the Windows Print Spooler. 
    NOTE: You will not be able to print after applying this 
    fix. Run the script again but use the 'Temp Run' mode 
    to temporarily enable printing. 
#>

# Require script to be run as Administrator
#Requires -RunAsAdministrator

# Function to import and display a block of text at the start
function Import-BlockText {
    param (
        [string]$TBInput,
        [string]$TBColor = "Cyan"
    )
    $TextBlock = [string[]](Get-Content $TBInput)
    foreach ($TH in $TextBlock) { 
        Write-Host -ForegroundColor $TBColor $TH 
    }
}

# Function to enable or disable print spooler service
function SetPrintSpooler {
    param (
        [string]$ModeSelect
    )
    switch -regex ($ModeSelect) {
        'Enable' { 
            Set-Service -Name Spooler -StartupType Automatic
            Start-Service -Name Spooler
            Start-Sleep -Seconds 2
        }
        'Disable' {
            Stop-Service -Name Spooler -Force
            Write-Host -ForegroundColor Magenta "`nPrint Spooler Stopped!"
            Start-Sleep -Seconds 2
            Write-Host -ForegroundColor Yellow "`nDisabling Print Spooler From Starting...`n"
            Set-Service -Name Spooler -StartupType Disabled
            Start-Sleep -Seconds 2
        }
        Default {}
    }
}

# Grab the location of the script, and set a variable for text block
$ScriptLoc = $PSScriptRoot
$TextBlock = $ScriptLoc + "\TextBlocks.txt"

# Show initial block of text
Import-BlockText $TextBlock

# Get current status of the Print Spooler
$SpoolerStatus = Get-Service -Name Spooler

# Check which mode the user wants to run the script in
Write-Host -ForegroundColor Green -NoNewline "`nType the number (1 or 2 or 3) of the mode you want to run, then press enter: "
$ScriptMode = Read-Host

# Check for mode, then peform the selected mode of operation
switch -regex ($ScriptMode) {
    '1' {
        Write-Host -ForegroundColor Yellow "Checking If Print Spooler Is Running; Stopping If Running..."
        Start-Sleep -Seconds 2
        if ($SpoolerStatus.Status -match 'Running') {
            Write-Host -ForegroundColor Yellow "Print Spooler Is Running, turning off..."
            SetPrintSpooler "Disable"
        }
        else {
            Write-Host -ForegroundColor Cyan "Print Spooler Not Active"
            Start-Sleep -Seconds 2
        }
        Write-Host -ForegroundColor Green -NoNewline "You Should Now Be Safe!`nPress Enter To Exit..."
        Read-Host 
        exit
    }
    '2' {
        Write-Host -ForegroundColor Green "Mode 2: Temp Enable`nOnce you have finished printing, come back to this window and press enter: "
        Write-Host -ForegroundColor Yellow "Checking If Print Spooler Is Disabled..."
        Start-Sleep -Seconds 2

        if ($SpoolerStatus.StartType -match 'Disabled') {
            Write-Host -ForegroundColor Yellow "`nPrint Spooler Is disabled, turning back on!"
            SetPrintSpooler "Enable"
            
        }
        elseif ($SpoolerStatus.StartType -match 'Automatic|AutomaticDelayedStart|Manual' -and $SpoolerStatus.Status -match 'Stopped') {
            Write-Host -ForegroundColor Yellow "Print Spooler Is Enabled, But Stopped, Starting Service..."
            SetPrintSpooler "Enable"
        }
        else { Write-Host -ForegroundColor Yellow "Print Spooler Is Enabled And Running, What Do You Want From Me Then Dangit????"; exit }
        
        Write-Host -ForegroundColor Red -NoNewline "WARNING! PRINT SPOOLER IS ON! KEEP THIS WINDOW OPEN UNTIL FINISHED PRINTING!`n Press Enter When Done: "
        Read-Host 
        Write-Host -ForegroundColor Yellow "Getting you safe again, turning Print Spooler off..."
        SetPrintSpooler "Disable"
        Write-Host -ForegroundColor Green -NoNewline "You Should Now Be Safe!`nPress Enter To Exit..."
        Read-Host 
        exit
    }
    '3' { 
        Write-Host -ForegroundColor Red "`nWARNING: Only use this mode if a patch has been put out by Microsoft, and it is safe to restore the Print Spooler!"
        Write-Host -ForegroundColor Yellow -NoNewline "`nAre you sure you want to turn the Print Spooler back on? Type Yes or No then press Enter: "
        $EnablePrompt = Read-Host
        switch -regex ($EnablePrompt) {
            'Yes' { 
                if ($SpoolerStatus.StartType -match 'Disabled') {
                    Write-Host -ForegroundColor Yellow "Print Spooler Is disabled, turning back on!"
                    SetPrintSpooler "Enable"
                }
                elseif ($SpoolerStatus.StartType -match 'Automatic|AutomaticDelayedStart|Manual' -and $SpoolerStatus.Status -match 'Stopped') {
                    Write-Host -ForegroundColor Yellow "Print Spooler Is Enabled, But Stopped, Starting Service..."
                    SetPrintSpooler "Enable"
                }
                else {
                    Write-Host -ForegroundColor Yellow "Print Spooler Is Enabled And Running, What Do You Want From Me Then Dangit????"
                    exit
                }
            }
            'No' {
                Write-Host -ForegroundColor Cyan "Well ok then, exiting..."
                exit
            }
            Default {
                Write-Host -ForegroundColor Red "INCORRECT ENTRY, EXITING SCRIPT!!"
                exit
            }
        }
        Write-Host -ForegroundColor Green -NoNewline "`nYou Should Now Be Back To Normal!`nPress Enter To Exit..."
        Read-Host 
        exit
    }
    Default { Write-Host -ForegroundColor Red "INCORRECT MODE SELECTION! RUN SCRIPT AGAIN, TYPE 1, 2, or 3 ONLY!"; exit }
}
