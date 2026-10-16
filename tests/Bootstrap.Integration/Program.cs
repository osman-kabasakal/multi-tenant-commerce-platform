using System.Diagnostics;
using System.Globalization;
using System.Text;
using System.Text.Json.Nodes;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Npgsql;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Infrastructure.Data;

if(args.Length!=1)throw new ArgumentException("Supply the private isolated fixture config.");
var file=Path.GetFullPath(args[0]);var directory=Path.GetDirectoryName(file)!;
var json=JsonNode.Parse(await File.ReadAllTextAsync(file))!.AsObject();
var config=Config(json);var id=config["Fixture:Id"]!;
var options=PortableBootstrapOptions.Read(config,true);
if(!Guid.TryParseExact(id,"N",out _) || new[]{options.Spec.Security,options.Spec.Queue,options.Spec.Saas}.Any(t=>t.Host!="127.0.0.1" || t.Port!=15442) ||
    options.Spec.Security.Database!="bootstrap_security_"+id || options.Spec.Queue.Database!="bootstrap_queue_"+id ||
    options.Spec.Saas.Database!="bootstrap_saas_"+id || options.Spec.DeploymentId!="bootstrap-fixture")
    throw new InvalidOperationException("Use only uniquely named loopback bootstrap fixture databases.");
var cli=config["Fixture:CliPath"]!;
var adminConnection=Admin(options.SecurityConnection);
var ownerRole="bootstrap_owner_"+id;var ownerPassword=Guid.NewGuid().ToString("N");
try
{
    await Sql(adminConnection,$"CREATE ROLE {Quote(ownerRole)} LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD '{ownerPassword}'");
    foreach(var name in new[]{options.Spec.Security.Database,options.Spec.Queue.Database,options.Spec.Saas.Database})await CreateDatabase(name);
    foreach(var pair in new[]{("PlatformSecurity","ConnectionString"),("Provisioning","ConnectionString"),("ConnectionStrings","SaasManagerDb")})
    {
        var b=new NpgsqlConnectionStringBuilder(json[pair.Item1]![pair.Item2]!.GetValue<string>()){Username=ownerRole,Password=ownerPassword};
        json[pair.Item1]![pair.Item2]=b.ConnectionString;
    }
    options=PortableBootstrapOptions.Read(Config(json),true);config=Config(json);
    Check(!await Scalar<bool>(options.SecurityConnection,"SELECT rolsuper OR rolcreatedb OR rolcreaterole FROM pg_catalog.pg_roles WHERE rolname=current_user"),"Bootstrap owner needs neither superuser nor database/role creation privileges");
    await Cli("verify",json,success:false);
    Check(await Relations(options.SaasConnection)==0 && await Relations(options.SecurityConnection)==0,"Verification of empty databases fails without creating tables");
    await Task.WhenAll(Cli("initialize",json),Cli("initialize",json));
    Check(true,"Independent owner processes serialize initialization and replay without lock leaks");
    await Cli("verify",json);
    await using(var db=Db(options.SaasConnection))
    {
        var plan=await db.SubscriptionPlans.SingleAsync();
        Check(options.Spec.Plan.Matches(plan) && !(await db.Database.GetPendingMigrationsAsync()).Any(),"Fresh SaaS uses actual migrations and exactly the explicit public trial plan");
        Check(await db.PaymentProviders.CountAsync()==0 && await db.PaymentMethods.CountAsync()==0 && await db.Payments.CountAsync()==0 && await db.Businesses.CountAsync()==0,"Production bootstrap invents no business, payment provider, card or payment");
    }
    var cipher=await Scalar<string>(options.SecurityConnection,"SELECT ciphertext FROM platform_security.secrets WHERE scope='system' AND name=$1",PortableDatabaseBootstrap.BindingName);
    var marker=await Scalar<DateTime>(options.SaasConnection,"SELECT initialized_at FROM platform_bootstrap.saas_state");
    using(var services=new ServiceCollection().AddPlatformSecurity(config,"Production").BuildServiceProvider())
    {
        var secrets=services.GetRequiredService<ISecretStore>();
        Check(await secrets.GetAsync("system",PortableDatabaseBootstrap.BindingName)==options.Spec.Fingerprint && !cipher.Contains(options.Spec.Fingerprint),"Bootstrap target binding is encrypted in the existing shared secret store");
        await services.GetRequiredService<ITenantSecrets>().ProvisionAsync(id,"bootstrap-shop");
        await secrets.SetAsync(id,"fixture-secret","synthetic-existing-tenant-secret");
    }
    await Cli("initialize",json);
    Check(marker==await Scalar<DateTime>(options.SaasConnection,"SELECT initialized_at FROM platform_bootstrap.saas_state") && cipher==await Scalar<string>(options.SecurityConnection,"SELECT ciphertext FROM platform_security.secrets WHERE scope='system' AND name=$1",PortableDatabaseBootstrap.BindingName),"Completed replay preserves original ownership timestamp and ciphertext after tenant creation");

    var runtimeRole="bootstrap_reader_"+id;var runtimePassword=Guid.NewGuid().ToString("N");
    await Sql(adminConnection,$"CREATE ROLE {Quote(runtimeRole)} LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD '{runtimePassword}'");
    foreach(var pair in new[]{(options.SecurityConnection,"platform_security"),(options.QueueConnection,"platform_provisioning,platform_bootstrap"),(options.SaasConnection,"public,platform_bootstrap")})
    {
        await Sql(pair.Item1,$"REVOKE CREATE ON SCHEMA public FROM PUBLIC; GRANT USAGE ON SCHEMA {pair.Item2} TO {Quote(runtimeRole)}; GRANT SELECT ON ALL TABLES IN SCHEMA {pair.Item2} TO {Quote(runtimeRole)}");
    }
    var runtime=json.DeepClone().AsObject();
    runtime["PlatformSecurity"]!["InitializeSchema"]=false;runtime["PlatformSecurity"]!["ReadOnly"]=true;
    runtime["PlatformSecurity"]!["ConnectionString"]=Reader(options.SecurityConnection);
    runtime["Provisioning"]!["ConnectionString"]=Reader(options.QueueConnection);
    runtime["ConnectionStrings"]!["SaasManagerDb"]=Reader(options.SaasConnection);
    runtime["Bootstrap"]!["AllowSchemaChanges"]=false;
    await Cli("verify",runtime);
    await Initialiser(runtime);
    Check(await Relations(options.SaasConnection)>0,"Read-only runtime credentials pass real SaaS initialization and seed hooks without DDL or seed writes");
    await Refused(async()=>await Sql(Reader(options.SaasConnection),"CREATE TABLE public.forbidden_runtime_ddl(id integer)"),"The runtime role cannot create application tables");
    await Cli("initialize",runtime,success:false);
    var changed=json.DeepClone().AsObject();changed["Bootstrap"]!["DeploymentId"]="another-deployment";changed["Provisioning"]!["DeploymentId"]="another-deployment";
    await Cli("initialize",changed,success:false);
    Check(cipher==await Scalar<string>(options.SecurityConnection,"SELECT ciphertext FROM platform_security.secrets WHERE scope='system' AND name=$1",PortableDatabaseBootstrap.BindingName),"Wrong deployment cannot overwrite the encrypted binding");
    var wrongKey=json.DeepClone().AsObject();wrongKey["PlatformSecurity"]!["AesGcm"]!["MasterKeyBase64"]=Convert.ToBase64String(System.Security.Cryptography.RandomNumberGenerator.GetBytes(32));
    await Cli("verify",wrongKey,success:false);await Cli("initialize",wrongKey,success:false);
    Check(cipher==await Scalar<string>(options.SecurityConnection,"SELECT ciphertext FROM platform_security.secrets WHERE scope='system' AND name=$1",PortableDatabaseBootstrap.BindingName),"Wrong encryption keys fail without replacing persisted ciphertext");

    await Sql(options.SaasConnection,"UPDATE platform_bootstrap.saas_state SET state='Initializing'");
    await Cli("verify",runtime,success:false);await Refused(()=>Initialiser(runtime),"Runtime refuses an incomplete owner bootstrap");
    await Cli("initialize",json);await Initialiser(runtime);
    Check(true,"The same owner resumes an interrupted bootstrap and re-enables read-only startup");
    await Sql(options.SaasConnection,"UPDATE public.\"SubscriptionPlans\" SET \"Name\"='Operator edited plan' WHERE \"Id\"=$1",options.Spec.Plan.Id);
    await Cli("verify",json,success:false);await Cli("initialize",json,success:false);
    Check(await Scalar<string>(options.SaasConnection,"SELECT \"Name\" FROM public.\"SubscriptionPlans\" WHERE \"Id\"=$1",options.Spec.Plan.Id)=="Operator edited plan","Plan drift is refused instead of silently reseeding operator data");
    await Sql(options.SaasConnection,"UPDATE public.\"SubscriptionPlans\" SET \"Name\"=$1 WHERE \"Id\"=$2",options.Spec.Plan.Name,options.Spec.Plan.Id);
    await Sql(options.QueueConnection,"ALTER TABLE platform_bootstrap.queue_state RENAME TO hidden_queue_state");
    await Cli("initialize",json,success:false);
    Check(await Scalar<bool>(options.QueueConnection,"SELECT pg_catalog.to_regclass('platform_bootstrap.queue_state') IS NULL"),"Lost queue ownership is refused instead of adopted");
    await Sql(options.QueueConnection,"ALTER TABLE platform_bootstrap.hidden_queue_state RENAME TO queue_state");
    await Sql(options.QueueConnection,"ALTER TABLE platform_provisioning.jobs RENAME TO hidden_jobs");
    await Cli("initialize",json,success:false);
    Check(await Scalar<bool>(options.QueueConnection,"SELECT pg_catalog.to_regclass('platform_provisioning.jobs') IS NULL"),"Lost durable queue data is refused instead of recreated");
    await Sql(options.QueueConnection,"ALTER TABLE platform_provisioning.hidden_jobs RENAME TO jobs");
    await Sql(options.SecurityConnection,"ALTER TABLE platform_security.tenants RENAME TO hidden_tenants");
    await Cli("initialize",json,success:false);
    Check(await Scalar<bool>(options.SecurityConnection,"SELECT pg_catalog.to_regclass('platform_security.tenants') IS NULL"),"Lost tenant schema is refused instead of silently recreated");
    await Sql(options.SecurityConnection,"ALTER TABLE platform_security.hidden_tenants RENAME TO tenants");
    await Cli("verify",runtime);
    await Sql(options.SaasConnection,"ALTER TABLE public.\"__EFMigrationsHistory\" RENAME TO hidden_migrations");
    await Cli("initialize",json,success:false);
    Check(await Scalar<bool>(options.SaasConnection,"SELECT pg_catalog.to_regclass('public.\"__EFMigrationsHistory\"') IS NULL"),"Lost SaaS migration history is refused without creating a replacement table");
    await Sql(options.SaasConnection,"ALTER TABLE public.hidden_migrations RENAME TO \"__EFMigrationsHistory\"");
    await Sql(options.SaasConnection,"UPDATE public.\"SubscriptionPlans\" SET \"IsDeleted\"=true WHERE \"Id\"=$1",options.Spec.Plan.Id);
    await Cli("initialize",json,success:false);
    Check(await Scalar<bool>(options.SaasConnection,"SELECT \"IsDeleted\" FROM public.\"SubscriptionPlans\" WHERE \"Id\"=$1",options.Spec.Plan.Id),"A removed initial plan is refused without reseeding or reviving it");
    await Sql(options.SaasConnection,"UPDATE public.\"SubscriptionPlans\" SET \"IsDeleted\"=false WHERE \"Id\"=$1",options.Spec.Plan.Id);
    await Sql(options.SecurityConnection,"UPDATE platform_security.secrets SET name='hidden-probe' WHERE scope='system' AND name='deployment-probe'");
    await Cli("initialize",json,success:false);
    Check(!await Scalar<bool>(options.SecurityConnection,"SELECT EXISTS(SELECT 1 FROM platform_security.secrets WHERE scope='system' AND name='deployment-probe')"),"A lost encryption probe is refused without pinning a replacement key");
    await Sql(options.SecurityConnection,"UPDATE platform_security.secrets SET name='deployment-probe' WHERE scope='system' AND name='hidden-probe'");
    await Cli("verify",runtime);

    var foreign=await FreshPair("foreign");var foreignOptions=PortableBootstrapOptions.Read(Config(foreign),true);
    await Sql(foreignOptions.SecurityConnection,"CREATE SCHEMA platform_security; CREATE TABLE platform_security.unrelated_data(id integer)");
    await Cli("initialize",foreign,success:false);
    Check(await Relations(foreignOptions.SaasConnection)==0,"Unowned tables inside a familiar schema are rejected before SaaS reservation");
    await Sql(foreignOptions.SecurityConnection,"DROP TABLE platform_security.unrelated_data");
    await Cli("initialize",foreign);await Cli("verify",foreign);
    Check(true,"Security and queue may share one explicitly named database");
    var foreignIos=await FreshPair("foreign-ios");var foreignIosOptions=PortableBootstrapOptions.Read(Config(foreignIos),true);
    await Sql(foreignIosOptions.QueueConnection,"CREATE SCHEMA platform_provisioning; CREATE TABLE platform_provisioning.ios_release_jobs(id integer); INSERT INTO platform_provisioning.ios_release_jobs VALUES(1)");
    await Cli("initialize",foreignIos,success:false);
    Check(await Relations(foreignIosOptions.SaasConnection)==0 && await Scalar<long>(foreignIosOptions.QueueConnection,"SELECT count(*) FROM platform_provisioning.ios_release_jobs")==1,
        "An unowned populated iOS queue is preserved and rejected before SaaS reservation");
    var unowned=await FreshPair("unowned");var unownedOptions=PortableBootstrapOptions.Read(Config(unowned),true);
    await Sql(unownedOptions.SaasConnection,"CREATE TABLE public.unrelated_application(id integer)");
    await Cli("initialize",unowned,success:false);
    Check(await Relations(unownedOptions.SecurityConnection)==0 && await Relations(unownedOptions.SaasConnection)==1,"Unowned SaaS data is preserved and no shared schema is initialized");
    await Refused(()=>Initialiser(unowned),"Production startup refuses pending migrations on a fresh database");
    var legacy=runtime.DeepClone().AsObject();legacy["DatabaseBootstrap"]!["Mode"]="Existing";
    await Sql(options.SaasConnection,"ALTER TABLE platform_bootstrap.saas_state RENAME TO hidden_saas_state");
    await Initialiser(legacy);await Refused(()=>Initialiser(runtime),"External mode requires ownership while Existing mode verifies older migrated databases");
    await Cli("initialize",json,success:false);
    await Sql(options.SaasConnection,"ALTER TABLE platform_bootstrap.hidden_saas_state RENAME TO saas_state");
    await Cli("verify",runtime);
    var demo=await FreshPair("demo");demo["LocalDemo"]!["Enabled"]=true;demo["DatabaseBootstrap"]!["Mode"]="LocalDemo";
    await Initialiser(demo);
    await using(var db=Db(Config(demo).GetConnectionString("SaasManagerDb")!))
        Check(await db.SubscriptionPlans.CountAsync()==3 && await db.PaymentProviders.CountAsync()==0,"Explicit LocalDemo still migrates and creates its three demo plans without payment credentials");
    Check(true,"All isolated bootstrap checks passed without Azure or cloud credentials");
    return 0;

    string Reader(string original){var b=new NpgsqlConnectionStringBuilder(original){Username=runtimeRole,Password=runtimePassword};return b.ConnectionString;}
}
catch(Exception error)
{
    Console.Error.WriteLine("Bootstrap fixture failed: "+error.GetType().Name+(error is PostgresException pg?" SQLSTATE="+pg.SqlState:"")+"\n"+error.StackTrace);
    return 1;
}

IConfiguration Config(JsonObject source)=>new ConfigurationBuilder().AddJsonStream(new MemoryStream(Encoding.UTF8.GetBytes(source.ToJsonString()))).Build();
ApplicationDbContext Db(string connection)=>new(new DbContextOptionsBuilder<ApplicationDbContext>().UseNpgsql(connection).Options);
string Admin(string connection){var b=new NpgsqlConnectionStringBuilder(connection){Database="postgres"};return b.ConnectionString;}
string Quote(string identifier)=>'"'+identifier.Replace("\"","\"\"")+'"';
async Task CreateDatabase(string name)=>await Sql(adminConnection,"CREATE DATABASE "+Quote(name)+" OWNER "+Quote(ownerRole));
async Task<JsonObject> FreshPair(string prefix)
{
    var shared="bootstrap_"+prefix+"_security_"+id;var app="bootstrap_"+prefix+"_saas_"+id;
    await CreateDatabase(shared);await CreateDatabase(app);
    var result=json.DeepClone().AsObject();
    var s=new NpgsqlConnectionStringBuilder(options.SecurityConnection){Database=shared}.ConnectionString;
    result["PlatformSecurity"]!["ConnectionString"]=s;result["Provisioning"]!["ConnectionString"]=s;
    result["ConnectionStrings"]!["SaasManagerDb"]=new NpgsqlConnectionStringBuilder(options.SaasConnection){Database=app}.ConnectionString;
    return result;
}
async Task<int> Relations(string connection)=>await Scalar<int>(connection,"SELECT count(*)::integer FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace WHERE c.relkind IN ('r','p','v','m','f') AND n.nspname NOT LIKE 'pg_%' AND n.nspname<>'information_schema'");
async Task<T> Scalar<T>(string connection,string sql,params object[] parameters)
{
    await using var db=new NpgsqlConnection(connection);await db.OpenAsync();await using var command=new NpgsqlCommand(sql,db);
    foreach(var value in parameters)command.Parameters.Add(new NpgsqlParameter{Value=value});
    return (T)(await command.ExecuteScalarAsync()??throw new InvalidOperationException("Expected fixture value missing."));
}
async Task Sql(string connection,string sql,params object[] parameters)
{
    await using var db=new NpgsqlConnection(connection);await db.OpenAsync();await using var command=new NpgsqlCommand(sql,db);
    foreach(var value in parameters)command.Parameters.Add(new NpgsqlParameter{Value=value});await command.ExecuteNonQueryAsync();
}
async Task Initialiser(JsonObject source)
{
    var settings=Config(source);await using var db=Db(settings.GetConnectionString("SaasManagerDb")!);
    var initialiser=new ApplicationDbContextInitialiser(NullLogger<ApplicationDbContextInitialiser>.Instance,db,new Clock(),settings);
    await initialiser.InitialiseAsync();await initialiser.SeedAsync();
}
void Check(bool condition,string message){Console.WriteLine((condition?"PASS: ":"FAIL: ")+message);if(!condition)throw new InvalidOperationException(message);}
async Task Refused(Func<Task> action,string message)
{
    try{await action();}catch(Exception error)when(error is InvalidOperationException or PostgresException){Check(true,message);return;}
    throw new InvalidOperationException("Expected refusal: "+message);
}
async Task Cli(string command,JsonObject source,bool success=true)
{
    var path=Path.Combine(directory,"invocation-"+Guid.NewGuid().ToString("N")+".json");await File.WriteAllTextAsync(path,source.ToJsonString());
    if(!OperatingSystem.IsWindows())File.SetUnixFileMode(path,UnixFileMode.UserRead|UnixFileMode.UserWrite);
    try
    {
        var start=new ProcessStartInfo("dotnet"){RedirectStandardOutput=true,RedirectStandardError=true,UseShellExecute=false};
        foreach(var arg in new[]{cli,command,"--config",path})start.ArgumentList.Add(arg);
        foreach(var key in start.Environment.Keys.Where(k=>new[]{"PlatformSecurity__","Provisioning__","ConnectionStrings__","Bootstrap__","TenantOnboarding__","LocalDemo__"}.Any(p=>k.StartsWith(p,StringComparison.OrdinalIgnoreCase))).ToArray())start.Environment.Remove(key);
        start.Environment["DOTNET_ENVIRONMENT"]="Production";
        using var process=Process.Start(start)??throw new InvalidOperationException("Could not start CLI.");
        var stdout=process.StandardOutput.ReadToEndAsync();var stderr=process.StandardError.ReadToEndAsync();
        try{await process.WaitForExitAsync(new CancellationTokenSource(TimeSpan.FromSeconds(90)).Token);}
        catch{if(!process.HasExited)process.Kill(entireProcessTree:true);throw;}
        var output=(await stdout)+(await stderr);
        if((process.ExitCode==0)!=success){Console.Error.WriteLine(output);throw new InvalidOperationException("Unexpected CLI result for "+command);}
    }
    finally{File.Delete(path);}
}
sealed class Clock : IDateTime
{
    public DateTime Now=>DateTime.UtcNow;public DateTime Today=>DateTime.UtcNow.Date;public long UnixTimestamp=>DateTimeOffset.UtcNow.ToUnixTimeSeconds();
    public string FormatISO8601(DateTime value)=>value.ToString("O",CultureInfo.InvariantCulture);
    public DateTime? ParseISO8601(string value)=>DateTime.TryParse(value,CultureInfo.InvariantCulture,DateTimeStyles.RoundtripKind,out var result)?result:null;
}
