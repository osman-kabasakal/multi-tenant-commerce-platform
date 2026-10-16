using System.Net;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;

namespace Platform.Google.Tests;

[TestClass]
public sealed class GoogleProvisioningTests
{
    internal static GoogleCloudOptions Options(bool allow = true, string? billing = null, bool apns = false, string? team = "ABC123DEFG") => new()
    {
        AllowCloudWrites = allow, DeploymentId = "contract-deployment", ProjectIdPrefix = "contract",
        Parent = "folders/123456", SenderServiceAccount = "sender-account@sender-project.iam.gserviceaccount.com",
        TesterEmails = ["tester@example.com"], IncludeOwnerAsTester = true, PollIntervalSeconds = 1, BillingAccount = billing,
        IosPushTransport = apns ? "Apns" : "Fcm", IosDevelopmentTeam = apns ? team : null
    };
    internal static GoogleTenantSpec Tenant() { var id = Guid.NewGuid().ToString("N"); return new(id, "Contract Store", "owner@example.com", "com.example.t" + id, "com.example.t" + id); }

    [TestMethod]
    public async Task ProvisionAndReplayReuseOwnedProjectAppsPolicyAndGroup()
    {
        using var server = new GoogleServer(); var api = server.Client(); var options = Options(); var spec = Tenant();
        var service = new GoogleTenantProvisioner(api, options);
        var first = await service.EnsureAsync(spec, default);
        var second = await service.EnsureAsync(spec, default);
        Assert.AreEqual(first, second);
        Assert.AreEqual(1, server.ProjectCreates); Assert.AreEqual(2, server.AppCreates); Assert.AreEqual(1, server.GroupCreates);
        Assert.AreEqual(1, server.PolicyWrites);
        Assert.IsTrue(first.ProjectId.Length <= 30); Assert.AreEqual(spec.TenantId, server.Projects[first.ProjectId]["labels"]!["platform-tenant"]!.GetValue<string>());
        CollectionAssert.AreEquivalent(new[] { "owner@example.com", "tester@example.com" }, server.JoinedEmails);
        Assert.IsTrue(server.EnabledServices.Contains("firebasecrashlytics.googleapis.com"));
        Assert.IsFalse(server.Paths.Any(p => p.Contains("serviceAccountKeys", StringComparison.OrdinalIgnoreCase)));
    }

    [TestMethod]
    public async Task ApnsProvisioningExportsOnlyPublicTransportAndTeamForTheOwnedAppleApp()
    {
        using var server = new GoogleServer();
        var spec = Tenant() with { IosBundleId = "com.example.tenant-coffee" };
        var config = await new GoogleTenantProvisioner(server.Client(), Options(apns: true)).EnsureAsync(spec, default);
        Assert.AreEqual("Apns", config.IosPushTransport); Assert.AreEqual("ABC123DEFG", config.IosDevelopmentTeam);
        var directory = Path.Combine(Path.GetTempPath(), "apns-sdk-" + Guid.NewGuid().ToString("N"));
        try
        {
            await FirebaseClientFiles.ExportAsync(config, directory);
            using var client = JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(directory, "firebase-client.json")));
            Assert.AreEqual("Apns", client.RootElement.GetProperty("iosPushTransport").GetString());
            Assert.AreEqual(config.IosDevelopmentTeam, client.RootElement.GetProperty("iosDevelopmentTeam").GetString());
            Assert.AreEqual(spec.IosBundleId, client.RootElement.GetProperty("iosBundleId").GetString());
            Assert.IsFalse(client.RootElement.TryGetProperty("keyId", out _));
            Assert.IsFalse(client.RootElement.TryGetProperty("keyFile", out _));
            Assert.IsFalse(server.Paths.Any(path => path.Contains("apns", StringComparison.OrdinalIgnoreCase)));
        }
        finally { if (Directory.Exists(directory)) Directory.Delete(directory, true); }
    }
    [DataTestMethod]
    [DataRow(null)][DataRow("")][DataRow("abc123defg")][DataRow("ABC123DEFG\n")]
    public async Task ApnsTeamIsValidatedBeforeGoogleResourceCreation(string? team)
    {
        using var server = new GoogleServer();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(server.Client(), Options(apns: true, team: team)).EnsureAsync(Tenant(), default));
        Assert.AreEqual(0, server.Paths.Count);
    }
    [TestMethod]
    public async Task ForeignProjectIsNeverAdoptedOrMutated()
    {
        using var server = new GoogleServer(); var api = server.Client(); var options = Options(); var spec = Tenant();
        var service = new GoogleTenantProvisioner(api, options); var saved = await service.EnsureAsync(spec, default);
        server.Projects[saved.ProjectId]["labels"]!["platform-tenant"] = Guid.NewGuid().ToString("N");
        var writes = server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => service.EnsureAsync(spec, default));
        Assert.AreEqual(writes, server.Writes);
    }

    [TestMethod]
    public async Task PartialSetupResumesAfterProviderErrorWithoutDuplicateProject()
    {
        using var server = new GoogleServer { FailEnableOnce = true }; var api = server.Client(); var spec = Tenant();
        var service = new GoogleTenantProvisioner(api, Options());
        await Assert.ThrowsExceptionAsync<GoogleApiException>(() => service.EnsureAsync(spec, default));
        var result = await service.EnsureAsync(spec, default);
        Assert.AreEqual(1, server.ProjectCreates); Assert.AreEqual(2, server.AppCreates);
        Assert.AreEqual(spec.TenantId, result.TenantId);
    }

    [TestMethod]
    public async Task ProviderFailureDoesNotExposeResponseBody()
    {
        using var server = new GoogleServer { DenyAll = true };
        var error = await Assert.ThrowsExceptionAsync<GoogleApiException>(() => new GoogleTenantProvisioner(server.Client(), Options()).EnsureAsync(Tenant(), default));
        Assert.AreEqual(HttpStatusCode.Forbidden, error.StatusCode);
        Assert.IsFalse(error.ToString().Contains("private-provider-detail"));
    }

    [TestMethod]
    public async Task PendingOperationIsPolledAndErrorOperationIsRejected()
    {
        using var server = new GoogleServer { PendingCreate = true };
        await new GoogleTenantProvisioner(server.Client(), Options()).EnsureAsync(Tenant(), default);
        Assert.IsTrue(server.Paths.Contains("cloudresourcemanager.googleapis.com/v3/operations/create-contract"));
        var error = await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => server.Client().WaitAsync(GoogleApi.Firebase, "v1beta1",
            new JsonObject { ["done"] = true, ["error"] = new JsonObject { ["message"] = "private-provider-detail" } }, Options(), default));
        Assert.IsFalse(error.ToString().Contains("private-provider-detail"));
    }

    [TestMethod]
    public async Task ExistingConditionalIamBindingsAndEtagArePreserved()
    {
        using var server = new GoogleServer();
        server.Policy["bindings"]!.AsArray().Add(JsonNode.Parse("""{"role":"roles/firebasecloudmessaging.admin","members":["serviceAccount:other@example.com"],"condition":{"title":"temporary","expression":"false"}}"""));
        await new GoogleTenantProvisioner(server.Client(), Options()).EnsureAsync(Tenant(), default);
        Assert.AreEqual("policy-version", server.LastPolicy!["etag"]!.GetValue<string>());
        Assert.AreEqual("false", server.LastPolicy["bindings"]!.AsArray().OfType<JsonObject>().Single(p => p["condition"] != null)["condition"]!["expression"]!.GetValue<string>());
        Assert.AreEqual(3, server.LastPolicy["bindings"]!.AsArray().Count);
    }

    [TestMethod]
    public async Task IamConflictStopsSetupRatherThanOverwritingAnotherWriter()
    {
        using var server = new GoogleServer { PolicyConflict = true };
        var error = await Assert.ThrowsExceptionAsync<GoogleApiException>(() => new GoogleTenantProvisioner(server.Client(), Options()).EnsureAsync(Tenant(), default));
        Assert.AreEqual(HttpStatusCode.Conflict, error.StatusCode); Assert.AreEqual(0, server.GroupCreates);
    }

    [TestMethod]
    public async Task BillingAccountMismatchIsNotRelinked()
    {
        using var server = new GoogleServer { BillingAccount = "billingAccounts/000000-000000-000000" };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(server.Client(), Options(billing: "billingAccounts/ABCDEF-123456-ABCDEF")).EnsureAsync(Tenant(), default));
        Assert.AreEqual(0, server.BillingWrites); Assert.AreEqual(0, server.AppCreates);
    }

    [TestMethod]
    public async Task AppPaginationFindsExistingAppsWithoutCreatingDuplicates()
    {
        using var server = new GoogleServer(); var service = new GoogleTenantProvisioner(server.Client(), Options()); var tenant = Tenant();
        await service.EnsureAsync(tenant, default); server.Paginate = true;
        await service.EnsureAsync(tenant, default);
        Assert.AreEqual(2, server.AppCreates); Assert.IsTrue(server.Paths.Any(p => p.Contains("pageToken=next-page")));
    }

    [TestMethod]
    public async Task MismatchedClientConfigCannotBePublished()
    {
        using var server = new GoogleServer { WrongConfig = true };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(server.Client(), Options()).EnsureAsync(Tenant(), default));
    }

    [TestMethod]
    public async Task FcmUsesEachTenantProjectAndMessagingScopeConcurrently()
    {
        using var server = new GoogleServer(); var api = server.Client(); var provision = new GoogleTenantProvisioner(api, Options());
        var a = await provision.EnsureAsync(Tenant(), default); var b = await provision.EnsureAsync(Tenant(), default);
        var messaging = new FirebaseCloudMessaging(api);
        var results = await Task.WhenAll(messaging.SendAsync(a, "device-a", "A", "Message A"), messaging.SendAsync(b, "device-b", "B", "Message B"));
        Assert.IsTrue(results[0].StartsWith("projects/" + a.ProjectId + "/messages/"));
        Assert.IsTrue(results[1].StartsWith("projects/" + b.ProjectId + "/messages/"));
        Assert.AreEqual("device-a", server.Messages[a.ProjectId]["message"]!["token"]!.GetValue<string>());
        Assert.AreEqual("device-b", server.Messages[b.ProjectId]["message"]!["token"]!.GetValue<string>());
        Assert.AreEqual(2, server.Tokens.Scopes.Count(s => s == GoogleRestClient.MessagingScope));
    }

    [TestMethod]
    public async Task DistributionUploadsBinaryAndDistributesOnlyToOwnedAppGroup()
    {
        using var server = new GoogleServer(); var api = server.Client(); var options = Options();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default);
        var file = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".apk");
        try
        {
            await File.WriteAllBytesAsync(file, [1,2,3,4]);
            var release = await new FirebaseAppDistribution(api, options).UploadAndDistributeAsync(config, "android", file);
            Assert.IsTrue(release.StartsWith($"projects/{config.ProjectNumber}/apps/{config.AndroidAppId}/releases/"));
            CollectionAssert.AreEqual(new byte[] {1,2,3,4}, server.UploadBytes!);
            Assert.AreEqual("raw", server.UploadProtocol); Assert.AreEqual(config.DistributionGroupAlias, server.DistributedGroup);
            server.WrongRelease = true; var before = server.Distributes;
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppDistribution(api, options).UploadAndDistributeAsync(config, "android", file));
            Assert.AreEqual(before, server.Distributes);
        }
        finally { File.Delete(file); }
    }

    [TestMethod]
    public async Task ForeignDeploymentDistributionIsDeniedBeforeNetworkMutation()
    {
        using var server = new GoogleServer(); var api = server.Client(); var options = Options();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default);
        var writes = server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppDistribution(api, options).UploadAndDistributeAsync(config with { TenantId = Guid.NewGuid().ToString("N") }, "android", "test.apk"));
        Assert.AreEqual(writes, server.Writes);
    }

    [TestMethod]
    public async Task ApiHostCannotBeOverriddenByAbsoluteOrTraversingPaths()
    {
        using var server = new GoogleServer(); var api = server.Client();
        await Assert.ThrowsExceptionAsync<ArgumentException>(() => api.SendAsync(GoogleApi.Firebase, HttpMethod.Get, "https://example.com/token", null, default));
        await Assert.ThrowsExceptionAsync<ArgumentException>(() => api.SendAsync(GoogleApi.Firebase, HttpMethod.Get, "v1/../token", null, default));
        Assert.AreEqual(0, server.Paths.Count);
    }

    [TestMethod]
    public void CloudWritesRequireExplicitPermissionAndStableTarget()
    {
        Assert.ThrowsException<InvalidOperationException>(() => Options(allow: false).Validate());
        Assert.ThrowsException<InvalidOperationException>(() => new GoogleCloudOptions { AllowCloudWrites = true }.Validate());
        var tenant = Tenant().TenantId; Assert.AreEqual(Options().ProjectId(tenant), Options().ProjectId(tenant));
        Assert.AreNotEqual(Options().ProjectId(tenant), Options().ProjectId(Tenant().TenantId));
    }
}

internal sealed class ContractTokens : IGoogleAccessTokenSource
{
    public List<string> Scopes { get; } = [];
    public Task<string> GetAsync(string scope, CancellationToken ct) { lock(Scopes) Scopes.Add(scope); return Task.FromResult("contract-token"); }
}

internal sealed class GoogleServer : HttpMessageHandler
{
    public Dictionary<string,JsonObject> Projects = []; public Dictionary<string,JsonObject> Messages = [];
    private readonly Dictionary<string,List<JsonObject>> apps = []; private readonly HashSet<string> firebase = []; private readonly HashSet<string> groups = [];
    public JsonObject Policy = JsonNode.Parse("""{"version":3,"etag":"policy-version","bindings":[{"role":"roles/viewer","members":["group:existing@example.com"]}]}""")!.AsObject();
    public JsonObject? LastPolicy; public string[] JoinedEmails = []; public List<string> EnabledServices = []; public List<string> Paths = [];
    public int ProjectCreates, AppCreates, GroupCreates, PolicyWrites, Writes, BillingWrites, Distributes;
    public bool DenyAll, FailEnableOnce, PendingCreate, PolicyConflict, Paginate, WrongConfig, WrongRelease;
    public string? BillingAccount, UploadProtocol, DistributedGroup; public byte[]? UploadBytes;
    public ContractTokens Tokens = new();
    public GoogleRestClient Client() => new(new HttpClient(this, disposeHandler: false), Tokens);
    private static HttpResponseMessage Reply(object value, HttpStatusCode status = HttpStatusCode.OK) => new(status) { Content = JsonContent.Create(value) };
    private static JsonObject Done(object? response = null) => new() { ["done"] = true, ["response"] = JsonSerializer.SerializeToNode(response ?? new { }) };

    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
    {
        Assert.AreEqual("Bearer", request.Headers.Authorization?.Scheme); Assert.AreEqual("contract-token", request.Headers.Authorization?.Parameter);
        var uri = request.RequestUri!; var path = Uri.UnescapeDataString(uri.AbsolutePath.TrimStart('/')); var parts = path.Split('/');
        lock(Paths) Paths.Add(uri.Host + "/" + path + uri.Query);
        if (request.Method != HttpMethod.Get) Writes++;
        if (DenyAll) return Reply(new { error = new { message = "private-provider-detail" } }, HttpStatusCode.Forbidden);
        JsonObject body = new();
        if (request.Content?.Headers.ContentType?.MediaType == "application/json") body = (JsonNode.Parse(await request.Content.ReadAsStringAsync(ct)) as JsonObject)!;
        var post = request.Method == HttpMethod.Post;
        if (uri.Host == "cloudresourcemanager.googleapis.com")
        {
            if (path == "v3/projects" && post)
            {
                var id = body["projectId"]!.GetValue<string>(); var p = body.DeepClone().AsObject();
                p["name"] = "projects/" + (600000 + ++ProjectCreates); p["state"] = "ACTIVE"; Projects[id] = p;
                return Reply(PendingCreate ? new JsonObject { ["name"] = "operations/create-contract" } : Done());
            }
            if (path == "v3/operations/create-contract") return Reply(Done());
            if (path.EndsWith(":getIamPolicy")) return Reply(Policy);
            if (path.EndsWith(":setIamPolicy"))
            {
                if (PolicyConflict) return Reply(new { }, HttpStatusCode.Conflict);
                PolicyWrites++; LastPolicy = body["policy"]!.DeepClone().AsObject(); Policy = LastPolicy.DeepClone().AsObject(); return Reply(Policy);
            }
            if (Projects.TryGetValue(parts[2],out var project)) return Reply(project);
            return Reply(new { }, HttpStatusCode.NotFound);
        }
        if (uri.Host == "cloudbilling.googleapis.com")
        {
            if (request.Method == HttpMethod.Put) { BillingWrites++; BillingAccount = body["billingAccountName"]!.GetValue<string>(); }
            return Reply(new { billingAccountName = BillingAccount, billingEnabled = BillingAccount != null });
        }
        if (uri.Host == "serviceusage.googleapis.com")
        {
            if (FailEnableOnce) { FailEnableOnce = false; return Reply(new { }, HttpStatusCode.ServiceUnavailable); }
            EnabledServices = body["serviceIds"]!.AsArray().Select(x => x!.GetValue<string>()).ToList(); return Reply(Done());
        }
        if (uri.Host == "firebase.googleapis.com")
        {
            var id = parts[2].Replace(":addFirebase", ""); var number = Projects[id]["name"]!.GetValue<string>().Split('/')[1];
            if (path.EndsWith(":addFirebase")) { firebase.Add(id); return Reply(Done()); }
            if (parts.Length == 3) return firebase.Contains(id) ? Reply(new { projectId=id, projectNumber=number }) : Reply(new { },HttpStatusCode.NotFound);
            var kind = parts[3]; var key = id + "/" + kind;
            if (!apps.ContainsKey(key)) apps[key] = [];
            if (path.EndsWith("/config"))
            {
                var app = apps[key].Single(a => a["appId"]!.GetValue<string>() == parts[4]);
                var package = app[kind == "androidApps" ? "packageName" : "bundleId"]!.GetValue<string>(); var appId = app["appId"]!.GetValue<string>();
                var projectId = WrongConfig ? "another-project" : id;
                var config = kind == "androidApps" ? JsonSerializer.Serialize(new { project_info = new {project_id=projectId,project_number=number},client = new[] {new {client_info=new {mobilesdk_app_id=appId,android_client_info=new {package_name=package}}}} })
                    : $"<?xml version=\"1.0\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist><dict><key>PROJECT_ID</key><string>{projectId}</string><key>GCM_SENDER_ID</key><string>{number}</string><key>GOOGLE_APP_ID</key><string>{appId}</string><key>BUNDLE_ID</key><string>{package}</string></dict></plist>";
                return Reply(new {configFileContents=Convert.ToBase64String(Encoding.UTF8.GetBytes(config))});
            }
            if (post)
            {
                var appId = $"1:{number}:{(kind=="androidApps"?"android":"ios")}:a{++AppCreates}";
                var app = body.DeepClone().AsObject(); app["appId"]=appId; app["name"]=$"projects/{id}/{kind}/{appId}"; app["state"]="ACTIVE"; apps[key].Add(app);
                return Reply(Done(app));
            }
            if (Paginate && !uri.Query.Contains("pageToken=")) return Reply(new { apps = Array.Empty<object>(), nextPageToken = "next-page" });
            return Reply(new {apps=apps[key]});
        }
        if (uri.Host == "fcm.googleapis.com")
        {
            lock(Messages) Messages[parts[2]]=body;
            return Reply(new {name=$"projects/{parts[2]}/messages/contract-message"});
        }
        if (uri.Host == "firebaseappdistribution.googleapis.com")
        {
            if (path.StartsWith("upload/"))
            {
                UploadProtocol=request.Headers.GetValues("X-Goog-Upload-Protocol").Single(); UploadBytes=await request.Content!.ReadAsByteArrayAsync(ct);
                var resource=path["upload/v1/".Length..].Replace("/releases:upload","");
                return Reply(Done(new {release=new {name=(WrongRelease?"projects/other/apps/other":resource)+"/releases/release-a"}}));
            }
            if (path.EndsWith(":distribute")) { Distributes++; DistributedGroup=body["groupAliases"]![0]!.GetValue<string>(); return Reply(new { }); }
            if (path.EndsWith(":batchJoin")) { JoinedEmails=body["emails"]!.AsArray().Select(e=>e!.GetValue<string>()).ToArray(); Assert.IsTrue(body["createMissingTesters"]!.GetValue<bool>()); return Reply(new { }); }
            if (post) { GroupCreates++; var group=$"projects/{parts[2]}/groups/tenant-testers"; groups.Add(group); return Reply(new {name=group}); }
            return groups.Contains(path[3..]) ? Reply(new {name=path[3..]}) : Reply(new { },HttpStatusCode.NotFound);
        }
        Assert.Fail("Unexpected API request: " + uri.Host + "/" + path); return Reply(new { },HttpStatusCode.NotFound);
    }
}
