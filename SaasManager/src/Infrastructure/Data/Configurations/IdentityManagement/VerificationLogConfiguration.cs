using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Infrastructure.Data.Configurations.IdentityManagement;

public class VerificationLogConfiguration : BaseEntityTypeConfiguration<VerificationLog>
{
    protected override void ConfigureEntity(EntityTypeBuilder<VerificationLog> builder)
    {
        builder.ToTable("VerificationLogs");

        // Properties
        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Code)
            .IsRequired()
            .HasMaxLength(10);

        builder.Property(e => e.SentAt)
            .IsRequired();

        builder.Property(e => e.ExpiresAt)
            .IsRequired();

        builder.Property(e => e.IsVerified)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.AttemptCount)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.LastErrorMessage)
            .HasMaxLength(200);

        // Indexes
        builder.HasIndex(e => new { e.GuestRegistrationId, e.Type, e.CreatedAt });
        builder.HasIndex(e => e.IsVerified);
        builder.HasIndex(e => e.ExpiresAt);

        
    }
}
