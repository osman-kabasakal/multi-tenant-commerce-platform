namespace Authentication.Keycloak.Models;

public class TenantStatusMessage
{
    public TenantStatusEvent? StatusEventType { get; set; }
    public string? StoreName { get; set; }
    public string? StoreSubDomain { get; set; }
    public string? LogoUrl { get; set; }
    public string? OwnerEmail { get; set; }
    public string? Password { get; set; }
    public string? FirstName { get; set; }
    public string? Lastname { get; set; }
    public string? Role { get; set; }
    public string? MongoConnectionString { get; set; }
    public string CompanyName { get; set; }= string.Empty;
    public string CompanyAddress { get; set; }= string.Empty;
    public string CompanyPhoneNumber { get; set; }= string.Empty;
    public string CompanyEmail { get; set; }= string.Empty;
}

public enum TenantStatusEvent
{
    Registered,
    EmployeeRegistered,
    Deactivated,
    UserDeleted
}