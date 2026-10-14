using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Application.Common.Interfaces.Identity;

public interface IWorkContext
{
    Guid? KeycloakId { get; }
    string? UserEmail { get; }
    bool IsGuest { get; }
    Guid? GuestId { get; }
    string? GuestToken { get; }
    IReadOnlyDictionary<string, string> Claims { get; }
    GuestRegistration? GuestRegistration { get; set; }

    void SetUserContext(Guid userId, string email, IDictionary<string, string> claims);

    void SetGuestContext(Guid guestId, string token);

    void SetGuestRegistration(GuestRegistration? guestRegistration);

    string GetClientIpAddress();
}
