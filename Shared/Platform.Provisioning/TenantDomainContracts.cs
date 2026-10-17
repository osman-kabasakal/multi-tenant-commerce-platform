using System.Globalization;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace Platform.Provisioning;

public static class TenantDomainNames
{
    public static string Normalize(string value)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Length > 250 || value != value.Trim() || value.Any(char.IsControl) ||
            value.IndexOfAny(['/', ':', '*', '@', '\\', '?', '#']) >= 0) throw new ArgumentException("Enter a domain name without a URL, port or wildcard.");
        var host = new IdnMapping { UseStd3AsciiRules = true }.GetAscii(value).ToLowerInvariant();
        var labels = host.Split('.');
        if (host.Length > 190 || labels.Length < 2 || labels.Any(x => !Regex.IsMatch(x, "^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\z")) ||
            labels[^1].All(char.IsAsciiDigit) || labels[^1] is "localhost" or "local" or "test" or "invalid" or "internal" or "example" ||
            System.Net.IPAddress.TryParse(host, out _)) throw new ArgumentException("Enter a public DNS hostname.");
        return host;
    }
    public static bool Within(string host, string zone) => host == zone || host.EndsWith("." + zone, StringComparison.Ordinal);
    public static string ChallengeName(string storeHost) => "_commerce-verification." + Normalize(storeHost);
    public static string Challenge(Guid id) => "commerce-v1=" + id.ToString("N") + "." + Convert.ToHexString(RandomNumberGenerator.GetBytes(32)).ToLowerInvariant();
}

// The owner is supplied by the authenticated server, never by a request body.
public sealed record TenantDomainRequest(Guid Id, string TenantId, Guid OwnerSubject, string DeploymentId, string StoreHost, string AdminHost)
{
    public void Validate()
    {
        IosReleasePlan.Tenant(TenantId);
        if (Id == Guid.Empty || OwnerSubject == Guid.Empty || !Regex.IsMatch(DeploymentId, "^[a-z][a-z0-9-]{2,39}\\z") ||
            TenantDomainNames.Normalize(StoreHost) != StoreHost || TenantDomainNames.Normalize(AdminHost) != AdminHost ||
            StoreHost == AdminHost || AdminHost != "manage." + StoreHost)
            throw new ArgumentException("Use a stable owned domain request and its separate management hostname.");
    }
}

public sealed record TenantDomainBinding(TenantDomainRequest Request, string State, string Challenge, DateTimeOffset ExpiresAt,
    string? ZoneId, string? ZoneName, string? ErrorCode, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt)
{
    public int Attempts { get; init; }
    public bool VerificationRequested { get; init; }
    public bool IsPrimary { get; init; }
}
public sealed record TenantDomainLease(TenantDomainBinding Binding, Guid Token);
public sealed record TenantDomainAccess(string ZoneId, string ZoneName);
public sealed class TenantDomainException(string code) : Exception("The custom domain cannot be assigned to this business.")
{
    public string Code { get; } = Regex.IsMatch(code, "^[A-Za-z0-9_.:-]{1,100}\\z") ? code : throw new ArgumentException("Invalid public domain error code.");
}
public interface ITenantDomainOwnership
{
    Task<TenantDomainAccess> CheckAsync(TenantDomainBinding binding, bool requireProof, CancellationToken ct);
}

// Snapshot from an owner-verified registry row, frozen with the original onboarding request.
public sealed record TenantDomainSelection(Guid Id,Guid OwnerSubject,string StoreHost,string AdminHost,string ZoneId,string ZoneName)
{
    public static TenantDomainSelection From(TenantDomainBinding binding) => new(binding.Request.Id,binding.Request.OwnerSubject,
        binding.Request.StoreHost,binding.Request.AdminHost,binding.ZoneId ?? throw new InvalidOperationException(),binding.ZoneName ?? throw new InvalidOperationException());
    public void Validate()
    {
        if(Id==Guid.Empty || OwnerSubject==Guid.Empty || TenantDomainNames.Normalize(StoreHost)!=StoreHost ||
            TenantDomainNames.Normalize(AdminHost)!=AdminHost || AdminHost!="manage."+StoreHost ||
            !Regex.IsMatch(ZoneId,"^[a-f0-9]{32}\\z") || TenantDomainNames.Normalize(ZoneName)!=ZoneName ||
            !TenantDomainNames.Within(StoreHost,ZoneName) || !TenantDomainNames.Within(AdminHost,ZoneName)) throw new ArgumentException("Invalid verified domain snapshot.");
    }
}
