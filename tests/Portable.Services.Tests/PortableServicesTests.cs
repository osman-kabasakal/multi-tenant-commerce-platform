using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.FileStorage;
using SaasManager.Infrastructure.Security;

namespace Portable.Services.Tests;

internal static class Owners
{
    public static (Mock<IWorkContext> Context,GuestRegistration Guest,Business Business) Create()
    {
        var actor=Guid.NewGuid();var guest=new GuestRegistration("owner@example.test",""){Id=Guid.NewGuid()};
        guest.MarkAsConverted(actor.ToString());guest.MarkEmailAsVerified();
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id){Id=Guid.NewGuid()};
        guest.ConvertToBusiness(business);
        var context=new Mock<IWorkContext>();context.SetupProperty(c=>c.GuestRegistration,guest);context.SetupGet(c=>c.KeycloakId).Returns(actor);
        return(context,guest,business);
    }
}

[TestClass]
public sealed class CardProtectionTests
{
    private static CardData Card()=>new(){Number="4242424242424242",Cvv="123",ExpiryMonth="12",ExpiryYear=DateTime.UtcNow.AddYears(5).ToString("yy"),CardHolderName="Test Owner"};

    [TestMethod]
    public async Task IndependentInstancesRecoverPanButNeverPersistOrRecoverCvv()
    {
        var key=Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));var owner=Owners.Create();
        var encryption=new PortableEncryptionService(key);var first=new PlatformCardDataProtector(encryption,owner.Context.Object);
        var saved=await first.EncryptAsync(Card());
        Assert.IsFalse(saved.EncryptedNumber.Contains(Card().Number));
        var json=await encryption.DecryptAsync(saved.EncryptedNumber["pcard:v1:".Length..],"saas-cards/v1/"+owner.Business.Id.ToString("N"));
        using(var doc=JsonDocument.Parse(json)){Assert.IsFalse(doc.RootElement.TryGetProperty("Cvv",out _));Assert.IsFalse(json.Contains("\"123\""));}
        var second=new PlatformCardDataProtector(new PortableEncryptionService(key),owner.Context.Object);
        var card=await second.DecryptAsync(saved);Assert.AreEqual(Card().Number,card.Number);Assert.AreEqual("",card.Cvv);
        Assert.AreEqual(saved.LastFourDigits,await second.GetLastFourDigitsAsync(saved));
    }

    private static async Task CryptoFailure(Func<Task> action)
    {
        try { await action(); Assert.Fail("Cryptographic validation unexpectedly accepted the payload."); }
        catch(CryptographicException) { }
    }

    [TestMethod]
    public async Task TenantKeyCipherAndMetadataTamperingAreRejectedWithoutRewriting()
    {
        var key=Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));var owner=Owners.Create();
        var service=new PlatformCardDataProtector(new PortableEncryptionService(key),owner.Context.Object);var saved=await service.EncryptAsync(Card());var original=saved.EncryptedNumber;
        await CryptoFailure(()=>new PlatformCardDataProtector(new PortableEncryptionService(key),Owners.Create().Context.Object).DecryptAsync(saved));
        await CryptoFailure(()=>new PlatformCardDataProtector(new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))),owner.Context.Object).DecryptAsync(saved));
        await CryptoFailure(()=>service.DecryptAsync(saved with {CardHolderName="Other"}));
        await CryptoFailure(()=>service.DecryptAsync(saved with {KeyIdentifier="legacy-azure-version"}));
        var chars=original.ToCharArray();chars[^5]=chars[^5]=='A'?'B':'A';
        await CryptoFailure(()=>service.DecryptAsync(saved with {EncryptedNumber=new string(chars)}));
        Assert.AreEqual(original,saved.EncryptedNumber);
    }

    [TestMethod]
    public async Task ValidationAndExplicitSelectionRejectUnsafeOrMissingConfiguration()
    {
        var service=new PlatformCardDataProtector(new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))),Owners.Create().Context.Object);
        Assert.IsFalse(await service.ValidateAsync(Card() with {Number="4242424242424243"}));
        Assert.IsFalse(await service.ValidateAsync(Card() with {ExpiryMonth="00"}));Assert.IsFalse(await service.ValidateAsync(Card() with {Cvv="abc"}));
        Assert.IsFalse(await service.ValidateAsync(Card() with {ExpiryYear="01"}));
        var services=new ServiceCollection();services.AddCardProtection(new ConfigurationBuilder().Build());
        using(var provider=services.BuildServiceProvider())await Assert.ThrowsExceptionAsync<NotSupportedException>(()=>provider.GetRequiredService<ICardDataProtector>().ValidateAsync(Card()));
        Assert.IsFalse(services.Any(d=>d.ServiceType.FullName?.StartsWith("Azure.")==true));
        var configured=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{{"CardProtection:Provider","Platform"}}).Build();
        services=new ServiceCollection();services.AddSingleton<IWorkContext>(Owners.Create().Context.Object);services.AddSingleton<ITenantEncryptionService>(new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))));services.AddCardProtection(configured);
        using(var provider=services.BuildServiceProvider())Assert.IsInstanceOfType<PlatformCardDataProtector>(provider.GetRequiredService<ICardDataProtector>());
    }
}

[TestClass]
public sealed class FileStorageTests
{
    [TestMethod]
    public async Task PersistentVolumeWorksAcrossIndependentInstancesWithoutPublicPaths()
    {
        var directory=Path.Combine(Path.GetTempPath(),"portable-files-"+Guid.NewGuid().ToString("N"));
        try
        {
            var options=new FileSystemStorageOptions{RootDirectory=directory};var first=new FileSystemBlobStorageService(options);
            var reference=await first.UploadFileAsync(new MemoryStream([1,2,3]),"logo.png","app-assets","tenant/logo/android");
            Assert.IsFalse(reference.Contains(directory));Assert.IsTrue(await first.ContainerExistsAsync("app-assets"));
            var second=new FileSystemBlobStorageService(options);var file=await second.DownloadFileAsync(reference);
            await using(file.Content){using var bytes=new MemoryStream();await file.Content.CopyToAsync(bytes);CollectionAssert.AreEqual(new byte[]{1,2,3},bytes.ToArray());}
            Assert.AreEqual("image/png",file.ContentType);Assert.AreEqual(3L,file.Length);
            if(!OperatingSystem.IsWindows())Assert.AreEqual(UnixFileMode.UserRead|UnixFileMode.UserWrite,File.GetUnixFileMode(Path.Combine(directory,"app-assets/tenant/logo/android/logo.png")));
            Assert.IsTrue(await second.DeleteFileAsync("tenant/logo/android/logo.png","app-assets"));Assert.IsFalse(await second.DeleteFileAsync("tenant/logo/android/logo.png","app-assets"));
        }
        finally{if(Directory.Exists(directory))Directory.Delete(directory,true);}
    }

    [TestMethod]
    public async Task TraversalEncodedPathsAndForeignProviderReferencesAreRejected()
    {
        var directory=Path.Combine(Path.GetTempPath(),"portable-paths-"+Guid.NewGuid().ToString("N"));
        try
        {
            var storage=new FileSystemBlobStorageService(new(){RootDirectory=directory});
            foreach(var path in new[]{"../escape","a/../../escape","%2e%2e/escape","a\\escape","/absolute"})
                await Assert.ThrowsExceptionAsync<ArgumentException>(()=>storage.UploadFileAsync(new MemoryStream([1]),"file.png","app-assets",path));
            await Assert.ThrowsExceptionAsync<ArgumentException>(()=>storage.UploadFileAsync(new MemoryStream([1]),"../escape","app-assets"));
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.DownloadFileAsync("https://example.com/private"));
            Assert.AreEqual(0,Directory.GetFiles(directory,"*",SearchOption.AllDirectories).Length);
        }
        finally{if(Directory.Exists(directory))Directory.Delete(directory,true);}
    }

    [TestMethod]
    public async Task OversizedCancelledAndSymlinkWritesPreserveExistingData()
    {
        var directory=Path.Combine(Path.GetTempPath(),"portable-limits-"+Guid.NewGuid().ToString("N"));
        var outside=Path.Combine(Path.GetTempPath(),"portable-outside-"+Guid.NewGuid().ToString("N"));
        try
        {
            var storage=new FileSystemBlobStorageService(new(){RootDirectory=directory,MaxFileBytes=3});
            var reference=await storage.UploadFileAsync(new MemoryStream([1,2]),"file.png","app-assets");
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.UploadFileAsync(new MemoryStream([1,2,3,4]),"file.png","app-assets"));
            using var cancel=new CancellationTokenSource();cancel.Cancel();
            await Assert.ThrowsExceptionAsync<OperationCanceledException>(()=>storage.UploadFileAsync(new MemoryStream([9]),"file.png","app-assets",ct:cancel.Token));
            CollectionAssert.AreEqual(new byte[]{1,2},await File.ReadAllBytesAsync(Path.Combine(directory,"app-assets/file.png")));
            Assert.AreEqual(0,Directory.GetFiles(directory,"*.tmp",SearchOption.AllDirectories).Length);
            if(!OperatingSystem.IsWindows())
            {
                Directory.CreateDirectory(outside);Directory.CreateSymbolicLink(Path.Combine(directory,"app-assets/link"),outside);
                await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.UploadFileAsync(new MemoryStream([9]),"secret","app-assets","link"));
                Assert.AreEqual(0,Directory.GetFiles(outside).Length);
                File.CreateSymbolicLink(Path.Combine(directory,"app-assets/dangling"),Path.Combine(outside,"missing"));
                await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.DownloadFileAsync("pfile:v1:app-assets/dangling"));
            }
        }
        finally{if(Directory.Exists(directory))Directory.Delete(directory,true);if(Directory.Exists(outside))Directory.Delete(outside,true);}
    }

    [TestMethod]
    public void PublicWebRootAndUnknownProvidersCannotBeSelected()
    {
        var content=Path.Combine(Path.GetTempPath(),Guid.NewGuid().ToString("N"));
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{{"FileStorage:Provider","FileSystem"},{"FileStorage:FileSystem:RootDirectory",Path.Combine(content,"wwwroot","uploads")}}).Build();
        Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddFileStorage(config,content));
        config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{{"FileStorage:Provider","Unknown"}}).Build();
        Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddFileStorage(config,content));
    }
}

internal sealed class TestContext(DbContextOptions<ApplicationDbContext> options):ApplicationDbContext(options)
{
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        foreach(var type in builder.Model.GetEntityTypes())foreach(var property in type.GetProperties().Where(p=>p.ClrType==typeof(JsonDocument)).ToArray())
            builder.Entity(type.ClrType).Property<JsonDocument>(property.Name).HasConversion(v=>v.RootElement.GetRawText(),v=>JsonDocument.Parse(v,new JsonDocumentOptions()));
    }
}
