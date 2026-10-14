using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Infrastructure.Data.Configurations.Registration;

public class BusinessRegistrationStateConfiguration : IEntityTypeConfiguration<BusinessRegistrationState>
{
    public void Configure(EntityTypeBuilder<BusinessRegistrationState> builder)
    {
        builder.Property(e => e.ValidatedTaxNumber)
            .HasMaxLength(20);

        builder.Property(e => e.LastValidationError)
            .HasMaxLength(500);

        builder.Property(e => e.ValidationAttempts)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.LastTaxValidationAttempt);

        // BusinessId nullable olabilir çünkü başlangıçta business oluşturulmamış olabilir
        builder.Property(e => e.BusinessId);

        // Business ile ilişki
        builder.HasOne(e => e.Business)
            .WithOne()
            .HasForeignKey<BusinessRegistrationState>(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict)
            .IsRequired(false);
    }
}
