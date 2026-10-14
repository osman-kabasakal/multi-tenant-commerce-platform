using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Microsoft.Extensions.Configuration;
using System.Security.Cryptography;
using System.Text.Json;

namespace Grand.Business.Common.Services.Security;

public class AzureEncryptionService : IAzureEncryptionService
{
    private readonly ICacheBase _cacheBase;

    private readonly KeyClient _keyClient;
    private readonly LocalDemoEncryption _local;
    // private CryptographyClient _cryptoClient;

    public AzureEncryptionService(
        IConfiguration configuration,
        ICacheBase cacheBase
    )
    {
        _cacheBase = cacheBase;
        if (configuration.GetValue<bool>("LocalDemo:Enabled"))
        {
            _local = new LocalDemoEncryption(configuration);
            return;
        }
        var keyVaultUrl = configuration["KeyVault:Url"];
        var credential = new DefaultAzureCredential();

        // Key Vault'dan anahtarı al veya oluştur

        _keyClient = new KeyClient(new Uri(keyVaultUrl), credential);
    }

    private KeyVaultKey GetKeyvaultKey(string keyName)
    {
        try
        {
            return _keyClient.GetKey(keyName).Value;
        }
        catch (Exception e)
        {
            // RSA-HSM anahtarı oluştur
            var key = _keyClient.CreateKey(
                keyName,
                KeyType.Rsa,
                new CreateRsaKeyOptions(keyName, false) {
                    KeySize = 2048,
                    ExpiresOn = DateTimeOffset.UtcNow.AddYears(1)
                });

            return key.Value;
        }
    }

    private CryptographyClient GetCryptographyClient(string keyName)
    {
        return new CryptographyClient(GetKeyvaultKey(keyName).Id, new DefaultAzureCredential());
    }

    public async Task<string> EncryptAsync(string plainText, string keyName)
    {
        if (_local != null) return await _local.EncryptAsync(plainText, keyName);
        if (string.IsNullOrEmpty(plainText))
            throw new ArgumentNullException(nameof(plainText));

        try
        {
            // Metni byte dizisine çevir
            byte[] bytesToEncrypt = Encoding.UTF8.GetBytes(plainText);

            var cryptoClient = GetCryptographyClient(keyName);

            // Azure Key Vault ile şifrele
            EncryptResult encryptResult =
                await cryptoClient.EncryptAsync(EncryptionAlgorithm.RsaOaep256, bytesToEncrypt);

            // Şifrelenmiş veriyi Base64'e çevir
            return Convert.ToBase64String(encryptResult.Ciphertext);
        }
        catch (Exception ex)
        {
            throw new CryptographicException($"Encryption failed: {ex.Message}", ex);
        }
    }

    public async Task<string> DecryptAsync(string cipherText, string keyName)
    {
        if (_local != null) return await _local.DecryptAsync(cipherText, keyName);
        if (string.IsNullOrEmpty(cipherText))
            throw new ArgumentNullException(nameof(cipherText));

        return await _cacheBase.GetAsync($"{keyName}:{cipherText}", async () =>
        {
            try
            {
                // Base64'ten byte dizisine çevir
                byte[] encryptedBytes = Convert.FromBase64String(cipherText);

                var cryptoClient = GetCryptographyClient(keyName);
                // Azure Key Vault ile şifre çöz
                DecryptResult decryptResult =
                    await cryptoClient.DecryptAsync(EncryptionAlgorithm.RsaOaep256, encryptedBytes);

                // Byte dizisini metne çevir
                return Encoding.UTF8.GetString(decryptResult.Plaintext);
            }
            catch (Exception ex)
            {
                throw new CryptographicException($"Decryption failed: {ex.Message}", ex);
            }
        });
    }

    public async Task<string> EncryptWithHybridMethod(string plainText, string keyName)
    {
        if (_local != null) return await _local.EncryptWithHybridMethod(plainText, keyName);
        // AES key oluştur
        using var aes = Aes.Create();
        aes.GenerateKey();

        // Veriyi AES ile şifrele
        byte[] encryptedData;
        using (var msEncrypt = new MemoryStream())
        {
            using (var encryptor = aes.CreateEncryptor())
            using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
            using (var swEncrypt = new StreamWriter(csEncrypt))
            {
                await swEncrypt.WriteAsync(plainText);
            }
            encryptedData = msEncrypt.ToArray();
        }

        // AES key'i RSA ile şifrele
        var cryptoClient = GetCryptographyClient(keyName);
        var encryptedKey = await cryptoClient.EncryptAsync(EncryptionAlgorithm.RsaOaep, aes.Key);

        // Sonuçları birleştir
        var result = new EncryptedDataModel {
            EncryptedData = Convert.ToBase64String(encryptedData),
            EncryptedKey = Convert.ToBase64String(encryptedKey.Ciphertext),
            IV = Convert.ToBase64String(aes.IV)
        };

        return JsonSerializer.Serialize(result);
    }

    public async Task<string> DecryptWithHybridMethod(string encryptedData, string keyName)
    {
        if (_local != null) return await _local.DecryptWithHybridMethod(encryptedData, keyName);
        try
        {
            // JSON'dan şifrelenmiş verileri parse et
            var encryptedObject = JsonSerializer.Deserialize<EncryptedDataModel>(encryptedData);

            // Base64'ten byte array'e çevir
            var encryptedBytes = Convert.FromBase64String(encryptedObject.EncryptedData);
            var encryptedKeyBytes = Convert.FromBase64String(encryptedObject.EncryptedKey);
            var iv = Convert.FromBase64String(encryptedObject.IV);

            // RSA ile AES key'i decrypt et
            var cryptoClient = GetCryptographyClient(keyName);
            var decryptedKeyResult = await cryptoClient.DecryptAsync(EncryptionAlgorithm.RsaOaep, encryptedKeyBytes);
            var aesKey = decryptedKeyResult.Plaintext;

            // AES ile veriyi decrypt et
            using var aes = Aes.Create();
            aes.Key = aesKey;
            aes.IV = iv;

            // Decrypt işlemi
            using var msDecrypt = new MemoryStream(encryptedBytes);
            using var aesDecryptor = aes.CreateDecryptor();
            using var csDecrypt = new CryptoStream(msDecrypt, aesDecryptor, CryptoStreamMode.Read);
            using var srDecrypt = new StreamReader(csDecrypt);

            return await srDecrypt.ReadToEndAsync();
        }
        catch (Exception ex)
        {
            throw new Exception($"Decryption failed: {ex.Message}");
        }
    }

    public class EncryptedDataModel
    {
        public string EncryptedData { get; set; }
        public string EncryptedKey { get; set; }
        public string IV { get; set; }
    }
}