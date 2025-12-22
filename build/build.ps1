<#
.SYNOPSIS
Builds the specified .NET project and publishes the output to a directory.

.DESCRIPTION
Validates that the target project exists, runs `dotnet clean`, `dotnet build`, and `dotnet publish`
with the provided configuration and verbosity. The published output is placed in `$OutputDirectory` (defaults to `dist`).

.PARAMETER Configuration
Build configuration to use: `Debug` or `Release`.

.PARAMETER ProjectName
Name of the project (for example `App.Api/app.csproj`) to build and publish.

.PARAMETER OutputDirectory
Directory to place published artifacts (created under repository root if absent). Default: `dist`.

.PARAMETER VerboseOutput
Switch to enable detailed dotnet CLI verbosity.

.EXAMPLE
.
\build\build.ps1 -Configuration Release -ProjectName App.Api/app.csproj

.NOTES
Requires PowerShell 7+ and require administrative privileges depending on environment.
And dotnet SDK installed
#>

# Ensure script is executed with PowerShell V7 and as Admin mode
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

# Define Path variables (repository root, target project path and output folder)
$rootDir = Split-Path -Path $PSScriptRoot -Parent
$projectDir = Join-Path -Path $rootDir "app/src/$($ProjectName)"
$outputDir = Join-Path $rootDir $OutputDirectory

# Sets verbosity level used by dotnet CLI (normal | detailed)
$verbosity = $VerboseOutput ? "detailed" : "normal"

# Validate the project path exists before invoking dotnet commands
Write-Host -ForegroundColor Blue "### Validate $($projectDir) exist ###"
if (-not (Test-Path $projectDir))
{
	throw "The provided $($ProjectName) does not exist`n Check that $($ProjectName) is spelled correct"
}

# Use dotnet commands to ensure a deterministic publish
# - dotnet clean: remove previous build artifacts
# - dotnet build: compile project with selected configuration
# - dotnet publish: create publishable artifacts in $OutputDirectory


# Start by cleaning the project to ensure consistent builds and a clean starting point
# Clean project with the provided verbosity and configuration
Write-Host -ForegroundColor Blue "### Cleaning dotnet $($projectName) ###"
dotnet clean $projectDir --configuration $Configuration --verbosity $verbosity

# Build project with the provided verbosity and configuration
# Builds the project but does not yet produce the final publish artifact
Write-Host -ForegroundColor Blue "### Building dotnet $($projectName) ###"
dotnet build $projectDir --configuration $Configuration --verbosity $verbosity

# Publish project to output directory.
Write-Host -ForegroundColor Blue "### Publish dotnet $($ProjectName) ###"
dotnet publish $projectDir --output $outputDir --no-build --verbosity $verbosity --configuration $Configuration --no-self-contained

Write-Host -ForegroundColor Green "### Done building project ###"
