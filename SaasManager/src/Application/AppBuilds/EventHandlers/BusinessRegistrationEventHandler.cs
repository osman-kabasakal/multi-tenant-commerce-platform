using Core.Utilities;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.IdentityManagement.EventHandlers;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.AppBuilds.EventHandlers;

public class BusinessRegistrationEventHandler: INotificationHandler<BusinessRegistrationCompletedEvent>
{
    private readonly ILogger<BusinessRegistrationEventHandler> _logger;
    private readonly IApplicationDbContext _context;

    public BusinessRegistrationEventHandler(
        ILogger<BusinessRegistrationEventHandler> logger,
        IApplicationDbContext context
        )
    {
        _logger = logger;
        _context = context;
    }
    
    
    public async Task Handle(BusinessRegistrationCompletedEvent notification, CancellationToken cancellationToken)
    {
        _logger.LogInformation("BusinessRegistrationCompletedEvent received for BusinessId: {BusinessId}", notification.BusinessId);
        
        var business = await _context.Businesses
            .FirstOrDefaultAsync(b => b.Id == notification.BusinessId, cancellationToken);
            
        if (business == null)
        {
            _logger.LogWarning("Business with ID {BusinessId} not found", notification.BusinessId);
            return;
        }
        
        if (business.IsDeleted || (!business.IsActive && business.Status != BusinessStatus.UnderSetup))
        {
            _logger.LogWarning("Business with ID {BusinessId} is deleted or inactive. IsDeleted: {IsDeleted}, IsActive: {IsActive}, Status: {Status}", 
                notification.BusinessId, business.IsDeleted, business.IsActive, business.Status);
            return;
        }
        
        // Log the business details
        _logger.LogInformation("Business details - ID: {BusinessId}, Name: {Name}, LegalName: {LegalName}, CreatedByGuestId: {CreatedByGuestId}", 
            business.Id, business.Name, business.LegalCompanyName, business.CreatedByGuestId);
        
        // Log any existing apps for this business
        if (business.Apps?.Any() == true)
        {
            foreach (var app in business.Apps)
            {
                _logger.LogInformation("Existing BusinessApp - ID: {AppId}, BusinessId: {BusinessId}, Type: {AppType}, Name: {AppName}", 
                    app.Id, app.BusinessId, app.Type, app.AppName);
            }
        }
        
        // Find all businesses created by the same guest ID
        var relatedBusinesses = await _context.Businesses
            .Where(b => b.CreatedByGuestId == business.CreatedByGuestId)
            .ToListAsync(cancellationToken);
            
        if (relatedBusinesses.Count > 1)
        {
            _logger.LogWarning("Multiple businesses found with the same CreatedByGuestId: {CreatedByGuestId}", business.CreatedByGuestId);
            foreach (var relatedBusiness in relatedBusinesses)
            {
                _logger.LogInformation("Related Business - ID: {BusinessId}, Name: {Name}, CreatedAt: {CreatedAt}", 
                    relatedBusiness.Id, relatedBusiness.Name, relatedBusiness.CreatedAt);
                
                // Get all apps for this business
                var apps = await _context.BusinessApps
                    .Where(a => a.BusinessId == relatedBusiness.Id)
                    .ToListAsync(cancellationToken);
                    
                foreach (var app in apps)
                {
                    _logger.LogInformation("App for related business {BusinessId} - AppId: {AppId}, Type: {AppType}, Name: {AppName}", 
                        relatedBusiness.Id, app.Id, app.Type, app.AppName);
                }
            }
        }
        
        var businessApp = await _context.BusinessApps
            .FirstOrDefaultAsync(b => b.BusinessId == notification.BusinessId, cancellationToken);
            
        if (businessApp == null)
        {
            _logger.LogInformation("Creating new BusinessApp for BusinessId: {BusinessId}", notification.BusinessId);
            
            var newApp = new BusinessApp(
                businessId: notification.BusinessId,
                type: AppType.CustomerMobile,
                appName: business.LegalCompanyName,
                packageName: $"com.famizyo.{business.ToSubdomain().ToFlutterFlavorName().ToLowerInvariant()}"
            );
            
            await _context.BusinessApps.AddAsync(newApp, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
            
            _logger.LogInformation("New BusinessApp created - ID: {AppId}, BusinessId: {BusinessId}, Type: {AppType}, Name: {AppName}", 
                newApp.Id, newApp.BusinessId, newApp.Type, newApp.AppName);
        }
        else
        {
            _logger.LogInformation("BusinessApp already exists - ID: {AppId}, BusinessId: {BusinessId}, Type: {AppType}, Name: {AppName}", 
                businessApp.Id, businessApp.BusinessId, businessApp.Type, businessApp.AppName);
        }
    }
}
