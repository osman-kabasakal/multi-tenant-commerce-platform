namespace SaasManager.Application.Common.Interfaces.FileStorage;

public interface IBlobStorageService
{
    Task<string> UploadFileAsync(Stream fileStream,string fileName,string containerName,string? directory=null,CancellationToken cancellationToken=default);
    Task<bool> DeleteFileAsync(string objectName,string containerName,CancellationToken cancellationToken=default);
    Task<bool> ContainerExistsAsync(string containerName,CancellationToken cancellationToken=default);
    Task<StoredFileDownload> DownloadFileAsync(string reference,CancellationToken cancellationToken=default);
}

// The recipient owns Content and must dispose it, or transfer ownership to an HTTP file result.
public sealed record StoredFileDownload(Stream Content,long Length,string ContentType)
{
    public static string ContentTypeFor(string name)=>Path.GetExtension(name).ToLowerInvariant() switch {
        ".png"=>"image/png", ".jpg" or ".jpeg"=>"image/jpeg", ".apk"=>"application/vnd.android.package-archive",
        ".zip"=>"application/zip", _=>"application/octet-stream"
    };
}
