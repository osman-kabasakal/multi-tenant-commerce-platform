using System.Diagnostics;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace Platform.Provisioning.Adapters;

public sealed class AndroidReleaseOptions
{
    public const string BuildToolsVersion="35.0.0";
    public string BuildToolPath(string tool)
    {
        if(tool is not ("aapt2" or "apksigner"))throw new ArgumentException("Unsupported Android verification tool.");
        var suffix=OperatingSystem.IsWindows()?(tool=="apksigner"?".bat":".exe"):"";
        return Path.Combine(AndroidSdkDirectory,"build-tools",BuildToolsVersion,tool+suffix);
    }
    public bool AllowSigningKeyCreation { get; init; }
    public bool SharedArtifactsConfirmed { get; init; }
    public string SourceDirectory { get; init; } = "";
    public string WorkingDirectory { get; init; } = "";
    public string ArtifactDirectory { get; init; } = "";
    public string PythonPath { get; init; } = "";
    public string FlutterPath { get; init; } = "";
    public string KeytoolPath { get; init; } = "";
    public string AndroidSdkDirectory { get; init; } = "";
    public int BuildNumber { get; init; } = 1;
    public int BuildTimeoutSeconds { get; init; } = 7200;
    public string Script => Path.Combine(SourceDirectory,"scripts","mobile_android.py");

    public void Validate(IConfiguration config,string environment)
    {
        if (environment is not ("Production" or "Staging") || config.GetValue<bool>("LocalDemo:Enabled") ||
            config["Provisioning:Profile"]!="Portable" || config["Provisioning:Google:Provider"]!="Google" ||
            !config.GetValue<bool>("Provisioning:Google:AllowCloudWrites") || config.GetValue<bool>("PlatformSecurity:ReadOnly") ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") || !AllowSigningKeyCreation || !SharedArtifactsConfirmed)
            throw new InvalidOperationException("Automatic Android releases require explicit Portable Production/Staging, Google writes, tenant signing and shared private artifacts.");
        if (BuildNumber is <1 or >2100000000 || BuildTimeoutSeconds is <300 or >14400)
            throw new InvalidOperationException("Invalid Android release version or timing.");
        foreach (var executable in new[]{PythonPath,FlutterPath,KeytoolPath})
            if (!Path.IsPathFullyQualified(executable) || !File.Exists(executable))
                throw new InvalidOperationException("Configure absolute installed Python, Flutter and JDK keytool executables.");
        if (!Path.IsPathFullyQualified(SourceDirectory) || !File.Exists(Script) ||
            !File.Exists(Path.Combine(SourceDirectory,"Platforms/store_user_app/pubspec.lock")) ||
            !File.Exists(Path.Combine(SourceDirectory,"Platforms/store_user_app/lib/core/config/tenant_firebase_identity.dart")) ||
            !Path.IsPathFullyQualified(AndroidSdkDirectory) || !File.Exists(BuildToolPath("aapt2")) || !File.Exists(BuildToolPath("apksigner")))
            throw new InvalidOperationException("Configure the compatible mobile source checkout and pinned Android build-tools 35.0.0.");
        MobileReleaseFiles.PrivateDirectory(WorkingDirectory);MobileReleaseFiles.PrivateDirectory(ArtifactDirectory);
        foreach(var path in new[]{WorkingDirectory,ArtifactDirectory})
            if (Path.GetFullPath(path)==Path.GetFullPath(SourceDirectory) || SourceDirectory.StartsWith(Path.GetFullPath(path)+Path.DirectorySeparatorChar,StringComparison.Ordinal))
                throw new InvalidOperationException("Release output cannot contain the source checkout.");
    }
}

public static class AndroidReleases
{
    public static IServiceCollection AddAndroidReleases(this IServiceCollection services,IConfiguration config,string environment)
    {
        var provider=config["Provisioning:Mobile:Provider"]??"Disabled";
        if (provider=="Disabled") return services;
        if (provider!="AndroidAppDistribution") throw new InvalidOperationException("Choose Disabled or AndroidAppDistribution mobile provisioning.");
        var options=config.GetSection("Provisioning:Mobile:Android").Get<AndroidReleaseOptions>()??throw new InvalidOperationException("Configure Android release options.");
        options.Validate(config,environment);services.AddSingleton(options);
        services.TryAddSingleton<IAndroidSigningKeyFactory,KeytoolAndroidSigningKeyFactory>();
        services.TryAddScoped<IAndroidReleaseBuilder,AndroidReleaseBuilder>();
        services.AddScoped<TenantAndroidSigningKeys>();services.AddScoped<AndroidReleasePipeline>();
        services.AddScoped<IProvisioningGuard,AndroidReleaseGuard>();services.AddScoped<IProvisioningStep,AndroidReleaseStep>();
        return services;
    }
}

internal static class MobileReleaseFiles
{
    internal static readonly JsonSerializerOptions Json=new(JsonSerializerDefaults.Web);
    public static void PrivateDirectory(string path)
    {
        if (!Path.IsPathFullyQualified(path) || Path.GetFullPath(path)==Path.GetPathRoot(path) || path.Any(char.IsControl))
            throw new InvalidOperationException("Use an absolute private mobile directory.");
        for(var directory=new DirectoryInfo(path);directory!=null;directory=directory.Parent)
            if(directory.LinkTarget!=null)throw new InvalidOperationException("Mobile directories cannot contain symbolic links.");
        Directory.CreateDirectory(path);
        if(!OperatingSystem.IsWindows())File.SetUnixFileMode(path,UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.UserExecute);
    }
    public static void RegularFile(string path,long max=2*1024*1024)
    {
        var file=new FileInfo(path);
        if(!file.Exists || file.LinkTarget!=null || file.Length>max)throw new InvalidOperationException("Invalid bounded mobile artifact.");
        for(var directory=file.Directory;directory!=null;directory=directory.Parent)
            if(directory.LinkTarget!=null)throw new InvalidOperationException("Mobile artifacts cannot contain symbolic links.");
    }
    public static async Task WriteAsync(string path,byte[] content,CancellationToken ct)
    {
        var settings=new FileStreamOptions{Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None};
        if(!OperatingSystem.IsWindows())settings.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
        await using var file=new FileStream(path,settings);await file.WriteAsync(content,ct);
    }
    public static T Parse<T>(string value)=>JsonSerializer.Deserialize<T>(value,Json)??throw new InvalidOperationException("Invalid saved mobile release metadata.");
    public static bool Digest(string value)=>Regex.IsMatch(value,"^[a-f0-9]{64}$");
    public static async Task<string> HashAsync(string path,CancellationToken ct)
    {
        RegularFile(path,1024L*1024*1024);await using var file=File.OpenRead(path);
        return Convert.ToHexString(await SHA256.HashDataAsync(file,ct)).ToLowerInvariant();
    }
}

internal static class MobileProcess
{
    public static async Task<string> RunAsync(string executable,IEnumerable<string> arguments,string directory,
        IReadOnlyDictionary<string,string>? environment,TimeSpan timeout,CancellationToken ct)
    {
        var start=new ProcessStartInfo(executable){WorkingDirectory=directory,UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true,CreateNoWindow=true};
        foreach(var argument in arguments)start.ArgumentList.Add(argument);
        if(environment!=null)foreach(var value in environment)start.Environment[value.Key]=value.Value;
        using var process=Process.Start(start)??throw new InvalidOperationException("The configured mobile tool could not start.");
        using var deadline=CancellationTokenSource.CreateLinkedTokenSource(ct);deadline.CancelAfter(timeout);
        // Drain both pipes concurrently with a bounded capture; provider/tool diagnostics never enter exceptions or worker logs.
        static async Task<string> DrainAsync(StreamReader reader)
        {
            var result=new System.Text.StringBuilder();var buffer=new char[4096];int count;
            while((count=await reader.ReadAsync(buffer))>0)if(result.Length<65536)result.Append(buffer,0,Math.Min(count,65536-result.Length));
            return result.ToString();
        }
        var output=DrainAsync(process.StandardOutput);var errors=DrainAsync(process.StandardError);
        try
        {
            await process.WaitForExitAsync(deadline.Token);var result=await output;await errors;
            if(process.ExitCode!=0)throw new InvalidOperationException("The configured mobile tool failed; inspect its private diagnostics.");
            return result.Trim();
        }
        catch
        {
            if(!process.HasExited)process.Kill(entireProcessTree:true);
            await process.WaitForExitAsync(CancellationToken.None);await output;await errors;
            if(!ct.IsCancellationRequested && deadline.IsCancellationRequested)throw new TimeoutException("Mobile tool exceeded its configured deadline.");
            throw;
        }
    }
}
