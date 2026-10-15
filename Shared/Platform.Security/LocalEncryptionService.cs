using System.Security.Cryptography;
using System.Text;

namespace Platform.Security;

/// <summary>All instances must receive the same externally provisioned 256-bit master key.</summary>
public sealed class LocalEncryptionService : ITenantEncryptionService
{
    private readonly byte[] _master;
    private const string Prefix = "psec:local:v1:";
    public LocalEncryptionService(string masterKeyBase64)
    {
        _master = Convert.FromBase64String(masterKeyBase64);
        if (_master.Length != 32) throw new ArgumentException("Local master key must contain exactly 32 bytes.");
    }
    private byte[] Key(string name)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        return HMACSHA256.HashData(_master, Encoding.UTF8.GetBytes("platform-security/v1/" + name));
    }
    public Task<string> EncryptAsync(string plainText, string keyName)
    {
        var key = Key(keyName);
        try { return Task.FromResult(Prefix + AuthenticatedCipher.Encrypt(plainText, keyName, key)); }
        finally { CryptographicOperations.ZeroMemory(key); }
    }
    public Task<string> DecryptAsync(string cipherText, string keyName)
    {
        if (!cipherText.StartsWith(Prefix, StringComparison.Ordinal))
            throw new CryptographicException("Unsupported local ciphertext. Re-seed legacy demo claims or migrate explicitly.");
        var key = Key(keyName);
        try { return Task.FromResult(AuthenticatedCipher.Decrypt(cipherText[Prefix.Length..], keyName, key)); }
        finally { CryptographicOperations.ZeroMemory(key); }
    }
    public Task<string> EncryptWithHybridMethod(string plainText, string keyName) => EncryptAsync(plainText, keyName);
    public Task<string> DecryptWithHybridMethod(string cipherText, string keyName) => DecryptAsync(cipherText, keyName);
}

internal static class AuthenticatedCipher
{
    public static string Encrypt(string text, string context, byte[] key)
    {
        var plain = Encoding.UTF8.GetBytes(text);
        var nonce = RandomNumberGenerator.GetBytes(12);
        var tag = new byte[16]; var cipher = new byte[plain.Length];
        using var aes = new AesGcm(key, 16);
        aes.Encrypt(nonce, plain, cipher, tag, Encoding.UTF8.GetBytes(context));
        CryptographicOperations.ZeroMemory(plain);
        return Convert.ToBase64String(nonce.Concat(tag).Concat(cipher).ToArray());
    }
    public static string Decrypt(string text, string context, byte[] key)
    {
        var bytes = Convert.FromBase64String(text);
        if (bytes.Length < 28) throw new CryptographicException("Invalid ciphertext.");
        var plain = new byte[bytes.Length - 28];
        try
        {
            using var aes = new AesGcm(key, 16);
            aes.Decrypt(bytes.AsSpan(0,12), bytes.AsSpan(28), bytes.AsSpan(12,16), plain, Encoding.UTF8.GetBytes(context));
            return Encoding.UTF8.GetString(plain);
        }
        finally { CryptographicOperations.ZeroMemory(plain); }
    }
}
