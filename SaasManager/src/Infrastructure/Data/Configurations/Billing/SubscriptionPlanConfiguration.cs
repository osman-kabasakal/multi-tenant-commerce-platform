using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Billing;

namespace SaasManager.Infrastructure.Data.Configurations.Billing;

public class SubscriptionPlanConfiguration : BaseEntityTypeConfiguration<SubscriptionPlan>
{

    protected override void ConfigureEntity(EntityTypeBuilder<SubscriptionPlan> builder)
    {
        builder.ToTable("SubscriptionPlans");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.Name)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.Code)
            .IsRequired()
            .HasMaxLength(20);

        builder.Property(e => e.Price)
            .IsRequired()
            .HasPrecision(18, 2);

        builder.Property(e => e.SetupFee)
            .IsRequired()
            .HasPrecision(18, 2);

        builder.Property(e => e.Description)
            .HasMaxLength(1000);

        builder.Property(e => e.MaxProducts)
            .IsRequired();

        builder.Property(e => e.MaxUsers)
            .IsRequired();

        builder.Property(e => e.MaxMonthlyOrders)
            .IsRequired();

        builder.Property(e => e.MaxCouriers)
            .IsRequired();

        builder.Property(e => e.MaxLocations)
            .IsRequired();

        builder.Property(e => e.HasPos)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.HasCourier)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.Features)
            .HasColumnType("jsonb");

        builder.Property(e => e.TrialDays)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.IsPublic)
            .IsRequired()
            .HasDefaultValue(true);

        builder.Property(e => e.SupportPriority)
            .IsRequired()
            .HasDefaultValue(0);

        // Indexes
        builder.HasIndex(e => e.Code)
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.IsPublic);
        builder.HasIndex(e => e.Price);
    }
}
