using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Billing;

namespace SaasManager.Infrastructure.Data.Configurations.Billing;

public class BusinessSubscriptionConfiguration : BaseEntityTypeConfiguration<BusinessSubscription>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessSubscription> builder)
    {
        builder.ToTable("BusinessSubscriptions");
        
        // Properties
        builder.Property(e => e.StartDate)
            .IsRequired();

        builder.Property(e => e.EndDate)
            .IsRequired();

        builder.Property(e => e.Amount)
            .IsRequired()
            .HasPrecision(18, 2);

        builder.Property(e => e.Status)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Period)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.IsTrial)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.TrialEndsAt);

        // Indexes
        builder.HasIndex(e => new { e.BusinessId, e.Status });
        builder.HasIndex(e => e.StartDate);
        builder.HasIndex(e => e.EndDate);
        builder.HasIndex(e => e.PlanId);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.Subscriptions)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Plan)
            .WithMany()
            .HasForeignKey(e => e.PlanId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.PreviousPlan)
            .WithMany()
            .HasForeignKey(e => e.PreviousPlanId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
