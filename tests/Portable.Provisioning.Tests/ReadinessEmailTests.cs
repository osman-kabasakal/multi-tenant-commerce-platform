using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class ReadinessEmailTests
{
    private static IConfiguration Config(bool local=false)=>new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{["LocalDemo:Enabled"]=local?"true":"false"}).Build();
    private static PortableOnboardingOptions Portable()=>new(){DeploymentId="commerce-production",StoreBaseUrl="https://shops.example.test",AdminBaseUrl="https://manage.example.test"};
    private static LocalOnboardingOptions Local()=>new(){StoreBaseUrl="http://localhost:18090",AdminBaseUrl="http://localhost:18083"};
    private static ReadinessEmailOptions Options()=>new(){Host="smtp.example.test",Port=587,FromAddress="platform@example.test",UserName="smtp-user",Password="synthetic-private-password"};
    private static TenantProvisioningRequest Request()=>new("123456781234123412341234567890ab","test-shop","Test Shop","owner@example.test","Owner","One","Address","555","company@example.test",DeploymentId:"commerce-production");
    private static ReadinessDeliveryLease Lease(OnboardingInfrastructureOptions infra,ReadinessEmailOptions options,TenantProvisioningRequest? request=null)
    {
        request??=Request();return new(request,new(infra.IsLocal?"Local":"Portable",new Dictionary<string,string>{["storeUrl"]=infra.StoreUrl(request.Slug),["adminUrl"]=infra.AdminUrl(request.Slug),["readiness"]="Verified"}),Guid.NewGuid(),1,options.Fingerprint(infra));
    }
    [TestMethod]public void Portable_requires_explicit_tls_and_accepts_credential_rotation_without_target_changes()
    {
        var options=Options();var infra=Portable();options.Validate(infra,"Production",Config());
        var rotated=new ReadinessEmailOptions{Host=options.Host,Port=options.Port,FromAddress=options.FromAddress,UserName="rotated-user",Password="another-synthetic-password"};
        Assert.AreEqual(options.Fingerprint(infra),rotated.Fingerprint(infra));
        Assert.AreNotEqual(options.Fingerprint(infra),new ReadinessEmailOptions{Host="other.example.test",FromAddress=options.FromAddress}.Fingerprint(infra));
        Assert.AreNotEqual(options.Fingerprint(infra),options.Fingerprint(new PortableOnboardingOptions{DeploymentId="another-deployment",StoreBaseUrl=infra.StoreBaseUrl,AdminBaseUrl=infra.AdminBaseUrl}));
    }
    [DataTestMethod]
    [DataRow("Development",false)] [DataRow("Production",true)] [DataRow("Staging",true)]
    public void Portable_rejects_development_or_local_demo(string environment,bool localDemo)=>Assert.ThrowsException<InvalidOperationException>(()=>Options().Validate(Portable(),environment,Config(localDemo)));
    [TestMethod]public void Production_never_allows_plaintext_even_for_loopback()
    {
        var value=new ReadinessEmailOptions{Host="127.0.0.1",Port=1025,FromAddress="platform@example.test",EnableStartTls=false,AllowPlaintextLoopback=true};
        Assert.ThrowsException<InvalidOperationException>(()=>value.Validate(Portable(),"Production",Config()));
        value.Validate(Local(),"Development",Config(true));
        Assert.ThrowsException<InvalidOperationException>(()=>value.Validate(Local(),"Production",Config(true)));
        Assert.ThrowsException<InvalidOperationException>(()=>value.Validate(Local(),"Development",Config()));
    }
    [TestMethod]public void Local_captures_cannot_contact_external_mail_servers()
    {Assert.ThrowsException<InvalidOperationException>(()=>Options().Validate(Local(),"Development",Config(true)));}
    [TestMethod]public void Invalid_smtp_configuration_is_refused()
    {
        foreach(var options in new[]{new ReadinessEmailOptions(),new ReadinessEmailOptions{Host="smtp.example.test",FromAddress="platform@example.test",Port=0},new ReadinessEmailOptions{Host="smtp.example.test",FromAddress="platform@example.test",UserName="user"},new ReadinessEmailOptions{Host="smtp.example.test",FromAddress="display <platform@example.test>"},new ReadinessEmailOptions{Host="smtp.example.test",FromAddress="platform@example.test",LeaseDuration=TimeSpan.FromSeconds(1)}})
            Assert.ThrowsException<InvalidOperationException>(()=>options.Validate(Portable(),"Production",Config()));
    }
    [TestMethod]public void Message_contains_only_owned_public_links_and_stable_delivery_identity()
    {
        var options=Options();var infra=Portable();var lease=Lease(infra,options);
        var first=ReadinessEmailMessage.Create(lease,options,infra);var retried=ReadinessEmailMessage.Create(lease with{Token=Guid.NewGuid(),Attempts=2},options,infra);
        Assert.AreEqual(first.MessageId,retried.MessageId);Assert.AreEqual(lease.Request.OwnerEmail,first.Recipient);
        StringAssert.Contains(first.Body,"https://test-shop.shops.example.test");StringAssert.Contains(first.Body,"https://test-shop.manage.example.test/Admin");
        Assert.IsFalse(first.Body.Contains(options.Password!));Assert.IsFalse(first.Body.Contains(options.UserName!));
    }
    [DataTestMethod]
    [DataRow("provider")] [DataRow("store")] [DataRow("admin")] [DataRow("readiness")] [DataRow("deployment")] [DataRow("binding")]
    public void Foreign_or_unverified_publication_cannot_create_a_message(string change)
    {
        var options=Options();var infra=Portable();var lease=Lease(infra,options);var resources=new Dictionary<string,string>(lease.Publication.Resources);
        if(change is "store" or "admin")resources[change+"Url"]="https://foreign.example.test";
        if(change=="readiness")resources["readiness"]="NotVerified";
        lease=lease with{Publication=new(change=="provider"?"Local":"Portable",resources)};
        if(change=="deployment")lease=lease with{Request=lease.Request with{DeploymentId="foreign-deployment"}};
        if(change=="binding")lease=lease with{BindingSha256=new string('f',64)};
        Assert.ThrowsException<InvalidOperationException>(()=>ReadinessEmailMessage.Create(lease,options,infra));
    }
    [TestMethod]public void Provider_is_disabled_by_default_and_unknown_provider_fails_at_registration()
    {
        var services=new ServiceCollection();services.AddReadinessEmail(Config(),"Production",Portable());Assert.AreEqual(0,services.Count);
        var bad=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{["Provisioning:ReadinessEmail:Provider"]="unknown"}).Build();
        Assert.ThrowsException<InvalidOperationException>(()=>services.AddReadinessEmail(bad,"Production",Portable()));
    }
}
