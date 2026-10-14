using System.Text.Json;
using Core.Models.Responses;
using FluentValidation.Validators;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Common.Security;
using StackExchange.Redis;

namespace SaasManager.Application.Stores.Commands.RegisterStore;

public record RegisterStoreCommand : IRequest<ServiceResponse<TenantStatusMessage>>
{
    public string StoreName { get; set; }= string.Empty;
    public Guid BusinessId { get; set; }
    public string StoreSubDomain { get; set; }= string.Empty;
    public string LogoUrl { get; set; }= string.Empty;
    public string OwnerEmail { get; set; }= string.Empty;
    public string Password { get; set; }= string.Empty;
    public string FirstName { get; set; }= string.Empty;
    public string Lastname { get; set; }= string.Empty;
    public string Role { get; set; }= string.Empty;
    
    public string CompanyName { get; set; }= string.Empty;
    public string CompanyAddress { get; set; }= string.Empty;
    public string CompanyPhoneNumber { get; set; }= string.Empty;
    public string CompanyEmail { get; set; }= string.Empty;
}

public class RegisterStoreCommandValidator : AbstractValidator<RegisterStoreCommand>
{
    public RegisterStoreCommandValidator()
    {
        RuleFor(x => x.StoreName).NotEmpty();
        RuleFor(x => x.StoreSubDomain).NotEmpty();
        RuleFor(x => x.LogoUrl).NotEmpty();
        RuleFor(x => x.OwnerEmail).NotEmpty().EmailAddress(mode: EmailValidationMode.AspNetCoreCompatible);
        RuleFor(x => x.Password).NotEmpty().MinimumLength(8).MaximumLength(16);
        RuleFor(x => x.FirstName).NotEmpty().MinimumLength(4).MaximumLength(16);
        RuleFor(x => x.Lastname).NotEmpty().MinimumLength(3).MaximumLength(16);
        RuleFor(x => x.Role).NotEmpty();
        
    }
}

[Authorize]
public class RegisterStoreCommandHandler : IRequestHandler<RegisterStoreCommand, ServiceResponse<TenantStatusMessage>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMongoAtlasManager _mongoAtlasManager;
    private readonly ISubscriber _subscriber;
    private readonly IConfiguration _configuration;

    private const string CHANNEL_NAME = "tenant-status-events";

    public RegisterStoreCommandHandler(
        IApplicationDbContext context,
        IMongoAtlasManager mongoAtlasManager,
        ISubscriber subscriber,
        IConfiguration configuration
        )
    {
        _context = context;
        _mongoAtlasManager = mongoAtlasManager;
        _subscriber = subscriber;
        _configuration = configuration;
    }
    
    public async Task<ServiceResponse<TenantStatusMessage>> Handle(RegisterStoreCommand request, CancellationToken cancellationToken)
    {
        var statusMessage = await _mongoAtlasManager.CreateDatabaseUserByStoreAsync(request, cancellationToken);
        
        statusMessage.Firebase = new FirebaseSettings()
        {
            ProjectId = _configuration["Famizyo:GCloudProjectId"],//GetprojectProjectId(request.StoreSubDomain, request.BusinessId),
            
        };
        
        var businessApp = await _context.BusinessApps.FirstOrDefaultAsync(x=>x.BusinessId == request.BusinessId, cancellationToken: cancellationToken);

        if (businessApp != null)
        {
            statusMessage.Firebase.AndroidPackageName = businessApp.PackageName;
            statusMessage.Firebase.IosBundleId = businessApp.PackageName;
        }
        
        await _subscriber.PublishAsync(RedisChannel.Literal(CHANNEL_NAME),JsonSerializer.Serialize(statusMessage));
        return ServiceResponse<TenantStatusMessage>.Success(statusMessage);
    }
    
    private string GetProjectId(string subDomain, Guid businessId)
    {
        var projectId = subDomain+"-"+businessId.ToString("N");
        if (projectId.Length < 6)
        {
            projectId = projectId.PadLeft(6-projectId.Length, '0');
        }

        if (projectId.Length > 30)
        {
            projectId = projectId.Substring(0, 30);
        }

        return projectId;
    }
}
