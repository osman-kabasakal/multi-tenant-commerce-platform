using Microsoft.AspNetCore.Mvc;

namespace Authentication.Keycloak.Components;
[Area("Admin")]
[ViewComponent(Name = KeycloakAuthenticationDefaults.SignInButtonWidgetName)]
public class KeycloakSignInButtonComponent: ViewComponent
{
    
    public async Task<IViewComponentResult> InvokeAsync(string widgetZone, object additionalData = null)
    {
        // return View($"~/Plugins/{KeycloakAuthenticationDefaults.ProviderSystemName}/Areas/Admin/Views/Shared/Components/KeycloakSignInButton/Default.cshtml");
        return View("Default");
    }
}