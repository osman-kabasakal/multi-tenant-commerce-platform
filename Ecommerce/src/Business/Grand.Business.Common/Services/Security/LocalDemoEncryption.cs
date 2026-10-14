using Grand.Business.Core.Interfaces.Common.Security;
using Microsoft.Extensions.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace Grand.Business.Common.Services.Security;

/// <summary>Authenticated encryption with a distinct key per tenant, stored only in .local.</summary>
public sealed class LocalDemoEncryption : IAzureEncryptionService
{
    private readonly string _directory;
    public LocalDemoEncryption(IConfiguration configuration)
    {
        _directory = configuration["LocalDemo:SecretsPath"]
            ?? throw new InvalidOperationException("Local demo secrets directory missing.");
    }
    private byte[] Key(string name)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        var path = Path.Combine(_directory, "encryption-" + Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(name))));
        return Grand.Infrastructure.LocalDemo.LocalSecretFile.GetOrCreate(path, () => RandomNumberGenerator.GetBytes(32));
    }
    public Task<string> EncryptAsync(string plainText, string keyName)
    {
        var plain = Encoding.UTF8.GetBytes(plainText);
        var nonce = RandomNumberGenerator.GetBytes(12);
        var cipher = new byte[plain.Length]; var tag = new byte[16];
        using var aes = new AesGcm(Key(keyName), 16);
        aes.Encrypt(nonce, plain, cipher, tag, Encoding.UTF8.GetBytes(keyName));
        return Task.FromResult(Convert.ToBase64String(nonce.Concat(tag).Concat(cipher).ToArray()));
    }
    public Task<string> DecryptAsync(string cipherText, string keyName)
    {
        var data = Convert.FromBase64String(cipherText);
        if (data.Length < 28) throw new CryptographicException("Invalid local ciphertext.");
        var plain = new byte[data.Length - 28];
        using var aes = new AesGcm(Key(keyName), 16);
        aes.Decrypt(data.AsSpan(0, 12), data.AsSpan(28), data.AsSpan(12, 16), plain, Encoding.UTF8.GetBytes(keyName));
        return Task.FromResult(Encoding.UTF8.GetString(plain));
    }
    public Task<string> EncryptWithHybridMethod(string plainText, string keyName) => EncryptAsync(plainText, keyName);
    public Task<string> DecryptWithHybridMethod(string cipherText, string keyName) => DecryptAsync(cipherText, keyName);
}
