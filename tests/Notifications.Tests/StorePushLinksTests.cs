using Grand.Web.Admin.Infrastructure;
using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace Platform.Notifications.Tests;
[TestClass]
public sealed class StorePushLinksTests
{
    [TestMethod]
    public void RelativeAndPreviousStoreLinksUseTheActiveOriginWhileKeepingTheirRoute()
    {
        var aliases = new[] { "https://old.shops.example.test", "https://store.example.test" };
        Assert.AreEqual("https://store.example.test/", StorePushLinks.Default("https://store.example.test", aliases, "/"));
        Assert.AreEqual("https://store.example.test/Cart?keep=AbC", StorePushLinks.Default("https://store.example.test", aliases, "https://old.shops.example.test/Cart?keep=AbC"));
        Assert.AreEqual("https://store.example.test/Category/abc", StorePushLinks.Default("https://store.example.test", aliases, "/Category/abc"));
    }
    [TestMethod]
    public void UnownedOrAdminLinksNeverBecomeTheDefaultMobileAction()
    {
        foreach (var value in new[] { "https://foreign.example/Cart", "//foreign.example/Cart", "https://user:password@store.example.test/Cart", "/Admin/Product/List", "javascript:alert(1)" })
            Assert.AreEqual("https://store.example.test/", StorePushLinks.Default("https://store.example.test", [], value));
    }
    [TestMethod]
    public void HttpIsAvailableOnlyForTheExplicitLocalSinkDemo()
    {
        Assert.AreEqual("http://localhost:5100/Cart", StorePushLinks.Default("http://localhost:5100", [], "/Cart", allowHttp: true));
        Assert.ThrowsException<InvalidOperationException>(() => StorePushLinks.Default("http://localhost:5100", [], "/Cart"));
    }

}
