using Keycloak.Net.Models.Groups;
using Keycloak.Net.Models.Users;

namespace Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;

public interface IKeycloakUserService
{
    /// <summary>
    /// Creates a new user in Keycloak.
    /// </summary>
    /// <param name="username">The username of the new user.</param>
    /// <param name="email">The email address of the new user.</param>
    /// <param name="firstName">The first name of the new user.</param>
    /// <param name="lastName">The last name of the new user.</param>
    /// <param name="password">The password for the new user.</param>
    /// <param name="storeId">The store ID associated with the new user.</param>
    /// <returns>The ID of the created user, or null if creation failed.</returns>
    Task<string> CreateUserAsync(string username, string email, string firstName, string lastName, string password, string storeId);

    /// <summary>
    /// Deletes a user from Keycloak.
    /// </summary>
    /// <param name="userId">The ID of the user to delete.</param>
    /// <returns>True if the user was successfully deleted, otherwise false.</returns>
    Task<bool> DeleteUserAsync(string userId);

    /// <summary>
    /// Assigns a role to a user in Keycloak.
    /// </summary>
    /// <param name="userId">The ID of the user.</param>
    /// <param name="roleName">The name of the role to assign.</param>
    /// <returns>True if the role was successfully assigned, otherwise false.</returns>
    Task<bool> AssignRoleToUserAsync(string userId, string roleName);

    /// <summary>
    /// Removes a role from a user in Keycloak.
    /// </summary>
    /// <param name="userId">The ID of the user.</param>
    /// <param name="roleName">The name of the role to remove.</param>
    /// <returns>True if the role was successfully removed, otherwise false.</returns>
    Task<bool> RemoveRoleFromUserAsync(string userId, string roleName);

    /// <summary>
    /// Retrieves a user from Keycloak.
    /// </summary>
    /// <param name="userId">The ID of the user to retrieve.</param>
    /// <returns>The user object, or null if the user was not found.</returns>
    Task<User> GetUserAsync(string userId);

    /// <summary>
    /// Retrieves a group from Keycloak by its path.
    /// </summary>
    /// <param name="groupPath">The path of the group to retrieve.</param>
    /// <returns>The group object, or null if the group was not found.</returns>
    Task<Group> GetGroupByPathAsync(string groupPath);

    /// <summary>
    /// Creates a group in Keycloak if it does not already exist.
    /// </summary>
    /// <param name="groupName">The name of the group to create.</param>
    /// <param name="storeId">The store ID associated with the group.</param>
    /// <param name="storeName">The store name associated with the group.</param>
    /// <param name="storeMongoConnectionString">The MongoDB connection string for the store.</param>
    /// <returns>The created or existing group object.</returns>
    Task<Group> CreateGroupIfNotExistsAsync(string groupName, string storeId, string storeName, string storeMongoConnectionString);

    /// <summary>
    /// Assigns a user to a group in Keycloak.
    /// </summary>
    /// <param name="ownerEmail">The email of the user to assign to the group.</param>
    /// <param name="groupId">The ID of the group to assign the user to.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    Task AssignUserToGroupAsync(string ownerEmail, string groupId);

    Task<(string ClientId, string ClientSecret)> CreateClientWithMappersAsync(
        string clientName,
        string dbConnectionString,
        string storeId,
        string groupId);
}
