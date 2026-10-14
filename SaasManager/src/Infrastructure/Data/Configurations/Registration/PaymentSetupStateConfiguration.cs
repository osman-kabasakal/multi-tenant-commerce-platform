using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Infrastructure.Data.Configurations.Registration;

public class PaymentSetupStateConfiguration : IEntityTypeConfiguration<PaymentSetupState>
{
    public void Configure(EntityTypeBuilder<PaymentSetupState> builder)
    {
        builder.Property(e => e.PreAuthAmount)
            .HasPrecision(18, 2);

        builder.Property(e => e.AuthorizationCode)
            .HasMaxLength(50);

        builder.Property(e => e.LastAttemptAt);
        
        builder.Property(e => e.PaymentMethodId)
            .HasColumnName("PaymentMethodId");
        
        builder.HasOne(e => e.PaymentMethod)
            .WithMany()
            .HasForeignKey(e => e.PaymentMethodId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
