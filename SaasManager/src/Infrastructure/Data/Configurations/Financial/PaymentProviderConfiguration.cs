using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Financial;

namespace SaasManager.Infrastructure.Data.Configurations.Financial;

public class PaymentProviderConfiguration : BaseEntityTypeConfiguration<PaymentProvider>
{
    protected override void ConfigureEntity(EntityTypeBuilder<PaymentProvider> builder)
    {
        builder.ToTable("PaymentProviders");

        // Properties
        builder.Property(e => e.Name)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.Code)
            .IsRequired()
            .HasMaxLength(20);

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Configuration)
            .HasColumnType("jsonb");

        builder.Property(e => e.ApiKey)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.ApiSecret)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.BaseUrl)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.IsSandbox)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.CommissionRate)
            .IsRequired()
            .HasPrecision(5, 2);

        builder.Property(e => e.FixedFee)
            .IsRequired()
            .HasPrecision(10, 2);

        builder.Property(e => e.SupportedCurrencies)
            .HasColumnType("varchar[]");

        builder.Property(e => e.ProcessingTimeoutSeconds)
            .IsRequired()
            .HasDefaultValue(30);

        builder.Property(e => e.IsHealthy)
            .IsRequired()
            .HasDefaultValue(true);

        // Indexes
        builder.HasIndex(e => e.Code)
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.Type);
        builder.HasIndex(e => e.IsHealthy);
        
        // PaymentMethods ilişkisi
        builder.HasMany(e => e.PaymentMethods)
            .WithOne(pm => pm.Provider)
            .HasForeignKey(pm => pm.ProviderId)
            .OnDelete(DeleteBehavior.Restrict);

        // Payments ilişkisi
        builder.HasMany(e => e.Payments)
            .WithOne(p => p.Provider)
            .HasForeignKey(p => p.ProviderId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
