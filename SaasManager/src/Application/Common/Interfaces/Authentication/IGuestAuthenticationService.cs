// using System.Security.Claims;
// using SaasManager.Application.Common.Models.Authantication;
// using SaasManager.Domain.Entities.IdentityManagement;
//
// namespace SaasManager.Application.Common.Interfaces.Authentication;
//
// public interface IGuestAuthenticationService
// {
//     Task<string> GenerateGuestTokenAsync();
//     Task<(GuestValidationResult validationResult,GuestRegistration? guestUser)>  ValidateGuestTokenAsync(string token);
//
//     Task<ClaimsPrincipal> GetGuestPrincipleByTokenAsync(string token);
// }
