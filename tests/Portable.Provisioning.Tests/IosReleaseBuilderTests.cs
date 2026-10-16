using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class IosReleaseBuilderTests
{
    [TestMethod]
    public async Task UnchangedInputsReachTheIndependentNativeVerifierWithoutClaimingARelease()
    {
        using var f = new IosNativeFiles();
        Assert.AreEqual(f.Artifact.Plan.SourceHash, await f.Builder.SourceHashAsync(default));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact, default));
        Assert.IsTrue(File.Exists(f.NativeMarker), "The baseline must reach the intentionally failing native verifier; other rejection tests cannot pass because of a broken fixture.");
    }
    [TestMethod]
    public async Task AFailedNativeAttemptKeepsOnlyItsLogAndPreservesAnotherRetainedArtifact()
    {
        using var f = new IosNativeFiles(); using var cloud = new AndroidFixture();
        File.WriteAllText(f.Options.Script, "if [ \"$1\" = source-hash ]; then printf '%s\\n' '" + new string('b', 64) + "'; exit 0; fi\n" +
            "while [ \"$#\" -gt 0 ]; do if [ \"$1\" = --workspace ]; then shift; workspace=\"$1\"; fi; shift; done\n" +
            "mkdir -p \"$workspace\"; printf 'synthetic failure log' > \"$workspace/ios-release.log\"; printf 'synthetic large native output' > \"$workspace/native-output\"; exit 1\n");
        var firebase = cloud.Firebase;
        var plan = f.Artifact.Plan with { TenantId = cloud.Request.TenantId, IosBundleId = firebase.IosBundleId, ProjectId = firebase.ProjectId,
            ProjectNumber = firebase.ProjectNumber, IosAppId = firebase.IosAppId, FirebaseSdkSha256 = IosReleaseOptions.SdkHash(firebase),
            StoreUrl = cloud.Deployment.StoreUrl(cloud.Request.Slug) };
        var material = new AppleSigningMaterial(new string('a', 40), plan.SigningCertificateSha256,
            new("P1", f.Artifact.ApplicationProfileUuid, [1, 2, 3]), new("P2", f.Artifact.ExtensionProfileUuid, [4, 5, 6]));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.BuildAsync(plan,
            cloud.Request with { DeploymentId = plan.DeploymentId }, firebase, material, default));
        var failed = Directory.GetDirectories(Path.Combine(f.Options.ArtifactDirectory, plan.TenantId)).Single();
        Assert.IsFalse(Directory.Exists(Path.Combine(failed, "workspace"))); Assert.IsFalse(Directory.Exists(Path.Combine(failed, "inputs")));
        Assert.AreEqual("synthetic failure log", File.ReadAllText(Path.Combine(failed, "ios-release.log")));
        Assert.AreEqual("synthetic-ipa", File.ReadAllText(f.Binary));
    }
    [TestMethod]
    public async Task ChangedUploaderOrIpaStopsBeforeNativeVerificationOrSubmission()
    {
        using var f = new IosNativeFiles();
        File.AppendAllText(f.Uploader, "changed");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.UploadSymbolsAsync(f.Artifact, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
        File.WriteAllText(f.Uploader, "synthetic-uploader"); File.AppendAllText(f.Binary, "changed");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
    }
    [TestMethod]
    public async Task EditedSdkOrNativeResultCannotReachTheNativeTool()
    {
        using var f = new IosNativeFiles();
        File.AppendAllText(f.Sdk, "changed");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
        File.WriteAllText(f.Sdk, "synthetic-sdk"); File.AppendAllText(f.Result, " ");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
    }
    [TestMethod]
    public async Task AValidLookingReceiptCannotSubstituteAnotherNativeProfileUuid()
    {
        using var f = new IosNativeFiles();
        var changed = f.Artifact with { ApplicationProfileUuid = "33333333-3333-3333-3333-333333333333" };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(changed, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
    }
    [TestMethod]
    public async Task ChangedDevicePolicyOrMissingWorkspaceRequiresRepairInsteadOfAnotherBuild()
    {
        using var f = new IosNativeFiles();
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact with { DeviceSetSha256 = new string('f', 64) }, default));
        Directory.Delete(f.Workspace, recursive: true);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => f.Builder.VerifyAsync(f.Artifact, default));
        Assert.IsFalse(File.Exists(f.NativeMarker));
    }
}

// The source-hash subprocess is synthetic. Every tested failure must stop before any native operation.
internal sealed class IosNativeFiles : IDisposable
{
    public readonly string Root;
    public readonly string Uploader, Binary, Sdk, Result, Workspace, NativeMarker;
    public readonly IosBuiltArtifact Artifact;
    public readonly IosReleaseBuilder Builder;
    public readonly IosReleaseOptions Options;
    public IosNativeFiles()
    {
        if (!File.Exists("/bin/sh")) Assert.Inconclusive("These subprocess boundary tests require a Unix shell.");
        Root = Path.Combine(OperatingSystem.IsMacOS() ? "/private/tmp" : Path.GetTempPath(), "ios-native-files-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(Root);
        var source = Path.Combine(Root, "source"); Directory.CreateDirectory(Path.Combine(source, "scripts"));
        NativeMarker = Path.Combine(Root, "native-invoked");
        var script = Path.Combine(source, "scripts/mobile_ios_worker.py");
        static string Quote(string value) => "'" + value.Replace("'", "'\\''", StringComparison.Ordinal) + "'";
        File.WriteAllText(script, "if [ \"$1\" = source-hash ]; then printf '%s\\n' '" + new string('b', 64) + "'; else printf native > " + Quote(NativeMarker) + "; exit 1; fi\n");
        var apple = new AppleApiOptions { RequiredDeviceUdids = [new string('A', 40)] };
        Options = new IosReleaseOptions { DeploymentId = "ios-native-contract", DevelopmentTeam = "ABCDE12345", SigningCertificateSha256 = new string('a', 64),
            ExpectedSourceHash = new string('b', 64), SourceDirectory = source, ArtifactDirectory = Path.Combine(Root, "artifacts"), PythonPath = "/bin/sh" };
        var tenant = Guid.NewGuid().ToString("N"); var attempt = Guid.NewGuid().ToString("N");
        var parent = Path.Combine(Options.ArtifactDirectory, tenant, attempt);
        Workspace = Path.Combine(parent, "workspace"); Directory.CreateDirectory(Workspace);
        Sdk = Path.Combine(parent, "inputs/GoogleService-Info.plist"); Directory.CreateDirectory(Path.GetDirectoryName(Sdk)!); File.WriteAllText(Sdk, "synthetic-sdk");
        Binary = Path.Combine(Workspace, "native.ipa"); File.WriteAllText(Binary, "synthetic-ipa");
        Uploader = Path.Combine(Workspace, "Platforms/store_user_app/ios/Pods/FirebaseCrashlytics/upload-symbols"); Directory.CreateDirectory(Path.GetDirectoryName(Uploader)!); File.WriteAllText(Uploader, "synthetic-uploader");
        var plan = new IosReleasePlan(tenant, Options.DeploymentId, "dev.commerce.fixture", Options.DevelopmentTeam, Options.SigningCertificateSha256, Options.ExpectedSourceHash, 7,
            "ios-native-demo", "123456789", "1:123456789:ios:bbbbbbbb", Hash(Sdk), "https://ios-coffee.example.test");
        var app = "11111111-1111-1111-1111-111111111111"; var extension = "22222222-2222-2222-2222-222222222222";
        var value = JsonSerializer.SerializeToNode(plan, new JsonSerializerOptions(JsonSerializerDefaults.Web))!.AsObject();
        foreach (var flag in new[] { "signedIpaBuilt", "signatureVerified", "xcodeExported", "symbolsVerified" }) value[flag] = true;
        value["ipaSha256"] = Hash(Binary); value["applicationProfileUuid"] = app; value["extensionProfileUuid"] = extension; value["artifact"] = "native.ipa";
        Result = Path.Combine(Workspace, "ios-release-result.json"); File.WriteAllText(Result, value.ToJsonString());
        Artifact = new(attempt, plan, Hash(Binary), Hash(Result), Hash(Uploader), IosReleaseBuilder.DeviceHash(apple), app, extension);
        Builder = new(Options, apple);
    }
    private static string Hash(string path) => Convert.ToHexString(SHA256.HashData(File.ReadAllBytes(path))).ToLowerInvariant();
    public void Dispose() => Directory.Delete(Root, recursive: true);
}
