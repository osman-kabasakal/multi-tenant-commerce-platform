using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Operations;

namespace SaasManager.Infrastructure.Data.Configurations.Operations;

public class IpBanConfiguration : BaseEntityTypeConfiguration<IpBan>
{
    protected override void ConfigureEntity(EntityTypeBuilder<IpBan> builder)
    {
        builder.ToTable("IpBans");

        // Properties
        builder.Property(e => e.IpAddress)
            .IsRequired()
            .HasMaxLength(45); // IPv6 için yeterli uzunluk

        builder.Property(e => e.ExpiresAt)
            .IsRequired();

        builder.Property(e => e.Reason)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.FailedAttempts)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.LastAttempt);

        builder.Property(e => e.AdditionalData)
            .HasColumnType("jsonb");

        // Indexes
        builder.HasIndex(e => e.IpAddress);
        builder.HasIndex(e => e.ExpiresAt);
        builder.HasIndex(e => e.Type);
        builder.HasIndex(e => new { e.IpAddress, e.IsActive })
            .HasFilter("\"IsDeleted\" = false");

        // Relationships
        builder.HasOne(e => e.RelatedGuest)
            .WithMany()
            .HasForeignKey(e => e.RelatedGuestId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
