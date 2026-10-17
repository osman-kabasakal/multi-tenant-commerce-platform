using System.Diagnostics;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Platform.Provisioning;
using Platform.Security;

namespace TenantManager.Provisioning;

public sealed class TenantScheduleOptions
{
    public bool Enabled { get; init; }
    public string DeploymentId { get; init; } = "";
    public string InstallerPath { get; init; } = "";
    public string CommerceConfigPath { get; init; } = "";
    public string WorkingDirectory { get; init; } = "";
    public string TenantDirectory { get; init; } = "";
    public string StoreBaseUrl { get; init; } = "";
    public int PollSeconds { get; init; } = 30;
    public int TimeoutMinutes { get; init; } = 20;
    public string[] TenantIds { get; init; } = [];
    public string NotificationCredentialsFile { get; init; } = "";

    public void Validate()
    {
        if (!Enabled || string.IsNullOrWhiteSpace(DeploymentId) || PollSeconds is < 5 or > 3600 || TimeoutMinutes is < 1 or > 120)
            throw new InvalidOperationException("Enable the bounded tenant schedule explicitly.");
        foreach (var path in new[] { InstallerPath, CommerceConfigPath, WorkingDirectory, TenantDirectory }.Concat(string.IsNullOrEmpty(NotificationCredentialsFile) ? Array.Empty<string>() : new[] { NotificationCredentialsFile }))
        {
            if (!Path.IsPathFullyQualified(path) || Path.GetFullPath(path) == Path.GetPathRoot(path))
                throw new InvalidOperationException("Supply absolute owned schedule paths.");
            for (var item = new FileInfo(path) as FileSystemInfo; item != null; item = item is DirectoryInfo directory ? directory.Parent : ((FileInfo)item).Directory)
                if (item.LinkTarget != null) throw new InvalidOperationException("Schedule paths cannot contain symbolic links.");
        }
        if (!File.Exists(InstallerPath) || !File.Exists(CommerceConfigPath) || !Directory.Exists(WorkingDirectory) || !Directory.Exists(TenantDirectory) ||
            !Uri.TryCreate(StoreBaseUrl, UriKind.Absolute, out var origin) || origin.Scheme != "https" || origin.AbsolutePath != "/" || !string.IsNullOrEmpty(origin.UserInfo))
            throw new InvalidOperationException("Supply existing portable installer paths and an HTTPS tenant parent origin.");
        if (TenantIds.Any(x => !Guid.TryParseExact(x, "N", out var id) || id == Guid.Empty || id.ToString("N") != x))
            throw new InvalidOperationException("Schedule filters must use canonical tenant ids.");
        var child = new ConfigurationBuilder().AddJsonFile(CommerceConfigPath).Build();
        if (child.GetValue<bool>("LocalDemo:Enabled") || !child.GetValue<bool>("Provisioning:ManagedRuntime") ||
            !child.GetValue<bool>("PlatformSecurity:ReadOnly") || child["PlatformConfiguration:Provider"] != "Environment")
            throw new InvalidOperationException("The task child requires a portable runtime with read-only shared secrets.");
        var sends = child["Notifications:Provider"] is "Fcm" or "FcmApns";
        if (sends != !string.IsNullOrEmpty(NotificationCredentialsFile) || sends && !File.Exists(NotificationCredentialsFile))
            throw new InvalidOperationException("Configure the explicit limited notification credential file for the task child.");
    }
}

public static class TenantScheduleHost
{
    public static async Task RunAsync(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        var path = builder.Configuration["Provisioning:ConfigPath"];
        if (string.IsNullOrWhiteSpace(path) || !Path.IsPathFullyQualified(path))
            throw new InvalidOperationException("Supply the absolute private schedule configuration.");
        builder.Configuration.AddJsonFile(path, optional: false).AddEnvironmentVariables();
        var config = builder.Configuration;
        if (config.GetValue<bool>("LocalDemo:Enabled") || config.GetValue<bool>("PlatformSecurity:InitializeSchema") ||
            config.GetValue<bool>("Provisioning:InitializeSchema") || !config.GetValue<bool>("PlatformSecurity:ReadOnly"))
            throw new InvalidOperationException("The schedule host requires initialized, read-only shared state.");
        var options = config.GetSection("Provisioning:Schedule").Get<TenantScheduleOptions>() ?? throw new InvalidOperationException("Configure the tenant schedule.");
        options.Validate();
        builder.Services.AddPlatformSecurity(config, builder.Environment.EnvironmentName);
        builder.Services.AddPlatformProvisioning(config);
        builder.Services.AddSingleton(options);
        builder.Services.AddHostedService<TenantScheduleWorker>();
        using var host = builder.Build();
        await host.RunAsync();
    }
}

public sealed class TenantScheduleWorker(TenantScheduleOptions options, IServiceScopeFactory scopes, ILogger<TenantScheduleWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            foreach (var path in Directory.EnumerateFiles(options.TenantDirectory, "*.json").OrderBy(x => x, StringComparer.Ordinal))
            {
                if (Path.GetFileNameWithoutExtension(path).Contains('.')) continue;
                try { await RunTenantAsync(path, ct); }
                catch (OperationCanceledException) when (ct.IsCancellationRequested) { return; }
                catch { logger.LogWarning("An owned tenant schedule batch could not complete; the next poll will retry."); }
            }
            await Task.Delay(TimeSpan.FromSeconds(options.PollSeconds), ct);
        }
    }

    internal static ProcessStartInfo ChildStartInfo(TenantScheduleOptions options, string tenant, string slug, string path, string databaseConnection)
    {
        var start = new ProcessStartInfo("dotnet") { WorkingDirectory = Path.Combine(options.WorkingDirectory, tenant), UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true };
        start.ArgumentList.Add(options.InstallerPath);
        var executablePath = start.Environment["PATH"];
        start.Environment.Clear(); // Keep ambient cloud/provisioning authority out of the task child.
        start.Environment["PATH"] = executablePath;
        // Only the explicit limited sender credential is forwarded, never the parent's provisioning ADC.
        if (!string.IsNullOrEmpty(options.NotificationCredentialsFile))
            start.Environment["GOOGLE_APPLICATION_CREDENTIALS"] = options.NotificationCredentialsFile;
        start.Environment["DOTNET_ENVIRONMENT"] = "Production";
        start.Environment["ASPNETCORE_ENVIRONMENT"] = "Production";
        start.Environment["LocalDemo__Enabled"] = "false";
        start.Environment["PlatformConfiguration__ConfigPath"] = options.CommerceConfigPath;
        start.Environment["PlatformConfiguration__Provider"] = "Environment";
        start.Environment["Provisioning__ManagedInstaller"] = "true";
        start.Environment["Provisioning__ManagedInstallerProfile"] = "Portable";
        start.Environment["Provisioning__TenantOutput"] = path;
        start.Environment["Provisioning__RunScheduledTasks"] = "true";
        start.Environment["Provisioning__StoreUrl"] = new UriBuilder(options.StoreBaseUrl) { Host = slug + "." + new Uri(options.StoreBaseUrl).Host }.Uri.GetLeftPart(UriPartial.Authority);
        start.Environment["TenantMessage__TenantId"] = tenant;
        start.Environment["TenantMessage__StoreSubDomain"] = slug;
        start.Environment["TenantMessage__MongoConnectionString"] = databaseConnection;
        return start;
    }

    public async Task RunTenantAsync(string path, CancellationToken ct)
    {
        if (Path.GetFullPath(Path.GetDirectoryName(path)!) != Path.GetFullPath(options.TenantDirectory) || new FileInfo(path).LinkTarget != null)
            throw new InvalidOperationException("Foreign or linked tenant metadata rejected.");
        using var metadata = JsonDocument.Parse(await File.ReadAllTextAsync(path, ct));
        var tenant = metadata.RootElement.GetProperty("tenantId").GetString()!;
        if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty || id.ToString("N") != tenant)
            throw new InvalidOperationException("Invalid tenant schedule metadata.");
        if (options.TenantIds.Length > 0 && !options.TenantIds.Contains(tenant)) return;
        using var scope = scopes.CreateScope();
        var job = await scope.ServiceProvider.GetRequiredService<IProvisioningQueue>().GetAsync(tenant, ct);
        if (job == null || job.State != "Succeeded") return; // Provisioning and initializer must finish first.
        job.Request.Validate();
        var slug = job.Request.Slug;
        if (job.Request.DeploymentId != options.DeploymentId || Path.GetFileName(path) != slug + ".json" ||
            metadata.RootElement.GetProperty("slug").GetString() != slug || metadata.RootElement.GetProperty("profile").GetString() != "Portable" ||
            !job.Steps.TryGetValue("store", out var store) || metadata.RootElement.GetProperty("storeId").GetString() != store.Resources["storeId"])
            throw new InvalidOperationException("Foreign tenant schedule request rejected.");
        var secrets = scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
        if (await secrets.ResolveAsync(store.Resources["storeId"], ct) != tenant) throw new InvalidOperationException("Foreign store alias rejected.");
        var work = Path.Combine(options.WorkingDirectory, tenant);
        if (!Directory.Exists(Path.Combine(work, "Plugins"))) throw new InvalidOperationException("Restore the initialized tenant workspace.");
        var start = ChildStartInfo(options, tenant, slug, path, await secrets.GetAsync(tenant, TenantSecretNames.DatabaseConnection, ct));
        using var process = Process.Start(start) ?? throw new InvalidOperationException("The tenant task child could not start.");
        using var timeout = CancellationTokenSource.CreateLinkedTokenSource(ct);
        timeout.CancelAfter(TimeSpan.FromMinutes(options.TimeoutMinutes));
        var stdout = process.StandardOutput.BaseStream.CopyToAsync(Stream.Null, timeout.Token);
        var stderr = process.StandardError.BaseStream.CopyToAsync(Stream.Null, timeout.Token);
        try { await process.WaitForExitAsync(timeout.Token); await Task.WhenAll(stdout, stderr); }
        catch
        {
            if (!process.HasExited) process.Kill(entireProcessTree: true);
            await process.WaitForExitAsync(CancellationToken.None);
            throw;
        }
        if (process.ExitCode != 0) throw new InvalidOperationException("The tenant task child failed; its expiring lease permits recovery.");
        logger.LogInformation("Owned tenant schedule batch finished.");
    }
}
