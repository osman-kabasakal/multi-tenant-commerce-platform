namespace Platform.Security;

/// <summary>Explicit portable deployment adapter for the existing AES-GCM protocol.</summary>
/// <remarks>Same master key and envelope as Local; selecting this adapter performs no data migration.</remarks>
public sealed class PortableEncryptionService(string masterKeyBase64) : ITenantEncryptionService
{
    private readonly LocalEncryptionService _engine = new(masterKeyBase64);
    public Task<string> EncryptAsync(string plainText, string keyName) => _engine.EncryptAsync(plainText, keyName);
    public Task<string> DecryptAsync(string cipherText, string keyName) => _engine.DecryptAsync(cipherText, keyName);
    public Task<string> EncryptWithHybridMethod(string plainText, string keyName) => _engine.EncryptWithHybridMethod(plainText, keyName);
    public Task<string> DecryptWithHybridMethod(string cipherText, string keyName) => _engine.DecryptWithHybridMethod(cipherText, keyName);
}
