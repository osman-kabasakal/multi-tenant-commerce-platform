using System.Security.Cryptography;
using System.Text;
using MongoDB.Bson;
using MongoDB.Driver;

namespace Grand.Installer.Cli.Services;

public static class ManagedClientCacheTaskRegistration
{
    public const string Type = "Grand.Business.Marketing.Services.BackgroundServices.ClientCacheNotificationTask, Grand.Business.Marketing";
    public static async Task EnsureAsync(IMongoDatabase database, string store)
    {
        if (string.IsNullOrWhiteSpace(store)) throw new InvalidOperationException("Register a client cache task only for an owned store.");
        var tasks = database.GetCollection<BsonDocument>("ScheduleTask");
        var owned = Builders<BsonDocument>.Filter.Eq("Type", Type) & Builders<BsonDocument>.Filter.Or(
            new BsonDocument("StoreId", store), new BsonDocument("StoreId", ""), new BsonDocument("StoreId", BsonNull.Value));
        if (await tasks.CountDocumentsAsync(owned) > 0) return;
        var key = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(store + ":" + Type)))[..24].ToLowerInvariant();
        try
        {
            await tasks.UpdateOneAsync(new BsonDocument("_id", key), new BsonDocument("$setOnInsert", new BsonDocument {
                ["Name"] = "Mobil önbellek değişikliklerini bildir", ["Type"] = Type, ["StoreId"] = store,
                ["Enabled"] = true, ["TimeInterval"] = 1, ["StopOnError"] = false
            }), new UpdateOptions { IsUpsert = true });
        }
        catch (MongoCommandException error) when (error.Code == 11000) { }
        catch (MongoWriteException error) when (error.WriteError.Category == ServerErrorCategory.DuplicateKey) { }
    }
}
