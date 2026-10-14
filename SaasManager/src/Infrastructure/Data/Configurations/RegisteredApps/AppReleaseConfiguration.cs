using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Infrastructure.Data.Configurations.RegisteredApps;

public class AppReleaseConfiguration: BaseEntityTypeConfiguration<AppRelease>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AppRelease> builder)
    {
        // Table name
        builder.ToTable("AppReleases");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.Platform)
            .HasMaxLength(50);

        builder.Property(e => e.Version)
            .HasMaxLength(20);

        builder.Property(e => e.ReleaseNotes)
            .HasMaxLength(2000);

        builder.Property(e => e.ReleaseStatus)
            .HasMaxLength(50);

        builder.Property(e => e.RejectionReason)
            .HasMaxLength(1000);

        // Relationships
        builder.HasOne(e => e.BusinessApp)
            .WithMany(ba => ba.Releases)
            .HasForeignKey(e => e.BusinessAppId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(e => e.AppBuild)
            .WithMany(ab => ab.Releases)
            .HasForeignKey(e => e.AppBuildId)
            .OnDelete(DeleteBehavior.Restrict);

        // Indexes
        builder.HasIndex(e => new { e.BusinessAppId, e.Version, e.Platform })
            .IsUnique();
            
        builder.HasIndex(e => e.ReleaseStatus);
        builder.HasIndex(e => e.SubmissionDate);
        builder.HasIndex(e => e.PublishedDate);
    }
}
