using Keycloak.Net.Models.Groups;
using Keycloak.Net.Models.Users;

namespace Grand.Installer.Cli.Services.RemoteUserManagement;

public interface IKeycloakUserService
{
    Task<string?> CreateUserAsync(string username, string email, string firstName, string lastName,
        string password,string storeId);
    Task<bool> DeleteUserAsync(string userId);

    Task<bool> AssignRoleToUserAsync(string userId, string roleName);

    Task<bool> RemoveRoleFromUserAsync(string userId, string roleName);

    Task<User> GetUserAsync(string userId);
    
    Task<Group?> GetGroupByPathAsync(string groupPath);

    Task<Group> CreateGroupIfNotExistsAsync(string groupName,
        string storeId,
        string storeName,
        string storeMongoConnectionString);

    Task AssignUserToGroupAsync(string ownerEmail, string groupId);

    Task<(string ClientId, string ClientSecret)> CreateClientWithMappersAsync(
        string clientName,
        string dbConnectionString,
        string storeId,
        string groupId);
    
    Task<Credentials?> GetClientCredentials(string clientUuid);
}