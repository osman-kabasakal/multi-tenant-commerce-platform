using Azure;
using Azure.Core;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Security;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace Platform.Security.Tests;

[TestClass]
public class AzureEncryptionTests
{
    [TestMethod]
    public async Task EnvelopePinsKeyVersionRejectsOtherTenantsAndUntrustedVaults()
    {
        var vault=new Uri("https://unit-test.vault.azure.net");
        var keyId=new Uri(vault,"/keys/tenant-data/version-1");
        using var rsa=RSA.Create(2048);
        var keys=new Mock<KeyClient>(); keys.SetupGet(x=>x.VaultUri).Returns(vault);
        var key=KeyModelFactory.KeyVaultKey(KeyModelFactory.KeyProperties(id:keyId,name:"tenant-data",version:"version-1",vaultUri:vault),new JsonWebKey(rsa));
        keys.Setup(x=>x.GetKeyAsync("tenant-data",null,It.IsAny<CancellationToken>())).ReturnsAsync(Response.FromValue(key,Mock.Of<Response>()));
        var crypto=new Mock<CryptographyClient>();
        crypto.Setup(x=>x.WrapKeyAsync(KeyWrapAlgorithm.RsaOaep256,It.IsAny<byte[]>(),It.IsAny<CancellationToken>()))
            .ReturnsAsync((KeyWrapAlgorithm algorithm,byte[] value,CancellationToken _) =>
                CryptographyModelFactory.WrapResult(keyId.ToString(),rsa.Encrypt(value,RSAEncryptionPadding.OaepSHA256),algorithm));
        crypto.Setup(x=>x.UnwrapKeyAsync(KeyWrapAlgorithm.RsaOaep256,It.IsAny<byte[]>(),It.IsAny<CancellationToken>()))
            .ReturnsAsync((KeyWrapAlgorithm algorithm,byte[] value,CancellationToken _) =>
                CryptographyModelFactory.UnwrapResult(keyId.ToString(),rsa.Decrypt(value,RSAEncryptionPadding.OaepSHA256),algorithm));
        var requested=new List<Uri>();
        var service=new AzureEncryptionService(keys.Object,Mock.Of<TokenCredential>(),"tenant-data",id=> {requested.Add(id);return crypto.Object;});
        var text=new string('x',100000);
        var cipher=await service.EncryptAsync(text,"tenant-a");
        // Current key lookup is unavailable after rotation; reading must still use the envelope's pinned ID.
        keys.Setup(x=>x.GetKeyAsync("tenant-data",null,It.IsAny<CancellationToken>())).ThrowsAsync(new Exception("Do not resolve latest on decrypt"));
        Assert.AreEqual(text,await service.DecryptAsync(cipher,"tenant-a"));
        Assert.IsTrue(requested.All(id=>id==keyId));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(()=>service.DecryptAsync(cipher,"tenant-b"));
        const string prefix="psec:azure:v1:";
        var envelope=JsonSerializer.Deserialize<Dictionary<string,string>>(Convert.FromBase64String(cipher[prefix.Length..]))!;
        envelope["KeyId"]="https://other.invalid/keys/tenant-data/version-1";
        var malicious=prefix+Convert.ToBase64String(JsonSerializer.SerializeToUtf8Bytes(envelope));
        var count=requested.Count;
        await Assert.ThrowsExceptionAsync<CryptographicException>(()=>service.DecryptAsync(malicious,"tenant-a"));
        Assert.AreEqual(count,requested.Count);
    }
}
