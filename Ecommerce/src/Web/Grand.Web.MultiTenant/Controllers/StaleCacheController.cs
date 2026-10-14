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
        var response = await mediator.Send(staleCacheQuery);
        return Ok(response);
    }
}
