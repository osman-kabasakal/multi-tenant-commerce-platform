using System.Diagnostics.CodeAnalysis;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using Core.Models.Configs;
using Core.Models.Responses;
using Core.Persistence;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Cache;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Email;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Keycloak;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Interfaces.PaymentProviders.IyzicoProvider;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Events.Registration;
using SaasManager.Infrastructure.Authentication;
using SaasManager.Infrastructure.BackgorundServices.RedisEventHandlers;
using SaasManager.Infrastructure.Caching;
using SaasManager.Infrastructure.Common;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.Data.Interceptors;
using SaasManager.Infrastructure.Email;
using SaasManager.Infrastructure.FileStorage;
using SaasManager.Infrastructure.Keycloak;
using SaasManager.Infrastructure.MongoAtlas;
using SaasManager.Infrastructure.PaymentProviders;
using SaasManager.Infrastructure.PaymentProviders.IyzicoProvider;
using SaasManager.Infrastructure.Persistence.ConcurrencyResolvers;
using SaasManager.Infrastructure.Security;
using SaasManager.Infrastructure.Utilities;

namespace SaasManager.Infrastructure;

public static class DependencyInjection
{
    public static void AddInfrastructureServices(this IHostApplicationBuilder builder)
    {
        builder
            .RegisterDatabase()
            .RegisterMongoAtlas()
            .RegisterCache()
            .RegisterApplicationServices();
    }

    private static IHostApplicationBuilder RegisterDatabase(this IHostApplicationBuilder builder)
    {
        var connectionString = builder.Configuration.GetConnectionString("SaasManagerDb");
        Guard.Against.Null(connectionString, message: "Connection string 'SaasManagerDb' not found.");

        builder.Services.AddScoped<IConcurrencyConflictResolver<Business>, BusinessConflictResolver>();

        builder.Services.AddScoped<ISaveChangesInterceptor, AuditableEntityInterceptor>();
        builder.Services.AddScoped<ISaveChangesInterceptor, ConcurrencyHandlingInterceptor>();
        builder.Services.AddScoped<ISaveChangesInterceptor, DispatchDomainEventsInterceptor>();

        builder.Services.AddDbContext<ApplicationDbContext>((sp, options) =>
        {
            options.AddInterceptors(sp.GetServices<ISaveChangesInterceptor>());
            options.UseNpgsql(connectionString);
        }, ServiceLifetime.Scoped);


        builder.Services.AddScoped<IApplicationDbContext>(provider =>
            provider.GetRequiredService<ApplicationDbContext>());

        builder.Services.AddScoped<ApplicationDbContextInitialiser>();


        builder.Services.AddSingleton(TimeProvider.System);

        return builder;
    }

    public static IHostApplicationBuilder RegisterMongoAtlas(this IHostApplicationBuilder builder)
    {
        builder.Services.AddScoped<IMongoDigestAuthenticationHandler, DigestAuthenticationHandler>();

        builder.Services.AddHttpClient("MongoAtlasClient", (_httpClient) =>
        {
            string _baseUrl =
                $"https://cloud.mongodb.com/api/atlas/v2/groups/{builder.Configuration["MongoAtlas:ProjectId"]}/";
            var authString = Convert.ToBase64String(Encoding.ASCII.GetBytes(
                $"{builder.Configuration["MongoAtlas:ClientPublicKey"]}:{builder.Configuration["MongoAtlas:ClientSecret"]}"));
            _httpClient.BaseAddress = new Uri(_baseUrl);
            _httpClient.Timeout = TimeSpan.FromSeconds(30);
            _httpClient.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/vnd.atlas.2024-08-05+json"));
        });

        builder.Services.AddScoped<IMongoAtlasClientService, MongoAtlasClientService>();
        builder.Services.AddScoped<IMongoAtlasManager, MongoAtlasManager>();

        return builder;
    }

    [SuppressMessage("ReSharper.DPA", "DPA0006: Large number of DB commands", MessageId = "count: 56")]
    public static IHostApplicationBuilder RegisterAuthentication(this IHostApplicationBuilder builder)
    {
        var localDemo = builder.Configuration.GetValue<bool>("LocalDemo:Enabled");
        builder.Services.AddScoped<IKeyCloakJwtValidationService, KeyCloakJwtValidationService>();

        builder.Services.Configure<AuthConfiguration>(instance =>
        {
            builder.Configuration.GetSection("AuthConfiguration").Bind(instance);
            instance.ClientSecret = builder.Configuration["AuthConfiguration:ClientSecret"]
                    ?? builder.Configuration.GetValue<string>($"ClientSecret-{instance.ClientId}")!;
        });

        builder.Services.AddOptions<AuthConfiguration>().Validate(instance =>
            Uri.TryCreate(instance.IdentityProviderUrl, UriKind.Absolute, out var authority) &&
            (authority.Scheme == "https" || localDemo && builder.Environment.IsDevelopment() && authority.Scheme == "http") &&
            string.IsNullOrEmpty(authority.UserInfo) && string.IsNullOrEmpty(authority.Query) && string.IsNullOrEmpty(authority.Fragment) &&
            !string.IsNullOrWhiteSpace(instance.ClientId) && !string.IsNullOrWhiteSpace(instance.ClientSecret),
            "Configure an HTTPS identity authority, client id and private client secret; HTTP is limited to the Development local demo.").ValidateOnStart();

        builder.Services.AddAuthentication(options =>
            {
                options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = OpenIdConnectDefaults.AuthenticationScheme;
            })
            .AddCookie(options =>
            {
                options.Cookie.Name = "auth.session";
                options.Cookie.HttpOnly = true;
                options.Cookie.SecurePolicy = localDemo ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always;
                options.Cookie.SameSite = SameSiteMode.Lax;
                options.ExpireTimeSpan = TimeSpan.FromMinutes(60);
                options.SlidingExpiration = true;

                // XSS Protection
                options.Cookie.IsEssential = true;

                // Same-Origin Policy
                options.Cookie.Path = "/";

                // Cookie Prefixing
                options.Cookie.Name = (localDemo ? "demo-" : "__Host-") + options.Cookie.Name;
                options.Events = new CookieAuthenticationEvents()
                {
                    OnSignedIn = async context =>
                    {
                        var dbContext = context.HttpContext.RequestServices.GetRequiredService<IApplicationDbContext>();
                        var user = context.Principal;
                        var userId = Guid.Parse(user!.FindFirst(JwtRegisteredClaimNames.Sub)?.Value!);
                        var email = user.FindFirst(JwtRegisteredClaimNames.Email)?.Value;
                        var guest = await dbContext.GuestRegistrations.FirstOrDefaultAsync(x =>
                            x.Email == email! && x.KeycloakUserId == userId.ToString() && x.IsActive && !x.IsDeleted);
                        if (guest != null)
                        {
                            if (!guest.IsConverted)
                            {
                                guest.MarkAsConverted(userId.ToString());
                                dbContext.GuestRegistrations.Update(guest);
                                await dbContext.SaveChangesAsync(default);
                                await context.HttpContext.RequestServices.GetRequiredService<IMediator>().Publish(new GuestConvertedToUserEvent(guest));
                            }

                            return;
                        }

                        var guestUser = new GuestRegistration(email, "")
                        {
                            Firstname = user.FindFirstValue(JwtRegisteredClaimNames.GivenName),
                            Lastname = user.FindFirstValue(JwtRegisteredClaimNames.FamilyName),
                        };
                        if (user!.FindFirstValue(JwtRegisteredClaimNames.EmailVerified)!.ToLower() == "true")
                        {
                            guestUser.MarkEmailAsVerified();
                        }

                        guestUser.MarkAsConverted(userId.ToString());


                        dbContext.GuestRegistrations.Add(guestUser);
                        await dbContext.SaveChangesAsync(default);

                        await context.HttpContext.RequestServices.GetRequiredService<IMediator>().Publish(new GuestConvertedToUserEvent(guestUser));
                        //emailverificationState
                        var emailState = new EmailVerificationState(guestUser);
                        emailState.Complete();

                        await dbContext.EmailVerificationStates.AddAsync(emailState);

                        await dbContext.SaveChangesAsync(default);
                    },
                    // OnValidatePrincipal = async context =>
                    // {
                    //     try
                    //     {
                    //         if (!(context.Principal?.Identity?.IsAuthenticated ?? false))
                    //         {
                    //             return;
                    //         }
                    //
                    //         // Cookie'nin süresi dolmak üzereyse yenile
                    //         if (!context.Properties.Items.ContainsKey(".Token.expired") &&
                    //             context.Properties.ExpiresUtc.HasValue &&
                    //             context.Properties.ExpiresUtc.Value < DateTime.UtcNow.AddSeconds(60))
                    //         {
                    //             var tokens = context.Properties.GetTokens().ToList();
                    //             var refreshToken = tokens.FirstOrDefault(t => t.Name == "refresh_token")?.Value;
                    //
                    //             if (!string.IsNullOrEmpty(refreshToken))
                    //             {
                    //                 // Token yenileme işlemi
                    //                 // Identity Provider'dan yeni token al
                    //
                    //                 var keycloakService = context.HttpContext.RequestServices
                    //                     .GetRequiredService<IKeycloakService>();
                    //                 var newTokens = await keycloakService.RefreshTokenAsync(refreshToken);
                    //                 tokens.RemoveAll(x => x.Name is "access_token" or "refresh_token" or "id_token");
                    //                 tokens.Clear();
                    //                 tokens.Add(new AuthenticationToken()
                    //                 {
                    //                     Name = "access_token", Value = newTokens.AccessToken
                    //                 });
                    //                 tokens.Add(new AuthenticationToken()
                    //                 {
                    //                     Name = "refresh_token", Value = newTokens.RefreshToken
                    //                 });
                    //                 tokens.Add(new AuthenticationToken()
                    //                 {
                    //                     Name = "id_token", Value = newTokens.IdToken
                    //                 });
                    //                 context.Properties.StoreTokens(tokens);
                    //                 await context.HttpContext.SignInAsync(context.Principal, context.Properties);
                    //             }
                    //         }
                    //     }
                    //     catch (Exception )
                    //     {
                    //         return;
                    //     }
                    // }
                };
            })
            .AddOpenIdConnect(options =>
            {
                var authConfiguration = builder.Services.BuildServiceProvider()
                    .GetRequiredService<IOptions<AuthConfiguration>>().Value;
                
                options.MetadataAddress = $"{authConfiguration.IdentityProviderUrl}/.well-known/openid-configuration";
                // Sorun: IdentityProviderUrl zaten realm'i içeriyor, bu nedenle Authority doğrudan host olmalı
                options.Authority = authConfiguration.IdentityProviderUrl;
                options.ClientId = authConfiguration.ClientId;
                options.ClientSecret = authConfiguration.ClientSecret;

                options.ResponseType = OpenIdConnectResponseType.Code;

                options.SaveTokens = true;
                options.GetClaimsFromUserInfoEndpoint = true;
                options.RequireHttpsMetadata = !localDemo;
                options.BackchannelHttpHandler = IdentityTransport.Create(builder.Configuration);
                if (localDemo)
                {
                    options.ResponseMode = "query";
                    options.CorrelationCookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
                    options.CorrelationCookie.SameSite = SameSiteMode.Lax;
                    options.NonceCookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
                    options.NonceCookie.SameSite = SameSiteMode.Lax;
                }
                options.UseTokenLifetime = true;

                // options.RefreshInterval = TimeSpan.FromSeconds(30);
                // options.AutomaticRefreshInterval = TimeSpan.FromSeconds(30);

                // Keycloak 25.0.6 Security Features
                options.SignedOutCallbackPath = "/remote-auth/signout-callback-oidc";
                options.RemoteSignOutPath = "/remote-auth/signout-oidc";
                options.CallbackPath = "/remote-auth/signin-oidc";

                // Claims Handling
                options.MapInboundClaims = false;
                options.GetClaimsFromUserInfoEndpoint = true;

                // Security Headers
                options.ProtocolValidator.RequireNonce = true;
                // ASP.NET Core validates protected state and the correlation cookie itself.
                // Preserve its protocol-validator default; the secondary validator does not receive state.
                // Issuer, audience, signature, expiry, nonce and correlation validation remain enabled.
                options.ProtocolValidator.RequireTimeStampInNonce = true;

                // Scopes
                options.Scope.Clear();
                var scopes = builder.Configuration.GetSection("AuthConfiguration:Scopes").Get<string[]>()
                    ?? ["openid", "profile", "email", "roles"];
                if (!scopes.Contains("openid", StringComparer.Ordinal))
                    throw new InvalidOperationException("Identity scopes must include openid.");
                foreach (var scope in scopes) options.Scope.Add(scope);

                // Token Validation
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(30),
                    RequireSignedTokens = true,
                    RequireExpirationTime = true,
                    ValidAlgorithms = new[] { "ES384", "RS256" },
                    NameClaimType = JwtRegisteredClaimNames.Name,
                    RoleClaimType = "roles",
                    RequireAudience = true,
                    ValidAudience = authConfiguration!.ClientId,
                    ValidIssuer = authConfiguration.IdentityProviderUrl,
                    ValidateIssuerSigningKey = true,
                };

                options.Events = new OpenIdConnectEvents
                {
                    OnTicketReceived = context =>
                    {
                        // Bu event authentication ticket oluşturulduktan sonra tetiklenir
                        if (context.Principal?.Identity?.IsAuthenticated == true)
                        {
                            // await context.HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme,context.Principal);
                            // Authentication tamamlandı, şimdi Callback'e yönlendirebiliriz
                            // var callbackUrl = context.Properties?.RedirectUri;
                            // if (!string.IsNullOrEmpty(callbackUrl))
                            // {
                            //     context.Response.Redirect(callbackUrl);
                            //     context.HandleResponse(); // Middleware'in default davranışını engelle
                            // }
                        }

                        return Task.CompletedTask;
                    },
                    OnRedirectToIdentityProviderForSignOut = async context =>
                    {
                        context.ProtocolMessage.Parameters.TryAdd("id_token_hint", context.Properties.Items["id_token_hint"]);
                        context.Properties.Parameters.TryAdd("id_token_hint", context.Properties.Items["id_token_hint"]);
                        context.ProtocolMessage.IdTokenHint = context.Properties.Items["id_token_hint"];
                        context.ProtocolMessage.IdToken =
                            await context.HttpContext.GetTokenAsync(OpenIdConnectDefaults.AuthenticationScheme,OpenIdConnectResponseType.IdToken);
                    }, 
                    OnTokenValidated = context =>
                    {
                        var identity = (ClaimsIdentity)context.Principal?.Identity!;

                        // Role Claims Processing
                        var realmAccessClaim = context.Principal?.FindFirst("realm_access")?.Value;
                        if (!string.IsNullOrEmpty(realmAccessClaim))
                        {
                            var realmAccess = JsonSerializer.Deserialize<JsonElement>(realmAccessClaim);
                            if (realmAccess.TryGetProperty("roles", out var roles))
                            {
                                foreach (var role in roles.EnumerateArray())
                                {
                                    identity.AddClaim(new Claim(ClaimTypes.Role, role.GetString() ?? string.Empty));
                                }
                            }
                        }
                        
                        if (identity != null)
                        {
                            identity.AddClaim(new Claim("id_token",
                                context.TokenEndpointResponse!.IdToken));
                            
                            // Add Session Related Claims
                            var sessionId = context.SecurityToken.Id ?? Guid.NewGuid().ToString();
                            identity.AddClaim(new Claim(ClaimTypes.Sid, sessionId));

                            // Add Additional Security Claims
                            identity.AddClaim(new Claim("auth_time", DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString()));
                            // identity.AddClaim(new Claim("nonce", context.ProtocolMessage.Nonce));
                        }

                        

                        return Task.CompletedTask;
                    },
                    OnAuthenticationFailed = context =>
                    {
                        context.HandleResponse();
                        context.Response.Redirect(localDemo ? "/?login=failed" : "/auth/error");
                        return Task.CompletedTask;
                    },
                    OnRedirectToIdentityProvider = context =>
                    {
                        if (context.HttpContext.IsAjaxRequest())
                        {
                            context.Response.StatusCode = 401;
                            context.HandleResponse();
                        }
                        else
                        {
                            context.ProtocolMessage.SetParameter("kc_idp_hint",
                                context.Properties.GetString("idp_hint"));
                        }

                        return Task.CompletedTask;
                    }
                };
            }).AddJwtBearer(options =>
            {
                var authConfiguration = builder.Configuration.GetSection("AuthConfiguration").Get<AuthConfiguration>();

                options.Authority = authConfiguration!.IdentityProviderUrl;
                options.BackchannelHttpHandler = IdentityTransport.Create(builder.Configuration);
                options.RequireHttpsMetadata = !localDemo;
                options.SaveToken = true;

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(30),
                    RequireSignedTokens = true,
                    RequireExpirationTime = true,
                    ValidAlgorithms = new[] { "ES384", "RS256" },
                    NameClaimType = JwtRegisteredClaimNames.Name,
                    RoleClaimType = "roles",
                    RequireAudience = true,
                    ValidAudience = authConfiguration!.ClientId,
                    ValidIssuer = authConfiguration.IdentityProviderUrl,
                    ValidateIssuerSigningKey = true,
                };

                options.Events = new JwtBearerEvents
                {
                    OnTokenValidated = context =>
                    {
                        var identity = (ClaimsIdentity)context.Principal?.Identity!;

                        // Role Claims işleme
                        var realmAccessClaim = context.Principal?.FindFirst("realm_access")?.Value;
                        if (!string.IsNullOrEmpty(realmAccessClaim))
                        {
                            var realmAccess = JsonSerializer.Deserialize<JsonElement>(realmAccessClaim);
                            if (realmAccess.TryGetProperty("roles", out var roles))
                            {
                                foreach (var role in roles.EnumerateArray())
                                {
                                    identity.AddClaim(new Claim(ClaimTypes.Role, role.GetString() ?? string.Empty));
                                }
                            }
                        }

                        return Task.CompletedTask;
                    },
                    OnAuthenticationFailed = context =>
                    {
                        if (context.Exception is SecurityTokenExpiredException)
                        {
                            context.Response.Headers.Append("Token-Expired", "true");
                        }

                        return Task.CompletedTask;
                    },
                    OnChallenge = context =>
                    {
                        if (context.Request.Path.StartsWithSegments("/api") &&
                            !context.Request.Path.StartsWithSegments("/api/auth"))
                        {
                            context.HandleResponse();
                            context.Response.StatusCode = 401;
                            context.Response.ContentType = "application/json";
                            var result = JsonSerializer.Serialize(new
                            {
                                error = "Unauthorized", message = "You are not authorized to access this resource."
                            });
                            return context.Response.WriteAsync(result);
                        }

                        return Task.CompletedTask;
                    }
                };
            });

        return builder;
    }

    public static IHostApplicationBuilder RegisterCache(this IHostApplicationBuilder builder)
    {
        builder.Services.AddSingleton<ICacheBase, MemoryCacheBase>();

        return builder;
    }

    public static IHostApplicationBuilder RegisterApplicationServices(this IHostApplicationBuilder builder)
    {
        builder.Services.AddSingleton<IDateTime, DateTimeService>();
        builder.Services.AddSingleton<ISecurityService, SecurityService>();

        if (builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
            builder.Services.AddScoped<IEmailService, LocalDemoEmailService>();
        else builder.Services.AddScoped<IEmailService, EmailService>();

        builder.Services.AddScoped<IIyzicoService, IyzicoService>();

        builder.Services.AddScoped<IKeycloakService, KeycloakService>();

        builder.Services.AddScoped<IPaymentProvider, IyzicoPaymentProvider>();
        builder.Services.AddScoped<IPaymentProviderFactory, PaymentProviderFactory>();

        builder.Services.AddFileStorage(builder.Configuration,builder.Environment.ContentRootPath);

        builder.Services.AddHostedService<RedisBackgroundListenerHostedService>();
        if (builder.Configuration.GetValue<bool>("Provisioning:Enabled"))
            builder.Services.AddHostedService<SaasManager.Infrastructure.BackgorundServices.ProvisioningCompletionService>();

        return builder;
    }
}
