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
        
        builder.Services.AddCors(options =>
        {
            options.AddPolicy("AllowedOrigins", policyBuilder =>
            {
                policyBuilder
                    .WithOrigins(builder.Environment.IsDevelopment()?
                        (Environment.GetEnvironmentVariable("ASPNETCORE_URLS")?.Split(";")??["https://localhost:5001","https://localhost:44447"]):
                        Environment.GetEnvironmentVariable("ASPNETCORE_URLS")!.Split(";"))
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .AllowCredentials();
            });
        });
        
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
            options.Cookie = new CookieBuilder()
            {
                Name = "X-XSRF-TOKEN", SecurePolicy = builder.Configuration.GetValue<bool>("LocalDemo:Enabled") ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always, HttpOnly = false
            };
        });
    }

    public static void AddKeyVaultIfConfigured(this IHostApplicationBuilder builder)
    {
        if (builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
        {
            builder.Services.AddScoped<ICardDataProtector, DisabledDemoCardProtector>();
            return;
        }
        var keyVaultUri = builder.Configuration["AZURE_KEY_VAULT_ENDPOINT"];
        if (!string.IsNullOrWhiteSpace(keyVaultUri))
        {
            var credential = new DefaultAzureCredential();
            var secretCLient = new SecretClient(new Uri(keyVaultUri), credential);
            builder.Services.AddSingleton(secretCLient);
            builder.Configuration.AddAzureKeyVault(
                secretCLient,
                new KeyVaultSecretManager()
            );
            
            builder.Services.AddSingleton(new KeyClient(new Uri(keyVaultUri), credential));
            builder.Services.AddSingleton<IKeyVaultService, KeyVaultService>();
            builder.Services.AddScoped<ICardDataProtector, AzureKeyVaultCardProtector>();
        }
    }
}
