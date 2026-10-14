using Grand.Infrastructure.Configuration;
using Grand.SharedKernel.Extensions;
using Grand.Web.ExternalSettings.DataProtection;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using StackExchange.Redis;
using System;
using System.IO;
using Azure.Identity;

namespace Grand.Web.ExternalSettings.Extensions
{
    public static class DataProtectionExtensions
    {
        /// <summary>
        /// Adds tenant-aware data protection services
        /// </summary>
        public static IServiceCollection AddTenantAwareDataProtection(this IServiceCollection services, IConfiguration configuration)
        {
            // First register the standard DataProtection services
            var redisConfig = new RedisConfig();
            configuration.GetSection("Redis").Bind(redisConfig);

            var azureConfig = new AzureConfig();
            configuration.GetSection("Azure").Bind(azureConfig);

            IDataProtectionBuilder dataProtectionBuilder;

            if (redisConfig.PersistKeysToRedis)
            {
                dataProtectionBuilder = services.AddDataProtection()
                    .SetApplicationName(Environment.GetEnvironmentVariable("TENANT_APP_INSTANCE_ID") ?? Guid.NewGuid().ToString())
                    .PersistKeysToStackExchangeRedis(ConnectionMultiplexer.Connect(redisConfig.PersistKeysToRedisUrl));
            }
            else if (azureConfig.PersistKeysToAzureKeyVault || azureConfig.PersistKeysToAzureBlobStorage)
            {
                dataProtectionBuilder = services.AddDataProtection();

                if (azureConfig.PersistKeysToAzureKeyVault)
                    dataProtectionBuilder
                        .PersistKeysToAzureBlobStorage(azureConfig.PersistKeysAzureBlobStorageConnectionString,
                            azureConfig.DataProtectionContainerName, azureConfig.DataProtectionBlobName)
                        .ProtectKeysWithAzureKeyVault(new Uri(azureConfig.KeyIdentifier),
                            new DefaultAzureCredential());
                else
                    dataProtectionBuilder
                        .PersistKeysToAzureBlobStorage(azureConfig.PersistKeysAzureBlobStorageConnectionString,
                            azureConfig.DataProtectionContainerName, azureConfig.DataProtectionBlobName);
            }
            else
            {
                var securityConfig = new SecurityConfig();
                configuration.GetSection("Security").Bind(securityConfig);

                var dataProtectionKeysPath = string.IsNullOrEmpty(securityConfig.KeyPersistenceLocation)
                    ? CommonPath.DataProtectionKeysPath
                    : securityConfig.KeyPersistenceLocation;
                
                var dataProtectionKeysFolder = new DirectoryInfo(dataProtectionKeysPath);

                dataProtectionBuilder = services.AddDataProtection()
                    .PersistKeysToFileSystem(dataProtectionKeysFolder);
            }

            // Ensure we have HttpContextAccessor
            services.AddHttpContextAccessor();

            // We need to ensure we don't get into circular dependency issues. A direct replacement
            // approach of the IDataProtectionProvider can cause issues. Let's use a different approach.
            
            // Store the original DataProtectionProvider in a specific slot
            services.AddSingleton(serviceProvider => 
            {
                return new DataProtectionProviderWrapper(
                    DataProtectionProvider.Create(new DirectoryInfo(CommonPath.DataProtectionKeysPath),
                        configure => 
                        {
                            configure.SetApplicationName(Environment.GetEnvironmentVariable("TENANT_APP_INSTANCE_ID") ?? "GrandNode");
                            if (redisConfig.PersistKeysToRedis)
                            {
                                configure.PersistKeysToStackExchangeRedis(
                                    ConnectionMultiplexer.Connect(redisConfig.PersistKeysToRedisUrl));
                            }
                        }
                    )
                );
            });
            
            // Now register our tenant-aware provider
            services.AddScoped<TenantAwareDataProtectionProvider>(provider => 
            {
                var baseProvider = provider.GetRequiredService<DataProtectionProviderWrapper>().Provider;
                var httpContextAccessor = provider.GetRequiredService<Microsoft.AspNetCore.Http.IHttpContextAccessor>();
                return new TenantAwareDataProtectionProvider(baseProvider, httpContextAccessor);
            });
            
            // Finally, register the tenant-aware provider as the default IDataProtectionProvider
            services.AddScoped<IDataProtectionProvider>(provider => 
                provider.GetRequiredService<TenantAwareDataProtectionProvider>());

            return services;
        }
    }
}