using System.Text.Json;

namespace Platform.Google;

public sealed record FirebasePushContent(string? Title, string? Body, string? ImageUrl = null,
    IReadOnlyDictionary<string,string>? Data = null)
{
    public void Validate(bool allowLocalImages = false)
    {
        if ((string.IsNullOrEmpty(Title) && string.IsNullOrEmpty(Body) && (Data == null || Data.Count == 0)) ||
            Title?.Length > 1000 || Body?.Length > 2000 ||
            (Data != null && Data.Any(p => string.IsNullOrEmpty(p.Key) || p.Value == null)) ||
            JsonSerializer.SerializeToUtf8Bytes(this).Length > 3000)
            throw new ArgumentException("Notification payload is empty or exceeds supported limits.");
        if (!string.IsNullOrEmpty(ImageUrl) && (!Uri.TryCreate(ImageUrl, UriKind.Absolute, out var image) || (image.Scheme != "https" && !(allowLocalImages && image.Scheme == "http" && (image.IsLoopback || image.Host.EndsWith(".localhost", StringComparison.OrdinalIgnoreCase)))) || !string.IsNullOrEmpty(image.UserInfo)))
            throw new ArgumentException("Notification images require an HTTPS URL.");
    }
}
