using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Operations;

namespace SaasManager.Domain.Entities.Organization;

public class Business : AuditableEntity
{
    public string Name { get; private set; } = null!;
    public string OwnerName { get; private set; } = null!;
    public string Email { get; private set; } = null!;
    public string Phone { get; private set; } = null!;
    public string TaxNumber { get; private set; } = null!;
    public string TaxOffice { get; private set; } = null!;
    public string Address { get; private set; } = null!;
    public string City { get; private set; } = null!;
    public string District { get; private set; } = null!;
    public string PostalCode { get; private set; } = null!;
    public string LegalCompanyName { get; private set; } = null!;
    public BusinessStatus Status { get; private set; }
    public Guid CreatedByGuestId { get; private set; }

    // Navigation Properties
    public GuestRegistration CreatedByGuest { get; private set; } = null!;
    public DatabaseConfig DatabaseConfig { get; private set; } = null!;
    public ICollection<BusinessSubscription> Subscriptions { get; private set; }
    public ICollection<Payment> Payments { get; private set; }
    public ICollection<BusinessApp> Apps { get; private set; }
    public ICollection<BusinessSettings> Settings { get; private set; }
    public ICollection<BusinessUser> Users { get; private set; }
    public ICollection<PaymentMethod> PaymentMethods { get; private set; }
    public ICollection<Notification> Notifications { get; private set; }
    public ICollection<SystemLog> SystemLogs { get; private set; }

    // Constructor for EF Core
    protected Business()
    {
        Subscriptions = new List<BusinessSubscription>();
        Payments = new List<Payment>();
        Apps = new List<BusinessApp>();
        Settings = new List<BusinessSettings>();
        Users = new List<BusinessUser>();
        PaymentMethods = new List<PaymentMethod>();
        Notifications = new List<Notification>();
        SystemLogs = new List<SystemLog>();
    }

    public Business(
        string name,
        string ownerName,
        string email,
        string phone,
        string taxNumber,
        string taxOffice,
        string address,
        string city,
        string district,
        string postalCode,
        string legalCompanyName,
        Guid createdByGuestId)
    {
        Name = name;
        OwnerName = ownerName;
        Email = email;
        Phone = phone;
        TaxNumber = taxNumber;
        TaxOffice = taxOffice;
        Address = address;
        City = city;
        District = district;
        PostalCode = postalCode;
        LegalCompanyName = legalCompanyName;
        CreatedByGuestId = createdByGuestId;
        Status = BusinessStatus.Pending;

        Subscriptions = new List<BusinessSubscription>();
        Payments = new List<Payment>();
        Apps = new List<BusinessApp>();
        Settings = new List<BusinessSettings>();
        Users = new List<BusinessUser>();
        PaymentMethods = new List<PaymentMethod>();
        Notifications = new List<Notification>();
        SystemLogs = new List<SystemLog>();
    }

    // Domain methods
    public void UpdateStatus(BusinessStatus newStatus)
    {
        Status = newStatus;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateContactInformation(string email, string phone, string address)
    {
        Email = email;
        Phone = phone;
        Address = address;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateCompanyInformation(
        string name,
        string legalCompanyName,
        string taxNumber,
        string taxOffice)
    {
        Name = name;
        LegalCompanyName = legalCompanyName;
        TaxNumber = taxNumber;
        TaxOffice = taxOffice;
        UpdatedAt = DateTime.UtcNow;
    }
}
