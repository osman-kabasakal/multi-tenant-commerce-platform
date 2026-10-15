using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Google;
using Platform.Notifications;
using Platform.Security;

namespace Platform.Notifications.Tests;

[TestClass]
public sealed class TenantPushTests
{
    [TestMethod]
    public async Task IndependentScopesUseCanonicalTenantConfigAndNeverLoadProvisioningPermissions()
    {
        var store = new TenantStore(); var a = store.Add("store-a", "notify-project-a", "600001"); var b = store.Add("store-b", "notify-project-b", "600002");
        using var server = new FcmServer(); var services = new ServiceCollection();
        services.AddTenantNotifications(new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> { ["Notifications:Provider"]="Fcm" }).Build());
        services.AddSingleton<ITenantSecrets>(store); services.AddSingleton(server.Client());
        using var provider = services.BuildServiceProvider(); using var scopeA = provider.CreateScope(); using var scopeB = provider.CreateScope();
        var results = await Task.WhenAll(scopeA.ServiceProvider.GetRequiredService<ITenantPushSender>().SendAsync("store-a",["device-a"],new("A","Message A")),
            scopeB.ServiceProvider.GetRequiredService<ITenantPushSender>().SendAsync("store-b",["device-b"],new("B","Message B")));
        Assert.AreEqual(1, results[0].Accepted); Assert.AreEqual(1, results[1].Accepted);
        Assert.AreEqual("device-a", server.Messages[a.ProjectId]["message"]!["token"]!.GetValue<string>());
        Assert.AreEqual("device-b", server.Messages[b.ProjectId]["message"]!["token"]!.GetValue<string>());
        Assert.IsFalse(services.Any(d => d.ServiceType == typeof(GoogleCloudOptions) || d.ServiceType == typeof(GoogleTenantProvisioner)));
    }

    [TestMethod]
    public async Task MissingForeignAndUnknownTenantConfigCannotFallbackToAnotherTenant()
    {
        var store = new TenantStore(); var a = store.Add("store-a", "notify-project-a", "600001"); var b = store.Add("store-b", "notify-project-b", "600002");
        using var server = new FcmServer(); var sender = new FcmTenantPushSender(store,new(server.Client()));
        store.Values[(b.TenantId,TenantFirebaseConfiguration.SecretName)] = JsonSerializer.Serialize(a);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => sender.SendAsync("store-b",["device-b"],new("B","Message")));
        store.Values.Remove((b.TenantId,TenantFirebaseConfiguration.SecretName));
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(() => sender.SendAsync("store-b",["device-b"],new("B","Message")));
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(() => sender.SendAsync("unknown",["device-b"],new("B","Message")));
        Assert.AreEqual(0,server.Messages.Count);
    }

    [TestMethod]
    public async Task RejectedTokenDoesNotSuppressOtherRecipientsAndPermissionsNeverFallback()
    {
        var store = new TenantStore(); store.Add("store-a", "notify-project-a", "600001");
        using var server = new FcmServer(); var sender = new FcmTenantPushSender(store,new(server.Client()));
        var result = await sender.SendAsync("store-a",["bad-device","good-device","good-device"],new("A","Message"));
        Assert.AreEqual(2,result.Attempted); Assert.AreEqual(1,result.Accepted);
        server.Denied = true;
        var error = await Assert.ThrowsExceptionAsync<Platform.Google.GoogleApiException>(()=>sender.SendAsync("store-a",["good-device"],new("A","Message")));
        Assert.AreEqual(HttpStatusCode.Forbidden,error.StatusCode); Assert.IsFalse(error.ToString().Contains("private-provider-detail"));
    }

    [TestMethod]
    public async Task PayloadPreservesMobileActionsImagesAndDataOnlyBackgroundDelivery()
    {
        var store = new TenantStore(); var a=store.Add("store-a", "notify-project-a", "600001");
        using var server = new FcmServer(); var sender = new FcmTenantPushSender(store,new(server.Client()));
        await sender.SendAsync("store-a",["device"],new("Title","Body","https://example.com/picture.png","https://example.com/order"));
        var message=server.Messages[a.ProjectId]["message"]!;
        Assert.AreEqual("https://example.com/order",message["data"]!["action_link"]!.GetValue<string>());
        Assert.AreEqual("high_importance_channel",message["android"]!["notification"]!["channel_id"]!.GetValue<string>());
        Assert.AreEqual("default",message["apns"]!["payload"]!["aps"]!["sound"]!.GetValue<string>());
        Assert.AreEqual(1,message["apns"]!["payload"]!["aps"]!["mutable-content"]!.GetValue<int>());
        Assert.AreEqual("https://example.com/order",message["webpush"]!["fcm_options"]!["link"]!.GetValue<string>());
        await sender.SendAsync("store-a",["device"],new(null,null,Data:new Dictionary<string,string>{{"Type","cache_invalidation"}}));
        message=server.Messages[a.ProjectId]["message"]!;
        Assert.IsNull(message["notification"]); Assert.AreEqual("5",message["apns"]!["headers"]!["apns-priority"]!.GetValue<string>());
        Assert.AreEqual(1,message["apns"]!["payload"]!["aps"]!["content-available"]!.GetValue<int>());
    }

    [TestMethod]
    public async Task LocalCaptureIsPrivateAndSeparatedByCanonicalBusinessIdentity()
    {
        var store = new TenantStore(); var a=store.Add("store-a", "notify-project-a", "600001"); var b=store.Add("store-b", "notify-project-b", "600002");
        var directory=Path.Combine(Path.GetTempPath(),"notification-test-"+Guid.NewGuid().ToString("N"));
        try
        {
            var sender=new LocalSinkTenantPushSender(store,new(){Provider="LocalSink",LocalDirectory=directory});
            await Task.WhenAll(sender.SendAsync("store-a",["private-device-a"],new("A","Local A","http://store-a.localhost/image.png")),sender.SendAsync("store-b",["private-device-b"],new("B","Local B")));
            var first=Directory.GetFiles(Path.Combine(directory,a.TenantId,"push")).Single();
            var second=Directory.GetFiles(Path.Combine(directory,b.TenantId,"push")).Single();
            var text=await File.ReadAllTextAsync(first); Assert.IsFalse(text.Contains("private-device-a")); Assert.IsFalse(text.Contains(b.TenantId));
            Assert.AreEqual(a.TenantId,JsonNode.Parse(text)!["tenantId"]!.GetValue<string>());
            Assert.AreEqual(b.TenantId,JsonNode.Parse(await File.ReadAllTextAsync(second))!["tenantId"]!.GetValue<string>());
            if(!OperatingSystem.IsWindows()) Assert.AreEqual(UnixFileMode.UserRead|UnixFileMode.UserWrite,File.GetUnixFileMode(first));
            var files=Directory.GetFiles(directory,"*",SearchOption.AllDirectories).Length;
            await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>sender.SendAsync("../unknown",["device"],new("A","Message")));
            Assert.AreEqual(files,Directory.GetFiles(directory,"*",SearchOption.AllDirectories).Length);
        }
        finally {if(Directory.Exists(directory))Directory.Delete(directory,true);}
    }

    [TestMethod]
    public async Task InvalidPayloadAndDisabledProviderNeverReportSuccess()
    {
        var store = new TenantStore(); store.Add("store-a", "notify-project-a", "600001");
        using var server = new FcmServer(); var sender=new FcmTenantPushSender(store,new(server.Client()));
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>sender.SendAsync("store-a",["[DENIED]"],new("A","Message")));
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>sender.SendAsync("store-a",["device"],new(null,null)));
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>sender.SendAsync("store-a",["device"],new("A","Message",ClickUrl:"file:///private/data")));
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>sender.SendAsync("store-a",["device"],new("A","Message","http://localhost/image.png")));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new DisabledTenantPushSender().SendAsync("store-a",["device"],new("A","Message")));
        Assert.AreEqual(0,server.Messages.Count);
    }

    [TestMethod]
    public void LocalProviderIsRejectedInProductionAndUnknownProvidersFailClosed()
    {
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{{"Notifications:Provider","LocalSink"},{"Notifications:LocalDirectory",Path.GetTempPath()},{"LocalDemo:Enabled","true"}}).Build();
        var services=new ServiceCollection(); services.AddTenantNotifications(config);
        var environment=new Mock<IHostEnvironment>();environment.SetupGet(e=>e.EnvironmentName).Returns("Production");services.AddSingleton(environment.Object);
        using var provider=services.BuildServiceProvider(); Assert.ThrowsException<InvalidOperationException>(()=>provider.GetRequiredService<NotificationOptions>());
        Assert.ThrowsException<InvalidOperationException>(()=>new NotificationOptions{Provider="Unknown"}.Validate("Development",true));
    }
}

internal sealed class TenantStore : ITenantSecrets
{
    public Dictionary<(string,string),string> Values=[]; private readonly Dictionary<string,string> aliases=[];
    public TenantFirebaseConfiguration Add(string alias,string project,string number)
    {
        var tenant=Guid.NewGuid().ToString("N");aliases[alias]=tenant;aliases[tenant]=tenant;
        var package="com.example.t"+tenant;var android=$"1:{number}:android:a1";var ios=$"1:{number}:ios:b1";
        var json=JsonSerializer.Serialize(new{project_info=new{project_id=project,project_number=number},client=new[]{new{client_info=new{mobilesdk_app_id=android,android_client_info=new{package_name=package}}}}});
        var plist=$"<plist><dict><key>PROJECT_ID</key><string>{project}</string><key>GCM_SENDER_ID</key><string>{number}</string><key>GOOGLE_APP_ID</key><string>{ios}</string><key>BUNDLE_ID</key><string>{package}</string></dict></plist>";
        var config=new TenantFirebaseConfiguration(tenant,project,number,"sender@example.com",android,ios,package,package,json,plist,"tenant-testers");
        Values[(tenant,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(config);return config;
    }
    public Task ProvisionAsync(string tenantId,string alias,CancellationToken cancellationToken=default)=>throw new NotSupportedException();
    public Task BindAliasAsync(string tenantId,string alias,CancellationToken cancellationToken=default)=>throw new NotSupportedException();
    public Task<string> ResolveAsync(string tenantId,CancellationToken cancellationToken=default)=>Task.FromResult(aliases[tenantId]);
    public Task<string> GetAsync(string tenantId,string name,CancellationToken cancellationToken=default)=>Task.FromResult(Values[(tenantId,name)]);
    public Task SetAsync(string tenantId,string name,string value,CancellationToken cancellationToken=default){Values[(tenantId,name)]=value;return Task.CompletedTask;}
    public Task<string> GetOrCreateAsync(string tenantId,string name,Func<string> generate,CancellationToken cancellationToken=default)=>throw new NotSupportedException();
}

internal sealed class FcmServer : HttpMessageHandler
{
    public Dictionary<string,JsonObject> Messages=[];public bool Denied;
    public GoogleRestClient Client()=>new(new HttpClient(this,false),new TestTokens());
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)
    {
        Assert.AreEqual("fcm.googleapis.com",request.RequestUri!.Host);
        var project=request.RequestUri.AbsolutePath.Split('/')[3];var body=JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!.AsObject();
        if(Denied)return new(HttpStatusCode.Forbidden){Content=JsonContent.Create(new{error=new{message="private-provider-detail"}})};
        if(body["message"]!["token"]!.GetValue<string>()=="bad-device")return new(HttpStatusCode.BadRequest){Content=JsonContent.Create(new{})};
        lock(Messages)Messages[project]=body;
        return new(HttpStatusCode.OK){Content=JsonContent.Create(new{name=$"projects/{project}/messages/accepted"})};
    }
    private sealed class TestTokens : IGoogleAccessTokenSource
    {
        public Task<string> GetAsync(string scope,CancellationToken ct){Assert.AreEqual(GoogleRestClient.MessagingScope,scope);return Task.FromResult("contract-token");}
    }
}
