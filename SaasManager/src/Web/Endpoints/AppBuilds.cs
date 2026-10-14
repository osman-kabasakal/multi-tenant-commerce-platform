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
        app.MapGroup(this,"app-builds")
            .RequireAuthorization()
            .MapGet(GetVm,"get-vm")
            .MapPost(NewBuild,"new-build")
            .MapPost(BuildList,"list")
            .MapGet(DownloadBuild,"download");
    }
    
    public async Task<Ok<ServiceResponse<NewBuildVm>>> GetVm(ISender sender, IAntiforgery antiforgery, IHttpContextAccessor accessor)
    {
        antiforgery.SetCookieTokenAndHeader(accessor.HttpContext);
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
    
    public async Task<Ok<FileStreamResult>> DownloadBuild(ISender sender, [AsParameters]DownloadBuildQuery command)
    {
        var fileResponse = await sender.Send(command);
        return TypedResults.Ok(new FileStreamResult(fileResponse.FileStream, fileResponse.MimeType)
        {
            FileDownloadName = fileResponse.FileName
        });
    }
}
