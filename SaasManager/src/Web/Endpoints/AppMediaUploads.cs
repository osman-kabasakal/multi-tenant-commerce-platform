using Core.Models.Responses;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using SaasManager.Application.AppBuilds.Commands.AppAssetUpload;

namespace SaasManager.Web.Endpoints;

public class AppMediaUploads: EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        app.MapGroup(this, "uploads")
            .RequireAuthorization()
            .MapPost("app-asset",UploadAppAsset)
            .RequireAuthorization()
            .DisableAntiforgery();
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
