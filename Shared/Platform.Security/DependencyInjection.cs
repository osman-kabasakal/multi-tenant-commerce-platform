using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;

namespace Platform.Security;

public static class DependencyInjection
{
    public static IServiceCollection AddPlatformSecurity(this IServiceCollection services, IConfiguration configuration, string environment)
    {
        var provider = configuration["PlatformSecurity:Provider"]
            ?? throw new InvalidOperationException("Set PlatformSecurity:Provider to Local or Azure explicitly.");
        if(provider == "Local")
        {
            if(environment != Environments.Development || !configuration.GetValue<bool>("LocalDemo:Enabled"))
                throw new InvalidOperationException("Local encryption requires Development and LocalDemo:Enabled.");
            services.TryAddSingleton<ITenantEncryptionService>(_ => new LocalEncryptionService(
                configuration["PlatformSecurity:Local:MasterKeyBase64"]
                ?? File.ReadAllText(configuration["PlatformSecurity:Local:MasterKeyFile"]
                    ?? throw new InvalidOperationException("A shared local master key is required." )).Trim()));
        }
        else if(provider == "Azure")
        {
            var vault = configuration["PlatformSecurity:Azure:VaultUrl"]
                ?? throw new InvalidOperationException("PlatformSecurity:Azure:VaultUrl is required.");
            var key = configuration["PlatformSecurity:Azure:KeyName"]
                ?? throw new InvalidOperationException("PlatformSecurity:Azure:KeyName is required.");
            services.TryAddSingleton<ITenantEncryptionService>(_ => {
                var credential = new DefaultAzureCredential();
                return new AzureEncryptionService(new KeyClient(new Uri(vault),credential),credential,key);
            });
        }
        else throw new InvalidOperationException("Unknown PlatformSecurity provider; no fallback is allowed.");
        var connection = configuration["PlatformSecurity:ConnectionString"]
            ?? throw new InvalidOperationException("A shared PlatformSecurity:ConnectionString is required.");
        services.TryAddSingleton(sp => new PostgresSecretStore(connection,sp.GetRequiredService<ITenantEncryptionService>(),
            configuration.GetValue<bool>("PlatformSecurity:InitializeSchema"),
            configuration.GetValue<bool>("PlatformSecurity:ReadOnly")));
        services.TryAddSingleton<ISecretStore>(sp => sp.GetRequiredService<PostgresSecretStore>());
        services.TryAddSingleton<ITenantSecrets>(sp => sp.GetRequiredService<PostgresSecretStore>());
        services.TryAddEnumerable(ServiceDescriptor.Singleton<IHostedService, SecurityStartup>());
        return services;
    }
    private sealed class SecurityStartup(PostgresSecretStore store) : IHostedService
    {
        public Task StartAsync(CancellationToken cancellationToken) => store.InitializeAsync(cancellationToken);
        public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    }
}
