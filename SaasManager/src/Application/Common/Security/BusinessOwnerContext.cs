using SaasManager.Application.Common.Interfaces.Identity;

namespace SaasManager.Application.Common.Security;

public static class BusinessOwnerContext
{
    public static Guid? BusinessId(IWorkContext context)
    {
        var guest=context.GuestRegistration;
        return context.KeycloakId is {} actor && guest is { IsEmailVerified:true,ConvertedBusinessId:{} business } &&
            business!=Guid.Empty && Guid.TryParse(guest.KeycloakUserId,out var owner) && owner==actor ? business : null;
    }
}
