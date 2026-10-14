using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Infrastructure.Data.Configurations.Organization;

public class BusinessUserConfiguration : BaseEntityTypeConfiguration<BusinessUser>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessUser> builder)
    {
        builder.ToTable("BusinessUsers");

        // Properties
        builder.Property(e => e.Name)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(e => e.Email)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(e => e.Phone)
            .HasMaxLength(20);

        builder.Property(e => e.Role)
            .IsRequired()
            .HasConversion<string>();

        builder.Property(e => e.KeycloakUserId)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(e => e.ProfilePhotoUrl)
            .HasMaxLength(500);

        builder.Property(e => e.Permissions)
            .HasColumnType("jsonb");

        builder.Property(e => e.RequirePasswordChange)
            .IsRequired()
            .HasDefaultValue(true);

        builder.Property(e => e.FailedLoginAttempts)
            .IsRequired()
            .HasDefaultValue(0);

        // Indexes
        builder.HasIndex(e => new { e.BusinessId, e.Email })
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.KeycloakUserId)
            .IsUnique()
            .HasFilter("\"IsDeleted\"  = false");

        builder.HasIndex(e => e.Role);
        builder.HasIndex(e => e.LastLoginAt);

        // Relationships
        builder.HasOne(e => e.Business)
            .WithMany(b => b.Users)
            .HasForeignKey(e => e.BusinessId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
