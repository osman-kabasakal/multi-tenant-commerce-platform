using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Email;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.IdentityManagement.EventHandlers;


public class EmailVerificationCodeGeneratedEventHandler 
    : INotificationHandler<EmailVerificationCodeGeneratedEvent>
{
    private readonly IEmailService _emailService;
    private readonly ILogger<EmailVerificationCodeGeneratedEventHandler> _logger;

    public EmailVerificationCodeGeneratedEventHandler(
        IEmailService emailService,
        ILogger<EmailVerificationCodeGeneratedEventHandler> logger)
    {
        _emailService = emailService;
        _logger = logger;
    }

    public Task Handle(
        EmailVerificationCodeGeneratedEvent notification,
        CancellationToken cancellationToken)
    {
        var domainEvent = notification;
        
        try
        {
            // var emailContent = await _templateRenderer.RenderAsync(
            //     "EmailVerification",
            //     new
            //     {
            //         Code = domainEvent.VerificationToken,
            //         ExpiresInMinutes = 5
            //     });

            // await _emailService.SendVerificationEmailAsync(
            //     domainEvent.Email, domainEvent.VerificationToken);

            _logger.LogInformation(
                "Verification code sent to {Email} for guest {GuestId}",
                domainEvent.Email,
                domainEvent.GuestId);
        }
        catch (Exception ex)
        {
            _logger.LogError(
                ex,
                "Failed to send verification code to {Email} for guest {GuestId}",
                domainEvent.Email,
                domainEvent.GuestId);
            throw;
        }

        return Task.CompletedTask;
    }
}

public class MaxVerificationAttemptsReachedEventHandler 
    : INotificationHandler<MaxVerificationAttemptsReachedEvent>
{
    private readonly IApplicationDbContext _context;
    private readonly ISecurityService _securityService;
    private readonly ILogger<MaxVerificationAttemptsReachedEventHandler> _logger;

    public MaxVerificationAttemptsReachedEventHandler(IApplicationDbContext context, ISecurityService securityService, ILogger<MaxVerificationAttemptsReachedEventHandler> logger)
    {
        _context = context;
        _securityService = securityService;
        _logger = logger;
    }

    public async Task Handle(
        MaxVerificationAttemptsReachedEvent notification,
        CancellationToken cancellationToken)
    {
        var domainEvent = notification;
        var guest = await _context.GuestRegistrations
            .FindAsync(new object[] { domainEvent.GuestId }, cancellationToken);

        if (guest != null)
        {
            // // IP adresini banla
            // await _securityService.BanIpAddressAsync(
            //     domainEvent.IpAddress,
            //     TimeSpan.FromHours(24),
            //     "Max verification attempts reached");

            // Guest kaydını sil
            guest.SoftDelete(guest.Id);
            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogWarning(
                "IP {IpAddress} banned for 24 hours due to max verification attempts for guest {GuestId}",
                //TODO: production'da değiştitiricez
                "127.0.0.1",
                domainEvent.GuestId);
        }
    }
}

public class GuestConvertedToUserEventHandler 
    : INotificationHandler<GuestConvertedToUserEvent>
{
    private readonly IEmailService _emailService;
    private readonly ILogger<GuestConvertedToUserEventHandler> _logger;
    private readonly IApplicationDbContext _context;

    public GuestConvertedToUserEventHandler(IEmailService emailService, ILogger<GuestConvertedToUserEventHandler> logger, IApplicationDbContext context)
    {
        _emailService = emailService;
        _logger = logger;
        _context = context;
    }

    public async Task Handle(
        GuestConvertedToUserEvent notification,
        CancellationToken cancellationToken)
    {
        var domainEvent = notification.Item;
        var guest = await _context.GuestRegistrations
            .FindAsync(new object[] { domainEvent.Id }, cancellationToken);

        if (guest?.Email != null)
        {
            try
            {
                // var welcomeContent = await _templateRenderer.RenderAsync(
                //     "WelcomeEmail",
                //     new { Email = guest.Email });
                //
                // await _emailService.SendEmailAsync(
                //     guest.Email,
                //     "Hoş Geldiniz",
                //     welcomeContent,
                //     true);

                _logger.LogInformation(
                    "Welcome email sent to {Email} for guest {GuestId}",
                    guest.Email,
                    domainEvent.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Failed to send welcome email to {Email} for guest {GuestId}",
                    guest.Email,
                    domainEvent.Id);
            }
        }
    }
}

public class PaymentPreAuthCompletedEventHandler 
    : INotificationHandler<PaymentPreAuthCompletedEvent>
{
    private readonly IApplicationDbContext _context;
    private readonly ILogger<PaymentPreAuthCompletedEventHandler> _logger;

    public PaymentPreAuthCompletedEventHandler(IApplicationDbContext context, ILogger<PaymentPreAuthCompletedEventHandler> logger)
    {
        _context = context;
        _logger = logger;
    }

    public  Task Handle(
        PaymentPreAuthCompletedEvent notification,
        CancellationToken cancellationToken)
    {
        var domainEvent = notification;
        
        _logger.LogInformation(
            "Payment pre-auth completed for guest {GuestId}. Amount: {Amount}, AuthCode: {AuthCode}",
            domainEvent.GuestId,
            domainEvent.Amount,
            domainEvent.AuthorizationCode);
        //
        // // Pre-auth logunu kaydet
        // var log = new PaymentAuthorizationLog
        // {
        //     GuestId = domainEvent.GuestId,
        //     Amount = domainEvent.Amount,
        //     AuthorizationCode = domainEvent.AuthorizationCode,
        //     CreatedAt = DateTime.UtcNow
        // };
        //
        // _context.PaymentAuthorizationLogs.Add(log);
        // await _context.SaveChangesAsync(cancellationToken);
        return Task.CompletedTask;
    }
}
