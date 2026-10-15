using Platform.Security;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Installer.Cli.Models;
using Keycloak.Net;
using Keycloak.Net.Models.Clients;
using Keycloak.Net.Models.ClientScopes;
using Keycloak.Net.Models.Groups;
using Keycloak.Net.Models.ProtocolMappers;
using Keycloak.Net.Models.Users;
using Microsoft.Extensions.Logging;
using System.Security.Cryptography;
using System.Text;

namespace Grand.Installer.Cli.Services.RemoteUserManagement;

public class KeycloakUserService : IKeycloakUserService
{
    private readonly KeycloakClient _keycloakClient;
    private readonly KeycloakSettings _keycloakSettings;
    private readonly ILogger<KeycloakUserService> _logger;
    private readonly ITenantEncryptionService _encryptionService;
    private readonly ITenantSecrets _tenantSecrets;

    public KeycloakUserService(
        IKeycloakService keycloakService,
        KeycloakSettings keycloakSettings,
        ILogger<KeycloakUserService> logger,
        ITenantEncryptionService encryptionService,
        ITenantSecrets tenantSecrets
    )
    {
        _keycloakClient = keycloakService.GetKeycloakClientAsync();
        _keycloakSettings = keycloakSettings;
        _logger = logger;
        _encryptionService = encryptionService;
        _tenantSecrets = tenantSecrets;
    }

    // Kullanıcı Oluşturma
    public async Task<string?> CreateUserAsync(string username, string email, string firstName, string lastName,
        string password, string storeId)
    {
        try
        {
            var savedUsers = await _keycloakClient.GetUsersAsync(realm: _keycloakSettings.Realm, email: email);
            var enumerable = savedUsers as User[] ?? savedUsers.ToArray();
            if (enumerable.Length == 0) throw new Exception($"User with email {email} does not exist");

            var currentUser = enumerable.First();
            currentUser.Attributes ??= new();
            if (currentUser.Attributes.TryGetValue("store_id", out var storeIdAttribute))
            {
                currentUser.Attributes["store_id"] = [storeId];
            }
            else
            {
                currentUser.Attributes.Add("store_id", [storeId]);
            }

            await _keycloakClient.UpdateUserAsync(_keycloakSettings.Realm, currentUser.Id, currentUser);
            return enumerable.First().Id;
        }
        catch (Exception e)
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

            var user = await _keycloakClient.GetUserAsync(_keycloakSettings.Realm, userId);

            if (user.RealmRoles != null && user.RealmRoles.Contains(role.Name))
                return true;

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
                Path = $"/{groupName}",
                Attributes = new Dictionary<string, IEnumerable<string>>() {
                    { "StoreId", new[] { storeId } },
                    { "StoreName", new[] { storeName } },
                    { "StoreMongoConnectionString", new[] { storeMongoConnectionString } }
                }
            };
            await _keycloakClient.CreateGroupAsync(_keycloakSettings.Realm, group);

            await Task.Delay(TimeSpan.FromSeconds(30));
            return await GetGroupByPathAsync(group.Path);
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
            var keycloakUsers =
                await _keycloakClient.GetUsersAsync(_keycloakSettings.Realm, email: ownerEmail, username: ownerEmail);
            if (keycloakUsers.Count() > 1)
            {
                _logger.LogWarning("Multiple user record by {0} were found", ownerEmail);
            }

            var user = keycloakUsers.FirstOrDefault();
            var group = await _keycloakClient.GetGroupAsync(_keycloakSettings.Realm, groupId);
            if (user.Groups != null && user.Groups.Contains(group.Name))
                return;

            await _keycloakClient.UpdateUserGroupAsync(_keycloakSettings.Realm, user.Id, groupId, group);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<(string ClientId, string ClientSecret)> CreateClientWithMappersAsync(
        string clientName,
        string dbConnectionString,
        string storeId,
        string groupId)
    {
        try
        {
            var existingClients = await _keycloakClient.GetClientsAsync(_keycloakSettings.Realm,clientName);
            var enumerable = existingClients as Client[] ?? existingClients.ToArray();
            var clientUuid = string.Empty;
            if (enumerable.Any(x=>x.ClientId==clientName))
            {
                var existingClient = existingClients.First(x=>x.ClientId==clientName);
                existingClient.ProtocolMappers = new List<ClientProtocolMapper>() {
                    new ClientProtocolMapper {
                        Name = "subdomainname",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "sub_domainname" },
                            { "claim.value", clientName },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    },
                    new ClientProtocolMapper {
                        Name = "dbconnection",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "db_connection" },
                            { "claim.value", await EncryptData(dbConnectionString, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    },
                    new ClientProtocolMapper {
                        Name = "storeid",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "store_id" },
                            { "claim.value", await EncryptData(storeId, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    },
                    new ClientProtocolMapper {
                        Name = "groupid",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "group_id" },
                            { "claim.value", await EncryptData(groupId, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    }
                };

                await _keycloakClient.UpdateClientAsync(_keycloakSettings.Realm, existingClient.Id, existingClient);
                clientUuid = existingClient.Id;
            }
            else
            {
                // Create Client
                var client = new Client {
                    ClientId = clientName,
                    Name = clientName,
                    Enabled = true,
                    Protocol = "openid-connect",
                    PublicClient = false,
                    DirectAccessGrantsEnabled = false,
                    ServiceAccountsEnabled = true,
                    ClientAuthenticatorType = "client-secret",
                    AuthorizationServicesEnabled = true,
                    ProtocolMappers = new List<ClientProtocolMapper>() {
                        new ClientProtocolMapper {
                            Name = "subdomainname",
                            Protocol = "openid-connect",
                            ProtocolMapper = "oidc-hardcoded-claim-mapper",
                            Config = new Dictionary<string, string> {
                                { "claim.name", "sub_domainname" },
                                { "claim.value", clientName },
                                { "access.token.claim", "true" },
                                { "id.token.claim", "true" }
                            }
                        },
                        new ClientProtocolMapper {
                            Name = "dbconnection",
                            Protocol = "openid-connect",
                            ProtocolMapper = "oidc-hardcoded-claim-mapper",
                            Config = new Dictionary<string, string> {
                                { "claim.name", "db_connection" },
                                { "claim.value", await EncryptData(dbConnectionString, clientName) },
                                { "access.token.claim", "true" },
                                { "id.token.claim", "true" }
                            }
                        },
                        new ClientProtocolMapper {
                            Name = "storeid",
                            Protocol = "openid-connect",
                            ProtocolMapper = "oidc-hardcoded-claim-mapper",
                            Config = new Dictionary<string, string> {
                                { "claim.name", "store_id" },
                                { "claim.value", await EncryptData(storeId, clientName) },
                                { "access.token.claim", "true" },
                                { "id.token.claim", "true" }
                            }
                        },
                        new ClientProtocolMapper {
                            Name = "groupid",
                            Protocol = "openid-connect",
                            ProtocolMapper = "oidc-hardcoded-claim-mapper",
                            Config = new Dictionary<string, string> {
                                { "claim.name", "group_id" },
                                { "claim.value", await EncryptData(groupId, clientName) },
                                { "access.token.claim", "true" },
                                { "id.token.claim", "true" }
                            }
                        }
                    }
                };


                clientUuid =
                    await _keycloakClient.CreateClientAndRetrieveClientIdAsync(_keycloakSettings.Realm, client);
            }

            var clientsecret = await _keycloakClient.GetClientSecretAsync(_keycloakSettings.Realm, clientUuid!);
            await _tenantSecrets.SetAsync(clientName, TenantSecretNames.KeycloakClient, clientsecret.Value);

            return (clientName, clientsecret.Value);
        }
        catch (Exception e)
        {
            _logger.LogInformation("ClientId: {0} \n ClientSecret: {1}", clientName,string.Empty);
            throw;
        }
    }

    public async Task<Credentials?> GetClientCredentials(string clientName)
    {
        var existingClients = await _keycloakClient.GetClientsAsync(_keycloakSettings.Realm,clientName);
        var enumerable = existingClients as Client[] ?? existingClients.ToArray();
        if (enumerable.Any(x=>x.ClientId==clientName))
        {
            var existingClient = existingClients.First(x=>x.ClientId==clientName);
            return await _keycloakClient.GetClientSecretAsync(_keycloakSettings.Realm, existingClient.Id);
        }

        return null;
    }

    private Task<string> EncryptData(string data, string key)
    {
        return _encryptionService.EncryptAsync(data, key);
    }
}