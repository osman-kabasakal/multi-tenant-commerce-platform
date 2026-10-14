using CloudFlare.Client.Api.Result;
using CloudFlare.Client.Exceptions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Security.Authentication;

namespace Grand.Installer.Cli.Services.CloudFlare;

public static class CloudflareExtensions
{
    public static async Task<CloudFlareResult<T>?> GetCloudFlareResultAsync<T>(
      this HttpResponseMessage response)
    {
      try
      {
        string content = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
        switch (response.StatusCode)
        {
          case HttpStatusCode.Unauthorized:
          case HttpStatusCode.Forbidden:
            throw new AuthenticationException(string.Join(Environment.NewLine, JsonConvert.DeserializeObject<CloudFlareResult<object>>(content).Errors.Select<ApiError, string>((Func<ApiError, string>) (x => x.Message))));
          default:
            if (content.IsValidJson())
              return JsonConvert.DeserializeObject<CloudFlareResult<T>>(content);
            return null;
            
        }
      }
      catch (Exception ex)
      {
        if (!(ex is AuthenticationException))
          throw new PersistenceUnavailableException(ex);
        throw;
      }
    }
    
    private static bool IsValidJson(this string content)
    {
      try
      {
        JToken.Parse(content);
      }
      catch
      {
        return false;
      }
      return true;
    }
}