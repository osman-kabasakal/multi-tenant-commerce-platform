using System.Collections.Concurrent;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class IosReleaseCoordinatorTests
{
    [TestMethod]
    public async Task EnqueuePinsTheOwnedFirebaseSdkAndMacIdentityWithoutSigningMaterialOrProviderWrites()
    {
        using var f = new IosCoordinatorFixture();
        var checkpoint = await f.Coordinator().EnqueueAsync(f.Request, f.Completed, default);
        var job = f.Queue.Jobs[f.Request.TenantId]; job.Plan.Validate();
        Assert.AreEqual("IosQueue", checkpoint.Provider); Assert.AreEqual(f.Options.ExpectedSourceHash, job.Plan.SourceHash);
        Assert.AreEqual(f.Options.DevelopmentTeam, job.Plan.DevelopmentTeam); Assert.AreEqual(IosReleaseOptions.SdkHash(f.Android.Firebase), job.Plan.FirebaseSdkSha256);
        Assert.AreEqual(f.Android.Firebase.IosAppId, job.Plan.IosAppId); Assert.AreEqual(0, f.Android.Server.Requests);
        var serialized = JsonSerializer.Serialize(job.Plan);
        Assert.IsFalse(serialized.Contains("PRIVATE KEY")); Assert.IsFalse(serialized.Contains("DeviceUdids")); Assert.IsFalse(serialized.Contains("<plist>"));
        await f.Coordinator().EnqueueAsync(f.Request, f.Completed, default);
        Assert.AreEqual(1, f.Queue.Jobs.Count);
    }
    [TestMethod]
    public async Task MacWaitDefersTheParentWithoutClaimingDeliveryOrChangingItsOriginalPlan()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync();
        var error = await Assert.ThrowsExceptionAsync<ProvisioningDeferredException>(() => f.Coordinator().CompleteAsync(f.Request, f.Completed, default));
        Assert.AreEqual("mobile-ios-release:WaitingForMac", error.ReasonCode);
        Assert.AreEqual("Pending", f.Queue.Jobs[f.Request.TenantId].State); Assert.AreEqual(0, f.Android.Server.Requests);
        f.Queue.Jobs[f.Request.TenantId] = f.Queue.Jobs[f.Request.TenantId] with { State = "Running" };
        await Assert.ThrowsExceptionAsync<ProvisioningDeferredException>(() => f.Coordinator().CompleteAsync(f.Request, f.Completed, default));
    }
    [TestMethod]
    public async Task AVerifiedIosReceiptAndRemoteReleaseAreRequiredForTheCompletionCheckpoint()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync(); f.Succeed();
        var result = await f.Coordinator().CompleteAsync(f.Request, f.Completed, default);
        Assert.AreEqual("IosAppDistribution", result.Provider); Assert.AreEqual("true", result.Resources["symbolsUploaded"]);
        Assert.AreEqual(f.Receipt().IpaSha256, result.Resources["sha256"]); Assert.AreEqual(1, f.Android.Server.ReleaseReads); Assert.AreEqual(0, f.Android.Server.Uploads);
        f.Completed["mobile-ios-release"] = result;
        await f.Coordinator().ValidateAsync(f.Request, f.Completed, default);
        Assert.AreEqual(2, f.Android.Server.ReleaseReads);
    }
    [TestMethod]
    public async Task FailedMissingOrIncompleteMacReceiptsNeverCompleteTheParent()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync();
        var job = f.Queue.Jobs[f.Request.TenantId];
        f.Queue.Jobs[f.Request.TenantId] = job with { State = "Failed" };
        await Assert.ThrowsExceptionAsync<IosReleaseFailedException>(() => f.Coordinator().CompleteAsync(f.Request, f.Completed, default));
        f.Queue.Jobs[f.Request.TenantId] = job with { State = "Succeeded" };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().CompleteAsync(f.Request, f.Completed, default));
        f.Queue.Jobs[f.Request.TenantId] = job with { State = "Succeeded", Receipt = f.Receipt() with { SymbolsUploaded = false } };
        await Assert.ThrowsExceptionAsync<ArgumentException>(() => f.Coordinator().CompleteAsync(f.Request, f.Completed, default));
        Assert.AreEqual(0, f.Android.Server.Requests);
    }
    [TestMethod]
    public async Task LostQueueStateIsNotRecreatedBehindAnExistingCheckpoint()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync(); f.Queue.Jobs.Clear();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().ValidateAsync(f.Request, f.Completed, default));
        Assert.AreEqual(1, f.Queue.Enqueues); Assert.AreEqual(0, f.Android.Server.Requests);
    }
    [TestMethod]
    public async Task SourceCertificateVersionAndSdkDriftRequireAnExplicitMigration()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync();
        foreach (var options in new[] {
            new IosReleaseBindingOptions { DevelopmentTeam = f.Options.DevelopmentTeam, SigningCertificateSha256 = f.Options.SigningCertificateSha256, ExpectedSourceHash = new string('c', 64), BuildNumber = 7 },
            new IosReleaseBindingOptions { DevelopmentTeam = f.Options.DevelopmentTeam, SigningCertificateSha256 = new string('d', 64), ExpectedSourceHash = f.Options.ExpectedSourceHash, BuildNumber = 7 },
            new IosReleaseBindingOptions { DevelopmentTeam = f.Options.DevelopmentTeam, SigningCertificateSha256 = f.Options.SigningCertificateSha256, ExpectedSourceHash = f.Options.ExpectedSourceHash, BuildNumber = 8 } })
            await Assert.ThrowsExceptionAsync<ProvisioningConflictException>(() => f.Coordinator(options).ValidateAsync(f.Request, f.Completed, default));
        var changed = f.Android.Firebase with { IosConfigPlist = f.Android.Firebase.IosConfigPlist + "<!--changed-->" };
        f.Android.Secrets.Values[(f.Request.TenantId, TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(changed);
        await Assert.ThrowsExceptionAsync<ProvisioningConflictException>(() => f.Coordinator().ValidateAsync(f.Request, f.Completed, default));
        Assert.AreEqual(0, f.Android.Server.Requests);
    }
    [TestMethod]
    public async Task WrongTenantTargetReadinessAndUnselectedIosPolicyStopBeforeScheduling()
    {
        using var f = new IosCoordinatorFixture();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().EnqueueAsync(f.Request with { MobileReleaseProfile = "AndroidAppDistribution" }, f.Completed, default));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().EnqueueAsync(f.Request, new Dictionary<string, ProvisioningStepResult>(), default));
        var changed = f.Android.Firebase with { IosBundleId = "dev.foreign.bundle" };
        f.Android.Secrets.Values[(f.Request.TenantId, TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(changed);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().EnqueueAsync(f.Request, f.Completed, default));
        Assert.AreEqual(0, f.Queue.Enqueues); Assert.AreEqual(0, f.Android.Server.Requests);
    }
    [TestMethod]
    public async Task ACheckpointOrRemoteReleaseCannotBeSubstitutedOnReplay()
    {
        using var f = new IosCoordinatorFixture(); await f.ScheduleAsync(); f.Succeed();
        var result = await f.Coordinator().CompleteAsync(f.Request, f.Completed, default);
        f.Completed["mobile-ios-release"] = result with { Resources = new Dictionary<string, string>(result.Resources) { ["sha256"] = new string('e', 64) } };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().ValidateAsync(f.Request, f.Completed, default));
        f.Completed["mobile-ios-release"] = result; f.Android.Server.BuildVersion = "8";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Coordinator().ValidateAsync(f.Request, f.Completed, default));
        Assert.AreEqual(0, f.Android.Server.Uploads);
    }
    [TestMethod]
    public async Task TheActualPortablePipelineQueuesIosBeforeAndroidAndWaitsForIosAfterIt()
    {
        using var f = new Fixture(); using var mobile = new AndroidFixture();
        f.Values["Provisioning:Profile"] = "Portable"; f.Values["Provisioning:Portable:DeploymentId"] = mobile.Google.DeploymentId;
        f.Values["Provisioning:Google:Provider"] = "Google"; f.Values["Provisioning:Google:AllowCloudWrites"] = "true";
        f.Values["Provisioning:Google:Parent"] = mobile.Google.Parent; f.Values["Provisioning:Google:DeploymentId"] = mobile.Google.DeploymentId;
        f.Values["Provisioning:Google:ProjectIdPrefix"] = mobile.Google.ProjectIdPrefix; f.Values["Provisioning:Google:SenderServiceAccount"] = mobile.Google.SenderServiceAccount;
        f.Values["Provisioning:Mobile:Provider"] = "AndroidIosAppDistribution"; f.Values["Provisioning:ConnectionString"] = "Host=localhost;Database=unused;Username=fixture";
        foreach (var property in typeof(AndroidReleaseOptions).GetProperties().Where(p => p.CanWrite))
            f.Values["Provisioning:Mobile:Android:" + property.Name] = Convert.ToString(property.GetValue(mobile.Options), System.Globalization.CultureInfo.InvariantCulture);
        f.Values["Provisioning:Mobile:Ios:Release:DevelopmentTeam"] = "ABCDE12345";
        f.Values["Provisioning:Mobile:Ios:Release:SigningCertificateSha256"] = new string('a', 64);
        f.Values["Provisioning:Mobile:Ios:Release:ExpectedSourceHash"] = new string('b', 64);
        var services = new ServiceCollection(); services.AddSingleton<ITenantSecrets>(mobile.Secrets);
        services.AddSingleton<ITenantEncryptionService, RegistrationOnlyEncryption>(); services.AddSingleton<IAndroidSigningKeyFactory>(mobile.Keys);
        services.AddSingleton<IAndroidReleaseBuilder>(mobile.Builder); services.AddSingleton<IIosReleaseQueue>(new IosMemoryQueue());
        services.AddPortableOnboarding(f.Config(), "Production");
        await using var provider = services.BuildServiceProvider(); using var scope = provider.CreateScope();
        var steps = scope.ServiceProvider.GetServices<IProvisioningStep>().Select(x => x.Name).ToArray();
        CollectionAssert.AreEqual(new[] { "publication", "mobile-ios-enqueue", "mobile-android-release", "mobile-ios-release" }, steps[^4..]);
        Assert.AreEqual(3, scope.ServiceProvider.GetServices<IProvisioningGuard>().Count());
    }
}

internal sealed class IosMemoryQueue : IIosReleaseQueue
{
    public readonly ConcurrentDictionary<string, IosReleaseJob> Jobs = new();
    public int Enqueues;
    public Task<IosReleaseJob> EnqueueAsync(IosReleasePlan plan, CancellationToken ct = default)
    {
        plan.Validate(); Interlocked.Increment(ref Enqueues);
        var value = Jobs.GetOrAdd(plan.TenantId, _ => new(plan, "Pending", 0, null, null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
        if (value.Plan != plan) throw new ProvisioningConflictException(); return Task.FromResult(value);
    }
    public Task<IosReleaseJob?> GetAsync(string tenant, CancellationToken ct = default) => Task.FromResult(Jobs.GetValueOrDefault(tenant));
    public Task<bool> RetryAsync(string tenant, CancellationToken ct = default) => throw new NotSupportedException();
}
internal sealed class IosCoordinatorFixture : IDisposable
{
    public readonly AndroidFixture Android = new();
    public readonly IosMemoryQueue Queue = new();
    public readonly IosReleaseBindingOptions Options = new() { DevelopmentTeam = "ABCDE12345", SigningCertificateSha256 = new string('a', 64), ExpectedSourceHash = new string('b', 64), BuildNumber = 7 };
    public TenantProvisioningRequest Request => Android.Request;
    public Dictionary<string, ProvisioningStepResult> Completed => Android.Completed;
    public IosCoordinatorFixture()
    {
        Android.Request = Android.Request with { MobileReleaseProfile = "AndroidIosAppDistribution" };
        Android.Completed["google-firebase"] = new("Google", new Dictionary<string, string> { ["projectId"] = Android.Firebase.ProjectId, ["iosAppId"] = Android.Firebase.IosAppId });
        Android.Server.BuildVersion = "7";
    }
    public IosReleaseCoordinator Coordinator(IosReleaseBindingOptions? options = null) => new(options ?? Options, Android.Deployment, Android.Google, Android.Secrets, Queue,
        new FirebaseAppDistribution(new GoogleRestClient(new HttpClient(Android.Server, false), new AndroidToken()), Android.Google));
    public async Task ScheduleAsync() => Completed["mobile-ios-enqueue"] = await Coordinator().EnqueueAsync(Request, Completed, default);
    public IosReleaseReceipt Receipt()
    {
        var plan = Queue.Jobs[Request.TenantId].Plan;
        return new(new string('f', 64), plan.SourceHash, plan.SigningCertificateSha256, plan.FirebaseSdkSha256, plan.BuildNumber,
            "11111111-1111-1111-1111-111111111111", "22222222-2222-2222-2222-222222222222", $"projects/{plan.ProjectNumber}/apps/{plan.IosAppId}/releases/fixture", true);
    }
    public void Succeed() => Queue.Jobs[Request.TenantId] = Queue.Jobs[Request.TenantId] with { State = "Succeeded", Receipt = Receipt() };
    public void Dispose() => Android.Dispose();
}
