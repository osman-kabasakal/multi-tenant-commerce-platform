namespace Core.Models.Configs;

public class IyzicoConfiguration
{
    public string ProviderId { get; set; } = null!;
    public string ApiKey { get; set; } = null!;
    public string SecretKey { get; set; } = null!;
    public bool IsSandbox { get; set; }
}
