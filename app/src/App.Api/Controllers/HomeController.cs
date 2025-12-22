using Microsoft.AspNetCore.Mvc;

namespace app.Controllers;

/// <summary>
/// Root endpoint for the application
/// Define route as *host*/api/health
/// Configure endpoint, returns HTTP 200 OK
/// </summary>
[Route("api/health")]
[ApiController]
public class HomeController : ControllerBase
{

    [HttpGet()]
    public IActionResult GetHealthStatus()
    {
        // Return HTTP 200 OK
        return Ok("Health Ok");
    }
}
