using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Infrastructure.Data.Configurations.RegisteredApps;

public class AppMediaAssetConfiguration: BaseEntityTypeConfiguration<AppMediaAsset>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AppMediaAsset> builder)
    {
        // Table name
        builder.ToTable("AppMediaAssets");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.AssetType)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Platform)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.FileName)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(e => e.FilePath)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.FileSize)
            .IsRequired();

        builder.Property(e => e.Width)
            .IsRequired();

        builder.Property(e => e.Height)
            .IsRequired();

        builder.Property(e => e.IsDefault)
            .IsRequired()
            .HasDefaultValue(false);

        // Relationships
        builder.HasOne(e => e.BusinessApp)
            .WithMany(ba => ba.MediaAssets)
            .HasForeignKey(e => e.BusinessAppId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(e => new { e.BusinessAppId, e.AssetType, e.Platform });
        builder.HasIndex(e => e.FilePath).IsUnique();
    }
}
