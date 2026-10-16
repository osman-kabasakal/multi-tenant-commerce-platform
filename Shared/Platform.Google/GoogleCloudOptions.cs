using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace Platform.Google;

public sealed class GoogleCloudOptions
{
    public bool AllowCloudWrites { get; init; }
    public string Parent { get; init; } = "";
    public string DeploymentId { get; init; } = "";
    public string ProjectIdPrefix { get; init; } = "";
    public string? BillingAccount { get; init; }
    public string SenderServiceAccount { get; init; } = "";
    public string DistributionGroupAlias { get; init; } = "tenant-testers";
    public string[] TesterEmails { get; init; } = [];
    public bool IncludeOwnerAsTester { get; init; }
    public string IosPushTransport { get; init; } = "Fcm";
    public string? IosDevelopmentTeam { get; init; }
    public int PollIntervalSeconds { get; init; } = 3;
    public int OperationTimeoutSeconds { get; init; } = 600;

    public void Validate()
    {
        if (IosPushTransport is not ("Fcm" or "Apns") || IosPushTransport == "Apns" &&
            (IosDevelopmentTeam == null || !Regex.IsMatch(IosDevelopmentTeam, "^[A-Z0-9]{10}\\z")))
            throw new InvalidOperationException("Select the iOS push transport and an explicit Apple team for APNs.");
        if (!AllowCloudWrites) throw new InvalidOperationException("Google provisioning requires explicit AllowCloudWrites.");
        if (!Regex.IsMatch(Parent, "^(folders|organizations)/[1-9][0-9]*$"))
            throw new InvalidOperationException("Configure the Google resource parent explicitly.");
        if (!Regex.IsMatch(DeploymentId, "^[a-z][a-z0-9-]{2,62}$") ||
            !Regex.IsMatch(ProjectIdPrefix, "^[a-z][a-z0-9-]{1,8}[a-z0-9]$"))
            throw new InvalidOperationException("Configure a stable deployment label and a 3-10 character project prefix.");
        if (!string.IsNullOrEmpty(BillingAccount) && !Regex.IsMatch(BillingAccount, "^billingAccounts/[A-Fa-f0-9]{6}-[A-Fa-f0-9]{6}-[A-Fa-f0-9]{6}$"))
            throw new InvalidOperationException("Invalid explicit Google billing account.");
        if (!Regex.IsMatch(SenderServiceAccount, "^[a-z][a-z0-9-]{4,28}[a-z0-9]@[a-z][a-z0-9-]{4,28}[a-z0-9]\\.iam\\.gserviceaccount\\.com$"))
            throw new InvalidOperationException("Configure the central FCM sender service account.");
        if (!Regex.IsMatch(DistributionGroupAlias, "^[a-z-]{4,63}$") || TesterEmails.Length > 998 ||
            TesterEmails.Any(e => !MailAddress.TryCreate(e, out var address) || address.Address != e))
            throw new InvalidOperationException("Invalid App Distribution group or tester configuration.");
        if (PollIntervalSeconds is < 1 or > 30 || OperationTimeoutSeconds is < 30 or > 1800)
            throw new InvalidOperationException("Google operation timing is outside supported limits.");
    }

    public string ProjectId(string tenantId)
    {
        if (!Guid.TryParseExact(tenantId, "N", out var tenant) || tenant == Guid.Empty || tenantId != tenant.ToString("N"))
            throw new ArgumentException("Use a canonical tenant ID.");
        var suffix = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(DeploymentId + ":" + tenantId)))[..18].ToLowerInvariant();
        return ProjectIdPrefix + "-" + suffix;
    }
}

public sealed record GoogleTenantSpec(string TenantId, string DisplayName, string OwnerEmail, string AndroidPackageName, string IosBundleId);

// Client SDK configuration is public. Server identities stay in the encrypted tenant store.
public sealed record TenantFirebaseConfiguration(string TenantId, string ProjectId, string ProjectNumber,
    string SenderServiceAccount, string AndroidAppId, string IosAppId, string AndroidPackageName,
    string IosBundleId, string AndroidConfigJson, string IosConfigPlist, string DistributionGroupAlias)
{
    public const string SecretName = "firebase-configuration";
    public string IosPushTransport { get; init; } = "Fcm";
    public string? IosDevelopmentTeam { get; init; }
}
