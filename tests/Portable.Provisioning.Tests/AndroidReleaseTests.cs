using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class AndroidReleaseTests
{
    [TestMethod]
    public async Task ManualReleaseGetsANewVersionWithoutReplacingInitialBindingsOrSigningKey()
    {
        using var f=new AndroidFixture();var initial=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        var saved=f.Secrets.Values.Where(p=>p.Key.Item2.Contains("initial-release")).ToDictionary(p=>p.Key,p=>p.Value);
        f.Completed["mobile-android-release"]=initial;var id=Guid.NewGuid();
        f.Server.BuildVersion="2";
        var release=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,id,2);
        var replay=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,id,2);
        Assert.AreEqual("2",release.Resources["buildNumber"]);Assert.AreEqual(release.Resources["sha256"],replay.Resources["sha256"]);
        Assert.AreNotEqual(initial.Resources["sha256"],release.Resources["sha256"]);
        Assert.AreEqual(initial.Resources["signingCertificateSha256"],release.Resources["signingCertificateSha256"]);
        Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(2,f.Builder.Builds);
        foreach(var value in saved)Assert.AreEqual(value.Value,f.Secrets.Values[value.Key]);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,id,3));
        f.Secrets.Values.TryRemove((f.Request.TenantId,TenantAndroidSigningKeys.SecretName),out _);
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,Guid.NewGuid(),3));
        Assert.AreEqual(1,f.Keys.Creates);
    }
    [TestMethod]
    public async Task AWorkerCannotSkipAnExplicitlyRequestedMobileRelease()
    {
        using var f=new AndroidFixture();
        var guard=new PortableDeploymentGuard(f.Deployment,new TenantDomainOptions(),f.Secrets);
        var error=await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>guard.ValidateAsync(f.Request,f.Completed,default));
        StringAssert.Contains(error.Message,"mobile policy");Assert.AreEqual(0,f.Keys.Creates);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ValidateSavedPlanAsync(f.Request with{MobileReleaseProfile="Disabled"},false,default));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ValidateSavedPlanAsync(f.Request with{MobileReleaseProfile=null},false,default));
    }
    [TestMethod]
    public async Task AFailedNativeSignatureCheckNeverPersistsOrDistributesTheCandidate()
    {
        using var f=new AndroidFixture();f.Builder.RejectSignature=true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        Assert.AreEqual(0,f.Server.Requests);Assert.IsFalse(f.Secrets.Values.ContainsKey((f.Request.TenantId,AndroidReleasePipeline.ArtifactSecret)));
    }
    [TestMethod]
    public void UnsupportedMobilePolicyAndLocalAutomaticSigningAreRejected()
    {
        using var f=new AndroidFixture();Assert.ThrowsException<ArgumentException>(()=>(f.Request with{MobileReleaseProfile="Unknown"}).Validate());
        var error=Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddLocalOnboarding(f.Configuration(("Provisioning:Mobile:Provider","AndroidAppDistribution")),"Development"));
        StringAssert.Contains(error.Message,"Portable Production");
    }
    [TestMethod]
    public async Task FailedBuildRemovesPlaintextKeysAndLargeCopiedSourcesButRetainsItsPrivateLog()
    {
        if(OperatingSystem.IsWindows()){Assert.Inconclusive("POSIX fixture tool");return;}
        using var f=new AndroidFixture();var tool=Path.Combine(f.Root,"fixture-tool.sh");
        await File.WriteAllTextAsync(tool,"""
            #!/bin/sh
            if [ "$1" = "--version" ]; then
              printf '%s\n' '{"frameworkVersion":"3.44.6","frameworkRevision":"ee80f08bbf97172ec030b8751ceab557177a34a6"}'
              exit 0
            fi
            previous=""
            for value in "$@"; do
              if [ "$previous" = "--workspace" ]; then
                mkdir -p "$value"
                printf '%s\n' 'Synthetic compiler failure' > "$value/build.log"
                exit 1
              fi
              previous="$value"
            done
            exit 2
            """);
        File.SetUnixFileMode(tool,UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.UserExecute);
        var options=new AndroidReleaseOptions{SourceDirectory=f.Options.SourceDirectory,WorkingDirectory=f.Options.WorkingDirectory,ArtifactDirectory=f.Options.ArtifactDirectory,
            PythonPath=tool,FlutterPath=tool,AndroidSdkDirectory=f.Options.AndroidSdkDirectory};
        var key=await f.Keys.CreateAsync(f.Request.TenantId,f.Firebase.AndroidPackageName,default);
        var plan=new AndroidReleasePlan(1,f.Request.TenantId,f.Deployment.DeploymentId,f.Firebase.AndroidPackageName,f.Firebase.ProjectId,f.Firebase.ProjectNumber,f.Firebase.AndroidAppId,
            f.Deployment.StoreUrl(f.Request.Slug),1,new string('a',64),key.CertificateSha256,f.Options.ArtifactDirectory);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new AndroidReleaseBuilder(options).BuildAsync(f.Request,f.Firebase,key,plan,default));
        Assert.IsFalse(Directory.GetFiles(options.WorkingDirectory,"signing.p12",SearchOption.AllDirectories).Any());
        Assert.IsFalse(Directory.GetFiles(options.WorkingDirectory,"signing.properties",SearchOption.AllDirectories).Any());
        Assert.IsFalse(Directory.GetDirectories(options.WorkingDirectory,"workspace",SearchOption.AllDirectories).Any());
        var log=Directory.GetFiles(options.WorkingDirectory,"build.log",SearchOption.AllDirectories).Single();StringAssert.Contains(await File.ReadAllTextAsync(log),"Synthetic compiler failure");
    }
    [TestMethod]
    public void EnabledPortableConfigurationResolvesTheActualOrderedPipeline()
    {
        using var f=new Fixture();using var mobile=new AndroidFixture();
        f.Values["Provisioning:Profile"]="Portable";
        f.Values["Provisioning:Google:Provider"]="Google";f.Values["Provisioning:Google:AllowCloudWrites"]="true";
        f.Values["Provisioning:Google:Parent"]=mobile.Google.Parent;f.Values["Provisioning:Google:DeploymentId"]=mobile.Google.DeploymentId;
        f.Values["Provisioning:Google:ProjectIdPrefix"]=mobile.Google.ProjectIdPrefix;f.Values["Provisioning:Google:SenderServiceAccount"]=mobile.Google.SenderServiceAccount;
        f.Values["Provisioning:Mobile:Provider"]="AndroidAppDistribution";
        foreach(var property in typeof(AndroidReleaseOptions).GetProperties().Where(p=>p.CanWrite))
            f.Values["Provisioning:Mobile:Android:"+property.Name]=Convert.ToString(property.GetValue(mobile.Options),System.Globalization.CultureInfo.InvariantCulture);
        var services=new ServiceCollection();services.AddSingleton<Platform.Security.ITenantSecrets>(mobile.Secrets);
        services.AddSingleton<Platform.Security.ITenantEncryptionService,RegistrationOnlyEncryption>();
        services.AddSingleton<IAndroidSigningKeyFactory>(mobile.Keys);services.AddSingleton<IAndroidReleaseBuilder>(mobile.Builder);
        services.AddPortableOnboarding(f.Config(),"Production");using var provider=services.BuildServiceProvider();using var scope=provider.CreateScope();
        var steps=scope.ServiceProvider.GetServices<IProvisioningStep>().Select(s=>s.Name).ToArray();
        Assert.AreEqual(11,steps.Length);Assert.AreEqual("publication",steps[^2]);Assert.AreEqual("mobile-android-release",steps[^1]);
        Assert.AreEqual(2,scope.ServiceProvider.GetServices<IProvisioningGuard>().Count());
    }
    [TestMethod]
    public async Task SuccessfulReleaseReplaysWithTheSameKeyBinaryAndDistributionWithoutNewWrites()
    {
        using var f=new AndroidFixture();var first=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        var stored=f.Secrets.Values[(f.Request.TenantId,TenantAndroidSigningKeys.SecretName)];
        var replay=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        Assert.AreEqual(2, f.Server.CertificateWrites);
        Assert.AreEqual(first.Resources["sha256"],replay.Resources["sha256"]);Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(1,f.Builder.Builds);
        Assert.AreEqual(1,f.Server.Uploads);Assert.AreEqual(1,f.Server.Deliveries);Assert.AreEqual(1,f.Server.ReleaseReads);
        Assert.AreEqual(stored,f.Secrets.Values[(f.Request.TenantId,TenantAndroidSigningKeys.SecretName)]);
        var publicState=JsonSerializer.Serialize(first);Assert.IsFalse(publicState.Contains("Password"));Assert.IsFalse(publicState.Contains("KeyStoreBase64"));Assert.IsFalse(publicState.Contains(f.Root));
    }
    [TestMethod]
    public async Task FingerprintsMustBeRetainedBeforeUploadAndRetryKeepsTheSameSignedBinary()
    {
        using var f = new AndroidFixture(); f.Server.FailCertificateOnce = true;
        await Assert.ThrowsExceptionAsync<GoogleApiException>(() => f.Pipeline().ExecuteAsync(f.Request, f.Completed, default));
        Assert.AreEqual(0, f.Server.Uploads); Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(1, f.Keys.Creates);
        await f.Pipeline().ExecuteAsync(f.Request, f.Completed, default);
        Assert.AreEqual(3, f.Server.CertificateWrites); Assert.AreEqual(1, f.Server.Uploads);
        Assert.AreEqual(1, f.Builder.Builds); Assert.AreEqual(1, f.Keys.Creates);
        await f.Pipeline().ExecuteAsync(f.Request, f.Completed, default);
        Assert.AreEqual(3, f.Server.CertificateWrites);
    }
    [TestMethod]
    public async Task ProviderUploadFailureRetriesTheSameDurableBinaryWithoutRegeneratingTheKey()
    {
        using var f=new AndroidFixture();f.Server.FailUploadOnce=true;
        await Assert.ThrowsExceptionAsync<GoogleApiException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        var replay=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        Assert.AreEqual(1,f.Builder.Builds);Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(2,f.Server.Uploads);
        Assert.AreEqual(f.Server.BinaryHashes[0],f.Server.BinaryHashes[1]);Assert.AreEqual("AndroidAppDistribution",replay.Provider);
    }
    [TestMethod]
    public async Task DistributionFailureReusesTheOriginalVerifiedArtifact()
    {
        using var f=new AndroidFixture();f.Server.FailDistributeOnce=true;
        await Assert.ThrowsExceptionAsync<GoogleApiException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        Assert.AreEqual(1,f.Builder.Builds);Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(2,f.Server.Uploads);Assert.AreEqual(1,f.Server.Deliveries);
        Assert.AreEqual(f.Server.BinaryHashes[0],f.Server.BinaryHashes[1]);
    }
    [TestMethod]
    public async Task SeparateTenantsReceiveDifferentSigningKeysPackagesAndArtifacts()
    {
        using var f=new AndroidFixture();var first=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        var request=f.Request with{TenantId=Guid.NewGuid().ToString("N"),Slug="second-android"};var firebase=f.AddTenant(request);
        var second=await f.Pipeline().ExecuteAsync(request,f.Checkpoints(request,firebase),default);
        Assert.AreNotEqual(first.Resources["signingCertificateSha256"],second.Resources["signingCertificateSha256"]);
        Assert.AreNotEqual(first.Resources["androidApplicationId"],second.Resources["androidApplicationId"]);
        Assert.AreNotEqual(first.Resources["sha256"],second.Resources["sha256"]);Assert.AreEqual(2,f.Keys.Creates);
    }
    [TestMethod]
    public async Task ConcurrentSigningCreationSelectsOnePersistedKeyAcrossServiceInstances()
    {
        using var f=new AndroidFixture();var first=new TenantAndroidSigningKeys(f.Secrets,f.Keys);var second=new TenantAndroidSigningKeys(f.Secrets,f.Keys);
        var values=await Task.WhenAll(first.GetOrCreateAsync(f.Request.TenantId,f.Firebase.AndroidPackageName,default),second.GetOrCreateAsync(f.Request.TenantId,f.Firebase.AndroidPackageName,default));
        Assert.AreEqual(values[0],values[1]);Assert.AreEqual(1,f.Secrets.Values.Count(x=>x.Key.Item2==TenantAndroidSigningKeys.SecretName));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>first.ReadAsync(f.Request.TenantId,"com.example.foreign",default));
        Assert.AreEqual(values[0],await first.ReadAsync(f.Request.TenantId,f.Firebase.AndroidPackageName,default));
    }
    [TestMethod]
    public async Task PackageSigningRetainsTheLegacyCertificateAndKeepsNewPackagesSeparate()
    {
        using var f = new AndroidFixture(); var keys = new TenantAndroidSigningKeys(f.Secrets, f.Keys);
        var old = await keys.GetOrCreateAsync(f.Request.TenantId, f.Firebase.AndroidPackageName, default);
        Assert.AreEqual(old, await keys.GetOrCreatePackageAsync(f.Request.TenantId, old.PackageName, default));
        var next = await keys.GetOrCreatePackageAsync(f.Request.TenantId, "com.customer.newstore", default);
        Assert.AreNotEqual(old.CertificateSha256, next.CertificateSha256);
        Assert.AreEqual(next, await keys.ReadPackageAsync(f.Request.TenantId, next.PackageName, default));
        Assert.AreEqual(next, await keys.GetOrCreatePackageAsync(f.Request.TenantId, next.PackageName, default));
        Assert.AreEqual(old, await keys.ReadAsync(f.Request.TenantId, old.PackageName, default)); Assert.AreEqual(2, f.Keys.Creates);
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(() => keys.ReadPackageAsync(f.Request.TenantId, "com.other.app", default));
    }
    [TestMethod]
    public async Task AForeignOrCorruptSavedPackageKeyIsNeverReplaced()
    {
        using var f = new AndroidFixture(); var keys = new TenantAndroidSigningKeys(f.Secrets, f.Keys);
        var old = await keys.GetOrCreatePackageAsync(f.Request.TenantId, "com.customer.newstore", default);
        var name = (f.Request.TenantId, TenantAndroidSigningKeys.PackageSecretName(old.PackageName));
        f.Secrets.Values[name] = JsonSerializer.Serialize(old with { PackageName = "com.foreign.app" }, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => keys.GetOrCreatePackageAsync(f.Request.TenantId, old.PackageName, default));
        Assert.AreEqual(1, f.Keys.Creates);
    }
    [TestMethod]
    public async Task ReadDoesNotCreateAnAbsentSigningKey()
    {
        using var f=new AndroidFixture();var keys=new TenantAndroidSigningKeys(f.Secrets,f.Keys);
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>keys.ReadAsync(f.Request.TenantId,f.Firebase.AndroidPackageName,default));Assert.AreEqual(0,f.Keys.Creates);
    }
    [TestMethod]
    public async Task ReadinessAndGoogleAreRequiredBeforeCreatingKeysOrBuilding()
    {
        using var f=new AndroidFixture();f.Completed.Remove("publication");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        Assert.AreEqual(0,f.Keys.Creates);Assert.AreEqual(0,f.Builder.Builds);Assert.AreEqual(0,f.Server.Requests);
    }
    [TestMethod]
    public async Task ForeignSavedFirebaseAppCannotBuildOrPublish()
    {
        using var f=new AndroidFixture();f.Secrets.Values[(f.Request.TenantId,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(f.Firebase with{TenantId=Guid.NewGuid().ToString("N")});
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        Assert.AreEqual(0,f.Keys.Creates);Assert.AreEqual(0,f.Builder.Builds);Assert.AreEqual(0,f.Server.Requests);
    }
    [DataTestMethod]
    [DataRow("source")][DataRow("version")][DataRow("certificate")][DataRow("tenant")]
    public async Task BuiltArtifactMustMatchEveryImmutableTenantReleaseBinding(string change)
    {
        using var f=new AndroidFixture();f.Builder.Alter=receipt=>change switch{
            "source"=>receipt with{SourceHash=new string('b',64)},"version"=>receipt with{BuildNumber=2},
            "certificate"=>receipt with{SigningCertificateSha256=new string('b',64)},_=>receipt with{TenantId=Guid.NewGuid().ToString("N")}};
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        Assert.AreEqual(0,f.Server.Uploads);Assert.IsFalse(f.Secrets.Values.ContainsKey((f.Request.TenantId,AndroidReleasePipeline.ArtifactSecret)));
    }
    [TestMethod]
    public async Task AChangedSourceIsRejectedEvenForCheckpointOnlyReplay()
    {
        using var f=new AndroidFixture();await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);var before=f.Server.Requests;
        f.Builder.SourceHash=new string('b',64);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new AndroidReleaseGuard(f.Pipeline()).ValidateAsync(f.Request,new Dictionary<string,ProvisioningStepResult>{{"mobile-android-release",new("AndroidAppDistribution",new Dictionary<string,string>())}},default));
        Assert.AreEqual(1,f.Builder.Builds);Assert.AreEqual(before,f.Server.Requests);Assert.AreEqual(1,f.Keys.Creates);
    }
    [TestMethod]
    public async Task CheckpointCannotAdoptAMissingOriginalMobilePlan()
    {
        using var f=new AndroidFixture();await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new AndroidReleaseGuard(f.Pipeline()).ValidateAsync(f.Request,new Dictionary<string,ProvisioningStepResult>{{"mobile-android-release",new("AndroidAppDistribution",new Dictionary<string,string>())}},default));
        Assert.AreEqual(0,f.Keys.Creates);Assert.AreEqual(0,f.Builder.Builds);
    }
    [TestMethod]
    public async Task ChangedOrMissingDurableApkIsNeverRebuiltOrDistributedAsTheSameVersion()
    {
        using var f=new AndroidFixture();var result=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);var writes=f.Server.Uploads;
        var path=Path.Combine(f.Options.ArtifactDirectory,f.Request.TenantId,result.Resources["sha256"]+".apk");await File.WriteAllTextAsync(path,"changed");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));Assert.AreEqual(writes,f.Server.Uploads);Assert.AreEqual(1,f.Builder.Builds);
        File.Delete(path);await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));Assert.AreEqual(1,f.Builder.Builds);
    }
    [TestMethod]
    public async Task CachedDistributionStillChecksCurrentCloudOwnershipAndBuildVersion()
    {
        using var f=new AndroidFixture();await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);f.Server.ForeignProject=true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));
        f.Server.ForeignProject=false;f.Server.BuildVersion="2";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));Assert.AreEqual(1,f.Server.Uploads);Assert.AreEqual(1,f.Server.Deliveries);
    }
    [TestMethod]
    public async Task CorruptSigningMaterialIsNotSilentlyRotated()
    {
        using var f=new AndroidFixture();await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);var name=(f.Request.TenantId,TenantAndroidSigningKeys.SecretName);
        var key=JsonSerializer.Deserialize<AndroidSigningKey>(f.Secrets.Values[name],new JsonSerializerOptions(JsonSerializerDefaults.Web))!;
        f.Secrets.Values[name]=JsonSerializer.Serialize(key with{CertificateSha256=new string('b',64)},new JsonSerializerOptions(JsonSerializerDefaults.Web));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default));Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(1,f.Server.Uploads);
    }
    [DataTestMethod]
    [DataRow("Provisioning:Google:AllowCloudWrites","false")][DataRow("Provisioning:Google:Provider","Disabled")]
    [DataRow("PlatformSecurity:ReadOnly","true")][DataRow("PlatformSecurity:Provider","Local")][DataRow("LocalDemo:Enabled","true")]
    public void SigningRequiresExplicitPortableCloudAndWritableEncryptedSecrets(string key,string value)
    {
        using var f=new AndroidFixture();Assert.ThrowsException<InvalidOperationException>(()=>f.Options.Validate(f.Configuration((key,value)),"Production"));
    }
    [TestMethod]
    public void ValidProductionConfigurationAndDisabledDefaultAreExplicit()
    {
        using var f=new AndroidFixture();f.Options.Validate(f.Configuration(),"Production");
        Assert.ThrowsException<InvalidOperationException>(()=>f.Options.Validate(f.Configuration(),"Development"));
        var services=new ServiceCollection();services.AddAndroidReleases(f.Configuration(),"Production");Assert.AreEqual(0,services.Count);
    }
}

internal sealed class RegistrationOnlyEncryption : Platform.Security.ITenantEncryptionService
{
    public Task<string> EncryptAsync(string value,string key)=>throw new InvalidOperationException("DI resolution must not perform provider operations.");
    public Task<string> DecryptAsync(string value,string key)=>throw new InvalidOperationException("DI resolution must not perform provider operations.");
    public Task<string> EncryptWithHybridMethod(string value,string key)=>throw new InvalidOperationException("DI resolution must not perform provider operations.");
    public Task<string> DecryptWithHybridMethod(string value,string key)=>throw new InvalidOperationException("DI resolution must not perform provider operations.");
}
