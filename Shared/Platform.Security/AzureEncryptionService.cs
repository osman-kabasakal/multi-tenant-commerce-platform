using Azure.Core;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace Platform.Security;

/// <summary>Versioned envelope encryption. Provision the wrapping RSA key once, outside application startup.</summary>
public sealed class AzureEncryptionService(KeyClient keys, TokenCredential credential, string wrappingKeyName,
    Func<Uri, CryptographyClient>? cryptographyClientFactory = null) : ITenantEncryptionService
{
    private CryptographyClient Crypto(Uri id) => cryptographyClientFactory?.Invoke(id) ?? new CryptographyClient(id, credential);
    private const string Prefix = "psec:azure:v1:";
    private sealed record Envelope(string KeyId, string WrappedKey, string Data);
    public async Task<string> EncryptAsync(string plainText, string keyName)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(keyName);
        var wrappingKey = (await keys.GetKeyAsync(wrappingKeyName)).Value;
        var dataKey = RandomNumberGenerator.GetBytes(32);
        try
        {
            var crypto = Crypto(wrappingKey.Id);
            var wrapped = await crypto.WrapKeyAsync(KeyWrapAlgorithm.RsaOaep256, dataKey);
            return Prefix + Convert.ToBase64String(JsonSerializer.SerializeToUtf8Bytes(new Envelope(
                wrappingKey.Id.AbsoluteUri, Convert.ToBase64String(wrapped.EncryptedKey),
                AuthenticatedCipher.Encrypt(plainText, keyName, dataKey))));
        }
        finally { CryptographicOperations.ZeroMemory(dataKey); }
    }
    public async Task<string> DecryptAsync(string cipherText, string keyName)
    {
        if (!cipherText.StartsWith(Prefix, StringComparison.Ordinal))
        {
            // Existing Azure RSA payloads remain readable with their original tenant key.
            var legacy = (await keys.GetKeyAsync(keyName)).Value;
            var result = await Crypto(legacy.Id)
                .DecryptAsync(EncryptionAlgorithm.RsaOaep256, Convert.FromBase64String(cipherText));
            return Encoding.UTF8.GetString(result.Plaintext);
        }
        var envelope = JsonSerializer.Deserialize<Envelope>(Convert.FromBase64String(cipherText[Prefix.Length..]))
            ?? throw new CryptographicException("Invalid Azure envelope.");
        var id = new Uri(envelope.KeyId);
        var expectedPath = "/keys/" + wrappingKeyName + "/";
        if (id.Scheme != "https" || id.Authority != keys.VaultUri.Authority ||
            !id.AbsolutePath.StartsWith(expectedPath, StringComparison.Ordinal) ||
            id.AbsolutePath[expectedPath.Length..].Contains('/') || string.IsNullOrEmpty(id.AbsolutePath[expectedPath.Length..]) ||
            id.Query.Length != 0 || id.Fragment.Length != 0)
            throw new CryptographicException("Envelope references an unexpected wrapping key.");
        var unwrapped = await Crypto(id).UnwrapKeyAsync(
            KeyWrapAlgorithm.RsaOaep256, Convert.FromBase64String(envelope.WrappedKey));
        try { return AuthenticatedCipher.Decrypt(envelope.Data, keyName, unwrapped.Key); }
        finally { CryptographicOperations.ZeroMemory(unwrapped.Key); }
    }
    public Task<string> EncryptWithHybridMethod(string plainText, string keyName) => EncryptAsync(plainText, keyName);
    public async Task<string> DecryptWithHybridMethod(string cipherText, string keyName)
    {
        if (cipherText.StartsWith(Prefix, StringComparison.Ordinal)) return await DecryptAsync(cipherText, keyName);
        // Read the previous JSON + RSA-OAEP/AES-CBC format; new writes always use authenticated envelopes.
        using var data = JsonDocument.Parse(cipherText);
        var root = data.RootElement;
        var key = (await keys.GetKeyAsync(keyName)).Value;
        var result = await Crypto(key.Id).DecryptAsync(EncryptionAlgorithm.RsaOaep,
            Convert.FromBase64String(root.GetProperty("EncryptedKey").GetString()!));
        try
        {
            using var aes = Aes.Create(); aes.Key = result.Plaintext;
            aes.IV = Convert.FromBase64String(root.GetProperty("IV").GetString()!);
            var encrypted = Convert.FromBase64String(root.GetProperty("EncryptedData").GetString()!);
            using var decryptor = aes.CreateDecryptor();
            return Encoding.UTF8.GetString(decryptor.TransformFinalBlock(encrypted,0,encrypted.Length));
        }
        finally { CryptographicOperations.ZeroMemory(result.Plaintext); }
    }
}
