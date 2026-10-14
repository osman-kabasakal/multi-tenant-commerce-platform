// using Grand.Infrastructure.Caching.Redis;
// using Grand.Web.MultiTenant.Controllers;
// using Microsoft.AspNetCore.Http;
// using Microsoft.Extensions.Logging;
// using StackExchange.Redis;
// using System.Threading.Tasks;
//
// namespace Grand.Web.MultiTenant.Middlewares
// {
//     /// <summary>
//     /// Middleware to register services for WebSocket controllers to use
//     /// </summary>
//     public class WebSocketServiceMiddleware
//     {
//         private readonly RequestDelegate _next;
//         private readonly IConnectionMultiplexer _redis;
//         private readonly ILogger<FcmWebSocketController> _logger;
//
//         public WebSocketServiceMiddleware(
//             RequestDelegate next,
//             IConnectionMultiplexer redis,
//             ILogger<FcmWebSocketController> logger)
//         {
//             _next = next;
//             _redis = redis;
//             _logger = logger;
//             
//             // Register service instances for static access
//             HttpContextAccessorExtensions.RegisterInstance(redis);
//             HttpContextAccessorExtensions.RegisterInstance(logger);
//         }
//
//         public async Task InvokeAsync(HttpContext context)
//         {
//             if (context.Request.Path.Value =="/api/ws/fcm" 
//                 &&context.WebSockets.IsWebSocketRequest
//                 )
//             {
//                 await _next(context);
//             }
//             else
//             {
//                 // Continue the request pipeline
//                 await _next(context);
//             }
//             
//         }
//     }
// }
