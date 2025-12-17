# Ensure script is executed with PowerShell V8 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

param(
	#Mandatory parameter to define configuration to build, either Debug or Release
	[Parameter(Mandatory = $true, HelpMessage = "Select Debug or Release to build dotnet project")]
	[ValidateSet("Debug", "Release", IgnoreCase = $true)]
	[string]$Configuration,

	#Mandatory parameter to define which project to build
	[Parameter(Mandatory = $true, HelpMessage = "Provide .csproj you want to build")]
	[ValidateNotNullOrEmpty()]
	[string]$ProjectName,


	#Option to define where to store build output, defaults to dist
	[Parameter(Mandatory = $false, HelpMessage = "Name of the directory to store build output. Folder will be created in root directory of the git repository")]
	[ValidateNotNullOrEmpty()]
	[string]$OutputDirectory = "dist",

	#Option to enable verbosity output
	[Parameter(Mandatory = $false, HelpMessage = "Verbose output from dotnet")]
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

# Start by clean project, to ensure consistent builds and clean starting point
# Clean project with the provided verbosity and configuration
Write-Host -ForegroundColor Blue "### Cleaning dotnet $($projectName) ###"
dotnet clean $projectDir --configuration $Configuration --verbosity $verbosity --output $outputDir

# Build project with the provided verbosity and configuration
Write-Host -ForegroundColor Blue "### Building dotnet $($projectName) ###"
dotnet build $projectDir --configuration $Configuration --verbosity $verbosity --output $outputDir

Write-Host -ForegroundColor Green "### Done building project ###"
