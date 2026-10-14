using Azure;
using Azure.Storage.Blobs.Models;

namespace SaasManager.Application.Common.Interfaces.FileStorage;

public interface IBlobStorageService
{
    Task<string> UploadFileAsync(Stream fileStream, string fileName, string containerName, string directory = null);
    Task<bool> DeleteFileAsync(string blobName, string containerName);
    Task<bool> ContainerExistsAsync(string containerName);
    
    Task<Response<BlobDownloadInfo>> DownloadFileAsync(string uri);
}
