using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Constants;
using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Infrastructure.Data.Configurations.IdentityManagement;

public class GuestRegistrationConfiguration: BaseEntityTypeConfiguration<GuestRegistration>
{
    protected override void ConfigureEntity(EntityTypeBuilder<GuestRegistration> builder)
    {
        builder.ToTable("GuestRegistrations");

        builder.Ignore(x => x.IsConverted)
            .Ignore(x => x.HasBusinessRegistration)
            .Ignore(x=>x.Fullname);
        
            // Properties
            builder.Property(e => e.Email)
                .HasMaxLength(EntityConstants.MaxEmailLength);

            builder.Property(x => x.IsEmailVerified);

            builder.Property(e => e.Phone)
                .HasMaxLength(EntityConstants.MaxPhoneLength);
            
            builder.Property(e => e.Firstname)
                .IsRequired(false)
                .HasMaxLength(EntityConstants.MaxNameLength);
            
            builder.Property(e => e.Lastname)
                .IsRequired(false)
                .HasMaxLength(EntityConstants.MaxNameLength);
            
            builder.Property(e => e.GuestToken)
                .HasMaxLength(1500);


            // Indexes
            builder.HasIndex(e => e.Email);
            builder.HasIndex(e => e.Phone);
            builder.HasIndex(e => e.ConvertedBusinessId)
                .IsUnique()
                .HasFilter("\"ConvertedBusinessId\" IS NOT NULL AND \"IsDeleted\"  = false");

            // Relationships
            builder.HasOne(e => e.ConvertedBusiness)
                .WithOne()
                .HasForeignKey<GuestRegistration>(e => e.ConvertedBusinessId)
                .OnDelete(DeleteBehavior.Restrict);
    }
}
