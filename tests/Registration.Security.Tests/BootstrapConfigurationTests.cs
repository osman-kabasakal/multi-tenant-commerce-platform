using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Infrastructure.Data;

namespace Registration.Security.Tests;

[TestClass]
public class BootstrapConfigurationTests
{
    private static Dictionary<string,string?> Values()=>new()
    {
        ["LocalDemo:Enabled"]="false",["PlatformSecurity:Provider"]="AesGcm",
        ["PlatformSecurity:ConnectionString"]="Host=postgres;Database=commerce_security;Username=owner;Password=synthetic",
        ["ConnectionStrings:SaasManagerDb"]="Host=postgres;Database=commerce_saas;Username=owner;Password=synthetic",
        ["Bootstrap:DeploymentId"]="commerce-production",["Bootstrap:AllowSchemaChanges"]="true",
        ["Provisioning:DeploymentId"]="commerce-production",
        ["Bootstrap:TrialPlan:Id"]="12345678-1234-1234-1234-1234567890ab",
        ["Bootstrap:TrialPlan:Name"]="Configured trial",["Bootstrap:TrialPlan:Code"]="TRIAL",
        ["Bootstrap:TrialPlan:Price"]="299.00",["Bootstrap:TrialPlan:TrialDays"]="14",
        ["Bootstrap:TrialPlan:MaxProducts"]="100",["Bootstrap:TrialPlan:MaxUsers"]="3",
        ["Bootstrap:TrialPlan:MaxMonthlyOrders"]="1000",["Bootstrap:TrialPlan:Features:0"]="Catalog",
        ["TenantOnboarding:Trial:Enabled"]="true",["TenantOnboarding:Trial:PlanId"]="12345678-1234-1234-1234-1234567890ab"
    };
    private static IConfiguration Config(Dictionary<string,string?> values)=>new ConfigurationBuilder().AddInMemoryCollection(values).Build();
    [DataTestMethod]
    [DataRow("LocalDemo:Enabled","true")]
    [DataRow("PlatformSecurity:Provider","Local")]
    [DataRow("PlatformSecurity:Provider","unknown")]
    [DataRow("Bootstrap:AllowSchemaChanges","false")]
    [DataRow("Bootstrap:DeploymentId","../deployment")]
    [DataRow("Provisioning:DeploymentId","foreign-deployment")]
    [DataRow("ConnectionStrings:SaasManagerDb","Host=postgres;Database=commerce_security")]
    [DataRow("ConnectionStrings:SaasManagerDb","Host=postgres;Database=postgres")]
    [DataRow("ConnectionStrings:SaasManagerDb","Host=postgres;Database=commerce_saas;Search Path=foreign")]
    [DataRow("TenantOnboarding:Trial:PlanId","ffffffff-ffff-ffff-ffff-ffffffffffff")]
    [DataRow("Bootstrap:TrialPlan:Price","1.001")]
    [DataRow("Bootstrap:TrialPlan:TrialDays","0")]
    [DataRow("Bootstrap:TrialPlan:MaxProducts","0")]
    [DataRow("Bootstrap:TrialPlan:Code","THIS_CODE_EXCEEDS_TWENTY_CHARACTERS")]
    [DataRow("Bootstrap:TrialPlan:Name","This configured name exceeds the actual fifty character database limit")]
    public void Invalid_bootstrap_configuration_is_rejected_before_database_work(string key,string value)
    {
        var values=Values();values[key]=value;
        Assert.ThrowsException<InvalidOperationException>(()=>PortableBootstrapOptions.Read(Config(values),true));
    }
    [TestMethod]
    public void Verification_does_not_require_schema_authorization_and_credentials_are_not_part_of_the_binding()
    {
        var values=Values();var original=PortableBootstrapOptions.Read(Config(values),true);
        values["Bootstrap:AllowSchemaChanges"]="false";
        values["PlatformSecurity:ConnectionString"]="Host=postgres;Database=commerce_security;Username=runtime;Password=another-synthetic";
        values["ConnectionStrings:SaasManagerDb"]="Host=postgres;Database=commerce_saas;Username=runtime;Password=another-synthetic";
        var reader=PortableBootstrapOptions.Read(Config(values),false);
        Assert.AreEqual(original.Spec.Fingerprint,reader.Spec.Fingerprint);
        Assert.IsFalse(System.Text.Json.JsonSerializer.Serialize(reader.Spec).Contains("another-synthetic",StringComparison.Ordinal));
    }
    [TestMethod]
    public void Plan_and_database_changes_change_the_binding_but_guid_format_does_not()
    {
        var values=Values();var original=PortableBootstrapOptions.Read(Config(values),true);
        values["TenantOnboarding:Trial:PlanId"]=values["TenantOnboarding:Trial:PlanId"]!.ToUpperInvariant();
        Assert.AreEqual(original.Spec.Fingerprint,PortableBootstrapOptions.Read(Config(values),true).Spec.Fingerprint);
        values["Bootstrap:TrialPlan:Price"]="299";
        Assert.AreEqual(original.Spec.Fingerprint,PortableBootstrapOptions.Read(Config(values),true).Spec.Fingerprint);
        values["Bootstrap:TrialPlan:TrialDays"]="30";
        Assert.AreNotEqual(original.Spec.Fingerprint,PortableBootstrapOptions.Read(Config(values),true).Spec.Fingerprint);
        values=Values();values["ConnectionStrings:SaasManagerDb"]="Host=postgres;Database=another_saas";
        Assert.AreNotEqual(original.Spec.Fingerprint,PortableBootstrapOptions.Read(Config(values),true).Spec.Fingerprint);
    }
}
