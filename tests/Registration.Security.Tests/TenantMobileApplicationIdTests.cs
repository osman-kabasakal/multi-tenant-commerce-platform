using System.Globalization;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Application.Stores.Provisioning;

namespace Registration.Security.Tests;

[TestClass]
public sealed class TenantMobileApplicationIdTests
{
    private static IConfiguration Config(string prefix = "com.osmankabasakal") => new ConfigurationBuilder()
        .AddInMemoryCollection(new Dictionary<string,string?> { ["TenantOnboarding:MobileApplicationIdPrefix"] = prefix }).Build();
    [DataTestMethod]
    [DataRow("Çağrı ŞİŞLİ Gıda", "cagrisisligida")]
    [DataRow("Yasemin Döner", "yasemindoner")]
    [DataRow("OSSEA-PET", "osseapet")]
    [DataRow("123 Market", "app123market")]
    [DataRow("class", "appclass")]
    [DataRow("你好 Market", "u4f60u597dmarket")]
    public void BusinessNamesProduceTheSameAndroidAndIosSafeLabel(string name, string label)
    {
        var actual = TenantMobileApplicationId.ForBusiness(Config(), name, Guid.NewGuid());
        Assert.AreEqual("com.osmankabasakal." + label, actual);
        StringAssert.Matches(actual, new System.Text.RegularExpressions.Regex("^[a-z][a-z0-9]*(\\.[a-z][a-z0-9]*)+\\z"));
    }
    [TestMethod]
    public void PolicyIsIndependentOfCurrentCultureAndUsesCanonicalUnicode()
    {
        var prior = CultureInfo.CurrentCulture;
        try
        {
            var id = Guid.NewGuid(); CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("tr-TR");
            var a = TenantMobileApplicationId.ForBusiness(Config(), "İğde Dükkanı", id);
            CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
            Assert.AreEqual(a, TenantMobileApplicationId.ForBusiness(Config(), "İğde Dükkanı".Normalize(System.Text.NormalizationForm.FormD), id));
        }
        finally { CultureInfo.CurrentCulture = prior; }
    }
    [TestMethod]
    public void CollisionAlternativeIsStableUniqueAndBounded()
    {
        var a = Guid.NewGuid(); var b = Guid.NewGuid(); var config = Config("com." + new string('a',146));
        var first = TenantMobileApplicationId.ForBusiness(config, new string('a',250), a, true);
        Assert.AreEqual(200, first.Length);
        Assert.AreEqual(first, TenantMobileApplicationId.ForBusiness(config, new string('a',250), a, true));
        Assert.AreNotEqual(first, TenantMobileApplicationId.ForBusiness(config, new string('a',250), b, true));
    }
    [DataTestMethod]
    [DataRow("com.example")][DataRow("com.example.store")][DataRow("com.class")][DataRow("Com.Owner")][DataRow("com.a-b")][DataRow("")]
    public void InvalidPublisherNamespaceIsRejected(string prefix) => Assert.ThrowsException<InvalidOperationException>(() => TenantMobileApplicationId.Prefix(Config(prefix)));
}
