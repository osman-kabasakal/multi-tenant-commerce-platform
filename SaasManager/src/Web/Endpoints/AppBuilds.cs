using Core.Models.Responses;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using SaasManager.Application.AppBuilds.Commands.NewBuild;
using SaasManager.Application.AppBuilds.Queries.DownloadBuild;
using SaasManager.Application.AppBuilds.Queries.GetAppBuildList;
using SaasManager.Application.AppBuilds.Queries.GetNewBuildVm;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Application.IdentityManagement.Commands.Registration;

namespace SaasManager.Web.Endpoints;

public class AppBuilds: EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var group=app.MapGroup(this,"app-builds").RequireAuthorization();
        group.MapGet(GetVm,"get-vm");
        group.MapPost("new-build",NewBuild).WithName(nameof(NewBuild)).AddEndpointFilter(async (context,next) =>
        {
            try {await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
            catch(AntiforgeryValidationException) {return Results.BadRequest(new {message="Sayfayı yenileyip tekrar deneyin."});}
            return await next(context);
        });
        group.MapPost(BuildList,"list");
        group.MapGet(DownloadBuild,"download");
    }
    
    public async Task<Ok<ServiceResponse<NewBuildVm>>> GetVm(ISender sender, IAntiforgery antiforgery, IHttpContextAccessor accessor)
    {
        PortalAntiforgery.Issue(accessor.HttpContext!,antiforgery);
        return TypedResults.Ok(await sender.Send(new GetNewBuildVmQuery()));
    }
    
    public async Task<Ok<ServiceResponse<NewBuildDto>>> NewBuild(ISender sender, NewBuildCommand command)
    {
        return TypedResults.Ok(await sender.Send(command));
    }
    
    public async Task<Ok<ServiceResponse<AppBuildList>>> BuildList(ISender sender, GetAppBuildListQuery command)
    {
        return TypedResults.Ok(await sender.Send(command));
    }
    
    public async Task<IResult> DownloadBuild(ISender sender, [AsParameters]DownloadBuildQuery command,HttpContext http,CancellationToken ct)
    {
        var fileResponse = await sender.Send(command,ct);
        http.Response.Headers.CacheControl="private, no-store";
        http.Response.Headers.XContentTypeOptions="nosniff";
        return Results.File(fileResponse.FileStream,fileResponse.MimeType,fileResponse.FileName,enableRangeProcessing:true);
    }
}
