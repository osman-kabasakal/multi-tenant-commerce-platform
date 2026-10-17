using System.Diagnostics;
using System.Net;
using System.Net.Http.Json;
using System.Reflection;
using System.Text.Json;
using Grand.Business.Tenants.Services.TenantServiceProvider;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Message;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.MultiTenant;
using MediatR;
using StackExchange.Redis;

if (args.Length < 2) throw new ArgumentException("Choose --verify or --server and the private cache fixture config.");
var config = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[1])).Build();
if (config["Fixture:Purpose"] != "isolated-tenant-cache-v1") throw new InvalidOperationException("Enable only the isolated cache fixture.");
if (args[0] == "--server")
{
    var builder = WebApplication.CreateBuilder(Array.Empty<string>());
    builder.Logging.ClearProviders();
    builder.WebHost.UseUrls("http://127.0.0.1:0");
    var options = ConfigurationOptions.Parse(config["Fixture:Connection"]!);
    options.ConnectTimeout = options.SyncTimeout = options.AsyncTimeout = 5000;
    builder.Services.AddSingleton<IConnectionMultiplexer>(ConnectionMultiplexer.Connect(options));
    builder.Services.AddSingleton(sp => sp.GetRequiredService<IConnectionMultiplexer>().GetSubscriber());
    builder.Services.AddSingleton(new RedisConfig { RedisPubSubChannel = config["Fixture:Channel"]! });
    builder.Services.AddSingleton(new CacheConfig { DefaultCacheTimeMinutes = 10 });
    builder.Services.AddMemoryCache();
    builder.Services.AddHttpContextAccessor();
    builder.Services.AddSingleton<ITenantIdentityAccessor, TenantIdentityAccessor>();
    builder.Services.AddSingleton<IMediator>(FixtureProxy.For<IMediator>((method, _) => method.Name == "Publish" ? Task.CompletedTask : throw new NotSupportedException()));
    builder.Services.AddSingleton<RedisCacheCoordinator>();
    builder.Services.AddSingleton<IMessageBus, RedisMessageBus>();
    builder.Services.AddSingleton<ICacheBase, RedisMessageCacheManager>();
    var app = builder.Build();
    app.Use(async (context, next) => {
        var store = context.Request.Headers["X-Fixture-Store"].ToString();
        if (store is not ("store-a" or "store-b" or "")) { context.Response.StatusCode = 400; return; }
        context.RequestServices.GetRequiredService<ITenantIdentityAccessor>().TenantId = string.IsNullOrEmpty(store) ? null : store;
        if (context.Request.Query["background"] == "true") context.Items = new Dictionary<object, object?>();
        else if (store.Length > 0) context.Items["StoreId"] = store;
        await next();
    });
    app.MapGet("/value", async (string key, string value, string mode, ICacheBase cache) => {
        var result = mode switch {
            "async" => await cache.GetAsync(key, () => Task.FromResult(value)),
            "async-time" => await cache.GetAsync(key, () => Task.FromResult(value), 10),
            "sync" => cache.Get(key, () => value),
            "sync-time" => cache.Get(key, () => value, 10),
            "set" => await cache.SetAsync(key, () => Task.FromResult(value)),
            "set-time" => await cache.SetAsync(key, () => Task.FromResult(value), 10),
            _ => throw new ArgumentException("Unknown fixture read mode.")
        };
        return Results.Json(result);
    });
    app.MapPost("/remove", async (string key, bool prefix, ICacheBase cache) => {
        if (prefix) await cache.RemoveByPrefix(key); else await cache.RemoveAsync(key);
        return Results.Ok();
    });
    app.MapPost("/clear", async (ICacheBase cache) => {
        try { await cache.Clear(); return Results.Ok(); }
        catch (InvalidOperationException) { return Results.BadRequest(); }
    });
    _ = app.Services.GetRequiredService<ICacheBase>();
    await app.Services.GetRequiredService<IMessageBus>().SubscribeAsync();
    await app.StartAsync();
    Console.WriteLine("READY " + app.Urls.Single()); Console.Out.Flush();
    await app.WaitForShutdownAsync();
    return;
}
if (args[0] != "--verify") throw new ArgumentException("Unknown cache fixture mode.");
var children = new List<Process>();
var errors = new List<Task<string>>();
var failures = new List<string>();
var checks = 0;
void Check(bool condition, string name) { checks++; Console.WriteLine((condition ? "PASS: " : "FAIL: ") + name); if (!condition) failures.Add(name); }
async Task<string> Server(string path)
{
    var start = new ProcessStartInfo("dotnet") { UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true };
    start.ArgumentList.Add(Assembly.GetExecutingAssembly().Location); start.ArgumentList.Add("--server"); start.ArgumentList.Add(path);
    var child = Process.Start(start)!; children.Add(child); errors.Add(child.StandardError.ReadToEndAsync());
    using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(20));
    while (true)
    {
        var line = await child.StandardOutput.ReadLineAsync(timeout.Token);
        if (line == null) throw new InvalidOperationException("Cache fixture server exited before readiness.");
        if (line.StartsWith("READY ", StringComparison.Ordinal)) return line[6..];
    }
}
using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(8) };
async Task<string> Read(string server, string store, string key, string value, string mode = "async", bool background = false)
{
    using var message = new HttpRequestMessage(HttpMethod.Get, server + "/value?key=" + Uri.EscapeDataString(key) + "&value=" + Uri.EscapeDataString(value) + "&mode=" + mode + "&background=" + background.ToString().ToLowerInvariant());
    if (store.Length > 0) message.Headers.Add("X-Fixture-Store", store);
    using var response = await http.SendAsync(message); response.EnsureSuccessStatusCode(); return (await response.Content.ReadFromJsonAsync<string>())!;
}
async Task<HttpStatusCode> Write(string server, string store, string path)
{
    using var message = new HttpRequestMessage(HttpMethod.Post, server + path);
    if (store.Length > 0) message.Headers.Add("X-Fixture-Store", store);
    using var response = await http.SendAsync(message); return response.StatusCode;
}
async Task<bool> Eventually(string server, string store, string key, string value)
{
    for (var i = 0; i < 40; i++) { if (await Read(server, store, key, value) == value) return true; await Task.Delay(50); }
    return false;
}
var foreignPath = Path.Combine(Path.GetDirectoryName(Path.GetFullPath(args[1]))!, "foreign-cache.json");
try
{
    var first = await Server(Path.GetFullPath(args[1])); var second = await Server(Path.GetFullPath(args[1]));
    await File.WriteAllTextAsync(foreignPath, JsonSerializer.Serialize(new { Fixture = new { Purpose = "isolated-tenant-cache-v1", Connection = config["Fixture:Connection"], Channel = config["Fixture:Channel"] + "-foreign" } }));
    if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(foreignPath, UnixFileMode.UserRead | UnixFileMode.UserWrite);
    var foreign = await Server(foreignPath);
    Check(await Read(first, "store-a", "shared", "a") == "a" && await Read(first, "store-a", "shared", "wrong", "async-time") == "a" &&
        await Read(first, "store-a", "shared", "wrong", "sync") == "a" && await Read(first, "store-a", "shared", "wrong", "sync-time") == "a",
        "default and explicit sync/async reads use exactly one identical tenant namespace");
    Check(await Read(first, "store-b", "shared", "b") == "b" && await Read(first, "store-a", "shared", "wrong") == "a", "identical keys remain isolated for two stores in one web process");
    Check(await Read(first, "store-a", "shared", "a-set", "set") == "a-set" && await Read(first, "store-a", "shared", "wrong", "async-time") == "a-set" &&
        await Read(first, "store-a", "shared", "a-set-time", "set-time") == "a-set-time" && await Read(first, "store-a", "shared", "wrong", "sync") == "a-set-time", "both SetAsync overloads replace the same scoped cache entry");
    Check(await Read(first, "store-a", "shared", "wrong", "async", true) == "a-set-time" && await Read(first, "store-b", "shared", "wrong", "sync-time", true) == "b", "background tenant identity shares its own HTTP cache without crossing stores");
    await Read(second, "store-a", "shared", "replica-old"); await Read(second, "store-b", "shared", "replica-b"); await Read(foreign, "store-a", "shared", "foreign-a");
    Check(await Write(first, "store-a", "/remove?key=shared&prefix=false") == HttpStatusCode.OK && await Eventually(second, "store-a", "shared", "replica-new"), "an awaited real Redis key invalidation reaches a separate web process");
    Check(await Read(second, "store-b", "shared", "wrong") == "replica-b" && await Read(foreign, "store-a", "shared", "wrong") == "foreign-a", "another store and deployment retain their cached values");
    await Read(first, "store-a", "product.one", "p1"); await Read(first, "store-a", "product.two", "p2");
    await Read(first, "store-b", "nested.store-a.product.one", "nested-b");
    await Write(first, "store-a", "/remove?key=product.&prefix=true");
    Check(await Read(first, "store-a", "product.one", "new-p1") == "new-p1" && await Read(first, "store-a", "product.two", "new-p2") == "new-p2" &&
        await Read(first, "store-b", "nested.store-a.product.one", "wrong") == "nested-b", "prefix removal matches only the beginning of qualified keys");
    await Write(first, "store-a", "/clear");
    Check(await Eventually(second, "store-a", "shared", "after-clear") && await Read(second, "store-b", "shared", "wrong") == "replica-b" &&
        await Read(first, "store-b", "shared", "wrong") == "b" && await Read(foreign, "store-a", "shared", "wrong") == "foreign-a", "tenant clear travels as a qualified prefix and preserves other stores/deployments");
    using var redis = await ConnectionMultiplexer.ConnectAsync(config["Fixture:Connection"]!);
    async Task Wire(string key) => await redis.GetSubscriber().PublishAsync(RedisChannel.Literal(config["Fixture:Channel"]!), JsonSerializer.Serialize(new MessageEventClient { ClientId = "fixture-legacy", Key = key, MessageType = (int)MessageEventType.ClearCache }));
    await Wire(""); await Task.Delay(200);
    Check(await Read(second, "store-b", "shared", "wrong") == "replica-b" && await Read(first, "store-b", "shared", "wrong") == "b", "an old unqualified clear message is ignored instead of clearing every tenant");
    await Wire("store-a.");
    Check(await Eventually(second, "store-a", "shared", "legacy-qualified-new") && await Read(second, "store-b", "shared", "wrong") == "replica-b", "a qualified legacy clear remains confined to its named tenant");
    Check(await Write(first, "", "/clear") == HttpStatusCode.BadRequest && await Read(first, "store-b", "shared", "wrong") == "b", "a clear without server tenant context fails before publication");
    var parallel = await Task.WhenAll(Enumerable.Range(0, 30).Select(i => Read(first, i % 2 == 0 ? "store-a" : "store-b", "parallel", i % 2 == 0 ? "parallel-a" : "parallel-b", "async", i % 3 == 0)));
    Check(parallel.Select((value, index) => value == (index % 2 == 0 ? "parallel-a" : "parallel-b")).All(x => x), "concurrent HTTP/background accesses retain independent tenant scope");
    if (failures.Count > 0)
    {
        Console.Error.WriteLine("FAIL: " + failures.Count + " of " + checks + " cache checks failed.");
        Environment.ExitCode = 1;
    }
    else Console.WriteLine("PASS: " + checks + " cache isolation checks; three real web processes, real Redis, controlled HTTP identity/acquire fixtures; no external delivery.");
}
finally
{
    foreach (var child in children) { if (!child.HasExited) child.Kill(entireProcessTree: true); await child.WaitForExitAsync(); child.Dispose(); }
    await Task.WhenAll(errors); File.Delete(foreignPath);
}
public class FixtureProxy : DispatchProxy
{
    public Func<MethodInfo, object?[]?, object?> InvokeFixture = null!;
    protected override object? Invoke(MethodInfo? method, object?[]? args) => InvokeFixture(method!, args);
    public static T For<T>(Func<MethodInfo, object?[]?, object?> call) where T : class { var instance = Create<T, FixtureProxy>(); ((FixtureProxy)(object)instance).InvokeFixture = call; return instance; }
}
