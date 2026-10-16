using Azure.Extensions.AspNetCore.Configuration.Secrets;
using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Secrets;
using Core.Models.Configs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.OpenApi.Models;
using NSwag;
using NSwag.Generation.Processors.Security;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Infrastructure.Common;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.Security;
using SaasManager.Web.Services;
using OpenApiOAuthFlow = NSwag.OpenApiOAuthFlow;
using OpenApiOAuthFlows = NSwag.OpenApiOAuthFlows;
using OpenApiSecurityScheme = NSwag.OpenApiSecurityScheme;

namespace SaasManager.Web;

public static class DependencyInjection
{
    public static void AddWebServices(this IHostApplicationBuilder builder)
    {
        
        var origins = SaasHostingSettings.AllowedOrigins(builder.Configuration, builder.Environment.IsDevelopment());
        builder.Services.AddCors(options => options.AddPolicy("AllowedOrigins", policy =>
            policy.WithOrigins(origins).AllowAnyMethod().AllowAnyHeader().AllowCredentials()));
        SaasHostingSettings.AddPersistentCookies(builder.Services, builder.Configuration, builder.Environment.ContentRootPath);

        builder.Services.AddDatabaseDeveloperPageExceptionFilter();

        builder.Services.AddScoped<ICurrentUserService, CurrentUser>();
        builder.Services.AddScoped<IWorkContext, WorkContext>();

        builder.Services.AddHttpContextAccessor();
        builder.Services.AddHealthChecks()
            .AddDbContextCheck<ApplicationDbContext>();

        builder.Services.AddExceptionHandler<CustomExceptionHandler>();

        builder.Services.AddRazorPages();

        // Customise default API behaviour
        builder.Services.Configure<ApiBehaviorOptions>(options =>
            options.SuppressModelStateInvalidFilter = true);

        builder.Services.AddEndpointsApiExplorer();

        builder.Services.AddOpenApiDocument((configure, sp) =>
        {
            var options = sp.GetRequiredService<IOptions<AuthConfiguration>>().Value;
            configure.Title = "SaasManager API";
            // OpenID Connect güvenlik şeması tanımı
            configure.AddSecurity("oauth2", new OpenApiSecurityScheme
            {
                Type = OpenApiSecuritySchemeType.OAuth2,
                Flows = new OpenApiOAuthFlows
                {
                    AuthorizationCode = new OpenApiOAuthFlow
                    {
                        // Düzeltme: IdentityProviderUrl zaten realm'i içeriyor, bu nedenle eklenen /protocol yolu hatalı olabilir
                        AuthorizationUrl = $"{builder.Configuration["AuthConfiguration:IdentityProviderUrl"]}/protocol/openid-connect/auth",
                        TokenUrl = $"{builder.Configuration["AuthConfiguration:IdentityProviderUrl"]}/protocol/openid-connect/token",
                        Scopes = new Dictionary<string, string>
                        {
                            { "openid", "OpenID Connect protokolü" },
                            { "profile", "Kullanıcı profil bilgileri" },
                            { "email", "Email bilgisi" },
                            { "roles", "Kullanıcı rolleri" },
                            { "offline_access", "Refresh token erişimi" }
                        }
                    }
                },
                Description = "Keycloak Authentication"
            });

            // Tüm operasyonlara güvenlik gereksinimi ekleme
            configure.OperationProcessors.Add(new AspNetCoreOperationSecurityScopeProcessor("oauth2"));
            
        });

        // Policy yapılandırmaları
        builder.Services.AddAuthorization(options =>
        {
            options.AddPolicy(Domain.Constants.Policies.RequireAdministratorRole, policy =>
                policy.RequireRole("admin"));
                
            options.AddPolicy(Domain.Constants.Policies.CanPurge, policy =>
                policy.RequireRole("admin"));
        });

        builder.Services.AddAntiforgery(options =>
        {
            options.HeaderName = "X-XSRF-TOKEN";
            options.Cookie = new CookieBuilder()
            {
                Name = "X-XSRF-TOKEN", SecurePolicy = builder.Configuration.GetValue<bool>("LocalDemo:Enabled") ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always, HttpOnly = false
            };
        });
    }

    public static void AddKeyVaultIfConfigured(this IHostApplicationBuilder builder)
    {
        var provider = builder.Configuration["PlatformConfiguration:Provider"];
        var local = builder.Configuration.GetValue<bool>("LocalDemo:Enabled");
        var keyVaultUri = builder.Configuration["AZURE_KEY_VAULT_ENDPOINT"];
        if (provider is not (null or "Environment" or "AzureKeyVault"))
            throw new InvalidOperationException("Choose an Environment or AzureKeyVault configuration provider.");
        if (!local && (provider == "AzureKeyVault" || provider == null && !string.IsNullOrWhiteSpace(keyVaultUri)))
        {
            if (string.IsNullOrWhiteSpace(keyVaultUri)) throw new InvalidOperationException("Configure the Azure Key Vault endpoint explicitly.");
            var credential = new DefaultAzureCredential();
            var client = new SecretClient(new Uri(keyVaultUri),credential);
            builder.Configuration.AddAzureKeyVault(client,new KeyVaultSecretManager());
        }
        builder.Services.AddCardProtection(builder.Configuration);
    }
}
