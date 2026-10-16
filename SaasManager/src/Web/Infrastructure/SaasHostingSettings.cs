using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SaasManager.Web.Infrastructure;

public static class SaasHostingSettings
{
    public static string[] AllowedOrigins(IConfiguration config, bool development)
    {
        var origins = config.GetSection("Web:AllowedOrigins").Get<string[]>();
        if (origins is not { Length: > 0 })
            origins = !string.IsNullOrWhiteSpace(config["ApplicationUrl"])
                ? [config["ApplicationUrl"]!] : development ? ["https://localhost:5001", "https://localhost:44447"] : [];
        if (origins.Length == 0) throw new InvalidOperationException("Configure ApplicationUrl or Web:AllowedOrigins for SaaS.");
        foreach (var origin in origins)
            if (!Uri.TryCreate(origin, UriKind.Absolute, out var uri) || uri.Scheme is not ("https" or "http") ||
                (!development && uri.Scheme != "https") || string.IsNullOrWhiteSpace(uri.Host) || uri.Host.Contains('*') ||
                !string.IsNullOrEmpty(uri.UserInfo) || uri.AbsolutePath != "/" || !string.IsNullOrEmpty(uri.Query) || !string.IsNullOrEmpty(uri.Fragment) ||
                origin.EndsWith('/') || uri.Host is "0.0.0.0" or "::" or "[::]")
                throw new InvalidOperationException("SaaS allowed origins must be exact origins, HTTPS outside Development, without paths or trailing slashes.");
        return origins.Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
    }

    public static void AddPersistentCookies(IServiceCollection services, IConfiguration config, string contentRoot)
    {
        var directory = config["Web:DataProtectionKeyDirectory"];
        if (string.IsNullOrWhiteSpace(directory)) return; // Preserve existing deployments unless explicitly configured.
        var name = config["Web:DataProtectionApplicationName"];
        if (!Path.IsPathFullyQualified(directory) || string.IsNullOrWhiteSpace(name))
            throw new InvalidOperationException("Configure an absolute private cookie key directory and a stable application name.");
        var path = Path.GetFullPath(directory);
        var publicRoot = Path.GetFullPath(Path.Combine(contentRoot, "wwwroot"));
        var comparison = OperatingSystem.IsWindows() ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal;
        if (path == Path.GetPathRoot(path) || string.Equals(path, publicRoot, comparison) || path.StartsWith(publicRoot + Path.DirectorySeparatorChar, comparison))
            throw new InvalidOperationException("Cookie keys must be outside the public web root.");
        for (var part = new DirectoryInfo(path); part != null; part = part.Parent)
            if (part.LinkTarget != null) throw new InvalidOperationException("Cookie key directories cannot use symbolic links.");
        Directory.CreateDirectory(path);
        if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
        services.AddDataProtection().SetApplicationName(name).PersistKeysToFileSystem(new DirectoryInfo(path));
    }
}
