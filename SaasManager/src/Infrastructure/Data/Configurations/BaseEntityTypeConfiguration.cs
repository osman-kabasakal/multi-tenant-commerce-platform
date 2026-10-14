using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SaasManager.Domain.Common;

namespace SaasManager.Infrastructure.Data.Configurations
{
    /// <summary>
    /// Tüm entity konfigürasyonları için temel sınıf
    /// </summary>
    /// <typeparam name="TEntity">Konfigüre edilecek entity tipi</typeparam>
    public abstract class BaseEntityTypeConfiguration<TEntity> : IEntityTypeConfiguration<TEntity> 
        where TEntity : BaseEntity
    {
        public void Configure(EntityTypeBuilder<TEntity> builder)
        {
            // Primary Key
            builder.HasKey(e => e.Id);

            // IAuditableEntity implementasyonu varsa
            if (typeof(IAuditableEntity).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property("CreatedAt")
                    .IsRequired();

                builder.Property("CreatedBy");

                builder.Property("UpdatedAt")
                    .IsRequired(false);
            }

            // ISoftDelete implementasyonu varsa
            if (typeof(ISoftDelete).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property("IsDeleted")
                    .IsRequired()
                    .HasDefaultValue(false);

                builder.Property("DeletedAt");

                builder.Property("DeletedBy")
                    .IsRequired(false);

                // Global Query Filter
                builder.HasQueryFilter(e => !EF.Property<bool>(e, "IsDeleted"));
            }

            // IActivatable implementasyonu varsa
            if (typeof(IActivatable).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property("IsActive")
                    .IsRequired()
                    .HasDefaultValue(false);
            }

            // IOptimisticConcurrency implementasyonu varsa
            if (typeof(IOptimisticConcurrency).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property(nameof(IOptimisticConcurrency.RowVersion))
                    .IsRowVersion();
            }

            // Entity özel konfigürasyonlarını uygula
            ConfigureEntity(builder);
        }

        /// <summary>
        /// Entity'ye özel konfigürasyonların uygulanacağı method
        /// </summary>
        /// <param name="builder">Entity type builder</param>
        protected abstract void ConfigureEntity(EntityTypeBuilder<TEntity> builder);
    }
}
