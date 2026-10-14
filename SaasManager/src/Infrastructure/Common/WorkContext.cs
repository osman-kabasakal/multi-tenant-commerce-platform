using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Infrastructure.Common;

public class WorkContext: IWorkContext
{
    private readonly Dictionary<string, string> _claims = new();
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly ILogger<WorkContext> _logger;

    public WorkContext(IHttpContextAccessor httpContextAccessor, ILogger<WorkContext> logger)
    {
        _httpContextAccessor = httpContextAccessor;
        _logger = logger;
    }

    public Guid? KeycloakId { get; private set; }
    public string? UserEmail { get; private set; }
    public bool IsGuest { get; private set; }
    public Guid? GuestId { get; private set; }
    public string? GuestToken { get; private set; }

    public GuestRegistration? GuestRegistration { get; set; }
    public IReadOnlyDictionary<string, string> Claims => _claims.AsReadOnly();

    public void SetUserContext(Guid userId, string email, IDictionary<string, string> claims)
    {
        KeycloakId = userId;
        UserEmail = email;
        IsGuest = false;
        _claims.Clear();
        foreach (var claim in claims)
        {
            _claims[claim.Key] = claim.Value;
        }
        
        _logger.LogInformation(
            "User context set - UserId: {UserId}, Email: {Email}, IP: {IpAddress}",
            userId, email, GetClientIpAddress());
    }

    public void SetGuestContext(Guid guestId, string token)
    {
        GuestId = guestId;
        GuestToken = token;
        IsGuest = true;
        KeycloakId = null;
        UserEmail = null;
        _claims.Clear();
        
        _logger.LogInformation(
            "Guest context set - GuestId: {GuestId}, IP: {IpAddress}",
            guestId, GetClientIpAddress());
    }

    public void SetGuestRegistration(GuestRegistration? guestRegistration)
    {
        GuestRegistration = guestRegistration;
        GuestId = guestRegistration?.Id;
        UserEmail= guestRegistration?.Email;
        IsGuest = false;
        
        _logger.LogInformation(
            "Guest registration set - GuestId: {GuestId}, Email: {Email}, ConvertedBusinessId: {ConvertedBusinessId}, IP: {IpAddress}",
            guestRegistration?.Id, guestRegistration?.Email, guestRegistration?.ConvertedBusinessId, GetClientIpAddress());
    }
    
    public string GetClientIpAddress()
    {
        var context = _httpContextAccessor.HttpContext;
        if (context == null)
        {
            return "Unable to determine IP address";
        }

        var ipAddress = context.Connection.RemoteIpAddress?.ToString();

        // X-Forwarded-For kontrolü (proxy veya load balancer kullanılıyorsa)
        if (context.Request.Headers.ContainsKey("X-Forwarded-For"))
        {
            var forwardedIps = context.Request.Headers["X-Forwarded-For"].ToString();
            var ipList = forwardedIps.Split(',').Select(ip => ip.Trim()).ToList();
            if (ipList.Any())
            {
                ipAddress = ipList.First();
            }
        }

        return ipAddress ?? "IP address not found";
    }
}
