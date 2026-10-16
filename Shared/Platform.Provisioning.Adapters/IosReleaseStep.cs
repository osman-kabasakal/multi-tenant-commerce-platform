using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

// Public binding shared by Linux and Mac. API keys, profiles and device identifiers never enter this configuration.
public sealed class IosReleaseBindingOptions
{
    public string DevelopmentTeam { get; init; } = "";
    public string SigningCertificateSha256 { get; init; } = "";
    public string ExpectedSourceHash { get; init; } = "";
    public int BuildNumber { get; init; } = 1;
    public void Validate(IConfiguration config, string environment, PortableOnboardingOptions deployment)
    {
        new IosWorkerIdentity(deployment.DeploymentId, DevelopmentTeam, SigningCertificateSha256, ExpectedSourceHash).Validate();
        if (BuildNumber is < 1 or > 2100000000 || environment is not ("Production" or "Staging") ||
            config.GetValue<bool>("LocalDemo:Enabled") || config["Provisioning:Profile"] != "Portable" ||
            config["Provisioning:Google:Provider"] != "Google" || !config.GetValue<bool>("Provisioning:Google:AllowCloudWrites") ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") || config.GetValue<bool>("PlatformSecurity:ReadOnly"))
            throw new InvalidOperationException("Combined mobile enrollment requires Portable Production/Staging, writable shared secrets and explicit Google writes.");
    }
}
public static class IosReleaseRegistration
{
    public static IServiceCollection AddIosReleaseQueueing(this IServiceCollection services, IConfiguration config, string environment, PortableOnboardingOptions deployment)
    {
        if (deployment.MobileReleaseProvider != "AndroidIosAppDistribution") return services;
        var options = config.GetSection("Provisioning:Mobile:Ios:Release").Get<IosReleaseBindingOptions>() ?? throw new InvalidOperationException("Configure the public iOS release binding.");
        options.Validate(config, environment, deployment);
        var connection = config["Provisioning:ConnectionString"] ?? config["PlatformSecurity:ConnectionString"] ?? throw new InvalidOperationException("Configure the shared mobile queue.");
        services.TryAddSingleton(_ => new PostgresIosReleaseQueue(connection));
        services.TryAddSingleton<IIosReleaseQueue>(sp => sp.GetRequiredService<PostgresIosReleaseQueue>());
        services.AddSingleton(options); services.AddScoped<IosReleaseCoordinator>();
        services.AddScoped<IProvisioningGuard, IosReleaseGuard>();
        services.AddScoped<IProvisioningStep, IosReleaseEnqueueStep>();
        return services;
    }
}
public sealed class IosReleaseEnqueueStep(IosReleaseCoordinator releases) : IProvisioningStep
{
    public string Name => "mobile-ios-enqueue";
    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
        => releases.EnqueueAsync(request, completed, ct);
}
public sealed class IosReleaseStep(IosReleaseCoordinator releases) : IProvisioningStep
{
    public string Name => "mobile-ios-release";
    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
        => releases.CompleteAsync(request, completed, ct);
}
public sealed class IosReleaseGuard(IosReleaseCoordinator releases) : IProvisioningGuard
{
    public Task ValidateAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
        => releases.ValidateAsync(request, completed, ct);
}
public sealed class IosReleaseFailedException() : Exception("The required iOS release failed. Repair its configuration and retry the owned onboarding job.");

public sealed class IosReleaseCoordinator(IosReleaseBindingOptions options, PortableOnboardingOptions deployment,
    GoogleCloudOptions google, ITenantSecrets secrets, IIosReleaseQueue queue, FirebaseAppDistribution distribution)
{
    private void Policy(TenantProvisioningRequest request)
    {
        request.Validate();
        if (request.MobileReleaseProfile != "AndroidIosAppDistribution" || request.DeploymentId != deployment.DeploymentId || google.DeploymentId != deployment.DeploymentId)
            throw new InvalidOperationException("The iOS request targets a different deployment or release policy.");
    }
    private async Task<(IosReleasePlan Plan, TenantFirebaseConfiguration Firebase)> ContextAsync(TenantProvisioningRequest request,
        IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
    {
        Policy(request);
        if (!completed.TryGetValue("publication", out var published) || published.Provider != "Portable" ||
            published.Resources.GetValueOrDefault("readiness") != "Verified" || published.Resources.GetValueOrDefault("storeUrl") != deployment.StoreUrl(request.Slug) ||
            !completed.TryGetValue("google-firebase", out var cloud) || cloud.Provider != "Google")
            throw new InvalidOperationException("iOS scheduling requires verified public tenant readiness and Google provisioning.");
        var firebase = MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetAsync(request.TenantId, TenantFirebaseConfiguration.SecretName, ct));
        FirebaseConfigValidator.Validate(firebase);
        if (firebase.TenantId != request.TenantId || firebase.ProjectId != google.ProjectId(request.TenantId) ||
            firebase.IosBundleId != (request.IosBundleId ?? "com.example.tenant" + request.TenantId) ||
            firebase.AndroidPackageName != (request.AndroidPackageName ?? "com.example.tenant" + request.TenantId) ||
            firebase.SenderServiceAccount != google.SenderServiceAccount || firebase.DistributionGroupAlias != google.DistributionGroupAlias ||
            cloud.Resources.GetValueOrDefault("projectId") != firebase.ProjectId || cloud.Resources.GetValueOrDefault("iosAppId") != firebase.IosAppId)
            throw new InvalidOperationException("The encrypted Firebase configuration belongs to another tenant, deployment or checkpoint.");
        var plan = new IosReleasePlan(request.TenantId, deployment.DeploymentId, firebase.IosBundleId, options.DevelopmentTeam,
            options.SigningCertificateSha256, options.ExpectedSourceHash, options.BuildNumber, firebase.ProjectId, firebase.ProjectNumber,
            firebase.IosAppId, IosReleaseOptions.SdkHash(firebase), deployment.StoreUrl(request.Slug));
        plan.Validate(); return (plan, firebase);
    }
    private static ProvisioningStepResult Enqueued(IosReleasePlan plan) => new("IosQueue", new Dictionary<string, string> {
        ["iosAppId"] = plan.IosAppId, ["iosBundleId"] = plan.IosBundleId, ["developmentTeam"] = plan.DevelopmentTeam, ["sourceHash"] = plan.SourceHash,
        ["signingCertificateSha256"] = plan.SigningCertificateSha256, ["firebaseSdkSha256"] = plan.FirebaseSdkSha256,
        ["buildNumber"] = plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture)
    });
    private static ProvisioningStepResult Delivered(IosReleasePlan plan, IosReleaseReceipt receipt) => new("IosAppDistribution", new Dictionary<string, string> {
        ["iosAppId"] = plan.IosAppId, ["iosBundleId"] = plan.IosBundleId, ["developmentTeam"] = plan.DevelopmentTeam, ["sourceHash"] = plan.SourceHash,
        ["signingCertificateSha256"] = plan.SigningCertificateSha256, ["firebaseSdkSha256"] = plan.FirebaseSdkSha256,
        ["buildNumber"] = plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture), ["sha256"] = receipt.IpaSha256,
        ["applicationProfileUuid"] = receipt.ApplicationProfileUuid, ["extensionProfileUuid"] = receipt.ExtensionProfileUuid,
        ["release"] = receipt.ReleaseResource, ["symbolsUploaded"] = "true"
    });
    private static void Checkpoint(IReadOnlyDictionary<string, ProvisioningStepResult> completed, string name, ProvisioningStepResult expected)
    {
        if (!completed.TryGetValue(name, out var value) || value.Provider != expected.Provider || value.Resources.Count != expected.Resources.Count ||
            expected.Resources.Any(x => value.Resources.GetValueOrDefault(x.Key) != x.Value))
            throw new InvalidOperationException("The iOS checkpoint differs from its immutable queue plan or receipt.");
    }
    private async Task<ProvisioningStepResult> VerifyAsync(IosReleaseJob job, IosReleasePlan plan, TenantFirebaseConfiguration firebase, CancellationToken ct)
    {
        if (job.Plan != plan || job.State != "Succeeded" || job.Receipt == null) throw new InvalidOperationException("The required iOS release has no matching completion receipt.");
        job.Receipt.Validate(plan);
        await distribution.VerifyReleaseAsync(firebase, "ios", job.Receipt.ReleaseResource, plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture), ct);
        return Delivered(plan, job.Receipt);
    }
    public async Task ValidateAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
    {
        Policy(request); var job = await queue.GetAsync(request.TenantId, ct);
        if (job == null)
        {
            if (completed.ContainsKey("mobile-ios-enqueue") || completed.ContainsKey("mobile-ios-release"))
                throw new InvalidOperationException("The original iOS plan is missing; restore its queue state.");
            return;
        }
        var context = await ContextAsync(request, completed, ct);
        if (job.Plan != context.Plan) throw new ProvisioningConflictException();
        if (completed.ContainsKey("mobile-ios-enqueue")) Checkpoint(completed, "mobile-ios-enqueue", Enqueued(context.Plan));
        if (completed.ContainsKey("mobile-ios-release")) Checkpoint(completed, "mobile-ios-release", await VerifyAsync(job, context.Plan, context.Firebase, ct));
    }
    public async Task<ProvisioningStepResult> EnqueueAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
    {
        var context = await ContextAsync(request, completed, ct);
        await queue.EnqueueAsync(context.Plan, ct); return Enqueued(context.Plan);
    }
    public async Task<ProvisioningStepResult> CompleteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
    {
        var context = await ContextAsync(request, completed, ct); Checkpoint(completed, "mobile-ios-enqueue", Enqueued(context.Plan));
        var job = await queue.GetAsync(request.TenantId, ct) ?? throw new InvalidOperationException("The scheduled iOS plan is missing.");
        if (job.Plan != context.Plan) throw new ProvisioningConflictException();
        if (job.State == "Failed") throw new IosReleaseFailedException();
        if (job.State is "Pending" or "Running") throw new ProvisioningDeferredException("mobile-ios-release:WaitingForMac", TimeSpan.FromSeconds(30));
        return await VerifyAsync(job, context.Plan, context.Firebase, ct);
    }
}
