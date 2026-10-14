using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Model.V2.Subscription;
using Iyzipay.Request;
using Iyzipay.Request.V2.Subscription;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.PaymentProviders.IyzicoProvider;
using SaasManager.Application.Common.Models.PaymentProviders.IyzicoProvider;

namespace SaasManager.Infrastructure.PaymentProviders.IyzicoProvider;

public class IyzicoService: IIyzicoService
{
    private readonly Options _options;
        private readonly ILogger<IyzicoService> _logger;
        private readonly IWorkContext _workContext;

        public IyzicoService(IConfiguration configuration, ILogger<IyzicoService> logger, IWorkContext workContext)
        {
            _logger = logger;
            _workContext = workContext;
            _options = new Options
            {
                ApiKey = configuration["Dev:Iyzico:ApiKey"],
                SecretKey = configuration["Dev:Iyzico:SecretKey"],
                BaseUrl = configuration["Dev:Iyzico:BaseUrl"]
            };
        }

        public async Task<IyzicoPaymentResult> CreatePaymentPreAuthAsync(CreatePaymentRequest request)
        {
            try
            {
                
                var payment = await Task.Run(() => Payment.Create(request, _options));

                return new IyzicoPaymentResult
                {
                    IsSuccess = payment.Status == "success",
                    PaymentId = payment.PaymentId,
                    ErrorMessage = payment.ErrorMessage,
                    RawResult = payment.ToString()
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during Iyzico payment pre-authorization");
                throw;
            }
        }

        public async Task<IyzicoPaymentResult> CancelPreAuthAsync(string paymentId)
        {
            try
            {
                var request = new CreateCancelRequest
                {
                    PaymentId = paymentId,
                    Ip = _workContext.GetClientIpAddress()
                };
                
                var cancel = await Task.Run(() => Cancel.Create(request, _options));

                return new IyzicoPaymentResult
                {
                    IsSuccess = cancel.Status == "success",
                    PaymentId = paymentId,
                    ErrorMessage = cancel.ErrorMessage,
                    RawResult = cancel.ToString()
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during Iyzico payment cancellation");
                throw;
            }
        }
}
