using Grand.Api.Commands.Models.Common;
using Grand.Api.Models.Common;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Tenants.Extensions;
using Grand.Infrastructure.Extensions;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;

namespace Grand.Api.Controllers;

[ApiController]
[Area("Api")]
[Route("[area]/[controller]/[action]")]
[ApiExplorerSettings(IgnoreApi = false, GroupName = "v1")]
[SwaggerTag("Create tenant-specific token")]
public class TenantTokenController : Controller
{
    private readonly IMediator _mediator;
    private readonly IUserApiService _userApiService;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public TenantTokenController(
        IMediator mediator, 
        IUserApiService userApiService,
        IHttpContextAccessor httpContextAccessor)
    {
        _mediator = mediator;
        _userApiService = userApiService;
        _httpContextAccessor = httpContextAccessor;
    }

    [AllowAnonymous]
    [IgnoreAntiforgeryToken]
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] LoginModel model)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var claims = new Dictionary<string, string> {
            { "Email", model.Email }
        };
        var user = await _userApiService.GetUserByEmail(model.Email);
        if (user != null)
            claims.Add("Token", user.Token);

        // Get the tenant ID from the HTTP context
        var tenantId = _httpContextAccessor.HttpContext?.GetTenantId();

        var token = await _mediator.Send(new GenerateTenantTokenCommand 
        { 
            Claims = claims,
            TenantId = tenantId
        });
        
        return Content(token);
    }
}