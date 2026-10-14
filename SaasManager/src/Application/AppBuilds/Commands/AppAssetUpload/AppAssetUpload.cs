using System.Text.Json;
using Core.Models.Responses;
using Core.Utilities;
using SaasManager.Application.Common.Interfaces.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.GrandNode;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.GrandModels.Picture;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events;

namespace SaasManager.Application.AppBuilds.Commands.AppAssetUpload;

public class AppAssetUploadResponse
{
    public string Url { get; set; } = null!;
    public string Name { get; set; } = null!;
}

public record AppAssetUploadCommand : IRequest<ServiceResponse<AppAssetUploadResponse>>
{
    public Guid BusinessAppId { get; init; }
    public string AssetType { get; init; }
    public string Platform { get; init; }
    public IFormFile File { get; init; }
}

public class AppAssetUploadCommandValidator : AbstractValidator<AppAssetUploadCommand>
{
    public AppAssetUploadCommandValidator()
    {
    }
}

public class AppAssetUploadCommandHandler : IRequestHandler<AppAssetUploadCommand, ServiceResponse<AppAssetUploadResponse>>
{
    private readonly IApplicationDbContext _context;
    private readonly IBlobStorageService _blobStorageService;
    private readonly IWorkContext _workContext;
    private readonly ILogger<AppAssetUploadCommandHandler> _logger;
    private readonly IMediator _mediator;

    public AppAssetUploadCommandHandler(IApplicationDbContext context,
        IBlobStorageService blobStorageService,
        IWorkContext workContext,
        ILogger<AppAssetUploadCommandHandler> logger,
        IMediator mediator
        )
    {
        _context = context;
        _blobStorageService = blobStorageService;
        _workContext = workContext;
        _logger = logger;
        _mediator = mediator;
    }

    public async Task<ServiceResponse<AppAssetUploadResponse>> Handle(AppAssetUploadCommand request, CancellationToken cancellationToken)
    {
        try
            {
                // Validate that the business app belongs to the current business
                var businessApp = await _context.BusinessApps
                    .FirstOrDefaultAsync(a => 
                        a.Id == request.BusinessAppId && 
                        a.BusinessId == _workContext.GuestRegistration.ConvertedBusinessId,
                        cancellationToken);
                
                if (businessApp == null)
                {
                    return ServiceResponse<AppAssetUploadResponse>.Error(
                        "BUSINESS_APP_NOT_FOUND", 
                        "Business app not found or not authorized");
                }

                // Validate file
                if (request.File == null || request.File.Length == 0)
                {
                    return ServiceResponse<AppAssetUploadResponse>.Error(
                        "INVALID_FILE", 
                        "No file was uploaded");
                }

                // Validate file type (basic validation - could be enhanced)
                var allowedExtensions = new[] { ".jpg", ".jpeg", ".png" };
                var fileExtension = Path.GetExtension(request.File.FileName).ToLowerInvariant();
                
                if (!allowedExtensions.Contains(fileExtension))
                {
                    return ServiceResponse<AppAssetUploadResponse>.Error(
                        "INVALID_FILE_TYPE", 
                        "Only JPEG and PNG files are allowed");
                }

                // Generate unique file name to prevent collisions
                var uniqueFileName = $"{Guid.NewGuid()}{fileExtension}";
                
                // Create directory path for storage
                var directory = $"{request.BusinessAppId}/{request.AssetType.ToLowerInvariant()}/{request.Platform.ToLowerInvariant()}";
                
                // Upload to blob storage
                string uploadedUrl;
                using (var stream = request.File.OpenReadStream())
                {
                    uploadedUrl = await _blobStorageService.UploadFileAsync(
                        stream,
                        uniqueFileName,
                        "app-assets",
                        directory);
                }
                
                // Parse the asset type
                if (!Enum.TryParse<AppMediaAssetType>(request.AssetType, out var assetType))
                {
                    return ServiceResponse<AppAssetUploadResponse>.Error(
                        "INVALID_ASSET_TYPE", 
                        "Invalid asset type");
                }
                
                // Create media asset record in database
                var appMediaAsset = new AppMediaAsset
                {
                    BusinessAppId = request.BusinessAppId,
                    AssetType = assetType,
                    Platform = request.Platform,
                    FileName = request.File.FileName,
                    FilePath = uploadedUrl,
                    FileSize = (int)request.File.Length,
                    // For image assets, we could extract dimensions here
                    // Would need to use an image processing library
                    Width = 0,
                    Height = 0,
                    IsDefault = true
                };

                if (assetType == AppMediaAssetType.Logo)
                {
                    //Admin api is not suppoerted yet 
                    // var appBuildConfigs = businessApp.BuildConfiguration.Deserialize<AppBuildsConfig>();
                    // var businessSettings = await _context.BusinessSettings
                    //     .Where(x => x.BusinessId == businessApp.BusinessId && x.GroupName=="BackendApiCredentials")
                    //     .ToListAsync(cancellationToken);
                    // var apiUSername = businessSettings.FirstOrDefault(x => x.Key == "ApiUserName")?.GetEffectiveValue();
                    // var apiPasssword = businessSettings.FirstOrDefault(x => x.Key == "ApiPassword")?.GetEffectiveValue();
                    // var grandApi = new ApiHttpClient(
                    //     "https://sanal-depo.commerce.test",
                    //     appBuildConfigs.AuthUrl,
                    //     appBuildConfigs.AuthRealm,
                    //     appBuildConfigs.AuthClientId,
                    //     appBuildConfigs.KeycloakClientSecret,
                    //     apiUSername,
                    //     apiPasssword
                    // );
                    // var picture = await grandApi.GetAsync<PictureDto>($"/odata/Picture/{appBuildConfigs.StoreLogoId}");
                    //
                    // if (picture != null)
                    // {
                    //     using (var stream = request.File.OpenReadStream())
                    //     {
                    //         var binary = stream.ToByteArray();
                    //         picture.PictureBinary = binary;
                    //         picture.MimeType = request.File.ContentType;
                    //         picture.IsNew = true;
                    //     }
                    //     var pictureResponse =await grandApi.PutAsync<PictureDto>("/odata/Picture", data: picture);
                    //     var url = new UriBuilder(appBuildConfigs.StoreLogo);
                    //     url.Path = GetFilePath(picture.Id,picture.SeoFilename,picture.MimeType);
                    //     url.Query = "";
                    //     appBuildConfigs.StoreLogo = url.ToString();
                    //     
                    //     businessApp.SetBuildConfiguration(JsonDocument.Parse(JsonSerializer.Serialize(appBuildConfigs)));
                    //
                    //     appMediaAsset.FilePath = url.ToString();
                    // }
                    
                }
                
                // Add to database
                var existingAssets = await _context.AppMediaAssets
                    .Where(x => 
                        x.BusinessAppId == request.BusinessAppId && 
                        x.AssetType == assetType && 
                        x.Platform == request.Platform).ToListAsync(cancellationToken);
                if (existingAssets.Any())
                {
                    foreach (var existingAsset in existingAssets)
                    {
                        existingAsset.IsDefault = false;
                        _context.AppMediaAssets.Update(existingAsset);
                    }
                }
                await _context.AppMediaAssets.AddAsync(appMediaAsset, cancellationToken);
                await _context.SaveChangesAsync(cancellationToken);
                await _mediator.Publish(new EntityUpdatedEvent<AppMediaAsset>(appMediaAsset), cancellationToken);
                
                
                // Return success response
                return ServiceResponse<AppAssetUploadResponse>.Success(new AppAssetUploadResponse
                {
                    Url = uploadedUrl,
                    Name = request.File.FileName
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error uploading app asset for business app {BusinessAppId}", request.BusinessAppId);
                return ServiceResponse<AppAssetUploadResponse>.Error(
                    "UPLOAD_FAILED", 
                    "Failed to upload file. Please try again.");
            }
    }

    private string GetFilePath(string pictureId, string seoFileName, string mimeType)
    {
        var lastPart = GetFileExtensionFromMimeType(mimeType);
        return !string.IsNullOrEmpty(seoFileName)
            ? $"{pictureId}_{seoFileName}.{lastPart}"
            : $"{pictureId}.{lastPart}";
    }
    
    private string GetFileExtensionFromMimeType(string mimeType)
    {
        if (mimeType == null)
            return null;

        var parts = mimeType.Split('/');
        var lastPart = parts[^1];
        switch (lastPart)
        {
            case "pjpeg":
                lastPart = "jpg";
                break;
            case "x-png":
                lastPart = "png";
                break;
            case "x-icon":
                lastPart = "ico";
                break;
        }

        return lastPart;
    }
}
