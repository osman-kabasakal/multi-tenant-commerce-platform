using System.Net;
using System.Net.Sockets;
using System.Text.Json;

namespace Platform.Provisioning.Adapters;

public static class TenantIngressProbe
{
    public static async Task WaitForCustomDnsAsync(TenantDomainSelection domain,string originIpv4,CancellationToken ct)
    {
        var expected=IPAddress.Parse(originIpv4);
        foreach(var host in new[]{domain.StoreHost,domain.AdminHost})
        {
            IPAddress[] addresses;
            try{addresses=await Dns.GetHostAddressesAsync(host,ct);}
            catch(SocketException){throw new ProvisioningDeferredException("DomainDnsPropagationPending",TimeSpan.FromSeconds(30));}
            if(addresses.Length==0 || addresses.Any(ip=>!ip.Equals(expected)))
                throw new ProvisioningDeferredException("DomainDnsPropagationPending",TimeSpan.FromSeconds(30));
        }
    }
    public static SocketsHttpHandler CustomHandler(CustomDomainOptions options)
    {
        options.Validate();
        var address=IPAddress.Parse(options.IngressConnectAddress??options.OriginIpv4);
        return new SocketsHttpHandler{AllowAutoRedirect=false,UseProxy=false,ConnectCallback=async(context,ct)=>{
            if(context.DnsEndPoint.Port!=443)throw new InvalidOperationException("Custom ingress probes require HTTPS on port 443.");
            var socket=new Socket(address.AddressFamily,SocketType.Stream,ProtocolType.Tcp);
            try{await socket.ConnectAsync(new IPEndPoint(address,443),ct);return new NetworkStream(socket,ownsSocket:true);}
            catch{socket.Dispose();throw;}
        }};
    }
    public static async Task VerifyAsync(HttpClient ingress,string storeUrl,string adminUrl,string tenantId,string storeId,CancellationToken ct)
    {
        // These are public probes. The gateway must select the tenant and inject its own service token.
        using var response=await ingress.GetAsync(storeUrl+"/_platform/ready",ct);
        if(!response.IsSuccessStatusCode)throw new InvalidOperationException("The tenant ingress is not ready; verify DNS, TLS and runtime routing.");
        using var ready=JsonDocument.Parse(await response.Content.ReadAsStringAsync(ct));
        if(ready.RootElement.GetProperty("tenantId").GetString()!=tenantId || ready.RootElement.GetProperty("storeId").GetString()!=storeId)
            throw new InvalidOperationException("Tenant ingress readiness returned a different tenant.");
        using var adminResponse=await ingress.GetAsync(adminUrl,ct);
        if(!adminResponse.Headers.TryGetValues("X-Platform-Tenant",out var tenants) || tenants.SingleOrDefault()!=tenantId ||
            adminResponse.StatusCode!=HttpStatusCode.Redirect || adminResponse.Headers.Location==null)
            throw new InvalidOperationException("The owned admin host is not ready for authentication.");
        var login=new Uri(new Uri(adminUrl),adminResponse.Headers.Location);
        if(login.Scheme!="https" || login.Authority!=new Uri(adminUrl).Authority || !login.AbsolutePath.EndsWith("/login",StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("The admin host redirected outside its own HTTPS login.");
        using var loginResponse=await ingress.GetAsync(login,ct);
        if(!loginResponse.IsSuccessStatusCode || !loginResponse.Headers.TryGetValues("X-Platform-Tenant",out var loginTenants) || loginTenants.SingleOrDefault()!=tenantId ||
            loginResponse.Content.Headers.ContentType?.MediaType!="text/html")throw new InvalidOperationException("The owned admin login page is not ready.");
    }
}
