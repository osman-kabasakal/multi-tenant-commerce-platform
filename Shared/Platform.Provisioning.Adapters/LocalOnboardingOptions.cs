using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Provisioning;

namespace Platform.Provisioning.Adapters;

public sealed class LocalOnboardingOptions
{
    public string MongoAdminConnection { get; init; } = "";
    public string InstallerPath { get; init; } = "";
    public string CommerceConfigPath { get; init; } = "";
    public string WorkingDirectory { get; init; } = "";
    public string TenantDirectory { get; init; } = "";
    public string RouteDirectory { get; init; } = "";
    public string SecretDirectory { get; init; } = "";
    public string NotificationDirectory { get; init; } = "";
    public string MobileDirectory { get; init; } = "";
    public string StoreBaseUrl { get; init; } = "http://localhost:18090";
    public string AdminBaseUrl { get; init; } = "http://localhost:18083";
    public string KeycloakAuthority { get; init; } = "http://localhost:18080";
    public string KeycloakRealm { get; init; } = "commerce-demo";
    public string KeycloakAdminUsername { get; init; } = "";
    public string KeycloakAdminPassword { get; init; } = "";

    public string StoreUrl(string slug) => TenantUrl(StoreBaseUrl, slug);
    public string AdminUrl(string slug) => TenantUrl(AdminBaseUrl, slug) + "/Admin";
    private static string TenantUrl(string baseUrl, string slug)
    {
        var uri = new Uri(baseUrl);
        return new UriBuilder(uri) { Host = slug + "." + uri.Host }.Uri.GetLeftPart(UriPartial.Authority);
    }
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
        if (config["Provisioning:Google:Provider"] != "Disabled")
            throw new InvalidOperationException("Local onboarding requires an explicit Disabled Google provider until cloud credentials are configured through a cloud profile.");
        services.AddSingleton(options);
        services.AddHttpClient("onboarding-keycloak", client => client.Timeout = TimeSpan.FromSeconds(30))
            .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler { AllowAutoRedirect = false });
        services.AddScoped<IProvisioningStep, TenantSecretsStep>();
        services.AddScoped<IProvisioningStep, MongoDatabaseStep>();
        services.AddScoped<IProvisioningStep, StoreInstallerStep>();
        services.AddScoped<IProvisioningStep, KeycloakTenantStep>();
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
