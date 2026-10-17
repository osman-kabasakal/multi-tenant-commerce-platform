using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using static Platform.Google.Tests.GoogleProvisioningTests;

namespace Platform.Google.Tests;

[TestClass]
public sealed class FirebaseAppIdentityTests
{
    private static (string Base64, string Sha1, string Sha256) Certificate()
    {
        using var rsa = RSA.Create(2048);
        var request = new CertificateRequest("CN=Synthetic Firebase Identity", rsa, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        using var cert = request.CreateSelfSigned(DateTimeOffset.UtcNow.AddDays(-1), DateTimeOffset.UtcNow.AddDays(30));
        return (Convert.ToBase64String(cert.RawData), Convert.ToHexString(SHA1.HashData(cert.RawData)).ToLowerInvariant(),
            Convert.ToHexString(SHA256.HashData(cert.RawData)).ToLowerInvariant());
    }

    [TestMethod]
    public async Task RegistersBothPublicFingerprintsAndReplaysWithoutReplacingExistingCertificates()
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default);
        var parent = $"projects/{config.ProjectId}/androidApps/{config.AndroidAppId}";
        var prior = new JsonObject { ["name"] = parent + "/sha/prior", ["certType"] = "SHA_256", ["shaHash"] = new string('b',64) };
        server.Certificates[parent] = new JsonArray(prior);
        var cert = Certificate(); var identity = new FirebaseAppIdentity(api, options);
        await identity.EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256);
        var writes = server.Writes;
        await identity.EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256);
        Assert.AreEqual(2, server.CertificateCreates); Assert.AreEqual(writes, server.Writes);
        var actual = server.Certificates[parent].OfType<JsonObject>().ToArray(); Assert.AreEqual(3, actual.Length);
        Assert.IsTrue(actual.Any(x => x["shaHash"]!.GetValue<string>() == cert.Sha1 && x["certType"]!.GetValue<string>() == "SHA_1"));
        Assert.IsTrue(actual.Any(x => x["shaHash"]!.GetValue<string>() == cert.Sha256 && x["certType"]!.GetValue<string>() == "SHA_256"));
        Assert.AreSame(prior, actual[0]);
    }

    [TestMethod]
    public async Task ConcurrentCertificateCreationReconcilesByReadback()
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); var cert = Certificate();
        server.ConflictCertificateOnce = true;
        await new FirebaseAppIdentity(api, options).EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256);
        Assert.AreEqual(2, server.CertificateCreates);
    }

    [TestMethod]
    public async Task UnretainedFingerprintFailsAndRetryUsesTheSameCertificate()
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); var cert = Certificate();
        var identity = new FirebaseAppIdentity(api, options); server.IgnoreCertificateWrites = true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => identity.EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256));
        Assert.AreEqual(1, server.CertificateCreates); server.IgnoreCertificateWrites = false;
        await identity.EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256);
        Assert.AreEqual(3, server.CertificateCreates);
    }

    [TestMethod]
    public async Task CertificateMismatchIsRejectedBeforeAnyNetworkRequest()
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); var cert = Certificate(); server.Paths.Clear();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppIdentity(api, options).EnsureAndroidSigningAsync(config, cert.Base64, new string('0',64)));
        Assert.AreEqual(0, server.Paths.Count);
    }

    [DataTestMethod]
    [DataRow("owner")][DataRow("project")][DataRow("application")][DataRow("package")]
    public async Task ForeignProjectOrApplicationCannotReceiveCertificateWrites(string change)
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); var cert = Certificate();
        if (change == "owner") server.Projects[config.ProjectId]["labels"]!["platform-tenant"] = new string('f',32);
        if (change == "project") server.Projects[config.ProjectId]["projectId"] = "another-project";
        if (change == "application") server.App(config.AndroidAppId)["name"] = "projects/foreign/androidApps/foreign";
        if (change == "package") server.App(config.AndroidAppId)["packageName"] = "com.foreign.app";
        var writes = server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppIdentity(api, options).EnsureAndroidSigningAsync(config, cert.Base64, cert.Sha256));
        Assert.AreEqual(writes, server.Writes); Assert.AreEqual(0, server.CertificateCreates);
    }

    [TestMethod]
    public async Task IosCreationStoresTheExplicitTeamAndReplayDoesNotPatch()
    {
        using var server = new GoogleServer(); var options = Options(apns:true); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default);
        Assert.AreEqual(options.IosDevelopmentTeam, server.App(config.IosAppId)["teamId"]!.GetValue<string>());
        await new FirebaseAppIdentity(api, options).EnsureIosTeamAsync(config);
        Assert.AreEqual(0, server.TeamPatches);
    }

    [TestMethod]
    public async Task MissingIosTeamIsPatchedWithConcurrencyTokenAndVerifiedOnce()
    {
        using var server = new GoogleServer(); var options = Options(apns:true); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default);
        server.App(config.IosAppId).Remove("teamId"); var identity = new FirebaseAppIdentity(api, options);
        await identity.EnsureIosTeamAsync(config); await identity.EnsureIosTeamAsync(config);
        Assert.AreEqual(1, server.TeamPatches); Assert.AreEqual(options.IosDevelopmentTeam, server.App(config.IosAppId)["teamId"]!.GetValue<string>());
    }

    [TestMethod]
    public async Task AnotherAppleTeamIsNeverOverwritten()
    {
        using var server = new GoogleServer(); var options = Options(apns:true); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); server.App(config.IosAppId)["teamId"] = "ZZZ123DEFG";
        var writes = server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppIdentity(api, options).EnsureIosTeamAsync(config));
        Assert.AreEqual(writes, server.Writes); Assert.AreEqual(0, server.TeamPatches);
    }

    [TestMethod]
    public async Task IosTeamWriteRequiresReadbackBeforeSetupCanSucceed()
    {
        using var server = new GoogleServer(); var options = Options(apns:true); var api = server.Client();
        var config = await new GoogleTenantProvisioner(api, options).EnsureAsync(Tenant(), default); server.App(config.IosAppId).Remove("teamId"); server.IgnoreTeamWrites = true;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new FirebaseAppIdentity(api, options).EnsureIosTeamAsync(config));
        Assert.AreEqual(1, server.TeamPatches);
    }
    [TestMethod]
    public async Task NewPackageCreatesTwoAppsInTheSameProjectAndPreservesOldAppsAndAllOtherResources()
    {
        using var server = new GoogleServer(); var options = Options(apns:true); var api = server.Client();
        var provisioner = new GoogleTenantProvisioner(api, options); var spec = Tenant();
        var previous = await provisioner.EnsureAsync(spec, default);
        var oldAndroid = server.App(previous.AndroidAppId).ToJsonString(); var oldIos = server.App(previous.IosAppId).ToJsonString();
        var policy = server.PolicyWrites; var groups = server.GroupCreates; server.Paths.Clear();
        var nextSpec = spec with { AndroidPackageName = "com.customer.newstore", IosBundleId = "com.customer.newstore" };
        var next = await provisioner.EnsureApplicationVersionAsync(previous, nextSpec);
        Assert.AreEqual(previous.ProjectId, next.ProjectId); Assert.AreEqual(previous.ProjectNumber, next.ProjectNumber);
        Assert.AreNotEqual(previous.AndroidAppId, next.AndroidAppId); Assert.AreNotEqual(previous.IosAppId, next.IosAppId);
        Assert.AreEqual(oldAndroid, server.App(previous.AndroidAppId).ToJsonString()); Assert.AreEqual(oldIos, server.App(previous.IosAppId).ToJsonString());
        Assert.AreEqual(1, server.ProjectCreates); Assert.AreEqual(4, server.AppCreates);
        Assert.AreEqual(policy, server.PolicyWrites); Assert.AreEqual(groups, server.GroupCreates);
        Assert.IsFalse(server.Paths.Any(x => x.Contains("batchJoin") || x.Contains("billing") || x.Contains("IamPolicy") || x.Contains(":batchEnable")));
        Assert.AreEqual(next, await provisioner.EnsureApplicationVersionAsync(previous, nextSpec)); Assert.AreEqual(4, server.AppCreates);
    }
    [TestMethod]
    public async Task VersionRegistrationRejectsForeignOwnershipBeforeCreatingAnyApps()
    {
        using var server = new GoogleServer(); var options = Options(); var api = server.Client();
        var provisioner = new GoogleTenantProvisioner(api, options); var spec = Tenant(); var previous = await provisioner.EnsureAsync(spec, default);
        server.Projects[previous.ProjectId]["labels"]!["platform-tenant"] = new string('f',32); var writes = server.Writes;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => provisioner.EnsureApplicationVersionAsync(previous,
            spec with { AndroidPackageName = "com.customer.newstore", IosBundleId = "com.customer.newstore" }));
        Assert.AreEqual(writes, server.Writes); Assert.AreEqual(2, server.AppCreates);
    }

}
