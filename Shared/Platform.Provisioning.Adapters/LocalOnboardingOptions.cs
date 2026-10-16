using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Provisioning;
using Platform.Google;

namespace Platform.Provisioning.Adapters;

public sealed class LocalOnboardingOptions : OnboardingInfrastructureOptions
{
    public override bool IsLocal => true;
    public string KeycloakAdminUsername { get; init; } = "";
    public string KeycloakAdminPassword { get; init; } = "";
    public void Validate(string environment, IConfiguration config)
    {
        if (environment != "Development" || !config.GetValue<bool>("LocalDemo:Enabled"))
            throw new InvalidOperationException("Local onboarding requires Development and LocalDemo:Enabled.");
        if (!File.Exists(InstallerPath) || !File.Exists(CommerceConfigPath))
            throw new InvalidOperationException("Publish the installer and prepare its configuration before starting onboarding.");
        if (!File.Exists(Path.Combine(Path.GetDirectoryName(InstallerPath)!,"wwwroot","logo.png")))
            throw new InvalidOperationException("The published installer logo resource is missing.");
        foreach (var directory in new[] { WorkingDirectory,TenantDirectory,RouteDirectory,SecretDirectory,NotificationDirectory,MobileDirectory })
        {
            if (!Path.IsPathFullyQualified(directory)) throw new InvalidOperationException("Onboarding directories must be absolute paths.");
            Directory.CreateDirectory(directory);
        }
        foreach (var endpoint in new[] { StoreBaseUrl,AdminBaseUrl,KeycloakAuthority })
        {
            var uri = new Uri(endpoint);
            if (!uri.IsLoopback) throw new InvalidOperationException("Local onboarding endpoints must use loopback hosts.");
        }
        if (string.IsNullOrWhiteSpace(MongoAdminConnection) || string.IsNullOrWhiteSpace(KeycloakAdminPassword))
            throw new InvalidOperationException("Local Mongo and Keycloak administrator credentials are required.");
    }
}

public static class LocalOnboarding
{
    public static IServiceCollection AddLocalOnboarding(this IServiceCollection services, IConfiguration config, string environment)
    {
        var options = config.GetSection("Provisioning:Local").Get<LocalOnboardingOptions>()
            ?? throw new InvalidOperationException("Configure Provisioning:Local.");
        options.Validate(environment, config);
        var google = config["Provisioning:Google:Provider"];
        if (google is not ("Disabled" or "Google"))
            throw new InvalidOperationException("Choose an explicit Disabled or Google provisioning provider.");
        if (google == "Google") services.AddGoogleCloud(config);
        services.AddSingleton(options);
        services.AddSingleton<OnboardingInfrastructureOptions>(options);
        services.AddHttpClient("onboarding-keycloak", client => client.Timeout = TimeSpan.FromSeconds(30))
            .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler { AllowAutoRedirect = false });
        services.AddScoped<IProvisioningStep, TenantSecretsStep>();
        services.AddScoped<IProvisioningStep, MongoDatabaseStep>();
        services.AddScoped<IProvisioningStep, StoreInstallerStep>();
        services.AddScoped<IProvisioningStep, KeycloakTenantStep>();
        if (google == "Google") services.AddScoped<IProvisioningStep, GoogleTenantStep>();
        services.AddScoped<IProvisioningStep, LocalTenantPublicationStep>();
        return services;
    }
}

internal static class PrivateFiles
{
    public static async Task WriteAsync(string path, string content, CancellationToken ct)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        var temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            var options = new FileStreamOptions { Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None };
            if (!OperatingSystem.IsWindows()) options.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
            await using (var stream = new FileStream(temporary,options))
            await using (var writer = new StreamWriter(stream)) await writer.WriteAsync(content.AsMemory(),ct);
            File.Move(temporary,path,true);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }
}
