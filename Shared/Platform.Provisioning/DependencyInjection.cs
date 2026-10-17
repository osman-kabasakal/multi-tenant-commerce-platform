using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Platform.Provisioning;

public static class DependencyInjection
{
    public static IServiceCollection AddPlatformProvisioning(this IServiceCollection services, IConfiguration configuration)
    {
        var connection = configuration["Provisioning:ConnectionString"] ?? configuration["PlatformSecurity:ConnectionString"]
            ?? throw new InvalidOperationException("A PostgreSQL provisioning connection string is required.");
        services.AddSingleton(_ => new PostgresProvisioningQueue(connection));
        services.AddSingleton<IProvisioningQueue>(sp => sp.GetRequiredService<PostgresProvisioningQueue>());
        services.AddSingleton(_ => new AndroidBuildQueue(connection));
        services.AddSingleton(_ => new IosBuildQueue(connection));
        services.AddSingleton(_ => new TenantDomainRegistry(connection));
        services.AddSingleton(_ => new DomainActivationQueue(connection));
        services.AddSingleton(_ => new MobileIdentityRegistry(connection));
        services.AddSingleton(_ => new MobileBrandingStore(connection));
        services.AddSingleton(_ => new PostgresIosReleaseQueue(connection));
        services.AddSingleton<IIosReleaseQueue>(sp => sp.GetRequiredService<PostgresIosReleaseQueue>());
        if (configuration.GetValue<bool>("Provisioning:InitializeSchema")) services.AddHostedService<ProvisioningStartup>();
        return services;
    }
    public static IServiceCollection AddProvisioningWorker(this IServiceCollection services, ProvisioningWorkerOptions? options = null)
    {
        options ??= new();
        if (options.LeaseDuration < TimeSpan.FromSeconds(3) || options.PollInterval <= TimeSpan.Zero || options.MaxAttempts < 1)
            throw new ArgumentException("Invalid provisioning worker options.");
        services.AddSingleton(options);
        services.AddHostedService<ProvisioningWorker>();
        return services;
    }
    private sealed class ProvisioningStartup(PostgresProvisioningQueue queue) : IHostedService
    {
        public Task StartAsync(CancellationToken cancellationToken) => queue.InitializeAsync(cancellationToken);
        public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    }
}
