using Microsoft.AspNetCore.Mvc;

namespace app.Controllers;

[Route("api/health")]
[ApiController]
public class HomeController : ControllerBase
{

    [HttpGet()]
    public IActionResult GetHealthStatus()
    {
        return Ok("Health Ok");

    }
}
