using System.Linq.Expressions;
using System.Reflection;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using SaasManager.Infrastructure.Data.Configurations;

namespace SaasManager.Infrastructure.Data;

public static class ModelBuilderExtensions
    {
        /// <summary>
        /// Verilen assembly içindeki tüm entity configuration'ları bulur ve uygular
        /// </summary>
        /// <param name="modelBuilder">Model builder instance'ı</param>
        /// <param name="assembly">Taranacak assembly. Null ise çağıran assembly kullanılır.</param>
        /// <returns>Model builder instance'ı (fluent API için)</returns>
        public static ModelBuilder ApplyEntityConfigurationsFromAssembly(
            this ModelBuilder modelBuilder,
            Assembly? assembly = null)
        {
            // Assembly belirtilmemişse çağıran assembly'i kullan
            assembly ??= Assembly.GetCallingAssembly();

            // BaseEntityTypeConfiguration'dan türeyen tüm tipleri bul
            var configurationTypes = assembly.GetTypes()
                .Where(type => 
                    !type.IsAbstract && 
                    !type.IsInterface &&
                    type.BaseType != null &&
                    type.BaseType.IsGenericType &&
                    type.BaseType.GetGenericTypeDefinition() == typeof(BaseEntityTypeConfiguration<>));

            foreach (var configurationType in configurationTypes)
            {
                // Configuration instance'ı oluştur
                var configuration = Activator.CreateInstance(configurationType);

                // Entity tipini al (BaseEntityTypeConfiguration<TEntity>'deki TEntity)
                var entityType = configurationType.BaseType!.GetGenericArguments()[0];

                // Generic ApplyConfiguration methodunu çağır
                var applyConfigurationMethod = typeof(ModelBuilder)
                    .GetMethods()
                    .First(m => 
                        m.Name == nameof(ModelBuilder.ApplyConfiguration) &&
                        m.IsGenericMethod)
                    .MakeGenericMethod(entityType);

                applyConfigurationMethod.Invoke(modelBuilder, new[] { configuration });
            }

            return modelBuilder;
        }
        
        /// <summary>
        /// Belirli bir assembly'den sadece verilen namespace altındaki configuration'ları uygular
        /// </summary>
        public static ModelBuilder ApplyEntityConfigurationsFromNamespace(
            this ModelBuilder modelBuilder,
            string @namespace,
            Assembly? assembly = null)
        {
            assembly ??= Assembly.GetCallingAssembly();

            var configurationTypes = assembly.GetTypes()
                .Where(type => 
                    type.Namespace == @namespace &&
                    !type.IsAbstract && 
                    !type.IsInterface &&
                    type.BaseType != null &&
                    type.BaseType.IsGenericType &&
                    type.BaseType.GetGenericTypeDefinition() == typeof(BaseEntityTypeConfiguration<>));

            foreach (var configurationType in configurationTypes)
            {
                var configuration = Activator.CreateInstance(configurationType);
                var entityType = configurationType.BaseType!.GetGenericArguments()[0];
                
                var applyConfigurationMethod = typeof(ModelBuilder)
                    .GetMethods()
                    .First(m => 
                        m.Name == nameof(ModelBuilder.ApplyConfiguration) &&
                        m.IsGenericMethod)
                    .MakeGenericMethod(entityType);

                applyConfigurationMethod.Invoke(modelBuilder, new[] { configuration });
            }

            return modelBuilder;
        }

        /// <summary>
        /// Entity'lerin soft-delete durumunu kontrol eden global query filter'ları ekler
        /// </summary>
        public static void ApplyGlobalFilters<TInterface>(
            this ModelBuilder modelBuilder,
            Expression<Func<TInterface, bool>> expression)
        {
            var entities = modelBuilder.Model
                .GetEntityTypes()
                .Where(e => e.ClrType.GetInterface(typeof(TInterface).Name) != null)
                .Select(e => e.ClrType);

            foreach (var entity in entities)
            {
                var newParam = Expression.Parameter(entity);
                var newBody = ReplacingExpressionVisitor.Replace(
                    expression.Parameters.Single(), 
                    newParam, 
                    expression.Body);

                modelBuilder.Entity(entity)
                    .HasQueryFilter(Expression.Lambda(newBody, newParam));
            }
        }
    }
