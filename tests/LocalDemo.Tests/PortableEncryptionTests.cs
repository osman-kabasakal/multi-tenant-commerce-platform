using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Security;

namespace Platform.Security.Tests;

[TestClass]
public sealed class PortableEncryptionTests
{
    [TestMethod]
    public async Task PortableProductionProviderReadsExistingProtocolWithoutMigration()
    {
        var master = Enumerable.Range(1,32).Select(x => (byte)x).ToArray();
        var key = Convert.ToBase64String(master);
        const string tenant = "tenant-a";
        // Construct a legacy-format fixture independently of either provider implementation.
        var derived = HMACSHA256.HashData(master,Encoding.UTF8.GetBytes("platform-security/v1/"+tenant));
        var nonce = Enumerable.Range(1,12).Select(x => (byte)x).ToArray();
        var text = Encoding.UTF8.GetBytes("existing encrypted record");
        var ciphertext = new byte[text.Length];var tag = new byte[16];
        using (var aes = new AesGcm(derived,16)) aes.Encrypt(nonce,text,ciphertext,tag,Encoding.UTF8.GetBytes(tenant));
        var fixture = "psec:local:v1:"+Convert.ToBase64String(nonce.Concat(tag).Concat(ciphertext).ToArray());
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["PlatformSecurity:Provider"]="AesGcm", ["PlatformSecurity:AesGcm:MasterKeyBase64"]=key,
            ["PlatformSecurity:ConnectionString"]="Host=localhost;Database=unused"
        }).Build();
        using var provider = new ServiceCollection().AddPlatformSecurity(configuration,"Production").BuildServiceProvider();
        var portable = provider.GetRequiredService<ITenantEncryptionService>();
        Assert.IsInstanceOfType<PortableEncryptionService>(portable);
        Assert.AreEqual("existing encrypted record",await portable.DecryptAsync(fixture,tenant));
        var local = new LocalEncryptionService(key);
        Assert.AreEqual("portable record",await local.DecryptAsync(await portable.EncryptAsync("portable record",tenant),tenant));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(()=>portable.DecryptAsync(fixture,"tenant-b"));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(()=>new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))).DecryptAsync(fixture,tenant));
        configuration["PlatformSecurity:Provider"]="Local";
        Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddPlatformSecurity(configuration,"Production"));
    }
}
