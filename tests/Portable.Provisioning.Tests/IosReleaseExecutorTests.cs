using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class IosReleaseExecutorTests
{
    [TestMethod]
    public async Task DurableArtifactPrecedesSymbolsAndASeparateExecutorReusesTheSameDelivery()
    {
        using var f = new IosExecutorFixture();
        var first = await f.Executor().ExecuteAsync(f.Plan, default);
        first.Validate(f.Plan);
        Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(1, f.Builder.SymbolUploads);
        Assert.AreEqual(1, f.Android.Server.Uploads); Assert.AreEqual(1, f.Android.Server.Deliveries);
        Assert.AreEqual(1, f.Android.Server.ReleaseReads);
        var restarted = new IosBuilderFixture(f.Android.Root, f.Android.Secrets);
        var second = await f.Executor(restarted).ExecuteAsync(f.Plan, default);
        Assert.AreEqual(first, second); Assert.AreEqual(0, restarted.Builds); Assert.AreEqual(0, restarted.SymbolUploads);
        Assert.AreEqual(1, f.Android.Server.Uploads); Assert.AreEqual(2, f.Android.Server.ReleaseReads);
        Assert.AreEqual(6, f.Apple.Server.Writes);
    }
    [TestMethod]
    public async Task FailedDistributionReusesTheCommittedIpaAndDoesNotUploadSymbolsAgain()
    {
        using var f = new IosExecutorFixture(); f.Android.Server.FailDistributeOnce = true;
        await Assert.ThrowsExceptionAsync<GoogleApiException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.IsTrue(f.Android.Secrets.Values.ContainsKey((f.Plan.TenantId, IosReleaseExecutor.ArtifactSecret)));
        Assert.IsTrue(f.Android.Secrets.Values.ContainsKey((f.Plan.TenantId, IosReleaseExecutor.SymbolsSecret)));
        var restarted = new IosBuilderFixture(f.Android.Root, f.Android.Secrets);
        await f.Executor(restarted).ExecuteAsync(f.Plan, default);
        Assert.AreEqual(0, restarted.Builds); Assert.AreEqual(0, restarted.SymbolUploads);
        Assert.AreEqual(2, f.Android.Server.Uploads); Assert.AreEqual(1, f.Android.Server.Deliveries);
        Assert.AreEqual(f.Android.Server.BinaryHashes[0], f.Android.Server.BinaryHashes[1]);
    }
    [TestMethod]
    public async Task FailedSymbolSubmissionCanResumeWithoutBuildingAnotherIpa()
    {
        using var f = new IosExecutorFixture(); f.Builder.FailSymbolsOnce = true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(0, f.Android.Server.Uploads);
        var restarted = new IosBuilderFixture(f.Android.Root, f.Android.Secrets);
        await f.Executor(restarted).ExecuteAsync(f.Plan, default);
        Assert.AreEqual(0, restarted.Builds); Assert.AreEqual(1, restarted.SymbolUploads);
    }
    [TestMethod]
    public async Task ChangedOrMissingRetainedIpaIsNeverRebuiltUnderTheSameInitialVersion()
    {
        using var f = new IosExecutorFixture(); await f.Executor().ExecuteAsync(f.Plan, default);
        var saved = JsonSerializer.Deserialize<IosBuiltArtifact>(f.Android.Secrets.Values[(f.Plan.TenantId, IosReleaseExecutor.ArtifactSecret)], new JsonSerializerOptions(JsonSerializerDefaults.Web))!;
        File.WriteAllText(f.Builder.BinaryPath(saved), "changed-synthetic-binary");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(1, f.Android.Server.Uploads); Assert.AreEqual(1, f.Builder.SymbolUploads);
        File.Delete(f.Builder.BinaryPath(saved));
        await Assert.ThrowsExceptionAsync<FileNotFoundException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(1, f.Builder.Builds);
    }
    [TestMethod]
    public async Task ForeignGoogleOwnershipStopsBeforeAppleProvisioningOrNativeSigning()
    {
        using var f = new IosExecutorFixture(); f.Android.Server.ForeignProject = true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(0, f.Apple.Server.Requests); Assert.AreEqual(0, f.Builder.Builds); Assert.AreEqual(0, f.Builder.SymbolUploads);
    }
    [TestMethod]
    public async Task ForeignSdkAndMismatchedPublicReadinessCannotCreateAnyAppleResources()
    {
        using var f = new IosExecutorFixture();
        f.Parents.Job = f.Parents.Job with { Steps = new Dictionary<string, ProvisioningStepResult>() };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        f.Parents.Job = f.Parents.Job with { Steps = f.Android.Completed };
        var changed = f.Android.Firebase with { IosConfigPlist = f.Android.Firebase.IosConfigPlist + "<!--changed-->" };
        f.Android.Secrets.Values[(f.Plan.TenantId, TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(changed);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(0, f.Apple.Server.Requests); Assert.AreEqual(0, f.Android.Server.Requests); Assert.AreEqual(0, f.Builder.Builds);
    }
    [TestMethod]
    public async Task WrongSourceOrDeploymentStopsBeforeProviderAccess()
    {
        using var f = new IosExecutorFixture();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan with { SourceHash = new string('d', 64) }, default));
        f.Parents.Job = f.Parents.Job with { Request = f.Android.Request with { DeploymentId = "another-deployment" } };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(0, f.Apple.Server.Requests); Assert.AreEqual(0, f.Android.Server.Requests);
    }
    [TestMethod]
    public async Task ChangedReleaseVersionIsDetectedAfterRestartWithoutAnotherUpload()
    {
        using var f = new IosExecutorFixture(); await f.Executor().ExecuteAsync(f.Plan, default);
        f.Android.Server.BuildVersion = "8";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(1, f.Android.Server.Uploads); Assert.AreEqual(1, f.Android.Server.Deliveries); Assert.AreEqual(1, f.Builder.Builds);
    }
    [TestMethod]
    public async Task AnUploadThatCompletedBeforeTheFinalReadIsNotRepeatedWhenThatReadFails()
    {
        using var f = new IosExecutorFixture(); f.Android.Server.BuildVersion = "8";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.IsTrue(f.Android.Secrets.Values.ContainsKey((f.Plan.TenantId, IosReleaseExecutor.DistributionSecret)));
        f.Android.Server.BuildVersion = "7";
        await f.Executor().ExecuteAsync(f.Plan, default);
        Assert.AreEqual(1, f.Android.Server.Uploads); Assert.AreEqual(1, f.Android.Server.Deliveries); Assert.AreEqual(1, f.Builder.Builds);
    }
    [TestMethod]
    public async Task ApnsTransportSurvivesDurableBuildAndReplayWithoutChangingTheFirebaseApp()
    {
        using var f = new IosExecutorFixture(apns: true);
        var first = await f.Executor().ExecuteAsync(f.Plan, default);
        var second = await f.Executor().ExecuteAsync(f.Plan, default);
        Assert.AreEqual(first, second); Assert.AreEqual("Apns", f.Plan.PushTransport);
        Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(1, f.Android.Server.Deliveries);
        var artifact = JsonSerializer.Deserialize<IosBuiltArtifact>(f.Android.Secrets.Values[(f.Plan.TenantId, IosReleaseExecutor.ArtifactSecret)], new JsonSerializerOptions(JsonSerializerDefaults.Web))!;
        Assert.AreEqual("Apns", artifact.Plan.PushTransport);
    }
    [DataTestMethod]
    [DataRow("Fcm", "ABCDE12345")]
    [DataRow("Apns", "OTHER12345")]
    public async Task FirebaseTransportOrTeamDriftCannotCreateAppleResources(string mode, string team)
    {
        using var f = new IosExecutorFixture(apns: true);
        var changed = f.Android.Firebase with { IosPushTransport = mode, IosDevelopmentTeam = team };
        f.Android.Secrets.Values[(f.Plan.TenantId, TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(changed);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Executor().ExecuteAsync(f.Plan, default));
        Assert.AreEqual(0, f.Apple.Server.Requests); Assert.AreEqual(0, f.Android.Server.Requests); Assert.AreEqual(0, f.Builder.Builds);
    }
    [TestMethod]
    public async Task QueueSdkDigestMatchesTheExactExportBytesAcrossPlatforms()
    {
        using var f = new IosExecutorFixture();
        var directory = Path.Combine(f.Android.Root, "sdk-export");
        await FirebaseClientFiles.ExportAsync(f.Android.Firebase, directory);
        var actual = Convert.ToHexString(SHA256.HashData(await File.ReadAllBytesAsync(Path.Combine(directory, "GoogleService-Info.plist")))).ToLowerInvariant();
        Assert.AreEqual(IosReleaseOptions.SdkHash(f.Android.Firebase), actual);
    }
}

internal sealed class IosParentFixture(ProvisioningJob job) : IProvisioningQueue
{
    public ProvisioningJob Job = job;
    public Task<ProvisioningJob?> GetAsync(string tenant, CancellationToken cancellationToken = default) => Task.FromResult<ProvisioningJob?>(Job.Request.TenantId == tenant ? Job : null);
    public Task<ProvisioningJob> EnqueueAsync(TenantProvisioningRequest request, CancellationToken cancellationToken = default) => throw new NotSupportedException();
    public Task<bool> RetryAsync(string tenant, CancellationToken cancellationToken = default) => throw new NotSupportedException();
}
internal sealed class IosBuilderFixture(string root, AndroidSecrets secrets) : IIosReleaseBuilder
{
    public int Builds, Verifications, SymbolUploads;
    public bool FailSymbolsOnce;
    public Task<string> SourceHashAsync(CancellationToken ct) => Task.FromResult(new string('b', 64));
    public async Task<IosBuiltArtifact> BuildAsync(IosReleasePlan plan, TenantProvisioningRequest request, TenantFirebaseConfiguration firebase, AppleSigningMaterial signing, CancellationToken ct)
    {
        Builds++;
        var attempt = Guid.NewGuid().ToString("N"); var bytes = System.Text.Encoding.UTF8.GetBytes("Synthetic interface-only IPA " + plan.TenantId);
        var artifact = new IosBuiltArtifact(attempt, plan, Convert.ToHexString(SHA256.HashData(bytes)).ToLowerInvariant(), new string('c', 64), new string('d', 64), new string('e', 64), signing.Application.Uuid, signing.Extension.Uuid);
        await File.WriteAllBytesAsync(BinaryPath(artifact), bytes, ct); return artifact;
    }
    public string BinaryPath(IosBuiltArtifact artifact) => Path.Combine(root, artifact.AttemptId + ".ipa");
    public async Task VerifyAsync(IosBuiltArtifact artifact, CancellationToken ct)
    {
        Verifications++;
        var hash = Convert.ToHexString(SHA256.HashData(await File.ReadAllBytesAsync(BinaryPath(artifact), ct))).ToLowerInvariant();
        if (hash != artifact.IpaSha256) throw new InvalidOperationException("Synthetic changed IPA.");
    }
    public Task UploadSymbolsAsync(IosBuiltArtifact artifact, CancellationToken ct)
    {
        Assert.IsTrue(secrets.Values.ContainsKey((artifact.Plan.TenantId, IosReleaseExecutor.ArtifactSecret)), "No upload precedes the committed artifact journal.");
        SymbolUploads++;
        if (FailSymbolsOnce) { FailSymbolsOnce = false; throw new InvalidOperationException("Synthetic symbol submission interrupted."); }
        return Task.CompletedTask;
    }
}
internal sealed class IosExecutorFixture : IDisposable
{
    public readonly AndroidFixture Android = new();
    public readonly AppleFixture Apple = new();
    public readonly IosReleaseOptions Options;
    public readonly IosReleasePlan Plan;
    public readonly IosParentFixture Parents;
    public readonly IosBuilderFixture Builder;
    private readonly GoogleCloudOptions google;
    public IosExecutorFixture(bool apns = false)
    {
        Android.Request = Android.Request with { MobileReleaseProfile = "AndroidIosAppDistribution" };
        google = apns ? new GoogleCloudOptions { AllowCloudWrites = true, DeploymentId = Android.Google.DeploymentId,
            ProjectIdPrefix = Android.Google.ProjectIdPrefix, Parent = Android.Google.Parent, SenderServiceAccount = Android.Google.SenderServiceAccount,
            IosPushTransport = "Apns", IosDevelopmentTeam = Apple.Plan.DevelopmentTeam } : Android.Google;
        if (apns)
        {
            Android.Firebase = Android.Firebase with { IosPushTransport = "Apns", IosDevelopmentTeam = Apple.Plan.DevelopmentTeam };
            Android.Secrets.Values[(Android.Request.TenantId, TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(Android.Firebase);
        }
        Plan = new(Android.Request.TenantId, Android.Google.DeploymentId, Android.Firebase.IosBundleId, Apple.Plan.DevelopmentTeam,
            Apple.Plan.SigningCertificateSha256, new string('b', 64), 7, Android.Firebase.ProjectId, Android.Firebase.ProjectNumber,
            Android.Firebase.IosAppId, IosReleaseOptions.SdkHash(Android.Firebase), Android.Deployment.StoreUrl(Android.Request.Slug))
            { IosPushTransport = apns ? "Apns" : null };
        Options = new() { DeploymentId = Plan.DeploymentId, DevelopmentTeam = Plan.DevelopmentTeam, SigningCertificateSha256 = Plan.SigningCertificateSha256, ExpectedSourceHash = Plan.SourceHash };
        Android.Server.BuildVersion = "7";
        Android.Completed["google-firebase"] = new("Google", new Dictionary<string, string> { ["projectId"] = Plan.ProjectId, ["androidAppId"] = Android.Firebase.AndroidAppId, ["iosAppId"] = Plan.IosAppId });
        Parents = new(new(Android.Request, "Pending", 0, Android.Completed, null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
        Builder = new(Android.Root, Android.Secrets);
    }
    public IosReleaseExecutor Executor(IIosReleaseBuilder? builder = null) => new(Options, google, Parents, Android.Secrets,
        new AppleTenantProvisioner(Apple.Options, Apple.Client(), Apple.Identity, Android.Secrets), builder ?? Builder,
        new FirebaseAppDistribution(new GoogleRestClient(new HttpClient(Android.Server, false), new AndroidToken()), google));
    public void Dispose() { Apple.Dispose(); Android.Dispose(); }
}
