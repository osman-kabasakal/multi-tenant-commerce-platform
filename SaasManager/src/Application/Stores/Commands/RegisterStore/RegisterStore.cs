using SaasManager.Application.Common.Utilities;
using SaasManager.Application.Common.Interfaces.Identity;
using Platform.Security;
using SaasManager.Application.Stores.Provisioning;
using Platform.Provisioning;
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
        RuleFor(x => x.Password).NotEmpty().MinimumLength(8).MaximumLength(128);
        RuleFor(x => x.FirstName).NotEmpty().MinimumLength(1).MaximumLength(100);
        RuleFor(x => x.Lastname).NotEmpty().MinimumLength(1).MaximumLength(100);
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
    private readonly ITenantSecrets _tenantSecrets;
    private readonly IWorkContext _workContext;
    private readonly IProvisioningQueue? _provisioning;

    private const string CHANNEL_NAME = "tenant-status-events";

    public RegisterStoreCommandHandler(
        IApplicationDbContext context,
        IMongoAtlasManager mongoAtlasManager,
        ISubscriber subscriber,
        IConfiguration configuration,
        ITenantSecrets tenantSecrets,
        IWorkContext workContext,
        IProvisioningQueue? provisioning = null
        )
    {
        _context = context;
        _mongoAtlasManager = mongoAtlasManager;
        _subscriber = subscriber;
        _configuration = configuration;
        _tenantSecrets = tenantSecrets;
        _workContext = workContext;
        _provisioning = provisioning;
    }
    
    public async Task<ServiceResponse<TenantStatusMessage>> Handle(RegisterStoreCommand request, CancellationToken cancellationToken)
    {
        if (request.BusinessId == Guid.Empty) throw new ArgumentException("BusinessId is required.");
        var business = await _context.Businesses.FirstOrDefaultAsync(b => b.Id == request.BusinessId && !b.IsDeleted, cancellationToken)
            ?? throw new InvalidOperationException("Business was not found.");
        var owner = _workContext.GuestRegistration?.Id ?? _workContext.GuestId;
        if (owner == null || business.CreatedByGuestId != owner.Value)
            throw new UnauthorizedAccessException("Business ownership is required to provision tenant secrets.");
        if (!string.Equals(request.StoreSubDomain, business.ToSubdomain(), StringComparison.Ordinal))
            throw new ArgumentException("Store subdomain must match the registered business.");
        var mobileProfile=_configuration["Provisioning:Mobile:Provider"]??"Disabled";
        if(mobileProfile is not ("Disabled" or "AndroidAppDistribution" or "AndroidIosAppDistribution") || mobileProfile!="Disabled" &&
            (!_configuration.GetValue<bool>("Provisioning:Enabled") || _configuration["Provisioning:Profile"]!="Portable" || string.IsNullOrWhiteSpace(_configuration["Provisioning:DeploymentId"])))
            throw new InvalidOperationException("Signed mobile enrollment requires an explicit durable Portable deployment.");
        if (!string.Equals(request.OwnerEmail, _workContext.GuestRegistration?.Email, StringComparison.OrdinalIgnoreCase))
            throw new UnauthorizedAccessException("The store owner email must match the registered business owner.");
        await TenantProvisioningEntitlement.RequireAsync(_context, _workContext, _configuration, business.Id, cancellationToken);
        var tenantId = request.BusinessId.ToString("N");
        await _tenantSecrets.ProvisionAsync(tenantId, request.StoreSubDomain, cancellationToken);
        if (_configuration.GetValue<bool>("Provisioning:Enabled"))
        {
            if (_provisioning == null) throw new InvalidOperationException("Register the durable provisioning queue.");
            var businessAppForProvisioning = await _context.BusinessApps.FirstOrDefaultAsync(x => x.BusinessId == request.BusinessId, cancellationToken);
            // Save once before enqueueing; a replay must not rotate credentials used by an in-flight installer.
            await _tenantSecrets.GetOrCreateAsync(tenantId, TenantSecretNames.InitialPassword,
                () => string.IsNullOrWhiteSpace(request.Password) ? throw new ArgumentException("Initial password is required.") : request.Password,
                cancellationToken);
            await _provisioning.EnqueueAsync(new TenantProvisioningRequest(tenantId, request.StoreSubDomain,
                request.StoreName, request.OwnerEmail, request.FirstName, request.Lastname,
                request.CompanyAddress, request.CompanyPhoneNumber, request.CompanyEmail,
                businessAppForProvisioning?.PackageName, businessAppForProvisioning?.PackageName, _configuration["Provisioning:DeploymentId"], mobileProfile), cancellationToken);
            return ServiceResponse<TenantStatusMessage>.Success(new TenantStatusMessage {
                TenantId = tenantId, StatusEventType = TenantStatusEvent.Registered,
                StoreName = request.StoreName, StoreSubDomain = request.StoreSubDomain,
                OwnerEmail = request.OwnerEmail
            });
        }
        var statusMessage = await _mongoAtlasManager.CreateDatabaseUserByStoreAsync(request, cancellationToken);
        await _tenantSecrets.SetAsync(tenantId, TenantSecretNames.DatabaseConnection, statusMessage.MongoConnectionString!, cancellationToken);
        await _tenantSecrets.SetAsync(tenantId, TenantSecretNames.InitialPassword, statusMessage.Password!, cancellationToken);
        statusMessage.TenantId = tenantId;
        
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
        
        // Keep credentials off Redis and the persisted background-job arguments.
        var transport = JsonSerializer.Deserialize<TenantStatusMessage>(JsonSerializer.Serialize(statusMessage))!;
        transport.MongoConnectionString = null;
        transport.Password = null;
        await _subscriber.PublishAsync(RedisChannel.Literal(CHANNEL_NAME),JsonSerializer.Serialize(transport));
        return ServiceResponse<TenantStatusMessage>.Success(transport);
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
