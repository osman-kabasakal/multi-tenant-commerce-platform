using Core.Models.Responses;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using SaasManager.Application.AppBuilds.Commands.AppAssetUpload;
using SaasManager.Application.AppBuilds.Queries.DownloadAsset;

namespace SaasManager.Web.Endpoints;

public class AppMediaUploads: EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var group=app.MapGroup(this,"uploads").RequireAuthorization();
        group.MapPost("app-asset",UploadAppAsset);
        group.MapGet("app-asset/file",DownloadAsset);
    }
    
    public async Task<IResult> DownloadAsset(ISender sender,Guid assetId,HttpContext http,CancellationToken ct)
    {
        var file=await sender.Send(new DownloadAssetQuery(assetId),ct);
        http.Response.Headers.CacheControl="private, no-store";
        http.Response.Headers.XContentTypeOptions="nosniff";
        return Results.File(file.FileStream,file.MimeType,file.FileName);
    }

    public async Task<Ok<ServiceResponse<AppAssetUploadResponse>>> UploadAppAsset(
        [FromForm] IFormFile file,
        [FromForm] Guid businessAppId,
        [FromForm] string assetType,
        [FromForm] string platform,
        ISender sender)
    {
        var command = new AppAssetUploadCommand
        {
            BusinessAppId = businessAppId,
            AssetType = assetType,
            Platform = platform,
            File = file
        };
            
        return TypedResults.Ok(await sender.Send(command));
    }
}
