using System.Text.Json.Serialization;

namespace SaasManager.Application.Common.Models;

public class TenantStatusMessage
{
    public string? TenantId { get; set; }
    public TenantStatusEvent? StatusEventType { get; set; }
    public string? StoreName { get; set; }
    public string? StoreSubDomain { get; set; }
    public string? LogoUrl { get; set; }
    public string? LogoId { get; set; }
    public string? OwnerEmail { get; set; }
    [JsonIgnore]
    public string? Password { get; set; }
    public string? FirstName { get; set; }
    public string? Lastname { get; set; }
    public string? Role { get; set; }
    [JsonIgnore]
    public string? MongoConnectionString { get; set; }
    public string CompanyName { get; set; }= string.Empty;
    public string CompanyAddress { get; set; }= string.Empty;
    public string CompanyPhoneNumber { get; set; }= string.Empty;
    public string CompanyEmail { get; set; }= string.Empty;
    
    // Firebase settings
    public FirebaseSettings? Firebase { get; set; }
}


public class FirebaseSettings
{
    [JsonPropertyName("projectId")]
    public string? ProjectId { get; set; }
    
    [JsonPropertyName("iosAppId")]
    public string? IosAppId { get; set; }
    
    [JsonPropertyName("iosTeamId")]
    public string? IosTeamId { get; set; }
    
    [JsonPropertyName("iosBundleId")]
    public string? IosBundleId { get; set; }
    
    [JsonPropertyName("iosAppStoreId")]
    public string? IosAppStoreId { get; set; }
    
    [JsonPropertyName("androidPackageName")]
    public string? AndroidPackageName { get; set; }
    
    [JsonPropertyName("androidSha256Fingerprint")]
    public string? AndroidSha256Fingerprint { get; set; }
}


public enum TenantStatusEvent
{
    Registered,
    EmployeeRegistered,
    Deactivated,
    UserDeleted
}
