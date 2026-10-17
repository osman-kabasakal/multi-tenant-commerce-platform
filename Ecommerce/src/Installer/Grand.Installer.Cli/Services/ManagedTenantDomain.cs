using System.Text.Json;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Domain.Stores;
using Grand.Infrastructure.MultiTenant;
using Grand.Installer.Cli.Models;
using Microsoft.Extensions.Configuration;
using Platform.Provisioning;

namespace Grand.Installer.Cli.Services;

public static class ManagedTenantDomain
{
    public static async Task<TenantDomainSelection?> VerifyAsync(IConfiguration config,TenantStatusMessage message)
    {
        var output=config["Provisioning:TenantOutput"];
        if(!Guid.TryParseExact(message.TenantId,"N",out var tenant) || tenant==Guid.Empty ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") || string.IsNullOrWhiteSpace(output) || !Path.IsPathFullyQualified(output) ||
            !Uri.TryCreate(config["Provisioning:StoreUrl"],UriKind.Absolute,out var url) || url.Scheme!="https" || !url.IsDefaultPort ||
            url.AbsolutePath!="/" || url.UserInfo.Length!=0 || url.Query.Length!=0 || url.Fragment.Length!=0)
            throw new InvalidOperationException("Portable installation requires owned tenant metadata and an HTTPS store origin.");
        var value=config["Provisioning:VerifiedDomain"];
        if(string.IsNullOrEmpty(value))
        {
            if(!url.Host.StartsWith(message.StoreSubDomain+".",StringComparison.Ordinal))
                throw new InvalidOperationException("A custom installer origin requires its verified ownership record.");
            return null;
        }
        if(value.Length>8192)throw new InvalidOperationException("Invalid bounded domain selection.");
        var selected=JsonSerializer.Deserialize<TenantDomainSelection>(value)??throw new InvalidOperationException("Missing domain selection.");
        selected.Validate();
        await using var registry=new TenantDomainRegistry(config["Provisioning:ConnectionString"]??config["PlatformSecurity:ConnectionString"]??throw new InvalidOperationException("The domain ownership store is required."));
        var binding=await registry.RequireVerifiedAsync(selected.Id,selected.OwnerSubject,message.TenantId,
            config["Provisioning:DeploymentId"]??throw new InvalidOperationException("Use an explicit deployment."));
        if(TenantDomainSelection.From(binding)!=selected || url.GetLeftPart(UriPartial.Authority)!="https://"+selected.StoreHost)
            throw new InvalidOperationException("The custom installer origin differs from its owned domain snapshot.");
        return selected;
    }
    public static async Task UpdateAsync(Store store,IStoreService service,TenantDomainSelection domain,ITenantIdentityAccessor identity)
    {
        if(string.IsNullOrWhiteSpace(store.Id))throw new InvalidOperationException("Use the owned store identity for domain migration.");
        var assigned=string.IsNullOrEmpty(identity.TenantId);
        if(!assigned && identity.TenantId!=store.Id)throw new InvalidOperationException("Domain migration cannot replace another tenant context.");
        if(assigned)identity.TenantId=store.Id;
        try
        {
            var storeUrl="https://"+domain.StoreHost;
            // Keep previous hosts for installed clients and saved links. Only the canonical origin changes.
            if(Uri.TryCreate(store.Url,UriKind.Absolute,out var previous) && !store.Domains.Any(x=>x.HostName==previous.Host))
                store.Domains.Add(new DomainHost{HostName=previous.Host,Url=previous.GetLeftPart(UriPartial.Authority)});
            foreach(var host in store.Domains)host.Primary=false;
            foreach(var (name,url,primary) in new[]{(domain.StoreHost,storeUrl,true),(domain.AdminHost,"https://"+domain.AdminHost,false)})
            {
                var alias=store.Domains.SingleOrDefault(x=>x.HostName==name);
                if(alias==null){alias=new DomainHost{HostName=name};store.Domains.Add(alias);}
                alias.Url=url;alias.Primary=primary;
            }
            store.Url=storeUrl;store.SecureUrl=storeUrl;store.SslEnabled=true;
            await service.UpdateStore(store);
        }
        finally {if(assigned)identity.TenantId=null;}
    }
}
