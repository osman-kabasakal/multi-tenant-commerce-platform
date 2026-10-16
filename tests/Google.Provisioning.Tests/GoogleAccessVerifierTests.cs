using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;

namespace Platform.Google.Tests;

[TestClass]
public sealed class GoogleAccessVerifierTests
{
    [TestMethod]
    public async Task CheckDoesNotMutateAndUsesExplicitTargetRatherThanCredentialParent()
    {
        using var handler = new AccessServer();
        var report = await handler.Verifier().CheckAsync("access-project", "folders/222");
        Assert.IsTrue(report.Checks.All(x => x.Status == "passed"));
        Assert.AreEqual("organizations/111", report.CredentialProjectParent);
        Assert.AreEqual("folders/222", report.TargetParent);
        Assert.IsTrue(handler.Paths.Contains("/v3/folders/222:testIamPermissions"));
        Assert.IsFalse(handler.Paths.Contains("/v3/organizations/111:testIamPermissions"));
        Assert.AreEqual("count:2", report.Checks.Single(x => x.Name == "androidApps").Details.Single());
        Assert.AreEqual("count:1", report.Checks.Single(x => x.Name == "distribution-groups").Details.Single());
        Assert.IsFalse(JsonSerializer.Serialize(report).Contains("private-provider-detail"));
    }

    [TestMethod]
    public async Task NoParentRemainsUnconfiguredEvenWithCredentialProjectParent()
    {
        using var handler = new AccessServer();
        var report = await handler.Verifier().CheckAsync("access-project", null);
        Assert.IsNull(report.TargetParent);
        Assert.AreEqual("not-configured", report.Checks.Single(x => x.Name == "target-parent-permissions").Status);
        Assert.IsFalse(handler.Paths.Any(x => x.Contains("/organizations/") || x.Contains("/folders/")));
    }

    [TestMethod]
    public async Task DisabledApiAndAbsentParentPermissionAreReportedWithoutEnablingOrGranting()
    {
        using var handler = new AccessServer { DisabledCrashlytics = true, MissingParentPermission = true };
        var report = await handler.Verifier().CheckAsync("access-project", "folders/222");
        Assert.AreEqual("disabled", report.Checks.Single(x => x.Name == "firebasecrashlytics.googleapis.com").Status);
        var parent = report.Checks.Single(x => x.Name == "target-parent-permissions");
        Assert.AreEqual("missing-permissions", parent.Status);
        CollectionAssert.Contains(parent.Details, "missing:resourcemanager.projects.create");
    }

    [TestMethod]
    public async Task ProviderDenialDoesNotBecomeEmptySuccessfulAppListOrLeakBody()
    {
        using var handler = new AccessServer { DenyApps = true };
        var report = await handler.Verifier().CheckAsync("access-project", "folders/222");
        var check = report.Checks.Single(x => x.Name == "androidApps");
        Assert.AreEqual("unavailable", check.Status);
        Assert.AreEqual(403, check.HttpStatus);
        Assert.AreEqual(0, check.Details.Length);
        Assert.IsFalse(JsonSerializer.Serialize(report).Contains("private-provider-detail"));
        Assert.AreEqual("passed", report.Checks.Single(x => x.Name == "target-parent-permissions").Status);
    }

    [TestMethod]
    public async Task ProjectAndFirebaseIdentitiesMustMatch()
    {
        using var handler = new AccessServer { WrongFirebaseProject = true };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => handler.Verifier().CheckAsync("access-project", null));
    }

    [TestMethod]
    public async Task RepeatingPaginationCannotHangDiagnostic()
    {
        using var handler = new AccessServer { RepeatingPage = true };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => handler.Verifier().CheckAsync("access-project", null));
    }

    [TestMethod]
    public async Task MalformedTargetsAreRejectedBeforeAuthenticationOrNetwork()
    {
        using var handler = new AccessServer();
        foreach (var parent in new[] { "projects/222", "folders/0", "folders/222/../projects", "https://example.com/token" })
            await Assert.ThrowsExceptionAsync<ArgumentException>(() => handler.Verifier().CheckAsync("access-project", parent));
        await Assert.ThrowsExceptionAsync<ArgumentException>(() => handler.Verifier().CheckAsync("access-project/else", null));
        Assert.AreEqual(0, handler.Paths.Count);
        Assert.AreEqual(0, handler.Tokens.Scopes.Count);
    }

    private sealed class AccessServer : HttpMessageHandler
    {
        public bool DisabledCrashlytics, MissingParentPermission, DenyApps, WrongFirebaseProject, RepeatingPage;
        public List<string> Paths { get; } = [];
        public ContractTokens Tokens { get; } = new();
        public GoogleAccessVerifier Verifier() => new(new GoogleRestClient(new HttpClient(this, false), Tokens));
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
        {
            var uri = request.RequestUri!;
            var path = uri.AbsolutePath;
            Paths.Add(path);
            Assert.AreEqual("https", uri.Scheme);
            Assert.AreEqual("contract-token", request.Headers.Authorization?.Parameter);
            Assert.IsTrue(request.Method == HttpMethod.Get ||
                (request.Method == HttpMethod.Post && path.EndsWith(":testIamPermissions")), "Diagnostic attempted a mutating request.");
            object value;
            if (path.EndsWith(":testIamPermissions"))
            {
                var body = JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!;
                value = new { permissions = MissingParentPermission && path.Contains("/folders/")
                    ? Array.Empty<string>() : body["permissions"]!.AsArray().Select(x => x!.GetValue<string>()).ToArray() };
            }
            else if (uri.Host == "cloudresourcemanager.googleapis.com")
                value = new { name = "projects/123456", projectId = "access-project", state = "ACTIVE", parent = "organizations/111" };
            else if (uri.Host == "serviceusage.googleapis.com")
                value = new { state = DisabledCrashlytics && path.EndsWith("firebasecrashlytics.googleapis.com") ? "DISABLED" : "ENABLED" };
            else if (path.EndsWith("/androidApps") || path.EndsWith("/iosApps"))
            {
                if (DenyApps) return new(HttpStatusCode.Forbidden) { Content = JsonContent.Create(new { error = "private-provider-detail" }) };
                value = new { apps = new[] { new { appId = "private-provider-detail" } },
                    nextPageToken = RepeatingPage || !uri.Query.Contains("pageToken=") ? "next-page" : null };
            }
            else if (uri.Host == "firebaseappdistribution.googleapis.com")
                value = new { groups = new[] { new { name = "private-provider-detail" } } };
            else value = new { projectId = WrongFirebaseProject ? "foreign-project" : "access-project", projectNumber = "123456", state = "ACTIVE" };
            return new(HttpStatusCode.OK) { Content = JsonContent.Create(value) };
        }
    }
}
