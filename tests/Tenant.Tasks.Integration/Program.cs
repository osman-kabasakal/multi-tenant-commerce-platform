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
// Real initializer receipts are sufficient before and after an optional domain activation.
var receipts = Path.Combine(Path.GetDirectoryName(Path.GetFullPath(args[0]))!, "receipts-" + Guid.NewGuid().ToString("N"));
Directory.CreateDirectory(receipts);
try
{
    var tenant = new string('a', 32); var slug = "fixture-shop"; var output = Path.Combine(receipts, slug + ".json");
    var metadata = new { profile = "Portable", tenantId = tenant, slug, storeId = "store-a" };
    await File.WriteAllTextAsync(output, System.Text.Json.JsonSerializer.Serialize(metadata));
    foreach (var task in ManagedTenantInitialization.Tasks)
        await File.WriteAllTextAsync(Path.Combine(receipts, slug + "." + task + ".json"),
            System.Text.Json.JsonSerializer.Serialize(new { metadata.profile, metadata.tenantId, metadata.slug, metadata.storeId, version = 1, task }));
    await ManagedTenantInitialization.VerifyAsync(output, tenant, slug, "store-a");
    Check(true, "a completed tenant initializer permits scheduling without an optional domain receipt");
    await File.WriteAllTextAsync(Path.Combine(receipts, slug + ".tenant-domain." + Guid.NewGuid().ToString("N") + ".json"), "{}");
    await ManagedTenantInitialization.VerifyAsync(output, tenant, slug, "store-a");
    Check(true, "a later identity-specific domain receipt does not block ordinary scheduling");
    var rejectedForeign = false;
    try { await ManagedTenantInitialization.VerifyAsync(output, tenant, slug, "store-b"); }
    catch (InvalidOperationException) { rejectedForeign = true; }
    Check(rejectedForeign, "initializer receipts cannot authorize another store");
    File.Delete(Path.Combine(receipts, slug + ".tenant-settings.json"));
    var rejectedIncomplete = false;
    try { await ManagedTenantInitialization.VerifyAsync(output, tenant, slug, "store-a"); }
    catch (FileNotFoundException) { rejectedIncomplete = true; }
    Check(rejectedIncomplete, "a missing mandatory initializer still blocks scheduling");
}
finally { Directory.Delete(receipts, true); }
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

await Reset(TaskRow("custom-existing", false));
await Task.WhenAll(Enumerable.Range(0, 10).Select(_ => ManagedClientCacheTaskRegistration.EnsureAsync(database, "store-a")));
var cacheTask = await tasks.Find(new BsonDocument("Type", ManagedClientCacheTaskRegistration.Type)).SingleAsync();
Check(cacheTask["StoreId"] == "store-a" && cacheTask["Enabled"].AsBoolean && cacheTask["TimeInterval"].AsInt32 == 1 && !cacheTask["StopOnError"].AsBoolean,
    "parallel scheduler starts register exactly one owned client cache task");
await tasks.UpdateOneAsync(new BsonDocument("_id", cacheTask["_id"]), Builders<BsonDocument>.Update.Set("Enabled", false).Set("TimeInterval", 42));
await ManagedClientCacheTaskRegistration.EnsureAsync(database, "store-a");
cacheTask = await Row(cacheTask["_id"].AsString);
Check(!cacheTask["Enabled"].AsBoolean && cacheTask["TimeInterval"].AsInt32 == 42 && !(await Row("custom-existing"))["Enabled"].AsBoolean,
    "automatic task registration preserves administrator choices and existing task rows");
await ManagedClientCacheTaskRegistration.EnsureAsync(database, "store-b");
Check(await tasks.CountDocumentsAsync(new BsonDocument("Type", ManagedClientCacheTaskRegistration.Type)) == 2 &&
    (await tasks.Find(new BsonDocument { ["Type"] = ManagedClientCacheTaskRegistration.Type, ["StoreId"] = "store-b" }).SingleAsync())["_id"] != cacheTask["_id"],
    "a foreign store task cannot suppress registration for the owned store");
var existingGlobal = TaskRow("legacy-cache", false); existingGlobal["Type"] = ManagedClientCacheTaskRegistration.Type; existingGlobal["StoreId"] = "";
await Reset(existingGlobal);
await ManagedClientCacheTaskRegistration.EnsureAsync(database, "store-a");
Check(await tasks.CountDocumentsAsync(FilterDefinition<BsonDocument>.Empty) == 1 && !(await Row("legacy-cache"))["Enabled"].AsBoolean,
    "an existing tenant-wide disabled task is retained without creating a replacement");

var originalAdc = Environment.GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS");
var originalAuthority = Environment.GetEnvironmentVariable("GOOGLE_PROVISIONER_FIXTURE");
try
{
    Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "/private/synthetic-broad-provisioner.json");
    Environment.SetEnvironmentVariable("GOOGLE_PROVISIONER_FIXTURE", "must-not-inherit");
    var childOptions = new TenantScheduleOptions { InstallerPath = "/private/installer.dll", WorkingDirectory = "/private/work",
        CommerceConfigPath = "/private/child.json", StoreBaseUrl = "https://shops.example.test", NotificationCredentialsFile = "/private/limited-sender.json" };
    var child = TenantScheduleWorker.ChildStartInfo(childOptions, "a".PadLeft(32, 'a'), "fixture-shop", "/private/metadata.json", "synthetic-tenant-db");
    Check(child.Environment["GOOGLE_APPLICATION_CREDENTIALS"] == "/private/limited-sender.json" && !child.Environment.ContainsKey("GOOGLE_PROVISIONER_FIXTURE") &&
        child.Environment["PlatformConfiguration__ConfigPath"] == "/private/child.json" && child.ArgumentList.Count == 1 && child.ArgumentList[0] == "/private/installer.dll",
        "the actual child launcher forwards only the explicit sender identity and keeps credentials out of command arguments");
    var disabled = TenantScheduleWorker.ChildStartInfo(new TenantScheduleOptions { InstallerPath = "/private/installer.dll", WorkingDirectory = "/private/work",
        CommerceConfigPath = "/private/child.json", StoreBaseUrl = "https://shops.example.test" }, "a".PadLeft(32, 'a'), "fixture-shop", "/private/metadata.json", "synthetic-tenant-db");
    Check(!disabled.Environment.ContainsKey("GOOGLE_APPLICATION_CREDENTIALS"), "a task child without a sender cannot inherit its parent's broad Google credential");
}
finally
{
    Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", originalAdc);
    Environment.SetEnvironmentVariable("GOOGLE_PROVISIONER_FIXTURE", originalAuthority);
}

var rejected = false;
try { new TenantScheduleOptions { Enabled = false }.Validate(); } catch (InvalidOperationException) { rejected = true; }
Check(rejected, "schedule host cannot start without explicit opt in");
Console.WriteLine("PASS: " + checks + " tenant schedule integration checks against real MongoDB; no external messages sent.");
