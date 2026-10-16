using System.Globalization;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;

namespace Platform.Provisioning.Adapters;

public sealed record AppleAccessCheck(string Resource, string Status, int? HttpStatus = null, int? Count = null,
    int? ValidDistributionCertificates = null, int? MatchingTeamDistributionCertificates = null,
    int? EnabledIosDevices = null, int? ActiveAdHocProfiles = null, string? ErrorCode = null);
public sealed record AppleAccessReport(DateTimeOffset CheckedAtUtc, IReadOnlyList<AppleAccessCheck> Checks)
{
    public bool ReadAccessVerified => Checks.Count == 4 && Checks.All(x => x.Status == "passed");
    public bool AppleWritesPerformed => false;
    public bool LocalSigningIdentityChecked => false;
    public bool SignedIpaBuilt => false;
    public bool ReadyForSignedRelease => false;
}

/// <summary>GET-only portal diagnostics. This does not prove signing, write permissions or release delivery.</summary>
public sealed class AppleAccessVerifier(AppleApiOptions options, AppleApiClient api)
{
    private static readonly (string Name, string Fields)[] Resources = [
        ("bundleIds", "identifier,platform"),
        ("certificates", "certificateType,expirationDate,certificateContent"),
        ("devices", "platform,status"),
        ("profiles", "profileType,profileState,expirationDate")
    ];
    private static JsonObject Attributes(JsonObject value, string kind)
    {
        if (AppleApiClient.Text(value, "type") != kind || value["attributes"] is not JsonObject attributes)
            throw new InvalidOperationException("Invalid Apple resource shape.");
        return attributes;
    }
    private static bool Future(JsonObject value) => DateTimeOffset.TryParse(AppleApiClient.Text(value, "expirationDate"),
        CultureInfo.InvariantCulture, DateTimeStyles.None, out var expiry) && expiry > DateTimeOffset.UtcNow;
    public async Task<AppleAccessReport> CheckAsync(CancellationToken ct = default)
    {
        options.Validate();
        var checks = new List<AppleAccessCheck>();
        foreach (var resource in Resources)
        {
            try
            {
                var query = new List<(string, string)> { ("limit", "200"), ($"fields[{resource.Name}]", resource.Fields) };
                if (resource.Name == "devices") query.Add(("filter[platform]", "IOS"));
                var items = await api.ListAsync(AppleApiClient.Query("v1/" + resource.Name, query.ToArray()), ct);
                var attributes = items.Select(x => Attributes(x, resource.Name)).ToArray();
                var check = new AppleAccessCheck(resource.Name, "passed", HttpStatus: 200, Count: items.Count);
                if (resource.Name == "certificates")
                {
                    var valid = 0; var matching = 0;
                    foreach (var value in attributes)
                    {
                        if (AppleApiClient.Text(value, "certificateType") is not ("DISTRIBUTION" or "IOS_DISTRIBUTION") || !Future(value)) continue;
                        var raw = Convert.FromBase64String(AppleApiClient.Text(value, "certificateContent"));
                        if (raw.Length is < 1 or > 65536) throw new InvalidOperationException("Invalid certificate bounds.");
                        using var certificate = new X509Certificate2(raw);
                        if (certificate.NotBefore.ToUniversalTime() > DateTime.UtcNow || certificate.NotAfter.ToUniversalTime() <= DateTime.UtcNow) continue;
                        valid++;
                        var subject = certificate.SubjectName.Decode(X500DistinguishedNameFlags.UseNewLines | X500DistinguishedNameFlags.DoNotUseQuotes);
                        if (Regex.IsMatch(subject, "(?:^|\\n)OU=" + options.DevelopmentTeam + "(?:\\r?\\n|\\z)")) matching++;
                    }
                    check = check with { ValidDistributionCertificates = valid, MatchingTeamDistributionCertificates = matching };
                }
                if (resource.Name == "devices") check = check with { EnabledIosDevices = attributes.Count(x =>
                    AppleApiClient.Text(x, "platform") == "IOS" && AppleApiClient.Text(x, "status") == "ENABLED") };
                if (resource.Name == "profiles") check = check with { ActiveAdHocProfiles = attributes.Count(x =>
                    AppleApiClient.Text(x, "profileType") == "IOS_APP_ADHOC" && AppleApiClient.Text(x, "profileState") == "ACTIVE" && Future(x)) };
                checks.Add(check);
            }
            catch (AppleApiException error) { checks.Add(new(resource.Name, "failed", HttpStatus: (int)error.Status, ErrorCode: error.Code)); }
            catch (AppleApiUnavailableException) { checks.Add(new(resource.Name, "unavailable", ErrorCode: "TRANSPORT_UNAVAILABLE")); }
            catch (Exception error) when (error is InvalidOperationException or JsonException or CryptographicException or FormatException)
            { checks.Add(new(resource.Name, "unavailable", ErrorCode: "INVALID_RESPONSE")); }
        }
        return new(DateTimeOffset.UtcNow, checks);
    }
}
