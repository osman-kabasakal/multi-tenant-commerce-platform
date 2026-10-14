namespace SaasManager.Application.Common.Models.IdentityManagement;

public record RegistrationInfo(
    string Email,
    string Phone,
    bool IsEmailVerified,
    bool IsPhoneVerified
);
