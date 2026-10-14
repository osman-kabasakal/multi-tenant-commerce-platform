using Core.Models.Responses;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;

namespace SaasManager.Application.IdentityManagement.Commands.Registration;

public record RegistrationCommand : IRequest<ServiceResponse<RegistrationStepResponse>>
{
    public string StepKey { get; init; } = string.Empty;
    public Dictionary<string, object> Data { get; init; } = new();
    public string? ValidationToken { get; init; }
}

public class RegistrationCommandValidator : AbstractValidator<RegistrationCommand>
{
    public RegistrationCommandValidator()
    {
    }
}

public class RegistrationCommandHandler : IRequestHandler<RegistrationCommand, ServiceResponse<RegistrationStepResponse>>
{
    private readonly IApplicationDbContext _context;
    private readonly IEnumerable<IRegistrationStep> _registrationSteps;
    private readonly ISecurityService _securityService;

    public RegistrationCommandHandler(
        IApplicationDbContext context,
        IEnumerable<IRegistrationStep> registrationSteps,
        ISecurityService securityService
        )
    {
        _context = context;
        _registrationSteps = registrationSteps;
        _securityService = securityService;
    }

    public async Task<ServiceResponse<RegistrationStepResponse>> Handle(RegistrationCommand request, CancellationToken cancellationToken)
    {
        foreach (var registrationStep in _registrationSteps)
        {
            var stepValidationResult = await registrationStep.ValidateAsync(request, cancellationToken);
            if(stepValidationResult.IsValid)
                continue;
            
            return ServiceResponse<RegistrationStepResponse>.Success(await CreateStepResponse(registrationStep,stepValidationResult));
        }

        return ServiceResponse<RegistrationStepResponse>.Success(new RegistrationStepResponse
        {
            IsCompleted = true
        });
    }
    
    private async Task<RegistrationStepResponse> CreateStepResponse(IRegistrationStep step, GuestValidationResult validationResult)
    {
        var response = new RegistrationStepResponse
        {
            CurrentStep = step.StepKey,
            ExpectedParams = await step.GetExpectedParameters(),
            ValidationUrl = $"/api/register",
            OperationErrorMessage = validationResult.ErrorMessage,
            Errors = validationResult.Errors
        };

        if (step.RequiresTimeout)
        {
            response.ValidationToken = _securityService.GenerateValidationToken(step.ExpiresAt!.Value);
            response.TimeoutSeconds = Convert.ToInt32(step.ExpiresAt!.Value.Subtract(DateTime.UtcNow).TotalSeconds); // 5 dakika
        }

        return response;
    }
}
