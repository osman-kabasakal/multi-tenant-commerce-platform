using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Infrastructure.Data.Configurations.Registration;

public class RegistrationStateConfiguration : BaseEntityTypeConfiguration<RegistrationState>
{
    protected override void ConfigureEntity(EntityTypeBuilder<RegistrationState> builder)
    {
        builder.ToTable("RegistrationStates");

        // Base configuration
        builder.HasKey(e => e.Id);

        builder.Ignore(x => x.StateKey)
            .Ignore(x=>x.Priority);
        
        builder.Property(e => e.CreatedAt)
            .IsRequired();

        builder.Property(e => e.UpdatedAt);
        
        builder.Property(e => e.CompletedAt);

        // TPH (Table Per Hierarchy) inheritance
        builder.HasDiscriminator<string>("StateType")
            .HasValue<EmailVerificationState>("EmailVerification")
            .HasValue<PaymentSetupState>("PaymentSetup")
            .HasValue<BusinessRegistrationState>("BusinessRegistration")
            .HasValue<SubscriptionSelectionState>("SubscriptionSelection");

        builder.Property("StateType")
            .HasMaxLength(50)
            .IsRequired();

        // Relationships
        builder.HasOne(e => e.Guest)
            .WithMany(g => g.RegistrationStates)
            .HasForeignKey(e => e.GuestId)
            .OnDelete(DeleteBehavior.Restrict);

        // Indexes  e => new { e.GuestId, e.StateType }
        builder.HasIndex("GuestId","StateType")
            .HasFilter("\"IsDeleted\" = false");

        builder.HasIndex(e => e.CompletedAt);
    }
}
