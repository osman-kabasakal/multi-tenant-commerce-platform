namespace SaasManager.Application.Common.Models.Authantication;

public class RefreshTokenResponseModel
{
    public string AccessToken { get; set; } = null!;
    public string RefreshToken { get; set; } = null!;
    public int ExpiresIn { get; set; }
    public int RefreshExpiresIn { get; set; }
}
