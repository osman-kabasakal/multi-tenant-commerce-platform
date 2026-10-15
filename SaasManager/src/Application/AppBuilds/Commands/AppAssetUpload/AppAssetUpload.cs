using Core.Models.Responses;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events;

namespace SaasManager.Application.AppBuilds.Commands.AppAssetUpload;

public sealed class AppAssetUploadResponse
{
    public string Url{get;set;}=null!;
    public string Name{get;set;}=null!;
}
public sealed record AppAssetUploadCommand:IRequest<ServiceResponse<AppAssetUploadResponse>>
{
    public Guid BusinessAppId{get;init;}
    public string AssetType{get;init;}=null!;
    public string Platform{get;init;}=null!;
    public IFormFile File{get;init;}=null!;
}
public sealed class AppAssetUploadCommandValidator:AbstractValidator<AppAssetUploadCommand>{}

public sealed class AppAssetUploadCommandHandler(IApplicationDbContext context,IBlobStorageService storage,IWorkContext owner,
    ILogger<AppAssetUploadCommandHandler> logger,IMediator mediator):IRequestHandler<AppAssetUploadCommand,ServiceResponse<AppAssetUploadResponse>>
{
    public async Task<ServiceResponse<AppAssetUploadResponse>> Handle(AppAssetUploadCommand request,CancellationToken ct)
    {
        var business=BusinessOwnerContext.BusinessId(owner);
        if(business==null || !await context.BusinessApps.AnyAsync(a=>a.Id==request.BusinessAppId && a.BusinessId==business && !a.IsDeleted,ct))
            return ServiceResponse<AppAssetUploadResponse>.Error("BUSINESS_APP_NOT_FOUND","Business app not found or not authorized");
        if(request.File==null || request.File.Length is < 1 or > 5*1024*1024)
            return ServiceResponse<AppAssetUploadResponse>.Error("INVALID_FILE","Supply a JPEG or PNG file up to 5 MiB.");
        if(!Enum.TryParse<AppMediaAssetType>(request.AssetType,true,out var type) || !Enum.IsDefined(type))
            return ServiceResponse<AppAssetUploadResponse>.Error("INVALID_ASSET_TYPE","Invalid asset type");
        var platform=request.Platform?.ToLowerInvariant();
        if(platform is not ("android" or "ios"))return ServiceResponse<AppAssetUploadResponse>.Error("INVALID_PLATFORM","Choose android or ios.");
        var extension=Path.GetExtension(request.File.FileName).ToLowerInvariant();
        if(extension is not (".jpg" or ".jpeg" or ".png"))return ServiceResponse<AppAssetUploadResponse>.Error("INVALID_FILE_TYPE","Only JPEG and PNG files are allowed");
        await using(var probe=request.File.OpenReadStream())
        {
            var header=new byte[8];var read=await probe.ReadAtLeastAsync(header,8,throwOnEndOfStream:false,cancellationToken:ct);
            var valid=extension==".png" ? read==8 && header.SequenceEqual(new byte[]{137,80,78,71,13,10,26,10}) : read>=3 && header[0]==255 && header[1]==216 && header[2]==255;
            if(!valid)return ServiceResponse<AppAssetUploadResponse>.Error("INVALID_FILE_TYPE","File content does not match its image type.");
        }
        try
        {
            string reference;
            await using(var stream=request.File.OpenReadStream())
                reference=await storage.UploadFileAsync(stream,Guid.NewGuid().ToString("N")+extension,"app-assets",
                    request.BusinessAppId.ToString("N")+"/"+type.ToString().ToLowerInvariant()+"/"+platform,ct);
            var asset=new AppMediaAsset{BusinessAppId=request.BusinessAppId,AssetType=type,Platform=platform,FileName=Path.GetFileName(request.File.FileName.Replace('\\','/')),
                FilePath=reference,FileSize=(int)request.File.Length,IsDefault=true};
            foreach(var previous in await context.AppMediaAssets.Where(x=>x.BusinessAppId==request.BusinessAppId && x.AssetType==type && x.Platform==platform && !x.IsDeleted).ToListAsync(ct))
            { previous.IsDefault=false;context.AppMediaAssets.Update(previous); }
            await context.AppMediaAssets.AddAsync(asset,ct);await context.SaveChangesAsync(ct);
            await mediator.Publish(new EntityUpdatedEvent<AppMediaAsset>(asset),ct);
            return ServiceResponse<AppAssetUploadResponse>.Success(new(){Url="/api/uploads/app-asset/file?assetId="+asset.Id,Name=asset.FileName});
        }
        catch(OperationCanceledException)when(ct.IsCancellationRequested){throw;}
        catch(Exception error)
        {
            logger.LogWarning("App asset storage failed ({ErrorType}).",error.GetType().Name);
            return ServiceResponse<AppAssetUploadResponse>.Error("UPLOAD_FAILED","Failed to upload file. Please try again.");
        }
    }
}
