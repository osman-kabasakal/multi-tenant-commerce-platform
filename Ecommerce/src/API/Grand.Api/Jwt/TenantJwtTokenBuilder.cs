using Grand.Api.Infrastructure.Extensions;
using Grand.Business.Tenants.Extensions;
using Grand.Infrastructure.Extensions;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace Grand.Api.Jwt;

public sealed class TenantJwtTokenBuilder
{
    private readonly Dictionary<string, string> claims = new();
    private readonly IHttpContextAccessor _httpContextAccessor;
    private string audience = "";
    private int expiryInMinutes = 5;
    private string issuer = "";
    private SecurityKey securityKey;
    private bool useaudience;
    private bool useissuer;

    public TenantJwtTokenBuilder(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    private void EnsureArguments()
    {
        if (securityKey == null)
            throw new ArgumentNullException(nameof(securityKey));

        if (useissuer && string.IsNullOrEmpty(issuer))
            throw new ArgumentNullException(nameof(issuer));

        if (useaudience && string.IsNullOrEmpty(audience))
            throw new ArgumentNullException(nameof(audience));
    }

    public TenantJwtTokenBuilder AddSecurityKey(SecurityKey securityKey)
    {
        this.securityKey = securityKey;
        return this;
    }

    public TenantJwtTokenBuilder AddSecurityKey(string secretKey)
    {
        securityKey = JwtSecurityKey.Create(secretKey);
        return this;
    }

    public TenantJwtTokenBuilder AddIssuer(string issuer)
    {
        this.issuer = issuer;
        useissuer = true;
        return this;
    }

    public TenantJwtTokenBuilder AddAudience(string audience)
    {
        this.audience = audience;
        useaudience = true;
        return this;
    }

    public TenantJwtTokenBuilder AddClaim(string type, string value)
    {
        claims.Add(type, value);
        return this;
    }

    public TenantJwtTokenBuilder AddClaims(Dictionary<string, string> claims)
    {
        foreach (var item in claims)
            if (!this.claims.ContainsKey(item.Key) && !string.IsNullOrEmpty(item.Value))
                this.claims.Add(item.Key, item.Value);
        return this;
    }

    public TenantJwtTokenBuilder AddExpiry(int expiryInMinutes)
    {
        this.expiryInMinutes = expiryInMinutes;
        return this;
    }

    public TenantJwtTokenBuilder UseTenantAsIssuerAndAudience()
    {
        var tenantId = _httpContextAccessor.HttpContext?.GetTenantId();
        if (!string.IsNullOrEmpty(tenantId))
        {
            AddIssuer(tenantId);
            AddAudience(tenantId);
        }
        return this;
    }

    public JwtToken Build()
    {
        EnsureArguments();

        var claims = new List<Claim> {
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            }
            .Union(this.claims.Select(item => new Claim(item.Key, item.Value)));

        var token = new JwtSecurityToken(
            issuer,
            audience,
            claims,
            expires: DateTime.UtcNow.AddMinutes(expiryInMinutes),
            signingCredentials: new SigningCredentials(
                securityKey,
                SecurityAlgorithms.HmacSha256));

        return new JwtToken(token);
    }
}