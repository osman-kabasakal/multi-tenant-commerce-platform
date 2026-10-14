using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Infrastructure.Data.Configurations.RegisteredApps;

public class AppScreenshotConfiguration: BaseEntityTypeConfiguration<AppScreenshot>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AppScreenshot> builder)
    {
        // Table name
        builder.ToTable("AppScreenshots");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.ScreenType)
            .HasMaxLength(50);

        builder.Property(e => e.FileName)
            .HasMaxLength(255);

        builder.Property(e => e.FilePath)
            .HasMaxLength(500);

        builder.Property(e => e.FileSize)
            .IsRequired();

        builder.Property(e => e.Width)
            .IsRequired();

        builder.Property(e => e.Height)
            .IsRequired();

        builder.Property(e => e.DisplayOrder)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Relationships
        builder.HasOne(e => e.BusinessApp)
            .WithMany(ba => ba.Screenshots)
            .HasForeignKey(e => e.BusinessAppId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(e => new { e.BusinessAppId, e.ScreenType, e.DisplayOrder });
        builder.HasIndex(e => e.FilePath).IsUnique();
    }
}
