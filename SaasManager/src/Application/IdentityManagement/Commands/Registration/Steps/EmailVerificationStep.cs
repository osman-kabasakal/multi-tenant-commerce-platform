using Core.Utilities;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Email;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

public class EmailVerificationStep : BaseRegistrationStep<EmailVerificationState>
{
    private readonly IEmailService _emailService;
    private readonly IMediator _mediator;
    private readonly ISecurityService _securityService;
    private EmailVerificationState? _currentState;

    public override string StepKey => nameof(EmailVerificationState);
    public override bool RequiresTimeout { get; set; } = false;
    public override DateTime? ExpiresAt { get; set; }

    public EmailVerificationStep(
        IApplicationDbContext context,
        IWorkContext workContext,
        ILogger<EmailVerificationStep> logger,
        IEmailService emailService,
        IMediator mediator,
        ISecurityService securityService)
        : base(context, workContext, logger)
    {
        _emailService = emailService;
        _mediator = mediator;
        _securityService = securityService;
        _currentState = null;
    }

    public override async Task<GuestValidationResult> ValidateAsync(
        RegistrationCommand command,
        CancellationToken cancellationToken)
    {
        try
        {
            var currentState = await GetOrInitializeState(cancellationToken);
            
            if (currentState.IsCompleted)
                return GuestValidationResult.Success();

            if (EmailVerificationCodeIsSend(currentState))
                return await ValidateVerificationCode(command, currentState, cancellationToken);

            if (await HandleExpiredCode(currentState, cancellationToken))
                return GuestValidationResult.Failure(StepKey, "Email verification is not verified");

            return await HandleEmailCollection(command, currentState, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during email verification for guest {GuestId}", _workContext.GuestId);
            return CreateValidationError("Doğrulama kodu gönderilirken bir hata oluştu");
        }
    }

    private async Task<EmailVerificationState> GetOrInitializeState(CancellationToken cancellationToken)
    {
        var currentState = await GetCurrentState();
        
        if (currentState == null)
        {
            currentState = new EmailVerificationState(_workContext.GuestRegistration!);
            if (_workContext.GuestRegistration!.IsEmailVerified)
            {
                currentState.Complete();
            }
            _context.EmailVerificationStates.Add(currentState);
            await _context.SaveChangesAsync(cancellationToken);
        }
        else if(_workContext.GuestRegistration!.IsEmailVerified)
        {
            currentState.Complete();
            _context.EmailVerificationStates.Update(currentState);
            await _context.SaveChangesAsync(cancellationToken);
        }
        
        return currentState;
    }

    private async Task<GuestValidationResult> ValidateVerificationCode(
        RegistrationCommand command,
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        if (command.StepKey != StepKey)
        {
            RequiresTimeout = true;
            ExpiresAt = state.CodeExpiresAt;
            return GuestValidationResult.Failure(StepKey, "Email verification step is not verified");
        }

        var requestModel = command.Data.BindToModel<EmailCodeVerificationStateModel>();
        
        if (string.IsNullOrEmpty(requestModel.Code) || !state.IsCodeValid(requestModel.Code))
        {
            state.IncrementAttempts("Email verification token is not valid");
            await _context.SaveChangesAsync(cancellationToken);
            if (state.VerificationAttempts > 3)
            {
                await _mediator.Publish(new MaxVerificationAttemptsReachedEvent(state.GuestId), cancellationToken);
            }
            return GuestValidationResult.Failure(StepKey, "Email verification token is not valid");
        }
        state.Complete();
        state.Guest.MarkEmailAsVerified();
        _context.EmailVerificationStates.Update(state);
        await _context.SaveChangesAsync(cancellationToken);
        return GuestValidationResult.Success();
    }

    private async Task<bool> HandleExpiredCode(
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrEmpty(state.VerificationCode) || !state.IsCodeExpired())
            return false;

        if (state.Guest.CanVerifyEmail())
        {
            await ResendVerificationCode(state, cancellationToken);
            return true;
        }

        await HandleExpiredCodeWithoutEmail(state, cancellationToken);
        return true;
    }

    private async Task ResendVerificationCode(
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        var newToken = _securityService.GenerateVerificationCode();
        state.SetVerificationCode(newToken);
        RequiresTimeout = true;
        ExpiresAt = state.CodeExpiresAt;
        _context.EmailVerificationStates.Update(state);
        await _context.SaveChangesAsync(cancellationToken);
    }

    private async Task HandleExpiredCodeWithoutEmail(
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        state.SoftDelete();
        _context.EmailVerificationStates.Update(state);
        await _context.SaveChangesAsync(cancellationToken);
        await GetCurrentState(true);
    }

    private async Task<GuestValidationResult> HandleEmailCollection(
        RegistrationCommand command,
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        if (command.StepKey != StepKey)
            return GuestValidationResult.Failure(StepKey, "Email verification step is not verified");

        var emailModel = command.Data.BindToModel<EmailVerificationStateModel>();
        if (string.IsNullOrEmpty(emailModel.Email))
            return GuestValidationResult.Failure(StepKey, "Email verification step is not verified");

        return await SaveEmailAndSendVerification(emailModel.Email, state, cancellationToken);
    }

    private async Task<GuestValidationResult> SaveEmailAndSendVerification(
        string email,
        EmailVerificationState state,
        CancellationToken cancellationToken)
    {
        //email daha önce kaydedilmiş mi kontrolü yapılacak 
        //email daha önce kayıtlıysa state'i kayıtlı kullanıcıya göre devam ettirmek lazım
        //kaydedilmişse doğrulanmış mı kontrolü yapılacak
        //doğrulanmamışsa token gönderilmiş mi ve token hala geçerli mi kontrolü yapılacak tokengeçerli ama doğrulanmamış ise validation error dönülecek
        //doğrulanmamışsa ve token geçerli değilse yeni token gönderilip state sıfırlanacak
        
        
        
        _workContext.GuestRegistration!.SetEmail(email);
        _context.GuestRegistrations.Update(_workContext.GuestRegistration!);

        var verificationCode = _securityService.GenerateVerificationCode();
        state.SetVerificationCode(verificationCode);
        RequiresTimeout = true;
        ExpiresAt = state.CodeExpiresAt;
        _context.EmailVerificationStates.Update(state);
        
        await _context.SaveChangesAsync(cancellationToken);
        
        await GetCurrentState(true);
        
        return CreateValidationError("Must validate email verification code");
    }

    public async Task<EmailVerificationState?> GetCurrentState(bool force = false,string? email=null)
    {
        if (_currentState != null && !force)
            return _currentState;


        _currentState = await _context.EmailVerificationStates
            .Include(x=>x.Guest)
            .FirstOrDefaultAsync(x =>
            x.GuestId == _workContext.GuestId
            && x.IsDeleted == false
            && x.IsActive == true
        );

        return _currentState;
    }

    private bool EmailVerificationCodeIsSend(EmailVerificationState? state) =>
        state is { IsActive: true, IsCompleted: false } &&
        !string.IsNullOrEmpty(state.VerificationCode)
        && !state.IsCodeExpired();

    public override async Task<Dictionary<string, FieldDefinition>> GetExpectedParameters()
    {
        var state = await GetCurrentState(true);

        if (EmailVerificationCodeIsSend(state))
        {
            return new Dictionary<string, FieldDefinition>()
            {
                ["code"] = new FieldDefinition
                {
                    Type = "text",
                    Label = "Doğrulama Kodu",
                    Required = true,
                    Validations = new Dictionary<string, object> { ["pattern"] = "^[0-9]{6}$" }
                }
            };
        }

        return new Dictionary<string, FieldDefinition>
        {
            ["email"] = new FieldDefinition
            {
                Type = "email",
                Label = "Email Adresi",
                Required = true,
                Validations = new Dictionary<string, object> { ["pattern"] = @"^[^@\s]+@[^@\s]+\.[^@\s]+$" }
            }
        };
    }

    private record EmailVerificationStateModel(
        [DynamicFormFieldName("email")] string? Email
    );

    private record EmailCodeVerificationStateModel(
        [DynamicFormFieldName("code")] string? Code
    );
}
