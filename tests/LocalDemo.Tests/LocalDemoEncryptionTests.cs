using Platform.Security;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Security.Cryptography;

namespace Platform.Security.Tests;

[TestClass]
public class LocalEncryptionTests
{
    private static string Key() => Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
    [TestMethod]
    public async Task IndependentInstancesCanDecryptOnlyTheirTenantAndRejectTampering()
    {
        var key = Key();
        ITenantEncryptionService writer = new LocalEncryptionService(key), reader = new LocalEncryptionService(key);
        var ciphertext = await writer.EncryptAsync("synthetic metadata", "tenant-a");
        Assert.AreEqual("synthetic metadata", await reader.DecryptAsync(ciphertext,"tenant-a"));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(() => reader.DecryptAsync(ciphertext,"tenant-b"));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(() => new LocalEncryptionService(Key()).DecryptAsync(ciphertext,"tenant-a"));
        const string prefix = "psec:local:v1:";
        var bytes = Convert.FromBase64String(ciphertext[prefix.Length..]); bytes[^1] ^= 1;
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(() => reader.DecryptAsync(prefix+Convert.ToBase64String(bytes),"tenant-a"));
        Assert.AreNotEqual(ciphertext,await writer.EncryptAsync("synthetic metadata","tenant-a"));
    }
    [TestMethod]
    public async Task HybridContractSupportsLargeValuesAcrossInstances()
    {
        var key=Key(); var text = new string('x',100000);
        var value=await new LocalEncryptionService(key).EncryptWithHybridMethod(text,"tenant-a");
        Assert.AreEqual(text,await new LocalEncryptionService(key).DecryptWithHybridMethod(value,"tenant-a"));
    }
    [TestMethod]
    public void ProviderSelectionIsExplicitAndLocalCannotRunInProduction()
    {
        var configuration=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["PlatformSecurity:Provider"]="Local", ["PlatformSecurity:ConnectionString"]="Host=localhost;Database=test",
            ["PlatformSecurity:Local:MasterKeyBase64"]=Key(), ["LocalDemo:Enabled"]="true"
        }).Build();
        Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddPlatformSecurity(configuration,"Production"));
        var services=new ServiceCollection().AddPlatformSecurity(configuration,"Development");
        using var provider=services.BuildServiceProvider();
        Assert.IsInstanceOfType<LocalEncryptionService>(provider.GetRequiredService<ITenantEncryptionService>());
        configuration["PlatformSecurity:Provider"]="invalid";
        Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddPlatformSecurity(configuration,"Development"));
        configuration["PlatformSecurity:Provider"]="Azure";
        configuration["PlatformSecurity:Azure:VaultUrl"]="https://unit-test.vault.azure.net";
        configuration["PlatformSecurity:Azure:KeyName"]="tenant-data";
        using var azure=new ServiceCollection().AddPlatformSecurity(configuration,"Production").BuildServiceProvider();
        Assert.IsInstanceOfType<AzureEncryptionService>(azure.GetRequiredService<ITenantEncryptionService>());
    }
}
