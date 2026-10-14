// using System.IdentityModel.Tokens.Jwt;
// using System.Security.Claims;
// using Core.Models.Configs;
// using Microsoft.EntityFrameworkCore;
// using SaasManager.Application.Common.Interfaces.Authentication;
// using SaasManager.Application.Common.Interfaces.Data;
// using SaasManager.Application.Common.Interfaces.Security;
// using SaasManager.Application.Common.Models.Authantication;
// using SaasManager.Domain.Entities.IdentityManagement;
// using JwtRegisteredClaimNames = Microsoft.IdentityModel.JsonWebTokens.JwtRegisteredClaimNames;
//
// namespace SaasManager.Infrastructure.Authentication;
//
// public class GuestAuthenticationService : IGuestAuthenticationService
// {
//     private readonly IApplicationDbContext _context;
//     private readonly ISecurityService _securityService;
//     private readonly GuestAuthConfiguration _guestAuthConfiguration;
//
//     public GuestAuthenticationService(
//         IApplicationDbContext context,
//         ISecurityService securityService,
//         GuestAuthConfiguration guestAuthConfiguration)
//     {
//         _context = context;
//         _securityService = securityService;
//         _guestAuthConfiguration = guestAuthConfiguration;
//     }
//
//     public async Task<string> GenerateGuestTokenAsync()
//     {
//         var guest = new GuestRegistration("","");
//         _context.GuestRegistrations.Add(guest);
//         
//         string token = _securityService.GenerateGuestToken(_guestAuthConfiguration, guest.Id);
//         
//         await _context.SaveChangesAsync(default);
//
//         return token;
//     }
//
//     public async Task<(GuestValidationResult validationResult,GuestRegistration? guestUser)> ValidateGuestTokenAsync(string token)
//     {
//         var guestPrinciple = _securityService.ValidateGuestToken(_guestAuthConfiguration, token);
//         // Guest ID'yi al
//         var guestIdClaim = guestPrinciple.FindFirst(ClaimTypes.NameIdentifier);
//         if (guestIdClaim == null || !Guid.TryParse(guestIdClaim.Value, out var guestId))
//         {
//             return (GuestValidationResult.Failure("Invalid guest id",""),null);
//         }
//
//         // Guest'i kontrol et
//         var guest = await _context.GuestRegistrations
//             .FirstOrDefaultAsync(g => g.Id == guestId && !g.IsDeleted);
//
//         if (guest == null || guest.GuestToken != token)
//         {
//             return (GuestValidationResult.Failure("Invalid guest id",""),null);
//         }
//
//         return (GuestValidationResult.Success(),guest);
//     }
//
//     public Task<ClaimsPrincipal> GetGuestPrincipleByTokenAsync(string token)
//     {
//         return Task.FromResult(_securityService.ValidateGuestToken(_guestAuthConfiguration,token));
//     }
// }
