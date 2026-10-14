using Authentication.Keycloak.Services.JwtValidationServices;
using Azure.Security.KeyVault.Secrets;
using Grand.Business.Core.Interfaces.Authentication;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

namespace Authentication.Keycloak.Infrastructure;

public class KeycloakAuthenticationBuilder : IAuthenticationBuilder
{
    public int Priority => 501;

    public void AddAuthentication(AuthenticationBuilder builder, IConfiguration configuration)
    {
        builder.AddKeycloakOpenIdConnect("centralappkeycloak", "localhost",
            authenticationScheme: KeycloakAuthenticationDefaults.AuthenticationScheme, options =>
            {
                var authConfiguration = builder.Services.BuildServiceProvider()
                    .GetRequiredService<IOptions<AuthConfiguration>>().Value;


                options.Authority = authConfiguration.IdentityProviderUrl;
                options.ClientSecret = authConfiguration.ClientSecret;
                options.ClientId = authConfiguration.ClientId;

                options.MetadataAddress = $"{authConfiguration.IdentityProviderUrl}/.well-known/openid-configuration";
                options.SignedOutCallbackPath = "/super-admin/KeycloakLogout";
                //TODO: Productionda burayı değiştir
                options.SignedOutRedirectUri = "/Admin/Home/Logout";

                options.ResponseType = OpenIdConnectResponseType.Code;
                options.AutomaticRefreshInterval = TimeSpan.FromHours(60);

                options.SaveTokens = true;
                options.GetClaimsFromUserInfoEndpoint = true;
                options.RequireHttpsMetadata = true;
                options.UseTokenLifetime = true;

                // Claims Handling
                options.MapInboundClaims = false;
                options.GetClaimsFromUserInfoEndpoint = true;

                // Security Headers
                options.ProtocolValidator.RequireNonce = true;
                options.ProtocolValidator.RequireState = false;
                // options.ProtocolValidator.RequireStateValidation = true;
                options.ProtocolValidator.RequireTimeStampInNonce = true;


                options.Scope.Clear();
                options.Scope.Add("openid");
                options.Scope.Add("profile");
                options.Scope.Add("email");
                options.Scope.Add("offline_access");
                options.Scope.Add("store");
                options.Scope.Add("roles");


                options.Events.OnSignedOutCallbackRedirect += context =>
                {
                    // context.Response.Redirect(context.Options.SignedOutRedirectUri);
                    // context.HandleResponse();

                    return Task.CompletedTask;
                };

                options.Events.OnRedirectToIdentityProviderForSignOut = async context =>
                {
                    // Tüm tarayıcı çerezlerini temizle
                    foreach (var cookie in context.HttpContext.Request.Cookies.Keys)
                    {
                        context.HttpContext.Response.Cookies.Delete(cookie);
                    }

                    // ID Token değerini alıp Keycloak'a birden fazla yöntemle ileterek güvenliği artırın
                    var idToken =
                        await context.HttpContext.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,
                            "id_token");
                    if (!string.IsNullOrEmpty(idToken))
                    {
                        // Protocol Message parametrelerine ekle
                        context.ProtocolMessage.Parameters.Add("id_token_hint", idToken);

                        // Properties parametrelerine ekle
                        if (context.Properties != null)
                        {
                            if (context.Properties.Items.ContainsKey("id_token_hint"))
                            {
                                context.Properties.Items["id_token_hint"] = idToken;
                            }
                            else
                            {
                                context.Properties.Items.Add("id_token_hint", idToken);
                            }

                            context.Properties.Parameters.Add("id_token_hint", idToken);
                        }

                        // Doğrudan ProtocolMessage'a ekle
                        context.ProtocolMessage.IdTokenHint = idToken;
                    }

                    // Client ID'yi ekleyin
                    string clientId = authConfiguration.ClientId;
                    context.ProtocolMessage.ClientId = clientId;

                    // Post logout redirect URI'yi ayarlayın
                    var baseUrl = $"{context.HttpContext.Request.Scheme}://{context.HttpContext.Request.Host}";
                    context.ProtocolMessage.PostLogoutRedirectUri = $"{baseUrl}/super-admin/KeycloakLogout";

                    // Keycloak'a gönderilecek son URL'yi logla
                    var logger =
                        context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();
                    logger?.LogInformation("Logout URL: {logoutUrl}", context.ProtocolMessage.BuildRedirectUrl());

                    // Ekstra güvenlik: Sunucu tarafı oturum verileri temizliği için ek işlemler
                    try
                    {
                        var authenticationService =
                            context.HttpContext.RequestServices.GetService<IGrandAuthenticationService>();
                        if (authenticationService != null)
                        {
                            await authenticationService.SignOut();
                        }

                        // Oturum durumunu tutan tüm çerezleri tek tek sil
                        context.HttpContext.Response.Cookies.Delete(".AspNetCore.Cookies");
                        context.HttpContext.Response.Cookies.Delete(".AspNetCore.Identity.Application");
                        context.HttpContext.Response.Cookies.Delete("KEYCLOAK_IDENTITY");
                        context.HttpContext.Response.Cookies.Delete("KEYCLOAK_SESSION");
                    }
                    catch (Exception ex)
                    {
                        logger?.LogError(ex, "Error during cleanup of authentication state");
                    }

                    // Keycloak'a özel parametreler için cache-control başlıklarını ayarla
                    context.HttpContext.Response.Headers.Append(new KeyValuePair<string, StringValues>("Cache-Control", "no-store, no-cache, max-age=0"));
                    context.HttpContext.Response.Headers.Append(new KeyValuePair<string, StringValues>("Pragma", "no-cache"));
                };

                options.Events.OnTokenValidated = async context =>
                {
                    try
                    {
                        // var token = context.TokenEndpointResponse!.AccessToken;

                        // var principle = await context.HttpContext.RequestServices
                        //     .GetService<KeyCloakJwtValidationService>().ValidateJwt(token);

                        var identity = context.Principal.Identity as ClaimsIdentity;
                        // Özel claim'leri ekle
                        if (identity != null)
                        {
                            identity.AddClaim(new Claim("id_token",
                                context.TokenEndpointResponse!.IdToken));
                        }
                    }
                    catch (Exception e)
                    {
                        context.Fail(e);
                    }
                };

                options.Events.OnRedirectToIdentityProvider = context =>
                {
                    // State parametresini ekleyin
                    if (string.IsNullOrEmpty(context.ProtocolMessage.State))
                    {
                        context.ProtocolMessage.SetParameter("state",Guid.NewGuid().ToString());
                    }

                    context.ProtocolMessage.SetParameter("kc_idp_hint",
                        context.Properties.GetString("idp_hint"));
                    
                    var logger = context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();

                    // Oidc mesaj parametrelerini logla
                    logger?.LogInformation("OIDC Protocol Message parameters before redirect: {params}",
                        string.Join(", ", context.ProtocolMessage.Parameters.Select(p => $"{p.Key}={p.Value}")));

                    // State parametresinin durumunu kontrol et
                    logger?.LogInformation("State parameter is: {state}",
                        string.IsNullOrEmpty(context.ProtocolMessage.State) ? "null/empty" : context.ProtocolMessage.State);

                    return Task.CompletedTask;
                };
                
                
                options.Events.OnAuthorizationCodeReceived = async context =>
                {
                    // Loglama ekleyin
                    var logger = context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();
                    logger?.LogInformation("Authorization code received: {code} - requesting token",
                        context.TokenEndpointRequest.Code.Substring(0, 5) + "...");
                    // İşlemin takibi için çerez belirteci
                    context.HttpContext.Response.Cookies.Append(
                        "auth_code_used",
                        "true",
                        new CookieOptions {
                            HttpOnly = true,
                            Secure = true,
                            SameSite = SameSiteMode.Lax,
                            Expires = DateTimeOffset.Now.AddMinutes(5)
                        });
                };
                
                options.Events.OnTokenResponseReceived = context =>
                {
                    var logger = context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();
                    logger?.LogInformation("Token response received successfully");

                    // Kullanılan yetkilendirme kodunu temizle
                    context.HttpContext.Response.Cookies.Delete("auth_code_used");

                    return Task.CompletedTask;
                };
                
                options.Events.OnMessageReceived = context =>
                {
                    var logger = context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();

                    // Hata durumlarını logla
                    if (!string.IsNullOrEmpty(context.ProtocolMessage.Error))
                    {
                        logger?.LogWarning("OpenID Connect error received: {error}, {description}",
                            context.ProtocolMessage.Error,
                            context.ProtocolMessage.ErrorDescription);

                        // Expired_code hatasını özel olarak ele al
                        if (context.ProtocolMessage.Error == "expired_code")
                        {
                            // Tüm çerezleri temizle
                            foreach (var cookie in context.HttpContext.Request.Cookies.Keys)
                            {
                                context.HttpContext.Response.Cookies.Delete(cookie);
                            }

                            // Kullanıcıyı login sayfasına geri yönlendir
                            context.HttpContext.Response.Redirect("/Admin/Home/Login");
                            context.HandleResponse();
                        }
                    }
                    
                    if (!string.IsNullOrEmpty(context.ProtocolMessage.State))
                    {
                        logger?.LogWarning("State parameter is missing in the received message");

                        // State parametresi gerektiğinde ve mevcut olmadığında, 
                        // doğrulama hatasını atlayabilirsiniz
                        // context.ProtocolValidationContext.State = "bypass_missing_state";
                        // context.ProtocolMessage.
                    }


                    return Task.CompletedTask;
                };
                
                options.Events.OnRemoteFailure = context =>
                {
                    var logger = context.HttpContext.RequestServices.GetService<ILogger<KeycloakAuthenticationBuilder>>();
                    logger?.LogError("Remote authentication failure: {error}", context.Failure?.Message);

                    // Doğrudan login sayfasına yönlendir
                    context.Response.Redirect("/Admin/Home/Login");
                    context.HandleResponse();

                    return Task.CompletedTask;
                };

                options.TokenValidationParameters = new TokenValidationParameters {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(30),
                    RequireSignedTokens = true,
                    RequireExpirationTime = true,
                    ValidAlgorithms = new[] { "ES384" },
                    NameClaimType = JwtRegisteredClaimNames.Name,
                    RoleClaimType = "roles",
                    RequireAudience = true,
                    ValidAudience = authConfiguration.Audience,
                    ValidIssuer = authConfiguration.IdentityProviderUrl,
                    ValidAudiences = [
                        "centraladminapp"
                    ],
                    ValidateIssuerSigningKey = true,
                };
            });
    }
}