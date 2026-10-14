using Grand.Business.Core.Interfaces.Cms;

namespace Authentication.Keycloak;

public class SigninButtonWidgetProvider: IWidgetProvider
{
    public string ConfigurationUrl => "";
    public string SystemName => KeycloakAuthenticationDefaults.ProviderSystemName;
    public string FriendlyName => "Keycloak Yetkilendirme";
    public int Priority => 1;
    public IList<string> LimitedToStores => new List<string>();
    public IList<string> LimitedToGroups => new List<string>();
    public Task<IList<string>> GetWidgetZones()
    {
        return Task.FromResult<IList<string>>(new List<string>() {
            "admin_external_authentication"
        });
    }

    public Task<string> GetPublicViewComponentName(string widgetZone)
    {
        return Task.FromResult(KeycloakAuthenticationDefaults.SignInButtonWidgetName);
    }
}