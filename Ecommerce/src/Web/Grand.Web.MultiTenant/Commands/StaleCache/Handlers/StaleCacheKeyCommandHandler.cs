// using FirebaseAdmin.Messaging;
// using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
// using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
// using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
// using Grand.Business.Marketing.Services.PushNotifications;
// using Grand.Business.Tenants.Constants.Hangfire;
// using Grand.Business.Tenants.Extensions;
// using Grand.Business.Tenants.Services.Hangfire;
// using Grand.Data;
// using Grand.Data.Mongo;
// using Grand.Domain.Cache;
// using Grand.Domain.PushNotifications;
// using Grand.Domain.Tenants;
// using Grand.Infrastructure.Caching;
// using Grand.Infrastructure.Events;
// using Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;
// using Grand.Web.MultiTenant.Commands.StaleCache.Models;
// using Hangfire;
// using MediatR;
// using Microsoft.AspNetCore.Http;
// using Microsoft.Extensions.DependencyInjection;
// using Microsoft.Extensions.Logging;
// using MongoDB.Bson;
// using MongoDB.Driver;
// using MongoDB.Driver.Linq;
// using System;
// using System.Linq.Expressions;
// using System.Text.Json;
// using System.Text.RegularExpressions;
//
// namespace Grand.Web.MultiTenant.Commands.StaleCache.Handlers;
//
// public class StaleCacheKeyCommandHandler : IRequestHandler<StaleCacheKeyCommand>
// {
//     private readonly IServiceProvider _serviceProvider;
//     private readonly ILogger<StaleCacheKeyCommandHandler> _logger;
//     private readonly IHttpContextAccessor _httpContextAccessor;
//     private readonly IKeycloakClientService _keycloakClientService;
//     private readonly KeycloakSettings _keycloakSettings;
//     private readonly ICacheBase _cacheBase;
//
//     public StaleCacheKeyCommandHandler(
//         IServiceProvider serviceProvider,
//     ILogger<StaleCacheKeyCommandHandler> logger,
//     IHttpContextAccessor httpContextAccessor,
//     IKeycloakClientService keycloakClientService,
//     KeycloakSettings keycloakSettings,
//     ICacheBase cacheBase
//     )
//     {
//         this._serviceProvider = serviceProvider;
//         _logger = logger;
//         this._httpContextAccessor = httpContextAccessor;
//         this._keycloakClientService = keycloakClientService;
//         this._keycloakSettings = keycloakSettings;
//         this._cacheBase = cacheBase;
//     }
//     public async Task Handle(StaleCacheKeyCommand request, CancellationToken cancellationToken)
//     {
//         if (string.IsNullOrEmpty(request.CacheKey)) return;
//
//         var tenantId = request.CacheKey.Split(".");
//
//         if (tenantId.Length <= 1)
//             return;
//
//         if (_httpContextAccessor.HttpContext == null || _httpContextAccessor.HttpContext.Items["StoreId"] == null)
//         {
//             var groups = await _cacheBase.GetAsync("groups", async () =>
//                     {
//                         //TODO: bu listeyi tenant managerdan çekmem lazım
//                         return await _keycloakClientService.GetKeycloakClientAsync().GetGroupHierarchyAsync(_keycloakSettings.Realm, cancellationToken: cancellationToken);
//                     });
//             var tenantDb = groups.Where(x => x.Attributes.ContainsKey("StoreMongoConnectionString") &&
//             x.Attributes["StoreMongoConnectionString"].Count() > 0 &&
//             x.Attributes["StoreId"].FirstOrDefault() == tenantId[0]).Select(x => new DataSettings() {
//                 ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
//                 DbProvider = DbProvider.MongoDB
//             }).FirstOrDefault();
//
//             BackgroundJob.Enqueue(HangfireConstants.FrontendQueue,
//                 () => StaleCacheKeyCommandHandler.StaleCacheBackgroundJob(
//                     new MultitenantTaskContext<StaleCacheKeyCommand>() {
//                         JobArgs = request,
//                         TenantDbSettings = tenantDb
//                     }, JobCancellationToken.Null));
//         }
//         else if (_httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var contextTenantId) && contextTenantId?.ToString() == tenantId[0])
//         {
//             BackgroundJob.Enqueue(HangfireConstants.FrontendQueue,
//                 () => StaleCacheKeyCommandHandler.StaleCacheBackgroundJob(
//                     new MultitenantTaskContext<StaleCacheKeyCommand>() {
//                         JobArgs = request,
//                         TenantDbSettings = _httpContextAccessor.HttpContext.GetDataSettings()
//                     }, JobCancellationToken.Null));
//         }
//     }
//     
//     public static async Task StaleCacheBackgroundJob(MultitenantTaskContext<StaleCacheKeyCommand> jobContext, IJobCancellationToken jobCancellationToken)
//     {
//         await jobContext.RunInTenantScope(async (scope) =>
//         {
//             await StaleCacheKey(scope.ServiceProvider, jobContext.JobArgs, jobCancellationToken.ShutdownToken,jobContext);
//         } );
//     }
//     
//     private static async Task<bool> StaleCacheKey(IServiceProvider serviceProvider, StaleCacheKeyCommand request,
//         CancellationToken cancellationToken, MultitenantTaskContext<StaleCacheKeyCommand> jobContext)
//     {
//         var _logger = serviceProvider.GetRequiredService<ILogger<StaleCacheKeyCommandHandler>>();
//
//         try
//         {
//             var cacheKeyCorrelationRepository = serviceProvider.GetRequiredService<IRepository<CacheKeyCorrelation>>();
//             var update = Builders<CacheKeyCorrelation>.Update
//                 .Set(x => x.IsStale, true)
//             .AddToSet(x => x.StaleReasons, request.StaleReason);
//
//             if (request.StaleType == CacheEvent.RemovePrefix)
//             {
//                 var regex = new Regex($"^{Regex.Escape(request.CacheKey)}");
//                 
//                 var count = await ((MongoRepository<CacheKeyCorrelation>)cacheKeyCorrelationRepository).Collection.UpdateManyAsync(x=>
//                     !x.IsStale && x.CacheKeys.Any(y => regex.IsMatch(y)), update, cancellationToken: cancellationToken);
//                 if (count.IsModifiedCountAvailable && count.ModifiedCount > 0)
//                 {
//                     BackgroundJob.Enqueue(HangfireConstants.FrontendQueue,
//                         () => StaleCacheKeyCommandHandler.SendMessageBackgroundTask(
//                             new MultitenantTaskContext<StaleCacheKeyCommand>() {
//                                 JobArgs = request,
//                                 TenantDbSettings = jobContext.TenantDbSettings
//                             }, JobCancellationToken.Null));
//                 }
//             }
//             else
//             {
//                 var count = await ((MongoRepository<CacheKeyCorrelation>)cacheKeyCorrelationRepository).Collection.UpdateManyAsync( x => !x.IsStale && x.CacheKeys.Contains(request.CacheKey), update, cancellationToken: cancellationToken);
//                 if (count.IsModifiedCountAvailable && count.ModifiedCount > 0)
//                 {
//                     BackgroundJob.Enqueue(HangfireConstants.FrontendQueue,
//                         () => StaleCacheKeyCommandHandler.SendMessageBackgroundTask(
//                             new MultitenantTaskContext<StaleCacheKeyCommand>() {
//                                 JobArgs = request,
//                                 TenantDbSettings = jobContext.TenantDbSettings
//                             }, JobCancellationToken.Null));
//                 }
//                 // _logger.LogInformation("{CacheKey} is marked as stale by prefix\n Match count: {MatchCount} \n Update count: {UpdateCount}", request.CacheKey, count.MatchedCount, count.ModifiedCount);
//             }
//         }
//         catch (System.Exception e)
//         {
//             _logger.LogError(e, "Error marking cache key as stale");
//         }
//
//         return true;
//     }
//     
//     public static async Task SendMessageBackgroundTask(MultitenantTaskContext<StaleCacheKeyCommand> jobContext, IJobCancellationToken jobCancellationToken)
//     {
//         await jobContext.RunInTenantScope(async (scope) =>
//         {
//             if (jobContext.JobArgs.StaleType == CacheEvent.RemovePrefix)
//             {
//                 var regex = new Regex($"^{Regex.Escape(jobContext.JobArgs.CacheKey)}");
//                 Expression<Func<CacheKeyCorrelation, bool>> filter = x=>
//                     x.IsStale && x.CacheKeys.Any(y => regex.IsMatch(y));
//                 await SendStaleCacheTopicNotification(scope.ServiceProvider, jobContext.JobArgs,filter, jobCancellationToken.ShutdownToken);
//             }
//             else
//             {
//                 Expression<Func<CacheKeyCorrelation, bool>> filter = x => x.IsStale && x.CacheKeys.Contains(jobContext.JobArgs.CacheKey);
//                 await SendStaleCacheTopicNotification(scope.ServiceProvider, jobContext.JobArgs,filter, jobCancellationToken.ShutdownToken);
//             }
//         } );
//     }
//
//     private static async Task SendStaleCacheTopicNotification(IServiceProvider serviceProvider, StaleCacheKeyCommand request,
//         Expression<Func<CacheKeyCorrelation, bool>> filter, CancellationToken cancellationToken)
//     {
//         var _logger = serviceProvider.GetRequiredService<ILogger<StaleCacheKeyCommandHandler>>();
//         var notificationService = serviceProvider.GetRequiredService<IPushNotificationsService>();
//         var pushRegistrationRepository = serviceProvider.GetRequiredService<IRepository<PushRegistration>>();
//         var fcmService = serviceProvider.GetRequiredService<FirebaseService>();
//         
//         var cacheKeyCorrelationRepository = serviceProvider.GetRequiredService<IRepository<CacheKeyCorrelation>>();
//         var cacheKeyCorrelationCustomerIds = cacheKeyCorrelationRepository.Table
//             .Where(filter)
//             .GroupBy(x => x.CustomerId)
//             .ToDictionary(x => x.Key, x => x.Select(a => a.CorrelationId));
//         var customerList = cacheKeyCorrelationCustomerIds.Select(x => x.Key).ToList();
//         var allTokens = await pushRegistrationRepository.Table.Where(x=> customerList.Contains( x.CustomerId)).ToListAsync(cancellationToken);
//         
//
//         foreach (var token in allTokens)
//         {
//
//             var correlationBatch = cacheKeyCorrelationCustomerIds[token.CustomerId].Select((x, i) => new { i, x })
//                 .GroupBy(x => x.i / 10)
//                 .Select(x => x.Select(y => y.x).ToList()).ToList();
//             foreach (var correlationsPart in correlationBatch)
//             {
//                 var notification = new Message()
//                 {
//                     Token = token.Token,
//                     Data = new Dictionary<string, string>
//                     {
//                         {"CorrelationIds", JsonSerializer.Serialize(correlationsPart) },
//                     },
//                 };
//                 var response = await fcmService.SendMessageAsync(notification);
//                 if (response == null)
//                 {
//                     await notificationService.DeletePushReceiver(token);
//                     _logger.LogError("Error sending FCM message to {Token}", token.Token);
//                 }
//                 else
//                 {
//                     _logger.LogInformation("FCM message sent to {Token} with response {Response}", token.Token, response);
//                 }
//             }
//         }
//     }
// }
