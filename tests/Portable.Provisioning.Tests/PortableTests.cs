using Microsoft.Extensions.Configuration;
using System.Net;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class PortableTests
{
    [TestMethod]
    public void ProductionPipelineIsExplicitAndLocalProfileStillRejectsProduction()
    {
        using var f=new Fixture();var services=new ServiceCollection();services.AddPortableOnboarding(f.Config(),"Production");
        Assert.AreEqual(6,services.Count(x=>x.ServiceType==typeof(IProvisioningStep)));Assert.AreEqual(1,services.Count(x=>x.ServiceType==typeof(IProvisioningGuard)));
        Assert.IsFalse(services.Any(x=>x.ServiceType.Name=="IGoogleAccessTokenSource"));
        Assert.ThrowsException<InvalidOperationException>(()=>new LocalOnboardingOptions().Validate("Production",f.Config()));
        f.Values["LocalDemo:Enabled"]="true";Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddPortableOnboarding(f.Config(),"Production"));
    }
    [DataTestMethod]
    [DataRow("StoreBaseUrl","http://shops.example.test")]
    [DataRow("KeycloakAuthority","https://identity.example.test/realms/commerce")]
    [DataRow("KeycloakAdminClientSecret","")]
    [DataRow("MongoAdminConnection","mongodb://127.0.0.1:27028")]
    [DataRow("RouteDirectory","relative-directory")]
    public void InvalidProductionInputsFailBeforeClaims(string key,string value)
    {using var f=new Fixture();f.Values["Provisioning:Portable:"+key]=value;Assert.ThrowsException<InvalidOperationException>(()=>f.Options());}

    [TestMethod]
    public async Task TargetGuardRequiresRegistrationAndRejectsChangedInfrastructureOnReplay()
    {
        using var f=new Fixture();var request=Fixture.Request();var secrets=new MemorySecrets();var guard=new PortableDeploymentGuard(f.Options(),f.Domains(),secrets);
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>guard.ValidateAsync(request,new Dictionary<string,ProvisioningStepResult>(),default));Assert.AreEqual(0,secrets.Creates);
        await secrets.SetAsync(request.TenantId,TenantSecretNames.InitialPassword,"initial-placeholder");
        await guard.ValidateAsync(request,new Dictionary<string,ProvisioningStepResult>(),default);var stored=secrets.Values[(request.TenantId,PortableDeploymentGuard.SecretName)];
        await guard.ValidateAsync(request,Fixture.Completed(request),default);Assert.AreEqual(1,secrets.Creates);
        f.Values["Provisioning:Portable:KeycloakRealm"]="other-realm";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new PortableDeploymentGuard(f.Options(),f.Domains(),secrets).ValidateAsync(request,Fixture.Completed(request),default));
        Assert.AreEqual(stored,secrets.Values[(request.TenantId,PortableDeploymentGuard.SecretName)]);
    }
    [TestMethod]
    public async Task AJobForAnotherDeploymentCannotReadOrCreateTenantSecrets()
    {
        using var f=new Fixture();var secrets=new MemorySecrets();var request=Fixture.Request() with{DeploymentId="foreign-deployment"};
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new PortableDeploymentGuard(f.Options(),f.Domains(),secrets).ValidateAsync(request,new Dictionary<string,ProvisioningStepResult>(),default));
        Assert.AreEqual(0,secrets.Creates);Assert.AreEqual(0,secrets.Values.Count);
    }
    [TestMethod]
    public async Task LocalDemoAdaptersRejectProductionBoundJobsBeforeAnyStepRuns()
    {
        using var f=new Fixture();var values=f.Values.ToDictionary(p=>p.Key.Replace("Provisioning:Portable:","Provisioning:Local:"),p=>p.Value);
        values["LocalDemo:Enabled"]="true";values["Provisioning:Local:StoreBaseUrl"]="http://localhost:18090";values["Provisioning:Local:AdminBaseUrl"]="http://localhost:18083";
        values["Provisioning:Local:KeycloakAuthority"]="http://localhost:18080";values["Provisioning:Local:KeycloakAdminPassword"]="contract-password";values["Provisioning:Local:SecretDirectory"]=Path.Combine(f.Root,"SecretDirectory");
        var config=new Microsoft.Extensions.Configuration.ConfigurationBuilder().AddInMemoryCollection(values).Build();var services=new ServiceCollection();services.AddLocalOnboarding(config,"Development");
        using var provider=services.BuildServiceProvider();var guard=provider.GetServices<IProvisioningGuard>().Single();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>guard.ValidateAsync(Fixture.Request() with{DeploymentId="production"},new Dictionary<string,ProvisioningStepResult>(),default));
        await guard.ValidateAsync(Fixture.Request(),new Dictionary<string,ProvisioningStepResult>(),default);
    }
    [TestMethod]
    public void CanonicalBusinessIdsCannotCreateCaseVariantResourceNamespaces()
    {
        var request=Fixture.Request() with {TenantId="ABCDEF0123456789ABCDEF0123456789"};
        Assert.ThrowsException<ArgumentException>(()=>request.Validate());
    }
    [TestMethod]
    public async Task AdministrativeCredentialRotationDoesNotMoveTheTenantTarget()
    {
        using var f=new Fixture();var request=Fixture.Request();var secrets=new MemorySecrets();await secrets.SetAsync(request.TenantId,TenantSecretNames.InitialPassword,"initial-placeholder");
        await new PortableDeploymentGuard(f.Options(),f.Domains(),secrets).ValidateAsync(request,new Dictionary<string,ProvisioningStepResult>(),default);
        f.Values["Provisioning:Portable:MongoAdminConnection"]="mongodb://administrator:rotated-contract@127.0.0.1:27028/admin?authSource=admin";
        f.Values["Provisioning:Portable:KeycloakAdminClientSecret"]="rotated-contract";
        await new PortableDeploymentGuard(f.Options(),f.Domains(),secrets).ValidateAsync(request,Fixture.Completed(request),default);
        Assert.AreEqual(1,secrets.Creates);
    }
    [TestMethod]
    public async Task ACheckpointWithoutAnOriginalBindingCannotBeAdopted()
    {
        using var f=new Fixture();var secrets=new MemorySecrets();var request=Fixture.Request();await secrets.SetAsync(request.TenantId,TenantSecretNames.InitialPassword,"initial-placeholder");
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>new PortableDeploymentGuard(f.Options(),f.Domains(),secrets).ValidateAsync(request,Fixture.Completed(request),default));Assert.AreEqual(0,secrets.Creates);
    }
    [TestMethod]
    public async Task PublicationRequiresRealOwnedReadinessBeforeNotificationAndMobileReadiness()
    {
        using var f=new Fixture();var options=f.Options();var request=Fixture.Request();var secrets=new MemorySecrets();await secrets.SetAsync(request.TenantId,TenantSecretNames.KeycloakClient,"private-client-value");
        var ready=false;var foreign=false;
        var factory=new Factory(async(name,http)=> {
            if(name=="onboarding-keycloak") {StringAssert.Contains(await http.Content!.ReadAsStringAsync(),"private-client-value");return Factory.Json(new{access_token="contract-tenant-token"});}
            if (http.RequestUri!.AbsolutePath=="/Admin")
            {
                var redirect=new HttpResponseMessage(HttpStatusCode.Redirect);redirect.Headers.Location=new Uri("/Admin/Login",UriKind.Relative);redirect.Headers.Add("X-Platform-Tenant",request.TenantId);return redirect;
            }
            if (http.RequestUri.AbsolutePath=="/Admin/Login")
            {
                var login=new HttpResponseMessage(HttpStatusCode.OK){Content=new StringContent("<form></form>",System.Text.Encoding.UTF8,"text/html")};login.Headers.Add("X-Platform-Tenant",request.TenantId);return login;
            }
            Assert.IsFalse(http.Headers.Contains("x-store-token"),"Readiness must not succeed only because the worker supplied a privileged token.");
            Assert.AreEqual(options.StoreUrl(request.Slug)+"/_platform/ready",http.RequestUri!.ToString());
            return !ready?Factory.Json(new{},HttpStatusCode.ServiceUnavailable):Factory.Json(new{tenantId=foreign?Guid.NewGuid().ToString("N"):request.TenantId,storeId="store-owned"});
        });
        var step=new PortableTenantPublicationStep(options,secrets,factory);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>step.ExecuteAsync(request,Fixture.Completed(request),default));
        Assert.IsFalse(File.Exists(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json")));
        Assert.IsFalse(File.Exists(Path.Combine(options.MobileDirectory,request.Slug+".json")));
        ready=true;foreign=true;await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>step.ExecuteAsync(request,Fixture.Completed(request),default));
        foreign=false;var result=await step.ExecuteAsync(request,Fixture.Completed(request),default);Assert.AreEqual("Verified",result.Resources["readiness"]);
        var route=await File.ReadAllTextAsync(Path.Combine(options.RouteDirectory,request.Slug+".json"));Assert.IsFalse(route.Contains("private-client-value"));Assert.IsFalse(route.Contains("connectionString"));
        var mobile=JsonNode.Parse(await File.ReadAllTextAsync(Path.Combine(options.MobileDirectory,request.Slug+".json")))!;Assert.IsFalse(mobile["localDemo"]!.GetValue<bool>());
        Assert.IsTrue(File.Exists(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json")));
    }
    [DataTestMethod]
    [DataRow("foreign-tenant")]
    [DataRow("foreign-redirect")]
    public async Task AdminReadinessCannotPublishAForeignHostOrTenant(string failure)
    {
        using var f=new Fixture();var options=f.Options();var request=Fixture.Request();var calls=0;
        var factory=new Factory((_,http)=>{
            calls++;
            if(http.RequestUri!.AbsolutePath=="/_platform/ready")return Task.FromResult(Factory.Json(new{tenantId=request.TenantId,storeId="store-owned"}));
            var response=new HttpResponseMessage(HttpStatusCode.Redirect);
            response.Headers.Add("X-Platform-Tenant",failure=="foreign-tenant"?"foreign":request.TenantId);
            response.Headers.Location=new Uri(failure=="foreign-redirect"?"https://foreign.example.test/Admin/Login":"https://"+request.Slug+".manage.example.test/Admin/Login");
            return Task.FromResult(response);
        });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new PortableTenantPublicationStep(options,new MemorySecrets(),factory).ExecuteAsync(request,Fixture.Completed(request),default));
        Assert.AreEqual(2,calls);Assert.IsFalse(File.Exists(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json")));
        Assert.IsFalse(File.Exists(Path.Combine(options.MobileDirectory,request.Slug+".json")));
    }
    [TestMethod]
    public async Task PublicationRefusesToOverwriteAnotherTenantRoute()
    {
        using var f=new Fixture();var options=f.Options();var request=Fixture.Request();
        var path=Path.Combine(options.RouteDirectory,request.Slug+".json");await File.WriteAllTextAsync(path,"{\"profile\":\"Portable\",\"tenantId\":\"foreign\"}");
        var before=await File.ReadAllTextAsync(path);var calls=0;
        var factory=new Factory((_,_)=>{calls++;return Task.FromResult(Factory.Json(new{}));});
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new PortableTenantPublicationStep(options,new MemorySecrets(),factory).ExecuteAsync(request,Fixture.Completed(request),default));
        Assert.AreEqual(before,await File.ReadAllTextAsync(path));Assert.AreEqual(0,calls);
    }
}
