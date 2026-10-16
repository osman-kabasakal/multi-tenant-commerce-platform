using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

/// <summary>Use one durable native artifact for symbols and App Distribution, including after Mac restart.</summary>
public sealed class IosReleaseExecutor(IosReleaseOptions options, GoogleCloudOptions google, IProvisioningQueue parents,
    ITenantSecrets secrets, AppleTenantProvisioner apple, IIosReleaseBuilder builder, FirebaseAppDistribution distribution) : IIosReleaseExecutor
{
    public const string ArtifactSecret = "ios-initial-release-artifact-v1";
    public const string SymbolsSecret = "ios-initial-release-symbols-v1";
    public const string DistributionSecret = "ios-initial-release-distribution-v1";
    private sealed record Submission(string IpaSha256, string NativeResultSha256, string Target, string Value);
    private async Task<string?> FindAsync(string tenant, string name, CancellationToken ct)
    { try { return await secrets.GetAsync(tenant, name, ct); } catch (KeyNotFoundException) { return null; } }
    private static void Match(IosBuiltArtifact artifact, IosReleasePlan plan)
    {
        if (artifact.Plan != plan || !Guid.TryParseExact(artifact.AttemptId, "N", out var attempt) || attempt == Guid.Empty ||
            !MobileReleaseFiles.Digest(artifact.IpaSha256) || !MobileReleaseFiles.Digest(artifact.NativeResultSha256))
            throw new InvalidOperationException("The saved native artifact belongs to another iOS plan.");
        if (!Guid.TryParseExact(artifact.ApplicationProfileUuid, "D", out var app) || app == Guid.Empty ||
            !Guid.TryParseExact(artifact.ExtensionProfileUuid, "D", out var extension) || extension == Guid.Empty || app == extension)
            throw new InvalidOperationException("The saved native profiles are invalid.");
    }
    private static string Target(IosReleasePlan plan) => $"projects/{plan.ProjectNumber}/apps/{plan.IosAppId}";
    private static Submission Expected(IosBuiltArtifact artifact, string value) => new(artifact.IpaSha256, artifact.NativeResultSha256, Target(artifact.Plan), value);
    private static Submission ReadSubmission(string value, IosBuiltArtifact artifact)
    {
        var receipt = MobileReleaseFiles.Parse<Submission>(value);
        if (receipt != Expected(artifact, receipt.Value)) throw new InvalidOperationException("The iOS submission receipt belongs to another immutable artifact or Firebase app.");
        return receipt;
    }
    public async Task<IosReleaseReceipt> ExecuteAsync(IosReleasePlan plan, CancellationToken ct)
    {
        plan.Validate();
        if (new IosWorkerIdentity(plan.DeploymentId, plan.DevelopmentTeam, plan.SigningCertificateSha256, plan.SourceHash) != options.Identity ||
            google.DeploymentId != plan.DeploymentId || await builder.SourceHashAsync(ct) != plan.SourceHash)
            throw new InvalidOperationException("The queued iOS plan targets a different Mac source or deployment.");
        var parent = await parents.GetAsync(plan.TenantId, ct) ?? throw new InvalidOperationException("The iOS job has no tenant onboarding parent.");
        var request = parent.Request; request.Validate();
        if (request.MobileReleaseProfile != "AndroidIosAppDistribution" || request.TenantId != plan.TenantId || request.DeploymentId != plan.DeploymentId || parent.State is not ("Pending" or "Running") ||
            (request.IosBundleId ?? "com.example.tenant" + request.TenantId) != plan.IosBundleId ||
            !parent.Steps.TryGetValue("publication", out var published) || published.Resources.GetValueOrDefault("readiness") != "Verified" ||
            published.Resources.GetValueOrDefault("storeUrl") != plan.StoreUrl || !parent.Steps.TryGetValue("google-firebase", out var cloud))
            throw new InvalidOperationException("The iOS job requires its owned, verified public tenant and Google checkpoints.");
        var firebase = MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetAsync(plan.TenantId, TenantFirebaseConfiguration.SecretName, ct));
        FirebaseConfigValidator.Validate(firebase);
        if (firebase.TenantId != plan.TenantId || firebase.ProjectId != google.ProjectId(plan.TenantId) || firebase.ProjectId != plan.ProjectId ||
            firebase.ProjectNumber != plan.ProjectNumber || firebase.IosAppId != plan.IosAppId || firebase.IosBundleId != plan.IosBundleId ||
            firebase.IosPushTransport != plan.PushTransport || firebase.IosPushTransport == "Apns" && firebase.IosDevelopmentTeam != plan.DevelopmentTeam ||
            firebase.AndroidPackageName != (request.AndroidPackageName ?? "com.example.tenant" + plan.TenantId) ||
            firebase.DistributionGroupAlias != google.DistributionGroupAlias || IosReleaseOptions.SdkHash(firebase) != plan.FirebaseSdkSha256 ||
            cloud.Resources.GetValueOrDefault("projectId") != plan.ProjectId || cloud.Resources.GetValueOrDefault("iosAppId") != plan.IosAppId)
            throw new InvalidOperationException("The authoritative Firebase SDK or target differs from the immutable iOS plan.");
        // Check remote ownership before Apple provisioning or Crashlytics submission, not only at IPA upload.
        await distribution.VerifyTargetAsync(firebase, "ios", ct);
        var saved = await FindAsync(plan.TenantId, ArtifactSecret, ct);
        if (saved == null)
        {
            var signing = await apple.PrepareAsync(plan, ct);
            var candidate = await builder.BuildAsync(plan, request, firebase, signing, ct);
            Match(candidate, plan); await builder.VerifyAsync(candidate, ct); ct.ThrowIfCancellationRequested();
            saved = await secrets.GetOrCreateAsync(plan.TenantId, ArtifactSecret, () => JsonSerializer.Serialize(candidate, MobileReleaseFiles.Json), ct);
            // An interrupted/reclaimed build may leave an unselected private workspace; never replace the committed winner.
        }
        var artifact = MobileReleaseFiles.Parse<IosBuiltArtifact>(saved); Match(artifact, plan);
        await builder.VerifyAsync(artifact, ct);
        var symbols = await FindAsync(plan.TenantId, SymbolsSecret, ct);
        if (symbols == null)
        {
            await builder.UploadSymbolsAsync(artifact, ct); ct.ThrowIfCancellationRequested();
            symbols = await secrets.GetOrCreateAsync(plan.TenantId, SymbolsSecret,
                () => JsonSerializer.Serialize(Expected(artifact, "uploaded"), MobileReleaseFiles.Json), ct);
        }
        if (ReadSubmission(symbols, artifact).Value != "uploaded") throw new InvalidOperationException("The selected IPA has no completed matching symbol submission.");
        var previous = await FindAsync(plan.TenantId, DistributionSecret, ct);
        string release;
        if (previous != null)
        {
            release = ReadSubmission(previous, artifact).Value;
        }
        else
        {
            var binary = builder.BinaryPath(artifact);
            if (await MobileReleaseFiles.HashAsync(binary, ct) != artifact.IpaSha256) throw new InvalidOperationException("The IPA changed before App Distribution upload.");
            ct.ThrowIfCancellationRequested();
            release = await distribution.UploadAndDistributeAsync(firebase, "ios", binary, ct); ct.ThrowIfCancellationRequested();
            var stored = await secrets.GetOrCreateAsync(plan.TenantId, DistributionSecret,
                () => JsonSerializer.Serialize(Expected(artifact, release), MobileReleaseFiles.Json), ct);
            if (ReadSubmission(stored, artifact).Value != release) throw new InvalidOperationException("The initial iOS release acquired another distribution identity.");
        }
        // Retain a successful distribution receipt even if this final read temporarily fails.
        await distribution.VerifyReleaseAsync(firebase, "ios", release, plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture), ct);
        var receipt = new IosReleaseReceipt(artifact.IpaSha256, plan.SourceHash, plan.SigningCertificateSha256, plan.FirebaseSdkSha256, plan.BuildNumber,
            artifact.ApplicationProfileUuid, artifact.ExtensionProfileUuid, release, true);
        receipt.Validate(plan); return receipt;
    }
}
