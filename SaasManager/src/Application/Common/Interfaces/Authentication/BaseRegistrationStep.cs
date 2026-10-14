using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Application.Common.Interfaces.Authentication;

public abstract class BaseRegistrationStep<TState> : IRegistrationStep
where TState: RegistrationState, new()
{
    protected readonly IApplicationDbContext _context;
    protected readonly IWorkContext _workContext;
    protected readonly ILogger _logger;

    protected BaseRegistrationStep(
        IApplicationDbContext context,
        IWorkContext workContext,
        ILogger logger)
    {
        _context = context;
        _workContext = workContext;
        _logger = logger;
    }

    public abstract string StepKey { get; }
    public abstract bool RequiresTimeout { get; set; }
    public abstract DateTime? ExpiresAt { get; set; }

    public abstract Task<Dictionary<string, FieldDefinition>> GetExpectedParameters();
    
    public abstract Task<GuestValidationResult> ValidateAsync(
        RegistrationCommand command,
        CancellationToken cancellationToken = default);

    protected GuestValidationResult CreateValidationError(string message,Dictionary<string, List<string>>? errors= null) =>
        GuestValidationResult.Failure(StepKey, message,errors);

    protected GuestValidationResult ValidationSuccess() =>
        GuestValidationResult.Success();
    
    protected async Task<TState> GetOrCreateStateAsync(
        GuestRegistration guest,
        CancellationToken cancellationToken)
    {
        var state = await _context.RegistrationStates
            .OfType<TState>()
            .FirstOrDefaultAsync(s => 
                    s.GuestId == guest.Id,
                cancellationToken);

        if (state == null)
        {
            state = new TState();
            state.SetGuest(guest);
            await _context.RegistrationStates.AddAsync(state, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
        }

        return state;
    }
}
