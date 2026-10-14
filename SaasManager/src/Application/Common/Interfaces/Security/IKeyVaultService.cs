using Azure.Security.KeyVault.Keys;

namespace SaasManager.Application.Common.Interfaces.Security;

public interface IKeyVaultService
{
    Task<KeyVaultKey> GetLatestKeyAsync(string keyName);
    Task<KeyVaultKey> GetKeyVersionAsync(string keyName, string version);
    Task<string> EncryptAsync(KeyVaultKey key, string data);
    Task<string> DecryptAsync(KeyVaultKey key, string encryptedData);
    Task<string> GetSecretAsync(string secretName);
}
