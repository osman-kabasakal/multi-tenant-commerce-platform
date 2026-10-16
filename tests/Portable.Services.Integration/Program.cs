using SaasManager.Infrastructure.Authentication;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Npgsql;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.FileStorage;

if(args.Length==3 && args[0]=="--enrollment-database")
{
    await EnrollmentDatabaseFixture.RunAsync(args[1],args[2]);
    return;
}

if (args.Length == 3 && args[0] == "--identity-tls")
{
    if (!Uri.TryCreate(args[2], UriKind.Absolute, out var target) || target.Scheme != "https" ||
        target.Host is not ("localhost" or "127.0.0.1") || target.Port != 18443)
        throw new InvalidOperationException("TLS probes are restricted to the isolated local identity server.");
    var values = new Dictionary<string,string?>();
    if (args[1] != "system") values["AuthConfiguration:AuthorityRootCertificateFile"] = args[1];
    var settings = new ConfigurationBuilder().AddInMemoryCollection(values).Build();
    using var transport = IdentityTransport.Create(settings) ?? new SocketsHttpHandler { AllowAutoRedirect = false };
    using var client = new HttpClient(transport) { Timeout = TimeSpan.FromSeconds(8) };
    var accepted = false;
    try { using var response = await client.GetAsync(target); accepted = response.IsSuccessStatusCode; }
    catch (HttpRequestException error) { Console.Error.WriteLine(error.ToString()); }
    Console.WriteLine(JsonSerializer.Serialize(new { accepted }));
    return;
}

// A cross-process transport fixture, restricted to this checkout's synthetic local businesses.
// This file is deliberately NOT a valid mobile build or proof of signing/distribution.
if (args.Length != 2 || !Guid.TryParse(args[1], out var appId))
    throw new ArgumentException("Usage: <private-demo-config> <synthetic-business-app-id>");
var config = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[0])).Build();
var connection = new NpgsqlConnectionStringBuilder(config.GetConnectionString("SaasManagerDb"));
if (!config.GetValue<bool>("LocalDemo:Enabled") || connection.Host is not ("localhost" or "127.0.0.1") ||
    connection.Port != 15439 || connection.Database != "commerce_saas" || config["FileStorage:Provider"] != "FileSystem")
    throw new InvalidOperationException("Only the local demo fixture database and filesystem provider are permitted.");
await using var db = new ApplicationDbContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseNpgsql(connection.ConnectionString).Options);
var app = await db.BusinessApps.Include(x => x.Business).SingleAsync(x => x.Id == appId && !x.IsDeleted);
if (app.Business.IsDeleted || !app.Business.Name.StartsWith("Onboarding ", StringComparison.Ordinal) ||
    !app.Business.Email.EndsWith("@example.test", StringComparison.Ordinal))
    throw new InvalidOperationException("Only synthetic onboarding businesses may receive this test fixture.");
var options = config.GetSection("FileStorage:FileSystem").Get<FileSystemStorageOptions>() ?? throw new InvalidOperationException();
var storage = new FileSystemBlobStorageService(options);
var id = Guid.NewGuid();
var bytes = Encoding.UTF8.GetBytes("PLATFORM_STORAGE_SMOKE_ONLY_NOT_AN_APK\n");
await using var content = new MemoryStream(bytes);
var reference = await storage.UploadFileAsync(content, id.ToString("N") + ".apk", "app-builds", "smoke");
db.AppBuilds.Add(new AppBuild {
    Id = id, BusinessAppId = appId, Platform = BuildPlatform.Android, Version = "smoke-" + id.ToString("N")[..10],
    BuildNumber = 1, FilePath = reference, FileSize = bytes.Length, FileHash = Convert.ToHexString(SHA256.HashData(bytes)),
    BuildStatus = "SyntheticTransportFixture", BuildDate = DateTime.UtcNow, CreatedAt = DateTime.UtcNow,
    Configuration = JsonDocument.Parse("{\"smokeTransportOnly\":true}")
});
await db.SaveChangesAsync();
Console.WriteLine(JsonSerializer.Serialize(new { buildId = id }));
