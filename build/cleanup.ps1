<#
.SYNOPSIS
Stops and removes a Windows service (if present) and cleans the working tree.

.DESCRIPTION
Stops the specified Windows service and removes it from the system. Afterwards, performs a destructive `git clean -ffdx`
To remove untracked files and directories so the repository is in a clean state.

.PARAMETER ServiceName
Optional name of the Windows service to stop and remove. Default: `Windows DevOps Challenge`.

.EXAMPLE
.
\build\cleanup.ps1 -ServiceName "Windows DevOps Challenge"

.NOTES
`git clean -ffdx` is destructive and will permanently remove untracked files and directories — use with caution.
#>

# Ensure script is executed with PowerShell V7 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

param(
    [Parameter(Mandatory = $false, HelpMessage = "Name of the service")]
    [string]$ServiceName = "Windows DevOps Challenge"
)

# Ensure script stops in case of errors
$ErrorActionPreference = "Stop"


# 1. Stop Service - attempt to get the service; silence error if service not present
$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service) {
    Write-Host -ForegroundColor Blue "Stopping & removing $($ServiceName)"
    if ($service.Status -eq 'Running') {

        # Force stop if still running
        Stop-Service -Name $ServiceName -Force
        Write-Host -ForegroundColor Green "Service stopped"    
    }

    # Remove the service registration from the system
    Remove-Service -Name $ServiceName
    Write-Host -ForegroundColor Green "Service removed"
}
else {

    Write-Host -ForegroundColor Blue "No existing service found"
}

# 2. Clean up workspace
git clean -ffdx
