using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Platform.Provisioning.Adapters;

public sealed class ReadinessEmailOptions
{
    public string Host { get; init; }="";
    public int Port { get; init; }=587;
    public string FromAddress { get; init; }="";
    public string? UserName { get; init; }
    public string? Password { get; init; }
    public bool EnableStartTls { get; init; }=true;
    public bool AllowPlaintextLoopback { get; init; }
    public TimeSpan Timeout { get; init; }=TimeSpan.FromSeconds(30);
    public TimeSpan LeaseDuration { get; init; }=TimeSpan.FromMinutes(2);
    public TimeSpan PollInterval { get; init; }=TimeSpan.FromSeconds(2);
    public int MaxAttempts { get; init; }=5;
    public void Validate(OnboardingInfrastructureOptions infrastructure,string environment,IConfiguration config)
    {
        var loopback=Host.Equals("localhost",StringComparison.OrdinalIgnoreCase) || IPAddress.TryParse(Host,out var ip) && IPAddress.IsLoopback(ip);
        if(Uri.CheckHostName(Host)==UriHostNameType.Unknown || Port is <1 or >65535 ||
            !MailAddress.TryCreate(FromAddress,out var from) || from.Address!=FromAddress || FromAddress.Any(char.IsControl) ||
            string.IsNullOrWhiteSpace(UserName)!=string.IsNullOrWhiteSpace(Password) || UserName?.Any(char.IsControl)==true ||
            Timeout<TimeSpan.FromSeconds(1) || Timeout>TimeSpan.FromMinutes(2) ||
            LeaseDuration<TimeSpan.FromSeconds(3) || LeaseDuration>TimeSpan.FromMinutes(10) || PollInterval<=TimeSpan.Zero || MaxAttempts<1)
            throw new InvalidOperationException("Configure a valid explicit SMTP sender, endpoint, credentials and bounded worker timings.");
        foreach(var endpoint in new[]{infrastructure.StoreBaseUrl,infrastructure.AdminBaseUrl})
            if(!Uri.TryCreate(endpoint,UriKind.Absolute,out var uri) || uri.AbsolutePath!="/" || !string.IsNullOrEmpty(uri.UserInfo) ||
                !string.IsNullOrEmpty(uri.Query) || !string.IsNullOrEmpty(uri.Fragment) || uri.Host.Contains('*') ||
                (infrastructure.IsLocal?!uri.IsLoopback:uri.Scheme!="https"))
                throw new InvalidOperationException("Configure the original owned store/admin origins for readiness delivery.");
        if(!infrastructure.IsLocal && (infrastructure is not PortableOnboardingOptions portable ||
            !System.Text.RegularExpressions.Regex.IsMatch(portable.DeploymentId,"^[a-z][a-z0-9-]{2,39}$") ||
            new Uri(infrastructure.StoreBaseUrl).Host.Equals(new Uri(infrastructure.AdminBaseUrl).Host,StringComparison.OrdinalIgnoreCase)))
            throw new InvalidOperationException("Portable readiness delivery requires its original deployment and separate public parent domains.");
        if(config.GetValue<bool>("PlatformSecurity:ReadOnly"))throw new InvalidOperationException("The readiness sender must be allowed to select the shared target binding.");
        if(infrastructure.IsLocal)
        {
            if(environment!="Development" || !config.GetValue<bool>("LocalDemo:Enabled") || !loopback)
                throw new InvalidOperationException("Local readiness email must use Development, LocalDemo and a loopback capture server.");
        }
        else if(environment is not ("Production" or "Staging") || config.GetValue<bool>("LocalDemo:Enabled") || !EnableStartTls)
            throw new InvalidOperationException("Portable readiness SMTP requires Production/Staging and validated STARTTLS.");
        if(!EnableStartTls && !(infrastructure.IsLocal && loopback && AllowPlaintextLoopback))
            throw new InvalidOperationException("Plaintext SMTP is permitted only for an explicitly confirmed local capture server.");
    }
    public string Deployment(OnboardingInfrastructureOptions infrastructure)=>infrastructure is PortableOnboardingOptions portable?portable.DeploymentId:"";
    public string Fingerprint(OnboardingInfrastructureOptions infrastructure)=>Hash(JsonSerializer.Serialize(new {
        version=1,profile=infrastructure.IsLocal?"Local":"Portable",deployment=Deployment(infrastructure),
        host=Host.ToLowerInvariant(),Port,FromAddress,EnableStartTls,infrastructure.StoreBaseUrl,infrastructure.AdminBaseUrl
    }));
    public string BindingName(OnboardingInfrastructureOptions infrastructure)=>"readiness-smtp-target-"+Hash((infrastructure.IsLocal?"Local:":"Portable:")+Deployment(infrastructure));
    internal static string Hash(string value)=>Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(value))).ToLowerInvariant();
}

public sealed record ReadinessEmail(string TenantId,string Recipient,string Subject,string Body,string MessageId);
public interface IReadinessEmailTransport
{
    Task SendAsync(ReadinessEmail message,CancellationToken cancellationToken);
}
public static class ReadinessEmailMessage
{
    public static ReadinessEmail Create(ReadinessDeliveryLease lease,ReadinessEmailOptions options,OnboardingInfrastructureOptions infrastructure)
    {
        var request=lease.Request;request.Validate();
        var expectedProvider=infrastructure.IsLocal?"Local":"Portable";
        if((request.DeploymentId??"")!=options.Deployment(infrastructure) || lease.BindingSha256!=options.Fingerprint(infrastructure) ||
            lease.Publication.Provider!=expectedProvider || request.OwnerEmail.Any(char.IsControl) ||
            !lease.Publication.Resources.TryGetValue("storeUrl",out var store) || store!=infrastructure.StoreUrl(request.Slug) ||
            !lease.Publication.Resources.TryGetValue("adminUrl",out var admin) || admin!=infrastructure.AdminUrl(request.Slug) ||
            !infrastructure.IsLocal && (!lease.Publication.Resources.TryGetValue("readiness",out var ready) || ready!="Verified"))
            throw new InvalidOperationException("Readiness email does not match its original tenant, deployment and verified public URLs.");
        var domain=new MailAddress(options.FromAddress).Host;
        var id="<tenant-ready."+ReadinessEmailOptions.Hash(request.TenantId+":"+lease.BindingSha256)+"@"+domain+">";
        return new(request.TenantId,request.OwnerEmail,"Mağazanız hazır",
            request.StoreName+" mağazanız hazır.\n\nMağaza: "+store+"\nYönetim: "+admin+"\n\nKayıt sırasında belirlediğiniz yönetici hesabıyla giriş yapabilirsiniz. Bu e-posta parola veya özel anahtar içermez.",id);
    }
}

public sealed class SmtpReadinessEmailTransport(ReadinessEmailOptions options) : IReadinessEmailTransport
{
    public async Task SendAsync(ReadinessEmail message,CancellationToken cancellationToken)
    {
        using var client=new SmtpClient(options.Host,options.Port){EnableSsl=options.EnableStartTls,DeliveryMethod=SmtpDeliveryMethod.Network,UseDefaultCredentials=false};
        if(!string.IsNullOrWhiteSpace(options.UserName))client.Credentials=new NetworkCredential(options.UserName,options.Password);
        using var mail=new MailMessage(options.FromAddress,message.Recipient,message.Subject,message.Body){IsBodyHtml=false,SubjectEncoding=Encoding.UTF8,BodyEncoding=Encoding.UTF8};
        mail.Headers.Add("Message-ID",message.MessageId);mail.Headers.Add("X-Platform-Tenant",message.TenantId);
        using var deadline=CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);deadline.CancelAfter(options.Timeout);
        await client.SendMailAsync(mail,deadline.Token);
    }
}

public static class ReadinessEmailRegistration
{
    public static IServiceCollection AddReadinessEmail(this IServiceCollection services,IConfiguration config,string environment,OnboardingInfrastructureOptions infrastructure)
    {
        var provider=config["Provisioning:ReadinessEmail:Provider"]??"Disabled";
        if(provider=="Disabled")return services;
        if(provider!="Smtp")throw new InvalidOperationException("Choose Disabled or Smtp readiness email explicitly.");
        var options=config.GetSection("Provisioning:ReadinessEmail:Smtp").Get<ReadinessEmailOptions>()??throw new InvalidOperationException("Configure readiness SMTP explicitly.");
        options.Validate(infrastructure,environment,config);
        var connection=config["Provisioning:ConnectionString"]??config["PlatformSecurity:ConnectionString"]??throw new InvalidOperationException("A shared provisioning database is required.");
        services.AddSingleton(options);services.AddSingleton(_=>new PostgresReadinessDeliveryQueue(connection));
        services.AddSingleton<IReadinessEmailTransport,SmtpReadinessEmailTransport>();services.AddHostedService<ReadinessEmailWorker>();
        return services;
    }
}
