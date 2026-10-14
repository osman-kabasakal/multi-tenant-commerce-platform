namespace SaasManager.Application.Common.Models.IdentityManagement;

public record PaymentInfo(
    string CardNumber,
    string CardHolderName,
    string ExpiryMonth,
    string ExpiryYear,
    string Cvv
);
