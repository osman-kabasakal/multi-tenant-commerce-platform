namespace SaasManager.Application.Stores.Commands.RegisterStore;

public class RegisterStoreDto
{
    public string StoreName { get; set; }= string.Empty;
    public string StoreSubDomain { get; set; }= string.Empty;
    public string LogoUrl { get; set; }= string.Empty;
    public string OwnerEmail { get; set; }= string.Empty;
    public string Password { get; set; }= string.Empty;
    public string FirstName { get; set; }= string.Empty;
    public string Lastname { get; set; }= string.Empty;
    public string Role { get; set; }= string.Empty;
}
