using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class AppleProvisioningTests
{
    [TestMethod]
    public void JwtUsesTheSelectedPrivateP256KeyAndShortLivedTeamClaims()
    {
        using var fixture = new AppleFixture();
        var token = new AppleApiTokens(fixture.Options).Create().Split('.');
        static byte[] Decode(string value) => Convert.FromBase64String(value.Replace('-', '+').Replace('_', '/') + new string('=', (4 - value.Length % 4) % 4));
        var header = JsonNode.Parse(Decode(token[0]))!; var payload = JsonNode.Parse(Decode(token[1]))!;
        Assert.AreEqual("ES256", header["alg"]!.GetValue<string>());
        Assert.AreEqual(fixture.Options.KeyId, header["kid"]!.GetValue<string>());
        Assert.AreEqual(fixture.Options.IssuerId, payload["iss"]!.GetValue<string>());
        Assert.AreEqual("appstoreconnect-v1", payload["aud"]!.GetValue<string>());
        Assert.IsNull(payload["scope"]); Assert.IsNull(payload["sub"]);
        Assert.AreEqual(125L, payload["exp"]!.GetValue<long>() - payload["iat"]!.GetValue<long>());
        using var key = ECDsa.Create(); key.ImportFromPem(File.ReadAllText(fixture.KeyFile));
        Assert.IsTrue(key.VerifyData(Encoding.ASCII.GetBytes(token[0] + "." + token[1]), Decode(token[2]), HashAlgorithmName.SHA256, DSASignatureFormat.IeeeP1363FixedFieldConcatenation));
    }
    [TestMethod]
    public void PublicReadableOrWrongCurveKeysCannotCreateTokens()
    {
        using var fixture = new AppleFixture();
        using var other = ECDsa.Create(ECCurve.NamedCurves.nistP384); File.WriteAllText(fixture.KeyFile, other.ExportPkcs8PrivateKeyPem());
        Assert.ThrowsException<InvalidOperationException>(() => new AppleApiTokens(fixture.Options).Create());
        if (!OperatingSystem.IsWindows())
        {
            File.SetUnixFileMode(fixture.KeyFile, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.GroupRead);
            Assert.ThrowsException<ArgumentException>(() => new AppleApiTokens(fixture.Options).Create());
        }
    }
    [TestMethod]
    public void ConfigRejectsUnknownFieldsSharedPermissionsAndRelativePaths()
    {
        using var fixture = new AppleFixture();
        var path = Path.Combine(fixture.Root, "operator.json");
        File.WriteAllText(path, JsonSerializer.Serialize(fixture.Options));
        if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite);
        Assert.AreEqual(fixture.Options.KeyId, AppleApiOptions.Read(path).KeyId);
        var input = JsonSerializer.SerializeToNode(fixture.Options)!; input["AllowAppleWrite"] = true;
        File.WriteAllText(path, input.ToJsonString());
        Assert.ThrowsException<JsonException>(() => AppleApiOptions.Read(path));
        Assert.ThrowsException<ArgumentException>(() => AppleApiOptions.Read("operator.json"));
        if (!OperatingSystem.IsWindows())
        {
            File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.GroupRead);
            Assert.ThrowsException<ArgumentException>(() => AppleApiOptions.Read(path));
        }
    }
    [TestMethod]
    public async Task MatchingFingerprintCannotAuthorizeACertificateFromAnotherTeam()
    {
        using var fixture = new AppleFixture("ZZZZZ99999");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(0, fixture.Server.Writes); Assert.AreEqual(0, fixture.Secrets.Values.Count);
    }
    [TestMethod]
    public async Task SuccessfulAccessCheckDoesNotClaimSigningOrWriteAnythingEvenWhenWritesAreEnabled()
    {
        using var fixture = new AppleFixture();
        var report = await new AppleAccessVerifier(fixture.Options, fixture.Client()).CheckAsync();
        Assert.IsTrue(report.ReadAccessVerified); Assert.AreEqual(4, report.Checks.Count);
        Assert.AreEqual(1, report.Checks.Single(x => x.Resource == "certificates").MatchingTeamDistributionCertificates);
        Assert.AreEqual(1, report.Checks.Single(x => x.Resource == "devices").EnabledIosDevices);
        Assert.IsFalse(report.ReadyForSignedRelease); Assert.IsFalse(report.SignedIpaBuilt);
        Assert.IsFalse(report.LocalSigningIdentityChecked); Assert.IsFalse(report.AppleWritesPerformed);
        Assert.AreEqual(0, fixture.Server.Writes); Assert.AreEqual(4, fixture.Server.Requests);
        var output = JsonSerializer.Serialize(report);
        Assert.IsFalse(output.Contains(fixture.KeyFile)); Assert.IsFalse(output.Contains(new string('A', 40)));
        Assert.IsFalse(output.Contains("synthetic-contract-token")); Assert.IsFalse(output.Contains("BEGIN"));
    }
    [TestMethod]
    public async Task PartialAccessFailureIsReportedWithoutProviderDetailsOrFalseSuccess()
    {
        using var fixture = new AppleFixture();
        fixture.Server.Override = request => request.RequestUri!.AbsolutePath == "/v1/certificates"
            ? AppleServer.Reply(new { errors = new[] { new { code = "FORBIDDEN.REQUIRED_AGREEMENTS_MISSING_OR_EXPIRED", detail = "provider-private-value" } } }, HttpStatusCode.Forbidden)
            : AppleServer.Reply(new { data = Array.Empty<object>(), links = new { next = (string?)null } });
        var report = await new AppleAccessVerifier(fixture.Options, fixture.Client()).CheckAsync();
        Assert.IsFalse(report.ReadAccessVerified); Assert.AreEqual(4, fixture.Server.Requests);
        var failed = report.Checks.Single(x => x.Resource == "certificates");
        Assert.AreEqual("failed", failed.Status); Assert.AreEqual(403, failed.HttpStatus);
        Assert.AreEqual("FORBIDDEN.REQUIRED_AGREEMENTS_MISSING_OR_EXPIRED", failed.ErrorCode);
        Assert.IsFalse(JsonSerializer.Serialize(report).Contains("provider-private-value")); Assert.AreEqual(0, fixture.Server.Writes);
    }
    [TestMethod]
    public async Task UnavailableOrMalformedAccessResponsesStayIncomplete()
    {
        using var fixture = new AppleFixture();
        fixture.Server.Override = request => request.RequestUri!.AbsolutePath == "/v1/devices"
            ? throw new HttpRequestException("provider-private-transport-detail") : AppleServer.Reply(new { data = "malformed" });
        var report = await new AppleAccessVerifier(fixture.Options, fixture.Client()).CheckAsync();
        Assert.IsFalse(report.ReadAccessVerified); Assert.IsTrue(report.Checks.All(x => x.Status == "unavailable"));
        Assert.AreEqual("TRANSPORT_UNAVAILABLE", report.Checks.Single(x => x.Resource == "devices").ErrorCode);
        Assert.IsFalse(JsonSerializer.Serialize(report).Contains("provider-private-transport-detail")); Assert.AreEqual(0, fixture.Server.Writes);
    }
    [TestMethod]
    public async Task ExplicitWritesAndMatchingTeamAreRequiredBeforeAnyRequest()
    {
        using var fixture = new AppleFixture();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner(fixture.Settings(false)).PrepareAsync(fixture.Plan));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan with { DevelopmentTeam = "ZZZZZ99999" }));
        Assert.AreEqual(0, fixture.Server.Requests); Assert.AreEqual(0, fixture.Secrets.Values.Count);
    }
    [TestMethod]
    public async Task SelectedSigningIdentityMustExistOnTheMacBeforeCreatingAnything()
    {
        using var fixture = new AppleFixture(); fixture.Identity.Available = false;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(0, fixture.Server.Writes); Assert.AreEqual(0, fixture.Secrets.Values.Count);
    }
    [TestMethod]
    public async Task ForeignCertificateAndUnavailableDevicesStopBeforeWrites()
    {
        using var fixture = new AppleFixture();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan with { SigningCertificateSha256 = new string('d', 64) }));
        fixture.Server.DeviceEnabled = false;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(0, fixture.Server.Writes);
    }
    [TestMethod]
    public async Task InitialProvisioningCreatesOnlyOwnedBundlesPushAndExactTesterProfilesAndReplaysWithoutWrites()
    {
        using var fixture = new AppleFixture();
        var first = await fixture.Provisioner().PrepareAsync(fixture.Plan);
        Assert.AreEqual(5, fixture.Server.Writes); Assert.AreEqual(2, fixture.Server.Bundles.Count); Assert.AreEqual(2, fixture.Server.Profiles.Count);
        Assert.AreEqual(1, fixture.Server.PushBundles.Count);
        Assert.AreNotEqual(first.Application.Uuid, first.Extension.Uuid);
        Assert.AreEqual(fixture.Plan.SigningCertificateSha256, first.CertificateSha256);
        foreach (var profile in fixture.Server.Profiles.Values) CollectionAssert.AreEqual(new[] { "D1" }, profile.Devices);
        var second = await fixture.Provisioner().PrepareAsync(fixture.Plan);
        Assert.AreEqual(first.Application.ResourceId, second.Application.ResourceId); Assert.AreEqual(5, fixture.Server.Writes);
        Assert.AreEqual(5, fixture.Secrets.Values.Count);
        Assert.IsFalse(fixture.Secrets.Values.Values.Any(value => value.Contains("BEGIN PRIVATE KEY") || value.Contains(new string('A', 40))));
    }
    [TestMethod]
    public async Task ExistingMerchantBundleIsNeverRenamedOrAdopted()
    {
        using var fixture = new AppleFixture();
        fixture.Server.Bundles["FOREIGN"] = AppleServer.Resource("bundleIds", "FOREIGN", new { identifier = fixture.Plan.IosBundleId, name = "Existing Merchant App", platform = "IOS" });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(0, fixture.Server.Writes);
        Assert.AreEqual("Existing Merchant App", fixture.Server.Bundles["FOREIGN"]["attributes"]!["name"]!.GetValue<string>());
    }
    [TestMethod]
    public async Task LostCreationResponseReconcilesTheSameOwnedResource()
    {
        using var fixture = new AppleFixture(); fixture.Server.LoseFirstBundleReply = true;
        var result = await fixture.Provisioner().PrepareAsync(fixture.Plan);
        Assert.IsNotNull(result.Application); Assert.AreEqual(5, fixture.Server.Writes); Assert.AreEqual(2, fixture.Server.Bundles.Count);
    }
    [TestMethod]
    public async Task AmbiguousCreationCannotBeResubmittedByAnotherAttemptOrProcess()
    {
        using var fixture = new AppleFixture(); fixture.Server.LoseFirstBundleReply = true; fixture.Server.HideBundles = true;
        await Assert.ThrowsExceptionAsync<AppleCreationAmbiguousException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        await Assert.ThrowsExceptionAsync<AppleCreationAmbiguousException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(1, fixture.Server.Writes); Assert.AreEqual(1, fixture.Server.Bundles.Count);
        fixture.Server.HideBundles = false;
        await fixture.Provisioner().PrepareAsync(fixture.Plan);
        Assert.AreEqual(5, fixture.Server.Writes);
    }
    [TestMethod]
    public async Task ChangedOrExpiredOwnedProfilesAreRejectedWithoutDeletingOrReplacingThem()
    {
        using var fixture = new AppleFixture(); await fixture.Provisioner().PrepareAsync(fixture.Plan);
        var profile = fixture.Server.Profiles.Values.First();
        profile.Devices = ["D1", "FOREIGN"];
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        profile.Devices = ["D1"]; profile.Value["attributes"]!["profileState"] = "INVALID";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Provisioner().PrepareAsync(fixture.Plan));
        Assert.AreEqual(5, fixture.Server.Writes); Assert.AreEqual(2, fixture.Server.Profiles.Count);
    }
    [TestMethod]
    public async Task PaginationCannotMoveBearerTokensToAnotherHostOrLoopForever()
    {
        using var fixture = new AppleFixture();
        fixture.Server.Override = _ => AppleServer.Reply(new { data = Array.Empty<object>(), links = new { next = "https://attacker.example/v1/devices" } });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Client().ListAsync("v1/devices?limit=200", default));
        Assert.AreEqual(1, fixture.Server.Requests);
        fixture.Server.Override = _ => AppleServer.Reply(new { data = Array.Empty<object>(), links = new { next = AppleApiClient.Origin + "v1/devices?limit=200" } });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => fixture.Client().ListAsync("v1/devices?limit=200", default));
        Assert.AreEqual(2, fixture.Server.Requests);
    }
    [TestMethod]
    public async Task ErrorMessagesAndUnsupportedMutationsNeverExposeProviderDetailsOrReachTheServer()
    {
        using var fixture = new AppleFixture(); var client = fixture.Client();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => client.SendAsync(HttpMethod.Delete, "v1/profiles/ANY", null, default));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => client.SendAsync(HttpMethod.Post, "v1/certificates", new { }, default));
        Assert.AreEqual(0, fixture.Server.Requests);
        fixture.Server.Override = _ => AppleServer.Reply(new { errors = new[] { new { code = "FORBIDDEN", detail = "provider-private-secret" } } }, HttpStatusCode.Forbidden);
        var error = await Assert.ThrowsExceptionAsync<AppleApiException>(() => client.SendAsync(HttpMethod.Get, "v1/devices", null, default));
        Assert.AreEqual("FORBIDDEN", error.Code); Assert.IsFalse(error.ToString().Contains("provider-private-secret", StringComparison.Ordinal));
        fixture.Server.Override = _ => AppleServer.Reply(new { errors = Array.Empty<object>() }, HttpStatusCode.Forbidden);
        Assert.AreEqual("UNKNOWN", (await Assert.ThrowsExceptionAsync<AppleApiException>(() => client.SendAsync(HttpMethod.Get, "v1/devices", null, default))).Code);
    }
}

internal sealed class AppleFixture : IDisposable
{
    public readonly string Root = Path.Combine(OperatingSystem.IsMacOS() ? "/private/tmp" : Path.GetTempPath(), "apple-contract-" + Guid.NewGuid().ToString("N"));
    public string KeyFile => Path.Combine(Root, "synthetic-key.p8");
    public readonly AndroidSecrets Secrets = new();
    public readonly AppleServer Server;
    public readonly AppleIdentity Identity = new();
    public readonly IosReleasePlan Plan;
    public AppleApiOptions Options => Settings(true);
    public AppleFixture(string certificateTeam = "ABCDE12345")
    {
        Directory.CreateDirectory(Root);
        using var key = ECDsa.Create(ECCurve.NamedCurves.nistP256); File.WriteAllText(KeyFile, key.ExportPkcs8PrivateKeyPem());
        if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(KeyFile, UnixFileMode.UserRead | UnixFileMode.UserWrite);
        using var rsa = RSA.Create(2048); var csr = new CertificateRequest("CN=Synthetic Distribution, OU=" + certificateTeam, rsa, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        using var certificate = csr.CreateSelfSigned(DateTimeOffset.UtcNow.AddDays(-1), DateTimeOffset.UtcNow.AddDays(100));
        Server = new(certificate.RawData);
        Plan = new(Guid.NewGuid().ToString("N"), "apple-contract", "dev.commerce.applefixture", "ABCDE12345",
            Convert.ToHexString(SHA256.HashData(certificate.RawData)).ToLowerInvariant(), new string('b', 64), 7,
            "apple-fixture-demo", "123456789", "1:123456789:ios:bbbbbbbb", new string('c', 64), "https://apple-coffee.example.test");
    }
    public AppleApiOptions Settings(bool writes) => new() { DevelopmentTeam = "ABCDE12345", KeyId = "KEY1234567", IssuerId = "11111111-2222-3333-4444-555555555555", KeyFile = KeyFile,
        AllowAppleWrites = writes, RequiredDeviceUdids = [new string('A', 40)] };
    public AppleApiClient Client(AppleApiOptions? settings = null) => new(new HttpClient(Server, false), settings ?? Options, new AppleTestTokens());
    public AppleTenantProvisioner Provisioner(AppleApiOptions? settings = null) => new(settings ?? Options, Client(settings), Identity, Secrets);
    public void Dispose() { Server.Dispose(); Directory.Delete(Root, true); }
}
internal sealed class AppleTestTokens : IAppleApiTokens { public string Create() => "synthetic-contract-token"; }
internal sealed class AppleIdentity : IAppleSigningIdentityVerifier
{
    public bool Available = true;
    public Task VerifyAsync(string sha1, string team, CancellationToken ct) => Available ? Task.CompletedTask : Task.FromException(new InvalidOperationException("Synthetic missing signer."));
}
internal sealed class AppleServer(byte[] certificate) : HttpMessageHandler
{
    public readonly Dictionary<string, JsonObject> Bundles = new();
    public readonly Dictionary<string, AppleProfileState> Profiles = new();
    public readonly HashSet<string> PushBundles = [];
    public bool DeviceEnabled = true, LoseFirstBundleReply, HideBundles;
    public int Requests, Writes;
    public Func<HttpRequestMessage, HttpResponseMessage>? Override;
    public static JsonObject Resource(string type, string id, object attributes) => JsonSerializer.SerializeToNode(new { type, id, attributes })!.AsObject();
    public static HttpResponseMessage Reply(object value, HttpStatusCode status = HttpStatusCode.OK) => new(status) { Content = new StringContent(JsonSerializer.Serialize(value), Encoding.UTF8, "application/json") };
    private static HttpResponseMessage Items(IEnumerable<JsonObject> values) => Reply(new { data = values.ToArray(), links = new { next = (string?)null } });
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
    {
        Requests++; Assert.AreEqual("api.appstoreconnect.apple.com", request.RequestUri!.Host); Assert.AreEqual("Bearer", request.Headers.Authorization!.Scheme);
        if (Override != null) return Override(request);
        var path = request.RequestUri.AbsolutePath; var parts = path.Trim('/').Split('/');
        var query = request.RequestUri.Query.TrimStart('?').Split('&', StringSplitOptions.RemoveEmptyEntries).Select(x => x.Split('=', 2)).ToDictionary(x => Uri.UnescapeDataString(x[0]), x => Uri.UnescapeDataString(x[1]));
        if (request.Method == HttpMethod.Get)
        {
            if (path == "/v1/certificates") return Items([Resource("certificates", "C1", new { certificateType = "DISTRIBUTION", expirationDate = DateTimeOffset.UtcNow.AddDays(100), certificateContent = Convert.ToBase64String(certificate) })]);
            if (path == "/v1/devices") return Items([Resource("devices", "D1", new { udid = new string('A', 40), platform = "IOS", status = DeviceEnabled ? "ENABLED" : "DISABLED" })]);
            if (path == "/v1/bundleIds") return Items(HideBundles ? [] : Bundles.Values.Where(x => !query.ContainsKey("filter[identifier]") || x["attributes"]!["identifier"]!.GetValue<string>() == query["filter[identifier]"]));
            if (parts.Length == 4 && parts[1] == "bundleIds") return Items(PushBundles.Contains(parts[2]) ? [Resource("bundleIdCapabilities", "PUSH" + parts[2], new { capabilityType = "PUSH_NOTIFICATIONS" })] : []);
            if (path == "/v1/profiles") return Items(Profiles.Values.Select(x => x.Value).Where(x => !query.ContainsKey("filter[name]") || x["attributes"]!["name"]!.GetValue<string>() == query["filter[name]"]));
            if (parts.Length == 5 && parts[1] == "profiles")
            {
                var profile = Profiles[parts[2]];
                if (parts[4] == "bundleId") return Reply(new { data = new { type = "bundleIds", id = profile.Bundle } });
                var ids = parts[4] == "devices" ? profile.Devices : new[] { "C1" };
                return Reply(new { data = ids.Select(id => new { type = parts[4], id }).ToArray(), links = new { next = (string?)null } });
            }
        }
        if (request.Method == HttpMethod.Post)
        {
            Writes++; var data = JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!["data"]!.AsObject();
            if (path == "/v1/bundleIds")
            {
                var id = "B" + (Bundles.Count + 1); var item = Resource("bundleIds", id, data["attributes"]!); Bundles[id] = item;
                if (LoseFirstBundleReply) { LoseFirstBundleReply = false; throw new HttpRequestException("Synthetic response lost after commit."); }
                return Reply(new { data = item }, HttpStatusCode.Created);
            }
            if (path == "/v1/bundleIdCapabilities")
            {
                var bundle = data["relationships"]!["bundleId"]!["data"]!["id"]!.GetValue<string>(); PushBundles.Add(bundle);
                return Reply(new { data = Resource("bundleIdCapabilities", "PUSH" + bundle, data["attributes"]!) }, HttpStatusCode.Created);
            }
            if (path == "/v1/profiles")
            {
                var id = "P" + (Profiles.Count + 1); var attributes = data["attributes"]!.DeepClone(); attributes["uuid"] = Guid.NewGuid().ToString("D");
                attributes["profileState"] = "ACTIVE"; attributes["expirationDate"] = DateTimeOffset.UtcNow.AddDays(90); attributes["profileContent"] = Convert.ToBase64String(Encoding.ASCII.GetBytes("synthetic-not-an-Apple-CMS"));
                var item = Resource("profiles", id, attributes);
                Profiles[id] = new(item, data["relationships"]!["bundleId"]!["data"]!["id"]!.GetValue<string>(), data["relationships"]!["devices"]!["data"]!.AsArray().Select(x => x!["id"]!.GetValue<string>()).ToArray());
                return Reply(new { data = item }, HttpStatusCode.Created);
            }
        }
        throw new InvalidOperationException("Unexpected synthetic Apple request.");
    }
}
internal sealed class AppleProfileState(JsonObject value, string bundle, string[] devices)
{
    public JsonObject Value = value;
    public string Bundle = bundle;
    public string[] Devices = devices;
}
