<#
TestConfig.psd1
Configuration for smoke tests and health checks used by `Smoke.Tests.ps1`.

Keys:
- Port: HTTP port the app listens on
- Host: Hostname or IP (
- EndpointPath: Path to the health endpoint
- LogDirectory: Relative path where application writes logs
#>
@{
    # Http-Port app is running on
    Port = 1234

    # Hostname or IP
    Host = 'localhost'

    # Endpoint to test
    EndpointPath = '/api/health'

    # Log PATH
    LogDirectory = 'logs'
}