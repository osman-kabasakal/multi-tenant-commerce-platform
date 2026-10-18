using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Logging;
using Npgsql;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;
using Portable.Provisioning.Tests;

if(args.Length<1)throw new ArgumentException("Supply a private isolated fixture configuration.");
var config=new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[0])).Build();
var connection=config["PlatformSecurity:ConnectionString"]!;var parsed=new NpgsqlConnectionStringBuilder(connection);
if(parsed.Host!="127.0.0.1" || parsed.Port!=15441 || !System.Text.RegularExpressions.Regex.IsMatch(parsed.Database??"","^android_release_test_[a-f0-9]{32}$") || config.GetValue<bool>("LocalDemo:Enabled") || config["PlatformSecurity:Provider"]!="AesGcm")
    throw new InvalidOperationException("Only the uniquely named loopback PostgreSQL mobile fixture is allowed.");
var options=config.GetSection("Fixture:Android").Get<AndroidReleaseOptions>()!;
ServiceProvider SecretProvider()
{
    var services=new ServiceCollection();services.AddPlatformSecurity(config,"Production");return services.BuildServiceProvider();
}
static void Check(bool value,string message){if(!value)throw new InvalidOperationException(message);Console.WriteLine("PASS: "+message);}
if(args.Length>1 && args[1]=="read-key")
{
    using var child=SecretProvider();var store=child.GetRequiredService<ITenantSecrets>();
    var key=await new TenantAndroidSigningKeys(store,new KeytoolAndroidSigningKeyFactory(options)).ReadAsync(args[2],args[3],default);
    Check(key.CertificateSha256==args[4],"An independent process decrypts and verifies the existing tenant PKCS12 identity without generating another key.");return;
}
if(args.Length>1 && args[1]=="resume-worker")
{
    using var childSecrets=SecretProvider();var childStore=childSecrets.GetRequiredService<ITenantSecrets>();
    await using var childQueue=new PostgresProvisioningQueue(connection);var lease=await childQueue.ClaimAsync(TimeSpan.FromSeconds(3))??throw new InvalidOperationException("Missing restarted worker claim.");
    Check(lease.Job.Request.TenantId==args[2],"The independent worker process claims the original tenant job.");
    using var childFixture=new AndroidFixture();childFixture.Server.Tenants.Clear();
    var firebase=JsonSerializer.Deserialize<TenantFirebaseConfiguration>(await childStore.GetAsync(args[2],TenantFirebaseConfiguration.SecretName))!;
    childFixture.Server.Tenants.Add(firebase.ProjectId,firebase);
    var builder=new NativeFixtureBuilder(options){RefuseBuild=true};var services=new ServiceCollection();
    services.AddSingleton(childStore);services.AddSingleton(options);services.AddSingleton(childFixture.Deployment);services.AddSingleton(childFixture.Google);
    services.AddSingleton<IAndroidSigningKeyFactory>(new KeytoolAndroidSigningKeyFactory(options));services.AddScoped<TenantAndroidSigningKeys>();services.AddSingleton<IAndroidReleaseBuilder>(builder);
    services.AddSingleton(new FirebaseAppDistribution(new GoogleRestClient(new HttpClient(childFixture.Server,disposeHandler:false),new AndroidToken()),childFixture.Google));
    services.AddSingleton(new FirebaseAppIdentity(new GoogleRestClient(new HttpClient(childFixture.Server,disposeHandler:false),new AndroidToken()),childFixture.Google));
    services.AddScoped<AndroidReleasePipeline>();services.AddScoped<IProvisioningGuard,AndroidReleaseGuard>();services.AddScoped<IProvisioningStep,AndroidReleaseStep>();
    using var provider=services.BuildServiceProvider();
    var worker=new ProvisioningWorker(childQueue,provider.GetRequiredService<IServiceScopeFactory>(),new(){LeaseDuration=TimeSpan.FromSeconds(3),MaxAttempts=1},new IntegrationWorkerLogger());
    await worker.RunAsync(lease,default);var completed=(await childQueue.GetAsync(args[2]))!;
    Check(completed.State=="Succeeded" && builder.Builds==0,"An independent worker process finishes with the stored APK and no rebuild or in-memory signing/build state.");
    var result=Path.GetFullPath(args[3]);
    if(!result.StartsWith(Path.GetFullPath(options.WorkingDirectory)+Path.DirectorySeparatorChar,StringComparison.Ordinal))throw new InvalidOperationException("Unowned native worker fixture result.");
    await File.WriteAllTextAsync(result,JsonSerializer.Serialize(new{builds=builder.Builds,uploads=childFixture.Server.Uploads,deliveries=childFixture.Server.Deliveries,binaryHash=childFixture.Server.BinaryHashes.Single()}));
    return;
}
Directory.CreateDirectory(options.WorkingDirectory);Directory.CreateDirectory(options.ArtifactDirectory);
using var fixture=new AndroidFixture();
using var initial=SecretProvider();var secrets=initial.GetRequiredService<ITenantSecrets>();
await using var queue=new PostgresProvisioningQueue(connection);await queue.InitializeAsync();
var request=fixture.Request;
async Task SeedAsync(TenantProvisioningRequest tenant,TenantFirebaseConfiguration firebase,ITenantSecrets store)
{
    await store.ProvisionAsync(tenant.TenantId,tenant.Slug);
    await store.SetAsync(tenant.TenantId,TenantFirebaseConfiguration.SecretName,JsonSerializer.Serialize(firebase));
    await queue.EnqueueAsync(tenant);
}
var checkedCompletionGuard=false;
async Task<ProvisioningLease> ClaimPreparedAsync(TenantProvisioningRequest tenant,TenantFirebaseConfiguration firebase)
{
    var claim=await queue.ClaimAsync(TimeSpan.FromSeconds(3))??throw new InvalidOperationException("Missing isolated fixture claim.");
    Check(claim.Job.Request.TenantId==tenant.TenantId,"The real PostgreSQL lease selects the expected mobile tenant.");
    foreach(var step in fixture.Checkpoints(tenant,firebase))await queue.CheckpointAsync(claim,step.Key,step.Value);
    if(!checkedCompletionGuard)
    {
        try{await queue.CompleteAsync(claim);throw new InvalidOperationException("An older-style worker bypassed the required mobile step.");}
        catch(PostgresException error)when(error.SqlState=="23514")
        {Check((await queue.GetAsync(tenant.TenantId))!.State=="Running","The actual database rejects completion without the required signed-mobile checkpoint, including an older worker's SQL update.");}
        checkedCompletionGuard=true;
    }
    return claim with{Job=(await queue.GetAsync(tenant.TenantId))!};
}
ServiceProvider WorkerProvider(ITenantSecrets store,IAndroidReleaseBuilder builder)
{
    var services=new ServiceCollection();services.AddSingleton(store);services.AddSingleton(options);services.AddSingleton(fixture.Deployment);services.AddSingleton(fixture.Google);
    services.AddSingleton<IAndroidSigningKeyFactory>(new KeytoolAndroidSigningKeyFactory(options));services.AddScoped<TenantAndroidSigningKeys>();services.AddSingleton(builder);
    services.AddSingleton(new FirebaseAppDistribution(new GoogleRestClient(new HttpClient(fixture.Server,disposeHandler:false),new AndroidToken()),fixture.Google));
    services.AddSingleton(new FirebaseAppIdentity(new GoogleRestClient(new HttpClient(fixture.Server,disposeHandler:false),new AndroidToken()),fixture.Google));
    services.AddScoped<AndroidReleasePipeline>();services.AddScoped<IProvisioningGuard,AndroidReleaseGuard>();services.AddScoped<IProvisioningStep,AndroidReleaseStep>();return services.BuildServiceProvider();
}
async Task RunAsync(ServiceProvider provider,ProvisioningLease lease)
{
    var worker=new ProvisioningWorker(queue,provider.GetRequiredService<IServiceScopeFactory>(),new(){LeaseDuration=TimeSpan.FromSeconds(3),MaxAttempts=1},new IntegrationWorkerLogger());
    await worker.RunAsync(lease,default);
}
await SeedAsync(request,fixture.Firebase,secrets);
var builder1=new NativeFixtureBuilder(options){HoldBuild=true};fixture.Server.FailUploadOnce=true;
using(var worker=WorkerProvider(secrets,builder1))await RunAsync(worker,await ClaimPreparedAsync(request,fixture.Firebase));
var failed=(await queue.GetAsync(request.TenantId))!;
Console.WriteLine($"Native worker outcome: state={failed.State}; error={failed.ErrorCode??"none"}; builds={builder1.Builds}; uploads={fixture.Server.Uploads}");
Check(failed.State=="Failed" && failed.ErrorCode=="mobile-android-release:GoogleApiException","A real worker persists a safe retryable mobile failure after the synthetic provider outage.");
Check(builder1.Builds==1 && !failed.Steps.ContainsKey("mobile-android-release"),"A long native signing fixture retains its three-second lease and never checkpoints a failed release.");
var key1=await new TenantAndroidSigningKeys(secrets,new KeytoolAndroidSigningKeyFactory(options)).ReadAsync(request.TenantId,fixture.Firebase.AndroidPackageName,default);
var keyRecord=await secrets.GetAsync(request.TenantId,TenantAndroidSigningKeys.SecretName);
var childStart=new ProcessStartInfo("dotnet"){UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true};
foreach(var argument in new[]{typeof(NativeFixtureBuilder).Assembly.Location,args[0],"read-key",request.TenantId,fixture.Firebase.AndroidPackageName,key1.CertificateSha256})childStart.ArgumentList.Add(argument);
using(var child=Process.Start(childStart)!)
{
    var output=child.StandardOutput.ReadToEndAsync();var error=child.StandardError.ReadToEndAsync();await child.WaitForExitAsync();
    Check(child.ExitCode==0,"A separate process reads the shared encrypted signing key successfully.");Console.Write(await output);await error;
}
// A fresh secret provider and worker contain no signing/build state from the failed process.
using var recovered=SecretProvider();var recoveredSecrets=recovered.GetRequiredService<ITenantSecrets>();
Check(await queue.RetryAsync(request.TenantId),"The failed mobile job can be explicitly retried through its durable queue.");
var resumedPath=Path.Combine(options.WorkingDirectory,"resume-result.json");
var resume=new ProcessStartInfo("dotnet"){UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true};
foreach(var argument in new[]{typeof(NativeFixtureBuilder).Assembly.Location,args[0],"resume-worker",request.TenantId,resumedPath})resume.ArgumentList.Add(argument);
using(var child=Process.Start(resume)!)
{
    var output=child.StandardOutput.ReadToEndAsync();var errors=child.StandardError.ReadToEndAsync();await child.WaitForExitAsync();
    Check(child.ExitCode==0,"A different OS process successfully resumes the real PostgreSQL mobile job.");Console.Write(await output);await errors;
}
var ready=(await queue.GetAsync(request.TenantId))!;using var resumed=JsonDocument.Parse(await File.ReadAllTextAsync(resumedPath));
Check(ready.State=="Succeeded" && ready.Steps.ContainsKey("mobile-android-release"),"The independent worker checkpoints verified distribution before completing the actual PostgreSQL job.");
Check(resumed.RootElement.GetProperty("builds").GetInt32()==0 && await recoveredSecrets.GetAsync(request.TenantId,TenantAndroidSigningKeys.SecretName)==keyRecord,"Worker restart reuses the saved APK and exact encrypted tenant signing material.");
Check(fixture.Server.Uploads+resumed.RootElement.GetProperty("uploads").GetInt32()==2 && fixture.Server.BinaryHashes[0]==resumed.RootElement.GetProperty("binaryHash").GetString() && resumed.RootElement.GetProperty("deliveries").GetInt32()==1,"Provider retry uploads the identical durable binary and distributes it once in the successful attempt.");
var metadata=ready.Steps["mobile-android-release"].Resources;
Check(metadata["signingCertificateSha256"]==key1.CertificateSha256,"The job's public fingerprint matches the actual PKCS12 signer used by apksigner.");
var second=request with{TenantId=Guid.NewGuid().ToString("N"),Slug="native-second"};var secondFirebase=fixture.AddTenant(second);await SeedAsync(second,secondFirebase,recoveredSecrets);
using(var worker=WorkerProvider(recoveredSecrets,new NativeFixtureBuilder(options)))await RunAsync(worker,await ClaimPreparedAsync(second,secondFirebase));
var secondJob=(await queue.GetAsync(second.TenantId))!;
Check(secondJob.State=="Succeeded" && secondJob.Steps["mobile-android-release"].Resources["signingCertificateSha256"]!=metadata["signingCertificateSha256"],"A second canonical business receives a different real signing certificate and completed mobile release.");
Check(secondJob.Steps["mobile-android-release"].Resources["androidApplicationId"]!=metadata["androidApplicationId"],"The actual signed packages preserve independent tenant application identities.");
await using(var db=new NpgsqlConnection(connection))
{
    await db.OpenAsync();await using var command=new NpgsqlCommand("SELECT ciphertext FROM platform_security.secrets",db);await using var reader=await command.ExecuteReaderAsync();
    var rows=0;var safe=true;while(await reader.ReadAsync()){rows++;safe&=!reader.GetString(0).Contains(key1.Password,StringComparison.Ordinal) && !reader.GetString(0).Contains(key1.KeyStoreBase64,StringComparison.Ordinal);}
    Check(rows>=10 && safe,"All actual PostgreSQL secret rows contain encrypted values rather than the signing password or PKCS12 payload.");
}
var serialized=JsonSerializer.Serialize(ready);
Check(!serialized.Contains(key1.Password,StringComparison.Ordinal) && !serialized.Contains("KeyStoreBase64",StringComparison.Ordinal) && !serialized.Contains(options.WorkingDirectory,StringComparison.Ordinal),"Public durable job state exposes no signing material or private filesystem paths.");
var legacy=request with{TenantId=Guid.NewGuid().ToString("N"),Slug="legacy-mobile",MobileReleaseProfile=null};await queue.EnqueueAsync(legacy);
var replay=await queue.EnqueueAsync(legacy with{MobileReleaseProfile="Disabled"});
Check(replay.Request.MobileReleaseProfile==null,"An explicit disabled policy replays an old request without rewriting its original durable JSON.");
try{await queue.EnqueueAsync(legacy with{MobileReleaseProfile="AndroidAppDistribution"});throw new InvalidOperationException("Mobile policy conflict was accepted.");}
catch(ProvisioningConflictException){Console.WriteLine("PASS: An existing disabled job cannot silently acquire automatic signing/cloud distribution.");}
Console.WriteLine("Actual encrypted mobile keys, native APK boundaries and PostgreSQL worker replay checks passed. Firebase HTTP is synthetic; no Flutter release or live Google resources were created.");

internal sealed class NativeFixtureBuilder(AndroidReleaseOptions options) : IAndroidReleaseBuilder
{
    private readonly AndroidReleaseBuilder actual=new(options);public int Builds;public bool RefuseBuild,HoldBuild;
    public Task<string> SourceHashAsync(CancellationToken ct)=>actual.SourceHashAsync(ct);
    public async Task<AndroidReleaseReceipt> VerifyAsync(string path,AndroidReleaseReceipt expected,CancellationToken ct)
    {
        try
        {
            var receipt=await actual.VerifyAsync(path,expected,ct);
            if(receipt!=expected)Console.WriteLine("Native verifier metadata differences: "+string.Join(",",typeof(AndroidReleaseReceipt).GetProperties().Where(p=>!Equals(p.GetValue(receipt),p.GetValue(expected))).Select(p=>p.Name)));
            return receipt;
        }
        catch(Exception error)when(!ct.IsCancellationRequested)
        {
            Console.WriteLine("Native verifier failed: "+error.GetType().Name);
            var tools=Directory.GetDirectories(Path.Combine(options.AndroidSdkDirectory,"build-tools")).OrderByDescending(p=>p,StringComparer.Ordinal).ToArray();
            Console.WriteLine("Installed native build-tools versions: "+string.Join(",",tools.Select(Path.GetFileName)));
            foreach(var item in new[]{("apksigner",new[]{"verify","--verbose","--print-certs",path}),("aapt2",new[]{"dump","badging",path})})
            {
                var start=new ProcessStartInfo(options.BuildToolPath(item.Item1)){UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true};
                foreach(var argument in item.Item2)start.ArgumentList.Add(argument);
                using var process=Process.Start(start)!;var output=process.StandardOutput.ReadToEndAsync();var errors=process.StandardError.ReadToEndAsync();
                await process.WaitForExitAsync(ct);var text=(await output)+"\n"+(await errors);
                Console.WriteLine($"Public APK inspection: tool={item.Item1}; exit={process.ExitCode}");
                foreach(var line in text.Split('\n').Where(line=>new[]{"package: ","application-debuggable","Signer #","Verifies","DOES NOT VERIFY","ERROR:"}.Any(prefix=>line.StartsWith(prefix,StringComparison.Ordinal))))Console.WriteLine(line[..Math.Min(1024,line.Length)]);
            }
            throw;
        }
    }
    public async Task<AndroidBuiltArtifact> BuildAsync(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,AndroidSigningKey key,AndroidReleasePlan plan,CancellationToken ct)
    {
        Builds++;if(RefuseBuild)throw new InvalidOperationException("A restarted worker attempted to rebuild an immutable APK.");
        var root=Path.Combine(options.WorkingDirectory,request.TenantId,Guid.NewGuid().ToString("N"));Directory.CreateDirectory(root);
        if(HoldBuild)await Task.Delay(TimeSpan.FromSeconds(4),ct);
        var keystore=Path.Combine(root,"key.p12");await File.WriteAllBytesAsync(keystore,Convert.FromBase64String(key.KeyStoreBase64),ct);
        if(!OperatingSystem.IsWindows())File.SetUnixFileMode(keystore,UnixFileMode.UserRead|UnixFileMode.UserWrite);
        var manifest=Path.Combine(root,"AndroidManifest.xml");await File.WriteAllTextAsync(manifest,$"<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"{firebase.AndroidPackageName}\" android:versionCode=\"{plan.BuildNumber}\" android:versionName=\"1.0\"><uses-sdk android:minSdkVersion=\"23\"/><application android:label=\"Synthetic mobile queue fixture\"/></manifest>",ct);
        var androidJar=Path.Combine(options.AndroidSdkDirectory,"platforms","android-35","android.jar");
        var unsigned=Path.Combine(root,"unsigned.apk");var signed=Path.Combine(root,"signed.apk");
        try
        {
            await Run(options.BuildToolPath("aapt2"),["link","-I",androidJar,"--manifest",manifest,"-o",unsigned],root,null,ct);
            await Run(options.BuildToolPath("apksigner"),["sign","--ks",keystore,"--ks-key-alias",key.KeyAlias,"--ks-pass","env:PLATFORM_NATIVE_SIGNING_PASSWORD","--key-pass","env:PLATFORM_NATIVE_SIGNING_PASSWORD","--out",signed,unsigned],root,key.Password,ct);
            var bytes=await File.ReadAllBytesAsync(signed,ct);return new(signed,new(request.TenantId,firebase.AndroidPackageName,firebase.ProjectId,firebase.ProjectNumber,firebase.AndroidAppId,plan.StoreUrl,plan.BuildNumber,plan.SourceHash,key.CertificateSha256,Convert.ToHexString(SHA256.HashData(bytes)).ToLowerInvariant()),root);
        }
        finally{File.Delete(keystore);}
    }
    private static async Task Run(string executable,IEnumerable<string> arguments,string directory,string? password,CancellationToken ct)
    {
        var start=new ProcessStartInfo(executable){WorkingDirectory=directory,UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true};
        foreach(var argument in arguments)start.ArgumentList.Add(argument);
        if(password!=null)start.Environment["PLATFORM_NATIVE_SIGNING_PASSWORD"]=password;
        using var process=Process.Start(start)!;var output=process.StandardOutput.ReadToEndAsync();var errors=process.StandardError.ReadToEndAsync();await process.WaitForExitAsync(ct);await output;await errors;
        if(process.ExitCode!=0)
        {
            var detail=(await output)+(await errors);
            var category=new[]{"UnsupportedClassVersionError","GLIBC_","OutOfMemoryError","Permission denied","Unable to access jarfile","Failed to load signer","Error parsing"}.FirstOrDefault(value=>detail.Contains(value,StringComparison.Ordinal))??"Other";
            Console.WriteLine($"Native tool failure: tool={Path.GetFileName(executable)}; version={new DirectoryInfo(Path.GetDirectoryName(executable)!).Name}; exit={process.ExitCode}; category={category}");
            throw new InvalidOperationException("Synthetic native fixture tool failed.");
        }
    }
}

internal sealed class IntegrationWorkerLogger : ILogger<ProvisioningWorker>
{
    public IDisposable? BeginScope<TState>(TState state)where TState:notnull=>null;
    public bool IsEnabled(LogLevel level)=>true;
    public void Log<TState>(LogLevel level,EventId eventId,TState state,Exception? error,Func<TState,Exception?,string> formatter)=>Console.WriteLine("Worker: "+formatter(state,error));
}
