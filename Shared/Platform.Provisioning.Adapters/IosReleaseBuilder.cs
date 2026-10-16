using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Platform.Google;

namespace Platform.Provisioning.Adapters;

public sealed class IosReleaseOptions
{
    public bool AllowSigning { get; init; }
    public bool AllowProfileInstallation { get; init; }
    public bool SharedArtifactsConfirmed { get; init; }
    public string DeploymentId { get; init; } = "";
    public string DevelopmentTeam { get; init; } = "";
    public string SigningCertificateSha256 { get; init; } = "";
    public string ExpectedSourceHash { get; init; } = "";
    public string SourceDirectory { get; init; } = "";
    public string ArtifactDirectory { get; init; } = "";
    public string PythonPath { get; init; } = "";
    public string FlutterPath { get; init; } = "";
    public string RubyPath { get; init; } = "";
    public string AppleConfigFile { get; init; } = "";
    public int BuildTimeoutSeconds { get; init; } = 7200;
    public IosWorkerIdentity Identity => new(DeploymentId, DevelopmentTeam, SigningCertificateSha256, ExpectedSourceHash);
    public string Script => Path.Combine(SourceDirectory, "scripts/mobile_ios_worker.py");
    public static IConfigurationRoot ReadConfiguration(string path)
    {
        if (!Path.IsPathFullyQualified(path)) throw new ArgumentException("Use an absolute private Mac configuration file.");
        MobileReleaseFiles.RegularFile(path, 2 * 1024 * 1024);
        if (!OperatingSystem.IsWindows() && (File.GetUnixFileMode(path) & (UnixFileMode.GroupRead | UnixFileMode.GroupWrite | UnixFileMode.GroupExecute | UnixFileMode.OtherRead | UnixFileMode.OtherWrite | UnixFileMode.OtherExecute)) != 0)
            throw new ArgumentException("Mac configuration must be accessible only to its owner.");
        return new ConfigurationBuilder().AddJsonFile(path, optional: false).Build();
    }
    public void Validate(IConfiguration config, string environment)
    {
        Identity.Validate();
        if (!OperatingSystem.IsMacOS() || environment is not ("Production" or "Staging") ||
            config.GetValue<bool>("LocalDemo:Enabled") || config["Provisioning:Profile"] != "Portable" ||
            config["Provisioning:Google:Provider"] != "Google" || !config.GetValue<bool>("Provisioning:Google:AllowCloudWrites") ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") || config.GetValue<bool>("PlatformSecurity:ReadOnly") ||
            config.GetValue<bool>("Provisioning:InitializeSchema") || config.GetValue<bool>("PlatformSecurity:InitializeSchema") ||
            !AllowSigning || !AllowProfileInstallation || !SharedArtifactsConfirmed)
            throw new InvalidOperationException("The Mac worker requires explicit Portable Production/Staging, writable shared secrets, Google writes, signing/profile installation and persistent shared artifacts; apply schemas separately.");
        if (BuildTimeoutSeconds is < 300 or > 14400) throw new InvalidOperationException("Invalid iOS build deadline.");
        foreach (var executable in new[] { PythonPath, FlutterPath, RubyPath })
            if (!Path.IsPathFullyQualified(executable) || !File.Exists(executable)) throw new InvalidOperationException("Configure absolute installed Python, pinned Flutter and Ruby executables.");
        if (!Path.IsPathFullyQualified(SourceDirectory) || !File.Exists(Script) || !File.Exists(Path.Combine(SourceDirectory, "Platforms/store_user_app/pubspec.lock")))
            throw new InvalidOperationException("Use the compatible tracked mobile and iOS tooling checkout.");
        var artifacts = Path.GetFullPath(ArtifactDirectory); var sources = Path.GetFullPath(SourceDirectory);
        if (artifacts == sources || artifacts.StartsWith(sources + Path.DirectorySeparatorChar, StringComparison.Ordinal) || sources.StartsWith(artifacts + Path.DirectorySeparatorChar, StringComparison.Ordinal))
            throw new InvalidOperationException("Use a private artifact directory outside the source checkout.");
        MobileReleaseFiles.PrivateDirectory(ArtifactDirectory);
    }
    public static string SdkHash(TenantFirebaseConfiguration firebase) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(firebase.IosConfigPlist))).ToLowerInvariant();
}

// Native metadata and upload-tool bytes are bound by the encrypted artifact journal before any cloud upload.
public sealed record IosBuiltArtifact(string AttemptId, IosReleasePlan Plan, string IpaSha256, string NativeResultSha256,
    string UploadToolSha256, string DeviceSetSha256, string ApplicationProfileUuid, string ExtensionProfileUuid);
public interface IIosReleaseBuilder
{
    Task<string> SourceHashAsync(CancellationToken ct);
    Task<IosBuiltArtifact> BuildAsync(IosReleasePlan plan, TenantProvisioningRequest request, TenantFirebaseConfiguration firebase, AppleSigningMaterial signing, CancellationToken ct);
    Task VerifyAsync(IosBuiltArtifact artifact, CancellationToken ct);
    Task UploadSymbolsAsync(IosBuiltArtifact artifact, CancellationToken ct);
    string BinaryPath(IosBuiltArtifact artifact);
}

public sealed class IosReleaseBuilder(IosReleaseOptions options, AppleApiOptions apple) : IIosReleaseBuilder
{
    public static string DeviceHash(AppleApiOptions apple) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(string.Join('\n', apple.RequiredDeviceUdids.Select(x => x.ToUpperInvariant()).Order(StringComparer.Ordinal))))).ToLowerInvariant();
    private string Attempt(IosBuiltArtifact artifact)
    {
        artifact.Plan.Validate();
        if (!Guid.TryParseExact(artifact.AttemptId, "N", out var attempt) || attempt == Guid.Empty || attempt.ToString("N") != artifact.AttemptId ||
            new IosWorkerIdentity(artifact.Plan.DeploymentId, artifact.Plan.DevelopmentTeam, artifact.Plan.SigningCertificateSha256, artifact.Plan.SourceHash) != options.Identity ||
            artifact.DeviceSetSha256 != DeviceHash(apple) || !MobileReleaseFiles.Digest(artifact.IpaSha256) || !MobileReleaseFiles.Digest(artifact.NativeResultSha256) || !MobileReleaseFiles.Digest(artifact.UploadToolSha256))
            throw new InvalidOperationException("The retained iOS artifact belongs to another plan, Mac identity or device policy.");
        var path = Path.Combine(Path.GetFullPath(options.ArtifactDirectory), artifact.Plan.TenantId, artifact.AttemptId);
        if (!Directory.Exists(path)) throw new InvalidOperationException("The immutable iOS workspace is missing; restore it rather than rebuilding the initial version.");
        for (var directory = new DirectoryInfo(path); directory != null; directory = directory.Parent)
            if (directory.LinkTarget != null) throw new InvalidOperationException("iOS workspaces cannot contain symbolic links.");
        return path;
    }
    private string Workspace(IosBuiltArtifact artifact) => Path.Combine(Attempt(artifact), "workspace");
    private static string UploadTool(string workspace) => Path.Combine(workspace, "Platforms/store_user_app/ios/Pods/FirebaseCrashlytics/upload-symbols");
    private static string ResultPath(string workspace) => Path.Combine(workspace, "ios-release-result.json");
    private static string RelativeFile(string workspace, string relative)
    {
        if (Path.IsPathFullyQualified(relative) || relative.Contains('\\')) throw new InvalidOperationException("Invalid relative IPA path.");
        var path = Path.GetFullPath(Path.Combine(workspace, relative));
        if (!path.StartsWith(workspace + Path.DirectorySeparatorChar, StringComparison.Ordinal) || Path.GetExtension(path) != ".ipa")
            throw new InvalidOperationException("The IPA escaped its private workspace.");
        MobileReleaseFiles.RegularFile(path, 1024L * 1024 * 1024); return path;
    }
    private static void Match(JsonElement result, IosReleasePlan plan)
    {
        var expected = new Dictionary<string, string> { ["tenantId"] = plan.TenantId, ["deploymentId"] = plan.DeploymentId,
            ["developmentTeam"] = plan.DevelopmentTeam, ["iosBundleId"] = plan.IosBundleId, ["projectId"] = plan.ProjectId,
            ["projectNumber"] = plan.ProjectNumber, ["iosAppId"] = plan.IosAppId, ["sourceHash"] = plan.SourceHash,
            ["signingCertificateSha256"] = plan.SigningCertificateSha256, ["firebaseSdkSha256"] = plan.FirebaseSdkSha256 };
        if (expected.Any(x => result.GetProperty(x.Key).GetString() != x.Value) || result.GetProperty("buildNumber").GetInt32() != plan.BuildNumber ||
            result.GetProperty("storeUrl").GetString()?.TrimEnd('/') != plan.StoreUrl.TrimEnd('/') ||
            new[] { "signedIpaBuilt", "signatureVerified", "xcodeExported", "symbolsVerified" }.Any(x => !result.GetProperty(x).GetBoolean()) ||
            !MobileReleaseFiles.Digest(result.GetProperty("ipaSha256").GetString() ?? ""))
            throw new InvalidOperationException("The native result does not prove the selected signed iOS artifact.");
        var app = Guid.ParseExact(result.GetProperty("applicationProfileUuid").GetString()!, "D");
        var extension = Guid.ParseExact(result.GetProperty("extensionProfileUuid").GetString()!, "D");
        if (app == Guid.Empty || extension == Guid.Empty || app == extension) throw new InvalidOperationException("The native profiles are invalid.");
    }
    public async Task<string> SourceHashAsync(CancellationToken ct)
    {
        var hash = await MobileProcess.RunAsync(options.PythonPath, [options.Script, "source-hash"], options.SourceDirectory, null, TimeSpan.FromMinutes(2), ct);
        if (!MobileReleaseFiles.Digest(hash)) throw new InvalidOperationException("Invalid iOS source fingerprint.");
        return hash;
    }
    public async Task<IosBuiltArtifact> BuildAsync(IosReleasePlan plan, TenantProvisioningRequest request, TenantFirebaseConfiguration firebase, AppleSigningMaterial signing, CancellationToken ct)
    {
        plan.Validate();
        if (plan.SourceHash != await SourceHashAsync(ct) || plan.FirebaseSdkSha256 != IosReleaseOptions.SdkHash(firebase) || signing.CertificateSha256 != plan.SigningCertificateSha256)
            throw new InvalidOperationException("The iOS source, SDK export or signing material changed before build.");
        var attemptId = Guid.NewGuid().ToString("N"); var attempt = Path.Combine(options.ArtifactDirectory, plan.TenantId, attemptId);
        MobileReleaseFiles.PrivateDirectory(attempt); var inputs = Path.Combine(attempt, "inputs"); MobileReleaseFiles.PrivateDirectory(inputs);
        var workspace = Path.Combine(attempt, "workspace");
        try
        {
            await FirebaseClientFiles.ExportAsync(firebase, inputs, ct);
            await MobileReleaseFiles.WriteAsync(Path.Combine(inputs, "plan.json"), JsonSerializer.SerializeToUtf8Bytes(plan, MobileReleaseFiles.Json), ct);
            await MobileReleaseFiles.WriteAsync(Path.Combine(inputs, "tenant.json"), JsonSerializer.SerializeToUtf8Bytes(new {
                tenantId = plan.TenantId, slug = request.Slug, displayName = request.StoreName, baseUrl = plan.StoreUrl, localDemo = false,
                androidApplicationId = firebase.AndroidPackageName, iosBundleId = firebase.IosBundleId,
                firebase = new { enabled = true, projectId = firebase.ProjectId, projectNumber = firebase.ProjectNumber, androidAppId = firebase.AndroidAppId, iosAppId = firebase.IosAppId }
            }, MobileReleaseFiles.Json), ct);
            var appProfile = Path.Combine(inputs, "application.mobileprovision"); var extensionProfile = Path.Combine(inputs, "extension.mobileprovision");
            await MobileReleaseFiles.WriteAsync(appProfile, signing.Application.Cms, ct); await MobileReleaseFiles.WriteAsync(extensionProfile, signing.Extension.Cms, ct);
            var policy = Path.Combine(inputs, "signing.json");
            await MobileReleaseFiles.WriteAsync(policy, JsonSerializer.SerializeToUtf8Bytes(new {
                AllowSigning = options.AllowSigning, AllowFirebaseWrites = true, AllowProfileInstallation = options.AllowProfileInstallation,
                DevelopmentTeam = plan.DevelopmentTeam, SigningCertificateSha1 = signing.CertificateSha1, ApplicationProfile = appProfile,
                ExtensionProfile = extensionProfile, RequiredDeviceUdids = apple.RequiredDeviceUdids
            }), ct);
            await MobileProcess.RunAsync(options.PythonPath, [options.Script, "build", "--plan", Path.Combine(inputs, "plan.json"), "--manifest", Path.Combine(inputs, "tenant.json"),
                "--firebase-directory", inputs, "--workspace", workspace, "--signing-config", policy, "--ruby", options.RubyPath, "--flutter", options.FlutterPath], options.SourceDirectory, null, TimeSpan.FromSeconds(options.BuildTimeoutSeconds), ct);
            MobileReleaseFiles.RegularFile(ResultPath(workspace), 65536);
            using var result = JsonDocument.Parse(await File.ReadAllTextAsync(ResultPath(workspace), ct)); Match(result.RootElement, plan);
            var value = result.RootElement;
            if (Guid.Parse(signing.Application.Uuid) != Guid.Parse(value.GetProperty("applicationProfileUuid").GetString()!) ||
                Guid.Parse(signing.Extension.Uuid) != Guid.Parse(value.GetProperty("extensionProfileUuid").GetString()!))
                throw new InvalidOperationException("Xcode used different Apple profiles from the selected tenant resources.");
            return new(attemptId, plan, value.GetProperty("ipaSha256").GetString()!, await MobileReleaseFiles.HashAsync(ResultPath(workspace), ct),
                await MobileReleaseFiles.HashAsync(UploadTool(workspace), ct), DeviceHash(apple), value.GetProperty("applicationProfileUuid").GetString()!, value.GetProperty("extensionProfileUuid").GetString()!);
        }
        catch
        {
            // These fresh paths belong only to this attempt. Keep bounded private logs, not failed native copies or tester inputs.
            if (Directory.Exists(workspace))
            {
                foreach (var log in Directory.EnumerateFiles(workspace, "*.log", SearchOption.TopDirectoryOnly))
                {
                    var file = new FileInfo(log);
                    if (file.LinkTarget == null && file.Length <= 64L * 1024 * 1024)
                        File.Move(log, Path.Combine(attempt, Path.GetFileName(log)), false);
                }
                Directory.Delete(workspace, recursive: true);
            }
            if (Directory.Exists(inputs)) Directory.Delete(inputs, recursive: true);
            throw;
        }
    }
    public string BinaryPath(IosBuiltArtifact artifact)
    {
        var workspace = Workspace(artifact); MobileReleaseFiles.RegularFile(ResultPath(workspace), 65536);
        using var json = JsonDocument.Parse(File.ReadAllText(ResultPath(workspace)));
        return RelativeFile(workspace, json.RootElement.GetProperty("artifact").GetString()!);
    }
    private async Task RunAsync(IosBuiltArtifact artifact, string mode, CancellationToken ct)
    {
        var attempt = Attempt(artifact); var workspace = Workspace(artifact); var inputs = Path.Combine(attempt, "inputs");
        if (await SourceHashAsync(ct) != artifact.Plan.SourceHash || await MobileReleaseFiles.HashAsync(ResultPath(workspace), ct) != artifact.NativeResultSha256 ||
            await MobileReleaseFiles.HashAsync(UploadTool(workspace), ct) != artifact.UploadToolSha256 || await MobileReleaseFiles.HashAsync(BinaryPath(artifact), ct) != artifact.IpaSha256 ||
            await MobileReleaseFiles.HashAsync(Path.Combine(inputs, "GoogleService-Info.plist"), ct) != artifact.Plan.FirebaseSdkSha256)
            throw new InvalidOperationException("The retained iOS binary, SDK, native evidence or uploader changed.");
        using (var original = JsonDocument.Parse(await File.ReadAllTextAsync(ResultPath(workspace), ct)))
        {
            Match(original.RootElement, artifact.Plan);
            if (original.RootElement.GetProperty("ipaSha256").GetString() != artifact.IpaSha256 ||
                Guid.Parse(original.RootElement.GetProperty("applicationProfileUuid").GetString()!) != Guid.Parse(artifact.ApplicationProfileUuid) ||
                Guid.Parse(original.RootElement.GetProperty("extensionProfileUuid").GetString()!) != Guid.Parse(artifact.ExtensionProfileUuid))
                throw new InvalidOperationException("The encrypted artifact receipt differs from its native evidence.");
        }
        var output = await MobileProcess.RunAsync(options.PythonPath, [options.Script, mode, "--plan", Path.Combine(inputs, "plan.json"), "--firebase-directory", inputs,
            "--workspace", workspace, "--signing-config", Path.Combine(inputs, "signing.json")], options.SourceDirectory, null, TimeSpan.FromMinutes(mode == "verify" ? 5 : 30), ct);
        using var verified = JsonDocument.Parse(output);
        if (verified.RootElement.GetProperty("ipaSha256").GetString() != artifact.IpaSha256 || !verified.RootElement.GetProperty("signatureVerified").GetBoolean() ||
            (mode == "upload-symbols" && !verified.RootElement.GetProperty("symbolsUploaded").GetBoolean()))
            throw new InvalidOperationException("Native re-verification or symbol submission did not complete.");
    }
    public Task VerifyAsync(IosBuiltArtifact artifact, CancellationToken ct) => RunAsync(artifact, "verify", ct);
    public Task UploadSymbolsAsync(IosBuiltArtifact artifact, CancellationToken ct) => RunAsync(artifact, "upload-symbols", ct);
}
