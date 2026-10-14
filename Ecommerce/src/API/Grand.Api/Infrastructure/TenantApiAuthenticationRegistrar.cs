using Grand.Api.Infrastructure.Extensions;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Tenants.Extensions;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Extensions;
using Grand.Infrastructure.MultiTenant;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace Grand.Api.Infrastructure;

public class TenantApiAuthenticationRegistrar : IAuthenticationBuilder
{
    public void AddAuthentication(AuthenticationBuilder builder, IConfiguration configuration)
    {
        builder.AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
        {
            var config = new TenantBackendAPIConfig();
            configuration.GetSection("BackendAPI").Bind(config);
            
            options.TokenValidationParameters = new TokenValidationParameters 
            {
                ValidateIssuer = config.ValidateIssuer,
                ValidateAudience = config.ValidateAudience,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = config.ValidIssuer,
                ValidAudience = config.ValidAudience,
                // The IssuerSigningKey will be set in the OnTokenValidated event
                // to use the tenant-specific key
            };

            options.Events = new JwtBearerEvents 
            {
                OnAuthenticationFailed = async context =>
                {
                    context.NoResult();
                    context.Response.StatusCode = 401;
                    context.Response.ContentType = "text/plain";
                    await context.Response.WriteAsync(context.Exception.Message);
                },
                OnChallenge = context =>
                {
                    context.HandleResponse();
                    return Task.CompletedTask;
                },
                OnTokenValidated = async context =>
                {
                    try
                    {
                        if (config.Enabled)
                        {
                            // Get the tenant ID from the HTTP context
                            var tenantId = context.HttpContext.GetTenantId();
                            
                            // Get the tenant-specific secret service
                            var tenantSecretService = context.HttpContext.RequestServices
                                .GetRequiredService<ITenantSecretService>();
                            
                            // Get the tenant-specific key
                            var securityKey = await TenantJwtSecurityKey.CreateBackendAsync(
                                tenantSecretService, tenantId);
                            
                            // Update the validation parameters with the tenant-specific key
                            context.Options.TokenValidationParameters.IssuerSigningKey = securityKey;
                            
                            // If tenant ID is used as issuer/audience, update the validation parameters
                            if (config.ValidateIssuer && !string.IsNullOrEmpty(tenantId))
                            {
                                context.Options.TokenValidationParameters.ValidIssuer = tenantId;
                            }
                            
                            if (config.ValidateAudience && !string.IsNullOrEmpty(tenantId))
                            {
                                context.Options.TokenValidationParameters.ValidAudience = tenantId;
                            }
                            
                            // Validate the token using the backend authentication service
                            var jwtAuthentication = context.HttpContext.RequestServices
                                .GetRequiredService<IJwtBearerAuthenticationService>();
                            if (!await jwtAuthentication.Valid(context))
                                throw new Exception(await jwtAuthentication.ErrorMessage());
                        }
                        else
                        {
                            throw new Exception("API is disabled");
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(ex.Message);
                    }
                }
            };
        });

        builder.AddJwtBearer(TenantFrontendAPIConfig.AuthenticationScheme, options =>
        {
            var config = new TenantFrontendAPIConfig();
            configuration.GetSection("FrontendAPI").Bind(config);
            
            options.TokenValidationParameters = new TokenValidationParameters 
            {
                ValidateIssuer = config.ValidateIssuer,
                ValidateAudience = config.ValidateAudience,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = config.ValidIssuer,
                ValidAudience = config.ValidAudience,
                // The IssuerSigningKey will be set in the OnTokenValidated event
                // to use the tenant-specific key
                ClockSkew = TimeSpan.Zero
            };

            options.Events = new JwtBearerEvents 
            {
                OnMessageReceived = async context =>
                {
                    try
                    {
                        if (config.Enabled)
                        {
                            // Get the tenant ID from the HTTP context
                            var tenantId = context.HttpContext.GetTenantId();
                            
                            // Get the tenant-specific secret service
                            var tenantSecretService = context.HttpContext.RequestServices
                                .GetRequiredService<ITenantSecretService>();
                            
                            // Get the tenant-specific key
                            var securityKey = await TenantJwtSecurityKey.CreateFrontendAsync(
                                tenantSecretService, tenantId);
                            
                            // Update the validation parameters with the tenant-specific key
                            context.Options.TokenValidationParameters.IssuerSigningKey = securityKey;
                            
                            // If tenant ID is used as issuer/audience, update the validation parameters
                            if (config.ValidateIssuer && !string.IsNullOrEmpty(tenantId))
                            {
                                context.Options.TokenValidationParameters.ValidIssuer = tenantId;
                            }
                            
                            if (config.ValidateAudience && !string.IsNullOrEmpty(tenantId))
                            {
                                context.Options.TokenValidationParameters.ValidAudience = tenantId;
                            }
                            
                            // // Validate the token using the customer authentication service
                            // var jwtAuthentication = context.HttpContext.RequestServices
                            //     .GetRequiredService<IJwtBearerCustomerAuthenticationService>();
                            // var isValid = await jwtAuthentication.Valid(context);
                            // if (!isValid)
                            //     throw new Exception(await jwtAuthentication.ErrorMessage());
                        }
                        else
                        {
                            throw new Exception("API is disabled");
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(ex.Message);
                    }
                },
                OnAuthenticationFailed = async context =>
                {
                    context.NoResult();
                    context.Response.StatusCode = 401;
                    context.Response.ContentType = "text/plain";
                    await context.Response.WriteAsync(context.Exception.Message);
                },
                OnChallenge = context =>
                {
                    context.HandleResponse();
                    return Task.CompletedTask;
                },
                OnTokenValidated = async context =>
                {
                    try
                    {
                        if (config.Enabled)
                        {
                            // Get the tenant ID from the HTTP context
                            // var tenantId = context.HttpContext.GetTenantId();
                            //
                            // // Get the tenant-specific secret service
                            // var tenantSecretService = context.HttpContext.RequestServices
                            //     .GetRequiredService<ITenantSecretService>();
                            //
                            // // Get the tenant-specific key
                            // var securityKey = await TenantJwtSecurityKey.CreateFrontendAsync(
                            //     tenantSecretService, tenantId);
                            //
                            // // Update the validation parameters with the tenant-specific key
                            // context.Options.TokenValidationParameters.IssuerSigningKey = securityKey;
                            //
                            // // If tenant ID is used as issuer/audience, update the validation parameters
                            // if (config.ValidateIssuer && !string.IsNullOrEmpty(tenantId))
                            // {
                            //     context.Options.TokenValidationParameters.ValidIssuer = tenantId;
                            // }
                            //
                            // if (config.ValidateAudience && !string.IsNullOrEmpty(tenantId))
                            // {
                            //     context.Options.TokenValidationParameters.ValidAudience = tenantId;
                            // }
                            
                            // Validate the token using the customer authentication service
                            var jwtAuthentication = context.HttpContext.RequestServices
                                .GetRequiredService<IJwtBearerCustomerAuthenticationService>();
                            var isValid = await jwtAuthentication.Valid(context);
                            if (!isValid)
                                throw new Exception(await jwtAuthentication.ErrorMessage());
                        }
                        else
                        {
                            throw new Exception("API is disabled");
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(ex.Message);
                    }
                }
            };
        });
    }

    public int Priority => 900;
}