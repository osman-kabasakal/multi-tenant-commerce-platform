using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SaasManager.Application.Common.Interfaces.FileStorage;

namespace SaasManager.Infrastructure.FileStorage;

public static class FileStorageServices
{
    public static IServiceCollection AddFileStorage(this IServiceCollection services,IConfiguration config,string contentRoot)
    {
        var provider=config["FileStorage:Provider"]??"Disabled";
        switch(provider)
        {
            case "FileSystem":
                var options=config.GetSection("FileStorage:FileSystem").Get<FileSystemStorageOptions>()??new();options.Validate();
                var publicRoot=Path.GetFullPath(Path.Combine(contentRoot,"wwwroot"));var privateRoot=Path.GetFullPath(options.RootDirectory);
                if(string.Equals(privateRoot,publicRoot,OperatingSystem.IsWindows()?StringComparison.OrdinalIgnoreCase:StringComparison.Ordinal)||privateRoot.StartsWith(publicRoot+Path.DirectorySeparatorChar,OperatingSystem.IsWindows()?StringComparison.OrdinalIgnoreCase:StringComparison.Ordinal))
                    throw new InvalidOperationException("File storage must be outside the public web root.");
                services.AddSingleton(options);services.AddScoped<IBlobStorageService,FileSystemBlobStorageService>();break;
            case "Azure":services.AddScoped<IBlobStorageService,BlobStorageService>();break;
            case "Disabled":services.AddScoped<IBlobStorageService,DisabledBlobStorageService>();break;
            default:throw new InvalidOperationException("Choose a FileSystem, Azure or Disabled file-storage provider.");
        }
        return services;
    }
}

public sealed class DisabledBlobStorageService:IBlobStorageService
{
    private static NotSupportedException Disabled()=>new("File storage is disabled; choose its provider explicitly.");
    public Task<string> UploadFileAsync(Stream stream,string fileName,string container,string? directory=null,CancellationToken ct=default)=>throw Disabled();
    public Task<bool> DeleteFileAsync(string key,string container,CancellationToken ct=default)=>throw Disabled();
    public Task<bool> ContainerExistsAsync(string container,CancellationToken ct=default)=>throw Disabled();
    public Task<StoredFileDownload> DownloadFileAsync(string reference,CancellationToken ct=default)=>throw Disabled();
}
