using System.Security.Cryptography;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Platform.Provisioning;
using SaasManager.Application.AppBuilds;
using SaasManager.Application.AppBuilds.Queries.DownloadBuild;
using SaasManager.Application.AppBuilds.Queries.GetAppBuildList;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using NotFoundException = Ardalis.GuardClauses.NotFoundException;

namespace SaasManager.Infrastructure;

public sealed class PortableAppBuilds(IApplicationDbContext db,IProvisioningQueue onboarding,AndroidBuildQueue builds,IConfiguration config):IPortableAppBuilds
{
    private string Deployment=>config["Provisioning:DeploymentId"]??"";
    private bool AndroidEnabled=>config["Provisioning:Mobile:Provider"] is "AndroidAppDistribution" or "AndroidIosAppDistribution";
    public async Task<PortableBuildState> StateAsync(BusinessApp app,CancellationToken ct)
    {
        if(!AndroidEnabled)return new(false,false,app.BuildNumber+1,"Bu kurulumda mobil derleme hizmeti etkin değil.");
        var original=await onboarding.GetAsync(app.BusinessId.ToString("N"),ct);
        if(original?.State!="Succeeded" || original.Request.DeploymentId!=Deployment ||
            !original.Steps.TryGetValue("mobile-android-release",out var first) ||
            !int.TryParse(first.Resources.GetValueOrDefault("buildNumber"),out var initial))
            return new(false,false,app.BuildNumber+1,"İlk mobil uygulamanızın kurulumu devam ediyor. Kurulum tamamlanınca yeniden derleyebilirsiniz.");
        var jobs=await builds.ListAsync(app.BusinessId.ToString("N"),ct);
        var busy=jobs.Any(j=>j.State is "Pending" or "Running");
        return new(true,busy,Math.Max(initial,jobs.Select(j=>j.BuildNumber).DefaultIfEmpty(0).Max())+1,null);
    }
    public async Task<NewBuildDto> EnqueueAsync(BusinessApp app,NewBuildDto request,CancellationToken ct)
    {
        var state=await StateAsync(app,ct);
        if(!state.Ready || request.Version!=app.Version)throw new ProvisioningConflictException();
        var job=await builds.EnqueueAsync(request.RequestId,app.BusinessId.ToString("N"),app.Id,Deployment,request.BuildNumber,ct);
        return new(){RequestId=job.Id,BusinessAppId=app.Id,Version=app.Version,BuildNumber=job.BuildNumber,BuildStatus=Status(job.State)};
    }
    public async Task<AppBuildList> ListAsync(Guid business,int page,int size,CancellationToken ct)
    {
        var app=await db.BusinessApps.FirstOrDefaultAsync(a=>a.BusinessId==business && a.Type==AppType.CustomerMobile && !a.IsDeleted,ct);
        var rows=new List<AppBuildDto>();
        if(app!=null && AndroidEnabled)
        {
            var original=await onboarding.GetAsync(business.ToString("N"),ct);
            if(original?.Request.DeploymentId==Deployment && original.Steps.TryGetValue("mobile-android-release",out var initial))
                rows.Add(Row(app.Id,app.Version,initial,original.UpdatedAt.UtcDateTime));
            foreach(var job in await builds.ListAsync(business.ToString("N"),ct))
                if(job.AppId==app.Id && job.DeploymentId==Deployment)
                    rows.Add(job.Receipt is {} receipt ? Row(job.Id,app.Version,receipt,job.UpdatedAt.UtcDateTime) :
                        new(){Id=job.Id,Platform="Android",Version=app.Version,BuildNumber=job.BuildNumber,BuildStatus=Status(job.State),BuildDate=job.CreatedAt.UtcDateTime});
        }
        return new(new PaginatedList<AppBuildDto>(rows.OrderByDescending(x=>x.BuildNumber).Skip((page-1)*size).Take(size).ToArray(),rows.Count,page,size));
    }
    private static string Status(string state)=>state switch{"Pending"=>"Queued","Running"=>"Building","Succeeded"=>"Built",_=>"Failed"};
    private static AppBuildDto Row(Guid id,string version,ProvisioningStepResult receipt,DateTime date)=>new()
    {Id=id,Platform="Android",Version=version,BuildNumber=int.Parse(receipt.Resources["buildNumber"],System.Globalization.CultureInfo.InvariantCulture),BuildStatus="Built",BuildDate=date,
        FileSize=long.TryParse(receipt.Resources.GetValueOrDefault("fileSize"),out var size)?size:0};
    public async Task<DownloadAppBuildResponse> DownloadAsync(Guid business,Guid build,CancellationToken ct)
    {
        var app=await db.BusinessApps.FirstOrDefaultAsync(a=>a.BusinessId==business && a.Type==AppType.CustomerMobile && !a.IsDeleted,ct);
        if(app==null || !AndroidEnabled)throw new NotFoundException("AppBuild",build.ToString());
        ProvisioningStepResult? receipt=null;
        if(build==app.Id)
        {
            var first=await onboarding.GetAsync(business.ToString("N"),ct);
            if(first?.Request.DeploymentId==Deployment)receipt=first.Steps.GetValueOrDefault("mobile-android-release");
        }
        else
        {
            var job=(await builds.ListAsync(business.ToString("N"),ct)).SingleOrDefault(j=>j.Id==build && j.AppId==app.Id && j.DeploymentId==Deployment && j.State=="Succeeded");
            receipt=job?.Receipt;
        }
        var digest=receipt?.Resources.GetValueOrDefault("sha256");
        var root=config["Provisioning:Mobile:ArtifactDirectory"];
        if(digest==null || !Regex.IsMatch(digest,"^[a-f0-9]{64}\\z") || root==null || !Path.IsPathFullyQualified(root) || Path.GetFullPath(root)==Path.GetPathRoot(root))
            throw new NotFoundException("AppBuild",build.ToString());
        var path=Path.Combine(root,business.ToString("N"),digest+".apk");
        for(FileSystemInfo? item=new FileInfo(path);item!=null;item=item is FileInfo file?file.Directory:((DirectoryInfo)item).Parent)
            if(item.LinkTarget!=null)throw new InvalidOperationException("Release artifacts cannot contain symbolic links.");
        var input=new FileStream(path,FileMode.Open,FileAccess.Read,FileShare.Read);
        try
        {
            if(input.Length is <1 or >536870912 || Convert.ToHexString(await SHA256.HashDataAsync(input,ct)).ToLowerInvariant()!=digest)
                throw new InvalidOperationException("The Android artifact no longer matches its verified release receipt.");
            input.Position=0;
            return new(){FileStream=input,MimeType="application/vnd.android.package-archive",FileName=$"app-{receipt!.Resources["buildNumber"]}.apk"};
        }
        catch{await input.DisposeAsync();throw;}
    }
}
