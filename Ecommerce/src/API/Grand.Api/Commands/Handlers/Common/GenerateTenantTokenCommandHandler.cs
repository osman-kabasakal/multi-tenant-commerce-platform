using Grand.Api.Commands.Models.Common;
using Grand.Api.Infrastructure.Extensions;
using Grand.Api.Jwt;
using Grand.Business.Tenants.Extensions;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Extensions;
using Grand.Infrastructure.MultiTenant;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace Grand.Api.Commands.Handlers.Common;

public class GenerateTenantTokenCommandHandler : IRequestHandler<GenerateTenantTokenCommand, string>
{
    private readonly TenantBackendAPIConfig _apiConfig;
    private readonly ITenantSecretService _tenantSecretService;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public GenerateTenantTokenCommandHandler(
        TenantBackendAPIConfig apiConfig,
        ITenantSecretService tenantSecretService,
        IHttpContextAccessor httpContextAccessor)
    {
        _apiConfig = apiConfig;
        _tenantSecretService = tenantSecretService;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<string> Handle(GenerateTenantTokenCommand request, CancellationToken cancellationToken)
    {
        var tenantId = request.TenantId ?? _httpContextAccessor.HttpContext?.GetTenantId();
        
        // Get tenant-specific secret
        var secretKey = await _tenantSecretService.GetBackendSecretAsync(tenantId);
        
        // Create token builder with tenant context
        var token = new TenantJwtTokenBuilder(_httpContextAccessor);
        token.AddSecurityKey(secretKey);

        if (_apiConfig.ValidateIssuer)
        {
            // Use tenant ID as issuer if available, otherwise use default
            token.AddIssuer(!string.IsNullOrEmpty(tenantId) ? tenantId : _apiConfig.ValidIssuer);
        }

        if (_apiConfig.ValidateAudience)
        {
            // Use tenant ID as audience if available, otherwise use default
            token.AddAudience(!string.IsNullOrEmpty(tenantId) ? tenantId : _apiConfig.ValidAudience);
        }

        token.AddClaims(request.Claims);
        token.AddExpiry(_apiConfig.ExpiryInMinutes);

        return await Task.FromResult(token.Build().Value);
    }
}

public class GenerateTenantTokenWebCommandHandler : IRequestHandler<GenerateTenantTokenWebCommand, string>
{
    private readonly TenantFrontendAPIConfig _frontendApiConfig;
    private readonly ITenantSecretService _tenantSecretService;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public GenerateTenantTokenWebCommandHandler(
        TenantFrontendAPIConfig frontendApiConfig,
        ITenantSecretService tenantSecretService,
        IHttpContextAccessor httpContextAccessor)
    {
        _frontendApiConfig = frontendApiConfig;
        _tenantSecretService = tenantSecretService;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<string> Handle(GenerateTenantTokenWebCommand request, CancellationToken cancellationToken)
    {
        var tenantId = request.TenantId ?? _httpContextAccessor.HttpContext?.GetTenantId();
        
        // Get tenant-specific secret
        var secretKey = await _tenantSecretService.GetFrontendSecretAsync(tenantId);
        
        // Create token builder with tenant context
        var token = new TenantJwtTokenBuilder(_httpContextAccessor);
        token.AddSecurityKey(secretKey);

        if (_frontendApiConfig.ValidateIssuer)
        {
            // Use tenant ID as issuer if available, otherwise use default
            token.AddIssuer(!string.IsNullOrEmpty(tenantId) ? tenantId : _frontendApiConfig.ValidIssuer);
        }

        if (_frontendApiConfig.ValidateAudience)
        {
            // Use tenant ID as audience if available, otherwise use default
            token.AddAudience(!string.IsNullOrEmpty(tenantId) ? tenantId : _frontendApiConfig.ValidAudience);
        }

        token.AddClaims(request.Claims);
        token.AddExpiry(_frontendApiConfig.ExpiryInMinutes);

        return await Task.FromResult(token.Build().Value);
    }
}