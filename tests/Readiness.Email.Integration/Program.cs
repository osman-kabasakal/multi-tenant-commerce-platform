using System.Collections.Concurrent;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Npgsql;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

if(args.Length!=1)throw new ArgumentException("Supply the owned private fixture configuration.");
var path=Path.GetFullPath(args[0]);var root=Path.GetDirectoryName(path)!;
var json=JsonNode.Parse(await File.ReadAllTextAsync(path))!.AsObject();
var config=Settings(json);var id=config["Fixture:Id"]!;var connection=new NpgsqlConnectionStringBuilder(config["PlatformSecurity:ConnectionString"]);
if(!Guid.TryParseExact(id,"N",out _) || connection.Host!="127.0.0.1" || connection.Port!=15443 || connection.Database!="readiness_delivery_test_"+id)
    throw new InvalidOperationException("Use only the isolated loopback readiness fixture database.");
try
{
    await using var smtp=new CaptureSmtp(root);smtp.FailNext=true;
    json["Provisioning"]!["ReadinessEmail"]!["Smtp"]!["Port"]=smtp.Port;
    config=Settings(json);
    using(var ownerServices=Services(config).BuildServiceProvider())
    using(var ownerStore=new PostgresSecretStore(connection.ConnectionString,ownerServices.GetRequiredService<ITenantEncryptionService>(),initializeSchema:true))
        await ownerStore.InitializeAsync();
    await using var jobs=new PostgresProvisioningQueue(connection.ConnectionString);await jobs.InitializeAsync();
    var senderRole="readiness_sender_"+id;var senderPassword=Guid.NewGuid().ToString("N");
    await Sql($"""
        CREATE ROLE {senderRole} LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD '{senderPassword}';
        REVOKE CREATE ON SCHEMA public FROM PUBLIC;
        GRANT USAGE ON SCHEMA platform_security,platform_provisioning TO {senderRole};
        GRANT SELECT ON platform_security.secrets,platform_provisioning.jobs TO {senderRole};
        GRANT INSERT ON platform_security.secrets TO {senderRole};
        GRANT SELECT,UPDATE ON platform_provisioning.readiness_deliveries TO {senderRole};
        """);
    json["PlatformSecurity"]!["ConnectionString"]=new NpgsqlConnectionStringBuilder(connection.ConnectionString){Username=senderRole,Password=senderPassword}.ConnectionString;
    await File.WriteAllTextAsync(path,json.ToJsonString());config=Settings(json);
    var logs=new CaptureLogs();using var services=Services(config,logs).BuildServiceProvider();
    var deliveries=services.GetRequiredService<PostgresReadinessDeliveryQueue>();var worker1=Worker(services);await worker1.InitializeAsync();
    var options=services.GetRequiredService<ReadinessEmailOptions>();var infra=services.GetRequiredService<OnboardingInfrastructureOptions>();
    var binding=options.Fingerprint(infra);var request=Request(id,"ready-one");
    await using(var runtime=new NpgsqlConnection(config["PlatformSecurity:ConnectionString"]))
    {
        await runtime.OpenAsync();await using var permissions=new NpgsqlCommand("SELECT NOT rolsuper AND NOT rolcreatedb AND NOT rolcreaterole AND NOT has_schema_privilege(current_user,'public','CREATE') FROM pg_catalog.pg_roles WHERE rolname=current_user",runtime);
        Check(await permissions.ExecuteScalarAsync() is true,"SMTP workers use a separate nonowner login without schema/admin privileges");
    }
    var job=await jobs.EnqueueAsync(request);var lease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CheckpointAsync(lease,"publication",Publication(request));
    Check(await deliveries.GetAsync(id)==null,"A publication checkpoint alone cannot enqueue readiness mail before job completion");
    await jobs.FailAsync(lease,"synthetic:MobileStillPending",5);
    Check(await deliveries.GetAsync(id)==null,"A failed later provisioning step produces no ready email");
    await DueJob(id);lease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CompleteAsync(lease);
    Check((await deliveries.GetAsync(id))?.State=="Pending","Job completion atomically inserts one durable readiness delivery");
    var claims=await Task.WhenAll(Enumerable.Range(0,8).Select(_=>deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))));
    Check(claims.Count(c=>c!=null)==1,"Concurrent independent claims select exactly one sender");
    await worker1.RunAsync(claims.Single(c=>c!=null)!);
    var failure=await deliveries.GetAsync(id);
    Check(failure?.State=="Pending" && failure.Attempts==1 && failure.ErrorCode=="smtp:SmtpException" && !logs.Text.Contains(CaptureSmtp.PrivateFailure),"A transient SMTP rejection persists a safe retry without provider response contents");
    Check((await jobs.GetAsync(id))?.State=="Succeeded","An email failure does not undo tenant readiness or restart provisioning");
    await DueDelivery(id);smtp.DelayNext=true;
    var childTask=SendChild(path);await smtp.DelayedData.Task.WaitAsync(TimeSpan.FromSeconds(15));
    await Task.Delay(3500);
    Check(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))==null,"The independent SMTP sender renews its lease while the server delays acceptance");
    smtp.ReleaseDelay.TrySetResult();await childTask;
    Check((await deliveries.GetAsync(id)) is {State:"Sent",Attempts:2} && smtp.Accepted.Count==1,"Another OS process resumes the persisted event and journals actual SMTP acceptance");
    Check(smtp.AttemptIds.Count==2 && smtp.AttemptIds.Distinct().Count()==1,"Transport retries retain the same stable Message-ID");
    Check(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))==null,"A completed event is not sent again on ordinary replay");

    var second=Request(Guid.NewGuid().ToString("N"),"ready-two");
    await jobs.EnqueueAsync(second);var secondLease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CheckpointAsync(secondLease,"publication",Publication(second));
    await Sql("UPDATE platform_provisioning.jobs SET state='Succeeded',claim_token=NULL,lease_until=NULL WHERE tenant_id=$1",second.TenantId);
    Check((await deliveries.GetAsync(second.TenantId))?.State=="Pending","Older-style completion SQL also creates the outbox event through the database trigger");
    var stale=await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))??throw new InvalidOperationException();
    await Task.Delay(3300);var recovered=await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))??throw new InvalidOperationException();
    await Refused(()=>deliveries.SentAsync(stale),"An expired sender cannot acknowledge a recovered event");
    await worker1.RunAsync(recovered);
    Check(smtp.Accepted.Count==2 && (await deliveries.GetAsync(second.TenantId))?.State=="Sent","Two tenants receive their own actual SMTP messages and durable receipts");
    var third=Request(Guid.NewGuid().ToString("N"),"ready-retry");
    await jobs.EnqueueAsync(third);var thirdLease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CheckpointAsync(thirdLease,"publication",Publication(third));await jobs.CompleteAsync(thirdLease);
    var terminalOptions=new ReadinessEmailOptions{Host=options.Host,Port=options.Port,FromAddress=options.FromAddress,EnableStartTls=false,AllowPlaintextLoopback=true,LeaseDuration=TimeSpan.FromSeconds(3),MaxAttempts=1};
    using(var terminalWorker=new ReadinessEmailWorker(deliveries,terminalOptions,infra,services.GetRequiredService<IReadinessEmailTransport>(),services.GetRequiredService<ISecretStore>(),Microsoft.Extensions.Logging.Abstractions.NullLogger<ReadinessEmailWorker>.Instance))
    {
        await terminalWorker.InitializeAsync();smtp.FailNext=true;
        await terminalWorker.RunAsync(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))??throw new InvalidOperationException());
    }
    Check((await deliveries.GetAsync(third.TenantId))?.State=="Failed" && (await jobs.GetAsync(third.TenantId))?.State=="Succeeded","Exhausted mail attempts are visible separately from successful tenant setup");
    Check(await deliveries.RetryAsync(third.TenantId) && !await deliveries.RetryAsync(third.TenantId),"Explicit retry requeues only the failed notification without reprovisioning");
    await worker1.RunAsync(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))??throw new InvalidOperationException());
    Check((await deliveries.GetAsync(third.TenantId)) is {State:"Sent",Attempts:2},"The repaired notification can be accepted while preserving its original attempt history");
    var paused=Request(Guid.NewGuid().ToString("N"),"ready-paused");
    await jobs.EnqueueAsync(paused);var pausedLease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CheckpointAsync(pausedLease,"publication",Publication(paused));await jobs.CompleteAsync(pausedLease);
    await Sql("UPDATE platform_provisioning.jobs SET state='Failed' WHERE tenant_id=$1",paused.TenantId);
    Check(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))==null,"A delivery cannot be claimed after its tenant job is suspended");
    var foreign=Request(Guid.NewGuid().ToString("N"),"ready-foreign") with{DeploymentId="foreign-deployment"};
    await jobs.EnqueueAsync(foreign);var foreignLease=await jobs.ClaimAsync(TimeSpan.FromSeconds(30))??throw new InvalidOperationException();
    await jobs.CheckpointAsync(foreignLease,"publication",new("Portable",new Dictionary<string,string>{["readiness"]="Verified",["storeUrl"]="https://ready-foreign.shops.example.test",["adminUrl"]="https://ready-foreign.manage.example.test/Admin"}));
    await jobs.CompleteAsync(foreignLease);
    Check(await deliveries.ClaimAsync("",binding,TimeSpan.FromSeconds(3))==null,"A sender cannot claim another deployment's readiness events");
    var changed=new ReadinessEmailOptions{Host=options.Host,Port=options.Port+1,FromAddress=options.FromAddress,EnableStartTls=false,AllowPlaintextLoopback=true};
    await Refused(()=>deliveries.VerifyAsync("",changed.Fingerprint(infra)),"A changed SMTP target is refused after the original delivery binding");
    var tlsOptions=new ReadinessEmailOptions{Host="127.0.0.1",Port=smtp.Port,FromAddress=options.FromAddress,EnableStartTls=true,Timeout=TimeSpan.FromSeconds(5)};
    var count=smtp.Accepted.Count;
    await Refused(()=>new SmtpReadinessEmailTransport(tlsOptions).SendAsync(new(id,"owner@example.test","TLS must be required","Synthetic","<tls-check@example.test>"),CancellationToken.None),"SMTP cannot downgrade when STARTTLS is unavailable");
    Check(smtp.Accepted.Count==count,"The TLS refusal sends no plaintext message");
    await Sql("ALTER TABLE platform_provisioning.readiness_deliveries RENAME TO hidden_deliveries");
    await Refused(()=>jobs.InitializeAsync(),"Owner reinitialization refuses a lost installed outbox instead of recreating it");
    Check(await Scalar<bool>("SELECT pg_catalog.to_regclass('platform_provisioning.readiness_deliveries') IS NULL"),"Missing outbox data remains untouched after the refused initialization");
    await Sql("ALTER TABLE platform_provisioning.hidden_deliveries RENAME TO readiness_deliveries");
    await jobs.InitializeAsync();await deliveries.VerifyAsync("",binding);
    Check((await deliveries.GetAsync(id))?.State=="Sent" && (await deliveries.GetAsync(second.TenantId))?.State=="Sent","Owner schema replay preserves existing delivery receipts");
    Check(!logs.Text.Contains(request.OwnerEmail) && !logs.Text.Contains(CaptureSmtp.PrivateFailure),"Runtime logs contain neither recipient addresses nor raw SMTP failures");
    await File.WriteAllTextAsync(Path.Combine(root,"expected.json"),JsonSerializer.Serialize(new[]{new{tenantId=id,recipient=request.OwnerEmail,storeUrl=infra.StoreUrl(request.Slug),adminUrl=infra.AdminUrl(request.Slug)},new{tenantId=second.TenantId,recipient=second.OwnerEmail,storeUrl=infra.StoreUrl(second.Slug),adminUrl=infra.AdminUrl(second.Slug)},new{tenantId=third.TenantId,recipient=third.OwnerEmail,storeUrl=infra.StoreUrl(third.Slug),adminUrl=infra.AdminUrl(third.Slug)}}));
    Console.WriteLine("Actual PostgreSQL readiness outbox and SMTP checks passed.");return 0;
}
catch(Exception error)
{Console.Error.WriteLine("Readiness fixture failed ("+error.GetType().Name+") "+(error is PostgresException pg?pg.SqlState:"")+"\n"+error.StackTrace);return 1;}

IConfiguration Settings(JsonObject value)=>new ConfigurationBuilder().AddJsonStream(new MemoryStream(Encoding.UTF8.GetBytes(value.ToJsonString()))).Build();
ServiceCollection Services(IConfiguration settings,CaptureLogs? logs=null)
{
    var service=new ServiceCollection();service.AddLogging(builder=>{if(logs!=null)builder.AddProvider(logs);});
    service.AddPlatformSecurity(settings,"Development");var infra=new LocalOnboardingOptions{StoreBaseUrl="http://localhost:18090",AdminBaseUrl="http://localhost:18083"};
    service.AddSingleton<OnboardingInfrastructureOptions>(infra);service.AddReadinessEmail(settings,"Development",infra);return service;
}
ReadinessEmailWorker Worker(IServiceProvider services)=>services.GetServices<IHostedService>().OfType<ReadinessEmailWorker>().Single();
TenantProvisioningRequest Request(string tenant,string slug)=>new(tenant,slug,slug+" Store",slug+"@example.test","Owner","Fixture","Address","555","company@example.test");
ProvisioningStepResult Publication(TenantProvisioningRequest request)=>new("Local",new Dictionary<string,string>{["storeUrl"]="http://"+request.Slug+".localhost:18090",["adminUrl"]="http://"+request.Slug+".localhost:18083/Admin"});
void Check(bool condition,string message){Console.WriteLine((condition?"PASS: ":"FAIL: ")+message);if(!condition)throw new InvalidOperationException(message);}
async Task Refused(Func<Task> action,string message)
{try{await action();}catch(Exception error)when(error is InvalidOperationException or PostgresException or ProvisioningLeaseLostException or System.Net.Mail.SmtpException){Check(true,message);return;}throw new InvalidOperationException("Expected refusal: "+message);}
async Task Sql(string sql,params object[] values)
{await using var db=new NpgsqlConnection(connection.ConnectionString);await db.OpenAsync();await using var cmd=new NpgsqlCommand(sql,db);foreach(var value in values)cmd.Parameters.Add(new NpgsqlParameter{Value=value});await cmd.ExecuteNonQueryAsync();}
async Task<T> Scalar<T>(string sql)
{await using var db=new NpgsqlConnection(connection.ConnectionString);await db.OpenAsync();await using var cmd=new NpgsqlCommand(sql,db);return (T)(await cmd.ExecuteScalarAsync()??throw new InvalidOperationException());}
Task DueJob(string tenant)=>Sql("UPDATE platform_provisioning.jobs SET available_at=now() WHERE tenant_id=$1",tenant);
Task DueDelivery(string tenant)=>Sql("UPDATE platform_provisioning.readiness_deliveries SET available_at=now() WHERE tenant_id=$1",tenant);
async Task SendChild(string file)
{
    var start=new ProcessStartInfo("dotnet"){RedirectStandardOutput=true,RedirectStandardError=true,UseShellExecute=false};
    foreach(var arg in new[]{config["Fixture:WorkerDll"]!,"--readiness-email-worker"})start.ArgumentList.Add(arg);
    foreach(var key in start.Environment.Keys.Where(k=>k.StartsWith("PlatformSecurity__",StringComparison.OrdinalIgnoreCase) || k.StartsWith("Provisioning__",StringComparison.OrdinalIgnoreCase) || k.StartsWith("LocalDemo__",StringComparison.OrdinalIgnoreCase)).ToArray())start.Environment.Remove(key);
    start.Environment["DOTNET_ENVIRONMENT"]="Development";start.Environment["ASPNETCORE_ENVIRONMENT"]="Development";start.Environment["Provisioning__ConfigPath"]=file;
    using var child=Process.Start(start)??throw new InvalidOperationException();var output=child.StandardOutput.ReadToEndAsync();var errors=child.StandardError.ReadToEndAsync();var accepted=false;
    try
    {
        var deadline=DateTime.UtcNow.AddSeconds(30);
        while(DateTime.UtcNow<deadline)
        {
            if(child.HasExited)throw new InvalidOperationException("Delivery-only worker exited before acceptance.");
            await using var runtime=new PostgresReadinessDeliveryQueue(config["PlatformSecurity:ConnectionString"]!);
            if((await runtime.GetAsync(id))?.State=="Sent"){accepted=true;break;}
            await Task.Delay(100);
        }
        if(!accepted)throw new TimeoutException("The real delivery-only worker did not accept the event.");
    }
    finally
    {
        if(!child.HasExited)
        {
            if(OperatingSystem.IsWindows())child.Kill(entireProcessTree:true);
            else {using var term=Process.Start(new ProcessStartInfo("kill"){ArgumentList={"-TERM",child.Id.ToString()},UseShellExecute=false});if(term!=null)await term.WaitForExitAsync();}
            try{await child.WaitForExitAsync(new CancellationTokenSource(TimeSpan.FromSeconds(5)).Token);}catch{if(!child.HasExited)child.Kill(entireProcessTree:true);await child.WaitForExitAsync();}
        }
        var logs=(await output)+(await errors);
        if(!accepted || child.ExitCode!=0){Console.Error.WriteLine(logs);throw new InvalidOperationException("The real delivery-only worker failed.");}
        if(logs.Contains(CaptureSmtp.PrivateFailure) || logs.Contains(config["PlatformSecurity:ConnectionString"]!))throw new InvalidOperationException("Unsafe worker diagnostics.");
        Check(true,"The actual TenantManager delivery-only host sends with minimal configuration and exits cleanly");
    }
}

sealed class CaptureLogs : ILoggerProvider
{
    private readonly ConcurrentQueue<string> entries=new();public string Text=>string.Join("\n",entries);
    public ILogger CreateLogger(string categoryName)=>new Capture(entries);public void Dispose(){ }
    private sealed class Capture(ConcurrentQueue<string> entries) : ILogger
    {
        public IDisposable? BeginScope<TState>(TState state)where TState:notnull=>null;public bool IsEnabled(LogLevel level)=>true;
        public void Log<TState>(LogLevel level,EventId eventId,TState state,Exception? error,Func<TState,Exception?,string> formatter)=>entries.Enqueue(formatter(state,error));
    }
}
sealed class CaptureSmtp : IAsyncDisposable
{
    public const string PrivateFailure="never-log-provider-token";
    private readonly TcpListener listener=new(IPAddress.Loopback,0);private readonly CancellationTokenSource stopped=new();private readonly Task accepting;private readonly List<Task> sessions=[];private readonly string root;
    public readonly ConcurrentQueue<string> Accepted=new();public readonly ConcurrentQueue<string> AttemptIds=new();
    public bool FailNext;public bool DelayNext;public TaskCompletionSource DelayedData=new(TaskCreationOptions.RunContinuationsAsynchronously);public TaskCompletionSource ReleaseDelay=new(TaskCreationOptions.RunContinuationsAsynchronously);
    public int Port=>((IPEndPoint)listener.LocalEndpoint).Port;
    public CaptureSmtp(string root){this.root=root;listener.Start();accepting=AcceptAsync();}
    private async Task AcceptAsync()
    {
        try{while(!stopped.IsCancellationRequested){var client=await listener.AcceptTcpClientAsync(stopped.Token);lock(sessions)sessions.Add(Session(client));}}
        catch(Exception error)when(error is OperationCanceledException or SocketException){ }
    }
    private async Task Session(TcpClient client)
    {
        using(client)
        {
            try
            {
                var stream=client.GetStream();using var reader=new StreamReader(stream,Encoding.ASCII,false,4096,true);using var writer=new StreamWriter(stream,Encoding.ASCII,4096,true){NewLine="\r\n",AutoFlush=true};
                await writer.WriteLineAsync("220 readiness-fixture");
                while(await reader.ReadLineAsync(stopped.Token) is { } line)
                {
                    if(line.StartsWith("EHLO") || line.StartsWith("HELO"))await writer.WriteLineAsync("250-readiness-fixture\r\n250 SIZE 1000000");
                    else if(line=="DATA")
                    {
                        await writer.WriteLineAsync("354 send message");var body=new StringBuilder();
                        while(await reader.ReadLineAsync(stopped.Token) is { } payload && payload!=".")body.Append(payload.StartsWith("..")?payload[1..]:payload).Append("\r\n");
                        var raw=body.ToString();AttemptIds.Enqueue(raw.Split("\r\n").Single(l=>l.StartsWith("Message-ID:",StringComparison.OrdinalIgnoreCase)));
                        if(FailNext){FailNext=false;await writer.WriteLineAsync("451 "+PrivateFailure);continue;}
                        if(DelayNext){DelayNext=false;DelayedData.TrySetResult();await ReleaseDelay.Task.WaitAsync(stopped.Token);}
                        Accepted.Enqueue(raw);await File.WriteAllTextAsync(Path.Combine(root,"accepted-"+Accepted.Count+".eml"),raw);await writer.WriteLineAsync("250 queued");
                    }
                    else if(line=="QUIT"){await writer.WriteLineAsync("221 goodbye");break;}
                    else await writer.WriteLineAsync("250 OK");
                }
            }
            catch(Exception error)when(error is IOException or OperationCanceledException or SocketException){ }
        }
    }
    public async ValueTask DisposeAsync(){stopped.Cancel();listener.Stop();await accepting;Task[] pending;lock(sessions)pending=sessions.ToArray();await Task.WhenAll(pending);stopped.Dispose();}
}
