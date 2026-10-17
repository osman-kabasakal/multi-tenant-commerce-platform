using System.Diagnostics;
using System.Reflection;
using Famizyo.Notification.Models;
using Famizyo.Notification.Services;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Localization;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using Grand.Domain.Vendors;
using Grand.Infrastructure;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;

if (args.Length == 0) throw new ArgumentException("Supply the private isolated order-notification fixture configuration.");
var configuration = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[0])).Build();
if (configuration["Fixture:Purpose"] != "isolated-order-notifications-v1") throw new InvalidOperationException("Only the explicit isolated fixture is permitted.");
var settings = MongoClientSettings.FromConnectionString(configuration["Fixture:Connection"]);
settings.ServerSelectionTimeout = settings.ConnectTimeout = settings.SocketTimeout = TimeSpan.FromSeconds(5);
var client = new MongoClient(settings);
var aName = configuration["Fixture:DatabaseA"]!; var bName = configuration["Fixture:DatabaseB"]!;
foreach (var name in new[] { aName, bName })
    if (!name.StartsWith("tenant_", StringComparison.Ordinal) || !Guid.TryParseExact(name[7..], "N", out var id) || id == Guid.Empty)
        throw new InvalidOperationException("Choose the two owned canonical fixture databases.");
var a = client.GetDatabase(aName); var b = client.GetDatabase(bName);
var contextA = new Context("store-a"); var contextB = new Context("store-b");
var serviceA = new OrderNotificationService(new MongoRepository<FamizyoOrderNotification>(a, new Audit()), configuration, contextA);
var serviceB = new OrderNotificationService(new MongoRepository<FamizyoOrderNotification>(b, new Audit()), configuration, contextB);
if (args.Length > 1 && args[1] == "--recover") { await serviceA.GetNotificationsToResendAsync("store-a"); return; }
var checks = 0;
void Check(bool condition, string name) { if (!condition) throw new InvalidOperationException("FAILED: " + name); checks++; Console.WriteLine("PASS: " + name); }
BsonDocument Order(string id, string store) => new() { ["_id"] = id, ["StoreId"] = store, ["CreatedOnUtc"] = DateTime.UtcNow };
IMongoCollection<BsonDocument> Orders(IMongoDatabase database) => database.GetCollection<BsonDocument>("Order");
IMongoCollection<FamizyoOrderNotification> Notices(IMongoDatabase database) => database.GetCollection<FamizyoOrderNotification>(nameof(FamizyoOrderNotification));
await a.GetCollection<Store>(nameof(Store)).InsertOneAsync(new Store { Id = "store-a" });
await b.GetCollection<Store>(nameof(Store)).InsertOneAsync(new Store { Id = "store-b" });
await Orders(a).InsertOneAsync(Order("shared-order", "store-a"));
await Orders(b).InsertOneAsync(Order("shared-order", "store-b"));
var notices = await serviceA.GetNotificationsToResendAsync("store-a");
Check(notices.Count == 1 && notices[0].OrderId == "shared-order" && notices[0].SendCount == 0 && notices[0].LastSentOnUtc == null,
    "a persisted owned order becomes one unsent notification without Keycloak or Redis discovery");
Check(await Notices(b).CountDocumentsAsync(FilterDefinition<FamizyoOrderNotification>.Empty) == 0, "tenant A reconciliation does not write tenant B");
var first = notices.Single();
var attempts = await Task.WhenAll(Enumerable.Range(0, 12).Select(_ => serviceA.CreateOrderNotificationAsync("shared-order", "store-a")));
Check(attempts.All(x => x.Id == first.Id) && await Notices(a).CountDocumentsAsync(x => x.OrderId == "shared-order") == 1,
    "concurrent replay retains exactly one notification id per order");
await Orders(a).InsertOneAsync(Order("concurrent-first-order", "store-a"));
var freshAttempts = await Task.WhenAll(Enumerable.Range(0, 12).Select(_ => serviceA.CreateOrderNotificationAsync("concurrent-first-order", "store-a")));
Check(freshAttempts.Select(x => x.Id).Distinct().Count() == 1 && freshAttempts.All(x => x.SendCount == 0) &&
    await Notices(a).CountDocumentsAsync(x => x.OrderId == "concurrent-first-order") == 1,
    "concurrent first creation writes one unsent notification without duplicate rows");
var foreign = (await serviceB.GetNotificationsToResendAsync("store-b")).Single();
Check(foreign.OrderId == first.OrderId && foreign.Id != first.Id && foreign.StoreId == "store-b", "identical order ids remain isolated across tenant databases");
await Orders(a).InsertOneAsync(Order("legacy-order", "store-a"));
await Notices(a).InsertOneAsync(new FamizyoOrderNotification { Id = "retained-legacy-id", OrderId = "legacy-order", StoreId = "store-a", SendCount = 7,
    ViewedOnUtc = DateTime.UtcNow, ViewedByCustomerId = "viewer", InteractedOnUtc = DateTime.UtcNow, InteractedByCustomerId = "operator", LastSentOnUtc = DateTime.UtcNow });
var legacy = await serviceA.CreateOrderNotificationAsync("legacy-order", "store-a");
Check(legacy.Id == "retained-legacy-id" && legacy.SendCount == 7 && legacy.ViewedByCustomerId == "viewer" && legacy.InteractedByCustomerId == "operator",
    "existing legacy ids, counters and acknowledgements are preserved");
await Orders(a).InsertOneAsync(Order("committed-before-worker-restart", "store-a"));
var start = new ProcessStartInfo("dotnet") { UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true };
start.ArgumentList.Add(Assembly.GetExecutingAssembly().Location); start.ArgumentList.Add(Path.GetFullPath(args[0])); start.ArgumentList.Add("--recover");
using (var child = Process.Start(start)!)
{
    var output = child.StandardOutput.ReadToEndAsync(); var error = child.StandardError.ReadToEndAsync();
    using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(15));
    try { await child.WaitForExitAsync(deadline.Token); await Task.WhenAll(output, error); }
    finally { if (!child.HasExited) child.Kill(entireProcessTree: true); }
    Check(child.ExitCode == 0 && await serviceA.GetNotificationByOrderIdAsync("committed-before-worker-restart") != null,
        "an independent new process recovers a committed order after transient consumer loss");
}
var batch = Enumerable.Range(0, 101).Select(i => Order("batch-" + i.ToString("D3"), "store-a")).ToArray();
await Orders(a).InsertManyAsync(batch);
await serviceA.GetNotificationsToResendAsync("store-a");
Check(await Notices(a).CountDocumentsAsync(Builders<FamizyoOrderNotification>.Filter.Regex(x => x.OrderId, new BsonRegularExpression("^batch-"))) == 100,
    "one reconciliation bounds new work to one hundred orders");
await serviceA.GetNotificationsToResendAsync("store-a");
Check(await Notices(a).CountDocumentsAsync(Builders<FamizyoOrderNotification>.Filter.Regex(x => x.OrderId, new BsonRegularExpression("^batch-"))) == 101,
    "the next batch completes remaining orders without a checkpoint gap");
await Task.WhenAll(Enumerable.Range(0, 25).Select(_ => serviceA.IncrementSendCountAsync(first.Id)).Concat(new[] {
    serviceA.MarkAsViewedAsync(first.Id, "viewer-a"), serviceA.MarkAsInteractedAsync(first.Id, "operator-a") }));
var updated = await serviceA.GetNotificationByOrderIdAsync("shared-order");
Check(updated.SendCount == 25 && updated.ViewedByCustomerId == "viewer-a" && updated.InteractedByCustomerId == "operator-a",
    "concurrent send counters and user acknowledgements do not overwrite each other");
var rejected = false;
try { await serviceA.CreateOrderNotificationAsync("missing-order", "store-a"); } catch (InvalidOperationException) { rejected = true; }
Check(rejected, "an unpersisted order cannot fabricate a notification");
await Orders(a).InsertOneAsync(Order("wrong-store-order", "store-b"));
rejected = false;
try { await serviceA.CreateOrderNotificationAsync("wrong-store-order", "store-a"); } catch (InvalidOperationException) { rejected = true; }
Check(rejected && await Notices(a).CountDocumentsAsync(x => x.OrderId == "wrong-store-order") == 0, "an order from a different store cannot enter the current group");
rejected = false;
try { await serviceA.GetNotificationsToResendAsync("store-b"); } catch (InvalidOperationException) { rejected = true; }
Check(rejected, "a mismatching current store fails before reconciliation");
await serviceA.MarkAsViewedAsync(foreign.Id, "foreign-viewer");
Check((await serviceB.GetNotificationByOrderIdAsync("shared-order")).ViewedOnUtc == null, "foreign notification acknowledgements leave the other tenant untouched");
var invalidDatabase = new OrderNotificationService(new MongoRepository<FamizyoOrderNotification>(client.GetDatabase("foreign_notification_fixture"), new Audit()), configuration, contextA);
rejected = false;
try { await invalidDatabase.GetNotificationsToResendAsync("store-a"); } catch (InvalidOperationException) { rejected = true; }
Check(rejected, "a non-tenant database is rejected before any collection access");
Console.WriteLine("PASS: " + checks + " real Mongo order-notification checks; two isolated tenants; no external delivery.");

public sealed class Audit : IAuditInfoProvider
{
    public string GetCurrentUser() => "fixture-operator";
    public DateTime GetCurrentDateTime() => DateTime.UtcNow;
}
public sealed class Context(string store) : IWorkContext
{
    public Customer CurrentCustomer => new() { Id = "fixture-operator" };
    public Customer OriginalCustomerIfImpersonated => null!;
    public Vendor CurrentVendor => null!;
    public DomainHost CurrentHost => null!;
    public Language WorkingLanguage => null!;
    public Currency WorkingCurrency => null!;
    public TaxDisplayType TaxDisplayType => default;
    public Store CurrentStore => new() { Id = store };
}
