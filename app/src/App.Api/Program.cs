
using Microsoft.AspNetCore.Builder;
using Serilog;
namespace app;

/// <summary>
/// Entry point for Windows service application
/// Configures hosting, logging & background worker / windows service
/// </summary>
public class Program
{
    /// <summary>
    /// Defines PATH for storing logs, based on '--log-dir' argument
    /// <exception cref="ArgumentNullException">
    /// Thrown when '--log-dir' is not provided or empty
    /// </exception>
    /// <return>
    /// A string representing PATH for logging
    /// </return>
    /// </summary>
    private static string SetupLogPath(string[] args)
    {
        string logDirectory = string.Empty;
        string logFileName = "dotnetlogs.txt";

        for (int i = 0; i < args.Length; i++)
        {
            if (args[i] == "--log-dir" && i + 1 < args.Length)
            {
                logDirectory = args[i + 1];
            }
        }
        if (String.IsNullOrWhiteSpace(logDirectory))
        {
            throw new ArgumentNullException(logDirectory, "You need to provide --log-dir argument");
        }
        return Path.Combine(logDirectory, logFileName);
    }
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        builder.Services.AddHostedService<WindowsBackgroundService>();

        // Setup Serilog
        string logDestination = SetupLogPath(args);
        Log.Logger = new LoggerConfiguration().MinimumLevel.Debug()
            .WriteTo.File(logDestination, rollingInterval: RollingInterval.Day).CreateLogger();


        // Add SwaggerUI for Debug builds
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        // Enable option to deploy this project as windows service
        builder.Services.AddWindowsService(options => { });

        builder.Services.AddControllers();

        // Add serilog
        builder.Logging.Services.AddSerilog();
        var host = builder.Build();

        // Configure the HTTP request pipeline
        if (host.Environment.IsDevelopment())
        {
            host.UseSwagger();
            host.UseSwaggerUI();
        }

        host.MapControllers();
        host.Run();
    }
}
