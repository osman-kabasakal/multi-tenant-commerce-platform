using Grand.Infrastructure.Endpoints;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace Payments.Iyzico;

public class EndpointProvider : IEndpointProvider
{
    public int Priority => 0;

    public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
    {
        endpointRouteBuilder.MapControllerRoute(IyzicoDefaults.PaymentInfoRouteName,
            "Plugins/IyzicoPayment/PaymentInfo",
            new { controller = "IyzicoPayment", action = "PaymentInfo", area = "" }
        );

        endpointRouteBuilder.MapControllerRoute(IyzicoDefaults.PaymentThreeDsCallbackRouteName,
            "Plugins/IyzicoPayment/ThreedsCallback",
            new { controller = "IyzicoPayment", action = "ThreedsCallback", area = "" }
        );

        endpointRouteBuilder.MapControllerRoute(IyzicoDefaults.PaymentThreeDsFormRenderRouteName,
            "Plugins/IyzicoPayment/IyzicoForm",
            new { controller = "IyzicoPayment", action = "IyzicoForm", area = "" }
        );
    }
}
