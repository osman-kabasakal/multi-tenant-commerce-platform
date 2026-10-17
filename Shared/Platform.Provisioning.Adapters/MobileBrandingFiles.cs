namespace Platform.Provisioning.Adapters;

public static class MobileBrandingFiles
{
    public static async Task ExportAsync(MobileBrandingStore? store,string tenant,MobileBranding? branding,string inputs,CancellationToken ct)
    {
        if(branding==null)return;
        branding.Validate();if(store==null)throw new InvalidOperationException("Configure the shared branding store.");
        var directory=Path.Combine(inputs,"branding");MobileReleaseFiles.PrivateDirectory(directory);
        foreach(var digest in new[]{branding.Android.Logo,branding.Android.Icon,branding.Android.Splash,branding.Ios.Logo,branding.Ios.Icon,branding.Ios.Splash}.Distinct())
            await MobileReleaseFiles.WriteAsync(Path.Combine(directory,digest+".image"),await store.ReadAsync(tenant,digest,ct),ct);
    }
}
