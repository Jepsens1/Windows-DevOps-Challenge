using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using app;
using Microsoft.Extensions.Logging;
namespace App.Test;

[TestClass]
public class UnitTest
{
    [TestMethod]
    public async Task ExecuteAsync_ShouldLogBeEnabled_WhenStarted()
    {
        // Arrange
        var loggerMock = new Mock<ILogger<WindowsBackgroundService>>();
        var worker = new WindowsBackgroundService(loggerMock.Object);

        // Act
        await worker.StartAsync(CancellationToken.None);
        await Task.Delay(2000);
        await worker.StopAsync(CancellationToken.None);

        // Assert
        loggerMock.Verify(x => x.IsEnabled(LogLevel.Information));
    }

}
