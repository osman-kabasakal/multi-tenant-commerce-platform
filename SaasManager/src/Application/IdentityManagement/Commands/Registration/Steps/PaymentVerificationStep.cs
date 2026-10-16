using Platform.Security;
using Microsoft.Extensions.Configuration;
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
    ITenantSecrets tenantSecrets,
    IConfiguration configuration,
    IPaymentAttemptLock paymentAttemptLock)
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
        try
        {
            var guest = _workContext.GuestRegistration ?? throw new InvalidOperationException("Registration owner is required.");
            var businessId = guest.ConvertedBusinessId ?? throw new InvalidOperationException("Registration business is required.");
            await using var lease = await paymentAttemptLock.TryAcquireAsync(businessId, cancellationToken);
            if (lease == null) return CreateValidationError("Ödeme işleminiz başka bir istekte sürüyor. Lütfen bekleyip tekrar deneyiniz.");
            // Read persisted completion under the exclusive lease; a previously tracked entity may be stale.
            var completed = await _context.PaymentSetupStates.AsNoTracking().AnyAsync(s =>
                s.GuestId == guest.Id && s.IsActive && !s.IsDeleted && s.CompletedAt.HasValue, cancellationToken);
            if (completed)
            {
                if (configuration.GetValue<bool>("Provisioning:Enabled")) await EnsureDurableProvisioningAsync(cancellationToken);
                return GuestValidationResult.Success();
            }
            var savedState = await _context.PaymentSetupStates.FirstOrDefaultAsync(s =>
                s.GuestId == guest.Id && s.IsActive && !s.IsDeleted, cancellationToken);
            if (savedState == null)
            {
                await _context.PaymentSetupStates.AddAsync(new PaymentSetupState(guest), cancellationToken);
                await _context.SaveChangesAsync(cancellationToken);
                return GuestValidationResult.Failure(StepKey, "");
            }
            var savedBusinessSubscription = await (
                from selection in _context.SubscriptionSelectionStates
                join selectedPlan in _context.SubscriptionPlans on selection.SelectedPlanId equals selectedPlan.Id
                join subscription in _context.BusinessSubscriptions on selectedPlan.Id equals subscription.PlanId
                where selection.GuestId == guest.Id && selection.IsActive && selection.CompletedAt.HasValue && !selection.IsDeleted &&
                    subscription.BusinessId == businessId && !subscription.IsDeleted && subscription.IsActive &&
                    subscription.Status == SubscriptionStatus.AwaitingPayment && selectedPlan.IsActive && !selectedPlan.IsDeleted
                select subscription).SingleAsync(cancellationToken);
            var plan = await _context.SubscriptionPlans.SingleAsync(p => p.Id == savedBusinessSubscription.PlanId, cancellationToken);
            var business = await _context.Businesses.SingleAsync(b => b.Id == businessId && !b.IsDeleted, cancellationToken);
            var paymentProvider = paymentProviderFactory.GetDefaultProvider();
            var journal = await SubscriptionPaymentJournal.OpenAsync(tenantSecrets, lease, guest.Id,
                savedBusinessSubscription, plan, paymentProvider, cancellationToken);
            if (journal.CurrentPhase == SubscriptionPaymentJournal.Phase.Initializing)
                return CreateValidationError("Ödeme isteğinin sonucu belirsiz. Yeni işlem başlatılmadı; işletme desteğiyle ödeme kaydı kontrol edilmelidir.");
            if (journal.CurrentPhase == SubscriptionPaymentJournal.Phase.Ready)
            {
                var (isValid, errors) = await ValidateRequiredFields(command.Data);
                if (!isValid) return CreateValidationError("Lütfen bilgilerinizi kontrol ederek tekrar deneyiniz!", errors!);
                var model = command.Data.BindToModel<CreditCardFormModel>();
                var card = new CardData { CardHolderName = model.CardHolderName!, Number = model.CardNumber!,
                    ExpiryMonth = model.ExpireMonth!, ExpiryYear = model.ExpireYear!, Cvv = model.Cvc! };
                if (!await cardDataProtector.ValidateAsync(card) || !await paymentProvider.ValidateCardAsync(card))
                    return CreateValidationError("Kartınız doğrulanamadı");
                // This durable marker precedes the external call. The protector never persists CVV.
                await journal.BeginAsync(await cardDataProtector.EncryptAsync(card), cancellationToken);
                await lease.EnsureHeldAsync(cancellationToken);
                var initialized = await paymentProvider.ProcessPaymentAsync(savedBusinessSubscription, card);
                // Preserve a known result even if the browser disconnects while the provider is responding.
                using var receiptTimeout = new CancellationTokenSource(TimeSpan.FromSeconds(15));
                if (!await journal.RecordInitializationAsync(initialized, receiptTimeout.Token))
                    return CreateValidationError("Ödeme doğrulanamadı. Sonuç belirsizse yeni abonelik oluşturulmaz.");
            }
            var subscriptionPayment = journal.Receipt;
            await lease.EnsureHeldAsync(cancellationToken);
            // An existing receipt resumes the same provider subscription without resending card initialization.
            if (!await paymentProvider.ActivateSubscriptionAsync(subscriptionPayment))
                return CreateValidationError("Abonelik henüz doğrulanamadı. Tekrar denendiğinde aynı ödeme kaydı kontrol edilecek.");
            using (var activeTimeout = new CancellationTokenSource(TimeSpan.FromSeconds(15)))
                await journal.RecordActiveAsync(activeTimeout.Token);
            var protectedCard = journal.Card;
            var year = int.Parse(protectedCard.ExpiryYear, System.Globalization.CultureInfo.InvariantCulture);
            if (year < 100) year += 2000;
            var expires = new DateTime(year, int.Parse(protectedCard.ExpiryMonth, System.Globalization.CultureInfo.InvariantCulture),
                1, 0, 0, 0, DateTimeKind.Utc).AddMonths(1).AddTicks(-1);
            var paymentMethod = new PaymentMethod(businessId, paymentProvider.Id, protectedCard.EncryptedNumber,
                protectedCard.LastFourDigits, protectedCard.CardType, protectedCard.CardHolderName, expires);
            paymentMethod.SetAsDefault();
            paymentMethod.RecordSuccessfulPayment(JsonDocument.Parse(JsonSerializer.Serialize(subscriptionPayment)));
            await _context.PaymentMethods.AddAsync(paymentMethod, cancellationToken);
            savedState.SetPreAuthDetails(1.0m, subscriptionPayment.PaymentId!);
            savedState.Complete();
            savedBusinessSubscription.UpdateStatus(SubscriptionStatus.Active);
            _context.BusinessSubscriptions.Update(savedBusinessSubscription);
            _context.RegistrationStates.Update(savedState);
            await lease.EnsureHeldAsync(cancellationToken);
            // One EF transaction commits the payment method, subscription and registration completion together.
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

            if (configuration.GetValue<bool>("Provisioning:Enabled"))
                return ValidationSuccess();

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
            _logger.LogError("Payment verification failed for guest {GuestId} ({ErrorType}).", _workContext.GuestId, ex.GetType().Name);
            return CreateValidationError("Ödeme doğrulama sırasında bir hata oluştu");
        }
    }


    private async Task EnsureDurableProvisioningAsync(CancellationToken ct)
    {
        var guest = _workContext.GuestRegistration ?? throw new InvalidOperationException("Registration owner is required.");
        var businessId = guest.ConvertedBusinessId ?? throw new InvalidOperationException("Registration business is required.");
        var business = await _context.Businesses.FirstAsync(x => x.Id == businessId && !x.IsDeleted, ct);
        var result = await sender.Send(new RegisterStoreCommand {
            BusinessId = business.Id, StoreName = business.Name, StoreSubDomain = business.ToSubdomain(),
            LogoUrl = "no-logo.png", OwnerEmail = guest.Email!, Password = PasswordGenerator.GenerateRandomPassword(),
            FirstName = guest.Firstname!, Lastname = guest.Lastname!, Role = "business_owner",
            CompanyName = business.Name,
            CompanyAddress = $"{business.Address!} {business.District}/{business.City} {business.PostalCode}",
            CompanyEmail = business.Email, CompanyPhoneNumber = business.Phone
        }, ct);
        if (!result.IsSuccess) throw new InvalidOperationException("Tenant provisioning could not be queued.");
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
