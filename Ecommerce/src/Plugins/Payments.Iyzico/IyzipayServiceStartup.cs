using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Infrastructure;
using Grand.Infrastructure.Configuration;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Payments.Iyzico.Builders;
using Payments.Iyzico.Services;
using StackExchange.Redis;

namespace Payments.Iyzico;

public class IyzipayServiceStartup : IStartupApplication
{
    public int Priority => 0;

    public bool BeforeConfigure => false;

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
    }

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IIyzicoPayService, IyzicoPayService>();
        services.AddScoped<IPaymentProvider, IyzicoPaymentProvider>();
        services.AddScoped<IyzicoPaymentRequestBuilder>();
    }
}
