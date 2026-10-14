using Grand.Infrastructure.Caching;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace Authentication.Keycloak.Services.AuthenticationServices;
public partial class LogoutSessionManager
{
    private static readonly object _lock = new();
    private readonly ILogger<LogoutSessionManager> _logger;
    private readonly ICacheBase _cache;

    public LogoutSessionManager(ILoggerFactory loggerFactory, ICacheBase cache)
    {
        _cache = cache;
        _logger = loggerFactory.CreateLogger<LogoutSessionManager>();
    }

    public async Task Add(string? sub, string? sid)
    {
        _logger.LogWarning("BC Add a logout to the session: sub: {sub}, sid: {sid}", sub, sid);
        
        lock (_lock)
        {
            var key = sub + sid;
            var logoutSession = _cache.Get<string?>(key,()=>null);
            _logger.LogInformation("BC logoutSession: {logoutSession}", logoutSession);
            if (logoutSession != null)
            {
                var session = JsonSerializer.Deserialize<BackchannelLogoutSession>(logoutSession);
            }
            else
            {
                var newSession = new BackchannelLogoutSession { Sub = sub, Sid = sid };
                _cache.SetAsync<string>(key, ()=>Task.FromResult(JsonSerializer.Serialize(newSession))).ConfigureAwait(false)
                    .GetAwaiter().GetResult();
            }
        }
    }

    public async Task<bool> IsLoggedOutAsync(string? sub, string? sid)
    {
        var key = sub + sid;
        var matches = false;
        var logoutSession = await _cache.GetAsync<string?>(key,()=>Task.FromResult<string?>(null));
        if (logoutSession != null)
        {
            var session = JsonSerializer.Deserialize<BackchannelLogoutSession>(logoutSession);
            if (session != null)
            {
                matches = session.IsMatch(sub, sid);
            }

            _logger.LogInformation("BC Logout session exists T/F {matches} : {sub}, sid: {sid}", matches, sub, sid);
        }

        return matches;
    }
}
public partial class LogoutSessionManager
{
    private class BackchannelLogoutSession
    {
        public string? Sub { get; set; }
        public string? Sid { get; set; }

        public bool IsMatch(string? sub, string? sid)
        {
            return (Sid == sid && Sub == sub) ||
                   (Sid == sid && Sub == null) ||
                   (Sid == null && Sub == sub);
        }
    }
}