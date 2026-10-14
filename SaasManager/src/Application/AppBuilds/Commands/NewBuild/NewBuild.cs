using System.Text.Json;
using Core.Models.Responses;
using FluentValidation.Results;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events;

namespace SaasManager.Application.AppBuilds.Commands.NewBuild;

public record NewBuildCommand : IRequest<ServiceResponse<NewBuildDto>>
{
    public NewBuildVm? NewBuild { get; init; }
}

public class NewBuildCommandValidator : AbstractValidator<NewBuildCommand>
{
    public NewBuildCommandValidator(
        IApplicationDbContext context,
        IWorkContext workContext
        )
    {
        RuleFor(x => x.NewBuild)
            .NotNull()
            .WithMessage("Form boş gönderilemez")
            .Custom((prop, validateContext) =>
            {
                var businessApp = context.BusinessApps.FirstOrDefault(x =>
                    x.BusinessId == workContext.GuestRegistration!.ConvertedBusinessId &&
                    x.Id == prop!.BusinessAppId && x.Type == AppType.CustomerMobile);
                if (businessApp==null)
                {
                    validateContext.AddFailure(new ValidationFailure("NewBuild.BusinessAppId", "Uygulama bulunamadı"));
                    return;
                }
                
                var hasActiveBuild = context.AppBuilds.Any(x => x.BusinessAppId == prop!.BusinessAppId &&
                                                          x.IsActive && x.CreatedAt> DateTime.UtcNow.AddMinutes(-15) 
                );

                if (hasActiveBuild)
                {
                    validateContext.AddFailure(new ValidationFailure("NewBuild.BusinessAppId", "Şu anda başka bir derleme işlemi devam ediyor"));
                    return;
                }
            });
    }
}

[Authorize]
public class NewBuildCommandHandler : IRequestHandler<NewBuildCommand, ServiceResponse<NewBuildDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IWorkContext _workContext;
    private readonly IMediator _mediator;

    public NewBuildCommandHandler(
        IApplicationDbContext context,
        IWorkContext workContext,
        IMediator mediator
        )
    {
        _context = context;
        _workContext = workContext;
        _mediator = mediator;
    }

    public async Task<ServiceResponse<NewBuildDto>> Handle(NewBuildCommand request, CancellationToken cancellationToken)
    {
        var businessApp = await _context.BusinessApps.FirstAsync((e)=> 
            e.Id == request.NewBuild!.BusinessAppId && 
            e.BusinessId == _workContext.GuestRegistration!.ConvertedBusinessId && 
            e.Type == AppType.CustomerMobile,
            cancellationToken
        );

        var buildConf = businessApp.BuildConfiguration.Deserialize<AppBuildsConfig>();
        
        var logoMedia = await _context.AppMediaAssets.FirstOrDefaultAsync(x => x.AssetType == AppMediaAssetType.Logo && x.IsDefault && !x.IsDeleted && x.BusinessAppId == businessApp.Id, cancellationToken);
        buildConf.StoreLogo = logoMedia?.FilePath??"https://sanal-donusum.commerce.test/images/logo.svg";
        
        var iconMedia = await _context.AppMediaAssets.FirstOrDefaultAsync(x => x.AssetType == AppMediaAssetType.Icon && x.IsDefault && !x.IsDeleted && x.BusinessAppId == businessApp.Id, cancellationToken);
        buildConf.StoreIcon = iconMedia?.FilePath??"https://sanal-donusum.commerce.test/favicon-96x96.png";
        
        buildConf.BusinessAppId = businessApp.Id;
        buildConf.Version = businessApp.Version;
        buildConf.BuildNumber = businessApp.BuildNumber + 1;
        
        var entity = new AppBuild()
        {
            BusinessAppId = request.NewBuild!.BusinessAppId,
            Platform = BuildPlatform.Android,
            Version = businessApp.Version,
            BuildNumber = businessApp.BuildNumber + 1,
            BuildStatus = BuildStatus.Queued.ToString(),
            IsActive = true,
            Configuration = JsonDocument.Parse(JsonSerializer.Serialize(buildConf)),
            FileSize = 0,
        };
        await _context.AppBuilds.AddAsync(entity, cancellationToken);
        
        businessApp.SetBuildConfiguration(JsonDocument.Parse(JsonSerializer.Serialize(buildConf)));
        businessApp.UpdateBuildStatus(BuildStatus.Queued);
        businessApp.UpdateVersion(businessApp.Version,businessApp.BuildNumber+1);
        _context.BusinessApps.Update(businessApp);
        
        await _context.SaveChangesAsync(cancellationToken);
        await _mediator.Publish(new EntityCreatedEvent<AppBuild>(entity), cancellationToken);
        
            
        return ServiceResponse<NewBuildDto>.Success(new NewBuildDto()
        {
            BusinessAppId = request.NewBuild!.BusinessAppId,
            Version = businessApp.Version,
            BuildNumber = businessApp.BuildNumber+1,
            BuildStatus = BuildStatus.Queued.ToString(),
        });
    }
}
