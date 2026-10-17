using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Text.Json;
using System.Text.Json.Nodes;
using Platform.Provisioning;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.Stores.Provisioning;

/// <summary>Version 1 allocation policy. Persist the result; never recompute an existing application's identity.</summary>
public static class TenantMobileApplicationId
{
    public const int PolicyVersion = 1;
    private const int MaximumLength = 200;
    private static readonly HashSet<string> Reserved = new(StringComparer.Ordinal)
    {
        "abstract", "assert", "boolean", "break", "byte", "case", "catch", "char", "class", "const", "continue",
        "default", "do", "double", "else", "enum", "extends", "final", "finally", "float", "for", "goto", "if",
        "implements", "import", "instanceof", "int", "interface", "long", "native", "new", "package", "private",
        "protected", "public", "return", "short", "static", "strictfp", "super", "switch", "synchronized", "this",
        "throw", "throws", "transient", "try", "void", "volatile", "while", "true", "false", "null", "_"
    };

    public static string Prefix(IConfiguration config)
    {
        var prefix = config["TenantOnboarding:MobileApplicationIdPrefix"] ?? "";
        if (prefix.Length > 150 || !Regex.IsMatch(prefix, "^[a-z][a-z0-9]*(\\.[a-z][a-z0-9]*)+\\z") ||
            prefix.Split('.').Any(Reserved.Contains) || prefix == "com.example" || prefix.StartsWith("com.example.", StringComparison.Ordinal))
            throw new InvalidOperationException("Configure a reverse-DNS MobileApplicationIdPrefix for new tenant applications.");
        return prefix;
    }

    public static string ForBusiness(IConfiguration config, string businessName, Guid businessId, bool disambiguate = false, string? verifiedStoreHost = null)
    {
        if (businessId == Guid.Empty) throw new ArgumentException("A real business identity is required.");
        if (string.IsNullOrWhiteSpace(businessName) || businessName.Length > 300) throw new ArgumentException("Use a bounded business name.");
        var prefix = verifiedStoreHost == null ? Prefix(config) : DomainPrefix(verifiedStoreHost);
        var normalized = businessName.Trim().Replace('ı','i').Normalize(NormalizationForm.FormD).ToLowerInvariant();
        var label = new StringBuilder();
        foreach (var rune in normalized.EnumerateRunes())
        {
            if (Rune.GetUnicodeCategory(rune) == UnicodeCategory.NonSpacingMark) continue;
            if (rune.IsAscii && (char.IsAsciiLetterOrDigit((char)rune.Value))) label.Append((char)rune.Value);
            else if (!Rune.IsWhiteSpace(rune) && rune.Value is not ('-' or '_' or '.' or '\'' or '’'))
                label.Append('u').Append(rune.Value.ToString("x", CultureInfo.InvariantCulture));
        }
        var result = label.Length == 0 ? "business" : label.ToString();
        if (!char.IsAsciiLetter(result[0]) || Reserved.Contains(result)) result = "app" + result;
        var limit = MaximumLength - prefix.Length - 1;
        var suffix = disambiguate ? "x" + businessId.ToString("N") : "";
        if (result.Length > limit && !disambiguate)
            suffix = "x" + Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(businessName.Normalize(NormalizationForm.FormC)))).ToLowerInvariant()[..16];
        result = result[..Math.Min(result.Length, limit - suffix.Length)] + suffix;
        return prefix + "." + result;
    }

    public static string DomainPrefix(string verifiedHost)
    {
        var host = TenantDomainNames.Normalize(verifiedHost);
        var labels = host.Split('.').Reverse().Select(label => {
            var value = label;
            if (label.Contains('-')) value = label.Replace("-", "", StringComparison.Ordinal) + "x" + Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(label))).ToLowerInvariant()[..16];
            if (!char.IsAsciiLetter(value[0]) || Reserved.Contains(value)) value = "domain" + value;
            return value;
        });
        var segments = labels.ToArray();
        var prefix = string.Join('.', segments);
        if (prefix.Length > 150) prefix = segments[0] + ".domain" + Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(host))).ToLowerInvariant();
        return prefix;
    }

    /// <summary>The unique database index is the final arbiter, including simultaneous registrations in different replicas.</summary>
    public static async Task<BusinessApp> AddInitialAsync(IApplicationDbContext db, IConfiguration config,
        Guid businessId, string businessName, string appName, CancellationToken ct, TenantDomainBinding? domain = null,MobileIdentityRegistry? identities=null)
    {
        var candidate = ForBusiness(config, businessName, businessId, verifiedStoreHost: domain?.Request.StoreHost);
        var collision = await db.BusinessApps.AsNoTracking().AnyAsync(x => x.PackageName == candidate, ct);
        if(!collision && identities!=null)collision=!await identities.TryReservePackageAsync(candidate,businessId.ToString("N"),ct);
        BusinessApp New(bool alternative)
        {
            var value = new BusinessApp(businessId, AppType.CustomerMobile, appName, ForBusiness(config, businessName, businessId, alternative, domain?.Request.StoreHost));
            var settings = JsonNode.Parse(value.BuildConfiguration.RootElement.GetRawText())!.AsObject();
            settings["mobileIdentityPolicy"] = JsonSerializer.SerializeToNode(new { version = PolicyVersion, businessName,
                domainRequestId = domain?.Request.Id, sourceDomain = domain?.Request.StoreHost });
            value.SetBuildConfiguration(JsonDocument.Parse(settings.ToJsonString()));return value;
        }
        var app = New(collision);
        if(identities!=null && !await identities.TryReservePackageAsync(app.PackageName,businessId.ToString("N"),ct))throw new ProvisioningConflictException();
        db.BusinessApps.Add(app);
        try { await db.SaveChangesAsync(ct); }
        catch (DbUpdateException)
        {
            if (collision || !await db.BusinessApps.AsNoTracking().AnyAsync(
                x => x.PackageName == candidate && x.BusinessId != businessId, ct)) throw;
            // A failed SaveChanges rolls back the company/subscription/app transaction. Removing this Added entity detaches it.
            db.BusinessApps.Remove(app); app = New(true);
            if(identities!=null && !await identities.TryReservePackageAsync(app.PackageName,businessId.ToString("N"),ct))throw new ProvisioningConflictException();
            db.BusinessApps.Add(app);
            await db.SaveChangesAsync(ct);
        }
        return app;
    }
}
