namespace Authentication.Keycloak.Models;

public enum BuildPlatform
{
    Ios,
    Android,
    Windows
}

public class NewBuildRedisMessage
{
    public Guid BusinessAppId { get; set; }
    public string Version { get; set; } = null!;
    public int BuildNumber { get; set; }
    public BuildPlatform Platform { get; set; }
    public string FilePath { get; set; } = null!;
    public List<string> SigningKeysSHA256 { get; set; }
    public string PackageName { get; set; }
    public string IosAppId { get; set; }
    public string StoreGroupName { get; set; }

}