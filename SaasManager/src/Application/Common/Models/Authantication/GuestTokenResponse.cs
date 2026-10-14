namespace SaasManager.Application.Common.Models.Authantication;

public class GuestTokenResponse
{
    public string Token { get; init; } = string.Empty;
    public DateTime ExpiresAt { get; init; }
    public Guid GuestId { get; init; }
}
