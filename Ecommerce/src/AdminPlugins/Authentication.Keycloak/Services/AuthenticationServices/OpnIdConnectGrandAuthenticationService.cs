using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Data;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Mvc;

namespace Authentication.Keycloak.Services.AuthenticationServices;

public class OpnIdConnectGrandAuthenticationService
{
    private readonly IExternalAuthenticationService _externalAuthenticationService;
    private readonly IGroupService _groupService;
    private readonly IWorkContext _workContext;
    private readonly IRepository<ExternalAuthentication> _externalAuthenticationRepository;
    private readonly ICustomerService _customerService;

    public OpnIdConnectGrandAuthenticationService(
        IExternalAuthenticationService externalAuthenticationService,
        IGroupService groupService,
        IWorkContext workContext,
        IRepository<ExternalAuthentication> externalAuthenticationRepository,
        ICustomerService customerService
        )
    {
        _externalAuthenticationService = externalAuthenticationService;
        _groupService = groupService;
        _workContext = workContext;
        _externalAuthenticationRepository = externalAuthenticationRepository;
        _customerService = customerService;
    }

    public virtual async Task<IActionResult> Authenticate(ExternalAuthParam parameters, string refreshToken,string? returnUrl = null)
    {
        ArgumentNullException.ThrowIfNull(parameters);
        var currentLoggedInUser = await _groupService.IsRegistered(_workContext.CurrentCustomer)
            ? _workContext.CurrentCustomer
            : null;
        
        var associatedUser = await _externalAuthenticationService.GetCustomer(parameters);

        if (associatedUser != null)
        {
            await SetExternalAuthenticationUserField(parameters, refreshToken, associatedUser);

            return await _externalAuthenticationService.AuthenticateExistingUser(associatedUser, currentLoggedInUser, returnUrl);
        }
        
        var result= await _externalAuthenticationService.AuthenticateNewUser(currentLoggedInUser, parameters, returnUrl);
        var newCustomer = await _customerService.GetCustomerByEmail(parameters.Email);
        await SetExternalAuthenticationUserField(parameters, refreshToken, newCustomer);
        return new RedirectResult(returnUrl??"/");
    }

    private async Task SetExternalAuthenticationUserField(ExternalAuthParam parameters, string refreshToken,
        Customer associatedUser)
    {
        var externalRecordById= await _externalAuthenticationRepository.GetOneAsync(x => x.CustomerId == associatedUser.Id);
        externalRecordById.OAuthAccessToken = parameters.AccessToken;
        await _externalAuthenticationRepository.UpdateField(externalRecordById.Id, x => x.OAuthAccessToken,
            parameters.AccessToken);
        if (externalRecordById.UserFields.Any(x=>x.Key==KeycloakAuthenticationDefaults.RefreshTokenName && _workContext.CurrentStore.Id==x.StoreId))
        {
            await _externalAuthenticationRepository.UpdateToSet(externalRecordById.Id,
                x => x.UserFields,
                x => x.Key == KeycloakAuthenticationDefaults.RefreshTokenName &&
                     _workContext.CurrentStore.Id == x.StoreId,
                new UserField() {
                    Key = KeycloakAuthenticationDefaults.RefreshTokenName,
                    Value = refreshToken,
                    StoreId = _workContext.CurrentStore.Id
                });
            
        }
        else
        {
            await _externalAuthenticationRepository.AddToSet(externalRecordById.Id,
                x => x.UserFields,
                new UserField() {
                    Key = KeycloakAuthenticationDefaults.RefreshTokenName,
                    Value = refreshToken,
                    StoreId = _workContext.CurrentStore.Id
                });
        }
    }
}