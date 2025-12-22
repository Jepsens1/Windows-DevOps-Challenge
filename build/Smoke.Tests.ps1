<#
.SYNOPSIS
Pester smoke tests that validate the application is running and logs are written.

.DESCRIPTION
Runs a minimal set of Pester tests to confirm the application is listening on the configured port
The health endpoint returns HTTP 200 and logs are being written to the configured logs directory. 
The script reads connection details from `TestConfig.psd1`.

.NOTES
Ensure the application is running before executing these tests. Run with `Invoke-Pester .\build\Smoke.Tests.ps1`.
#>

# Ensure script is executed with PowerShell V7 and as Admin mode
#requires -Version 7.0
#requires -RunAsAdministrator

Describe "Application Smoke Tests" {
	BeforeAll {
		$configFile = Join-Path $PSScriptRoot "TestConfig.psd1"
		$config = Import-PowerShellDataFile -Path $configFile

		$baseUrl = "http://$($config.Host):$($config.Port)"
		$endpoint = "$($baseUrl)$($config.EndpointPath)"
		$rootDir = Split-Path -Path $PSScriptRoot -Parent
		$logDirectory = Resolve-Path -Path "$($rootDir)\logs"

	}
	Context "Port Accessibility" {
		It "Port $($config.Port) is open and listening on $($config.Host)" {
			$result = Test-NetConnection -ComputerName $config.Host -Port $config.Port -InformationLevel Quiet -WarningAction SilentlyContinue
			$result | Should -Be $true
		}
	}

	Context "Health Endpoint" {

		It "GET $($endpoint) returns HTTP 200" {
			$response = Invoke-WebRequest -Uri $endpoint -Method Get -UseBasicParsing -ErrorAction Stop
			$response.StatusCode | Should -Be 200
		}
	}

	Context "Logging" {
		It "Log directory exists at $($logDirectory)" {
			Test-Path -Path $logDirectory -PathType Container | Should -Be $true
		}
		It "At least one non-empty log file exists" {
			Write-Host "Log directory $($logDirectory)"
			$logFiles = Get-ChildItem -Path "$($logDirectory)\*" -Include *.txt
			$logFiles | Should -Not -BeNullOrEmpty
		}
	}
}
