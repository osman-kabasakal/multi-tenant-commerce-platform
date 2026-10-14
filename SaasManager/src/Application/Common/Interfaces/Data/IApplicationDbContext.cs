using SaasManager.Domain.Entities;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Operations;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Application.Common.Interfaces.Data;

public interface IApplicationDbContext
{
    
    // Identity Management Domain
    DbSet<GuestRegistration> GuestRegistrations { get; }
    DbSet<VerificationLog> VerificationLogs { get; }
    DbSet<RegistrationState> RegistrationStates { get; }
    DbSet<EmailVerificationState> EmailVerificationStates { get; }
    DbSet<PaymentSetupState> PaymentSetupStates { get; }
    
    DbSet<BusinessRegistrationState> BusinessRegistrationStates { get; }
    DbSet<SubscriptionSelectionState> SubscriptionSelectionStates { get; }

    // Organization Domain
    DbSet<Business> Businesses { get; }
    DbSet<BusinessUser> BusinessUsers { get; }
    DbSet<BusinessSettings> BusinessSettings { get; }
    DbSet<BusinessApp> BusinessApps { get; }

    // Billing Domain
    DbSet<SubscriptionPlan> SubscriptionPlans { get; }
    DbSet<BusinessSubscription> BusinessSubscriptions { get; }

    // Financial Domain
    DbSet<Payment> Payments { get; }
    DbSet<PaymentMethod> PaymentMethods { get; }
    DbSet<PaymentProvider> PaymentProviders { get; }

    // Operations Domain
    DbSet<DatabaseConfig> DatabaseConfigs { get; }
    DbSet<SystemLog> SystemLogs { get; }
    DbSet<Notification> Notifications { get; }
    DbSet<IpBan> IpBans { get; }
    
    //Registered Apps
    DbSet<AppBuild>  AppBuilds { get; }
    DbSet<AppRelease>  AppReleases { get; } 
    DbSet<AppMediaAsset> AppMediaAssets { get; }    
    DbSet<AppScreenshot> AppScreenshots { get; }
    
    DbSet<AppStoreMetadata> AppStoreMetadatas { get; }
    
    
    
    DbSet<TodoList> TodoLists { get; }

    DbSet<TodoItem> TodoItems { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
