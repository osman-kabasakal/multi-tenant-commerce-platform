using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Financial;

namespace SaasManager.Infrastructure.Data.Configurations.Financial;

public class PaymentConfiguration : BaseEntityTypeConfiguration<Payment>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Payment> builder)
    {
        builder.ToTable("Payments");

        // Properties
        builder.Property(e => e.Amount)
            .IsRequired()
            .HasPrecision(18, 2);

        builder.Property(e => e.Currency)
            .IsRequired()
            .HasMaxLength(3);

        builder.Property(e => e.Status)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.ProviderTransactionId)
            .HasMaxLength(100);

        builder.Property(e => e.ProviderResponse)
            .HasColumnType("jsonb");

        builder.Property(e => e.RetryCount)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.ErrorCode)
            .HasMaxLength(50);

        builder.Property(e => e.ErrorMessage)
            .HasMaxLength(500);

        // Indexes
        builder.HasIndex(e => e.BusinessId);
        builder.HasIndex(e => e.SubscriptionId);
        builder.HasIndex(e => e.PaymentMethodId);
        builder.HasIndex(e => e.Status);
        builder.HasIndex(e => e.Type);
        builder.HasIndex(e => e.ProviderTransactionId)
            .IsUnique()
            .HasFilter("\"ProviderTransactionId\" IS NOT NULL AND \"IsDeleted\"  = false");

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.Payments)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Subscription)
            .WithMany()
            .HasForeignKey(e => e.SubscriptionId)
            .OnDelete(DeleteBehavior.Restrict);

        // PaymentMethod ilişkisi
        builder.HasOne(e => e.PaymentMethod)
            .WithMany(pm => pm.SubscriptionPayments)
            .HasForeignKey(e => e.PaymentMethodId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Provider)
            .WithMany(p=>p.Payments)
            .HasForeignKey(e => e.ProviderId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
