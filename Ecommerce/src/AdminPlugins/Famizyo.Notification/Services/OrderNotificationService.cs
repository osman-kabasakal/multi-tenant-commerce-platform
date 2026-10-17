using Famizyo.Notification.Models;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Stores;
using Grand.Infrastructure;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using System.Security.Cryptography;
using System.Text;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

namespace Famizyo.Notification.Services;

/// <summary>
/// Service for managing order notifications
/// </summary>
public class OrderNotificationService : IOrderNotificationService
{
    private readonly IRepository<FamizyoOrderNotification> _orderNotificationRepository;
    private readonly IConfiguration _configuration;
    private readonly IWorkContext _workContext;
    private bool Managed => _configuration.GetValue<bool>("Provisioning:ManagedRuntime");
    
    public OrderNotificationService(IRepository<FamizyoOrderNotification> orderNotificationRepository, IConfiguration configuration, IWorkContext workContext)
    {
        _orderNotificationRepository = orderNotificationRepository;
        _configuration = configuration;
        _workContext = workContext;
    }
    
    /// <summary>
    /// Creates a new order notification
    /// </summary>
    public async Task<FamizyoOrderNotification> CreateOrderNotificationAsync(string orderId, string storeId)
    {
        if (Managed)
        {
            var repository = await OwnedRepository(storeId);
            var order = await repository.Database.GetCollection<BsonDocument>("Order").Find(new BsonDocument {
                ["_id"] = orderId, ["StoreId"] = storeId }).SingleOrDefaultAsync();
            if (order == null) throw new InvalidOperationException("Record a notification only for an existing owned order.");
            return await EnsureNotification(repository, order);
        }

        var notification = new FamizyoOrderNotification
        {
            OrderId = orderId,
            StoreId = storeId,
            CreatedOnUtc = DateTime.UtcNow,
            SendCount = 1,
            LastSentOnUtc = DateTime.UtcNow
        };
        
        await _orderNotificationRepository.InsertAsync(notification);
        return notification;
    }
    
    /// <summary>
    /// Records that a notification has been viewed
    /// </summary>
    public async Task MarkAsViewedAsync(string notificationId, string customerId)
    {
        if (Managed)
        {
            var store = _workContext.CurrentStore?.Id ?? "";
            var repository = await OwnedRepository(store);
            await repository.Collection.UpdateOneAsync(x => x.Id == notificationId && x.StoreId == store,
                Builders<FamizyoOrderNotification>.Update.Set(x => x.ViewedByCustomerId, customerId).Set(x => x.ViewedOnUtc, DateTime.UtcNow));
            return;
        }

        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.ViewedByCustomerId = customerId;
        notification.ViewedOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }
    
    /// <summary>
    /// Records that a notification has been interacted with (clicked)
    /// </summary>
    public async Task MarkAsInteractedAsync(string notificationId, string customerId)
    {
        if (Managed)
        {
            var store = _workContext.CurrentStore?.Id ?? "";
            var repository = await OwnedRepository(store);
            await repository.Collection.UpdateOneAsync(x => x.Id == notificationId && x.StoreId == store,
                Builders<FamizyoOrderNotification>.Update.Set(x => x.InteractedByCustomerId, customerId).Set(x => x.InteractedOnUtc, DateTime.UtcNow));
            return;
        }

        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.InteractedByCustomerId = customerId;
        notification.InteractedOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }
    
    /// <summary>
    /// Gets a notification by order ID
    /// </summary>
    public async Task<FamizyoOrderNotification> GetNotificationByOrderIdAsync(string orderId)
    {
        if (Managed)
        {
            var store = _workContext.CurrentStore?.Id ?? "";
            var repository = await OwnedRepository(store);
            return await repository.Collection.Find(x => x.OrderId == orderId && x.StoreId == store).FirstOrDefaultAsync();
        }

        return await _orderNotificationRepository.Table
            .FirstOrDefaultAsync(n => n.OrderId == orderId);
    }
    
    /// <summary>
    /// Gets all notifications that need to be resent (unviewed or non-interacted)
    /// </summary>
    public async Task<IList<FamizyoOrderNotification>> GetNotificationsToResendAsync(string storeId)
    {
        if (Managed) await ReconcileOrders(storeId);

        var notifications = await _orderNotificationRepository.Table
            .Where(n => n.StoreId == storeId && 
                       (n.ViewedOnUtc == null || n.InteractedOnUtc == null))
            .OrderByDescending(n => n.CreatedOnUtc)
            .ToListAsync();
            
        return notifications;
    }
    
    /// <summary>
    /// Increments the send count for a notification
    /// </summary>
    public async Task IncrementSendCountAsync(string notificationId)
    {
        if (Managed)
        {
            var store = _workContext.CurrentStore?.Id ?? "";
            var repository = await OwnedRepository(store);
            await repository.Collection.UpdateOneAsync(x => x.Id == notificationId && x.StoreId == store,
                Builders<FamizyoOrderNotification>.Update.Inc(x => x.SendCount, 1).Set(x => x.LastSentOnUtc, DateTime.UtcNow));
            return;
        }

        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.SendCount++;
        notification.LastSentOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }

    private async Task<MongoRepository<FamizyoOrderNotification>> OwnedRepository(string storeId)
    {
        if (string.IsNullOrEmpty(storeId) || _workContext.CurrentStore?.Id != storeId ||
            _orderNotificationRepository is not MongoRepository<FamizyoOrderNotification> repository)
            throw new InvalidOperationException("Managed notifications require the current owned Mongo store.");
        var database = repository.Database.DatabaseNamespace.DatabaseName;
        if (!database.StartsWith("tenant_", StringComparison.Ordinal) ||
            !Guid.TryParseExact(database[7..], "N", out var id) || id == Guid.Empty ||
            id.ToString("N") != database[7..] ||
            await repository.Database.GetCollection<Store>(nameof(Store)).CountDocumentsAsync(x => x.Id == storeId) != 1)
            throw new InvalidOperationException("A foreign notification database or store was rejected.");
        return repository;
    }

    private static async Task<FamizyoOrderNotification> EnsureNotification(MongoRepository<FamizyoOrderNotification> repository, BsonDocument order)
    {
        var orderId = order["_id"].AsString;
        var store = order["StoreId"].AsString;
        var id = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes("managed-order-notification-v1|" + store + "|" + orderId)))[..32].ToLowerInvariant();
        var created = order.TryGetValue("CreatedOnUtc", out var date) && date.IsValidDateTime ? date.ToUniversalTime() : DateTime.UtcNow;
        var filter = Builders<FamizyoOrderNotification>.Filter.Eq(x => x.OrderId, orderId) & Builders<FamizyoOrderNotification>.Filter.Eq(x => x.StoreId, store);
        var update = Builders<FamizyoOrderNotification>.Update.SetOnInsert(x => x.Id, id).SetOnInsert(x => x.OrderId, orderId)
            .SetOnInsert(x => x.StoreId, store).SetOnInsert(x => x.CreatedOnUtc, created).SetOnInsert(x => x.SendCount, 0)
            .SetOnInsert(x => x.LastSentOnUtc, (DateTime?)null);
        try
        {
            return await repository.Collection.FindOneAndUpdateAsync(filter, update,
                new FindOneAndUpdateOptions<FamizyoOrderNotification> { IsUpsert = true, ReturnDocument = ReturnDocument.After });
        }
        catch (MongoCommandException error) when (error.Code == 11000)
        {
            // Concurrent upserts use the same deterministic id. An existing legacy id is retained by the filter.
            return await repository.Collection.Find(filter).FirstAsync();
        }
        catch (MongoWriteException error) when (error.WriteError.Category == ServerErrorCategory.DuplicateKey)
        {
            return await repository.Collection.Find(filter).FirstAsync();
        }
    }

    private async Task ReconcileOrders(string storeId)
    {
        var repository = await OwnedRepository(storeId);
        async Task<bool> HasOrderIndex()
        {
            using var cursor = await repository.Collection.Indexes.ListAsync();
            return (await cursor.ToListAsync()).Any(index => index["key"].AsBsonDocument.GetElement(0).Name == nameof(FamizyoOrderNotification.OrderId));
        }
        if (!await HasOrderIndex())
        {
            try
            {
                await repository.Collection.Indexes.CreateOneAsync(new CreateIndexModel<FamizyoOrderNotification>(
                    Builders<FamizyoOrderNotification>.IndexKeys.Ascending(x => x.OrderId).Ascending(x => x.StoreId),
                    new CreateIndexOptions { Name = "managed_notification_order_store_v1" }));
            }
            catch (MongoCommandException error) when (error.Code is 85 or 86)
            {
                if (!await HasOrderIndex()) throw;
            }
        }
        // The order is the durable fact: a missing projection is recovered without Redis/Keycloak discovery.
        var lookup = new BsonDocument("$lookup", new BsonDocument {
            ["from"] = nameof(FamizyoOrderNotification), ["let"] = new BsonDocument("order", "$_id"),
            ["pipeline"] = new BsonArray { new BsonDocument("$match", new BsonDocument("$expr", new BsonDocument("$and", new BsonArray {
                new BsonDocument("$eq", new BsonArray { "$OrderId", "$$order" }),
                new BsonDocument("$eq", new BsonArray { "$StoreId", storeId }) }))) }, ["as"] = "notifications" });
        BsonDocument[] pipeline = [
            new("$match", new BsonDocument("StoreId", storeId)),
            new("$sort", new BsonDocument { ["CreatedOnUtc"] = -1, ["_id"] = 1 }), lookup,
            new("$match", new BsonDocument("notifications.0", new BsonDocument("$exists", false))),
            new("$limit", 100), new("$project", new BsonDocument { ["_id"] = 1, ["StoreId"] = 1, ["CreatedOnUtc"] = 1 }) ];
        var orders = await repository.Database.GetCollection<BsonDocument>("Order").Aggregate<BsonDocument>(pipeline).ToListAsync();
        foreach (var order in orders) await EnsureNotification(repository, order);
    }

}