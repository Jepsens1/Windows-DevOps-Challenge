param(
    $Port,
    $Hostname,
    $Endpoint,
    $LogDirectory
)
Describe "Application Smoke Tests" {

    Context "Port Accessibility" {
        It "Port $($Port) is open and listening on $($Hostname)" {
            $result = Test-NetConnection -ComputerName $Hostname -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue
            $result | Should -Be $true
        }
    }

    Context "Health Endpoint" {

        It "GET $($Endpoint) returns HTTP 200" {
            $response = Invoke-WebRequest -Uri $Endpoint -Method Get -UseBasicParsing -ErrorAction Stop
            $response.StatusCode | Should -Be 200
        }
    }

    Context "Logging" {
        It "Log directory exists at $($LogDirectory)" {
            Test-Path -Path $LogDirectory -PathType Container | Should -Be $true
        }
        It "At least one non-empty log file exists" {
            $logFiles = Get-ChildItem -Path $LogDirectory -Filter "*.txt" -Recurse | Where-Object { $_.Length -gt 0 }
            $logFiles | Should -Not -BeNullOrEmpty
        }
    }
}
