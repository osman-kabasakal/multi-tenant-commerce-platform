using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class ManagedTenantTests
{
    [TestMethod]
    public void ProductionUsesTheOriginalOrderedTenantPhasesBeforeIdentityAndPublication()
    {
        using var f=new Fixture();var services=new ServiceCollection();
        services.AddSingleton<ITenantSecrets>(new MemorySecrets());services.AddSingleton<ITenantEncryptionService,RegistrationOnlyEncryption>();services.AddPortableOnboarding(f.Config(),"Production");
        using var provider=services.BuildServiceProvider();
        CollectionAssert.AreEqual(new[]{"tenant-secrets","database","store","tenant-plugins","tenant-migrations","tenant-settings","identity","domains","publication"},provider.GetServices<IProvisioningStep>().Select(x=>x.Name).ToArray());
    }
    [DataTestMethod]
    [DataRow("tenant-plugins","store")]
    [DataRow("tenant-migrations","tenant-plugins")]
    [DataRow("tenant-settings","tenant-migrations")]
    public async Task MissingPrecedingPhaseCannotStartAnInstaller(string phase,string prerequisite)
    {
        using var f=new Fixture();var request=Fixture.Request();var done=Fixture.Completed(request);done.Remove(prerequisite);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new ManagedTenantStep(phase,f.Options(),new MemorySecrets()).ExecuteAsync(request,done,default));
        Assert.IsFalse(Directory.GetFiles(f.Options().WorkingDirectory,"*",SearchOption.AllDirectories).Any());
    }
    [DataTestMethod]
    [DataRow("tenant-migrations")]
    [DataRow("tenant-settings")]
    public async Task CheckpointsCannotBeReplayedForAnotherStore(string phase)
    {
        using var f=new Fixture();var request=Fixture.Request();var options=f.Options();
        await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+".json"),JsonSerializer.Serialize(new{profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId="store-owned"}));
        await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+"."+phase+".json"),JsonSerializer.Serialize(new{version=1,profile="Portable",task=phase,tenantId=request.TenantId,slug=request.Slug,storeId="foreign-store"}));
        var secrets=new MemorySecrets();secrets.Aliases["store-owned"]=request.TenantId;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new ManagedTenantStep(phase,options,secrets).ExecuteAsync(request,Fixture.Completed(request),default));
    }
    [TestMethod]
    public async Task OwnedPhaseReplayKeepsTheSameStoreAndDoesNotRerunTheInstaller()
    {
        using var f=new Fixture();var request=Fixture.Request();var options=f.Options();var secrets=new MemorySecrets();secrets.Aliases["store-owned"]=request.TenantId;
        await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+".json"),JsonSerializer.Serialize(new{profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId="store-owned"}));
        foreach(var phase in ManagedTenantStep.Tasks)
        {
            await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+"."+phase+".json"),JsonSerializer.Serialize(new{version=1,profile="Portable",task=phase,tenantId=request.TenantId,slug=request.Slug,storeId="store-owned"}));
            var step=new ManagedTenantStep(phase,options,secrets);
            var first=await step.ExecuteAsync(request,Fixture.Completed(request),default);var replay=await step.ExecuteAsync(request,Fixture.Completed(request),default);
            Assert.AreEqual(first.Resources["storeId"],replay.Resources["storeId"]);Assert.AreEqual("1",replay.Resources["profileVersion"]);
        }
    }
    [DataTestMethod]
    [DataRow("tenant-plugins")]
    [DataRow("tenant-migrations")]
    [DataRow("tenant-settings")]
    public async Task PublicationRefusesIncompleteBusinessInstallationBeforeWritingRoutes(string missing)
    {
        using var f=new Fixture();var request=Fixture.Request();var options=f.Options();var done=Fixture.Completed(request);done.Remove(missing);
        var calls=0;var http=new Factory((_,_)=>{calls++;return Task.FromResult(Factory.Json(new{}));});
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new PortableTenantPublicationStep(options,new MemorySecrets(),http).ExecuteAsync(request,done,default));
        Assert.AreEqual(0,calls);Assert.IsFalse(File.Exists(Path.Combine(options.RouteDirectory,request.Slug+".json")));
    }
    [TestMethod]
    public async Task SavedSettingsAndStoreMetadataDoNotProveBaseInstallationCompleted()
    {
        using var f=new Fixture();var request=Fixture.Request();var options=f.Options();
        await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+".json"),JsonSerializer.Serialize(new{profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId="store-owned"}));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new StoreInstallerStep(options,new MemorySecrets()).ExecuteAsync(request,Fixture.Completed(request),default));
    }

    [TestMethod]
    public async Task VerifiedBaseInstallationMetadataCanReplayWithoutLaunchingAnInstaller()
    {
        using var f=new Fixture();var request=Fixture.Request();var options=f.Options();var secrets=new MemorySecrets();
        await File.WriteAllTextAsync(Path.Combine(options.TenantDirectory,request.Slug+".json"),JsonSerializer.Serialize(new{profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId="store-owned",baseInstallationVerified=true}));
        var result=await new StoreInstallerStep(options,secrets).ExecuteAsync(request,Fixture.Completed(request),default);
        Assert.AreEqual("store-owned",result.Resources["storeId"]);
    }

}
