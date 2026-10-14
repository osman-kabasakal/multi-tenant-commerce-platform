namespace SaasManager.Domain.Enums;

public enum SubscriptionStatus
{
    Active = 0,
    PastDue = 1,
    Cancelled = 2,
    Suspended = 3,
    Expired = 4,
    AwaitingPayment = 5
}
