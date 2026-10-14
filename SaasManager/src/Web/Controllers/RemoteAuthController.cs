using System.Security.Claims;
using Core.Models.Responses;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Keycloak;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Web.Controllers;

// [Authorize]
[Route("remote-auth/[action]")]
// [ApiController]
public class RemoteAuthController(
    IApplicationDbContext dbContext,
    IMediator mediator,
    IWorkContext workContext) : ControllerBase
{
    public async Task<IActionResult> Callback(string returnUrl="/")
    {   
        var user =HttpContext.User;

        if (!(user.Identity?.IsAuthenticated??false))
        {
            return Ok(ServiceResponse<bool>.Success(false));
        }

        var userId = Guid.Parse(user.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
        var email = user.FindFirst(ClaimTypes.Email)?.Value;
        var guest = await dbContext.GuestRegistrations.FirstOrDefaultAsync(x => x.Email == email! && x.IsActive && !x.IsDeleted);
        if (guest != null)
            return Ok(ServiceResponse<bool>.Success(true));
            
        var guestUser = new GuestRegistration(workContext.UserEmail, "")
        {
            Firstname = workContext.Claims.GetValueOrDefault("firstname"),
            Lastname = workContext.Claims.GetValueOrDefault("lastname"),
        };
        
        guestUser.MarkEmailAsVerified();
        guestUser.MarkAsConverted(workContext.KeycloakId!.Value.ToString());
        
        dbContext.GuestRegistrations.Add(guestUser);
        await dbContext.SaveChangesAsync(default);
        await mediator.Publish(new GuestConvertedToUserEvent(guestUser));
        return Redirect(returnUrl);
    }
}
