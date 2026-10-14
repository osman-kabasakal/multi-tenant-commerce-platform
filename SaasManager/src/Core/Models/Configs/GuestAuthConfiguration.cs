namespace Core.Models.Configs;

public class GuestAuthConfiguration
{
    public string SecurityKey { get; set; } = null!;
    public string Issuer { get; set; } = null!;
    public string Audience { get; set; } = null!;
    public int TokenExpirationInDays { get; set; }
}
