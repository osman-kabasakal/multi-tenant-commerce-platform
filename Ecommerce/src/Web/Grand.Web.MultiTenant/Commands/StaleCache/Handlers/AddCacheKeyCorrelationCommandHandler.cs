using Grand.Data;
using Grand.Domain.Cache;
using Grand.Infrastructure;
using Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using MediatR;
using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Handlers;

public class AddCacheKeyCorrelationCommandHandler : IRequestHandler<AddCacheKeyCorrelationCommand>
{
    private readonly IRepository<CacheKeyCorrelation> _cacheKeyCorrelationRepository;
    private readonly IWorkContext _workContext;

    public AddCacheKeyCorrelationCommandHandler(IRepository<CacheKeyCorrelation> cacheKeyCorrelationRepository,
        IWorkContext workContext
        )
    {
        _cacheKeyCorrelationRepository = cacheKeyCorrelationRepository;
        _workContext = workContext;
    }
    public Task Handle(AddCacheKeyCorrelationCommand request, CancellationToken cancellationToken)
    {
        return _cacheKeyCorrelationRepository.InsertAsync(new CacheKeyCorrelation
        {
            CustomerId = _workContext.CurrentCustomer?.Id,
            CorrelationId = request.CorrelationId,
            CacheKeys = request.CacheKeys,
            CreatedAt = DateTime.UtcNow
        });
    }
}
