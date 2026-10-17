using System.Collections.Concurrent;
using System.Text.Json;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

if (args.Length == 0 || args[0] is "--help" or "help")
{
    Console.WriteLine("check-apple-access --config <absolute-private-apple-json>");
    Console.WriteLine("check-access --credentials <service-account-file> [--parent organizations/ID|folders/ID]");
    Console.WriteLine("reconcile-app-identity --config <google-config-file> --credentials <service-account-file> --firebase <tenant-config-file> --tenant <business-guid-N> --certificate <public-der-file> --sha256 <verified-apk-certificate-sha256> --apply public-metadata");
    Console.WriteLine("export-mobile --config <file> --tenant <business-guid-N> --output <directory> [--identity <version-guid>]");
    Console.WriteLine("distribute --config <file> --tenant <business-guid-N> --platform <android|ios> --binary <apk|ipa> [--identity <version-guid>]");
    return 0;
}
try
{
    var command = args[0];
    if (command == "check-apple-access")
    {
        if (args.Length != 3 || args[1] != "--config") throw new ArgumentException();
        var apple = AppleApiOptions.Read(args[2]);
        using var http = AppleApiClient.CreateHttpClient();
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(3));
        var report = await new AppleAccessVerifier(apple, new AppleApiClient(http, apple, new AppleApiTokens(apple))).CheckAsync(timeout.Token);
        Console.WriteLine(JsonSerializer.Serialize(report, new JsonSerializerOptions(JsonSerializerDefaults.Web) {
            WriteIndented = true, DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull
        }));
        return report.ReadAccessVerified ? 0 : 2;
    }
    if (command == "check-access")
    {
        if (args.Length is not (3 or 5) || args[1] != "--credentials" ||
            (args.Length == 5 && args[3] != "--parent")) throw new ArgumentException();
        using var input = File.OpenRead(Path.GetFullPath(args[2]));
        // Explicit service-account parsing prevents fallback to another logged-in identity or ADC.
        var account = ServiceAccountCredential.FromServiceAccountData(input);
        using var http = new HttpClient(new SocketsHttpHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(45) };
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(3));
        var report = await new GoogleAccessVerifier(new GoogleRestClient(http,
            new ExplicitServiceAccountTokens(account))).CheckAsync(account.ProjectId, args.Length == 5 ? args[4] : null, timeout.Token);
        var output = JsonSerializer.SerializeToNode(report, new JsonSerializerOptions(JsonSerializerDefaults.Web))!.AsObject();
        output["serviceAccountEmail"] = account.Id;
        output["checkedAtUtc"] = DateTimeOffset.UtcNow;
        Console.WriteLine(output.ToJsonString(new JsonSerializerOptions { WriteIndented = true }));
        return report.Checks.All(check => check.Status == "passed") ? 0 : 2;
    }
    if (command == "reconcile-app-identity")
    {
        if (args.Length != 15) throw new ArgumentException();
        var inputFlags = new Dictionary<string,string>();
        for (var i = 1; i < args.Length; i += 2)
            if (!inputFlags.TryAdd(args[i], args[i+1])) throw new ArgumentException();
        var required = new[] { "--config", "--credentials", "--firebase", "--tenant", "--certificate", "--sha256", "--apply" };
        if (required.Any(key => !inputFlags.ContainsKey(key)) || inputFlags["--apply"] != "public-metadata") throw new ArgumentException();
        var settings = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(inputFlags["--config"]), optional:false).Build();
        var options = settings.GetSection("Provisioning:Google").Get<GoogleCloudOptions>() ?? throw new InvalidOperationException();
        if (settings["Provisioning:Google:Provider"] != "Google") throw new InvalidOperationException();
        options.Validate();
        var file = new FileInfo(Path.GetFullPath(inputFlags["--firebase"]));
        if (file.Length > 4 * 1024 * 1024) throw new ArgumentException();
        var identityConfig = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(await File.ReadAllTextAsync(file.FullName)) ?? throw new InvalidOperationException();
        if (identityConfig.TenantId != inputFlags["--tenant"]) throw new InvalidOperationException();
        FirebaseConfigValidator.Validate(identityConfig);
        var certificateFile = new FileInfo(Path.GetFullPath(inputFlags["--certificate"]));
        if (certificateFile.Length is < 1 or > 65536) throw new ArgumentException();
        var certificate = Convert.ToBase64String(await File.ReadAllBytesAsync(certificateFile.FullName));
        using var credentials = File.OpenRead(Path.GetFullPath(inputFlags["--credentials"]));
        var account = ServiceAccountCredential.FromServiceAccountData(credentials);
        using var http = new HttpClient(new SocketsHttpHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(45) };
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(3));
        var identity = new FirebaseAppIdentity(new GoogleRestClient(http, new ExplicitServiceAccountTokens(account)), options);
        await identity.EnsureAndroidSigningAsync(identityConfig, certificate, inputFlags["--sha256"], timeout.Token);
        if (options.IosDevelopmentTeam != null) await identity.EnsureIosTeamAsync(identityConfig, timeout.Token);
        Console.WriteLine(JsonSerializer.Serialize(new { tenantId = identityConfig.TenantId, projectId = identityConfig.ProjectId,
            androidAppId = identityConfig.AndroidAppId, iosAppId = identityConfig.IosAppId, certificateSha256 = inputFlags["--sha256"],
            androidFingerprintsVerified = true, iosTeamVerified = options.IosDevelopmentTeam != null, checkedAtUtc = DateTimeOffset.UtcNow }));
        return 0;
    }
    if (command is not ("export-mobile" or "distribute") || args.Length % 2 != 1) throw new ArgumentException();
    var flags = new Dictionary<string,string>();
    for (var i = 1; i < args.Length; i += 2)
        if (!args[i].StartsWith("--", StringComparison.Ordinal) || !flags.TryAdd(args[i], args[i+1])) throw new ArgumentException();
    var allowed = command == "export-mobile" ? new[] { "--config", "--tenant", "--output" } : ["--config", "--tenant", "--platform", "--binary"];
    if (flags.Count != allowed.Length+(flags.ContainsKey("--identity")?1:0) || flags.Keys.Any(key=>!allowed.Contains(key) && key!="--identity") || allowed.Any(key => !flags.ContainsKey(key))) throw new ArgumentException();
    var tenant = flags["--tenant"];
    if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty) throw new ArgumentException();
    var config = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(flags["--config"]), optional:false)
        .AddEnvironmentVariables().AddInMemoryCollection(new Dictionary<string,string?> {
            ["PlatformSecurity:ReadOnly"] = "true", ["PlatformSecurity:InitializeSchema"] = "false"
        }).Build();
    var services = new ServiceCollection();
    services.AddPlatformSecurity(config, Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT") ?? "Production");
    if (command == "distribute")
    {
        if (config["Provisioning:Google:Provider"] != "Google") throw new InvalidOperationException();
        services.AddGoogleCloud(config);
    }
    using var provider = services.BuildServiceProvider();
    MobileIdentityVersion? selected=null;ProvisioningJob? original=null;TenantDomainSelection? domain=null;string? storeUrl=null;
    var connection=config["Provisioning:ConnectionString"]??config["PlatformSecurity:ConnectionString"]??throw new InvalidOperationException();
    if(config["Provisioning:Profile"]=="Portable" || flags.ContainsKey("--identity"))
    {
        await using var registry=new MobileIdentityRegistry(connection);
        if(flags.TryGetValue("--identity",out var reference))
        {
            if(!Guid.TryParseExact(reference,"D",out var version) || version==Guid.Empty)throw new ArgumentException();
            selected=await registry.GetForWorkerAsync(tenant,version)??throw new KeyNotFoundException();
            if(selected.State is not ("Active" or "Retired" or "WaitingBuilds" or "Ready"))throw new InvalidOperationException();
            domain=selected.Request.Domain;storeUrl=selected.Request.StoreUrl;
        }
        else
        {
            selected=await registry.ActiveForWorkerAsync(tenant);
            await using var domains=new TenantDomainRegistry(connection);
            var primary=await domains.PrimaryForWorkerAsync(tenant);
            domain=primary==null?null:TenantDomainSelection.From(primary);
        }
        await using var queue=new PostgresProvisioningQueue(connection);original=await queue.GetAsync(tenant);
        if(original?.State!="Succeeded" || selected!=null && (selected.Request.OriginalRequestSha256!=DomainActivationPlan.Digest(original.Request) ||
            selected.Request.DeploymentId!=original.Request.DeploymentId))throw new InvalidOperationException();
        storeUrl??=domain==null?original.Steps["publication"].Resources["storeUrl"]:"https://"+domain.StoreHost;
    }
    var secretName=selected is {Legacy:false}?selected.Prepared?.FirebaseSecretName??throw new InvalidOperationException():TenantFirebaseConfiguration.SecretName;
    var value = await provider.GetRequiredService<ITenantSecrets>().GetAsync(tenant, secretName);
    var firebase = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(value,new JsonSerializerOptions(JsonSerializerDefaults.Web)) ?? throw new InvalidOperationException();
    FirebaseConfigValidator.Validate(firebase);
    if (firebase.TenantId != tenant || selected!=null && (firebase.AndroidPackageName!=selected.Request.AndroidPackageName || firebase.IosBundleId!=selected.Request.IosBundleId)) throw new InvalidOperationException();
    if (command == "export-mobile")
    {
        await FirebaseClientFiles.ExportAsync(firebase, Path.GetFullPath(flags["--output"]));
        if(original!=null)
        {
            var target=Path.Combine(Path.GetFullPath(flags["--output"]),"tenant.json");
            var manifest=JsonSerializer.SerializeToUtf8Bytes(new {tenantId=tenant,slug=original.Request.Slug,displayName=original.Request.StoreName,baseUrl=storeUrl,
                localDemo=false,verifiedDomain=domain,mobileIdentityId=selected is {Legacy:false}?selected.Request.Id.ToString("N"):"",
                androidApplicationId=firebase.AndroidPackageName,iosBundleId=firebase.IosBundleId,
                firebase=new {enabled=true,projectId=firebase.ProjectId,projectNumber=firebase.ProjectNumber,androidAppId=firebase.AndroidAppId,iosAppId=firebase.IosAppId}},new JsonSerializerOptions(JsonSerializerDefaults.Web));
            var settings=new FileStreamOptions {Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None};
            if(!OperatingSystem.IsWindows())settings.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
            await using var output=new FileStream(target,settings);await output.WriteAsync(manifest);
        }
        Console.WriteLine("Public Firebase SDK configuration and selected tenant manifest exported.");
    }
    else
    {
        var release = await provider.GetRequiredService<FirebaseAppDistribution>().UploadAndDistributeAsync(firebase, flags["--platform"], flags["--binary"]);
        Console.WriteLine("Distributed release: " + release);
    }
    return 0;
}
catch (Exception error)
{
    // Do not print secret values, credential paths, database exceptions or provider response bodies.
    Console.Error.WriteLine("Cloud operation failed (" + error.GetType().Name + "). Check configuration and provider permissions.");
    return 1;
}

internal sealed class ExplicitServiceAccountTokens(ServiceAccountCredential account) : IGoogleAccessTokenSource
{
    private readonly GoogleCredential credential = GoogleCredential.FromServiceAccountCredential(account);
    private readonly ConcurrentDictionary<string, GoogleCredential> scoped = new();
    public Task<string> GetAsync(string scope, CancellationToken ct) =>
        ((ITokenAccess)scoped.GetOrAdd(scope, value => credential.CreateScoped(value))).GetAccessTokenForRequestAsync(cancellationToken: ct);
}
