namespace SaasManager.Application.Common.Interfaces.Identity;

public interface ICurrentUserService
{
    string? UserId { get; }
}
