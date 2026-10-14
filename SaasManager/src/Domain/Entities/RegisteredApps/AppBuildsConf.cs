namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppBuildsConfig
{
    public Guid BusinessAppId { get; set; }
    public string? GCloudProjectId { get; set; }
    public string Flavor { get;set; } = null!;
    public string StoreUrl { get;set; }= null!;
    public string AuthUrl { get;set; }= null!;
    public string AuthRealm { get;set; }= null!;
    public string AuthClientId { get;set; }= null!;
    public string KeycloakClientSecret { get;set; }= null!;
    public string StoreLogo { get;set; }= null!;
    public string StoreLogoId { get;set; }= null!;
    public string StoreIcon { get;set; }= null!;
    public string PackageNameAndroid { get;set; }= null!;
    public string PackageNameIos { get;set; }= null!;
    public string AppTitle { get;set; }= null!;

    public string Version { get; set; } = null!;
    public int BuildNumber { get; set; } 
}
