using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Operations;

namespace SaasManager.Infrastructure.Data.Configurations.Operations;

public class DatabaseConfigConfiguration : BaseEntityTypeConfiguration<DatabaseConfig>
{
    protected override void ConfigureEntity(EntityTypeBuilder<DatabaseConfig> builder)
    {
        builder.ToTable("DatabaseConfigs");

        // Properties
        builder.Property(e => e.InstanceName)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.Host)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(e => e.Port)
            .IsRequired();

        builder.Property(e => e.DatabaseName)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.Username)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.EncryptedPassword)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(e => e.ConnectionString)
            .IsRequired()
            .HasMaxLength(1000);

        builder.Property(e => e.Status)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.IsMigrated)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(e => e.LastMigrationDate);
        builder.Property(e => e.LastConnectionTest);

        // Indexes
        builder.HasIndex(e => e.BusinessId)
            .IsUnique();

        builder.HasIndex(e => e.InstanceName)
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.DatabaseName)
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => new { e.Host, e.Port, e.DatabaseName })
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        // Relationships
        builder.HasOne(e => e.Business)
            .WithOne(e => e.DatabaseConfig)
            .HasForeignKey<DatabaseConfig>(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
