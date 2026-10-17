using System.Net.WebSockets;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;

namespace Grand.Infrastructure.Caching.Redis;

/// <summary>Each authenticated device observes its own bounded cursor; Redis remains the recovery source.</summary>
public sealed class ClientCacheSocket(TenantCacheJournal journal, ILogger<ClientCacheSocket> logger)
{
    public const string Protocol = "stale-cache-websocket-protocol";

    public async Task ServeAsync(HttpContext context, string store, string customer, TimeSpan lifetime)
    {
        if (!journal.Enabled || journal.CurrentStore() != store || journal.CurrentCustomer() != customer || lifetime <= TimeSpan.Zero || lifetime > TimeSpan.FromHours(1))
            throw new InvalidOperationException("Open client cache transport only in the verified current customer/store context.");
        using var socket = await context.WebSockets.AcceptWebSocketAsync(context.WebSockets.WebSocketRequestedProtocols.Contains(Protocol) ? Protocol : null);
        using var stop = CancellationTokenSource.CreateLinkedTokenSource(context.RequestAborted);
        stop.CancelAfter(lifetime);
        var sent = new Dictionary<string, string>(StringComparer.Ordinal);
        async Task Publish()
        {
            while (!stop.IsCancellationRequested && socket.State == WebSocketState.Open)
            {
                var current = await journal.ChangedAsync(store, customer);
                var changed = current.Where(x => sent.GetValueOrDefault(x.CorrelationId) != x.Revision).ToArray();
                foreach (var batch in changed.Chunk(100))
                {
                    var payload = JsonSerializer.SerializeToUtf8Bytes(new { correlationIds = batch.Select(x => x.CorrelationId), timestamp = DateTime.UtcNow });
                    await socket.SendAsync(payload.AsMemory(), WebSocketMessageType.Text, true, stop.Token);
                    foreach (var notice in batch) sent[notice.CorrelationId] = notice.Revision;
                }
                var retained = current.Select(x => x.CorrelationId).ToHashSet(StringComparer.Ordinal);
                foreach (var key in sent.Keys.Where(x => !retained.Contains(x)).ToArray()) sent.Remove(key);
                await Task.Delay(TimeSpan.FromSeconds(5), stop.Token);
            }
        }
        async Task Receive()
        {
            // This is a server-to-client stream. Client frames cannot choose owners or consume shared receipts.
            var buffer = new byte[256];
            var result = await socket.ReceiveAsync(buffer.AsMemory(), stop.Token);
            if (result.MessageType != WebSocketMessageType.Close)
                throw new InvalidOperationException("Client cache transport does not accept client data frames.");
        }
        var publish = Publish(); var receive = Receive();
        var close = WebSocketCloseStatus.NormalClosure;
        try { await await Task.WhenAny(publish, receive); }
        catch (OperationCanceledException) when (stop.IsCancellationRequested) { }
        catch (WebSocketException) { }
        catch (InvalidOperationException) { close = WebSocketCloseStatus.PolicyViolation; }
        catch (RedisException error) { logger.LogWarning("Client cache stream unavailable ({ErrorType}).", error.GetType().Name); close = WebSocketCloseStatus.InternalServerError; }
        finally
        {
            stop.Cancel();
            try { await Task.WhenAll(publish, receive); } catch (Exception error) when (error is OperationCanceledException or WebSocketException or RedisException or InvalidOperationException) { }
            if (socket.State is WebSocketState.Open or WebSocketState.CloseReceived)
            {
                using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(2));
                try { await socket.CloseOutputAsync(close, "Reconnect with current credentials.", deadline.Token); } catch (Exception error) when (error is OperationCanceledException or WebSocketException) { }
            }
        }
    }
}
