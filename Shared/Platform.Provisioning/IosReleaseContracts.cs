using System.Text.RegularExpressions;

namespace Platform.Provisioning;

// Only immutable public build metadata crosses this queue. Keys and device UDIDs stay on the Mac.
public sealed record IosReleasePlan(string TenantId, string DeploymentId, string IosBundleId,
    string DevelopmentTeam, string SigningCertificateSha256, string SourceHash, int BuildNumber,
    string ProjectId, string ProjectNumber, string IosAppId, string FirebaseSdkSha256, string StoreUrl)
{
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public string? IosPushTransport { get; init; }
    [System.Text.Json.Serialization.JsonIgnore]
    public string PushTransport => IosPushTransport ?? "Fcm";
    internal static bool Digest(string? value) => Regex.IsMatch(value ?? "", "^[a-f0-9]{64}\\z");
    internal static void Tenant(string value)
    {
        if (!Guid.TryParseExact(value, "N", out var id) || id == Guid.Empty || id.ToString("N") != value)
            throw new ArgumentException("Use a canonical nonempty tenant ID.");
    }
    public void Validate()
    {
        if (IosPushTransport is not (null or "Fcm" or "Apns")) throw new ArgumentException("Invalid immutable iOS push transport.");
        Tenant(TenantId);
        new IosWorkerIdentity(DeploymentId, DevelopmentTeam, SigningCertificateSha256, SourceHash).Validate();
        if (IosBundleId.Length > 220 || !Regex.IsMatch(IosBundleId, "^[A-Za-z][A-Za-z0-9-]*(\\.[A-Za-z][A-Za-z0-9-]*)+\\z") ||
            BuildNumber is < 1 or > 2100000000 || !Digest(FirebaseSdkSha256) ||
            !Regex.IsMatch(ProjectId, "^[a-z][a-z0-9-]{4,28}[a-z0-9]\\z") || !Regex.IsMatch(ProjectNumber, "^[1-9][0-9]{0,19}\\z") ||
            !Regex.IsMatch(IosAppId, "^1:" + Regex.Escape(ProjectNumber) + ":ios:[A-Za-z0-9]+\\z"))
            throw new ArgumentException("Invalid immutable iOS build identity.");
        if (StoreUrl.Length > 2000 || !Uri.TryCreate(StoreUrl, UriKind.Absolute, out var url) ||
            url.Scheme != "https" || !url.IsDefaultPort || url.UserInfo.Length != 0 || url.Query.Length != 0 ||
            url.Fragment.Length != 0 || url.AbsolutePath != "/")
            throw new ArgumentException("Use the tenant's public HTTPS store origin.");
    }
}

public sealed record IosWorkerIdentity(string DeploymentId, string DevelopmentTeam,
    string SigningCertificateSha256, string SourceHash)
{
    public void Validate()
    {
        if (!Regex.IsMatch(DeploymentId, "^[A-Za-z0-9][A-Za-z0-9._-]{0,99}\\z") ||
            !Regex.IsMatch(DevelopmentTeam, "^[A-Z0-9]{10}\\z") ||
            !IosReleasePlan.Digest(SigningCertificateSha256) || !IosReleasePlan.Digest(SourceHash))
            throw new ArgumentException("Bind the Mac worker to a deployment, team, certificate and source fingerprint.");
    }
}

public sealed record IosReleaseReceipt(string IpaSha256, string SourceHash, string SigningCertificateSha256,
    string FirebaseSdkSha256, int BuildNumber, string ApplicationProfileUuid, string ExtensionProfileUuid,
    string ReleaseResource, bool SymbolsUploaded)
{
    public void Validate(IosReleasePlan plan)
    {
        plan.Validate();
        if (!IosReleasePlan.Digest(IpaSha256) || SourceHash != plan.SourceHash ||
            SigningCertificateSha256 != plan.SigningCertificateSha256 || FirebaseSdkSha256 != plan.FirebaseSdkSha256 ||
            BuildNumber != plan.BuildNumber || !SymbolsUploaded ||
            !Guid.TryParseExact(ApplicationProfileUuid, "D", out var app) || app == Guid.Empty ||
            !Guid.TryParseExact(ExtensionProfileUuid, "D", out var extension) || extension == Guid.Empty || app == extension ||
            !Regex.IsMatch(ReleaseResource, "^projects/" + Regex.Escape(plan.ProjectNumber) + "/apps/" + Regex.Escape(plan.IosAppId) + "/releases/[A-Za-z0-9_-]+\\z"))
            throw new ArgumentException("The iOS receipt does not match its original release plan.");
    }
}

public sealed record IosReleaseJob(IosReleasePlan Plan, string State, int Attempts, IosReleaseReceipt? Receipt,
    string? ErrorCode, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt);
public sealed record IosReleaseLease(IosReleaseJob Job, Guid Token);

public sealed record IosReleaseStatus(string State, int Attempts, string? ErrorCode);
public interface IIosReleaseQueue
{
    Task<IosReleaseJob> EnqueueAsync(IosReleasePlan plan, CancellationToken ct = default);
    Task<IosReleaseJob?> GetAsync(string tenant, CancellationToken ct = default);
    Task<bool> RetryAsync(string tenant, CancellationToken ct = default);
}
