using Core.Models.Responses;
using Microsoft.AspNetCore.Http.HttpResults;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Stores.Commands.RegisterStore;

namespace SaasManager.Web.Endpoints;

public class Stores: EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        app.MapGroup(this)
            .MapPost(RegisterStore);
    }
    
    public async Task<Created<ServiceResponse<TenantStatusMessage>>> RegisterStore(ISender sender, RegisterStoreCommand command)
    {
        var id = await sender.Send(command);

        return TypedResults.Created($"/{nameof(Stores)}", id);
    }
}
