using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Web.Infrastructure;

namespace Portable.Services.Tests;

[TestClass]
public sealed class RequestErrorTests
{
    [DataTestMethod]
    [DataRow(400)]
    [DataRow(413)]
    public async Task RejectedFormRetainsClientStatusWithoutPrivateDetails(int status)
    {
        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();
        var handled = await new CustomExceptionHandler().TryHandleAsync(context,
            new BadHttpRequestException("private request/token details", status), CancellationToken.None);
        Assert.IsTrue(handled);
        Assert.AreEqual(status, context.Response.StatusCode);
        var body = Encoding.UTF8.GetString(((MemoryStream)context.Response.Body).ToArray());
        StringAssert.Contains(body, "Invalid request.");
        Assert.IsFalse(body.Contains("private request/token details"));
    }
}
