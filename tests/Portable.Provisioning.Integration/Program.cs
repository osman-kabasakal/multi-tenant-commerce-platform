using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging.Abstractions;
using MongoDB.Bson;
using MongoDB.Driver;
using Npgsql;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

static void Check(bool condition,string description){Console.WriteLine((condition?"PASS: ":"FAIL: ")+description);if(!condition)throw new InvalidOperationException(description);}
var config=new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[0])).Build();
var tenantId=config["Fixture:TenantId"]!;var slug=config["Fixture:Slug"]!;
if(!Guid.TryParseExact(tenantId,"N",out _) || !slug.StartsWith("portable-",StringComparison.Ordinal))throw new InvalidOperationException("Use a synthetic portable worker fixture.");
var connection=new NpgsqlConnectionStringBuilder(config["PlatformSecurity:ConnectionString"]);
var ownedDatabase="portable_worker_test_"+tenantId;
var mongoUrl=new MongoUrl(config["Provisioning:Portable:MongoAdminConnection"]);
if(connection.Database!=ownedDatabase || connection.Host is not ("127.0.0.1" or "localhost") || connection.Port!=15439 ||
    mongoUrl.Servers.Any(s=>s.Host is not ("127.0.0.1" or "localhost") || s.Port!=27028))
    throw new InvalidOperationException("Only the local demo endpoints and a uniquely owned fixture database are permitted.");
var adminMongo=new MongoClient(mongoUrl);var mongoName="tenant_"+tenantId;var cleanupTenants=new List<string>{tenantId};
var initialUsers=await adminMongo.GetDatabase(mongoName).RunCommandAsync<BsonDocument>(new BsonDocument("usersInfo",mongoName));
var initialCollections=await (await adminMongo.GetDatabase(mongoName).ListCollectionNamesAsync()).ToListAsync();
if(initialUsers["users"].AsBsonArray.Count!=0 || initialCollections.Count!=0)
    throw new InvalidOperationException("Refusing to reuse or clean a pre-existing Mongo tenant namespace.");
ServiceCollection Services(IConfiguration settings)
{
    var services=new ServiceCollection();services.AddLogging();services.AddPlatformSecurity(settings,"Production");services.AddPlatformProvisioning(settings);services.AddPortableOnboarding(settings,"Production");return services;
}
try
{
    var externalEnrollment=config.GetValue<bool>("Fixture:ExternalEnrollment");
    if(externalEnrollment)
    {
        var second=config["Fixture:SecondTenantId"]!;
        if(!Guid.TryParseExact(second,"N",out var secondId) || secondId.ToString("N")!=second || second==tenantId)throw new InvalidOperationException("Require a separate synthetic second enrollment tenant.");
        var secondName="tenant_"+second;var secondDb=adminMongo.GetDatabase(secondName);var users=await secondDb.RunCommandAsync<BsonDocument>(new BsonDocument("usersInfo",secondName));
        if(users["users"].AsBsonArray.Count!=0 || (await (await secondDb.ListCollectionNamesAsync()).ToListAsync()).Count!=0)throw new InvalidOperationException("Refusing to reuse an existing enrollment tenant namespace.");
        cleanupTenants.Add(second);
    }
    await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"owned-tenants.json"),JsonSerializer.Serialize(cleanupTenants));
    await using var provider=Services(config).BuildServiceProvider();
    foreach(var initializer in provider.GetServices<IHostedService>())await initializer.StartAsync(default);
    var publicReady=config.GetValue<bool>("Fixture:ExpectPublicReady");
    if(publicReady)
    {
        var store=provider.GetRequiredService<ISecretStore>();
        foreach(var secret in config.GetSection("Fixture:BootstrapSecrets").GetChildren())await store.GetOrCreateAsync("system",secret.Key,()=>secret.Value!);
        await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"initialized.json"),"{}");
        if(await Console.In.ReadLineAsync().WaitAsync(TimeSpan.FromMinutes(2))!="provision")throw new InvalidOperationException("The runtime fixture did not authorize provisioning after startup.");
    }
    var workerStart=new System.Diagnostics.ProcessStartInfo("dotnet") {UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true,
        WorkingDirectory=Path.GetDirectoryName(config["Fixture:WorkerDll"]!)!};
    workerStart.ArgumentList.Add(config["Fixture:WorkerDll"]!);workerStart.ArgumentList.Add("--provisioning-worker");
    workerStart.Environment["DOTNET_ENVIRONMENT"]="Production";workerStart.Environment["ASPNETCORE_ENVIRONMENT"]="Production";
    workerStart.Environment["Provisioning__ConfigPath"]=Path.GetFullPath(args[0]);workerStart.Environment["LocalDemo__Enabled"]="false";
    async Task RunPublishedJob(string targetTenant,PostgresProvisioningQueue queue,IReadOnlyList<string>? targets=null)
    {
        using var actualWorker=System.Diagnostics.Process.Start(workerStart)!;
        var lines=new System.Collections.Concurrent.ConcurrentQueue<string>();
        async Task ReadWorkerOutput()
        {
            while(await actualWorker.StandardOutput.ReadLineAsync() is {} line)
            {
                lines.Enqueue(line);
                if(line.Contains("Application started",StringComparison.Ordinal))await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"worker-started.json"),"{}");
            }
        }
        var stdout=ReadWorkerOutput();var stderr=actualWorker.StandardError.ReadToEndAsync();
        try
        {
            var deadline=DateTime.UtcNow.AddMinutes(3);
            while(DateTime.UtcNow<deadline && !actualWorker.HasExited)
            {
                var current=await Task.WhenAll((targets??[targetTenant]).Select(id=>queue.GetAsync(id)));
                if(current.All(job=>job?.State is "Succeeded" or "Failed"))break;
                await Task.Delay(200);
            }
            Check(!actualWorker.HasExited,"The published Production worker stays running while provisioning the real tenant");
        }
        finally
        {
            if(!actualWorker.HasExited){using var stop=System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo("kill"){ArgumentList={"-TERM",actualWorker.Id.ToString()},UseShellExecute=false});if(stop!=null)await stop.WaitForExitAsync();
                try{using var timeout=new CancellationTokenSource(TimeSpan.FromSeconds(15));await actualWorker.WaitForExitAsync(timeout.Token);}catch(OperationCanceledException){actualWorker.Kill(true);await actualWorker.WaitForExitAsync();}}
            await stdout;
            await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"worker-provisioning-"+targetTenant+".log"),string.Join(Environment.NewLine,lines)+await stderr);
        }
    }
    if(externalEnrollment)
    {
        var enrollmentQueue=provider.GetRequiredService<PostgresProvisioningQueue>();await RunPublishedJob(tenantId,enrollmentQueue,cleanupTenants);
        var enrollmentSecrets=provider.GetRequiredService<ITenantSecrets>();var enrollmentOptions=provider.GetRequiredService<PortableOnboardingOptions>();
        var jobs=await Task.WhenAll(cleanupTenants.Select(id=>enrollmentQueue.GetAsync(id)));
        foreach(var enrollmentJob in jobs)
        {
            Check(enrollmentJob?.State=="Succeeded" && enrollmentJob.Request.DeploymentId==enrollmentOptions.DeploymentId,"An actual SaaS enrollment completes through its deployment-bound Production worker");
            Check(enrollmentJob!.Steps.ContainsKey("database") && enrollmentJob.Steps.ContainsKey("store") && enrollmentJob.Steps.ContainsKey("identity") && enrollmentJob.Steps.ContainsKey("domains") && enrollmentJob.Steps["publication"].Resources["readiness"]=="Verified","Database, installer, identity, domains and public readiness all have durable completion checkpoints");
            var ownedConnection=await enrollmentSecrets.GetAsync(enrollmentJob.Request.TenantId,TenantSecretNames.DatabaseConnection);var owned=new MongoClient(ownedConnection).GetDatabase("tenant_"+enrollmentJob.Request.TenantId);
            Check(await owned.GetCollection<BsonDocument>("Store").CountDocumentsAsync(FilterDefinition<BsonDocument>.Empty)==1,"SaaS-created tenant credentials read the actual installed store");
            var clientSecret=await enrollmentSecrets.GetAsync(enrollmentJob.Request.TenantId,TenantSecretNames.KeycloakClient);
            using var scope=provider.CreateScope();await scope.ServiceProvider.GetServices<IProvisioningStep>().Single(step=>step.Name=="identity").ExecuteAsync(enrollmentJob.Request,enrollmentJob.Steps,default);
            Check(await enrollmentSecrets.GetAsync(enrollmentJob.Request.TenantId,TenantSecretNames.KeycloakClient)==clientSecret,"SaaS tenant identity replay preserves the existing confidential client secret");
        }
        var first=jobs[0]!;var second=jobs[1]!;var enrollmentDenied=false;
        try{await new MongoClient(await enrollmentSecrets.GetAsync(first.Request.TenantId,TenantSecretNames.DatabaseConnection)).GetDatabase("tenant_"+second.Request.TenantId).GetCollection<BsonDocument>("Store").Find(FilterDefinition<BsonDocument>.Empty).FirstOrDefaultAsync();}catch(MongoCommandException error){enrollmentDenied=error.Code==13;}
        Check(enrollmentDenied,"The first SaaS tenant cannot use its Mongo credentials to read the second tenant database");
        await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"ready-result.json"),JsonSerializer.Serialize(new{tenantId,slug=first.Request.Slug,ownerEmail=first.Request.OwnerEmail,storeId=first.Steps["store"].Resources["storeId"],storeUrl=enrollmentOptions.StoreUrl(first.Request.Slug),adminUrl=enrollmentOptions.AdminUrl(first.Request.Slug),
            second=new{tenantId=second.Request.TenantId,slug=second.Request.Slug,storeId=second.Steps["store"].Resources["storeId"],storeUrl=enrollmentOptions.StoreUrl(second.Request.Slug),adminUrl=enrollmentOptions.AdminUrl(second.Request.Slug)}}));
        if(await Console.In.ReadLineAsync().WaitAsync(TimeSpan.FromMinutes(5))!="done")throw new InvalidOperationException("SaaS enrollment verification did not complete.");
        Console.WriteLine("Production SaaS enrollment and actual worker resource checks passed.");
        return;
    }
    using(var actualHost=System.Diagnostics.Process.Start(workerStart)!)
    {
        var lines=new System.Collections.Concurrent.ConcurrentQueue<string>();
        async Task ReadOutput(){while(await actualHost.StandardOutput.ReadLineAsync() is {} line)lines.Enqueue(line);}
        var stdout=ReadOutput();var stderr=actualHost.StandardError.ReadToEndAsync();
        try
        {
            var deadline=DateTime.UtcNow.AddSeconds(60);
            while(!actualHost.HasExited && DateTime.UtcNow<deadline &&
                !(lines.Any(l=>l.Contains("Application started",StringComparison.Ordinal)) && lines.Any(l=>l.Contains("Hosting environment: Production",StringComparison.Ordinal))))
                await Task.Delay(100);
            Check(!actualHost.HasExited && lines.Any(l=>l.Contains("Application started",StringComparison.Ordinal)),"Published TenantManager starts its actual headless worker in Production");
            using var stop=System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo("kill"){ArgumentList={"-TERM",actualHost.Id.ToString()},UseShellExecute=false});
            if(stop!=null)await stop.WaitForExitAsync();using var stopTimeout=new CancellationTokenSource(TimeSpan.FromSeconds(15));await actualHost.WaitForExitAsync(stopTimeout.Token);
        }
        finally {if(!actualHost.HasExited){actualHost.Kill(true);await actualHost.WaitForExitAsync();}}
        await stdout;var log=string.Join(Environment.NewLine,lines)+await stderr;await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"worker-host.log"),log);
        Check(log.Contains("Hosting environment: Production",StringComparison.Ordinal) && log.Contains("Application started",StringComparison.Ordinal),"Headless host confirms its Production environment and clean startup");
    }
    var secrets=provider.GetRequiredService<ITenantSecrets>();
    await secrets.ProvisionAsync(tenantId,slug);await secrets.SetAsync(tenantId,TenantSecretNames.InitialPassword,config["Fixture:AdminPassword"]!);
    var request=new TenantProvisioningRequest(tenantId,slug,"Portable Worker Smoke",slug+"@example.test","Portable","Smoke","Street","000",slug+"@example.test","test.example."+slug.Replace("-",""),"test.example."+slug.Replace("-",""));
    var queue=provider.GetRequiredService<PostgresProvisioningQueue>();await queue.EnqueueAsync(request);
    if(publicReady)
    {
        await RunPublishedJob(tenantId,queue);
    }
    else
    {
        var lease=(await queue.ClaimAsync(TimeSpan.FromMinutes(2)))!;
        using(var worker=new ProvisioningWorker(queue,provider.GetRequiredService<IServiceScopeFactory>(),new(){MaxAttempts=1},NullLogger<ProvisioningWorker>.Instance))await worker.RunAsync(lease,default);
    }
    var job=(await queue.GetAsync(tenantId))!;
    Check(job.Steps.ContainsKey("store"),"Real managed installer runs in Production with LocalDemo disabled");
    Check(job.Steps.ContainsKey("identity"),"Scoped HTTPS Keycloak service account creates the owned tenant client");
    Check(job.Steps.ContainsKey("domains") && job.Steps["domains"].Provider=="Wildcard","Explicit wildcard configuration yields deterministic public tenant hosts");
    if(publicReady && job.State!="Succeeded")
    {
        using var ingress=provider.GetRequiredService<IHttpClientFactory>().CreateClient("onboarding-ingress");
        var targets=provider.GetRequiredService<PortableOnboardingOptions>();
        foreach(var url in new[]{targets.StoreUrl(slug)+"/_platform/ready",targets.AdminUrl(slug)})
        {
            try{using var response=await ingress.GetAsync(url);Console.WriteLine("DIAGNOSTIC public probe: "+(int)response.StatusCode+" "+new Uri(url).AbsolutePath+" redirect="+response.Headers.Location);}
            catch(Exception error){Console.WriteLine("DIAGNOSTIC public probe: "+error.GetType().Name);}
        }
    }
    if(publicReady)Check(job.State=="Succeeded" && job.Steps["publication"].Resources["readiness"]=="Verified","Public HTTPS commerce and actual owned admin login allow durable provisioning completion");
    else Check(job.State=="Failed" && job.ErrorCode!.StartsWith("publication:",StringComparison.Ordinal) && !job.Steps.ContainsKey("publication"),"Missing public ingress prevents a false ready result");
    var options=provider.GetRequiredService<PortableOnboardingOptions>();
    using var output=JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(options.TenantDirectory,slug+".json")));
    Check(output.RootElement.GetProperty("profile").GetString()=="Portable" && !output.RootElement.TryGetProperty("connectionString",out _),"Production installer output contains only owned public metadata");
    if(publicReady)Check(File.Exists(Path.Combine(options.NotificationDirectory,slug,"ready.json")) && File.Exists(Path.Combine(options.MobileDirectory,slug+".json")),"Ready outbox and mobile configuration appear only after verified public runtime readiness");
    else Check(!File.Exists(Path.Combine(options.NotificationDirectory,slug,"ready.json")) && !File.Exists(Path.Combine(options.MobileDirectory,slug+".json")),"No ready event or mobile publication appears before public runtime readiness");
    var tenantConnection=await secrets.GetAsync(tenantId,TenantSecretNames.DatabaseConnection);
    var tenantMongo=new MongoClient(tenantConnection);var own=tenantMongo.GetDatabase(mongoName);
    Check(await own.GetCollection<BsonDocument>("Store").CountDocumentsAsync(FilterDefinition<BsonDocument>.Empty)==1,"Tenant credentials can read the real newly installed store");
    Check(await own.GetCollection<BsonDocument>("Product").CountDocumentsAsync(FilterDefinition<BsonDocument>.Empty)==0,"Production installation does not add local synthetic demo products");
    var denied=false;try{await tenantMongo.GetDatabase("admin").GetCollection<BsonDocument>("system.users").Find(FilterDefinition<BsonDocument>.Empty).FirstOrDefaultAsync();}catch(MongoCommandException error){denied=error.Code==13;}
    Check(denied,"Tenant database credentials cannot read administrator data");
    var originalSecret=await secrets.GetAsync(tenantId,TenantSecretNames.KeycloakClient);
    using var identityScope=provider.CreateScope();
    await identityScope.ServiceProvider.GetServices<IProvisioningStep>().Single(s=>s.Name=="identity").ExecuteAsync(request,job.Steps,default);
    Check(await secrets.GetAsync(tenantId,TenantSecretNames.KeycloakClient)==originalSecret,"Live identity replay preserves the existing tenant client secret");
    using var client=provider.GetRequiredService<IHttpClientFactory>().CreateClient("onboarding-keycloak");
    using var token=await client.PostAsync(options.KeycloakAuthority+"/realms/"+options.KeycloakRealm+"/protocol/openid-connect/token",new FormUrlEncodedContent(new Dictionary<string,string>{["grant_type"]="client_credentials",["client_id"]=slug,["client_secret"]=originalSecret}));
    Check(token.IsSuccessStatusCode,"The live configured tenant service account can issue a token over HTTPS");
    using var tokenJson=JsonDocument.Parse(await token.Content.ReadAsStringAsync());var payload=tokenJson.RootElement.GetProperty("access_token").GetString()!.Split('.')[1].Replace('-','+').Replace('_','/');payload=payload.PadRight((payload.Length+3)/4*4,'=');
    using var claims=JsonDocument.Parse(Convert.FromBase64String(payload));var encryption=provider.GetRequiredService<ITenantEncryptionService>();
    Check(await encryption.DecryptAsync(claims.RootElement.GetProperty("store_id").GetString()!,slug)==job.Steps["store"].Resources["storeId"] &&
        await encryption.DecryptAsync(claims.RootElement.GetProperty("db_connection").GetString()!,slug)==tenantConnection,"The HTTPS issuer supplies this tenant's existing encrypted store/database claims");
    if(!publicReady)
    {
    var changed=new ConfigurationBuilder().AddConfiguration(config).AddInMemoryCollection(new Dictionary<string,string?>{["Provisioning:Portable:StoreBaseUrl"]="https://other.example.test"}).Build();
    await using var changedProvider=Services(changed).BuildServiceProvider();
    await queue.RetryAsync(tenantId);var replay=(await queue.ClaimAsync(TimeSpan.FromMinutes(2)))!;
    using(var worker=new ProvisioningWorker(queue,changedProvider.GetRequiredService<IServiceScopeFactory>(),new(){MaxAttempts=1},NullLogger<ProvisioningWorker>.Instance))await worker.RunAsync(replay,default);
    var refused=(await queue.GetAsync(tenantId))!;Check(refused.State=="Failed" && refused.ErrorCode=="pipeline:InvalidOperationException" && refused.Steps.Count==job.Steps.Count,"A changed deployment is rejected before replay can complete or change remote resources");
    }
    Check(Directory.GetFiles(Path.GetDirectoryName(options.WorkingDirectory)!,"ClientSecret-*",SearchOption.AllDirectories).Length==0,"Production provisioning never exports tenant client secrets to files");
    if(publicReady)
    {
        var secondTenant=Guid.NewGuid().ToString("N");var secondSlug="portable-"+secondTenant[..10];var secondName="tenant_"+secondTenant;
        var secondDatabase=adminMongo.GetDatabase(secondName);var secondUsers=await secondDatabase.RunCommandAsync<BsonDocument>(new BsonDocument("usersInfo",secondName));
        if(secondUsers["users"].AsBsonArray.Count!=0 || (await (await secondDatabase.ListCollectionNamesAsync()).ToListAsync()).Count!=0)throw new InvalidOperationException("Refusing to reuse a second existing tenant namespace.");
        cleanupTenants.Add(secondTenant);await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"owned-tenants.json"),JsonSerializer.Serialize(cleanupTenants));await secrets.ProvisionAsync(secondTenant,secondSlug);await secrets.SetAsync(secondTenant,TenantSecretNames.InitialPassword,config["Fixture:AdminPassword"]!);
        var secondRequest=new TenantProvisioningRequest(secondTenant,secondSlug,"Second Portable Store",secondSlug+"@example.test","Second","Owner","Street","000",secondSlug+"@example.test","test.example.tenant"+secondTenant,"test.example.tenant"+secondTenant);
        await queue.EnqueueAsync(secondRequest);await RunPublishedJob(secondTenant,queue);var secondJob=(await queue.GetAsync(secondTenant))!;
        Check(secondJob.State=="Succeeded" && secondJob.Steps["publication"].Resources["readiness"]=="Verified","The same running gateway discovers a second newly provisioned Production tenant without restart");
        var crossDenied=false;try{await tenantMongo.GetDatabase(secondName).GetCollection<BsonDocument>("Store").Find(FilterDefinition<BsonDocument>.Empty).FirstOrDefaultAsync();}catch(MongoCommandException error){crossDenied=error.Code==13;}
        Check(crossDenied,"The first Production tenant database credentials cannot read the second tenant database");
        await File.WriteAllTextAsync(Path.Combine(Path.GetDirectoryName(args[0])!,"ready-result.json"),JsonSerializer.Serialize(new{tenantId,slug,storeId=job.Steps["store"].Resources["storeId"],storeUrl=options.StoreUrl(slug),adminUrl=options.AdminUrl(slug),
            second=new{tenantId=secondTenant,slug=secondSlug,storeId=secondJob.Steps["store"].Resources["storeId"],storeUrl=options.StoreUrl(secondSlug),adminUrl=options.AdminUrl(secondSlug)}}));
        if(await Console.In.ReadLineAsync().WaitAsync(TimeSpan.FromMinutes(2))!="done")throw new InvalidOperationException("The public runtime checks did not finish.");
        Console.WriteLine("Portable public runtime and Production worker resource checks passed.");
    }
    else Console.WriteLine("Portable production resource checks passed; public ingress is intentionally still a required gate.");
}
finally
{
    foreach(var ownedTenant in cleanupTenants)
    {
        var ownedMongo="tenant_"+ownedTenant;var database=adminMongo.GetDatabase(ownedMongo);
        var users=await database.RunCommandAsync<BsonDocument>(new BsonDocument("usersInfo",ownedMongo));
        if(users["users"].AsBsonArray.Count==1 && users["users"][0].AsBsonDocument.TryGetValue("customData",out var metadata) && metadata.IsBsonDocument && metadata.AsBsonDocument.GetValue("platformTenantId","")==ownedTenant)
        {await database.RunCommandAsync<BsonDocument>(new BsonDocument("dropUser",ownedMongo));await adminMongo.DropDatabaseAsync(ownedMongo);}
    }
    NpgsqlConnection.ClearAllPools();
    var admin=new NpgsqlConnectionStringBuilder(connection.ConnectionString){Database="postgres"};await using var db=new NpgsqlConnection(admin.ConnectionString);await db.OpenAsync();
    await using var drop=new NpgsqlCommand("DROP DATABASE IF EXISTS "+ownedDatabase+" WITH (FORCE)",db);await drop.ExecuteNonQueryAsync();
}
