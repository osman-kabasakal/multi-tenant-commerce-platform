using Grand.Business.Tenants.Constants.Hangfire;
using Grand.Business.Tenants.Extensions;
using Grand.Business.Tenants.Services.Hangfire;
using Grand.Data;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Extensions;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using Hangfire;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;

namespace Grand.Web.MultiTenant.MiddleWares;

public class ReleatedCacheKeysMiddleware
{
    private readonly RequestDelegate _next;

    public ReleatedCacheKeysMiddleware(RequestDelegate next
    )
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context, ICacheBase cacheBase,
        ICacheTracker cacheTracker, IMediator mediator, ILogger<ReleatedCacheKeysMiddleware> logger,
        IWorkContext workContext)
    {
        if (context.Items.TryGetValue("CorrelationId", out var corId))
        {
            var seName = context.Request.Path.Value.TrimStart('/').ToLower();
            if (seName.ToString().Contains("account/") ||
                seName.ToString().Contains("shoppingcart/") ||
                seName.ToString().Contains("wishlist/") ||
                seName.ToString().Contains("order/")
               )
            {
                var key = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{workContext.CurrentCustomer.Id}.{seName}");
                cacheBase.Get(key, () => true);
            }
        }

        context.Response.OnStarting(async () =>
        {
            // İstek tamamlandığında, URL-önbellek ilişkilerini kaydet
            if (context.Items.TryGetValue("CorrelationId", out var correlationId))
            {
                var relatedCacheTracker = cacheTracker.GetCacheKeysForRequest(correlationId.ToString());
                if (relatedCacheTracker.Any())
                {
                    var jobArg = new MultitenantTaskContext<AddCacheKeyCorrelationCommand>() {
                        CustomerId = workContext.CurrentCustomer?.Id,
                        JobArgs = new AddCacheKeyCorrelationCommand() {
                            CorrelationId = correlationId.ToString(),
                            CacheKeys = [.. relatedCacheTracker]
                        },
                        TenantDbSettings = new DataSettings() {
                            ConnectionString = context.GetConnectionString(),
                            DbProvider = DbProvider.MongoDB
                        }
                    };
                    BackgroundJob.Enqueue(HangfireConstants.AddCorrelationCacheKeyQueue, () =>
                        ReleatedCacheKeysMiddleware.SaveCacheKeysCorrelation(
                            JobCancellationToken.Null, jobArg
                        ));
                }

                cacheTracker.removeCorrelationId(correlationId.ToString());
            }
        });

        await _next(context);
    }

    public static async Task SaveCacheKeysCorrelation(IJobCancellationToken jobCancellationToken,
        MultitenantTaskContext<AddCacheKeyCorrelationCommand> taskContext)
    {
        await taskContext.RunInTenantScope(async (scope) =>
        {
            var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
            var command = taskContext.JobArgs;
            await mediator.Send(command);
        });
    }
}