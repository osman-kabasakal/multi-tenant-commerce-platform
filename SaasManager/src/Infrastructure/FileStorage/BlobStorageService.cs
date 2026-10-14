using Azure;
using Azure.Core;
using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Blobs.Specialized;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.FileStorage;

namespace SaasManager.Infrastructure.FileStorage;

public class BlobStorageService : IBlobStorageService
{
    private readonly string _blobResourceEndpoint;
    private readonly string? _blobResourceConnectionString;

    public BlobStorageService(IConfiguration configuration)
    {
        _blobResourceEndpoint = configuration["Azure:BlobStorage:ConnectionString"];
        _blobResourceConnectionString = Environment.GetEnvironmentVariable("AZURE_STORAGEBLOB_CONNECTIONSTRING");
    }

    public async Task<string> UploadFileAsync(Stream fileStream, string fileName, string containerName,
        string directory = null)
    {
        // Create blob service client
        var blobServiceClient = string.IsNullOrEmpty(_blobResourceConnectionString)
            ? new BlobServiceClient(new Uri(_blobResourceEndpoint), new DefaultAzureCredential())
            : new BlobServiceClient(_blobResourceConnectionString);

        // Get container reference and create if not exists
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        await containerClient.CreateIfNotExistsAsync(PublicAccessType.None);

        // Generate blob name with directory if provided
        string blobName = string.IsNullOrEmpty(directory)
            ? fileName
            : $"{directory}/{fileName}";

        // Get blob client
        var blobClient = containerClient.GetBlobClient(blobName);

        // Upload the file
        await blobClient.UploadAsync(fileStream, overwrite: true);

        // Return full URL of the blob
        return blobClient.Uri.ToString();
    }

    public async Task<bool> DeleteFileAsync(string blobName, string containerName)
    {
        var blobServiceClient = new BlobServiceClient(new Uri(_blobResourceEndpoint), new DefaultAzureCredential());
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        var blobClient = containerClient.GetBlobClient(blobName);

        return await blobClient.DeleteIfExistsAsync();
    }

    public async Task<bool> ContainerExistsAsync(string containerName)
    {
        var blobServiceClient = new BlobServiceClient(new Uri(_blobResourceEndpoint), new DefaultAzureCredential());
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);

        return await containerClient.ExistsAsync();
    }

    public Task<Response<BlobDownloadInfo>> DownloadFileAsync(string uri)
    {
        var blobServiceClient = new BlobServiceClient(new Uri(_blobResourceEndpoint), new DefaultAzureCredential());
        var blobUri = new Uri(uri);
        var containerName = blobUri.Segments[1].TrimEnd('/');
        var blobName = string.Join("", blobUri.Segments.Skip(2));
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        var blobClient = containerClient.GetBlobClient(blobName);

        return blobClient.DownloadAsync();
    }
}
