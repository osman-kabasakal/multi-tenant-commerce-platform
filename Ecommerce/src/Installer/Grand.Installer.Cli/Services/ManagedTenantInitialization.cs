using System.Text.Json;

namespace Grand.Installer.Cli.Services;

/// <summary>The mandatory ordered initializer receipts, independent of later domain changes.</summary>
public static class ManagedTenantInitialization
{
    public static IReadOnlyList<string> Tasks { get; } = Array.AsReadOnly(new[] {
        "tenant-plugins", "tenant-migrations", "tenant-settings"
    });

    public static async Task VerifyAsync(string metadataPath, string tenant, string slug, string store)
    {
        void Verify(JsonElement receipt)
        {
            if (receipt.GetProperty("profile").GetString() != "Portable" || receipt.GetProperty("tenantId").GetString() != tenant ||
                receipt.GetProperty("slug").GetString() != slug || receipt.GetProperty("storeId").GetString() != store)
                throw new InvalidOperationException("Scheduled tenant ownership changed.");
        }
        using var metadata = JsonDocument.Parse(await File.ReadAllTextAsync(metadataPath));
        Verify(metadata.RootElement);
        foreach (var task in Tasks)
        {
            using var receipt = JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(Path.GetDirectoryName(metadataPath)!, slug + "." + task + ".json")));
            Verify(receipt.RootElement);
            if (receipt.RootElement.GetProperty("version").GetInt32() != 1 || receipt.RootElement.GetProperty("task").GetString() != task)
                throw new InvalidOperationException("Complete the ordered tenant initializer before scheduled tasks.");
        }
    }
}
