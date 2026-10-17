using Microsoft.EntityFrameworkCore;
using Platform.Provisioning;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Domain.Enums;

namespace SaasManager.Infrastructure;

public sealed class MobileBrandingCapture(IApplicationDbContext db,IBlobStorageService files,MobileBrandingStore images)
{
    public async Task<MobileBranding> CaptureAsync(Guid business,Guid app,CancellationToken ct)
    {
        if(!await db.BusinessApps.AnyAsync(x=>x.Id==app && x.BusinessId==business && !x.IsDeleted,ct))throw new ProvisioningConflictException();
        var assets=await db.AppMediaAssets.AsNoTracking().Where(x=>x.BusinessAppId==app && x.IsDefault && !x.IsDeleted).ToListAsync(ct);
        async Task<string> Read(string platform,AppMediaAssetType type,string? fallback=null)
        {
            var asset=assets.SingleOrDefault(x=>x.Platform==platform && x.AssetType==type);
            if(asset==null)return fallback??throw new ArgumentException("Derleme için işletme logosu ve kare uygulama ikonu yükleyin.");
            var download=await files.DownloadFileAsync(asset.FilePath,ct);
            await using var source=download.Content;
            if(download.Length is <24 or >MobileBrandingStore.MaximumBytes)throw new ArgumentException("Markalama görseli en fazla 5 MiB olabilir.");
            var content=new byte[checked((int)download.Length)];await source.ReadExactlyAsync(content,ct);
            if(await source.ReadAsync(new byte[1],ct)!=0)throw new ArgumentException("Markalama görselinin boyutu değişti.");
            return await images.PutAsync(business.ToString("N"),content,type==AppMediaAssetType.Icon,ct);
        }
        var logo=await Read("android",AppMediaAssetType.Logo);var icon=await Read("android",AppMediaAssetType.Icon);
        var splash=await Read("android",AppMediaAssetType.WelcomeScreen,logo);
        var iosLogo=await Read("ios",AppMediaAssetType.Logo,logo);var iosIcon=await Read("ios",AppMediaAssetType.Icon,icon);
        var iosSplash=await Read("ios",AppMediaAssetType.WelcomeScreen,iosLogo);
        return new(new(logo,icon,splash),new(iosLogo,iosIcon,iosSplash));
    }
}
