using MongoDB.Bson;
using MongoDB.Driver;
using SaasManager.Domain.Entities.Operations;

namespace SaasManager.Domain.Common;

public static class MongoConnectionMapper
{
    public static DatabaseConfig MapFromConnectionString(string connectionString)
    {
        try
        {
            // Atlas connection string örneği:
            // mongodb://localhost:27017/commerce_demo
            // veya
            // mongodb://localhost:27017/commerce_demo,cluster0-shard-00-01.xxxxx.mongodb.net:27017,cluster0-shard-00-02.xxxxx.mongodb.net:27017/database?ssl=true&replicaSet=atlas-xxxxx-shard-0&authSource=admin&retryWrites=true&w=majority
            
            var url = new MongoUrl(connectionString);
            
            string host;
            int port;

            if (connectionString.StartsWith("mongodb+srv://"))
            {
                // SRV format için
                host = url.Server.Host;
                port = 27017; // SRV için default port
            }
            else
            {
                // Standard format için
                // İlk host ve port'u al (primary node)
                host = url.Servers.First().Host;
                port = url.Servers.First().Port;
            }

            // Host'tan cluster adını çıkar
            string instanceName = ExtractClusterName(host);

            var config = new DatabaseConfig(
                businessId: Guid.Empty, // BusinessId dışarıdan set edilmeli
                instanceName: instanceName,
                host: host,
                port: port,
                databaseName: url.DatabaseName,
                username: url.Username,
                encryptedPassword: url.Password); // Password encryption yapılmalı

            // Connection string'i de sakla
            config.SetConnectionString(connectionString);
            
            return config;
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException("Invalid MongoDB Atlas connection string", ex);
        }
    }

    private static string ExtractClusterName(string host)
    {
        // cluster0.xxxxx.mongodb.net -> cluster0
        // cluster0-shard-00-00.xxxxx.mongodb.net -> cluster0
        var parts = host.Split('.');
        if (parts.Length > 0)
        {
            var clusterPart = parts[0];
            if (clusterPart.Contains("-shard-"))
            {
                return clusterPart.Split('-')[0];
            }
            return clusterPart;
        }
        return $"mongodb-{Guid.NewGuid():N}";
    }

    public static string MapToConnectionString(DatabaseConfig config)
    {
        // Eğer mevcut connection string varsa, sadece credentials'ları güncelle
        if (!string.IsNullOrEmpty(config.ConnectionString))
        {
            return UpdateConnectionCredentials(
                config.ConnectionString,
                config.Username,
                config.EncryptedPassword // Decrypt edilmeli
            );
        }

        // Yeni connection string oluştur
        var builder = new MongoUrlBuilder
        {
            Server = new MongoServerAddress(config.Host, config.Port),
            DatabaseName = config.DatabaseName,
            Username = config.Username,
            Password = config.EncryptedPassword, // Decrypt edilmeli
            UseTls = true,
            RetryWrites = true,
            W = WriteConcern.WValue.Parse("majority")
        };

        if (config.Host.EndsWith(".mongodb.net"))
        {
            builder.AuthenticationSource = "admin";
            builder.ReplicaSetName = $"atlas-{ExtractClusterName(config.Host).ToLower()}-shard-0";
        }

        return builder.ToMongoUrl().ToString();
    }

    private static string UpdateConnectionCredentials(string connectionString, string username, string password)
    {
        var url = new MongoUrl(connectionString);
        var builder = new MongoUrlBuilder(connectionString)
        {
            Username = username,
            Password = password
        };
        return builder.ToMongoUrl().ToString();
    }

    public static bool ValidateConnectionString(string connectionString)
    {
        try
        {
            var url = new MongoUrl(connectionString);

            // Atlas connection string kontrolleri
            if (connectionString.StartsWith("mongodb+srv://"))
            {
                if (!url.Server.Host.EndsWith(".mongodb.net"))
                    return false;
            }
            else
            {
                // Standard format için tüm sunucuları kontrol et
                if (!url.Servers.Any(s => s.Host.EndsWith(".mongodb.net")))
                    return false;
            }

            // Temel validasyonlar
            if (string.IsNullOrEmpty(url.DatabaseName)) return false;
            if (string.IsNullOrEmpty(url.Username)) return false;
            if (string.IsNullOrEmpty(url.Password)) return false;

            return true;
        }
        catch
        {
            return false;
        }
    }

    public static async Task<bool> TestConnection(DatabaseConfig config)
    {
        var connectionString = MapToConnectionString(config);
        var settings = MongoClientSettings.FromUrl(new MongoUrl(connectionString));
        
        // SSL/TLS ayarları
        settings.SslSettings = new SslSettings 
        { 
            EnabledSslProtocols = System.Security.Authentication.SslProtocols.Tls12 
        };
        
        var client = new MongoClient(settings);

        try
        {
            // Ping komutu ile bağlantıyı test et
            await client.GetDatabase(config.DatabaseName)
                .RunCommandAsync<BsonDocument>(new BsonDocument("ping", 1));

            config.UpdateLastConnectionTest(true);
            return true;
        }
        catch
        {
            config.UpdateLastConnectionTest(false);
            return false;
        }
    }
}
