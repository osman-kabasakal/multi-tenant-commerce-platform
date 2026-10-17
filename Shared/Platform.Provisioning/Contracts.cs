using System.Text.Json;
using System.Text.RegularExpressions;

namespace Platform.Provisioning;

// Only public setup metadata crosses the durable queue. Credentials live in ITenantSecrets.
public sealed record TenantProvisioningRequest(
    string TenantId, string Slug, string StoreName, string OwnerEmail,
    string FirstName, string LastName, string CompanyAddress, string CompanyPhone,
    string CompanyEmail, string? AndroidPackageName = null, string? IosBundleId = null, string? DeploymentId = null, string? MobileReleaseProfile = null)
{
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public TenantDomainSelection? Domain { get; init; }
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public MobileBranding? Branding { get; init; }
    public void Validate()
    {
        Domain?.Validate();Branding?.Validate();
        if (!Guid.TryParseExact(TenantId, "N", out var id) || id == Guid.Empty || id.ToString("N") != TenantId)
            throw new ArgumentException("TenantId must be a nonempty canonical business ID.");
        if (!Regex.IsMatch(Slug, "^[a-z][a-z0-9-]{1,38}[a-z0-9]$"))
            throw new ArgumentException("Use a lowercase DNS label of 3-40 characters for the tenant slug.");
        if (Slug is "www" or "admin" or "api" or "auth" or "mail" or "saas")
            throw new ArgumentException("This tenant slug is reserved.");
        if (string.IsNullOrWhiteSpace(StoreName) || StoreName.Length > 200 ||
            !System.Net.Mail.MailAddress.TryCreate(OwnerEmail, out var email) || email.Address != OwnerEmail)
            throw new ArgumentException("A store name and valid owner email are required.");
        if (DeploymentId != null && !Regex.IsMatch(DeploymentId, "^[a-zA-Z0-9][a-zA-Z0-9._-]{0,99}$"))
            throw new ArgumentException("Invalid provisioning deployment id.");
        if (MobileReleaseProfile is not (null or "Disabled" or "AndroidAppDistribution" or "AndroidIosAppDistribution"))
            throw new ArgumentException("Choose an explicit supported mobile release profile.");
        if (MobileReleaseProfile == "AndroidIosAppDistribution" &&
            (DeploymentId == null || !Regex.IsMatch(DeploymentId, "^[A-Za-z0-9][A-Za-z0-9._-]{0,99}\\z") ||
             IosBundleId != null && (IosBundleId.Length > 220 || !Regex.IsMatch(IosBundleId, "^[A-Za-z][A-Za-z0-9-]*(\\.[A-Za-z][A-Za-z0-9-]*)+\\z"))))
            throw new ArgumentException("Combined mobile releases require an explicit deployment and Apple-compatible bundle identity.");
        var packages = MobileReleaseProfile == "AndroidIosAppDistribution" ? new[] { AndroidPackageName } : new[] { AndroidPackageName, IosBundleId };
        foreach (var package in packages.Where(p => p != null))
            if (!Regex.IsMatch(package!, "^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+$"))
                throw new ArgumentException("Invalid mobile package identifier.");
    }
}

public sealed record ProvisioningStepResult(string Provider, IReadOnlyDictionary<string, string> Resources);
public sealed record ProvisioningJob(TenantProvisioningRequest Request, string State, int Attempts,
    IReadOnlyDictionary<string, ProvisioningStepResult> Steps, string? ErrorCode,
    DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt)
{
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public IosReleaseStatus? IosRelease { get; init; }
}
public sealed record ProvisioningLease(ProvisioningJob Job, Guid Token);

public interface IProvisioningQueue
{
    Task<ProvisioningJob> EnqueueAsync(TenantProvisioningRequest request, CancellationToken cancellationToken = default);
    Task<ProvisioningJob?> GetAsync(string tenantId, CancellationToken cancellationToken = default);
    Task<bool> RetryAsync(string tenantId, CancellationToken cancellationToken = default);
}

public interface IProvisioningStep
{
    string Name { get; }
    Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,
        IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken cancellationToken);
}

public sealed class ProvisioningLeaseLostException() : Exception("The provisioning lease is no longer owned by this worker.");
public sealed class ProvisioningConflictException() : Exception("A different provisioning request already owns this business or tenant slug.");

/// <summary>Validates immutable deployment ownership before any step, including checkpoint-only replays.</summary>
public interface IProvisioningGuard
{
    Task ValidateAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken cancellationToken);
}

/// <summary>A durable dependency wait; release the worker without consuming a failed attempt.</summary>
public sealed class ProvisioningDeferredException : Exception
{
    public string ReasonCode { get; }
    public TimeSpan RetryAfter { get; }
    public ProvisioningDeferredException(string reasonCode, TimeSpan retryAfter) : base("A required provisioning dependency is still pending.")
    {
        if (!Regex.IsMatch(reasonCode, "^[A-Za-z0-9_.:-]{1,160}\\z") || retryAfter < TimeSpan.FromSeconds(10) || retryAfter > TimeSpan.FromMinutes(5))
            throw new ArgumentException("Use a bounded dependency-wait interval and safe public reason code.");
        ReasonCode = reasonCode; RetryAfter = retryAfter;
    }
}
