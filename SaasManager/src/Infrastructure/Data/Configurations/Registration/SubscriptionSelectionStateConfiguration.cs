using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Infrastructure.Data.Configurations.Registration;

public class SubscriptionSelectionStateConfiguration : IEntityTypeConfiguration<SubscriptionSelectionState>
{
    public void Configure(EntityTypeBuilder<SubscriptionSelectionState> builder)
    {
        builder.HasBaseType<RegistrationState>();
        
        builder.Ignore(x => x.StateKey)
            .Ignore(x=>x.Priority);

        builder.Property(e => e.SelectedPlanId)
            .HasColumnName("SelectedPlanId");

        builder.Property(e => e.SelectionDate)
            .HasColumnName("SelectionDate");
        

        builder.Property(e => e.IsTrialSelected)
            .HasColumnName("IsTrialSelected")
            .IsRequired();

        builder.Property(e => e.AttemptCount)
            .HasColumnName("AttemptCount")
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.LastErrorMessage)
            .HasColumnName("LastErrorMessage")
            .HasMaxLength(500);

        // Relationships
        builder.HasOne(e => e.SelectedPlan)
            .WithMany()
            .HasForeignKey(e => e.SelectedPlanId)
            .OnDelete(DeleteBehavior.Restrict);

        
    }
}
