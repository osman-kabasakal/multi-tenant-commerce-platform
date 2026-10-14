using System.Text;
using Azure;
using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using Azure.Security.KeyVault.Secrets;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Exceptions;
using SaasManager.Application.Common.Interfaces.Security;
using NotFoundException = SaasManager.Application.Common.Exceptions.NotFoundException;

namespace SaasManager.Infrastructure.Security;

public class KeyVaultService : IKeyVaultService
{
    private readonly KeyClient _keyClient;
    private readonly SecretClient _secretClient;
    private readonly ILogger<KeyVaultService> _logger;

    public KeyVaultService(
        KeyClient keyClient, 
        SecretClient secretClient,
        ILogger<KeyVaultService> logger)
    {
        _keyClient = keyClient;
        _secretClient = secretClient;
        _logger = logger;
    }

    public async Task<KeyVaultKey> GetLatestKeyAsync(string keyName)
    {
        try
        {
            return await _keyClient.GetKeyAsync(keyName);
        }
        catch (Exception)
        {
            // Key yoksa oluştur
            return await _keyClient.CreateKeyAsync(
                keyName,
                KeyType.Rsa,
                new CreateRsaKeyOptions(keyName, false) {
                    KeySize = 2048,
                    ExpiresOn = DateTimeOffset.UtcNow.AddYears(1)
                });
        }
    }

    public async Task<string> EncryptAsync(KeyVaultKey key, string data)
    {
        var bytes = Encoding.UTF8.GetBytes(data);
        var cryptoClient = _keyClient.GetCryptographyClient(key.Name, key.Properties.Version);
        var encryptResult = await cryptoClient.EncryptAsync(
            EncryptionAlgorithm.RsaOaep,
            bytes);

        return Convert.ToBase64String(encryptResult.Ciphertext);
    }
    
    public async Task<KeyVaultKey> GetKeyVersionAsync(string keyName, string version)
   {
       try
       {
           // Belirli bir versiyondaki key'i al
           return await _keyClient.GetKeyAsync(keyName, version);
       }
       catch (Exception ex)
       {
           _logger.LogError(ex, "Error retrieving key version {KeyName} {Version}", keyName, version);
           throw new SecurityException($"Could not retrieve key version: {keyName}", ex);
       }
   }

   public async Task<string> DecryptAsync(KeyVaultKey key, string encryptedData)
   {
       try
       {
           // Base64 string'i byte array'e çevir
           var encryptedBytes = Convert.FromBase64String(encryptedData);

           // Key'e özel CryptographyClient oluştur
           var cryptoClient = new CryptographyClient(key.Id, new DefaultAzureCredential());

           // Decrypt işlemini gerçekleştir
           var decryptResult = await cryptoClient.DecryptAsync(
               EncryptionAlgorithm.RsaOaep,
               encryptedBytes);

           // Byte array'i string'e çevir
           return Encoding.UTF8.GetString(decryptResult.Plaintext);
       }
       catch (FormatException ex)
       {
           _logger.LogError(ex, "Invalid encrypted data format");
           throw new SecurityException("Invalid encrypted data format", ex);
       }
       catch (Exception ex)
       {
           _logger.LogError(ex, "Error decrypting data with key {KeyId}", key.Id);
           throw new SecurityException("Decryption failed", ex);
       }
   }

   public async Task<string> GetSecretAsync(string secretName)
   {
       try
       {
           // Secret'ı al
           var secret = await _secretClient.GetSecretAsync(secretName);
           return secret.Value.Value;
       }
       catch (RequestFailedException ex) when (ex.Status == 404)
       {
           _logger.LogWarning("Secret {SecretName} not found", secretName);
           throw new NotFoundException($"Secret not found: {secretName}");
       }
       catch (Exception ex)
       {
           _logger.LogError(ex, "Error retrieving secret {SecretName}", secretName);
           throw new SecurityException($"Could not retrieve secret: {secretName}", ex);
       }
   }

   private async Task ValidateKeyVersionAsync(string keyName, string version)
   {
       try
       {
           var key = await _keyClient.GetKeyAsync(keyName, version);
           
           // Key'in aktif olup olmadığını kontrol et
           if (key.Value.Properties.Enabled != true)
           {
               throw new SecurityException($"Key version is disabled: {keyName} {version}");
           }

           // Key'in süresinin dolup dolmadığını kontrol et
           if (key.Value.Properties.ExpiresOn.HasValue && 
               key.Value.Properties.ExpiresOn.Value <= DateTimeOffset.UtcNow)
           {
               throw new SecurityException($"Key version has expired: {keyName} {version}");
           }
       }
       catch (RequestFailedException ex) when (ex.Status == 404)
       {
           throw new NotFoundException($"Key version not found: {keyName} {version}");
       }
   }

   private Task<bool> IsKeyRotationNeededAsync(KeyVaultKey key)
   {
       // Key rotation policy'sine göre kontrol et
       // Örneğin: 90 günden eski key'ler için rotasyon gerekli
       var rotationThreshold = TimeSpan.FromDays(90);
       
       if (key.Properties.CreatedOn.HasValue)
       {
           var keyAge = DateTimeOffset.UtcNow - key.Properties.CreatedOn.Value;
           return Task.FromResult(keyAge > rotationThreshold);
       }

       return Task.FromResult(false);
   }

   private async Task<KeyVaultKey> RotateKeyAsync(string keyName)
   {
       try
       {
           // Yeni bir key version oluştur
           var newKey = await _keyClient.CreateKeyAsync(keyName, KeyType.Rsa);
           _logger.LogInformation("Created new key version for {KeyName}", keyName);
           
           return newKey;
       }
       catch (Exception ex)
       {
           _logger.LogError(ex, "Error rotating key {KeyName}", keyName);
           throw new SecurityException($"Could not rotate key: {keyName}", ex);
       }
   }
}
