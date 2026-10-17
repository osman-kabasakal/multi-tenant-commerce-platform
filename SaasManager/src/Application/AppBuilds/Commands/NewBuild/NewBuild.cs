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
                if (prop == null) return;
                var owner = BusinessOwnerContext.BusinessId(workContext);
                var businessApp = context.BusinessApps.FirstOrDefault(x => x.BusinessId == owner && x.Id == prop.BusinessAppId && !x.IsDeleted && x.IsActive && x.Type == AppType.CustomerMobile);
                if (businessApp == null)
                {
                    validateContext.AddFailure(new ValidationFailure("NewBuild.BusinessAppId", "Uygulama bulunamadı"));
                    return;
                }

                var hasActiveBuild = context.AppBuilds.Any(x => x.BusinessAppId == prop!.BusinessAppId &&
                                                          !x.IsDeleted && (x.BuildStatus == "Queued" || x.BuildStatus == "Building")
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
    private readonly IPortableAppBuilds? _portable;

    public NewBuildCommandHandler(
        IApplicationDbContext context,
        IWorkContext workContext,
        IMediator mediator, IPortableAppBuilds? portable = null
        )
    {
        _context = context;
        _workContext = workContext;
        _mediator = mediator;
        _portable = portable;
    }

    public async Task<ServiceResponse<NewBuildDto>> Handle(NewBuildCommand request, CancellationToken cancellationToken)
    {
        var eligibility = await BuildEligibility.CheckAsync(_context, _workContext, cancellationToken);
        var businessApp = eligibility.App;
        if (!eligibility.Allowed || request.NewBuild == null || businessApp?.Id != request.NewBuild.BusinessAppId)
            return ServiceResponse<NewBuildDto>.Error("build_unavailable", eligibility.BlockReason ?? "Uygulama bulunamadı.");
        if (_portable != null)
        {
            if (request.NewBuild.RequestId == Guid.Empty || request.NewBuild.BuildNumber < 1)
                return ServiceResponse<NewBuildDto>.Error("invalid_build", "Derleme bilgileri geçersiz. Sayfayı yenileyin.");
            try { return ServiceResponse<NewBuildDto>.Success(await _portable.EnqueueAsync(businessApp, request.NewBuild, cancellationToken)); }
            catch (ArgumentException)
            { return ServiceResponse<NewBuildDto>.Error("invalid_branding", "İşletme logosunu ve en az 512×512 piksel kare PNG/JPEG uygulama ikonunu yükleyin. Görseller en fazla 5 MiB ve 4096×4096 piksel olabilir."); }
            catch (Platform.Provisioning.ProvisioningConflictException)
            { return ServiceResponse<NewBuildDto>.Error("build_unavailable", "Derleme durumu değişti. Sayfayı yenileyip tekrar deneyin."); }
        }
        if (businessApp.BuildStatus is BuildStatus.Queued or BuildStatus.Building ||
            await _context.AppBuilds.AnyAsync(b => b.BusinessAppId == businessApp.Id && !b.IsDeleted && (b.BuildStatus == "Queued" || b.BuildStatus == "Building"), cancellationToken))
            return ServiceResponse<NewBuildDto>.Error("build_unavailable", "Şu anda başka bir derleme işlemi devam ediyor.");

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
            BuildNumber = entity.BuildNumber,
            BuildStatus = BuildStatus.Queued.ToString(),
        });
    }
}
