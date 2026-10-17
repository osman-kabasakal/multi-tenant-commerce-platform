using System.Globalization;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;

namespace Grand.Web.MultiTenant.Controllers;

[Route("api/ws/fcm")]
public sealed class FcmWebSocketController(TenantCacheJournal journal, ClientCacheSocket stream, IWorkContext workContext) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Connect()
    {
        if (!journal.Enabled) return NotFound();
        if (!HttpContext.WebSockets.IsWebSocketRequest) return BadRequest();
        // Store ownership is already verified by RequestValidationMiddleware. Authenticate the mobile customer separately.
        var auth = await HttpContext.AuthenticateAsync(FrontendAPIConfig.AuthenticationScheme);
        if (!auth.Succeeded || auth.Principal == null) return Unauthorized();
        var customer = workContext.CurrentCustomer;
        var store = journal.CurrentStore();
        var email = auth.Principal.FindFirst("Email")?.Value;
        var guid = auth.Principal.FindFirst("Guid")?.Value;
        var sameCustomer = customer != null && (email != null ? string.Equals(customer.Email, email, StringComparison.OrdinalIgnoreCase) : Guid.TryParse(guid, out var parsed) && customer.CustomerGuid == parsed);
        if (customer is not { Active: true, Deleted: false } || !sameCustomer || string.IsNullOrEmpty(store) || workContext.CurrentStore?.Id != store || journal.CurrentCustomer() != customer.Id)
            return Unauthorized();
        var origin = Request.Headers.Origin.ToString();
        if (origin.Length > 0 && (!Uri.TryCreate(origin, UriKind.Absolute, out var source) || source.Scheme != Request.Scheme || !string.Equals(source.Authority, Request.Host.Value, StringComparison.OrdinalIgnoreCase)))
            return StatusCode(403);
        if (!long.TryParse(auth.Principal.FindFirst("exp")?.Value, NumberStyles.None, CultureInfo.InvariantCulture, out var expiry)) return Unauthorized();
        var lifetime = DateTimeOffset.FromUnixTimeSeconds(expiry) - DateTimeOffset.UtcNow;
        if (lifetime <= TimeSpan.Zero) return Unauthorized();
        if (lifetime > TimeSpan.FromHours(1)) lifetime = TimeSpan.FromHours(1);
        await stream.ServeAsync(HttpContext, store, customer.Id, lifetime);
        return new EmptyResult();
    }
}
