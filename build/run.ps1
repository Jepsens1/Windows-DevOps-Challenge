<#
.SYNOPSIS
Installs and starts the Windows service using the provided executable or DLL.

.DESCRIPTION
Validates the presence of the specified service binary in `$OutputDirectory`
Removes any existing service with the same name, creates a new Windows service pointing to the binary and starts it.
The service's binary path includes a `--log-dir` argument to point logs to the repository `logs` folder.

.PARAMETER ServiceFile
Name of the executable or DLL to run as a service (e.g., `App.Api.exe`).

.PARAMETER OutputDirectory
Directory where the service binary resides (default `dist`).

.PARAMETER ServiceName
Name used when creating the Windows service. Default: `Windows DevOps Challenge`.

.EXAMPLE
.
\build\run.ps1 -ServiceFile App.Api.exe -OutputDirectory dist -ServiceName "Windows DevOps Challenge"

.NOTES
Requires administrative privileges to create and start Windows services.
#>

# Ensure script is executed with PowerShell V7 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

param(
	#Mandatory parameter to define executable or dll name
	[Parameter(Mandatory = $true, HelpMessage = "Name of the executable or dll")]
	[ValidateNotNullOrWhiteSpace()]
	[string]$ServiceFile,

	#Mandatory parameter to define where to look Windows Service file
	[Parameter(Mandatory = $false, HelpMessage = "Directory PATH to .exe or .dll service. Default (dist)")]
	[ValidateNotNullOrWhiteSpace()]
	[string]$OutputDirectory = "dist",

	[Parameter(Mandatory = $false, HelpMessage = "Name of the service")]
    [string]$ServiceName = "Windows DevOps Challenge"
)

# Ensure script stops in case of errors
$ErrorActionPreference = "Stop"

# Define Path variables
$rootDir = Split-Path -Path $PSScriptRoot -Parent
$outputDir = Join-Path $rootDir $OutputDirectory
$logsDir = Join-Path $rootDir "logs"
$serviceFileLocation = Join-Path $outputDir $ServiceFile

Write-Host -ForegroundColor Blue "### Validate $($serviceFileLocation) exist ###"
if (-not (Test-Path $serviceFileLocation))
{
	throw "The provided $($serviceFileLocation) does not exist`n Check that $($serviceFileLocation) is spelled correct"
}

# Check & Remove old service
Write-Host -ForegroundColor Blue "Checking if service $($ServiceName) already exists..."

$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($existingService)
{
Write-Host -ForegroundColor Yellow "Service $($ServiceName) already exists - stopping & removing it now..."
if ($existingService.Status -eq 'Running') {

Stop-Service -Name $ServiceName -Force
Write-Host -ForegroundColor Green "Service stopped"	
}

Remove-Service -Name $ServiceName
Write-Host -ForegroundColor Green "Old service removed"
} else {

	Write-Host -ForegroundColor Blue "No existing service found"
}

# Create & start new service
Write-Host -ForegroundColor Blue "Creating new service..."
New-Service -Name $ServiceName -BinaryPathName "$($serviceFileLocation) --log-dir $($logsDir)"

Write-Host -ForegroundColor Blue "Starting service..."
Start-Service -Name $ServiceName

Write-Host -ForegroundColor Green "### $($ServiceName) service is running ###"