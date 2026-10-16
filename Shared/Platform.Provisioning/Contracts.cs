using System.Text.Json;
using System.Text.RegularExpressions;

namespace Platform.Provisioning;

// Only public setup metadata crosses the durable queue. Credentials live in ITenantSecrets.
public sealed record TenantProvisioningRequest(
    string TenantId, string Slug, string StoreName, string OwnerEmail,
    string FirstName, string LastName, string CompanyAddress, string CompanyPhone,
    string CompanyEmail, string? AndroidPackageName = null, string? IosBundleId = null, string? DeploymentId = null, string? MobileReleaseProfile = null)
{
    public void Validate()
    {
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
        if (MobileReleaseProfile is not (null or "Disabled" or "AndroidAppDistribution"))
            throw new ArgumentException("Choose an explicit supported mobile release profile.");
        foreach (var package in new[] { AndroidPackageName, IosBundleId }.Where(p => p != null))
            if (!Regex.IsMatch(package!, "^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+$"))
                throw new ArgumentException("Invalid mobile package identifier.");
    }
}

public sealed record ProvisioningStepResult(string Provider, IReadOnlyDictionary<string, string> Resources);
public sealed record ProvisioningJob(TenantProvisioningRequest Request, string State, int Attempts,
    IReadOnlyDictionary<string, ProvisioningStepResult> Steps, string? ErrorCode,
    DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt);
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
