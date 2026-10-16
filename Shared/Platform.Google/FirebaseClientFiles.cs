using System.Text.Json;

namespace Platform.Google;

public static class FirebaseClientFiles
{
    public static async Task ExportAsync(TenantFirebaseConfiguration tenant, string directory, CancellationToken ct = default)
    {
        FirebaseConfigValidator.Validate(tenant);
        Directory.CreateDirectory(directory);
        await WriteAsync(Path.Combine(directory, "google-services.json"), tenant.AndroidConfigJson, ct);
        await WriteAsync(Path.Combine(directory, "GoogleService-Info.plist"), tenant.IosConfigPlist, ct);
        await WriteAsync(Path.Combine(directory, "firebase-client.json"), JsonSerializer.Serialize(new
        {
            tenantId = tenant.TenantId, projectId = tenant.ProjectId, projectNumber = tenant.ProjectNumber,
            androidAppId = tenant.AndroidAppId, iosAppId = tenant.IosAppId,
            androidPackageName = tenant.AndroidPackageName, iosBundleId = tenant.IosBundleId,
            iosPushTransport = tenant.IosPushTransport, iosDevelopmentTeam = tenant.IosDevelopmentTeam
        }, new JsonSerializerOptions { WriteIndented = true }), ct);
    }

    private static async Task WriteAsync(string path, string value, CancellationToken ct)
    {
        var temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            var options = new FileStreamOptions { Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None };
            if (!OperatingSystem.IsWindows()) options.UnixCreateMode = UnixFileMode.UserRead | UnixFileMode.UserWrite;
            await using (var stream = new FileStream(temporary, options))
            await using (var writer = new StreamWriter(stream)) await writer.WriteAsync(value.AsMemory(), ct);
            File.Move(temporary, path, true);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }
}
