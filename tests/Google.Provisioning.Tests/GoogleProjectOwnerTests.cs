using System.Net;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;

namespace Platform.Google.Tests;

[TestClass]
public sealed class GoogleProjectOwnerTests
{
    private static GoogleCloudOptions Options(bool enabled = true, string parent = "organizations/345678") => new()
    {
        AllowCloudWrites = true, DeploymentId = "owner-contract", ProjectIdPrefix = "owners",
        Parent = parent, SenderServiceAccount = "sender-account@sender-project.iam.gserviceaccount.com",
        GrantOrganizationAdminUsersProjectOwner = enabled, PollIntervalSeconds = 1
    };
    private static string[] Owners(JsonObject policy) => policy["bindings"]!.AsArray().OfType<JsonObject>()
        .Where(binding => binding["role"]?.GetValue<string>() == "roles/owner" && binding["condition"] == null)
        .SelectMany(binding => binding["members"]!.AsArray().Select(member => member!.GetValue<string>())).ToArray();

    [TestMethod]
    public async Task DisabledByDefaultDoesNotReadOrganizationOrGrantHumanOwnership()
    {
        using var directory = new OwnerDirectory();
        await new GoogleTenantProvisioner(directory.Client(), Options(enabled: false)).EnsureAsync(GoogleProvisioningTests.Tenant(), default);
        Assert.AreEqual(0, directory.DirectoryReads);
        CollectionAssert.AreEqual(Array.Empty<string>(), Owners(directory.Server.Policy));
        Assert.IsFalse(new GoogleCloudOptions().GrantOrganizationAdminUsersProjectOwner);
    }

    [TestMethod]
    public async Task OrganizationAdministratorUsersBecomeOwnersAndReplayKeepsOtherBindings()
    {
        using var directory = new OwnerDirectory();
        directory.Server.Policy["bindings"]!.AsArray().Add(JsonNode.Parse("""{"role":"roles/owner","members":["user:existing@example.com"]}"""));
        var original = directory.Server.Policy["bindings"]!.AsArray()[0]!.ToJsonString();
        var tenant = GoogleProvisioningTests.Tenant();
        var service = new GoogleTenantProvisioner(directory.Client(), Options());
        await service.EnsureAsync(tenant, default);
        await service.EnsureAsync(tenant, default);
        CollectionAssert.AreEquivalent(new[] { "user:alice@example.com", "user:bob@example.com", "user:existing@example.com" }, Owners(directory.Server.Policy));
        Assert.AreEqual(1, directory.Server.PolicyWrites);
        Assert.AreEqual(original, directory.Server.Policy["bindings"]!.AsArray()[0]!.ToJsonString());
        Assert.AreEqual("policy-version", directory.Server.Policy["etag"]!.GetValue<string>());
        Assert.AreEqual(3, directory.LastRequestedPolicyVersion);
        Assert.IsFalse(Owners(directory.Server.Policy).Contains("user:" + tenant.OwnerEmail));
        Assert.IsFalse(Owners(directory.Server.Policy).Any(member => member.StartsWith("serviceAccount:")));
        Assert.AreEqual(1, directory.Server.ProjectCreates);
    }

    [TestMethod]
    public async Task CurrentOrganizationAdministratorsAreReadAgainForEachNewTenant()
    {
        using var directory = new OwnerDirectory();
        var service = new GoogleTenantProvisioner(directory.Client(), Options());
        await service.EnsureAsync(GoogleProvisioningTests.Tenant(), default);
        directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["members"]!.AsArray().Add("user:carol@example.com");
        await service.EnsureAsync(GoogleProvisioningTests.Tenant(), default);
        Assert.IsTrue(Owners(directory.Server.Policy).Contains("user:carol@example.com"));
        Assert.AreEqual(2, directory.DirectoryReads);
        Assert.AreEqual(2, directory.Server.ProjectCreates);
    }

    [TestMethod]
    public async Task ConditionalProjectOwnershipIsPreservedAndDoesNotReplaceTheRequiredOwnerBinding()
    {
        using var directory = new OwnerDirectory();
        var conditional = JsonNode.Parse("""{"role":"roles/owner","members":["user:alice@example.com"],"condition":{"title":"temporary","expression":"false"}}""")!;
        directory.Server.Policy["bindings"]!.AsArray().Add(conditional);
        var original = conditional.ToJsonString();
        await new GoogleTenantProvisioner(directory.Client(), Options()).EnsureAsync(GoogleProvisioningTests.Tenant(), default);
        Assert.AreEqual(original, directory.Server.Policy["bindings"]!.AsArray().Single(binding => binding?["condition"] != null)!.ToJsonString());
        CollectionAssert.AreEquivalent(new[] { "user:alice@example.com", "user:bob@example.com" }, Owners(directory.Server.Policy));
    }

    [TestMethod]
    public async Task FolderAncestryResolvesTheActualOrganization()
    {
        using var directory = new OwnerDirectory();
        directory.Folders["folders/123456"] = "folders/234567";
        directory.Folders["folders/234567"] = "organizations/345678";
        await new GoogleTenantProvisioner(directory.Client(), Options(parent: "folders/123456")).EnsureAsync(GoogleProvisioningTests.Tenant(), default);
        Assert.AreEqual(3, directory.DirectoryReads);
        Assert.IsTrue(directory.Paths.Contains("v3/organizations/345678:getIamPolicy"));
    }

    [DataTestMethod]
    [DataRow("folders/123456")]
    [DataRow("https://example.invalid/organizations/345678")]
    [DataRow("organizations/345678/../other")]
    [DataRow("organizations/345678\n")]
    public async Task CyclicOrInvalidFolderParentsFailBeforeProjectCreation(string parent)
    {
        using var directory = new OwnerDirectory();
        directory.Folders["folders/123456"] = parent;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options(parent: "folders/123456"))
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
        Assert.AreEqual(0, directory.Server.PolicyWrites);
    }

    [DataTestMethod]
    [DataRow(true, false)]
    [DataRow(false, true)]
    public async Task InvalidFolderIdentityOrInactiveFolderCannotSupplyOwners(bool mismatch, bool inactive)
    {
        using var directory = new OwnerDirectory { WrongFolderIdentity = mismatch, InactiveFolder = inactive };
        directory.Folders["folders/123456"] = "organizations/345678";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options(parent: "folders/123456"))
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
    }

    [DataTestMethod]
    [DataRow("group:administrators@example.com")]
    [DataRow("domain:example.com")]
    [DataRow("allUsers")]
    [DataRow("user:alice@example.com\n")]
    [DataRow("user:Example <alice@example.com>")]
    [DataRow("user:admin@sender-project.iam.gserviceaccount.com")]
    public async Task UnresolvedOrInvalidAdministratorPrincipalsCannotReceiveUnconditionalOwner(string member)
    {
        using var directory = new OwnerDirectory();
        directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["members"] = new JsonArray(member);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
        Assert.AreEqual(0, directory.Server.PolicyWrites);
    }

    [TestMethod]
    public async Task ConditionalOrganizationAdministratorIsNotElevatedToUnconditionalOwner()
    {
        using var directory = new OwnerDirectory();
        directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["condition"] = JsonNode.Parse("""{"title":"temporary","expression":"false"}""");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
    }

    [DataTestMethod]
    [DataRow(false)]
    [DataRow(true)]
    public async Task MissingHumanAdministratorsOrBindingsFailClosed(bool missingBindings)
    {
        using var directory = new OwnerDirectory();
        if (missingBindings) directory.OrganizationPolicy.Remove("bindings");
        else directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["members"] = new JsonArray("serviceAccount:admin@sender-project.iam.gserviceaccount.com");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
    }

    [TestMethod]
    public async Task OrganizationReadDeniedDoesNotCreateAProjectOrGrantAnUnverifiedOwner()
    {
        using var directory = new OwnerDirectory { DenyOrganization = true };
        var error = await Assert.ThrowsExceptionAsync<GoogleApiException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(HttpStatusCode.Forbidden, error.StatusCode);
        Assert.AreEqual(0, directory.Server.ProjectCreates);
        Assert.AreEqual(0, directory.Server.PolicyWrites);
    }

    [TestMethod]
    public async Task ExcessiveAdministratorUsersAreRejectedBeforeAnyProjectMutation()
    {
        using var directory = new OwnerDirectory();
        directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["members"] = new JsonArray(
            Enumerable.Range(0, 101).Select(index => (JsonNode?)JsonValue.Create($"user:admin{index}@example.com")).ToArray());
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(0, directory.Server.ProjectCreates);
    }

    [TestMethod]
    public async Task ExcessiveFolderDepthTerminatesBeforeProjectCreation()
    {
        using var directory = new OwnerDirectory();
        for (var index = 100001; index < 100012; index++) directory.Folders["folders/" + index] = "folders/" + (index + 1);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new GoogleTenantProvisioner(directory.Client(), Options(parent: "folders/100001"))
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(10, directory.DirectoryReads);
        Assert.AreEqual(0, directory.Server.ProjectCreates);
    }

    [TestMethod]
    public async Task ChangedOrganizationAdministratorsCannotAddOwnersToAForeignTenantProject()
    {
        using var directory = new OwnerDirectory();
        var options = Options(); var tenant = GoogleProvisioningTests.Tenant();
        var service = new GoogleTenantProvisioner(directory.Client(), options);
        await service.EnsureAsync(tenant, default);
        directory.Server.Projects[options.ProjectId(tenant.TenantId)]["labels"]!["platform-tenant"] = Guid.NewGuid().ToString("N");
        directory.OrganizationPolicy["bindings"]!.AsArray()[0]!["members"]!.AsArray().Add("user:carol@example.com");
        var original = directory.Server.Policy.ToJsonString(); var writes = directory.Server.PolicyWrites;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => service.EnsureAsync(tenant, default));
        Assert.AreEqual(original, directory.Server.Policy.ToJsonString());
        Assert.AreEqual(writes, directory.Server.PolicyWrites);
    }

    [TestMethod]
    public async Task ProjectIamConflictDoesNotOverwriteExistingOwnersOrPublishDistribution()
    {
        using var directory = new OwnerDirectory();
        directory.Server.PolicyConflict = true;
        var original = directory.Server.Policy.ToJsonString();
        var error = await Assert.ThrowsExceptionAsync<GoogleApiException>(() => new GoogleTenantProvisioner(directory.Client(), Options())
            .EnsureAsync(GoogleProvisioningTests.Tenant(), default));
        Assert.AreEqual(HttpStatusCode.Conflict, error.StatusCode);
        Assert.AreEqual(original, directory.Server.Policy.ToJsonString());
        Assert.AreEqual(0, directory.Server.GroupCreates);
    }
}

internal sealed class OwnerDirectory : DelegatingHandler
{
    public GoogleServer Server { get; } = new();
    public JsonObject OrganizationPolicy { get; } = JsonNode.Parse("""{"bindings":[{"role":"roles/resourcemanager.organizationAdmin","members":["user:alice@example.com","serviceAccount:admin@sender-project.iam.gserviceaccount.com","user:bob@example.com","user:alice@example.com"]},{"role":"roles/viewer","members":["user:unrelated@example.com"]}]}""")!.AsObject();
    public Dictionary<string, string> Folders { get; } = [];
    public List<string> Paths { get; } = [];
    public int DirectoryReads, LastRequestedPolicyVersion;
    public bool DenyOrganization, WrongFolderIdentity, InactiveFolder;
    public OwnerDirectory() { InnerHandler = Server; }
    public GoogleRestClient Client() => new(new HttpClient(this, disposeHandler: false), Server.Tokens);
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
    {
        var path = request.RequestUri!.AbsolutePath.TrimStart('/');
        Paths.Add(path);
        if (path.StartsWith("v3/folders/"))
        {
            DirectoryReads++;
            var folder = path[3..];
            return new HttpResponseMessage(HttpStatusCode.OK) { Content = JsonContent.Create(new {
                name = WrongFolderIdentity ? "folders/999999" : folder,
                state = InactiveFolder ? "DELETE_REQUESTED" : "ACTIVE", parent = Folders[folder] }) };
        }
        if (path.StartsWith("v3/organizations/"))
        {
            DirectoryReads++;
            var body = JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!;
            LastRequestedPolicyVersion = body["options"]!["requestedPolicyVersion"]!.GetValue<int>();
            return new HttpResponseMessage(DenyOrganization ? HttpStatusCode.Forbidden : HttpStatusCode.OK) { Content = JsonContent.Create(OrganizationPolicy) };
        }
        return await base.SendAsync(request, ct);
    }
}
