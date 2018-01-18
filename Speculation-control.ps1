
<#
.SYNOPSIS
    Version 1.0
    
  Script will indicates if your instance/computer is protected against speculative execution side-channel vulnerabilities.

  Script requires the "SpeculationControl.zip" file on the same folder where you'll be executing the script - download it here: 

  https://gallery.technet.microsoft.com/scriptcenter/Speculation-Control-e36f0050/file/185444/1/SpeculationControl.zip

  The Script will unzip the SpeculationControl.zip file and run it against it's module - this zip file contains a PowerShell module 
  that can be used to confirm whether a system has enabled the protections needed to validate that the speculation control vulnerability. 
  This is described in the blog topic: "Windows Server guidance to protect against the speculative execution side-channel vulnerabilities."

#>

Param(
  [parameter(mandatory=$false)]
  [System.Boolean]
  $loggingEnabled = $true,
  
  [parameter(mandatory=$false)]
  [System.String]
  $logPath
)

#region Variables

$output = "$PSScriptRoot\SpeculationControl.zip" 
$start_time = Get-Date
$file="SpeculationControl.zip"
$destination="SpeculationControl"

#endregion

$shell = New-Object -ComObject Shell.Application
$zip_file = $shell.NameSpace($output)
foreach($item in $zip_file.Items()) {
    $shell.Namespace($PSScriptRoot).CopyHere($item)
}

#Process that determines if the instance/computer is protected against speculative control.

$SaveExecutionPolicy = Get-ExecutionPolicy 
#  
Set-ExecutionPolicy RemoteSigned -Scope Currentuser # this won't be necessary if executed from Run Command (AWS)
 
Import-Module .\SpeculationControl\SpeculationControl.psd1

Get-SpeculationControlSettings 
 
Set-ExecutionPolicy $SaveExecutionPolicy -Scope Currentuser

#end of Process
