using System.ComponentModel.DataAnnotations;
using Core.Utilities;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.Common.Utilities;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

public class SubscriptionSelectionStep: BaseRegistrationStep<SubscriptionSelectionState>
{
    private readonly IDateTime _dateTime;

    public SubscriptionSelectionStep(
        IApplicationDbContext context,
        IWorkContext workContext, 
        ILogger<SubscriptionSelectionStep> logger,
        IDateTime dateTime
        ) : base(context, workContext, logger)
    {
        _dateTime = dateTime;
    }

    public override string StepKey => nameof(SubscriptionSelectionState);
    public override bool RequiresTimeout { get; set; } = false;
    public override DateTime? ExpiresAt { get; set; }
    public override Task<Dictionary<string, FieldDefinition>> GetExpectedParameters()
    {
        return Task.FromResult(DynamicFormExtensions.ToDynamicFormParameters<SubscriptionSelectionModel>());
    }

    public override async Task<GuestValidationResult> ValidateAsync(RegistrationCommand command, CancellationToken cancellationToken = default)
    {
        var state= await GetOrCreateStateAsync(_workContext.GuestRegistration!, cancellationToken);

        if (state.IsCompleted)
        {
            return ValidationSuccess();
        }

        if (!command.Data.Any())
        {
            return CreateValidationError("");
        }

        var model = command.Data.ToDynamicFormModel<SubscriptionSelectionModel>();

        if (!(await ModelIsValidAsync(model, cancellationToken)))
        {
            return CreateValidationError("Geçersiz plan seçimi");
        }
        
        try
        {
            var subscription = await _context.SubscriptionPlans.FirstAsync(x => x.Id == model.PlanId, cancellationToken: cancellationToken);
            var businessSubscription = new BusinessSubscription(
                businessId: _workContext.GuestRegistration!.ConvertedBusinessId!.Value,
                planId: model.PlanId,
                startDate: _dateTime.Now.AddDays(subscription.TrialDays),
                endDate: _dateTime.Now.AddDays(subscription.TrialDays + 30),
                amount: subscription.Price,
                period: PaymentPeriod.Monthly,
                isTrial: true,
                trialEndsAt: _dateTime.Now.AddDays(subscription.TrialDays),
                previousPlanId: null
            );

            businessSubscription.UpdateStatus(SubscriptionStatus.AwaitingPayment);
            await _context.BusinessSubscriptions.AddAsync(businessSubscription, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            state.SelectPlan(subscription, true);
            state.Complete();
            
            await _context.SaveChangesAsync(cancellationToken);

            return ValidationSuccess();
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error during subscription selection for guest {GuestId}", _workContext.GuestRegistration!.ConvertedBusinessId!.Value);
            return CreateValidationError("Abonelik işlemi sırasında bir hata oluştu");
        }
    }

    private async Task<bool> ModelIsValidAsync(SubscriptionSelectionModel model,
        CancellationToken cancellationToken = default)
    {
        var validationCOntext = new ValidationContext<SubscriptionSelectionModel>(model);
        var validator = new SubscriptionSelectionModelValidator(_context);
        var validationResult = await validator.ValidateAsync(validationCOntext, cancellationToken);
        
        return validationResult.IsValid;
    }

    public class SubscriptionSelectionModelValidator : DynamicFormValidator<SubscriptionSelectionModel>
    {
        private readonly IApplicationDbContext _context;

        public SubscriptionSelectionModelValidator(IApplicationDbContext context):base()
        {
            _context = context;
            
            RuleFor(x=>x.PlanId)
                .NotEmpty()
                .MustAsync(PlanExistsAsync).WithMessage("Geçersiz plan seçimi");
        }
        
        private async Task<bool> PlanExistsAsync(Guid planId, CancellationToken cancellationToken)
        {
            return await _context.SubscriptionPlans
                .AnyAsync(p => p.Id == planId && p.IsActive, cancellationToken);
        }
    }
    
    public class SubscriptionSelectionModel
    {
        [DynamicFormFieldName("planId")]
        [Required]
        public Guid PlanId { get; set; }
    }
}
