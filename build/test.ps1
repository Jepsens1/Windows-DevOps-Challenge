# Ensure script is executed with PowerShell V8 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

param(
	#Mandatory parameter to define configuration to unit test, either Debug or Release
	[Parameter(Mandatory = $true, HelpMessage = "Select Debug or Release to perform unit test")]
	[ValidateSet("Debug", "Release", IgnoreCase = $true)]
	[string]$Configuration,

	#Mandatory parameter to define which project to test 
	[Parameter(Mandatory = $true, HelpMessage = "Provide .csproj you want to unit test")]
	[ValidateNotNullOrEmpty()]
	[string]$ProjectName,


	#Option to define where to store test output, defaults to testresult
	[Parameter(Mandatory = $false, HelpMessage = "Name of the directory to store test output. Folder will be created in root directory of the git repository")]
	[ValidateNotNullOrEmpty()]
	[string]$OutputDirectory = "logs",

	#Option to enable verbosity output
	[Parameter(Mandatory = $false, HelpMessage = "Verbose output from dotnet test")]
	[switch]$VerboseOutput
)

# Ensure script stops in case of errors from dotnet cli
$ErrorActionPreference = "Stop"

# Define Path variables
$rootDir = Split-Path -Path $PSScriptRoot -Parent
$projectDir = Join-Path -Path $rootDir "app/src/$($ProjectName)"
$outputDir = Join-Path $rootDir $OutputDirectory

# Sets verbosity level
$verbosity = $VerboseOutput ? "detailed" : "normal"

Write-Host -ForegroundColor Blue "### Validate $($projectDir) exist ###"
if (-not (Test-Path $projectDir))
{
	throw "The provided $($ProjectName) does not exist`n Check that $($ProjectName) is spelled correct"
}


# Test project with the provided verbosity and configuration
Write-Host -ForegroundColor Blue "### Perform unit test on $($projectName) ###"
dotnet test $projectDir --logger "trx;LogFileName=unitResults.trx" --results-directory $outputDir --configuration $Configuration --verbosity $verbosity

Write-Host -ForegroundColor Green "### Done unit test###"
