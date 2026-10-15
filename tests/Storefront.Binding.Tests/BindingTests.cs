using System.Text;
using Grand.Web.MultiTenant.ModelBinders;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Abstractions;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.Routing;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Storefront.Binding.Tests;

[TestClass]
public class BindingTests
{
    private static ModelBindingContext Binding(string? contentType=null,string body="")
    {
        var http=new DefaultHttpContext();http.Request.ContentType=contentType;http.Request.Body=new MemoryStream(Encoding.UTF8.GetBytes(body));
        var action=new ActionContext(http,new RouteData(),new ActionDescriptor{Parameters=new List<ParameterDescriptor>()},new ModelStateDictionary());
        return DefaultModelBindingContext.CreateBindingContext(action,new CompositeValueProvider(),new EmptyModelMetadataProvider().GetMetadataForType(typeof(LoginInput)),new BindingInfo(),"model");
    }
    [TestMethod]
    public void UnsupportedNullableBindingContinuesToMvcInsteadOfWrappingNull()
    {
        var context=new Mock<ModelBinderProviderContext>();context.SetupGet(c=>c.Metadata).Returns(new EmptyModelMetadataProvider().GetMetadataForType(typeof(bool?)));
        context.SetupGet(c=>c.BindingInfo).Returns(new BindingInfo());
        var original=new Mock<IModelBinderProvider>();original.Setup(p=>p.GetBinder(context.Object)).Returns((IModelBinder)null!);
        Assert.IsNull(new ComplexTypeModelBinderProvider(original.Object).GetBinder(context.Object));
    }
    [TestMethod]
    public async Task NonJsonRequestsDelegateToTheDefaultFormBinder()
    {
        var context=Binding();var original=new Mock<IModelBinder>();original.Setup(b=>b.BindModelAsync(context)).Callback(()=>context.Result=ModelBindingResult.Success(new LoginInput{Name="form"})).Returns(Task.CompletedTask);
        await new ComplexTypeModelBinder(original.Object).BindModelAsync(context);
        Assert.AreEqual("form",((LoginInput)context.Result.Model!).Name);original.Verify(b=>b.BindModelAsync(context),Times.Once);
    }
    [TestMethod]
    public async Task JsonComplexDtoStillBindsAndLeavesBodyReadable()
    {
        var context=Binding("application/json","{\"name\":\"json\"}");var original=new Mock<IModelBinder>();
        await new ComplexTypeModelBinder(original.Object).BindModelAsync(context);
        Assert.AreEqual("json",((LoginInput)context.Result.Model!).Name);Assert.AreEqual(0L,context.HttpContext.Request.Body.Position);
        original.Verify(b=>b.BindModelAsync(It.IsAny<ModelBindingContext>()),Times.Never);
    }
    [TestMethod]
    public async Task InvalidJsonDoesNotEchoTheRequestBodyIntoModelState()
    {
        var context=Binding("application/json","private-payload");await new ComplexTypeModelBinder(new Mock<IModelBinder>().Object).BindModelAsync(context);
        Assert.IsFalse(context.Result.IsModelSet);Assert.IsFalse(string.Join(" ",context.ModelState.Values.SelectMany(v=>v.Errors).Select(e=>e.ErrorMessage)).Contains("private-payload"));
    }
    public sealed class LoginInput{public string Name{get;set;}="";}
}
