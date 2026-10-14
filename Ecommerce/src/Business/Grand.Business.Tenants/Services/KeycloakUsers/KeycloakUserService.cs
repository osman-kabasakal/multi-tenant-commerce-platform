using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Domain.Tenants;
using Keycloak.Net;
using Keycloak.Net.Models.Clients;
using Keycloak.Net.Models.Groups;
using Keycloak.Net.Models.Users;
using Microsoft.Extensions.Logging;
using System;

namespace Grand.Business.Tenants.Services.KeycloakUsers;

public class KeycloakUserService: IKeycloakUserService
{
    private readonly KeycloakClient _keycloakClient;
    private readonly KeycloakSettings _keycloakSettings;
    private readonly IAzureEncryptionService _azureEncryptionService;
    private readonly ILogger<KeycloakUserService> _logger;

    public KeycloakUserService(
        IKeycloakClientService keycloakService,
        KeycloakSettings keycloakSettings,
        IAzureEncryptionService azureEncryptionService,
        ILogger<KeycloakUserService> logger)
    {
        _keycloakClient = keycloakService.GetKeycloakClientAsync();
        _keycloakSettings = keycloakSettings;
        _azureEncryptionService = azureEncryptionService;
        _logger = logger;
    }

    // Kullanıcı Oluşturma
    public async Task<string> CreateUserAsync(string username, string email, string firstName, string lastName,
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

    public async Task<Group> GetGroupByPathAsync(string groupPath)
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

                var protocolDic = new Dictionary<string, ClientProtocolMapper>() {
                    {"subdomainname",new ClientProtocolMapper {
                        Name = "subdomainname",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "sub_domainname" },
                            { "claim.value", clientName },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    }},
                    {"dbconnection",new ClientProtocolMapper {
                        Name = "dbconnection",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "db_connection" },
                            { "claim.value", await EncryptData(dbConnectionString, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    }},
                    {"storeid",new ClientProtocolMapper {
                        Name = "storeid",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "store_id" },
                            { "claim.value", await EncryptData(storeId, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    }},
                    {"groupid",new ClientProtocolMapper {
                        Name = "groupid",
                        Protocol = "openid-connect",
                        ProtocolMapper = "oidc-hardcoded-claim-mapper",
                        Config = new Dictionary<string, string> {
                            { "claim.name", "group_id" },
                            { "claim.value", await EncryptData(groupId, clientName) },
                            { "access.token.claim", "true" },
                            { "id.token.claim", "true" }
                        }
                    }}
                };
                if(existingClient.ProtocolMappers == null)
                    existingClient.ProtocolMappers = new List<ClientProtocolMapper>();
                var existingProtocols = existingClient.ProtocolMappers.ToList();
                foreach (var protocol in protocolDic)
                {
                    if (existingProtocols.Any(x => x.Name == protocol.Key))
                    {
                        var existingProtocol = existingProtocols.First(x => x.Name == protocol.Key);
                        existingProtocol.Config = protocol.Value.Config;
                        
                    }
                    else
                    {
                        existingProtocols.Add(new ClientProtocolMapper {
                            Name = protocol.Value.Name,
                            Protocol = protocol.Value.Protocol,
                            ProtocolMapper = protocol.Value.ProtocolMapper,
                            Config = protocol.Value.Config
                        });
                    }

                    if (protocol.Value.Config["claim.name"] != "sub_domainname")
                    {
                        var chipperText = protocol.Value.Config["claim.value"];
                        var decryptedValue = await _azureEncryptionService.DecryptAsync(chipperText, clientName);
                    }
                }
                existingClient.ProtocolMappers = existingProtocols;

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
        return _azureEncryptionService.EncryptAsync(data, key);
    }
}
