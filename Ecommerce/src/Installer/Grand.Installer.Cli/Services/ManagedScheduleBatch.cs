using MongoDB.Bson;
using MongoDB.Driver;

namespace Grand.Installer.Cli.Services;

/// <summary>One sequential batch in one tenant database. Every persisted update is lease fenced.</summary>
public sealed class ManagedScheduleBatch(IMongoDatabase database, string storeId, int leaseSeconds = 90)
{
    private readonly string owner = Guid.NewGuid().ToString("N");
    private readonly IMongoCollection<BsonDocument> leases = database.GetCollection<BsonDocument>("PlatformScheduleLease");
    private readonly IMongoCollection<BsonDocument> tasks = database.GetCollection<BsonDocument>("ScheduleTask");
    private readonly SemaphoreSlim gate = new(1, 1);
    private BsonValue? active;

    private static BsonDocument Expired(string field) => new("$expr", new BsonDocument("$lte", new BsonArray {
        new BsonDocument("$ifNull", new BsonArray { "$" + field, new BsonDateTime(DateTime.UnixEpoch) }), "$$NOW" }));
    private static BsonDocument Live(string field) => new("$expr", new BsonDocument("$gt", new BsonArray { "$" + field, "$$NOW" }));
    private BsonDocument Expiry => new("$dateAdd", new BsonDocument { ["startDate"] = "$$NOW", ["unit"] = "second", ["amount"] = leaseSeconds });
    private static PipelineUpdateDefinition<BsonDocument> Set(BsonDocument values) => new(new[] { new BsonDocument("$set", values) });
    private FilterDefinition<BsonDocument> OwnedTask(BsonValue id) =>
        Builders<BsonDocument>.Filter.Eq("_id", id) & Builders<BsonDocument>.Filter.Eq("LeasedByMachineName", owner) & Live("LeasedUntilUtc");
    private FilterDefinition<BsonDocument> OwnedTenant =>
        Builders<BsonDocument>.Filter.Eq("_id", "scheduled-tasks") & Builders<BsonDocument>.Filter.Eq("Owner", owner) & Live("ExpiresUtc");

    public async Task<int> RunAsync(Func<BsonDocument, Task> execute, CancellationToken ct)
    {
        if (leaseSeconds < 3 || leaseSeconds > 600 || string.IsNullOrEmpty(storeId))
            throw new ArgumentException("Use a bounded lease and an owned store.");
        // MongoDB forbids $expr in an upsert predicate. Seed once without resetting an existing lease,
        // then claim it atomically using the server clock and a non-upsert update.
        try
        {
            await leases.UpdateOneAsync(new BsonDocument("_id", "scheduled-tasks"),
                new BsonDocument("$setOnInsert", new BsonDocument { ["Owner"] = BsonNull.Value, ["ExpiresUtc"] = new BsonDateTime(DateTime.UnixEpoch) }),
                new UpdateOptions { IsUpsert = true }, ct);
        }
        catch (MongoCommandException e) when (e.Code == 11000) { }
        catch (MongoWriteException e) when (e.WriteError.Category == ServerErrorCategory.DuplicateKey) { }
        var acquired = await leases.FindOneAndUpdateAsync(
            Builders<BsonDocument>.Filter.Eq("_id", "scheduled-tasks") & Expired("ExpiresUtc"),
            Set(new BsonDocument { ["Owner"] = owner, ["ExpiresUtc"] = Expiry }),
            new FindOneAndUpdateOptions<BsonDocument> { ReturnDocument = ReturnDocument.After }, ct);
        if (acquired == null) return 0;

        using var stop = CancellationTokenSource.CreateLinkedTokenSource(ct);
        var heartbeat = HeartbeatAsync(stop.Token);
        var batch = ExecuteAsync(execute, ct);
        // Execute has no cancellation contract in GrandNode. The CLI must exit on cancellation/lease loss;
        // never release a lock while an uncooperative task is still running in this process.
        try
        {
            var first = await Task.WhenAny(batch, heartbeat).WaitAsync(ct);
            if (first == heartbeat) { await heartbeat; throw new InvalidOperationException("Tenant task lease lost."); }
            var count = await batch;
            stop.Cancel();
            try { await heartbeat; } catch (OperationCanceledException) when (stop.IsCancellationRequested) { }
            await leases.DeleteOneAsync(OwnedTenant, CancellationToken.None);
            return count;
        }
        catch { stop.Cancel(); throw; }
    }

    private async Task HeartbeatAsync(CancellationToken ct)
    {
        while (true)
        {
            await Task.Delay(TimeSpan.FromSeconds(leaseSeconds / 3d), ct);
            await gate.WaitAsync(ct);
            try
            {
                using var deadline = CancellationTokenSource.CreateLinkedTokenSource(ct);
                deadline.CancelAfter(TimeSpan.FromSeconds(Math.Max(1, leaseSeconds / 3d)));
                if ((await leases.UpdateOneAsync(OwnedTenant, Set(new BsonDocument("ExpiresUtc", Expiry)), cancellationToken: deadline.Token)).MatchedCount != 1)
                    throw new InvalidOperationException("Tenant task lease lost.");
                if (active != null && (await tasks.UpdateOneAsync(OwnedTask(active), Set(new BsonDocument("LeasedUntilUtc", Expiry)), cancellationToken: deadline.Token)).MatchedCount != 1)
                    throw new InvalidOperationException("Scheduled task lease lost.");
            }
            finally { gate.Release(); }
        }
    }

    private async Task<int> ExecuteAsync(Func<BsonDocument, Task> execute, CancellationToken ct)
    {
        var candidates = await tasks.Find(new BsonDocument("Enabled", true)).Sort(new BsonDocument("_id", 1)).ToListAsync(ct);
        var count = 0;
        foreach (var candidate in candidates)
        {
            ct.ThrowIfCancellationRequested();
            var taskStore = candidate.GetValue("StoreId", BsonNull.Value);
            if (!taskStore.IsBsonNull && taskStore.AsString.Length != 0 && taskStore.AsString != storeId) continue;
            var due = new BsonDocument("$expr", new BsonDocument("$lte", new BsonArray {
                new BsonDocument("$dateAdd", new BsonDocument {
                    ["startDate"] = new BsonDocument("$ifNull", new BsonArray { "$LastStartUtc", new BsonDateTime(DateTime.UnixEpoch) }),
                    ["unit"] = "minute", ["amount"] = new BsonDocument("$max", new BsonArray { 1, "$TimeInterval" }) }), "$$NOW" }));
            // An interrupted attempt resumes after its lease expires, even when its normal interval is long.
            var recoverable = Builders<BsonDocument>.Filter.Type("LeasedByMachineName", BsonType.String) &
                Builders<BsonDocument>.Filter.Ne("LeasedByMachineName", "") & Expired("LeasedUntilUtc");
            BsonDocument? claimed;
            await gate.WaitAsync(ct);
            try
            {
                if (await leases.CountDocumentsAsync(OwnedTenant, cancellationToken: ct) != 1)
                    throw new InvalidOperationException("Tenant task lease lost.");
                var storeFilter = Builders<BsonDocument>.Filter.Or(new BsonDocument("StoreId", BsonNull.Value),
                    new BsonDocument("StoreId", ""), new BsonDocument("StoreId", storeId));
                claimed = await tasks.FindOneAndUpdateAsync(
                    Builders<BsonDocument>.Filter.Eq("_id", candidate["_id"]) & new BsonDocument("Enabled", true) & storeFilter & (due | recoverable) & Expired("LeasedUntilUtc"),
                    Set(new BsonDocument { ["LastStartUtc"] = "$$NOW", ["LeasedByMachineName"] = owner, ["LeasedUntilUtc"] = Expiry }),
                    new FindOneAndUpdateOptions<BsonDocument> { ReturnDocument = ReturnDocument.After }, ct);
                if (claimed != null) active = claimed["_id"];
            }
            finally { gate.Release(); }
            if (claimed == null) continue;
            var succeeded = true;
            try { await Task.Run(() => execute(claimed), ct); }
            catch (OperationCanceledException) when (ct.IsCancellationRequested) { throw; }
            catch (Exception error)
            {
                succeeded = false;
                // Only the error type is logged; provider payloads and credentials are deliberately excluded.
                Console.Error.WriteLine("Scheduled task failed: " + error.GetType().Name);
            }
            await gate.WaitAsync(ct);
            try
            {
                var changes = new BsonDocument { ["LeasedByMachineName"] = BsonNull.Value, ["LeasedUntilUtc"] = BsonNull.Value };
                if (succeeded) { changes["LastSuccessUtc"] = "$$NOW"; changes["LastNonSuccessEndUtc"] = BsonNull.Value; }
                else
                {
                    changes["LastNonSuccessEndUtc"] = "$$NOW";
                    changes["Enabled"] = new BsonDocument("$cond", new BsonArray { "$StopOnError", false, "$Enabled" });
                }
                if ((await tasks.UpdateOneAsync(OwnedTask(claimed["_id"]), Set(changes), cancellationToken: ct)).MatchedCount != 1)
                    throw new InvalidOperationException("Scheduled task lease lost.");
                active = null;
            }
            finally { gate.Release(); }
            count++;
            Console.WriteLine(succeeded ? "Scheduled task completed." : "Scheduled task failed; its retry policy was preserved.");
        }
        return count;
    }
}
