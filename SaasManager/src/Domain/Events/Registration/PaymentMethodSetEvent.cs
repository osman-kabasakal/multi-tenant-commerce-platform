namespace SaasManager.Domain.Events.Registration;

public class PaymentMethodSetEvent(Guid guestId, Guid paymentMethodId) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public Guid PaymentMethodId { get; } = paymentMethodId;
}