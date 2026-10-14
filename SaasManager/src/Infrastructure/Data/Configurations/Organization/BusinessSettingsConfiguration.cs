using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Infrastructure.Data.Configurations.Organization;

public class BusinessSettingsConfiguration : BaseEntityTypeConfiguration<BusinessSettings>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessSettings> builder)
    {
        builder.ToTable("BusinessSettings");

        // Properties
        builder.Property(e => e.Key)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.Value)
            .IsRequired()
            .HasMaxLength(4000);

        builder.Property(e => e.DefaultValue)
            .HasMaxLength(4000);

        builder.Property(e => e.Description)
            .HasMaxLength(500);

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.DataType)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.IsSystem)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.IsRequired)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.ValidationRule)
            .HasMaxLength(1000);

        builder.Property(e => e.DisplayOrder)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.GroupName)
            .HasMaxLength(50);

        // Indexes
        builder.HasIndex(e => new { e.BusinessId, e.Key })
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.Type);
        builder.HasIndex(e => e.GroupName);
        builder.HasIndex(e => e.DisplayOrder);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.Settings)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
