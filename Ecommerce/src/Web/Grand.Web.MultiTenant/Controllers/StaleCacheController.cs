using Grand.Web.Common.Controllers;
using Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;

namespace Grand.Web.MultiTenant.Controllers;

public class StaleCacheController(
    IMediator mediator
): BasePublicController
{
    [HttpPost]
    [ProducesResponseType(typeof(StaleCacheResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetStaleCorrelationIds(
        StaleCacheQuery staleCacheQuery
    ){
        if (staleCacheQuery?.StaleCacheItems == null || staleCacheQuery.StaleCacheItems.Count > 100 ||
            staleCacheQuery.StaleCacheItems.Any(item => item == null || string.IsNullOrWhiteSpace(item.CorrelationId) || item.CorrelationId.Length > 64))
            return BadRequest(new { error = "Supply at most one hundred bounded cache correlations." });
        var response = await mediator.Send(staleCacheQuery);
        return Ok(response);
    }
}
