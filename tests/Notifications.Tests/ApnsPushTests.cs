using System.Net;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Google;

namespace Platform.Notifications.Tests;

[TestClass]
public sealed class ApnsPushTests
{
    [TestMethod]
    public void ProviderJwtUsesTheTeamP256KeyAndReusesItAcrossTopicsForFortyMinutes()
    {
        using var test = new Fixture();
        var token = test.Tokens.Get(); var parts = token.Split('.');
        static byte[] Decode(string value) => Convert.FromBase64String(value.Replace('-','+').Replace('_','/') + new string('=',(4-value.Length%4)%4));
        using var header = JsonDocument.Parse(Decode(parts[0])); using var payload = JsonDocument.Parse(Decode(parts[1]));
        using var key = ECDsa.Create(); key.ImportFromPem(File.ReadAllText(test.Options.KeyFile));
        Assert.AreEqual("ES256",header.RootElement.GetProperty("alg").GetString());
        Assert.AreEqual(test.Options.KeyId,header.RootElement.GetProperty("kid").GetString());
        Assert.AreEqual(test.Options.DevelopmentTeam,payload.RootElement.GetProperty("iss").GetString());
        Assert.AreEqual(test.Clock.Now.ToUnixTimeSeconds(),payload.RootElement.GetProperty("iat").GetInt64());
        Assert.IsTrue(key.VerifyData(Encoding.ASCII.GetBytes(parts[0]+"."+parts[1]),Decode(parts[2]),HashAlgorithmName.SHA256,DSASignatureFormat.IeeeP1363FixedFieldConcatenation));
        test.Clock.Now += TimeSpan.FromMinutes(39); Assert.AreEqual(token,test.Tokens.Get());
        test.Clock.Now += TimeSpan.FromMinutes(1); Assert.AreNotEqual(token,test.Tokens.Get());
        test.Clock.Now -= TimeSpan.FromSeconds(1); Assert.ThrowsException<InvalidOperationException>(()=>test.Tokens.Get());
    }

    [TestMethod]
    public void KeysMustBePrivateP256AndOwnerOnlyWithoutSymlinks()
    {
        using var test = new Fixture();
        using var wrong = ECDsa.Create(ECCurve.NamedCurves.nistP384);
        File.WriteAllText(test.Options.KeyFile,wrong.ExportPkcs8PrivateKeyPem());
        Assert.ThrowsException<InvalidOperationException>(()=>new ApnsProviderTokens(test.Options,test.Clock));
        using var valid = ECDsa.Create(ECCurve.NamedCurves.nistP256);
        File.WriteAllText(test.Options.KeyFile,valid.ExportSubjectPublicKeyInfoPem());
        Assert.ThrowsException<InvalidOperationException>(()=>new ApnsProviderTokens(test.Options,test.Clock));
        File.WriteAllText(test.Options.KeyFile,valid.ExportPkcs8PrivateKeyPem());
        if (!OperatingSystem.IsWindows())
        {
            File.SetUnixFileMode(test.Options.KeyFile,UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.GroupRead);
            Assert.ThrowsException<InvalidOperationException>(()=>new ApnsProviderTokens(test.Options,test.Clock));
            File.SetUnixFileMode(test.Options.KeyFile,UnixFileMode.UserRead|UnixFileMode.UserWrite);
            var link = Path.Combine(test.Directory,"linked.p8"); File.CreateSymbolicLink(link,test.Options.KeyFile);
            Assert.ThrowsException<InvalidOperationException>(()=>new ApnsProviderTokens(Fixture.Settings(link),test.Clock));
        }
    }

    [TestMethod]
    public void TokenFormatSupportsVariableLengthAndRejectsOtherEnvironmentsOrUnsafePathBytes()
    {
        Assert.AreEqual("aabb",ApnsRegistrationToken.Decode(ApnsRegistrationToken.Prefix+"AABB"));
        foreach (var invalid in new[]{"", "apns-v1:sandbox:aabb", "apns-v2:production:aabb", ApnsRegistrationToken.Prefix+"abc",ApnsRegistrationToken.Prefix+"aabb/../../",ApnsRegistrationToken.Prefix+new string('a',514)})
            Assert.ThrowsException<ArgumentException>(()=>ApnsRegistrationToken.Decode(invalid));
    }

    [TestMethod]
    public async Task CanonicalTenantOwnsTheTopicAndEachNewTenantUsesItsOwnConnectionPool()
    {
        using var test = new Fixture(); var a=test.Add("a","notify-project-a","600001"); var b=test.Add("b","notify-project-b","600002");
        var one=await test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"AABB",ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body"));
        var two=await test.Sender.SendAsync("b",[ApnsRegistrationToken.Prefix+"bbcc"],new("Other","Body"));
        Assert.AreEqual(1,one.Attempted); Assert.AreEqual(1,one.Accepted); Assert.AreEqual(1,two.Accepted);
        CollectionAssert.AreEqual(new[]{a.IosBundleId,b.IosBundleId},test.Http.Topics.ToArray());
        Assert.AreEqual(2,test.Http.Pools);
        Assert.AreEqual("/3/device/aabb",test.Http.Paths[0]);
        Assert.AreEqual("alert",test.Http.PushTypes[0]); Assert.AreEqual("10",test.Http.Priorities[0]);
        Assert.AreEqual(test.Clock.Now.AddHours(1).ToUnixTimeSeconds().ToString(),test.Http.Expirations[0]);
    }

    [TestMethod]
    public async Task ForeignTenantTeamAndLegacyTransportFailBeforeNetwork()
    {
        using var test = new Fixture(); var a=test.Add("a","notify-project-a","600001"); var b=test.Add("b","notify-project-b","600002");
        foreach(var invalid in new[]{a with{TenantId=b.TenantId},a with{IosDevelopmentTeam="FOREIGN123"},a with{IosPushTransport="Fcm"}})
        {
            test.Store.Values[(a.TenantId,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(invalid);
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        }
        Assert.AreEqual(0,test.Http.Pools);
    }

    [TestMethod]
    public async Task DeadDevicesDoNotSuppressValidRecipients()
    {
        using var test = new Fixture();test.Add("a","notify-project-a","600001");
        test.Http.Reply=(request)=>request.RequestUri!.AbsolutePath.EndsWith("aabb") ? Response(HttpStatusCode.BadRequest,"BadDeviceToken") : Ok();
        var result=await test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb",ApnsRegistrationToken.Prefix+"bbcc"],new("Title","Body"));
        Assert.AreEqual(2,result.Attempted); Assert.AreEqual(1,result.Accepted);
        test.Http.Reply=(_)=>Response(HttpStatusCode.Gone,"Unregistered");
        Assert.AreEqual(0,(await test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body"))).Accepted);
    }

    [TestMethod]
    public async Task ProviderDenialsRedirectsAndMalformedReceiptsNeverBecomeSuccessOrExposeTokens()
    {
        using var test = new Fixture();test.Add("a","notify-project-a","600001");
        foreach(var reply in new Func<HttpRequestMessage,HttpResponseMessage>[] {
            _=>Response(HttpStatusCode.Forbidden,"InvalidProviderToken"), _=>Response(HttpStatusCode.Redirect,"private-provider-detail"),
            _=>new(HttpStatusCode.OK){Version=HttpVersion.Version20}, _=>new(HttpStatusCode.OK){Version=HttpVersion.Version11},
            _=>Response(HttpStatusCode.TooManyRequests,"TooManyRequests"),
            _=>new(HttpStatusCode.BadRequest){Version=HttpVersion.Version20,Content=new StringContent(new string('x',5000))}})
        {
            test.Http.Reply=reply;
            var error=await Assert.ThrowsExceptionAsync<ApnsApiException>(()=>test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
            Assert.IsFalse(error.ToString().Contains("aabb")); Assert.IsFalse(error.ToString().Contains("private-provider-detail")); Assert.IsNull(error.InnerException);
        }
        test.Http.Reply=(_)=>throw new HttpRequestException("https://api.push.apple.com/3/device/private-device-token");
        var transport=await Assert.ThrowsExceptionAsync<ApnsApiException>(()=>test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        Assert.AreEqual("Transport",transport.Code); Assert.IsFalse(transport.ToString().Contains("private-device-token"));
    }

    [DataTestMethod]
    [DataRow("[]")][DataRow("{\"reason\":123}")][DataRow("{\"reason\":null}")][DataRow("{}")]
    public async Task MalformedProviderReasonsUseOnlyTheSanitizedProtocolError(string body)
    {
        using var test = new Fixture(); test.Add("a","notify-project-a","600001");
        test.Http.Reply = _ => new(HttpStatusCode.BadRequest) { Version = HttpVersion.Version20, Content = new StringContent(body) };
        var error = await Assert.ThrowsExceptionAsync<ApnsApiException>(() => test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        Assert.AreEqual("Protocol", error.Code); Assert.IsNull(error.InnerException);
    }
    [TestMethod]
    public async Task MultipleApnsReceiptIdsCannotPassAsOneDelivery()
    {
        using var test = new Fixture(); test.Add("a","notify-project-a","600001");
        test.Http.Reply = _ => { var result = Ok(); result.Headers.Add("apns-id", Guid.NewGuid().ToString()); return result; };
        var error = await Assert.ThrowsExceptionAsync<ApnsApiException>(() => test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        Assert.AreEqual("Receipt", error.Code);
    }
    [TestMethod]
    public async Task SilentAndRichPayloadsKeepDataAndUseTheRequiredApnsHeaders()
    {
        using var test = new Fixture();test.Add("a","notify-project-a","600001");
        await test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new(null,null,Data:new Dictionary<string,string>{{"Type","cache_invalidation"}}));
        Assert.AreEqual("background",test.Http.PushTypes[0]); Assert.AreEqual("5",test.Http.Priorities[0]);
        var silent=test.Http.Payloads[0]; Assert.AreEqual(1,silent["aps"]!["content-available"]!.GetValue<int>()); Assert.IsNull(silent["aps"]!["alert"]);
        await test.Sender.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body","https://example.com/image.jpg","https://example.com/order"));
        var rich=test.Http.Payloads[1];Assert.AreEqual("v1",rich["platform_apns"]!.GetValue<string>());
        Assert.AreEqual("https://example.com/order",rich["data"]!["action_link"]!.GetValue<string>());
        Assert.AreEqual("https://example.com/image.jpg",rich["image"]!.GetValue<string>());
        Assert.AreEqual(1,rich["aps"]!["mutable-content"]!.GetValue<int>());
    }

    [TestMethod]
    public async Task MixedSenderRoutesNativeAppleAndAndroidTokensWithoutForwardingAppleTokensToGoogle()
    {
        using var test = new Fixture();var target=test.Add("a","notify-project-a","600001");using var google=new FcmServer();
        var fcm=new FcmTenantPushSender(test.Store,new(google.Client()));var sender=new FcmApnsTenantPushSender(fcm,test.Sender);
        var result=await sender.SendAsync("a",["android-device",ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body"));
        Assert.AreEqual(2,result.Accepted);Assert.AreEqual("FcmApns",result.Provider);
        Assert.AreEqual("android-device",google.Messages[target.ProjectId]["message"]!["token"]!.GetValue<string>());
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>fcm.SendAsync("a",[ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        google.Messages.Clear();
        test.Store.Values[(target.TenantId,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(target with{IosDevelopmentTeam="FOREIGN123"});
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>sender.SendAsync("a",["android-device",ApnsRegistrationToken.Prefix+"aabb"],new("Title","Body")));
        Assert.AreEqual(0,google.Messages.Count);
    }

    [TestMethod]
    public void CombinedProviderRequiresProductionAndOnlyTheExplicitApnsKey()
    {
        using var test = new Fixture();
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["Notifications:Provider"]="FcmApns",["Notifications:Apns:DevelopmentTeam"]=test.Options.DevelopmentTeam,
            ["Notifications:Apns:KeyId"]=test.Options.KeyId,["Notifications:Apns:KeyFile"]=test.Options.KeyFile }).Build();
        var services=new ServiceCollection();services.AddTenantNotifications(config);services.AddSingleton<Platform.Security.ITenantSecrets>(test.Store);
        var environment=new Mock<IHostEnvironment>();environment.SetupGet(x=>x.EnvironmentName).Returns("Production");services.AddSingleton(environment.Object);
        using var provider=services.BuildServiceProvider();using var scope=provider.CreateScope();
        Assert.IsInstanceOfType<FcmApnsTenantPushSender>(scope.ServiceProvider.GetRequiredService<ITenantPushSender>());
        Assert.IsFalse(services.Any(x=>x.ServiceType==typeof(GoogleCloudOptions)||x.ServiceType==typeof(GoogleTenantProvisioner)));
        Assert.ThrowsException<InvalidOperationException>(()=>new NotificationOptions{Provider="FcmApns"}.Validate("Development",true));
    }

    private static HttpResponseMessage Response(HttpStatusCode status,string reason)=>new(status){Version=HttpVersion.Version20,Content=JsonContent.Create(new{reason})};
    private static HttpResponseMessage Ok(){var response=Response(HttpStatusCode.OK,"");response.Headers.Add("apns-id",Guid.NewGuid().ToString());return response;}
    private sealed class FixedClock : TimeProvider { public DateTimeOffset Now=new(2026,10,16,0,0,0,TimeSpan.Zero);public override DateTimeOffset GetUtcNow()=>Now; }
    private sealed class ApnsServer : IApnsHttpClients
    {
        public int Pools;public List<string> Topics=[],Paths=[],PushTypes=[],Priorities=[],Expirations=[];public List<JsonNode> Payloads=[];
        public Func<HttpRequestMessage,HttpResponseMessage> Reply=(_)=>Ok();
        public HttpClient Create(){Pools++;return new(new Handler(this));}
        private sealed class Handler(ApnsServer server) : HttpMessageHandler
        {
            protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)
            {
                Assert.AreEqual("api.push.apple.com",request.RequestUri!.Host); Assert.AreEqual("https",request.RequestUri.Scheme);
                Assert.AreEqual(HttpVersion.Version20,request.Version);Assert.AreEqual(HttpVersionPolicy.RequestVersionExact,request.VersionPolicy);
                server.Topics.Add(request.Headers.GetValues("apns-topic").Single());server.Paths.Add(request.RequestUri.AbsolutePath);
                server.PushTypes.Add(request.Headers.GetValues("apns-push-type").Single());server.Priorities.Add(request.Headers.GetValues("apns-priority").Single());
                server.Expirations.Add(request.Headers.GetValues("apns-expiration").Single());server.Payloads.Add(JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!);
                return server.Reply(request);
            }
        }
    }
    private sealed class Fixture : IDisposable
    {
        public string Directory { get; }=Path.Combine(OperatingSystem.IsMacOS()?"/private/tmp":Path.GetTempPath(),"apns-contract-"+Guid.NewGuid().ToString("N"));
        public ApnsOptions Options;public FixedClock Clock=new();public TenantStore Store=new();public ApnsServer Http=new();public ApnsProviderTokens Tokens;public ApnsTenantPushSender Sender;
        public Fixture()
        {
            System.IO.Directory.CreateDirectory(Directory);var path=Path.Combine(Directory,"key.p8");using var key=ECDsa.Create(ECCurve.NamedCurves.nistP256);
            File.WriteAllText(path,key.ExportPkcs8PrivateKeyPem());if(!OperatingSystem.IsWindows())File.SetUnixFileMode(path,UnixFileMode.UserRead|UnixFileMode.UserWrite);
            Options=Settings(path);Tokens=new(Options,Clock);Sender=new(Store,Options,Tokens,Http,Clock);
        }
        public static ApnsOptions Settings(string path)=>new(){DevelopmentTeam="ABC123DEFG",KeyId="KEY1234567",KeyFile=path};
        public TenantFirebaseConfiguration Add(string alias,string project,string number)
        {
            var value=Store.Add(alias,project,number) with{IosPushTransport="Apns",IosDevelopmentTeam=Options.DevelopmentTeam};
            Store.Values[(value.TenantId,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(value);return value;
        }
        public void Dispose(){Tokens.Dispose();System.IO.Directory.Delete(Directory,true);}
    }
}
