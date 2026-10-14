namespace Authentication.Keycloak.MultitenantTasks;

/// <summary>
/// Represents the configuration settings for connecting to a Redis server.
/// </summary>
public class RedisConfiguration
{
    /// <summary>
    /// Gets or sets the connection string used to connect to the Redis server.
    /// </summary>
    public string ConnectionString { get; set; }

    /// <summary>
    /// Gets or sets the name of the channel used for Redis pub/sub messaging.
    /// </summary>
    public string Channel { get; set; }

    /// <summary>
    /// Gets or sets the interval, in milliseconds, to wait before attempting to reconnect to the Redis server.
    /// Default value is 5000 milliseconds (5 seconds).
    /// </summary>
    public int ReconnectInterval { get; set; } = 5000;

    /// <summary>
    /// Gets or sets the maximum number of retry attempts for reconnecting to the Redis server.
    /// Default value is 3.
    /// </summary>
    public int MaxRetryAttempts { get; set; } = 3;
}
