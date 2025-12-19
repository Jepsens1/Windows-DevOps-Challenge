# Ensure script is executed with PowerShell V8 and as Admin mode
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
	[string]$OutputDirectory = "dist"
)

# Ensure script stops in case of errors
$ErrorActionPreference = "Stop"

# Define Path variables
$rootDir = Split-Path -Path $PSScriptRoot -Parent
$outputDir = Join-Path $rootDir $OutputDirectory
$serviceFileLocation = Join-Path $outputDir $ServiceFile

Write-Host -ForegroundColor Blue "### Validate $($serviceFileLocation) exist ###"
if (-not (Test-Path $serviceFileLocation))
{
	throw "The provided $($serviceFileLocation) does not exist`n Check that $($serviceFileLocation) is spelled correct"
}

# Register Service 
sc.exe create "Windows DevOps Challenge" binpath=$serviceFileLocation

# Start Service
sc.exe start "Windows DevOps Challenge"

Write-Host -ForegroundColor Green "### Windows DevOps Challenge service is running ###"