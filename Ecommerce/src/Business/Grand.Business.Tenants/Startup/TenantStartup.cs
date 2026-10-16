using Platform.Security;
using Grand.Business.Core.Interfaces.Tenants.KeycloakJwtToken;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Tenants.Extensions;
using Grand.Business.Tenants.Services.KeycloakJwtToken;
using Grand.Business.Tenants.Services.KeycloakUsers;
using Grand.Domain.Tenants;
using Grand.Infrastructure;
using Keycloak.Net;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver;
using System;

namespace Grand.Business.Tenants.Startup;

public class TenantStartup : IStartupApplication
{
    public int Priority => 10;

    public bool BeforeConfigure => false;

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {

    }

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton(provider =>
        {
            var settings = new KeycloakSettings();
            configuration.GetSection("KeyCloakServiceClient").Bind(settings);
            if (string.IsNullOrWhiteSpace(settings.Authority) || string.IsNullOrWhiteSpace(settings.Realm) || string.IsNullOrWhiteSpace(settings.ClientId))
                throw new InvalidOperationException("Configure the optional Keycloak management client before using legacy identity administration.");
            settings.ClientSecret = provider.GetRequiredService<ISecretStore>()
                .GetAsync("system", $"ClientSecret-{settings.ClientId}").GetAwaiter().GetResult();
            return settings;
        });
        services.Configure<KeycloakSettings>(configuration.GetSection("KeyCloakServiceClient"));

        // Public issuer/JWKS verification needs no confidential management credential.
        services.Configure<AuthConfiguration>(configuration.GetSection("AuthConfiguration"));

        services.AddTransient<IKeycloakJwtTokenValidationService, KeycloakJwtTokenValidationService>();

        services.AddScoped<IKeycloakClientService, KeycloakClientService>();
        services.AddScoped<IKeycloakUserService, KeycloakUserService>();

        services.AddScopedServiceProvider<IMongoDatabase>();

    }
}
