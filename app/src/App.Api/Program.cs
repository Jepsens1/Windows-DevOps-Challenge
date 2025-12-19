
using Microsoft.AspNetCore.Builder;
using Serilog;
namespace app;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        builder.Services.AddHostedService<WindowsBackgroundService>();


        // Setup Serilog
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
        string logDestination = Path.Combine(logDirectory, logFileName);
        Console.WriteLine(logDestination);
        Log.Logger = new LoggerConfiguration().MinimumLevel.Debug()
            .WriteTo.File(logDestination, rollingInterval: RollingInterval.Day).CreateLogger();


        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();
        // Enable option to deploy this project as windows service
        builder.Services.AddWindowsService(options =>{});

        builder.Services.AddControllers();

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
