using System.Reflection;
using SaasManager.Application.Common.Exceptions;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;

namespace SaasManager.Application.Common.Behaviours;

public class AuthorizationBehaviour<TRequest, TResponse>(IWorkContext workContext)
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : notnull
{
    private readonly IWorkContext _workContext = workContext;

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        var authorizeAttributes = request.GetType().GetCustomAttributes<AuthorizeAttribute>();

        if (authorizeAttributes.Any())
        {
            // Must be authenticated user
            if (_workContext.KeycloakId == null || !(_workContext.GuestRegistration?.IsConverted??false))
            {
                throw new UnauthorizedAccessException();
            }

            // Role-based authorization
            // var authorizeAttributesWithRoles = authorizeAttributes.Where(a => !string.IsNullOrWhiteSpace(a.Roles));

            // if (authorizeAttributesWithRoles.Any())
            // {
            //     var authorized = false;
            //
            //     foreach (var roles in authorizeAttributesWithRoles.Select(a => a.Roles.Split(',')))
            //     {
            //         foreach (var role in roles)
            //         {
            //             var isInRole = await _workContext.Claims[JwtRegistered].IsInRoleAsync(_user.Id, role.Trim());
            //             if (isInRole)
            //             {
            //                 authorized = true;
            //                 break;
            //             }
            //         }
            //     }
            //
            //     // Must be a member of at least one role in roles
            //     if (!authorized)
            //     {
            //         throw new ForbiddenAccessException();
            //     }
            // }
            //
            // // Policy-based authorization
            // var authorizeAttributesWithPolicies = authorizeAttributes.Where(a => !string.IsNullOrWhiteSpace(a.Policy));
            // if (authorizeAttributesWithPolicies.Any())
            // {
            //     foreach (var policy in authorizeAttributesWithPolicies.Select(a => a.Policy))
            //     {
            //         var authorized = await _identityService.AuthorizeAsync(_user.Id, policy);
            //
            //         if (!authorized)
            //         {
            //             throw new ForbiddenAccessException();
            //         }
            //     }
            // }
        }

        // User is authorized / authorization not required
        return await next();
    }
}
