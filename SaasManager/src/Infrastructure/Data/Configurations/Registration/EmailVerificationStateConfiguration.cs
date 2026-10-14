using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Infrastructure.Data.Configurations.Registration;

public class EmailVerificationStateConfiguration : IEntityTypeConfiguration<EmailVerificationState>
{
    public void Configure(EntityTypeBuilder<EmailVerificationState> builder)
    {
        builder.Property(e => e.VerificationCode)
            .HasMaxLength(6);

        builder.Property(e => e.CodeExpiresAt);

        builder.Property(e => e.VerificationAttempts)
            .IsRequired()
            .HasDefaultValue(0);
    }
}