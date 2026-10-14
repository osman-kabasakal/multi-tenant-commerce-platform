using Grand.Business.Core.Commands.Checkout.Orders;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Domain.Customers;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Grand.Web.ExternalSettings.TenantToken;
using Iyzipay.Model;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Payments.Iyzico.Models;
using Payments.Iyzico.Services;
using Payments.Iyzico.Utilities;
using System.Globalization;
using System.Text.Json.Serialization;

namespace Payments.Iyzico.Controllers
{
    public class IyzicoPaymentController : BasePublicController
    {
        private readonly IyzicoPaymentSettings _iyzicoPaymentSettings;
        private readonly IOrderCalculationService _orderTotalCalculationService;
        private readonly IShoppingCartService _shoppingCartService;
        private readonly IWorkContext _workContext;
        private readonly ITranslationService _translationService;
        private readonly IPaymentTransactionService _paymentTransactionService;
        private readonly ITenantTokenHandler _tokenHandler;
        private readonly IIyzicoPayService _iyzicoPayService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserFieldService _userFieldService;
        private readonly IMediator _mediator;
        private readonly IOrderService _orderService;
        private readonly IGrandAuthenticationService _grandAuthenticationService;
        private readonly ILogger<IyzicoPaymentController> _logger;

        public IyzicoPaymentController(
        IyzicoPaymentSettings iyzicoPaymentSettings,
        IOrderCalculationService orderTotalCalculationService,
        IShoppingCartService shoppingCartService,
        IWorkContext workContext,
        ITranslationService translationService,
        IPaymentTransactionService paymentTransactionService,
        ITenantTokenHandler tenantTokenHandler,
        IIyzicoPayService iyzicoPayService,
        IHttpContextAccessor httpContextAccessor,
        IUserFieldService userFieldService,
        IMediator mediator,
        IOrderService orderService,
        IGrandAuthenticationService grandAuthenticationService,
        ILogger<IyzicoPaymentController> logger
        )
        {
            _iyzicoPaymentSettings = iyzicoPaymentSettings;
            _orderTotalCalculationService = orderTotalCalculationService;
            _shoppingCartService = shoppingCartService;
            _workContext = workContext;
            _translationService = translationService;
            _paymentTransactionService = paymentTransactionService;
            _tokenHandler = tenantTokenHandler;
            _iyzicoPayService = iyzicoPayService;
            _httpContextAccessor = httpContextAccessor;
            _userFieldService = userFieldService;
            _mediator = mediator;
            _orderService = orderService;
            _grandAuthenticationService = grandAuthenticationService;
            _logger = logger;
        }


        public async Task<IActionResult> PaymentInfo()
        {
            var model = new IyzicoPaymentInfoModel();
            model.CreditCardFormData = DynamicFormExtensions.ToDynamicFormParameters<CreditCardFormModel>();
            model.StoredUserCards = await _iyzicoPayService.GetStoredUserCards();
            model.SandBox = _iyzicoPaymentSettings.UseSandBox;
            model.SelectedCardToken = await _workContext.CurrentCustomer.GetUserField<string>(_userFieldService, IyzicoDefaults.IyzicoSelectedCardTokenKey);
            model.InstallmentQueryUrl = Url.Action("InstallmentQuery", "IyzicoPayment");
            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> ThreedsCallback()
        {
            try
            {
                IyzicoCallbackModel callbackModel;
                var contentType = Request.ContentType?.ToLower() ?? "";

                _logger.LogInformation($"Content Type: {contentType}");

                if (contentType.Contains("application/json"))
                {
                    // JSON formatında gelen veriyi oku
                    callbackModel = await HttpContext.Request.ReadFromJsonAsync<IyzicoCallbackModel>();
                    if (callbackModel == null)
                    {
                        _logger.LogError("JSON verisi IyzicoCallbackModel'e dönüştürülemedi");
                        return BadRequest("Geçersiz JSON formatı");
                    }
                }
                else if (contentType.Contains("application/x-www-form-urlencoded"))
                {
                    // Form verilerini oku
                    var form = await Request.ReadFormAsync();
                    callbackModel = new IyzicoCallbackModel {
                        PaymentId = form.ContainsKey("paymentId") ? form["paymentId"].ToString() : null,
                        ConversationId = form.ContainsKey("conversationId") ? form["conversationId"].ToString() : null,
                        Status = form.ContainsKey("status") ? form["status"].ToString() : null,
                        MdStatus = form.ContainsKey("mdStatus") ? form["mdStatus"].ToString() : null,
                        ConversationData = form.ContainsKey("conversationData") ? form["conversationData"].ToString() : null
                    };
                }
                else
                {
                    _logger.LogError($"Desteklenmeyen içerik tipi: {contentType}");
                    return BadRequest("Desteklenmeyen içerik tipi");
                }

                // Gerekli alanların kontrolü
                if (string.IsNullOrEmpty(callbackModel.PaymentId) ||
                    string.IsNullOrEmpty(callbackModel.ConversationId))
                {
                    _logger.LogError("Gerekli alanlar eksik");
                    return BadRequest("Gerekli alanlar eksik");
                }

                // Gelen verileri logla
                _logger.LogInformation(
                    "Callback alındı - Customer: {4} PaymentId: {0}, ConversationId: {1}, Status: {2}, MdStatus: {3}",
                    callbackModel.PaymentId,
                    callbackModel.ConversationId,
                    callbackModel.Status,
                    callbackModel.MdStatus,
                    _workContext.CurrentCustomer.GetFullName()
                );

                if (string.IsNullOrEmpty(await _tokenHandler.ValidateAndGetTenant(callbackModel.ConversationId)))
                {
                    return BadRequest("İstek doğrulnamadı!");
                }
                ThreedsPayment completePayment = await _iyzicoPayService.CompletePayment(callbackModel.PaymentId, callbackModel.ConversationData);
                var paymentTransaction = await _paymentTransactionService.GetOrderByGuid(Guid.Parse(completePayment.BasketId));

                paymentTransaction.CustomValues.Remove(IyzicoDefaults.EncryptedCartFormKey);
                paymentTransaction.AuthorizationTransactionId = completePayment.PaymentId;
                paymentTransaction.TransactionAmount = double.Parse(completePayment.PaidPrice.TrimEnd('0'),CultureInfo.InvariantCulture);

                await _mediator.Send(new MarkAsPaidCommand { PaymentTransaction = paymentTransaction });
                var order = await _orderService.GetOrderByGuid(paymentTransaction.OrderGuid);
                return RedirectToRoute("CheckoutCompleted", new { orderId = order.Id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Callback işlenirken hata oluştu");
                return StatusCode(500, "İşlem sırasında bir hata oluştu");
            }
        }


        [HttpGet]
        public async Task<IActionResult> InstallmentQuery(string bin, double price)
        {
            return Ok(await _iyzicoPayService.GetInstallmentDetailsByBinBumber(bin, price));
        }

        [HttpGet]
        public async Task<IActionResult> IyzicoForm()
        {
            var iyzicoForm = HttpContext.Session.GetString("threedshtmlcontent");
            if (string.IsNullOrEmpty(iyzicoForm))
                return NotFound();

            await _grandAuthenticationService.SignIn(_workContext.CurrentCustomer, false);
            return Content(Encoding.UTF8.GetString(Convert.FromBase64String(iyzicoForm)), "text/html");
        }

    }
}

public class IyzicoCallbackModel
{
    [FromForm(Name = "paymentId")]
    [JsonPropertyName("paymentId")]
    public string PaymentId { get; set; }

    [FromForm(Name = "conversationId")]
    [JsonPropertyName("conversationId")]
    public string ConversationId { get; set; }

    [FromForm(Name = "status")]
    [JsonPropertyName("status")]
    public string Status { get; set; }

    [FromForm(Name = "mdStatus")]
    [JsonPropertyName("mdStatus")]
    public string MdStatus { get; set; }

    [FromForm(Name = "conversationData")]
    [JsonPropertyName("conversationData")]
    public string ConversationData { get; set; }
}
