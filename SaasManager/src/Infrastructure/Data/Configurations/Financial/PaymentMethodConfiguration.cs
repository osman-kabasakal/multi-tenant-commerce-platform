using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Financial;

namespace SaasManager.Infrastructure.Data.Configurations.Financial;

public class PaymentMethodConfiguration : BaseEntityTypeConfiguration<PaymentMethod>
{
    protected override void ConfigureEntity(EntityTypeBuilder<PaymentMethod> builder)
    {
        builder.ToTable("PaymentMethods");

        // Properties
        builder.Property(e => e.Token)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.LastFour)
            .HasMaxLength(4);

        builder.Property(e => e.CardBrand)
            .HasMaxLength(20);

        builder.Property(e => e.CardholderName)
            .HasMaxLength(100);

        builder.Property(e => e.IsDefault)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.IsValid)
            .IsRequired()
            .HasDefaultValue(true);
        
        builder.Property(e => e.PaymentProviderData)
            .HasColumnType("jsonb");

        // Indexes
        builder.HasIndex(e => new { e.BusinessId, e.Token })
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.ProviderId);
        builder.HasIndex(e => e.ExpiryDate);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.PaymentMethods)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Provider)
            .WithMany(p=>p.PaymentMethods)
            .HasForeignKey(e => e.ProviderId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
