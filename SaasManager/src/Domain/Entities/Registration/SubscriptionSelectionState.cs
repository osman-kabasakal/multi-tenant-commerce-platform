using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Domain.Entities.Registration;



public class SubscriptionSelectionState : RegistrationState
{
    // Properties
    public Guid? SelectedPlanId { get; private set; }
    public DateTime? SelectionDate { get; private set; }
    
    public bool IsTrialSelected { get; private set; }
    public int AttemptCount { get; private set; }
    public string? LastErrorMessage { get; private set; }

    // Navigation Properties
    public SubscriptionPlan? SelectedPlan { get; private set; }
   

    // Constructors
    public SubscriptionSelectionState() { }

    public SubscriptionSelectionState(GuestRegistration guest) : base(guest)
    {
        AttemptCount = 0;
    }

    // Domain Methods
    public void SelectPlan(SubscriptionPlan plan, bool isTrial)
    {
        if (plan == null)
            throw new ArgumentNullException(nameof(plan));

        SelectedPlanId = plan.Id;
        SelectedPlan = plan;
        SelectionDate = DateTime.UtcNow;
        IsTrialSelected = isTrial;

        AddDomainEvent(new SubscriptionPlanSelectedEvent(GuestId, plan.Id, isTrial));
        Update();
    }


    public void RecordFailedAttempt(string errorMessage)
    {
        AttemptCount++;
        LastErrorMessage = errorMessage;

        if (AttemptCount >= 3)
        {
            AddDomainEvent(new MaxSubscriptionAttemptsReachedEvent(GuestId));
        }

        Update();
    }

    public bool CanAttemptSubscription()
    {
        return AttemptCount < 3;
    }

    public override int Priority => 2;
}
