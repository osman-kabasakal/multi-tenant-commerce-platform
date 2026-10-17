using Grand.Web.MultiTenant.Commands.StaleCache.Handlers;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using System.Net.WebSockets;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Grand.Business.Marketing.Services.BackgroundServices;
using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.Stores;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.IdentityModel.Tokens;
using Platform.Notifications;
using Platform.Security;
using System.Diagnostics;
using System.Net.Http.Json;
using System.Reflection;
using System.Text.Json;
using Grand.Business.Tenants.Services.TenantServiceProvider;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Events;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using StackExchange.Redis;

internal static class JournalVerification
{
    public static async Task Run(IConfiguration fixture, string path)
    {
        var checks = 0;
        void Check(bool value, string name) { if (!value) throw new InvalidOperationException("FAIL: " + name); checks++; Console.WriteLine("PASS: " + name); }
        var children = new List<Process>();
        var streams = new List<Task<string>>();
        using var redis = await ConnectionMultiplexer.ConnectAsync(fixture["Fixture:Connection"]!);
        var db = redis.GetDatabase();
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> {
            ["Provisioning:ManagedRuntime"] = "true", ["Redis:RedisPubSubEnabled"] = "true", ["Redis:RedisPubSubChannel"] = fixture["Fixture:Channel"]
        }).Build();
        var httpContext = new HttpContextAccessor();
        var journal = new TenantCacheJournal(redis, configuration, httpContext, new TenantIdentityAccessor());
        string Correlation() => Guid.NewGuid().ToString("D");
        async Task<string> Server(bool subscribe)
        {
            var start = new ProcessStartInfo("dotnet") { UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true };
            foreach (var value in new[] { Assembly.GetExecutingAssembly().Location, subscribe ? "--server-managed" : "--server-managed-no-subscribe", path }) start.ArgumentList.Add(value);
            var child = Process.Start(start)!; children.Add(child); streams.Add(child.StandardError.ReadToEndAsync());
            using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(20));
            while (true) {
                var line = await child.StandardOutput.ReadLineAsync(timeout.Token);
                if (line == null) throw new InvalidOperationException("Managed cache fixture exited before readiness.");
                if (line.StartsWith("READY ")) return line[6..];
            }
        }
        using var client = new HttpClient { Timeout = TimeSpan.FromSeconds(20) };
        async Task<(string Value, string Id)> Read(string server, string key, string value, string extra = "", string customer = "customer-a")
        {
            using var request = new HttpRequestMessage(HttpMethod.Get, server + "/value?key=" + Uri.EscapeDataString(key) + "&value=" + Uri.EscapeDataString(value) + "&mode=" + (extra == "&mode=uncached" ? "uncached" : "async") + (extra == "&mode=uncached" ? "" : extra));
            request.Headers.Add("X-Fixture-Store", "store-a"); request.Headers.Add("X-Fixture-Customer", customer);
            using var response = await client.SendAsync(request); response.EnsureSuccessStatusCode();
            return ((await response.Content.ReadFromJsonAsync<string>())!, response.Headers.GetValues("X-Correlation-ID").Single());
        }
        async Task Invalidate(string server, string key, bool prefix = false)
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, server + "/remove?key=" + Uri.EscapeDataString(key) + "&prefix=" + prefix.ToString().ToLowerInvariant());
            request.Headers.Add("X-Fixture-Store", "store-a");
            using var response = await client.SendAsync(request); response.EnsureSuccessStatusCode();
        }
        try
        {
            var first = await Server(true); var disconnected = await Server(false);
            var cached = await Read(disconnected, "offline-key", "before");
            Check((await Read(disconnected, "offline-key", "wrong")).Value == "before", "managed memory cache reuses an unchanged observation");
            await Invalidate(first, "offline-key");
            Check((await Read(disconnected, "offline-key", "after")).Value == "after", "persisted facts reject stale memory even when this web process never subscribed to PubSub");
            Check((await journal.StaleAsync("store-a", "customer-a", new[] { cached.Id })).SequenceEqual(new[] { cached.Id }), "HTTP cache dependency keeps its original observation and becomes stale");
            Check((await journal.ChangedAsync("store-a", "customer-b")).Count == 0 && (await journal.ChangedAsync("store-b", "customer-a")).Count == 0, "another customer and store cannot receive the tracked correlation");
            Check((await journal.StaleAsync("store-a", "customer-b", new[] { cached.Id })).Count == 1, "foreign and unknown correlations are uniformly stale without exposing their owner");
            var pending = await journal.PendingAsync("store-a", "customer-a");
            Check(pending.Any(x => x.CorrelationId == cached.Id), "disconnected changes remain pending for the separate tenant task");
            await journal.AcknowledgeAsync("store-a", "customer-a", pending);
            Check(!(await journal.PendingAsync("store-a", "customer-a")).Any(x => x.CorrelationId == cached.Id) &&
                (await journal.ChangedAsync("store-a", "customer-a")).Any(x => x.CorrelationId == cached.Id), "push acknowledgement preserves each live or reconnecting socket's independent change view");
            await Invalidate(first, "offline-key");
            Check((await journal.PendingAsync("store-a", "customer-a")).Any(x => x.CorrelationId == cached.Id), "a newer revision becomes pending after an earlier push receipt");
            string Token(string customer, bool expired = false) {
                var jwt = new JwtSecurityToken("isolated-cache-fixture", "isolated-cache-fixture",
                    new[] { new Claim("Guid", customer == "customer-b" ? "00000000-0000-0000-0000-000000000002" : "00000000-0000-0000-0000-000000000001") },
                    DateTime.UtcNow.AddMinutes(-5), DateTime.UtcNow.AddMinutes(expired ? -1 : 2),
                    new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(new string('x', 32))), SecurityAlgorithms.HmacSha256));
                return new JwtSecurityTokenHandler().WriteToken(jwt);
            }
            async Task<ClientWebSocket> Socket(string customer, string? token, string? origin = null) {
                var socket = new ClientWebSocket(); socket.Options.AddSubProtocol(ClientCacheSocket.Protocol);
                socket.Options.SetRequestHeader("X-Fixture-Store", "store-a"); socket.Options.SetRequestHeader("X-Fixture-Customer", customer);
                if (token != null) socket.Options.SetRequestHeader("Authorization", "Bearer " + token);
                if (origin != null) socket.Options.SetRequestHeader("Origin", origin);
                using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(5));
                try { await socket.ConnectAsync(new Uri(first.Replace("http:", "ws:") + "/api/ws/fcm"), deadline.Token); return socket; }
                catch { socket.Dispose(); throw; }
            }
            async Task<bool> Denied(string customer, string? token, string? origin = null) {
                try { using var socket = await Socket(customer, token, origin); return false; } catch (WebSocketException) { return true; }
            }
            Check(await Denied("customer-a", null) && await Denied("customer-a", Token("customer-b")) && await Denied("customer-a", Token("customer-a", true)) &&
                await Denied("customer-a", Token("customer-a"), "https://foreign.invalid"), "the actual mobile socket controller rejects missing, expired, mismatched customer credentials and a foreign browser origin");
            using (var socket1 = await Socket("customer-a", Token("customer-a")))
            using (var socket2 = await Socket("customer-a", Token("customer-a")))
            using (var other = await Socket("customer-b", Token("customer-b"))) {
                async Task<string[]> Notice(ClientWebSocket socket) {
                    var data = new byte[65536]; using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(8));
                    var received = await socket.ReceiveAsync(data.AsMemory(), deadline.Token);
                    using var json = JsonDocument.Parse(data.AsMemory(0, received.Count));
                    return json.RootElement.GetProperty("correlationIds").EnumerateArray().Select(x => x.GetString()!).ToArray();
                }
                Check((await Notice(socket1)).Contains(cached.Id) && (await Notice(socket2)).Contains(cached.Id), "two independently authenticated device sockets receive the same owned change without consuming each other");
                var leaked = false;
                using (var deadline = new CancellationTokenSource(TimeSpan.FromMilliseconds(300))) {
                    try { await other.ReceiveAsync(new byte[1024].AsMemory(), deadline.Token); leaked = true; } catch (OperationCanceledException) { }
                }
                Check(!leaked, "an authenticated different customer socket receives no other customer's correlations");
                await socket1.SendAsync(Encoding.UTF8.GetBytes("{\"customerId\":\"customer-b\"}").AsMemory(), WebSocketMessageType.Text, true, CancellationToken.None);
                using var closeDeadline = new CancellationTokenSource(TimeSpan.FromSeconds(5));
                var closed = await socket1.ReceiveAsync(new byte[1024].AsMemory(), closeDeadline.Token);
                Check(closed.MessageType == WebSocketMessageType.Close && socket1.CloseStatus == WebSocketCloseStatus.PolicyViolation, "client data cannot replace socket ownership or acknowledge a shared receipt");
                socket2.Abort();
            }
            var gate = Guid.NewGuid().ToString("N");
            var loading = Read(disconnected, "race-key", "racing-old", "&gate=" + gate);
            var barrier = "fixture:cache-acquire:" + gate;
            using (var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(10)))
                while (!await db.KeyExistsAsync(barrier + ":started")) await Task.Delay(20, timeout.Token);
            await Invalidate(first, "race-key");
            await db.StringSetAsync(barrier + ":release", "yes", TimeSpan.FromSeconds(20));
            var raced = await loading;
            Check(raced.Value == "racing-old" && (await journal.StaleAsync("store-a", "customer-a", new[] { raced.Id })).Count == 1 &&
                (await Read(disconnected, "race-key", "racing-new")).Value == "racing-new", "invalidation during acquisition never stamps the in-flight old value as newly fresh");
            await db.KeyDeleteAsync(new RedisKey[] { barrier + ":started", barrier + ":release" });
            var stamp = await journal.ObserveAsync("store-a"); var id = Correlation();
            await journal.TrackAsync("store-a", "customer-prefix", id, "store-a.product.one", stamp);
            await journal.InvalidateAsync("store-a", "store-a.unrelated", CacheEvent.RemoveKey);
            Check((await journal.StaleAsync("store-a", "customer-prefix", new[] { id })).Count == 0, "unrelated exact invalidations preserve dependency freshness");
            await journal.InvalidateAsync("store-a", "store-a.PRODUCT.", CacheEvent.RemovePrefix);
            Check((await journal.StaleAsync("store-a", "customer-prefix", new[] { id })).Count == 1, "prefix facts use the cache manager's case-insensitive starts-with semantics");
            stamp = await journal.ObserveAsync("store-a"); id = Correlation();
            await journal.TrackAsync("store-a", "customer-oldest", id, "store-a.repeat", stamp);
            await journal.InvalidateAsync("store-a", "store-a.repeat", CacheEvent.RemoveKey);
            await journal.TrackAsync("store-a", "customer-oldest", id, "store-a.repeat", await journal.ObserveAsync("store-a"));
            Check((await journal.StaleAsync("store-a", "customer-oldest", new[] { id })).Count == 1, "re-reading a dependency in one response cannot erase its older stale observation");
            var foreignConfig = new ConfigurationBuilder().AddConfiguration(configuration).AddInMemoryCollection(new Dictionary<string,string?> { ["Redis:RedisPubSubChannel"] = fixture["Fixture:Channel"] + "-foreign" }).Build();
            var foreign = new TenantCacheJournal(redis, foreignConfig, httpContext, new TenantIdentityAccessor());
            Check((await foreign.ChangedAsync("store-a", "customer-a")).Count == 0, "the same store/customer identities in another deployment have no shared journal");
            stamp = await journal.ObserveAsync("store-a"); id = Correlation();
            for (var i = 0; i < 257; i++) await journal.TrackAsync("store-a", "customer-many-dependencies", id, "store-a.dependency-" + i, stamp);
            Check((await journal.StaleAsync("store-a", "customer-many-dependencies", new[] { id })).Count == 1, "a response beyond the bounded dependency limit is conservatively stale");
            var ids = Enumerable.Range(0, 513).Select(_ => Correlation()).ToArray();
            foreach (var item in ids) await journal.TrackAsync("store-a", "customer-many-correlations", item, "store-a.bounded", stamp);
            Check((await journal.StaleAsync("store-a", "customer-many-correlations", new[] { ids[0] })).Count == 1 &&
                (await journal.StaleAsync("store-a", "customer-many-correlations", new[] { ids[^1] })).Count == 0, "old correlations expire from the per-customer bounded history");
            // Missing recent keys must not hide an older affected correlation behind one hundred fresh records.
            var old = Correlation(); await journal.TrackAsync("store-a", "customer-deep", old, "store-a.deep-old", stamp);
            for (var i = 0; i < 110; i++) await journal.TrackAsync("store-a", "customer-deep", Correlation(), "store-a.deep-fresh", stamp);
            await journal.InvalidateAsync("store-a", "store-a.deep-old", CacheEvent.RemoveKey);
            Check((await journal.PendingAsync("store-a", "customer-deep")).Any(x => x.CorrelationId == old), "pending scans include older affected records behind more than one hundred fresh ones");
            stamp = await journal.ObserveAsync("store-history");
            for (var i = 0; i < 5001; i++) await journal.InvalidateAsync("store-history", "store-history.key-" + i, CacheEvent.RemoveKey);
            Check(!await journal.IsFreshAsync("store-history", "store-history.unknown-old", stamp), "pruned invalidation history cannot falsely certify an old observation");
            stamp = await journal.ObserveAsync("store-a");
            await db.KeyDeleteAsync("commerce:" + fixture["Fixture:Channel"] + ":cache:v1:{store-a}:epoch");
            Check(!await journal.IsFreshAsync("store-a", "store-a.any", stamp), "Redis epoch loss invalidates old observations instead of reusing revision zero");
            var statePrefix = "commerce:" + fixture["Fixture:Channel"] + ":cache:v1:{store-a}:";
            stamp = await journal.ObserveAsync("store-a");
            await journal.InvalidateAsync("store-a", "store-a.eviction", CacheEvent.RemoveKey);
            var afterInvalidation = await journal.ObserveAsync("store-a");
            await db.KeyDeleteAsync(statePrefix + "facts");
            Check(!await journal.IsFreshAsync("store-a", "store-a.eviction", afterInvalidation), "loss of a fact hash rotates the epoch rather than treating missing history as fresh");
            stamp = await journal.ObserveAsync("store-a");
            await db.KeyDeleteAsync(statePrefix + "sequence");
            Check(!await journal.IsFreshAsync("store-a", "store-a.any", stamp), "loss of a revision key cannot silently reuse the same epoch");
            await children[1].KillAndWait();
            var recovered = await Server(false);
            Check((await Read(recovered, "offline-key", "restarted")).Value == "restarted" && (await journal.ChangedAsync("store-a", "customer-a")).Any(x => x.CorrelationId == cached.Id), "a fresh web process retains disconnected customer changes in Redis");
            Check((await Read(recovered, "uncached", "one", "&mode=uncached")).Value == "one" && (await Read(recovered, "uncached", "two", "&mode=uncached")).Value == "two", "zero-duration reads do not store managed memory entries");
            httpContext.HttpContext = new DefaultHttpContext(); httpContext.HttpContext.Items["StoreId"] = "store-a";
            var tenant = "00000000000000000000000000000001";
            var secrets = FixtureProxy.For<ITenantSecrets>((method, _) => method.Name == "ResolveAsync" ? Task.FromResult(tenant) : throw new NotSupportedException());
            var customers = new[] { new Customer { Id = "customer-push", StoreId = "store-a", Active = true }, new Customer { Id = "customer-foreign", StoreId = "store-b", Active = true } };
            var receivers = new[] {
                new PushRegistration { CustomerId = "customer-push", Allowed = true, Token = "fixture-device-a" },
                new PushRegistration { CustomerId = "customer-push", Allowed = true, Token = "fixture-device-a" },
                new PushRegistration { CustomerId = "customer-push", Allowed = false, Token = "denied-fixture-device" },
                new PushRegistration { CustomerId = "customer-foreign", Allowed = true, Token = "foreign-fixture-device" }
            };
            var customerRepo = FixtureProxy.For<IRepository<Customer>>((method, _) => method.Name == "get_Table" ? customers.AsQueryable() : throw new NotSupportedException());
            var receiverRepo = FixtureProxy.For<IRepository<PushRegistration>>((method, _) => method.Name == "get_Table" ? receivers.AsQueryable() : throw new NotSupportedException());
            var work = FixtureProxy.For<IWorkContext>((method, _) => method.Name == "get_CurrentStore" ? new Store { Id = "store-a" } : throw new NotSupportedException());
            var options = new NotificationOptions { Provider = "LocalSink", LocalDirectory = Path.Combine(Path.GetDirectoryName(path)!, "local-push") };
            options.Validate("Development", true);
            var capture = new CaptureSender(new LocalSinkTenantPushSender(secrets, options));
            var task = new ClientCacheNotificationTask(journal, work, customerRepo, receiverRepo, capture, secrets, options, NullLogger<ClientCacheNotificationTask>.Instance);
            stamp = await journal.ObserveAsync("store-a"); var pushId = Correlation();
            await journal.TrackAsync("store-a", "customer-push", pushId, "store-a.push", stamp);
            await journal.TrackAsync("store-a", "customer-foreign", Correlation(), "store-a.push", stamp);
            await journal.InvalidateAsync("store-a", "store-a.push", CacheEvent.RemoveKey);
            capture.Fail = true; var failure = false;
            try { await task.Execute(); } catch (InvalidOperationException) { failure = true; }
            Check(failure && (await journal.PendingAsync("store-a", "customer-push")).Any(x => x.CorrelationId == pushId), "actual scheduled task retains its change after a sender failure");
            capture.Fail = false; capture.Partial = true; failure = false;
            try { await task.Execute(); } catch (InvalidOperationException) { failure = true; }
            Check(failure && (await journal.PendingAsync("store-a", "customer-push")).Count == 1, "a partial provider receipt is not acknowledged as successful delivery");
            capture.Partial = false; await task.Execute();
            var receiptFiles = Directory.GetFiles(Path.Combine(options.LocalDirectory, tenant, "push"), "*.json");
            using var captured = JsonDocument.Parse(await File.ReadAllTextAsync(receiptFiles.Single()));
            var messageData = captured.RootElement.GetProperty("message").GetProperty("Data");
            Check(capture.LastTokens.SequenceEqual(new[] { "fixture-device-a" }) && messageData.GetProperty("Type").GetString() == "cache_invalidation" &&
                messageData.GetProperty("TenantId").GetString() == tenant && messageData.GetProperty("CorrelationIds").GetString()!.Contains(pushId) &&
                (await journal.PendingAsync("store-a", "customer-push")).Count == 0, "actual task and LocalSink sender deliver only the allowed owned device and persist its successful receipt");
            var queryWork = FixtureProxy.For<IWorkContext>((method, _) => method.Name switch {
                "get_CurrentStore" => new Store { Id = "store-a" },
                "get_CurrentCustomer" => new Customer { Id = "customer-push", StoreId = "store-a", Active = true },
                _ => throw new NotSupportedException()
            });
            var query = new StaleCacheKeyQueryHandler(null!, null!, redis, NullLogger<StaleCacheKeyQueryHandler>.Instance, journal, queryWork);
            var staleReply = await query.Handle(new StaleCacheQuery { StaleCacheItems = [new StaleCacheItem { CorrelationId = pushId, AsOf = DateTime.UtcNow.AddYears(20) }] }, default);
            Check(staleReply.StaleCorrelationIds.SequenceEqual(new[] { pushId }), "the actual stale-query handler uses server observations even if a client supplies a future timestamp");
            var wrongWork = FixtureProxy.For<IWorkContext>((method, _) => method.Name switch {
                "get_CurrentStore" => new Store { Id = "store-b" },
                "get_CurrentCustomer" => new Customer { Id = "customer-push", Active = true },
                _ => throw new NotSupportedException()
            });
            var rejectedScope = false;
            try { await new StaleCacheKeyQueryHandler(null!, null!, redis, NullLogger<StaleCacheKeyQueryHandler>.Instance, journal, wrongWork).Handle(
                new StaleCacheQuery { StaleCacheItems = [new StaleCacheItem { CorrelationId = pushId }] }, default); } catch (InvalidOperationException) { rejectedScope = true; }
            Check(rejectedScope, "the actual stale-query handler rejects a mismatched current store before reading customer correlations");
            var sentCount = capture.Calls; await task.Execute();
            Check(capture.Calls == sentCount && (await journal.ChangedAsync("store-a", "customer-push")).Count == 1, "a restarted task does not resend an acknowledged revision and reconnect recovery remains available");
            Console.WriteLine("PASS: " + checks + " managed journal checks; real Redis and separate web processes; controlled fixture identities and acquisitions, no external delivery.");
        }
        finally
        {
            foreach (var child in children) { await child.KillAndWait(); child.Dispose(); }
            await Task.WhenAll(streams);
        }
    }
    private static async Task KillAndWait(this Process child) { if (!child.HasExited) child.Kill(entireProcessTree: true); await child.WaitForExitAsync(); }
}

internal sealed class CaptureSender(ITenantPushSender inner) : ITenantPushSender
{
    public bool Fail, Partial;
    public int Calls;
    public string[] LastTokens = [];
    public Task<TenantPushReceipt> SendAsync(string tenant, IReadOnlyList<string> tokens, TenantPushMessage message, CancellationToken ct = default)
    {
        Calls++; LastTokens = tokens.ToArray();
        if (Fail) throw new HttpRequestException("Synthetic local sender failure.");
        if (Partial) return Task.FromResult(new TenantPushReceipt(tokens.Count, 0, "ControlledPartial"));
        return inner.SendAsync(tenant, tokens, message, ct);
    }
}
