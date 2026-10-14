namespace SaasManager.Domain.Events.Registration;

public class PaymentPreAuthCompletedEvent(
    Guid guestId,
    decimal amount,
    string authorizationCode)
    : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public decimal Amount { get; } = amount;
    public string AuthorizationCode { get; } = authorizationCode;
    public DateTime CompletedAt { get; } = DateTime.UtcNow;
}