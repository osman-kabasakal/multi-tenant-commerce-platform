namespace SaasManager.Domain.Enums;

public enum PaymentStatus
{
    Pending = 0,
    Processing = 1,
    Completed = 2,
    Failed = 3,
    Refunded = 4,
    Cancelled = 5,
    PartiallyRefunded = 6
}

public enum PaymentType
{
    SubscriptionPayment = 0,
    OrderPayment = 1,
    RefundPayment = 2,
    DepositPayment = 3
}
