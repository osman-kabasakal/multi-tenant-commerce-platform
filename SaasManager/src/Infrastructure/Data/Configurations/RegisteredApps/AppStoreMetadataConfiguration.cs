using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Infrastructure.Data.Configurations.RegisteredApps;

public class AppStoreMetadataConfiguration: BaseEntityTypeConfiguration<AppStoreMetadata>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AppStoreMetadata> builder)
    {
        // Table name
        builder.ToTable("AppStoreMetadata");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.Platform)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.AppTitle)
            .HasMaxLength(100);

        builder.Property(e => e.ShortDescription)
            .HasMaxLength(500);

        builder.Property(e => e.FullDescription)
            .HasMaxLength(4000);

        builder.Property(e => e.Keywords)
            .HasMaxLength(500);

        builder.Property(e => e.PrimaryCategory)
            .HasMaxLength(100);

        builder.Property(e => e.SecondaryCategory)
            .HasMaxLength(100);

        builder.Property(e => e.MinimumOsVersion)
            .HasMaxLength(20);

        builder.Property(e => e.SupportUrl)
            .HasMaxLength(500);

        builder.Property(e => e.PrivacyPolicyUrl)
            .HasMaxLength(500);

        builder.Property(e => e.AppleAppId)
            .HasMaxLength(20);

        builder.Property(e => e.GooglePackageName)
            .HasMaxLength(200);

        builder.Property(e => e.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Relationships
        builder.HasOne(e => e.BusinessApp)
            .WithMany(ba => ba.Stores)
            .HasForeignKey(e => e.BusinessAppId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(e => new { e.BusinessAppId, e.Platform })
            .IsUnique();
            
        builder.HasIndex(e => e.AppleAppId);
        builder.HasIndex(e => e.GooglePackageName);
    }
}
