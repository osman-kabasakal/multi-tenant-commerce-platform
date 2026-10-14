using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;

namespace SaasManager.Web.Middlewares;

public class AuthenticationMiddleware
{
    private List<string> _excludePaths = [
    "/api/identity/registration"
    ];
    private readonly RequestDelegate _next;
    private readonly ILogger<AuthenticationMiddleware> _logger;

    public AuthenticationMiddleware(RequestDelegate next, ILogger<AuthenticationMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(
        HttpContext context,
        IApplicationDbContext applicationDbContext,
        IWorkContext workContext)
    {
        var path = context.Request.Path.Value?.ToLower();
        var user = context.User;
        
        if (user.Identity?.IsAuthenticated == true)
        {
            var userId = Guid.Parse(user.FindFirst(JwtRegisteredClaimNames.Sub)?.Value!);
            var email = user.FindFirst(JwtRegisteredClaimNames.Email)?.Value;
            var claims = user.Claims.Select(x=>x.Type).Distinct().ToDictionary(c => c, c => user.FindFirstValue(c)??"");
            
            _logger.LogInformation("Authentication middleware - Authenticated user: UserId: {UserId}, Email: {Email}, IP: {IpAddress}", 
                userId, email, context.Connection.RemoteIpAddress);
            
            var guest = await applicationDbContext.GuestRegistrations
                .Include(g => g.ConvertedBusiness)
                .FirstOrDefaultAsync(x => x.Email == email! && x.KeycloakUserId==userId.ToString());
            
            if (guest != null)
            {
                _logger.LogInformation("Authentication middleware - Guest found: GuestId: {GuestId}, Email: {Email}, IsConverted: {IsConverted}, ConvertedBusinessId: {ConvertedBusinessId}", 
                    guest.Id, guest.Email, guest.IsConverted, guest.ConvertedBusinessId);
                
                if (guest.ConvertedBusiness != null)
                {
                    _logger.LogInformation("Authentication middleware - Converted Business details: BusinessId: {BusinessId}, Name: {BusinessName}, CreatedByGuestId: {CreatedByGuestId}", 
                        guest.ConvertedBusiness.Id, guest.ConvertedBusiness.Name, guest.ConvertedBusiness.CreatedByGuestId);
                    
                    // Check if there are any apps for this business
                    var businessApps = await applicationDbContext.BusinessApps
                        .Where(a => a.BusinessId == guest.ConvertedBusiness.Id)
                        .ToListAsync();
                    
                    foreach (var app in businessApps)
                    {
                        _logger.LogInformation("Authentication middleware - Business App: AppId: {AppId}, BusinessId: {BusinessId}, Type: {AppType}", 
                            app.Id, app.BusinessId, app.Type);
                    }
                }
            }
            else
            {
                _logger.LogWarning("Authentication middleware - No guest record found for user: UserId: {UserId}, Email: {Email}", userId, email);
            }
            
            workContext.SetUserContext(userId, email!, claims);
            workContext.SetGuestRegistration(guest);
            
            // if (!(guest?.IsConverted??false) && !_excludePaths.Any(x=>x.StartsWith(path??"",StringComparison.OrdinalIgnoreCase)))
            // {
            //     context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            //     context.Response.ContentType = "application/json";
            //
            //     var result = JsonSerializer.Serialize(new { 
            //         message = "Unauthorized access" 
            //     });
            //
            //     await context.Response.WriteAsync(result);
            //     
            //     return;
            // }
        }
        
        await _next(context);
        return;
    }
}
