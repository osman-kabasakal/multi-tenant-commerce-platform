using Authentication.Keycloak.Models;
using System.Text.Json.Serialization;

namespace Authentication.Keycloak.MultitenantTasks;

/// <summary>
/// Represents a basic response model for authentication operations.
/// </summary>
public class BasicResponseModel
{
    /// <summary>
    /// Gets or sets a value indicating whether the operation was successful.
    /// </summary>
    [JsonPropertyName("isSuccess")]
    public bool IsSuccess { get; set; }

    /// <summary>
    /// Gets or sets the message associated with the tenant status.
    /// </summary>
    [JsonPropertyName("message")]
    public TenantStatusMessage Message { get; set; }
}