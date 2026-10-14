using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Constants;
using SaasManager.Domain.Entities.Operations;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Infrastructure.Data.Configurations.Organization;

public class BusinessConfiguration: BaseEntityTypeConfiguration<Business>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Business> builder)
    {
        builder.ToTable("Businesses");

            // Properties
            builder.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(EntityConstants.MaxNameLength);

            builder.Property(e => e.OwnerName)
                .IsRequired()
                .HasMaxLength(EntityConstants.MaxNameLength);

            builder.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(EntityConstants.MaxEmailLength);

            builder.Property(e => e.Phone)
                .IsRequired()
                .HasMaxLength(EntityConstants.MaxPhoneLength);

            builder.Property(e => e.TaxNumber)
                .IsRequired()
                .HasMaxLength(20);

            builder.Property(e => e.TaxOffice)
                .HasMaxLength(100);

            builder.Property(e => e.Address)
                .IsRequired();

            builder.Property(e => e.City)
                .IsRequired()
                .HasMaxLength(50);

            builder.Property(e => e.District)
                .IsRequired()
                .HasMaxLength(50);

            builder.Property(e => e.PostalCode)
                .HasMaxLength(20);

            builder.Property(e => e.LegalCompanyName)
                .IsRequired()
                .HasMaxLength(200);

            builder.Property(e => e.Status)
                .IsRequired()
                .HasConversion<string>();

            // Indexes
            builder.HasIndex(e => e.Email)
                .IsUnique();

            builder.HasIndex(e => e.TaxNumber)
                .IsUnique();

            builder.HasIndex(e => e.Phone);
            builder.HasIndex(e => e.Status);

            // Relationships
            builder.HasOne(e => e.CreatedByGuest)
                .WithOne()
                .HasForeignKey<Business>(e => e.CreatedByGuestId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasOne(e => e.DatabaseConfig)
                .WithOne(e => e.Business)
                .HasForeignKey<DatabaseConfig>(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.Subscriptions)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.Payments)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.Apps)
                .WithOne(p=>p.Business)
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.Settings)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasMany(e => e.Users)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.PaymentMethods)
                .WithOne(p=>p.Business)
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(e => e.Notifications)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasMany(e => e.SystemLogs)
                .WithOne()
                .HasForeignKey(e => e.BusinessId)
                .OnDelete(DeleteBehavior.Restrict);
    }
}
