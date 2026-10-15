using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Platform.Google.Tests;

[TestClass]
public sealed class GoogleAdapterTests
{
    [TestMethod]
    public async Task CloudStepPersistsTenantConfigButCheckpointsOnlyPublicIds()
    {
        using var server = new GoogleServer(); var secrets = new MemorySecrets(); var spec = GoogleProvisioningTests.Tenant();
        var request = new TenantProvisioningRequest(spec.TenantId, "contract-store", spec.DisplayName, spec.OwnerEmail,"Owner","Example","Address","Phone",spec.OwnerEmail,spec.AndroidPackageName,spec.IosBundleId);
        var step = new GoogleTenantStep(new GoogleTenantProvisioner(server.Client(), GoogleProvisioningTests.Options()), secrets, GoogleProvisioningTests.Options());
        var result = await step.ExecuteAsync(request, new Dictionary<string,ProvisioningStepResult>(), default);
        var config = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(await secrets.GetAsync(spec.TenantId,TenantFirebaseConfiguration.SecretName))!;
        Assert.AreEqual(spec.TenantId, config.TenantId); Assert.AreEqual(config.ProjectId, result.Resources["projectId"]);
        Assert.IsFalse(JsonSerializer.Serialize(result).Contains("SenderServiceAccount"));
        Assert.IsFalse(JsonSerializer.Serialize(result).Contains("configFileContents"));
        await step.ExecuteAsync(request, new Dictionary<string,ProvisioningStepResult>(), default);
        Assert.AreEqual(1,server.ProjectCreates);
        await secrets.SetAsync(spec.TenantId,TenantFirebaseConfiguration.SecretName,JsonSerializer.Serialize(config with {ProjectId="other-project"}));
        var writes=server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>step.ExecuteAsync(request,new Dictionary<string,ProvisioningStepResult>(),default));
        Assert.AreEqual(writes,server.Writes);
        var other = GoogleProvisioningTests.Tenant().TenantId;
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(() => secrets.GetAsync(other,TenantFirebaseConfiguration.SecretName));
    }

    [TestMethod]
    public async Task ExportAndPublicationContainClientConfigurationOnly()
    {
        using var server = new GoogleServer(); var spec = GoogleProvisioningTests.Tenant(); var secrets = new MemorySecrets();
        var config = await new GoogleTenantProvisioner(server.Client(),GoogleProvisioningTests.Options()).EnsureAsync(spec,default);
        var directory = Path.Combine(Path.GetTempPath(), "google-publication-" + Guid.NewGuid().ToString("N"));
        try
        {
            await FirebaseClientFiles.ExportAsync(config,directory);
            var manifest = await File.ReadAllTextAsync(Path.Combine(directory,"firebase-client.json"));
            Assert.IsFalse(manifest.Contains(config.SenderServiceAccount)); Assert.IsFalse(manifest.Contains("private_key"));
            if (!OperatingSystem.IsWindows()) Assert.AreEqual(UnixFileMode.UserRead|UnixFileMode.UserWrite,File.GetUnixFileMode(Path.Combine(directory,"google-services.json")));
            await secrets.SetAsync(spec.TenantId,TenantFirebaseConfiguration.SecretName,JsonSerializer.Serialize(config));
            var options = new LocalOnboardingOptions {MobileDirectory=Path.Combine(directory,"mobile"),NotificationDirectory=Path.Combine(directory,"notifications"),RouteDirectory=Path.Combine(directory,"routes")};
            var request = new TenantProvisioningRequest(spec.TenantId,"contract-store",spec.DisplayName,spec.OwnerEmail,"Owner","Example","Address","Phone",spec.OwnerEmail,spec.AndroidPackageName,spec.IosBundleId);
            var completed = new Dictionary<string,ProvisioningStepResult> {
                ["store"] = new("Local",new Dictionary<string,string>{{"storeId","store-id"}}),
                ["google-firebase"] = new("Google",new Dictionary<string,string>{{"projectId",config.ProjectId}})
            };
            var result = await new LocalTenantPublicationStep(options,secrets).ExecuteAsync(request,completed,default);
            var published = JsonNode.Parse(await File.ReadAllTextAsync(Path.Combine(options.MobileDirectory,"contract-store.json")))!;
            Assert.IsTrue(published["firebase"]!["enabled"]!.GetValue<bool>());
            Assert.AreEqual(config.ProjectId,published["firebase"]!["projectId"]!.GetValue<string>());
            Assert.AreEqual("true",result.Resources["firebaseEnabled"]);
            Assert.IsFalse(published.ToJsonString().Contains(config.SenderServiceAccount));
        }
        finally { if(Directory.Exists(directory)) Directory.Delete(directory,true); }
    }

    [TestMethod]
    public void DefaultLocalPipelineHasNoGoogleStepOrCredentialResolution()
    {
        var directory = Path.Combine(Path.GetTempPath(), "google-disabled-" + Guid.NewGuid().ToString("N"));
        try
        {
            Directory.CreateDirectory(Path.Combine(directory,"wwwroot"));
            File.WriteAllText(Path.Combine(directory,"installer.dll"),""); File.WriteAllText(Path.Combine(directory,"commerce.json"),"{}"); File.WriteAllText(Path.Combine(directory,"wwwroot","logo.png"),"");
            var values = new Dictionary<string,string?> {
                ["LocalDemo:Enabled"]="true",["Provisioning:Google:Provider"]="Disabled",
                ["Provisioning:Local:InstallerPath"]=Path.Combine(directory,"installer.dll"),["Provisioning:Local:CommerceConfigPath"]=Path.Combine(directory,"commerce.json"),
                ["Provisioning:Local:MongoAdminConnection"]="mongodb://127.0.0.1:27017",["Provisioning:Local:KeycloakAdminPassword"]="test-placeholder"
            };
            foreach(var key in new[]{"WorkingDirectory","TenantDirectory","RouteDirectory","SecretDirectory","NotificationDirectory","MobileDirectory"}) values["Provisioning:Local:"+key]=Path.Combine(directory,key);
            var config = new ConfigurationBuilder().AddInMemoryCollection(values).Build(); var services = new ServiceCollection();
            services.AddLocalOnboarding(config,"Development");
            Assert.AreEqual(5,services.Count(d=>d.ServiceType==typeof(IProvisioningStep)));
            Assert.IsFalse(services.Any(d=>d.ServiceType==typeof(IGoogleAccessTokenSource)));
            values["Provisioning:Google:Provider"]="Google";
            Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddLocalOnboarding(new ConfigurationBuilder().AddInMemoryCollection(values).Build(),"Development"));
        }
        finally { if(Directory.Exists(directory)) Directory.Delete(directory,true); }
    }
}

internal sealed class MemorySecrets : ITenantSecrets
{
    private readonly Dictionary<(string,string),string> values=[];
    public Task ProvisionAsync(string tenantId,string alias,CancellationToken cancellationToken=default)=>Task.CompletedTask;
    public Task BindAliasAsync(string tenantId,string alias,CancellationToken cancellationToken=default)=>Task.CompletedTask;
    public Task<string> ResolveAsync(string tenantId,CancellationToken cancellationToken=default)=>Task.FromResult(tenantId);
    public Task<string> GetAsync(string tenantId,string name,CancellationToken cancellationToken=default)=>Task.FromResult(values[(tenantId,name)]);
    public Task SetAsync(string tenantId,string name,string value,CancellationToken cancellationToken=default){values[(tenantId,name)]=value;return Task.CompletedTask;}
    public Task<string> GetOrCreateAsync(string tenantId,string name,Func<string> generate,CancellationToken cancellationToken=default){if(!values.ContainsKey((tenantId,name)))values[(tenantId,name)]=generate();return GetAsync(tenantId,name);}
}
