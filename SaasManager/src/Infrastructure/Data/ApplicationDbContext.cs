using System.Reflection;
using SaasManager.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Operations;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Infrastructure.Data.Configurations;

namespace SaasManager.Infrastructure.Data;

public class ApplicationDbContext : DbContext, IApplicationDbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }
    
    // Identity Management Domain
    public DbSet<GuestRegistration> GuestRegistrations => Set<GuestRegistration>();
    public DbSet<VerificationLog> VerificationLogs => Set<VerificationLog>();
    public DbSet<RegistrationState> RegistrationStates => Set<RegistrationState>();
    public DbSet<EmailVerificationState> EmailVerificationStates => Set<EmailVerificationState>();
    public DbSet<PaymentSetupState> PaymentSetupStates => Set<PaymentSetupState>();

    public DbSet<BusinessRegistrationState> BusinessRegistrationStates => Set<BusinessRegistrationState>();
    public DbSet<SubscriptionSelectionState> SubscriptionSelectionStates => Set<SubscriptionSelectionState>();

    // Organization Domain
    public DbSet<Business> Businesses => Set<Business>();
    public DbSet<BusinessUser> BusinessUsers => Set<BusinessUser>();
    public DbSet<BusinessSettings> BusinessSettings => Set<BusinessSettings>();
    public DbSet<BusinessApp> BusinessApps => Set<BusinessApp>();

// Billing Domain
    public DbSet<SubscriptionPlan> SubscriptionPlans => Set<SubscriptionPlan>();
    public DbSet<BusinessSubscription> BusinessSubscriptions => Set<BusinessSubscription>();

// Financial Domain
    public DbSet<Payment> Payments => Set<Payment>();
    public DbSet<PaymentMethod> PaymentMethods => Set<PaymentMethod>();
    public DbSet<PaymentProvider> PaymentProviders => Set<PaymentProvider>();

// Operations Domain
    public DbSet<DatabaseConfig> DatabaseConfigs => Set<DatabaseConfig>();
    public DbSet<SystemLog> SystemLogs => Set<SystemLog>();
    public DbSet<Notification> Notifications => Set<Notification>();
    public DbSet<IpBan> IpBans => Set<IpBan>();
    
    //Registered Apps
    public DbSet<AppBuild> AppBuilds => Set<AppBuild>();
    public DbSet<AppRelease> AppReleases => Set<AppRelease>();
    public DbSet<AppMediaAsset> AppMediaAssets => Set<AppMediaAsset>();
    public DbSet<AppScreenshot> AppScreenshots => Set<AppScreenshot>();
    public DbSet<AppStoreMetadata> AppStoreMetadatas => Set<AppStoreMetadata>();
    

    public DbSet<TodoList> TodoLists => Set<TodoList>();

    public DbSet<TodoItem> TodoItems => Set<TodoItem>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        builder.ApplyEntityConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        builder.ApplyConfiguration<TodoItem>(new TodoItemConfiguration());
        builder.ApplyConfiguration<TodoList>(new TodoListConfiguration());
    }
}
