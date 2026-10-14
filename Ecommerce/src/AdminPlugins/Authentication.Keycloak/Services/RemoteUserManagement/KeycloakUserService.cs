using Keycloak.Net;
using Keycloak.Net.Models.Groups;
using Keycloak.Net.Models.Users;
using Microsoft.Extensions.Logging;

namespace Authentication.Keycloak.Services.RemoteUserManagement;

public class KeycloakUserService : IKeycloakUserService
{
    private readonly KeycloakClient _keycloakClient;
    private readonly KeycloakSettings _keycloakSettings;
    private readonly ILogger<KeycloakUserService> _logger;

    public KeycloakUserService(
        IKeycloakService keycloakService,
        KeycloakSettings keycloakSettings,
        ILogger<KeycloakUserService> logger)
    {
        _keycloakClient = keycloakService.GetKeycloakClientAsync();
        _keycloakSettings = keycloakSettings;
        _logger = logger;
    }

    // Kullanıcı Oluşturma
    public async Task<string?> CreateUserAsync(string username, string email, string firstName, string lastName,
        string password, string storeId)
    {
        try
        {
            var user = new User {
                UserName = username,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                Enabled = true,
                EmailVerified = true,
                Attributes = new Dictionary<string, IEnumerable<string>>() {
                    { "store_id", new[] { storeId } }
                },
            };

            var keyCloakUserId = await _keycloakClient.CreateAndRetrieveUserIdAsync(_keycloakSettings.Realm, user);

            await _keycloakClient.SetUserPasswordAsync(_keycloakSettings.Realm, keyCloakUserId, password);
            
            
            return keyCloakUserId;
        }
        catch(Exception e)
        {
            _logger.LogError(e, "Failed to create keycloak user");
            return null;
        }
    }

    // Kullanıcı Silme
    public async Task<bool> DeleteUserAsync(string userId)
    {
        try
        {
            await _keycloakClient.DeleteUserAsync(_keycloakSettings.Realm, userId);
            return true;
        }
        catch
        {
            return false;
        }
    }

    // Kullanıcıya Rol Atama
    public async Task<bool> AssignRoleToUserAsync(string userId, string roleName)
    {
        try
        {
            // Önce rolü bulalım
            var roles = await _keycloakClient.GetRolesAsync(_keycloakSettings.Realm);
            var role = roles.FirstOrDefault(r => r.Name == roleName);

            if (role == null)
                return false;

            // Rolü kullanıcıya atayalım
            await _keycloakClient.AddRealmRoleMappingsToUserAsync(_keycloakSettings.Realm, userId, new[] { role });
            return true;
        }
        catch
        {
            return false;
        }
    }

    // Kullanıcıdan Rol Kaldırma
    public async Task<bool> RemoveRoleFromUserAsync(string userId, string roleName)
    {
        try
        {
            var roles = await _keycloakClient.GetRolesAsync(_keycloakSettings.Realm);
            var role = roles.FirstOrDefault(r => r.Name == roleName);

            if (role == null)
                return false;

            await _keycloakClient.DeleteRealmRoleMappingsFromUserAsync(_keycloakSettings.Realm, userId, new[] { role });
            return true;
        }
        catch
        {
            return false;
        }
    }

    // Kullanıcı Bilgilerini Getirme
    public async Task<User> GetUserAsync(string userId)
    {
        try
        {
            return await _keycloakClient.GetUserAsync(_keycloakSettings.Realm, userId);
        }
        catch
        {
            return null;
        }
    }

    public async Task<Group?> GetGroupByPathAsync(string groupPath)
    {
        try
        {
            return await _keycloakClient.GetRealmGroupByPathAsync(_keycloakSettings.Realm, groupPath);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Keycloak API Error");
            return null;
        }
    }

    public async Task<Group> CreateGroupIfNotExistsAsync(
        string groupName,
        string storeId,
        string storeName,
        string storeMongoConnectionString
        )
    {
        try
        {
            var existingGroup =
                await GetGroupByPathAsync($"{groupName}");
            if (existingGroup != null)
                return existingGroup;
            var group = new Group {
                Name = groupName,
                Path = $"{groupName}",
                Attributes = new Dictionary<string, IEnumerable<string>>() {
                    { "StoreId", new[] { storeId } },
                    { "StoreName", new[] { storeName } },
                    { "StoreMongoConnectionString", new[] { storeMongoConnectionString } }
                }
            };
            await _keycloakClient.CreateGroupAsync(_keycloakSettings.Realm, group);
            return await _keycloakClient.GetRealmGroupByPathAsync(_keycloakSettings.Realm, group.Path);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Keycloak API Error");
            return null;
        }
    }

    public async Task AssignUserToGroupAsync(string ownerEmail, string groupId)
    {
        try
        {
            var keycloakUsers= await _keycloakClient.GetUsersAsync(_keycloakSettings.Realm, email: ownerEmail,username:ownerEmail);
            if (keycloakUsers.Count() > 1)
            {
                _logger.LogWarning("Multiple user record by {0} were found",ownerEmail);
            }
            var user= keycloakUsers.FirstOrDefault();
            var group = await _keycloakClient.GetGroupAsync(_keycloakSettings.Realm, groupId);
            await _keycloakClient.UpdateUserGroupAsync(_keycloakSettings.Realm, user.Id, groupId, group);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
}