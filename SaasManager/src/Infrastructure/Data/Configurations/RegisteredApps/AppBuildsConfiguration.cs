using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Infrastructure.Data.Configurations.RegisteredApps;

public class AppBuildsConfiguration: BaseEntityTypeConfiguration<AppBuild>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AppBuild> builder)
    {
        // Table name
        builder.ToTable("AppBuilds");

        // Primary Key
        builder.HasKey(e => e.Id);

        // Properties
        builder.Property(e => e.Version)
            .HasMaxLength(20);

        builder.Property(e => e.FilePath)
            .HasMaxLength(500);

        builder.Property(e => e.FileHash)
            .HasMaxLength(100);

        builder.Property(e => e.BuildStatus)
            .HasMaxLength(50);

        builder.Property(e => e.Platform)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Configuration)
            .HasColumnType("jsonb");

        // Relationships
        builder.HasOne(e => e.BusinessApp)
            .WithMany(ba => ba.Builds)
            .HasForeignKey(e => e.BusinessAppId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(e => new { e.BusinessAppId, e.Version, e.BuildNumber, e.Platform })
            .IsUnique();
            
        builder.HasIndex(e => e.BuildStatus);
        builder.HasIndex(e => e.BuildDate);
        builder.HasIndex(e => e.ExpiryDate);
    }
}
