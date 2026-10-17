using System.Diagnostics;
using System.Net.WebSockets;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Threading.Channels;
using Famizyo.Notification;
using Famizyo.Notification.Hubs;
using Famizyo.Notification.Models;
using Famizyo.Notification.Services;
using Famizyo.Notification.Tasks;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Domain.Customers;
using Grand.Domain.Stores;
using Grand.Infrastructure;
using Grand.Infrastructure.Extensions;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.AspNetCore.SignalR;

if (args.Length < 2) throw new ArgumentException("Select --verify, --server or --publish and a private fixture configuration file.");
var mode = args[0];
var config = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[1])).Build();
if (!config.GetValue<bool>("Fixture:Enabled")) throw new InvalidOperationException("The isolated SignalR fixture must be enabled explicitly.");
if (mode == "--server")
{
    var builder = WebApplication.CreateBuilder(Array.Empty<string>());
    builder.Configuration.AddConfiguration(config);
    builder.Logging.ClearProviders();
    builder.WebHost.UseUrls("http://127.0.0.1:0");
    var notifications = new NotificationFixture();
    builder.Services.AddSingleton<IOrderNotificationService>(notifications);
    builder.Services.AddHttpContextAccessor();
    builder.Services.AddScoped<IWorkContext>(services => Stub.For<IWorkContext>((method, _) => method.Name == "get_CurrentStore"
        ? new Store { Id = IdentityStore(services.GetRequiredService<IHttpContextAccessor>().HttpContext!) } : throw new NotSupportedException()));
    builder.Services.AddScoped<IWorkContextSetter>(services => Stub.For<IWorkContextSetter>((method, _) => method.Name == "SetCurrentCustomer"
        ? Task.FromResult(new Customer { Id = "fixture-" + IdentityStore(services.GetRequiredService<IHttpContextAccessor>().HttpContext!) }) : throw new NotSupportedException()));
    builder.Services.AddScoped<IPermissionService>(services => Stub.For<IPermissionService>((method, _) => method.Name == "Authorize"
        ? Task.FromResult(services.GetRequiredService<IHttpContextAccessor>().HttpContext!.Request.Headers["X-Fixture-Identity"] != "denied") : throw new NotSupportedException()));
    builder.Services.AddPlatformSignalR(builder.Configuration).AddHubOptions<NotificationHub>(options => options.AddFilter<ReadyFilter>());
    var app = builder.Build();
    app.Use(async (context, next) => {
        var identity = context.Request.Headers["X-Fixture-Identity"].ToString();
        context.User = identity.Length == 0 ? new ClaimsPrincipal(new ClaimsIdentity()) : new ClaimsPrincipal(new ClaimsIdentity([new Claim(ClaimTypes.NameIdentifier, identity)], "isolated-fixture"));
        context.Items["StoreId"] = context.Request.Headers["X-Fixture-Store"].ToString();
        await next(context);
    });
    app.MapHub<NotificationHub>("/notificationhub");
    await app.StartAsync();
    var address = app.Services.GetRequiredService<IServer>().Features.Get<IServerAddressesFeature>()!.Addresses.Single();
    await File.WriteAllTextAsync(args[2], address);
    await app.WaitForShutdownAsync();
    return;
}
if (mode == "--publish")
{
    var builder = Host.CreateApplicationBuilder(Array.Empty<string>());
    builder.Configuration.AddConfiguration(config);
    builder.Logging.ClearProviders();
    var notifications = new NotificationFixture { Notification = new FamizyoOrderNotification { StoreId = args[2], OrderId = args[3], Id = "notice-" + args[3] } };
    builder.Services.AddSingleton<IOrderNotificationService>(notifications);
    builder.Services.AddSingleton<IStoreService>(Stub.For<IStoreService>((method, _) => method.Name == "GetAllStores"
        ? Task.FromResult<IList<Store>>([new Store { Id = args[2] }]) : throw new NotSupportedException()));
    builder.Services.AddPlatformSignalR(builder.Configuration);
    builder.Services.AddTransient<ResendUnseenNotificationsTask>();
    using var host = builder.Build();
    await host.Services.GetRequiredService<ResendUnseenNotificationsTask>().Execute();
    if (notifications.SendCount != 1) throw new InvalidOperationException("The actual resend task did not record its single attempt.");
    return;
}
if (mode != "--verify") throw new ArgumentException("Unknown fixture mode.");
var checks = 0;
void Check(bool condition, string name) { if (!condition) throw new InvalidOperationException("FAILED: " + name); checks++; Console.WriteLine("PASS: " + name); }
var directory = Path.GetDirectoryName(Path.GetFullPath(args[1]))!;
var children = new List<Process>();
Process Start(params string[] arguments)
{
    var start = new ProcessStartInfo("dotnet") { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false };
    start.ArgumentList.Add(Assembly.GetExecutingAssembly().Location);
    foreach (var argument in arguments) start.ArgumentList.Add(argument);
    var child = Process.Start(start)!;
    child.BeginOutputReadLine(); child.BeginErrorReadLine();
    children.Add(child); return child;
}
async Task<string> Server(string settings, string name)
{
    var ready = Path.Combine(directory, name + ".ready");
    File.Delete(ready);
    var child = Start("--server", settings, ready);
    for (var attempt = 0; attempt < 150; attempt++)
    {
        if (File.Exists(ready)) return (await File.ReadAllTextAsync(ready)).Trim();
        if (child.HasExited) throw new InvalidOperationException("A fixture web process stopped before readiness.");
        await Task.Delay(100);
    }
    throw new TimeoutException("A fixture web process did not become ready.");
}
async Task Publish(string store, string order)
{
    using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(15));
    var child = Start("--publish", args[1], store, order);
    await child.WaitForExitAsync(deadline.Token);
    Check(child.ExitCode == 0, "actual resend task publishes from an independent process");
}
try
{
    var first = await Server(args[1], "first");
    var second = await Server(args[1], "second");
    var foreign = Path.Combine(directory, "foreign.json");
    var foreignSettings = new Dictionary<string, object> {
        ["Fixture"] = new { Enabled = true }, ["Provisioning"] = new { ManagedRuntime = true },
        ["Redis"] = new { RedisPubSubConnectionString = config["Redis:RedisPubSubConnectionString"] },
        ["PlatformSignalR"] = new { Provider = "Redis", DeploymentId = config["PlatformSignalR:DeploymentId"] + "-foreign" }
    };
    await File.WriteAllTextAsync(foreign, JsonSerializer.Serialize(foreignSettings));
    if (!System.OperatingSystem.IsWindows()) File.SetUnixFileMode(foreign, UnixFileMode.UserRead | UnixFileMode.UserWrite);
    var other = await Server(foreign, "foreign");
    await using var a = await SocketProbe.Connect(first, "a", "store-a");
    await using var b = await SocketProbe.Connect(first, "b", "store-b");
    await using var replica = await SocketProbe.Connect(second, "a", "store-a");
    await using var otherDeployment = await SocketProbe.Connect(other, "a", "store-a");
    Check(await a.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)) && await b.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)) &&
        await replica.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)) && await otherDeployment.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)), "real WebSocket clients join their authenticated store groups on separate web processes");
    await using var anonymous = await SocketProbe.Connect(first, "", "store-a");
    Check(!await anonymous.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)), "anonymous hub connections are rejected");
    await using var denied = await SocketProbe.Connect(first, "denied", "store-a");
    Check(!await denied.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)), "a customer without Orders permission cannot join");
    await using var crossStore = await SocketProbe.Connect(first, "a", "store-b");
    Check(!await crossStore.Ready.Task.WaitAsync(TimeSpan.FromSeconds(5)), "a mismatching current store cannot join another store group");
    var firstOrder = "order-a-" + Guid.NewGuid().ToString("N");
    await Publish("store-a", firstOrder);
    Check(await a.Next() == firstOrder && await replica.Next() == firstOrder, "the actual resend task reaches both admin replicas through Redis");
    Check(!await b.HasMessage() && !await otherDeployment.HasMessage(), "another tenant and another deployment receive no foreign message");
    var secondOrder = "order-b-" + Guid.NewGuid().ToString("N");
    await Publish("store-b", secondOrder);
    Check(await b.Next() == secondOrder && !await a.HasMessage() && !await replica.HasMessage(), "tenant B delivery remains isolated from tenant A");
    // Preserve the connected clients while the one-shot task process restarts for its next batch.
    var thirdOrder = "order-a-" + Guid.NewGuid().ToString("N");
    await Publish("store-a", thirdOrder);
    Check(await a.Next() == thirdOrder && await replica.Next() == thirdOrder, "a fresh task process can deliver to already connected web clients");
    var rejectedNotifications = new NotificationFixture();
    var unsupported = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> {
        ["Provisioning:ManagedRuntime"] = "true", ["PlatformSignalR:Provider"] = "InProcess" }).Build();
    var rejected = false;
    try { await new ResendUnseenNotificationsTask(rejectedNotifications, null!, null!, Microsoft.Extensions.Logging.Abstractions.NullLogger<ResendUnseenNotificationsTask>.Instance, unsupported).Execute(); }
    catch (InvalidOperationException) { rejected = true; }
    Check(rejected && rejectedNotifications.SendCount == 0, "managed in-process transport fails before recording any notification send");
    var failedNotifications = new NotificationFixture { Notification = new FamizyoOrderNotification { StoreId = "store-a", OrderId = "fixture-failed", Id = "notice-failed" } };
    var failedClient = Stub.For<IClientProxy>((method, _) => method.Name == "SendCoreAsync" ? Task.FromException(new IOException("fixture delivery unavailable")) : throw new NotSupportedException());
    var failedClients = Stub.For<IHubClients>((method, _) => method.Name == "Group" ? failedClient : throw new NotSupportedException());
    var failedHub = Stub.For<IHubContext<NotificationHub>>((method, _) => method.Name == "get_Clients" ? failedClients : throw new NotSupportedException());
    var onlyStore = Stub.For<IStoreService>((method, _) => method.Name == "GetAllStores" ? Task.FromResult<IList<Store>>([new Store { Id = "store-a" }]) : throw new NotSupportedException());
    var failed = false;
    try { await new ResendUnseenNotificationsTask(failedNotifications, onlyStore, failedHub, Microsoft.Extensions.Logging.Abstractions.NullLogger<ResendUnseenNotificationsTask>.Instance, config).Execute(); }
    catch (IOException) { failed = true; }
    Check(failed && failedNotifications.SendCount == 0, "delivery failure propagates to the scheduler without incrementing the send count");
    Console.WriteLine("PASS: " + checks + " distributed SignalR checks; real Redis and WebSockets with controlled identity fixtures; no external notifications.");
}
finally
{
    foreach (var child in children)
    {
        if (!child.HasExited) child.Kill(entireProcessTree: true);
        await child.WaitForExitAsync(); child.Dispose();
    }
}
static string IdentityStore(HttpContext context) => context.Request.Headers["X-Fixture-Identity"] == "b" ? "store-b" : "store-a";

public sealed class NotificationFixture : IOrderNotificationService
{
    public FamizyoOrderNotification? Notification { get; init; }
    public int SendCount { get; private set; }
    public Task<IList<FamizyoOrderNotification>> GetNotificationsToResendAsync(string storeId) => Task.FromResult<IList<FamizyoOrderNotification>>(
        Notification?.StoreId == storeId ? [Notification] : []);
    public Task IncrementSendCountAsync(string id) { SendCount++; return Task.CompletedTask; }
    public Task<FamizyoOrderNotification> CreateOrderNotificationAsync(string orderId, string storeId) => throw new NotSupportedException();
    public Task MarkAsViewedAsync(string id, string customer) => throw new NotSupportedException();
    public Task MarkAsInteractedAsync(string id, string customer) => throw new NotSupportedException();
    public Task<FamizyoOrderNotification> GetNotificationByOrderIdAsync(string orderId) => throw new NotSupportedException();
}
public class Stub : DispatchProxy
{
    private Func<MethodInfo, object?[]?, object?> invoke = null!;
    public static T For<T>(Func<MethodInfo, object?[]?, object?> invoke) where T : class
    { var proxy = Create<T, Stub>(); ((Stub)(object)proxy).invoke = invoke; return proxy; }
    protected override object? Invoke(MethodInfo? targetMethod, object?[]? args) => invoke(targetMethod!, args);
}
public sealed class ReadyFilter : IHubFilter
{
    public async Task OnConnectedAsync(HubLifetimeContext context, Func<HubLifetimeContext, Task> next)
    {
        await next(context);
        if (!context.Context.ConnectionAborted.IsCancellationRequested) await context.Hub.Clients.Caller.SendAsync("FixtureReady");
    }
}
public sealed class SocketProbe : IAsyncDisposable
{
    private readonly ClientWebSocket socket = new();
    private readonly Channel<string> messages = Channel.CreateUnbounded<string>();
    private readonly CancellationTokenSource stop = new();
    private Task reader = Task.CompletedTask;
    public TaskCompletionSource<bool> Ready { get; } = new(TaskCreationOptions.RunContinuationsAsynchronously);
    public static async Task<SocketProbe> Connect(string origin, string identity, string store)
    {
        var result = new SocketProbe();
        result.socket.Options.SetRequestHeader("X-Fixture-Identity", identity);
        result.socket.Options.SetRequestHeader("X-Fixture-Store", store);
        using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(5));
        await result.socket.ConnectAsync(new Uri(origin.Replace("http://", "ws://") + "/notificationhub"), deadline.Token);
        await result.socket.SendAsync(Encoding.UTF8.GetBytes("{\"protocol\":\"json\",\"version\":1}\u001e"), WebSocketMessageType.Text, true, deadline.Token);
        result.reader = result.Read(); return result;
    }
    private async Task Read()
    {
        var buffer = new byte[8192]; var pending = "";
        try
        {
            while (!stop.IsCancellationRequested)
            {
                var read = await socket.ReceiveAsync(buffer, stop.Token);
                if (read.MessageType == WebSocketMessageType.Close) break;
                pending += Encoding.UTF8.GetString(buffer, 0, read.Count);
                if (pending.Length > 65536) throw new InvalidOperationException("Fixture SignalR frame limit exceeded.");
                while (pending.IndexOf('\u001e') is var end && end >= 0)
                {
                    var frame = pending[..end]; pending = pending[(end + 1)..];
                    using var json = JsonDocument.Parse(frame);
                    if (!json.RootElement.TryGetProperty("type", out var type)) continue;
                    if (type.GetInt32() == 7) return;
                    if (type.GetInt32() != 1) continue;
                    var target = json.RootElement.GetProperty("target").GetString();
                    if (target == "FixtureReady") Ready.TrySetResult(true);
                    if (target == NotificationDefaults.NotificationClientNewOrderMethodName)
                        messages.Writer.TryWrite(json.RootElement.GetProperty("arguments")[0].GetString()!);
                }
            }
        }
        catch (Exception) when (stop.IsCancellationRequested) { }
        finally { Ready.TrySetResult(false); messages.Writer.TryComplete(); }
    }
    public async Task<string> Next() { using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(5)); return await messages.Reader.ReadAsync(deadline.Token); }
    public async Task<bool> HasMessage()
    { using var deadline = new CancellationTokenSource(TimeSpan.FromMilliseconds(300)); try { await messages.Reader.ReadAsync(deadline.Token); return true; } catch (OperationCanceledException) { return false; } }
    public async ValueTask DisposeAsync() { stop.Cancel(); socket.Abort(); try { await reader; } catch { } socket.Dispose(); stop.Dispose(); }
}
