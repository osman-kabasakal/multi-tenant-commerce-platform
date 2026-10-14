using Grand.Business.Common.Services.Security;
using Grand.Infrastructure.LocalDemo;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Security.Cryptography;

namespace Grand.Business.Common.Tests.Services.Security;

[TestClass]
public class LocalDemoEncryptionTests
{
    private string _directory;
    private LocalDemoEncryption _encryption;

    [TestInitialize]
    public void Init()
    {
        _directory = Path.Combine(Path.GetTempPath(), "commerce-demo-test-" + Guid.NewGuid());
        Directory.CreateDirectory(_directory);
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string> {
            ["LocalDemo:SecretsPath"] = _directory
        }).Build();
        _encryption = new LocalDemoEncryption(config);
    }

    [TestCleanup]
    public void Cleanup() => Directory.Delete(_directory, true);

    [TestMethod]
    public async Task CiphertextIsTenantBoundAndAuthenticated()
    {
        var ciphertext = await _encryption.EncryptAsync("synthetic store metadata", "demo-a");
        Assert.AreEqual("synthetic store metadata", await _encryption.DecryptAsync(ciphertext, "demo-a"));
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(
            () => _encryption.DecryptAsync(ciphertext, "demo-b"));
        var bytes = Convert.FromBase64String(ciphertext);
        bytes[^1] ^= 1;
        await Assert.ThrowsExceptionAsync<AuthenticationTagMismatchException>(
            () => _encryption.DecryptAsync(Convert.ToBase64String(bytes), "demo-a"));
    }

    [TestMethod]
    public void ConcurrentCreationPublishesOneCompleteKey()
    {
        var path = Path.Combine(_directory, "shared-key");
        var results = new byte[24][];
        Parallel.For(0, results.Length, i => results[i] = LocalSecretFile.GetOrCreate(path,
            () => RandomNumberGenerator.GetBytes(32)));
        foreach (var result in results)
        {
            Assert.AreEqual(32, result.Length);
            CollectionAssert.AreEqual(results[0], result);
        }
    }
}
