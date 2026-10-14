namespace TenantManager.AzureEncryption;

public interface IAzureEncryptionService
{
    Task<string> EncryptAsync(string plainText, string keyName);
    Task<string> DecryptAsync(string cipherText, string keyName);

    Task<string> EncryptWithHybridMethod(string plainText, string keyName);
    Task<string> DecryptWithHybridMethod(string encryptedData, string keyName);
}