using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver;
using Platform.Google;

namespace Platform.Provisioning.Adapters;

public abstract class OnboardingInfrastructureOptions
{
    public abstract bool IsLocal { get; }
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

    public string StoreUrl(string slug) => TenantUrl(StoreBaseUrl, slug);
    public string AdminUrl(string slug) => TenantUrl(AdminBaseUrl, slug) + "/Admin";
    private static string TenantUrl(string baseUrl, string slug)
    {
        var uri = new Uri(baseUrl);
        return new UriBuilder(uri) { Host = slug + "." + uri.Host }.Uri.GetLeftPart(UriPartial.Authority);
    }
}

public sealed class PortableOnboardingOptions : OnboardingInfrastructureOptions
{
    public override bool IsLocal => false;
    public string DeploymentId { get; init; } = "";
    public string KeycloakAdminRealm { get; init; } = "";
    public string KeycloakAdminClientId { get; init; } = "";
    public string KeycloakAdminClientSecret { get; init; } = "";
    public string? IdentityRootCertificateFile { get; init; }
    public string? IngressRootCertificateFile { get; init; }
    public string InstallerEnvironment { get; private set; } = "Production";

    public void Validate(string environment, IConfiguration config)
    {
        if (config.GetValue<bool>("LocalDemo:Enabled") || environment is not ("Production" or "Staging" or "Development"))
            throw new InvalidOperationException("Portable onboarding requires an explicit deployment environment with LocalDemo disabled.");
        if (config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure"))
            throw new InvalidOperationException("Portable onboarding requires explicit AesGcm or Azure shared encryption.");
        if (!Regex.IsMatch(DeploymentId,"^[a-z][a-z0-9-]{2,39}$") ||
            !Regex.IsMatch(KeycloakRealm,"^[a-zA-Z0-9_-]{1,100}$") || !Regex.IsMatch(KeycloakAdminRealm,"^[a-zA-Z0-9_-]{1,100}$") ||
            string.IsNullOrWhiteSpace(KeycloakAdminClientId) || string.IsNullOrWhiteSpace(KeycloakAdminClientSecret))
            throw new InvalidOperationException("Configure a deployment id and a scoped Keycloak provisioning service account.");
        foreach (var endpoint in new[] { StoreBaseUrl, AdminBaseUrl, KeycloakAuthority })
            if (!Uri.TryCreate(endpoint,UriKind.Absolute,out var uri) || uri.Scheme!="https" || uri.AbsolutePath!="/" ||
                !string.IsNullOrEmpty(uri.UserInfo) || !string.IsNullOrEmpty(uri.Query) || !string.IsNullOrEmpty(uri.Fragment) || uri.Host.Contains('*'))
                throw new InvalidOperationException("Portable endpoints must be HTTPS origins with no credentials, paths or wildcards.");
        if (new Uri(StoreBaseUrl).Host.Equals(new Uri(AdminBaseUrl).Host,StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Store and admin must use separate configured parent domains.");
        var mongo=MongoClientSettings.FromConnectionString(MongoAdminConnection);
        if (mongo.Credential == null) throw new InvalidOperationException("Mongo provisioning requires authenticated administrator credentials.");
        if (!Path.IsPathFullyQualified(InstallerPath) || !Path.IsPathFullyQualified(CommerceConfigPath) || !File.Exists(InstallerPath) || !File.Exists(CommerceConfigPath) ||
            !File.Exists(Path.Combine(Path.GetDirectoryName(InstallerPath)!,"wwwroot","logo.png")))
            throw new InvalidOperationException("Publish the managed installer and supply its private portable configuration first.");
        var child=new ConfigurationBuilder().AddJsonFile(CommerceConfigPath).Build();
        if (child.GetValue<bool>("LocalDemo:Enabled") || child["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") ||
            child["PlatformConfiguration:Provider"] is not ("Environment" or "AzureKeyVault"))
            throw new InvalidOperationException("The managed installer configuration must explicitly select portable production providers.");
        foreach (var directory in new[] { WorkingDirectory,TenantDirectory,RouteDirectory,MobileDirectory,NotificationDirectory })
        {
            if (!Path.IsPathFullyQualified(directory) || Path.GetFullPath(directory)==Path.GetPathRoot(directory))
                throw new InvalidOperationException("Use absolute private onboarding directories, never a filesystem root.");
            for (var item=new DirectoryInfo(directory);item!=null;item=item.Parent)
                if (item.LinkTarget!=null) throw new InvalidOperationException("Portable onboarding directories cannot contain symbolic links.");
            Directory.CreateDirectory(directory);
            if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(directory,UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.UserExecute);
        }
        using var identityTrust=OnboardingHttp.Create(IdentityRootCertificateFile);
        using var ingressTrust=OnboardingHttp.Create(IngressRootCertificateFile);
        InstallerEnvironment=environment;
    }

    public string TargetFingerprint()
    {
        var mongo=MongoClientSettings.FromConnectionString(MongoAdminConnection);
        var target=JsonSerializer.Serialize(new {version=1,DeploymentId,StoreBaseUrl,AdminBaseUrl,KeycloakAuthority,KeycloakRealm,KeycloakAdminRealm,
            servers=mongo.Servers.Select(s=>s.ToString()).OrderBy(s=>s,StringComparer.Ordinal).ToArray(),mongo.ReplicaSetName,mongo.UseTls,
            InstallerPath,CommerceConfigPath,WorkingDirectory,TenantDirectory,RouteDirectory,MobileDirectory});
        return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(target)));
    }
}

public static class PortableOnboarding
{
    public static IServiceCollection AddPortableOnboarding(this IServiceCollection services,IConfiguration config,string environment)
    {
        var options=config.GetSection("Provisioning:Portable").Get<PortableOnboardingOptions>()??throw new InvalidOperationException("Configure Provisioning:Portable explicitly.");
        options.Validate(environment,config);
        var domains=config.GetSection("Provisioning:Domains").Get<TenantDomainOptions>()??throw new InvalidOperationException("Configure domain provisioning explicitly.");
        domains.Validate(options);
        var google=config["Provisioning:Google:Provider"];
        if (google is not ("Disabled" or "Google")) throw new InvalidOperationException("Choose an explicit Disabled or Google provisioning provider.");
        if (google=="Google") services.AddGoogleCloud(config);
        services.AddSingleton(options);services.AddSingleton<OnboardingInfrastructureOptions>(options);services.AddSingleton(domains);
        services.AddHttpClient("onboarding-keycloak",c=>c.Timeout=TimeSpan.FromSeconds(30)).ConfigurePrimaryHttpMessageHandler(()=>OnboardingHttp.Create(options.IdentityRootCertificateFile));
        services.AddHttpClient("onboarding-ingress",c=>c.Timeout=TimeSpan.FromSeconds(30)).ConfigurePrimaryHttpMessageHandler(()=>OnboardingHttp.Create(options.IngressRootCertificateFile));
        services.AddHttpClient("onboarding-dns",c=>c.Timeout=TimeSpan.FromSeconds(30)).ConfigurePrimaryHttpMessageHandler(()=>new HttpClientHandler {AllowAutoRedirect=false});
        services.AddScoped<IProvisioningGuard,PortableDeploymentGuard>();
        services.AddScoped<IProvisioningStep,TenantSecretsStep>();services.AddScoped<IProvisioningStep,MongoDatabaseStep>();
        services.AddScoped<IProvisioningStep,StoreInstallerStep>();services.AddScoped<IProvisioningStep,KeycloakTenantStep>();
        if (google=="Google") services.AddScoped<IProvisioningStep,GoogleTenantStep>();
        services.AddScoped<IProvisioningStep,TenantDomainStep>();services.AddScoped<IProvisioningStep,PortableTenantPublicationStep>();
        return services;
    }
}

internal static class OnboardingHttp
{
    public static SocketsHttpHandler Create(string? rootFile) =>
        Platform.Security.PrivateCertificateAuthority.CreateHandler(rootFile) ?? new SocketsHttpHandler {AllowAutoRedirect=false};
}
