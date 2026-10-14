using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Application.Common.Interfaces.Authentication;

public interface IRegistrationStep
{
    string StepKey { get; }
    bool RequiresTimeout { get; set; }
    
    DateTime? ExpiresAt { get; set; }
    
    Task<Dictionary<string, FieldDefinition>> GetExpectedParameters();
    Task<GuestValidationResult> ValidateAsync(
        RegistrationCommand command,
        CancellationToken cancellationToken = default);
}
