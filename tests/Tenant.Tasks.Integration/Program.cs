using Grand.Installer.Cli.Services;
using MongoDB.Bson;
using MongoDB.Driver;
using TenantManager.Provisioning;

if (args.Length != 1) throw new ArgumentException("Supply a private file containing the isolated test database URI.");
var url = new MongoUrl((await File.ReadAllTextAsync(args[0])).Trim());
if (url.DatabaseName == null || !url.DatabaseName.StartsWith("platform_schedule_test_", StringComparison.Ordinal))
    throw new InvalidOperationException("Only an explicitly isolated schedule test database is permitted.");
var settings = MongoClientSettings.FromUrl(url);
settings.ServerSelectionTimeout = settings.ConnectTimeout = settings.SocketTimeout = TimeSpan.FromSeconds(5);
var database = new MongoClient(settings).GetDatabase(url.DatabaseName);
var tasks = database.GetCollection<BsonDocument>("ScheduleTask");
var leases = database.GetCollection<BsonDocument>("PlatformScheduleLease");
var checks = 0;
void Check(bool condition, string name) { if (!condition) throw new InvalidOperationException("FAILED: " + name); checks++; Console.WriteLine("PASS: " + name); }
BsonDocument TaskRow(string id, bool enabled = true) => new() {
    ["_id"] = id, ["Enabled"] = enabled, ["Type"] = "Fixture", ["StoreId"] = "store-a", ["TimeInterval"] = 1, ["StopOnError"] = false,
    ["LastStartUtc"] = BsonNull.Value, ["LastSuccessUtc"] = BsonNull.Value, ["LastNonSuccessEndUtc"] = BsonNull.Value,
    ["LeasedByMachineName"] = BsonNull.Value, ["LeasedUntilUtc"] = BsonNull.Value };
async Task Reset(params BsonDocument[] rows) {
    await tasks.DeleteManyAsync(FilterDefinition<BsonDocument>.Empty); await leases.DeleteManyAsync(FilterDefinition<BsonDocument>.Empty);
    if (rows.Length > 0) await tasks.InsertManyAsync(rows);
}
Task<BsonDocument> Row(string id) => tasks.Find(new BsonDocument("_id", id)).SingleAsync();
var future = TaskRow("future"); future["LastStartUtc"] = DateTime.UtcNow.AddHours(1);
var foreign = TaskRow("foreign"); foreign["StoreId"] = "store-b";
var leased = TaskRow("leased"); leased["LeasedUntilUtc"] = DateTime.UtcNow.AddHours(1); leased["LeasedByMachineName"] = "another-host";
await Reset(TaskRow("b"), TaskRow("a"), TaskRow("disabled", false), future, foreign, leased);
var order = new List<string>();
var count = await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(async row => { order.Add(row["_id"].AsString); await Task.Delay(30); }, default);
Check(count == 2 && order.SequenceEqual(new[] { "a", "b" }), "due enabled tasks execute sequentially in stable order");
Check((await Row("a"))["LastSuccessUtc"].IsValidDateTime && (await Row("b"))["LastSuccessUtc"].IsValidDateTime, "successful task timestamps persist");
Check((await Row("disabled"))["LastStartUtc"].IsBsonNull && (await Row("future"))["LastSuccessUtc"].IsBsonNull &&
    (await Row("foreign"))["LastStartUtc"].IsBsonNull && (await Row("leased"))["LastStartUtc"].IsBsonNull, "disabled future foreign-store and actively leased tasks stay untouched");
Check(await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(_ => throw new Exception("must not execute"), default) == 0, "restart does not rerun tasks before their configured interval");

var stop = TaskRow("stop"); stop["StopOnError"] = true;
await Reset(stop, TaskRow("retry"));
await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(_ => throw new Exception("fixture-provider-secret"), default);
Check(!(await Row("stop"))["Enabled"].AsBoolean && (await Row("stop"))["LastNonSuccessEndUtc"].IsValidDateTime, "StopOnError disables a failing task");
Check((await Row("retry"))["Enabled"].AsBoolean && (await Row("retry"))["LastNonSuccessEndUtc"].IsValidDateTime &&
    !(await Row("retry")).ToJson().Contains("fixture-provider-secret"), "retry policy survives without persisting provider exception payloads");

await Reset(TaskRow("edited"));
await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(async row => {
    await tasks.UpdateOneAsync(new BsonDocument("_id", "edited"), Builders<BsonDocument>.Update.Set("Enabled", false).Set("TimeInterval", 42));
    throw new Exception("fixture failure");
}, default);
Check(!(await Row("edited"))["Enabled"].AsBoolean && (await Row("edited"))["TimeInterval"].AsInt32 == 42, "task completion preserves concurrent administrator edits");

await Reset(TaskRow("long"));
var started = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
var finish = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
var first = new ManagedScheduleBatch(database, "store-a", 3).RunAsync(async _ => { started.SetResult(); await finish.Task; }, default);
await started.Task.WaitAsync(TimeSpan.FromSeconds(10));
await Task.Delay(4100);
var secondExecutions = 0;
var second = await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(_ => { secondExecutions++; return Task.CompletedTask; }, default);
Check(second == 0 && secondExecutions == 0 && !first.IsCompleted, "heartbeat prevents a second worker claiming a long running tenant batch");
finish.SetResult(); await first;
Check((await Row("long"))["LastSuccessUtc"].IsValidDateTime, "the renewing worker can finish after its original lease duration");

await Reset(TaskRow("lost"));
var lostStarted = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
var lostFinish = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
var stale = new ManagedScheduleBatch(database, "store-a", 3).RunAsync(async _ => { lostStarted.SetResult(); await lostFinish.Task; }, default);
await lostStarted.Task.WaitAsync(TimeSpan.FromSeconds(10));
await leases.UpdateOneAsync(new BsonDocument("_id", "scheduled-tasks"), Builders<BsonDocument>.Update.Set("Owner", "replacement"));
var stopped = false;
try { await stale.WaitAsync(TimeSpan.FromSeconds(5)); } catch (InvalidOperationException) { stopped = true; }
Check(stopped && (await Row("lost"))["LastSuccessUtc"].IsBsonNull, "lease loss stops the batch before publishing success");
await tasks.UpdateOneAsync(new BsonDocument("_id", "lost"), Builders<BsonDocument>.Update.Set("LeasedByMachineName", "replacement").Set("LeasedUntilUtc", DateTime.UtcNow.AddMinutes(-1)));
await leases.UpdateOneAsync(new BsonDocument("_id", "scheduled-tasks"), Builders<BsonDocument>.Update.Set("ExpiresUtc", DateTime.UtcNow.AddMinutes(-1)));
lostFinish.SetResult(); await Task.Delay(100);
Check((await Row("lost"))["LeasedByMachineName"].AsString == "replacement" && (await Row("lost"))["LastSuccessUtc"].IsBsonNull, "stale callback cannot overwrite replacement worker metadata");
Check(await new ManagedScheduleBatch(database, "store-a", 3).RunAsync(_ => Task.CompletedTask, default) == 1, "expired tenant and task leases recover immediately without waiting the normal interval");

var rejected = false;
try { new TenantScheduleOptions { Enabled = false }.Validate(); } catch (InvalidOperationException) { rejected = true; }
Check(rejected, "schedule host cannot start without explicit opt in");
Console.WriteLine("PASS: " + checks + " tenant schedule integration checks against real MongoDB; no external messages sent.");
