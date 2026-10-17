using System.Net;
using Platform.Hosting;
using Platform.Security;
using Yarp.ReverseProxy.Forwarder;

namespace Platform.Gateway;

public static class GatewayApp
{
    public static WebApplication Build(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        var path = builder.Configuration["Gateway:ConfigPath"];
        if (!string.IsNullOrWhiteSpace(path)) builder.Configuration.AddJsonFile(path, optional: false);
        builder.Configuration.AddEnvironmentVariables();
        var options = builder.Configuration.GetSection("Gateway").Get<GatewayOptions>() ?? throw new InvalidOperationException("Configure the gateway explicitly.");
        options.Validate(builder.Configuration);
        builder.Services.AddSingleton(options);
        builder.Services.AddPlatformSecurity(builder.Configuration, builder.Environment.EnvironmentName);
        builder.Services.AddTrustedProxy(builder.Configuration);
        builder.Services.AddHttpForwarder();
        builder.Services.AddSingleton<IMobileAssociationSource>(_ => new PostgresMobileAssociationSource(
            builder.Configuration["PlatformSecurity:ConnectionString"] ?? throw new InvalidOperationException("Configure read-only tenant identity storage.")));
        builder.Services.AddSingleton<TenantRoutes>(); builder.Services.AddSingleton<TenantTokens>();
        builder.Services.AddHttpClient("gateway-identity").ConfigurePrimaryHttpMessageHandler(() =>
            PrivateCertificateAuthority.CreateHandler(options.IdentityRootCertificateFile) ?? new SocketsHttpHandler { AllowAutoRedirect = false, UseCookies = false });
        var handler = PrivateCertificateAuthority.CreateHandler(options.UpstreamRootCertificateFile) ?? new SocketsHttpHandler();
        handler.UseCookies = false; handler.UseProxy = false; handler.AllowAutoRedirect = false; handler.AutomaticDecompression = DecompressionMethods.None;
        handler.EnableMultipleHttp2Connections = true; handler.ConnectTimeout = TimeSpan.FromSeconds(15);
        builder.Services.AddSingleton(new HttpMessageInvoker(handler, disposeHandler: true));
        var app = builder.Build();
        app.UseTrustedProxy(app.Configuration);
        app.Run(Forwarder(options, app.Logger));
        return app;
    }

    public static RequestDelegate Forwarder(GatewayOptions options, ILogger logger) => async context => {
        if (context.Request.Path == "/_gateway/health" && context.Connection.RemoteIpAddress is {} address && IPAddress.IsLoopback(address))
        { context.Response.StatusCode = 200; await context.Response.WriteAsync("Healthy"); return; }
        if (context.Request.Path == "/_gateway/certificate-permission")
        {
            context.Response.StatusCode=403;
            if(!options.CustomDomainsEnabled || !IPAddress.TryParse(options.CertificatePermissionPeer,out var peer) ||
                context.Connection.RemoteIpAddress?.Equals(peer)!=true || context.Request.Query["domain"].Count!=1)return;
            try
            {
                var domain=context.Request.Query["domain"].ToString();
                var route=await context.RequestServices.GetRequiredService<TenantRoutes>().ResolveCustomAsync(new HostString(domain),context.RequestAborted);
                if(route!=null)context.Response.StatusCode=204;
            }
            catch(OperationCanceledException)when(context.RequestAborted.IsCancellationRequested){}
            catch{context.Response.StatusCode=403;}
            return;
        }
        if (!context.Request.IsHttps) { context.Response.StatusCode = 400; return; }
        try
        {
            var route = await context.RequestServices.GetRequiredService<TenantRoutes>().ResolveAsync(context.Request.Host, context.RequestAborted);
            if (route == null || (!route.Admin && context.Request.Path.StartsWithSegments("/Admin", StringComparison.OrdinalIgnoreCase)))
            { context.Response.StatusCode = 404; return; }
            if (MobileAssociations.Handles(context.Request.Path))
            {
                await MobileAssociations.WriteAsync(context, route, context.RequestServices.GetRequiredService<IMobileAssociationSource>());
                return;
            }
            var token = route.Admin ? null : await context.RequestServices.GetRequiredService<TenantTokens>().GetAsync(route, context.RequestAborted);
            var error = await context.RequestServices.GetRequiredService<IHttpForwarder>().SendAsync(context,
                route.Admin ? options.AdminUpstream : options.CommerceUpstream, context.RequestServices.GetRequiredService<HttpMessageInvoker>(),
                new ForwarderRequestConfig { ActivityTimeout = TimeSpan.FromMinutes(2) }, new TenantTransformer(route, token));
            if (error != ForwarderError.None && !context.Response.HasStarted) context.Response.StatusCode = 502;
        }
        catch (OperationCanceledException) when (context.RequestAborted.IsCancellationRequested) { }
        catch (Exception error)
        {
            logger.LogWarning("Tenant forwarding failed ({ErrorType}).", error.GetType().Name);
            if (!context.Response.HasStarted) { context.Response.Clear(); context.Response.StatusCode = 503; }
            else context.Abort();
        }
    };
}
