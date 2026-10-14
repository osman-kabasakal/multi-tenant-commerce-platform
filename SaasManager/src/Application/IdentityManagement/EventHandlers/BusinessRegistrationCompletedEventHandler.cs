using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Email;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.IdentityManagement.EventHandlers;

public class BusinessRegistrationCompletedEventHandler 
    : INotificationHandler<BusinessRegistrationCompletedEvent>
{
    private readonly ILogger<BusinessRegistrationCompletedEventHandler> _logger;
    private readonly IEmailService _emailService;
    private readonly IApplicationDbContext _context;

    public BusinessRegistrationCompletedEventHandler(
        ILogger<BusinessRegistrationCompletedEventHandler> logger,
        IEmailService emailService,
        IApplicationDbContext context)
    {
        _logger = logger;
        _emailService = emailService;
        _context = context;
    }

    public async Task Handle(
        BusinessRegistrationCompletedEvent notification,
        CancellationToken cancellationToken)
    {
        _logger.LogInformation("BusinessRegistrationCompletedEventHandler - Event received for BusinessId: {BusinessId}", notification.BusinessId);
        
        var business = await _context.Businesses.FirstOrDefaultAsync(x=>x.Id == notification.BusinessId, cancellationToken: cancellationToken);

        if (business == null)
        {
            _logger.LogWarning("BusinessRegistrationCompletedEventHandler - Business with ID {BusinessId} not found", notification.BusinessId);
            return;
        }
        
        // Log detailed business information
        _logger.LogInformation(
            "BusinessRegistrationCompletedEventHandler - Business details: ID: {BusinessId}, Name: {Name}, Email: {Email}, CreatedByGuestId: {CreatedByGuestId}",
            business.Id, business.Name, business.Email, business.CreatedByGuestId);
        
        // Find all businesses created by the same guest ID
        var relatedBusinesses = await _context.Businesses
            .Where(b => b.CreatedByGuestId == business.CreatedByGuestId)
            .ToListAsync(cancellationToken);
        
        if (relatedBusinesses.Count > 1)
        {
            _logger.LogWarning(
                "BusinessRegistrationCompletedEventHandler - Multiple businesses found with same CreatedByGuestId: {CreatedByGuestId}, Count: {Count}", 
                business.CreatedByGuestId, relatedBusinesses.Count);
            
            foreach (var relatedBusiness in relatedBusinesses)
            {
                _logger.LogInformation(
                    "BusinessRegistrationCompletedEventHandler - Related Business: ID: {BusinessId}, Name: {Name}, Created: {Created}, CreatedBy: {CreatedBy}", 
                    relatedBusiness.Id, relatedBusiness.Name, relatedBusiness.CreatedAt, relatedBusiness.CreatedBy);
            }
        }

        try
        {
            // Hoşgeldiniz emaili gönder
            // await _emailService.SendWelcomeEmailAsync(
            //     business.Email,
            //     business.Name);

            _logger.LogInformation(
                "BusinessRegistrationCompletedEventHandler - Welcome email would be sent for new business registration. Business ID: {BusinessId}",
                business.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(
                ex,
                "BusinessRegistrationCompletedEventHandler - Error sending welcome email for business registration. Business ID: {BusinessId}",
                business.Id);
        }
    }
}
