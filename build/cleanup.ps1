# Ensure script is executed with PowerShell V8 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

param(
    [Parameter(Mandatory = $false, HelpMessage = "Name of the service")]
    [string]$ServiceName = "Windows DevOps Challenge"
)

# Ensure script stops in case of errors
$ErrorActionPreference = "Stop"


# 1. Stop Service
$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service) {
    Write-Host -ForegroundColor Blue "Stopping & removing $($ServiceName)"
    if ($service.Status -eq 'Running') {

        Stop-Service -Name $ServiceName -Force
        Write-Host -ForegroundColor Green "Service stopped"	
    }

    Remove-Service -Name $ServiceName
    Write-Host -ForegroundColor Green "Service removed"
}
else {

    Write-Host -ForegroundColor Blue "No existing service found"
}

# 2. Clean up workspace
git clean -ffdx
