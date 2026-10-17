using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text.Json;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed record AndroidSigningKey(int Version,string TenantId,string PackageName,string KeyAlias,
    string Password,string KeyStoreBase64,string CertificateSha256,string CertificateBase64)
{
    public void Validate(string tenant,string package)
    {
        if(Version!=1 || TenantId!=tenant || PackageName!=package || KeyAlias!="tenant" || string.IsNullOrEmpty(Password) || Password.Length!=64 || Password.Any(c=>!char.IsAsciiHexDigit(c)) ||
            string.IsNullOrEmpty(KeyStoreBase64) || KeyStoreBase64.Length>1024*1024 || string.IsNullOrEmpty(CertificateBase64) || CertificateBase64.Length>65536 || !MobileReleaseFiles.Digest(CertificateSha256))
            throw new InvalidOperationException("The saved Android signing identity does not match this tenant app.");
        if(Convert.FromBase64String(KeyStoreBase64).Length<512)throw new InvalidOperationException("Invalid Android keystore content.");
        using var certificate=new X509Certificate2(Convert.FromBase64String(CertificateBase64));
        if(Convert.ToHexString(SHA256.HashData(certificate.RawData)).ToLowerInvariant()!=CertificateSha256)
            throw new InvalidOperationException("The saved Android signing certificate is invalid.");
    }
}

public interface IAndroidSigningKeyFactory
{
    Task<AndroidSigningKey> CreateAsync(string tenant,string package,CancellationToken ct);
    Task VerifyAsync(AndroidSigningKey key,CancellationToken ct);
}

public sealed class KeytoolAndroidSigningKeyFactory(AndroidReleaseOptions options) : IAndroidSigningKeyFactory
{
    public async Task<AndroidSigningKey> CreateAsync(string tenant,string package,CancellationToken ct)
    {
        var directory=Path.Combine(options.WorkingDirectory,"signing-"+Guid.NewGuid().ToString("N"));MobileReleaseFiles.PrivateDirectory(directory);
        try
        {
            var path=Path.Combine(directory,"signing.p12");var password=Convert.ToHexString(RandomNumberGenerator.GetBytes(32));
            await MobileProcess.RunAsync(options.KeytoolPath,["-genkeypair","-noprompt","-alias","tenant","-keyalg","RSA","-keysize","3072",
                "-validity","10000","-storetype","PKCS12","-dname","CN=Tenant "+tenant,"-keystore",path,
                "-storepass:env","PLATFORM_ANDROID_KEY_PASSWORD","-keypass:env","PLATFORM_ANDROID_KEY_PASSWORD"],directory,
                new Dictionary<string,string>{{"PLATFORM_ANDROID_KEY_PASSWORD",password}},TimeSpan.FromSeconds(120),ct);
            MobileReleaseFiles.RegularFile(path,1024*1024);var bytes=await File.ReadAllBytesAsync(path,ct);
            var certificate=await ExportCertificateAsync(path,password,directory,ct);
            return new(1,tenant,package,"tenant",password,Convert.ToBase64String(bytes),Convert.ToHexString(SHA256.HashData(certificate)).ToLowerInvariant(),Convert.ToBase64String(certificate));
        }
        finally {Directory.Delete(directory,recursive:true);}
    }
    private async Task<byte[]> ExportCertificateAsync(string keyStore,string password,string directory,CancellationToken ct)
    {
        var target=Path.Combine(directory,"certificate.der");
        await MobileProcess.RunAsync(options.KeytoolPath,["-exportcert","-alias","tenant","-keystore",keyStore,"-storepass:env","PLATFORM_ANDROID_KEY_PASSWORD","-file",target],
            directory,new Dictionary<string,string>{{"PLATFORM_ANDROID_KEY_PASSWORD",password}},TimeSpan.FromSeconds(60),ct);
        MobileReleaseFiles.RegularFile(target,65536);return await File.ReadAllBytesAsync(target,ct);
    }
    public async Task VerifyAsync(AndroidSigningKey key,CancellationToken ct)
    {
        key.Validate(key.TenantId,key.PackageName);
        var directory=Path.Combine(options.WorkingDirectory,"key-check-"+Guid.NewGuid().ToString("N"));MobileReleaseFiles.PrivateDirectory(directory);
        try
        {
            var path=Path.Combine(directory,"signing.p12");await MobileReleaseFiles.WriteAsync(path,Convert.FromBase64String(key.KeyStoreBase64),ct);
            var certificate=await ExportCertificateAsync(path,key.Password,directory,ct);
            if(Convert.ToHexString(SHA256.HashData(certificate)).ToLowerInvariant()!=key.CertificateSha256)
                throw new InvalidOperationException("The encrypted Android keystore belongs to another signing identity.");
        }
        finally{Directory.Delete(directory,recursive:true);}
    }
}

public sealed class TenantAndroidSigningKeys(ITenantSecrets secrets,IAndroidSigningKeyFactory factory)
{
    public const string SecretName="android-release-signing-v1";
    public async Task<AndroidSigningKey> ReadAsync(string tenant,string package,CancellationToken ct)
    {
        var value=MobileReleaseFiles.Parse<AndroidSigningKey>(await secrets.GetAsync(tenant,SecretName,ct));value.Validate(tenant,package);await factory.VerifyAsync(value,ct);return value;
    }
    public async Task<AndroidSigningKey> GetOrCreateAsync(string tenant,string package,CancellationToken ct)
    {
        try{return await ReadAsync(tenant,package,ct);}catch(KeyNotFoundException){}
        var candidate=await factory.CreateAsync(tenant,package,ct);candidate.Validate(tenant,package);
        var saved=await secrets.GetOrCreateAsync(tenant,SecretName,()=>JsonSerializer.Serialize(candidate,MobileReleaseFiles.Json),ct);
        var winner=MobileReleaseFiles.Parse<AndroidSigningKey>(saved);winner.Validate(tenant,package);await factory.VerifyAsync(winner,ct);return winner;
    }
    public static string PackageSecretName(string package)
    {
        if (package.Length > 200 || !System.Text.RegularExpressions.Regex.IsMatch(package, "^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+\\z"))
            throw new ArgumentException("Use a valid bounded Android package identity.");
        return "android-package-signing-v1-" + Convert.ToHexString(SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(package))).ToLowerInvariant();
    }
    public async Task<AndroidSigningKey> ReadPackageAsync(string tenant, string package, CancellationToken ct)
    {
        var name = PackageSecretName(package);
        string value;
        try { value = await secrets.GetAsync(tenant, name, ct); }
        catch (KeyNotFoundException)
        {
            // The original release may predate per-package storage. It is never copied, rotated or reused by another package.
            var legacy = MobileReleaseFiles.Parse<AndroidSigningKey>(await secrets.GetAsync(tenant, SecretName, ct));
            legacy.Validate(tenant, legacy.PackageName);
            if (legacy.PackageName != package) throw new KeyNotFoundException("No signing identity exists for this package.");
            await factory.VerifyAsync(legacy, ct); return legacy;
        }
        var key = MobileReleaseFiles.Parse<AndroidSigningKey>(value); key.Validate(tenant, package);
        await factory.VerifyAsync(key, ct); return key;
    }
    public async Task<AndroidSigningKey> GetOrCreatePackageAsync(string tenant, string package, CancellationToken ct)
    {
        try { return await ReadPackageAsync(tenant, package, ct); } catch (KeyNotFoundException) { }
        var name = PackageSecretName(package);
        var candidate = await factory.CreateAsync(tenant, package, ct); candidate.Validate(tenant, package);
        var saved = await secrets.GetOrCreateAsync(tenant, name, () => JsonSerializer.Serialize(candidate, MobileReleaseFiles.Json), ct);
        var winner = MobileReleaseFiles.Parse<AndroidSigningKey>(saved); winner.Validate(tenant, package);
        await factory.VerifyAsync(winner, ct); return winner;
    }

}
