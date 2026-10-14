using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Infrastructure.Data.Configurations.Organization;

public class BusinessAppConfiguration : BaseEntityTypeConfiguration<BusinessApp>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessApp> builder)
    {
        builder.ToTable("BusinessApps");

        // Properties
        builder.Property(e => e.AppName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(e => e.PackageName)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(e => e.Version)
            .IsRequired()
            .HasMaxLength(20);

        builder.Property(e => e.BuildNumber)
            .IsRequired();

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.BuildStatus)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.BuildPriority)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.StoreUrl)
            .HasMaxLength(500);

        builder.Property(e => e.BuildConfiguration)
            .HasColumnType("jsonb");

        builder.Property(e => e.BuildLogs)
            .HasColumnType("jsonb");

        builder.Property(e => e.ErrorMessage)
            .HasMaxLength(1000);

        // Indexes
        builder.HasIndex(e => new { e.BusinessId, e.Type })
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.PackageName)
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.BuildStatus);
        builder.HasIndex(e => e.BuildPriority);
        builder.HasIndex(e => e.NextScheduledBuildAt);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.Apps)
            .HasForeignKey(e => e.BusinessId)
            .HasPrincipalKey(b => b.Id)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
