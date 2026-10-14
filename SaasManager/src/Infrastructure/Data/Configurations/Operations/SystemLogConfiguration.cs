using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Operations;

namespace SaasManager.Infrastructure.Data.Configurations.Operations;

public class SystemLogConfiguration : BaseEntityTypeConfiguration<SystemLog>
{
    protected override void ConfigureEntity(EntityTypeBuilder<SystemLog> builder)
    {
        builder.ToTable("SystemLogs");

        // Properties
        builder.Property(e => e.Message)
            .IsRequired()
            .HasMaxLength(4000);

        builder.Property(e => e.Type)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Severity)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.Source)
            .HasMaxLength(200);

        builder.Property(e => e.UserName)
            .HasMaxLength(100);

        builder.Property(e => e.UserRole)
            .HasMaxLength(50);

        builder.Property(e => e.IpAddress)
            .HasMaxLength(50);

        builder.Property(e => e.UserAgent)
            .HasMaxLength(500);

        builder.Property(e => e.CreatedAt)
            .IsRequired();

        builder.Property(e => e.EventId)
            .IsRequired()
            .HasDefaultValue(0);

        builder.Property(e => e.CorrelationId)
            .HasMaxLength(100);

        builder.Property(e => e.Exception)
            .HasMaxLength(4000);

        builder.Property(e => e.StackTrace)
            .HasMaxLength(4000);

        builder.Property(e => e.Metadata)
            .HasColumnType("jsonb");

        // Indexes
        builder.HasIndex(e => e.BusinessId);
        builder.HasIndex(e => e.Type);
        builder.HasIndex(e => e.Severity);
        builder.HasIndex(e => e.CreatedAt);
        builder.HasIndex(e => e.CorrelationId);
        builder.HasIndex(e => e.UserName);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.SystemLogs)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);

        // Note: SystemLog entity doesn't have soft delete functionality
    }
}
