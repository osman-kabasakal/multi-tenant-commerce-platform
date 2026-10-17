namespace Grand.Domain.Customers;

public static class CustomerPasswordHash
{
    // Legacy records contain an uppercase hex digest and salt, but no algorithm field.
    // Its fixed digest length identifies the original supported SHA format independently of today's policy.
    // New passwords continue to use CustomerSettings.HashedPasswordFormat.
    public static HashedPasswordFormat StoredFormat(string hash, HashedPasswordFormat currentFormat)
    {
        if (string.IsNullOrEmpty(hash) || hash.Any(character=>!Uri.IsHexDigit(character))) return currentFormat;
        return hash.Length switch {
            40=>HashedPasswordFormat.SHA1,
            64=>HashedPasswordFormat.SHA256,
            96=>HashedPasswordFormat.SHA384,
            128=>HashedPasswordFormat.SHA512,
            _=>currentFormat
        };
    }
}
