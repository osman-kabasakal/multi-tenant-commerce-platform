// using Grand.Infrastructure;
// using Microsoft.AspNetCore.Mvc;
// using System;
// using System.Collections.Concurrent;
// using System.Net.WebSockets;
// using System.Text;
// using System.Text.Json;
// using System.Threading;
// using System.Threading.Tasks;
// using StackExchange.Redis;
// using Microsoft.Extensions.Logging;
// using Grand.Infrastructure.Caching.Redis;
// using Grand.Web.Common.Controllers;
// using System.Collections.Generic;
//
// namespace Grand.Web.MultiTenant.Controllers
// {
//     /// <summary>
//     /// WebSocket controller for FCM notifications - one-way data flow from server to client
//     /// </summary>
//     [ApiController]
//     [Route("api/ws/fcm")]
//     public class FcmWebSocketController : BasePublicController
//     {
//         private readonly IConnectionMultiplexer _redis;
//         private readonly IWorkContext _workContext;
//         private readonly ILogger<FcmWebSocketController> _logger;
//
//         private static readonly ConcurrentDictionary<string, ConcurrentDictionary<WebSocket, string>> _connections =
//             new ConcurrentDictionary<string, ConcurrentDictionary<WebSocket, string>>();
//
//         private static readonly SemaphoreSlim _processingLock = new SemaphoreSlim(1, 1);
//         private static Timer _processingTimer;
//         private static bool _isProcessing = false;
//         private static readonly TimeSpan _processingInterval = TimeSpan.FromSeconds(2);
//         private static readonly TimeSpan _disconnectTimeout = TimeSpan.FromSeconds(2);
//
//         public FcmWebSocketController(
//             IConnectionMultiplexer redis,
//             IWorkContext workContext,
//             ILogger<FcmWebSocketController> logger)
//         {
//             _redis = redis;
//             _workContext = workContext;
//             _logger = logger;
//
//             // Ensure processing timer is started
//             if (_processingTimer == null)
//             {
//                 _processingTimer = new Timer(async _ => await ProcessFcmQueueAsync(), null, _processingInterval,
//                     _processingInterval);
//             }
//         }
//
//         /// <summary>
//         /// WebSocket endpoint for FCM notifications
//         /// </summary>
//         [HttpGet("")]
//         public async Task Get()
//         {
//             if (HttpContext.WebSockets.IsWebSocketRequest)
//             {
//                 var customerId = _workContext.CurrentCustomer.Id;
//
//                 // Tenant ID from the HTTP context
//                 if (!HttpContext.Items.TryGetValue("StoreId", out var storeIdObj) || storeIdObj == null)
//                 {
//                     HttpContext.Response.StatusCode = 400; // Bad request
//                     return;
//                 }
//
//                 string tenantId = storeIdObj.ToString();
//
//                 using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();
//                 await HandleWebSocketConnection(webSocket, tenantId, customerId);
//             }
//             else
//             {
//                 HttpContext.Response.StatusCode = 400; // Bad request
//             }
//         }
//
//         /// <summary>
//         /// Handles a WebSocket connection for a specific customer and tenant
//         /// </summary>
//         private async Task HandleWebSocketConnection(WebSocket webSocket, string tenantId, string customerId)
//         {
//             // Add connection to active connections
//             var connectionId = $"{tenantId}:{customerId}";
//             _connections.AddOrUpdate(connectionId,
//                 _ => new ConcurrentDictionary<WebSocket, string>() { [webSocket] = DateTime.UtcNow.ToString("o") },
//                 (_, connections) =>
//                 {
//                     connections[webSocket] = DateTime.UtcNow.ToString("o");
//                     return connections;
//                 });
//
//             _logger.LogInformation("WebSocket connection established for customer {CustomerId} in tenant {TenantId}",
//                 customerId, tenantId);
//
//             try
//             {
//                 // Keep connection open until client disconnects
//                 var buffer = new byte[1024];
//                 while (webSocket.State == WebSocketState.Open)
//                 {
//                     // This is primarily a one-way channel, but we need to listen for close messages
//                     var result = await webSocket.ReceiveAsync(
//                         new ArraySegment<byte>(buffer), CancellationToken.None);
//
//                     if (result.MessageType == WebSocketMessageType.Close)
//                     {
//                         await webSocket.CloseAsync(
//                             WebSocketCloseStatus.NormalClosure,
//                             "Connection closed by client",
//                             CancellationToken.None);
//                         break;
//                     }
//                 }
//             }
//             catch (Exception ex) when (ex is WebSocketException || ex is OperationCanceledException)
//             {
//                 // Normal disconnection, just log at debug level
//                 _logger.LogInformation(ex, "WebSocket connection closed for customer {CustomerId} in tenant {TenantId}",
//                     customerId, tenantId);
//             }
//             catch (Exception ex)
//             {
//                 _logger.LogError(ex,
//                     "Error handling WebSocket connection for customer {CustomerId} in tenant {TenantId}",
//                     customerId, tenantId);
//             }
//             finally
//             {
//                 // Remove from active connections
//                 if (_connections.TryGetValue(connectionId, out var connections))
//                 {
//                     connections.TryRemove(webSocket, out _);
//
//                     // If no more connections for this customer, remove the customer entry
//                     if (connections.IsEmpty)
//                     {
//                         _connections.TryRemove(connectionId, out _);
//                     }
//                 }
//
//                 // Ensure the socket is closed
//                 if (webSocket.State != WebSocketState.Closed)
//                 {
//                     try
//                     {
//                         // Use a very short timeout to avoid blocking
//                         using var cts = new CancellationTokenSource(_disconnectTimeout);
//                         await webSocket.CloseAsync(
//                             WebSocketCloseStatus.NormalClosure,
//                             "Connection closed by server",
//                             cts.Token);
//                     }
//                     catch
//                     {
//                         // Ignore any errors during socket cleanup
//                     }
//                 }
//
//                 _logger.LogInformation("WebSocket connection removed for customer {CustomerId} in tenant {TenantId}",
//                     customerId, tenantId);
//             }
//         }
//
//         /// <summary>
//         /// Process WebSocket notification queue and send notifications to connected clients
//         /// </summary>
//         private static async Task ProcessFcmQueueAsync()
//         {
//             // Prevent concurrent processing
//             if (_isProcessing || !await _processingLock.WaitAsync(0))
//                 return;
//
//             _isProcessing = true;
//             IConnectionMultiplexer redis = null;
//             ILogger<FcmWebSocketController> logger = null;
//
//             void VaidNextQueue()
//             {
//                 // _isProcessing = false;
//                 // _processingLock.Release();
//             }
//
//             try
//             {
//                 // Get reference to the controller's Redis and logger instances
//                 var instances = HttpContextAccessorExtensions.GetInstances();
//                 if (instances != null &&
//                     instances.TryGetValue(typeof(IConnectionMultiplexer), out var redisObj) &&
//                     instances.TryGetValue(typeof(ILogger<FcmWebSocketController>), out var loggerObj))
//                 {
//                     redis = (IConnectionMultiplexer)redisObj;
//                     logger = (ILogger<FcmWebSocketController>)loggerObj;
//                 }
//
//                 if (redis == null || logger == null)
//                 {
//                     VaidNextQueue();
//                     // Skip processing if we don't have Redis or logger instances
//                     return;
//                 }
//
//                 var db = redis.GetDatabase();
//                 int processedCount = 0;
//                 int maxBatchSize = 30; // Process up to 30 notifications at once for better throughput
//
//                 var listLength = await db.ListLengthAsync("ws:notifications");
//                 if (listLength <= 0)
//                 {
//                     VaidNextQueue();
//                     return;
//                 }
//
//                 var pendingNotificationKeys = await db.ListLeftPopAsync("ws:notifications", listLength);
//
//                 if (pendingNotificationKeys.Length == 0)
//                 {
//                     VaidNextQueue();
//                     return;
//                 }
//
//                 var notificationDatas = new ConcurrentDictionary<RedisValue, Task<RedisValue>>();
//                 var notificationDataBatch = db.CreateBatch();
//                 foreach (var pendingNotificationKey in pendingNotificationKeys)
//                 {
//                     // Get pending notification key from queue
//                     if (pendingNotificationKey.IsNullOrEmpty || notificationDatas.ContainsKey(pendingNotificationKey))
//                         continue;
//                     notificationDatas.TryAdd(pendingNotificationKey,
//                         notificationDataBatch.StringGetAsync(pendingNotificationKey.ToString())
//                         );
//                 }
//
//                 notificationDataBatch.Execute();
//
//                 foreach (var (pendingNotificationKey, pendingData) in notificationDatas)
//                 {
//                     try
//                     {
//                         var pendingNotificationJsonString = (await pendingData).ToString();
//                         if (string.IsNullOrEmpty(pendingNotificationJsonString))
//                         {
//                             await db.KeyDeleteAsync(pendingNotificationKey.ToString());
//                             continue;
//                         }
//
//                         var notificationData = JsonSerializer.Deserialize<Dictionary<string, object>>(
//                             pendingNotificationJsonString
//                         );
//
//                         if (notificationData == null ||
//                             !notificationData.TryGetValue("tenantId", out var tenantIdObj) ||
//                             !notificationData.TryGetValue("customerId", out var customerIdObj) ||
//                             !notificationData.TryGetValue("correlationIds", out var correlationIdsObj))
//                         {
//                             logger?.LogWarning("Invalid WebSocket notification data format: {Key}",
//                                 pendingNotificationKey);
//                             continue;
//                         }
//
//                         // Convert to the correct format for sending to WebSocket clients
//                         var notification = new RedisCacheCoordinator.PendingFcmNotification {
//                             TenantId = tenantIdObj.ToString(),
//                             CustomerId = customerIdObj.ToString(),
//                             CorrelationIds = JsonSerializer.Deserialize<List<string>>(correlationIdsObj.ToString()),
//                             Timestamp = DateTimeOffset.UtcNow
//                         };
//
//                         // Send to connected clients
//                         await SendNotificationToConnectedClientsAsync(notification, logger);
//                         processedCount++;
//
//                         await db.KeyDeleteAsync(pendingNotificationKey.ToString());
//                     }
//                     catch (Exception ex)
//                     {
//                         logger?.LogError(ex, "Error processing WebSocket notification key: {Key}",
//                             pendingNotificationKey);
//
//                         // Put the notification back at the end of the queue, but only retry once
//                         if (!pendingNotificationKey.IsNullOrEmpty)
//                         {
//                             var retryCount = await db.HashGetAsync($"retry:{pendingNotificationKey}", "count");
//                             if (retryCount.IsNull || int.Parse(retryCount) < 2)
//                             {
//                                 // Increment retry count
//                                 await db.HashSetAsync($"retry:{pendingNotificationKey}", "count",
//                                     retryCount.IsNull ? "1" : (int.Parse(retryCount) + 1).ToString());
//                                 await db.KeyExpireAsync($"retry:{pendingNotificationKey}", TimeSpan.FromMinutes(5));
//
//                                 // Add back to queue
//                                 await db.ListRightPushAsync("ws:notifications", pendingNotificationKey);
//                             }
//                             else
//                             {
//                                 // Too many retries, delete
//                                 await db.KeyDeleteAsync($"retry:{pendingNotificationKey}");
//                                 logger?.LogWarning("Dropping WebSocket notification after too many retries: {Key}",
//                                     pendingNotificationKey);
//                             }
//                         }
//                     }
//                 }
//
//                 if (processedCount > 0)
//                 {
//                     logger?.LogInformation("Processed {Count} WebSocket notifications", processedCount);
//                 }
//             }
//             catch (Exception ex)
//             {
//                 logger?.LogError(ex, "Error in WebSocket notification processing loop");
//             }
//             finally
//             {
//                 _isProcessing = false;
//                 _processingLock.Release();
//             }
//         }
//
//         /// <summary>
//         /// Send notification to all connected clients for the specific customer
//         /// </summary>
//         private static async Task SendNotificationToConnectedClientsAsync(
//             RedisCacheCoordinator.PendingFcmNotification notification,
//             ILogger logger)
//         {
//             var connectionId = $"{notification.TenantId}:{notification.CustomerId}";
//
//             // Check if there are any connections for this customer
//             if (!_connections.TryGetValue(connectionId, out var clientConnections) || clientConnections.IsEmpty)
//             {
//                 return;
//             }
//
//             // Prepare notification message
//             var message = new {
//                 type = "cache_invalidation",
//                 tenantId = notification.TenantId,
//                 correlationIds = notification.CorrelationIds,
//                 timestamp = DateTimeOffset.UtcNow.ToString("o")
//             };
//
//             var messageBytes = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(message));
//             var sendTasks = new List<Task>();
//             var failedSockets = new List<WebSocket>();
//
//             // Send to all connected clients for this customer
//             foreach (var clientSocket in clientConnections.Keys)
//             {
//                 if (clientSocket.State != WebSocketState.Open)
//                 {
//                     failedSockets.Add(clientSocket);
//                     continue;
//                 }
//
//                 try
//                 {
//                     // Send asynchronously to avoid blocking on slow clients
//                     sendTasks.Add(clientSocket.SendAsync(
//                         new ArraySegment<byte>(messageBytes),
//                         WebSocketMessageType.Text,
//                         true,
//                         CancellationToken.None));
//                 }
//                 catch (Exception)
//                 {
//                     // Mark for removal
//                     failedSockets.Add(clientSocket);
//                 }
//             }
//
//             // Wait for all sends to complete with a timeout
//             if (sendTasks.Any())
//             {
//                 try
//                 {
//                     // Wait max 1 second for all sends to complete
//                     await Task.WhenAll(sendTasks).WaitAsync(TimeSpan.FromSeconds(sendTasks.Count));
//                 }
//                 catch (Exception ex)
//                 {
//                     logger?.LogWarning(ex, "Some WebSocket sends timed out or failed");
//                 }
//             }
//
//             // Remove any failed connections
//             foreach (var failedSocket in failedSockets)
//             {
//                 clientConnections.TryRemove(failedSocket, out _);
//             }
//
//             // If all connections failed, remove the customer entry
//             if (clientConnections.IsEmpty)
//             {
//                 _connections.TryRemove(connectionId, out _);
//             }
//
//             if (failedSockets.Count > 0)
//             {
//                 logger?.LogInformation("Removed {Count} failed WebSocket connections for customer {CustomerId}",
//                     failedSockets.Count, notification.CustomerId);
//             }
//
//             logger?.LogInformation("Sent WebSocket notification to {Count} connections for customer {CustomerId}",
//                 sendTasks.Count, notification.CustomerId);
//         }
//     }
//
//     /// <summary>
//     /// Helper class to access HttpContext and service instances from static methods
//     /// </summary>
//     public static class HttpContextAccessorExtensions
//     {
//         private static Dictionary<Type, object> _serviceInstances = new Dictionary<Type, object>();
//
//         public static void RegisterInstance<T>(T instance) where T : class
//         {
//             _serviceInstances[typeof(T)] = instance;
//         }
//
//         public static Dictionary<Type, object> GetInstances()
//         {
//             return _serviceInstances;
//         }
//     }
// }