using Platform.Security;
using System.ComponentModel.DataAnnotations;
using System.Text.Json;
using Core.Utilities;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Common;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

public class PaymentVerificationStep(
    IApplicationDbContext context,
    IWorkContext workContext,
    IDateTime dateTime,
    ILogger<PaymentVerificationStep> logger,
    ICardDataProtector cardDataProtector,
    IPaymentProviderFactory paymentProviderFactory,
    ISender sender,
    IMediator mediator,
    ITenantSecrets tenantSecrets)
    : BaseRegistrationStep<PaymentSetupState>(context, workContext, logger)
{
    public override string StepKey => nameof(PaymentSetupState);
    public override bool RequiresTimeout { get; set; }
    public override DateTime? ExpiresAt { get; set; }

    public override Task<Dictionary<string, FieldDefinition>> GetExpectedParameters()
    {
        return Task.FromResult(DynamicFormExtensions.ToDynamicFormParameters<CreditCardFormModel>());
    }

    private async Task<(bool IsValid, Dictionary<string, List<string>>? errors)> ValidateRequiredFields(
        Dictionary<string, object> data)
    {
        if (!data.Any())
        {
            return (false, null);
        }

        var dynamicFormModel = data.ToDynamicFormModel<CreditCardFormModel>();
        var validationContext = new ValidationContext<CreditCardFormModel>(dynamicFormModel);
        var validationResults =
            await (new DynamicFormValidator<CreditCardFormModel>()).ValidateAsync(validationContext, default);

        var fieldErrors = validationResults.Errors.GroupBy(x => x.PropertyName)
            .ToDictionary(x => x.Key, x => x.Select(eg => eg.ErrorMessage).ToList());

        return (validationResults.IsValid, fieldErrors);
    }

    public override async Task<GuestValidationResult> ValidateAsync(
        RegistrationCommand command,
        CancellationToken cancellationToken)
    {
        // Mevcut state'i bul veya yeni oluştur
        var savedState = await _context.RegistrationStates
            .OfType<PaymentSetupState>()
            .FirstOrDefaultAsync(s =>
                    s.GuestId == _workContext.GuestId &&
                    s.IsActive,
                cancellationToken);

        if (savedState == null)
        {
            savedState = new PaymentSetupState(_workContext.GuestRegistration!);
            await _context.PaymentSetupStates.AddAsync(savedState, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            return GuestValidationResult.Failure(StepKey, "");
        }

        if (savedState.IsCompleted)
        {
            return GuestValidationResult.Success();
        }

        if (!command.Data.Any())
        {
            return CreateValidationError("", null);
        }

        var (isValid, errorMessage) = await ValidateRequiredFields(command.Data);
        if (!isValid)
        {
            return CreateValidationError("Lütfen bilgilerinizi kontrol ederek tekrar deneyiniz!", errorMessage!);
        }

        try
        {
            var model = command.Data.BindToModel<CreditCardFormModel>();
            var paymentProvider = paymentProviderFactory.GetDefaultProvider();
            var cardModel = new CardData()
            {
                CardHolderName = model.CardHolderName!,
                Number = model.CardNumber!,
                ExpiryMonth = model.ExpireMonth!,
                ExpiryYear = model.ExpireYear!,
                Cvv = model.Cvc!
            };

            if (!(await paymentProvider.ValidateCardAsync(cardModel)) ||
                !(await cardDataProtector.ValidateAsync(cardModel)))
            {
                return CreateValidationError("Kartınız doğrulanamadı");
            }

            var savedBusinessSubscription = await
            (
                from subscriptionSelectionState in _context.SubscriptionSelectionStates
                join subscriptionPlan in _context.SubscriptionPlans on subscriptionSelectionState.SelectedPlanId equals
                    subscriptionPlan.Id
                join businessSubscription in _context.BusinessSubscriptions on subscriptionPlan.Id equals
                    businessSubscription.PlanId
                where subscriptionSelectionState.IsActive &&
                      subscriptionSelectionState.CompletedAt.HasValue &&
                      !subscriptionSelectionState.IsDeleted &&
                      businessSubscription.BusinessId == _workContext.GuestRegistration!.ConvertedBusinessId
                select businessSubscription
            ).FirstAsync(cancellationToken);
            
            var business = await _context.Businesses.FirstAsync(x=>x.Id == savedBusinessSubscription.BusinessId, cancellationToken);

            var subscriptionPayment = await paymentProvider.ProcessPaymentAsync(savedBusinessSubscription!, cardModel);
            if (!subscriptionPayment.IsSuccess)
            {
                return CreateValidationError($"Ödeme doğrulama hatası: {subscriptionPayment.ErrorMessage}");
            }

            if (!(await paymentProvider.ActivateSubscriptionAsync(subscriptionPayment)))
            {
                return CreateValidationError("Aboneliğiniz aktifleştirilirken hata oluştu.");
            }

            var protectedCard = await cardDataProtector.EncryptAsync(cardModel);

            var paymentMethod = new PaymentMethod(
                _workContext.GuestRegistration!.ConvertedBusinessId!.Value,
                paymentProvider.Id,
                protectedCard.EncryptedNumber,
                protectedCard.LastFourDigits,
                protectedCard.CardType,
                protectedCard.CardHolderName,
                (dateTime.ParseISO8601(dateTime.FormatISO8601(new DateTime(
                    int.Parse(DateTime.Now.Year.ToString().Substring(0, 2) + protectedCard.ExpiryYear),
                    int.Parse(protectedCard.ExpiryMonth),
                    1
                ).AddMonths(1).AddDays(-1).ToIstanbulDateTime()))??dateTime.Now.AddYears(15)));
            
            paymentMethod.SetAsDefault();
            paymentMethod.RecordSuccessfulPayment(JsonDocument.Parse(JsonSerializer.Serialize(subscriptionPayment)));

            await _context.PaymentMethods.AddAsync(paymentMethod, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);


            // Başarılı ön yetkilendirmeyi kaydet
            _logger.LogInformation("Setting pre-auth details and completing registration state for GuestId: {GuestId}", _workContext.GuestId);
            savedState.SetPreAuthDetails(1.0m, subscriptionPayment.PaymentId!);
            savedState.Complete();
            _context.RegistrationStates.Update(savedState);
            await _context.SaveChangesAsync(cancellationToken);
            await mediator.Publish(new PaymentPreAuthCompletedEvent(savedState.GuestId, 1.0m, subscriptionPayment.PaymentId!), cancellationToken);
            
            
            _logger.LogInformation("Updating business status to UnderSetup - BusinessId: {BusinessId}, BusinessName: {BusinessName}", 
                business.Id, business.Name);
                
            // Business varlığını güncel bilgilerle tekrar sorgula
            var currentBusiness = await _context.Businesses
                .FirstOrDefaultAsync(x => x.Id == business.Id, cancellationToken);
                
            if (currentBusiness != null)
            {
                currentBusiness.UpdateStatus(BusinessStatus.UnderSetup);
                _context.Businesses.Update(currentBusiness);
                await _context.SaveChangesAsync(cancellationToken);
                _logger.LogInformation("Business status updated successfully - BusinessId: {BusinessId}, Status: {Status}", 
                    currentBusiness.Id, currentBusiness.Status);
            }
            else
            {
                _logger.LogWarning("Business with ID {BusinessId} not found for status update", business.Id);
            }

            
            var tenantMessage= await sender.Send(new RegisterStoreCommand
            {
                BusinessId = business.Id,
                StoreName = business.Name,
                StoreSubDomain = business.ToSubdomain(),
                LogoUrl = "no-logo.png",
                OwnerEmail = _workContext.GuestRegistration!.Email!,
                Password = PasswordGenerator.GenerateRandomPassword(),
                FirstName = _workContext.GuestRegistration!.Firstname!,
                Lastname = _workContext.GuestRegistration!.Lastname!,
                Role = "business_owner",
                CompanyName = business.Name,
                CompanyAddress = $"{business.Address!} {business.District}/{business.City} {business.PostalCode}",
                CompanyEmail = business.Email,
                CompanyPhoneNumber = business.Phone

            },cancellationToken);

            if (!tenantMessage.IsSuccess)
            {
                return CreateValidationError(tenantMessage.ErrorMessage!);
            }

            var databaseConfig =
                MongoConnectionMapper.MapMetadataFromConnectionString(
                    await tenantSecrets.GetAsync(business.Id.ToString("N"), TenantSecretNames.DatabaseConnection, cancellationToken),
                    "tenant-secret:" + business.Id.ToString("N") + "/" + TenantSecretNames.DatabaseConnection);
            databaseConfig.SetBusiness(business);
            databaseConfig.UpdateStatus(DatabaseStatus.Migrating);
            
            await _context.DatabaseConfigs.AddAsync(databaseConfig, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
            
            return ValidationSuccess();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during payment verification for guest {GuestId}", _workContext.GuestId);
            return CreateValidationError("Ödeme doğrulama sırasında bir hata oluştu");
        }
    }


    class CreditCardFormModel
    {
        [DynamicFormFieldName("cardHolderName")]
        [Required(ErrorMessage = "Kart üzerindeki isim zorunludur.")]
        [Display(Name = "Kart Üzerindeki İsim")]
        public string? CardHolderName { get; set; }

        [DynamicFormFieldName("cardNumber")]
        [Required(ErrorMessage = "Kart numarası zorunludur.")]
        [RegularExpression(@"^\d{16}$", ErrorMessage = "Kart numarası 16 haneli olmalıdır.")]
        [Display(Name = "Kart Numarası")]
        [DataType(DataType.CreditCard)]
        public string? CardNumber { get; set; }

        [DynamicFormFieldName("expireMonth")]
        [Required(ErrorMessage = "Son kullanma ayı zorunludur.")]
        [RegularExpression(@"^(0[1-9]|1[0-2])$", ErrorMessage = "Son kullanma ayı 01 ile 12 arasında olmalıdır.")]
        [Display(Name = "Son Kullanma Ay")]
        [Range(1, 12)]
        [DataType(DataType.Currency)]
        public string? ExpireMonth { get; set; }

        [DynamicFormFieldName("expireYear")]
        [Required(ErrorMessage = "Son kullanma yılı zorunludur.")]
        [RegularExpression(@"^\d{2}$", ErrorMessage = "Son kullanma yılı 2 haneli olmalıdır.")]
        [Display(Name = "Son Kullanma Yıl")]
        [Range(24, 50)]
        [DataType(DataType.Currency)]
        public string? ExpireYear { get; set; }

        [DynamicFormFieldName("cvc")]
        [Required(ErrorMessage = "Güvenlik kodu zorunludur.")]
        [RegularExpression(@"^\d{3}$", ErrorMessage = "Güvenlik kodu 3 haneli olmalıdır.")]
        [Display(Name = "Güvenlik Kodu")]
        [DataType(DataType.Currency)]
        [Range(100, 9999)]
        public string? Cvc { get; set; }
    }
}
