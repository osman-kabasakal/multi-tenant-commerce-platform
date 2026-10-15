using Platform.Security;
using Azure.Security.KeyVault.Secrets;
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
        var azureKeyVaultClient = services.BuildServiceProvider().GetRequiredService<ISecretStore>();
        var conf = new KeycloakSettings();
        configuration.GetSection("KeyCloakServiceClient").Bind(conf);
        conf.ClientSecret = azureKeyVaultClient.GetAsync("system", $"ClientSecret-{conf.ClientId}").GetAwaiter().GetResult();
        services.AddSingleton(conf);
        services.Configure<KeycloakSettings>(configuration.GetSection("KeyCloakServiceClient"));

        services.Configure<AuthConfiguration>(instance =>
        {
            configuration.GetSection("AuthConfiguration").Bind(instance);
            instance.ClientSecret = azureKeyVaultClient.GetAsync("system", $"ClientSecret-{instance.ClientId}").GetAwaiter().GetResult();
        });

        services.AddTransient<IKeycloakJwtTokenValidationService, KeycloakJwtTokenValidationService>();

        services.AddScoped<IKeycloakClientService, KeycloakClientService>();
        services.AddScoped<IKeycloakUserService, KeycloakUserService>();

        services.AddScopedServiceProvider<IMongoDatabase>();

    }
}
