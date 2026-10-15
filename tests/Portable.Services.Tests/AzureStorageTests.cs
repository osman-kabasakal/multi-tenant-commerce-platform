using System.Net;
using Azure.Core.Pipeline;
using Azure.Storage.Blobs;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Infrastructure.FileStorage;

namespace Portable.Services.Tests;

[TestClass]
public sealed class AzureStorageTests
{
    [TestMethod]
    public async Task OptionalAzureAdapterUsesOneAccountForEveryOperationAndRejectsForeignReferences()
    {
        using var server=new StorageServer();var options=new BlobClientOptions{Transport=new HttpClientTransport(new HttpClient(server,false))};options.Retry.MaxRetries=0;
        var client=new BlobServiceClient(new Uri("https://contract.blob.core.windows.net/"),options);
        var storage=new BlobStorageService(client);
        var reference=await storage.UploadFileAsync(new MemoryStream([1,2]),"logo.png","app-assets","tenant");
        Assert.AreEqual("https://contract.blob.core.windows.net/app-assets/tenant/logo.png",reference);
        Assert.IsTrue(await storage.ContainerExistsAsync("app-assets"));
        var file=await storage.DownloadFileAsync(reference);await using(file.Content){using var bytes=new MemoryStream();await file.Content.CopyToAsync(bytes);CollectionAssert.AreEqual(new byte[]{1,2},bytes.ToArray());}
        Assert.IsTrue(await storage.DeleteFileAsync("tenant/logo.png","app-assets"));
        var count=server.Calls;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.DownloadFileAsync("https://foreign.blob.core.windows.net/app-assets/secret"));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>storage.DownloadFileAsync(reference+"?sig=not-persisted"));
        Assert.AreEqual(count,server.Calls);
    }

    private sealed class StorageServer:HttpMessageHandler
    {
        public int Calls;
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)
        {
            Calls++;Assert.AreEqual("contract.blob.core.windows.net",request.RequestUri!.Host);
            var status=request.Method==HttpMethod.Put?HttpStatusCode.Created:request.Method==HttpMethod.Delete?HttpStatusCode.Accepted:HttpStatusCode.OK;
            var response=new HttpResponseMessage(status){Content=new ByteArrayContent(request.Method==HttpMethod.Get?[1,2]:[])};
            response.Headers.Add("ETag","\"contract-etag\"");response.Headers.Add("x-ms-request-id","contract-request");response.Headers.Add("x-ms-blob-type","BlockBlob");
            response.Content.Headers.LastModified=DateTimeOffset.UtcNow;response.Content.Headers.ContentType=new("image/png");
            return Task.FromResult(response);
        }
    }
}
