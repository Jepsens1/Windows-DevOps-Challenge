Describe "Application Smoke Tests" {
    BeforeAll {
        $configFile = Join-Path $PSScriptRoot "TestConfig.psd1"
        $config = Import-PowerShellDataFile -Path $configFile

        $baseUrl = "http://$($config.Host):$($config.Port)"
        $endpoint = "$($baseUrl)$($config.EndpointPath)"
        $logDirectory = Join-Path -Path $PSScriptRoot -ChildPath "..\$($config.LogDirectory)" | Resolve-Path

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
            $logFiles = Get-ChildItem -Path $logDirectory -Filter "*.txt" -Recurse | Where-Object { $_.Length -gt 0 }
            $logFiles | Should -Not -BeNullOrEmpty
        }
    }
}
