using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.FileStorage;

namespace SaasManager.Infrastructure.FileStorage;

/// <summary>Optional Azure adapter. Authentication and account selection are consistent for every operation.</summary>
public sealed class BlobStorageService : IBlobStorageService
{
    private readonly BlobServiceClient client;
    public BlobStorageService(BlobServiceClient client) => this.client = client;
    public BlobStorageService(IConfiguration configuration)
    {
        var connection = configuration["FileStorage:Azure:ConnectionString"]
            ?? Environment.GetEnvironmentVariable("AZURE_STORAGEBLOB_CONNECTIONSTRING");
        if (!string.IsNullOrWhiteSpace(connection)) client = new BlobServiceClient(connection);
        else
        {
            var endpoint = configuration["FileStorage:Azure:Endpoint"] ?? configuration["Azure:BlobStorage:ConnectionString"];
            if (!Uri.TryCreate(endpoint,UriKind.Absolute,out var uri) || uri.Scheme != "https" || !string.IsNullOrEmpty(uri.UserInfo) || !string.IsNullOrEmpty(uri.Query))
                throw new InvalidOperationException("Configure an HTTPS Azure storage endpoint or a private connection string.");
            client = new BlobServiceClient(uri,new DefaultAzureCredential());
        }
    }

    private static string Key(string fileName,string? directory)
    {
        // Use the same portable object-name restrictions as the file-system provider.
        var segments=(string.IsNullOrEmpty(directory)?fileName:directory+"/"+fileName).Split('/');
        foreach(var segment in segments)
            if(!System.Text.RegularExpressions.Regex.IsMatch(segment,"^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$")||segment is "." or "..")
                throw new ArgumentException("Invalid storage object name.");
        return string.Join('/',segments);
    }
    private static void Container(string container)
    {
        if(!System.Text.RegularExpressions.Regex.IsMatch(container,"^[a-z][a-z0-9-]{2,62}$"))throw new ArgumentException("Invalid storage container.");
    }
    public async Task<string> UploadFileAsync(Stream stream,string fileName,string container,string? directory=null,CancellationToken ct=default)
    {
        Container(container);var key=Key(fileName,directory);var bucket=client.GetBlobContainerClient(container);
        await bucket.CreateIfNotExistsAsync(PublicAccessType.None,cancellationToken:ct);
        var blob=bucket.GetBlobClient(key);await blob.UploadAsync(stream,overwrite:true,cancellationToken:ct);
        // A configured SAS credential must never become part of a persisted file reference.
        return blob.Uri.GetLeftPart(UriPartial.Path);
    }
    public async Task<bool> DeleteFileAsync(string key,string container,CancellationToken ct=default)
    {
        Container(container);Key(key,null);
        return (await client.GetBlobContainerClient(container).GetBlobClient(key).DeleteIfExistsAsync(cancellationToken:ct)).Value;
    }
    public async Task<bool> ContainerExistsAsync(string container,CancellationToken ct=default)
    {
        Container(container);return (await client.GetBlobContainerClient(container).ExistsAsync(ct)).Value;
    }
    public async Task<StoredFileDownload> DownloadFileAsync(string reference,CancellationToken ct=default)
    {
        var account=client.Uri;
        if(!Uri.TryCreate(reference,UriKind.Absolute,out var uri) || uri.Scheme!=account.Scheme || uri.Authority!=account.Authority ||
            !string.IsNullOrEmpty(uri.UserInfo)||!string.IsNullOrEmpty(uri.Query)||!string.IsNullOrEmpty(uri.Fragment))
            throw new InvalidOperationException("The file reference belongs to a different storage account or provider.");
        var prefix=account.AbsolutePath.TrimEnd('/')+"/";
        if(!uri.AbsolutePath.StartsWith(prefix,StringComparison.Ordinal))throw new InvalidOperationException("The file reference is outside the configured storage account.");
        var parts=Uri.UnescapeDataString(uri.AbsolutePath[prefix.Length..]).Split('/',2);
        if(parts.Length!=2)throw new ArgumentException("Invalid Azure storage reference.");
        Container(parts[0]);Key(parts[1],null);
        var response=await client.GetBlobContainerClient(parts[0]).GetBlobClient(parts[1]).DownloadStreamingAsync(cancellationToken:ct);
        return new(response.Value.Content,response.Value.Details.ContentLength,response.Value.Details.ContentType??StoredFileDownload.ContentTypeFor(parts[1]));
    }
}
