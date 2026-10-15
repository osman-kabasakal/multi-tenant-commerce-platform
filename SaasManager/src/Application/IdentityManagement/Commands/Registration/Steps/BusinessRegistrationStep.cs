using Platform.Security;
using System.ComponentModel.DataAnnotations;
using Core.Utilities;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.Common.Utilities;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

public class BusinessRegistrationStep(
    IApplicationDbContext context,
    IWorkContext workContext,
    ILogger<BusinessRegistrationStep> logger,
    IMediator mediator,
    ITenantSecrets tenantSecrets)
    : BaseRegistrationStep<BusinessRegistrationState>(context, workContext, logger)
{
    public override string StepKey => nameof(BusinessRegistrationState);
    public override bool RequiresTimeout { get; set; } = false;
    public override DateTime? ExpiresAt { get; set; }

    public override Task<Dictionary<string, FieldDefinition>> GetExpectedParameters()
    {
        return Task.FromResult(DynamicFormExtensions.ToDynamicFormParameters<BusinessRegistrationModel>());
    }

    private async Task<(bool IsValid, Dictionary<string, List<string>>? errors)> ValidateRequiredFields(
        Dictionary<string, object> data)
    {
        if (!data.Any())
        {
            return (false, null);
        }

        var dynamicFormModel = data.ToDynamicFormModel<BusinessRegistrationModel>();
        var validationContext = new ValidationContext<BusinessRegistrationModel>(dynamicFormModel);
        var validationResults =
            await (new DynamicFormValidator<BusinessRegistrationModel>()).ValidateAsync(validationContext, default);

        var fieldErrors = validationResults.Errors.GroupBy(x => x.PropertyName)
            .ToDictionary(x => x.Key, x => x.Select(eg => eg.ErrorMessage).ToList());

        return (validationResults.IsValid, fieldErrors);
    }

    public override async Task<GuestValidationResult> ValidateAsync(
        RegistrationCommand command,
        CancellationToken cancellationToken = default)
    {
        // Mevcut state'i bul veya yeni oluştur
        var state = await _context.BusinessRegistrationStates
            .FirstOrDefaultAsync(s =>
                    s.GuestId == _workContext.GuestId &&
                    
                    s.IsActive,
                cancellationToken);

        if (state == null)
        {
            state = new BusinessRegistrationState(_workContext.GuestRegistration!);
            await _context.BusinessRegistrationStates.AddAsync(state, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            return CreateValidationError("");
        }

        // Resume the same business after a secret-store outage instead of creating a new identity.
        if (state.BusinessId.HasValue)
        {
            var registered = await _context.Businesses.FirstAsync(b => b.Id == state.BusinessId.Value, cancellationToken);
            await FinishRegistration(registered, state, cancellationToken);
            return GuestValidationResult.Success();
        }

        if (!command.Data.Any())
            return CreateValidationError("");

        var (isValid, errorMessages) = await ValidateRequiredFields(command.Data);
        if (!isValid)
        {
            return CreateValidationError("Lütfen bilgilerinizi kontrol ederek tekrar deneyiniz!", errorMessages!);
        }

        var model = command.Data.ToDynamicFormModel<BusinessRegistrationModel>();
        // Vergi numarası kullanımda mı kontrolü
        var existingBusiness = await _context.Businesses
            .FirstOrDefaultAsync(b =>
                    b.TaxNumber == model.TaxNumber &&
                    !b.IsDeleted,
                cancellationToken);

        if (existingBusiness != null)
        {
            return GuestValidationResult.Failure(StepKey,
                "Bu vergi numarası ile kayıtlı bir işletme zaten mevcut");
        }

        // İşletme kaydı oluşturma
        var business = new Business(
            model.Name,
            model.OwnerName,
            _workContext.UserEmail!,
            model.Phone,
            model.TaxNumber,
            model.TaxOffice,
            model.Address,
            model.City,
            model.District,
            model.PostalCode,
            model.LegalCompanyName,
            _workContext.GuestId!.Value);
        
        
        await _context.Businesses.AddAsync(business, cancellationToken);

        
        _workContext.GuestRegistration!.ConvertToBusiness(business);

        _context.GuestRegistrations.Update(_workContext.GuestRegistration);

        // State'i güncelle ve tamamlandı olarak işaretle
        state.LinkBusiness(business);
        state.SetTaxValidation(business.TaxNumber,true);
        // Persist the identity first. A retry can resume provisioning if the shared store is unavailable.
        await _context.SaveChangesAsync(cancellationToken);
        await FinishRegistration(business, state, cancellationToken);

        return GuestValidationResult.Success();
    }

    private async Task FinishRegistration(Business business, BusinessRegistrationState state, CancellationToken ct)
    {
        await tenantSecrets.ProvisionAsync(business.Id.ToString("N"), business.ToSubdomain(), ct);
        if (state.IsCompleted) return;
        state.Complete();
        await _context.SaveChangesAsync(ct);
        await mediator.Publish(new BusinessRegistrationCompletedEvent(business.Id), ct);
    }
}

public class BusinessRegistrationModel
{
    [DynamicFormFieldName("name")]
    [Display(Name = "İşletme Adı")]
    [Required(ErrorMessage = "İşletme adı zorunludur")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "İşletme adı 2-100 karakter arasında olmalıdır")]
    public string Name { get; set; } = null!;
    
    [DynamicFormFieldName("legalCompanyName")]
    [Display(Name = "Şirket Unvanı")]
    [Required(ErrorMessage = "Yasal şirket unvanı zorunludur")]
    [StringLength(200, MinimumLength = 2, ErrorMessage = "Yasal şirket unvanı 2-200 karakter arasında olmalıdır")]
    public string LegalCompanyName { get; set; } = null!;

    [DynamicFormFieldName("ownerName")]
    [Display(Name = "Şirket Sahibi Ad Soyad")]
    [Required(ErrorMessage = "İşletme sahibinin adı zorunludur")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "İşletme sahibi adı 2-100 karakter arasında olmalıdır")]
    public string OwnerName { get; set; } = null!;

    [DynamicFormFieldName("taxNumber")]
    [Display(Name = "Vergi Numarası")]
    [Required(ErrorMessage = "Vergi numarası zorunludur")]
    [RegularExpression(@"^\d{10}$", ErrorMessage = "Vergi numarası 10 haneli olmalıdır")]
    public string TaxNumber { get; set; } = null!;

    [DynamicFormFieldName("taxOffice")]
    [Display(Name = "Vergi Dairesi")]
    [Required(ErrorMessage = "Vergi dairesi zorunludur")]
    [StringLength(100, ErrorMessage = "Vergi dairesi en fazla 100 karakter olabilir")]
    public string TaxOffice { get; set; } = null!;
    
    [DynamicFormFieldName("phone")]
    [Display(Name = "Telefon")]
    [Required(ErrorMessage = "Telefon numarası zorunludur")]
    [RegularExpression(@"^[0-9]{10}$", ErrorMessage = "Geçerli bir telefon numarası giriniz")]
    public string Phone { get; set; } = null!;
    

    [DynamicFormFieldName("address")]
    [Display(Name = "Tam Adres")]
    [Required(ErrorMessage = "Adres zorunludur")]
    [StringLength(500, MinimumLength = 10, ErrorMessage = "Adres 10-500 karakter arasında olmalıdır")]
    public string Address { get; set; } = null!;

    [DynamicFormFieldName("city")]
    [Display(Name = "İl")]
    [Required(ErrorMessage = "İl zorunludur")]
    [StringLength(50, ErrorMessage = "İl en fazla 50 karakter olabilir")]
    public string City { get; set; } = null!;

    [DynamicFormFieldName("district")]
    [Display(Name = "İlçe")]
    [Required(ErrorMessage = "İlçe zorunludur")]
    [StringLength(50, ErrorMessage = "İlçe en fazla 50 karakter olabilir")]
    public string District { get; set; } = null!;

    [DynamicFormFieldName("postalCode")]
    [Display(Name = "Posta Kodu")]
    [Required(ErrorMessage = "Posta kodu zorunludur")]
    [RegularExpression(@"^\d{5}$", ErrorMessage = "Posta kodu 5 haneli olmalıdır")]
    public string PostalCode { get; set; } = null!;

    
}
