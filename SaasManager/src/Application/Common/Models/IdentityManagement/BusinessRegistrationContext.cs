using SaasManager.Domain.Enums;

namespace SaasManager.Application.Common.Models.IdentityManagement;

public class BusinessRegistrationContext
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid GuestRegistrationId { get; private set; }
    public RegistrationStep CurrentStep { get; private set; }
    
    // Her adım için gerekli veriler
    public RegistrationInfo RegistrationInfo { get; private set; } = null!;
    public BusinessInfo BusinessInfo { get; private set; } = null!;
    public PaymentInfo PaymentInfo { get; private set; } = null!;

    // State'ler arası veri paylaşımı için
    public Dictionary<string, object> StateData { get; private set; } = new();

    public BusinessRegistrationContext(Guid guestRegistrationId, RegistrationStep currentStep)
    {
        GuestRegistrationId = guestRegistrationId;
        CurrentStep = currentStep;
    }

    public void UpdateStep(RegistrationStep step)
    {
        CurrentStep = step;
    }

    public void SetRegistrationInfo(RegistrationInfo info)
    {
        RegistrationInfo = info;
    }

    public void SetBusinessInfo(BusinessInfo info)
    {
        BusinessInfo = info;
    }

    public void SetPaymentInfo(PaymentInfo info)
    {
        PaymentInfo = info;
    }
}
