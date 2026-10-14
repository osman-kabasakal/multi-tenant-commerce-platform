using CloudFlare.Client.Api.Result;
using CloudFlare.Client.Exceptions;
using Newtonsoft.Json;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Text;

namespace Grand.Installer.Cli.Services.CloudFlare;

public class CustomClodFlareApiConnection: IDisposable
{
    private readonly HttpClient _client;
    private readonly JsonSerializerSettings _serializerSettings;
    private readonly JsonMediaTypeFormatter _formatter;

    public CustomClodFlareApiConnection(string apiKey)
    {
        HttpClient client = new HttpClient(new HttpClientHandler()
        {
            AllowAutoRedirect = true
        }, true)
        {
            BaseAddress = new Uri( "https://api.cloudflare.com/client/v4/", UriKind.Absolute)
        };
        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        client.DefaultRequestHeaders.ExpectContinue = true;
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        
        _client = client;
        
        _serializerSettings = new JsonSerializerSettings()
        {
          NullValueHandling = NullValueHandling.Ignore
        };
        JsonMediaTypeFormatter mediaTypeFormatter = new JsonMediaTypeFormatter();
        mediaTypeFormatter.SerializerSettings = _serializerSettings;
        _formatter = mediaTypeFormatter;
        IsDisposed = false;
    }

    public bool IsDisposed { get; set; }

    public async Task<CloudFlareResult<TResult>?> GetAsync<TResult>(
      string requestUri,
      CancellationToken cancellationToken)
    {
      return await (await this._client.GetAsync(requestUri, cancellationToken).ConfigureAwait(false)).GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
    }

    public async Task<CloudFlareResult<TResult>?> DeleteAsync<TResult>(
      string requestUri,
      CancellationToken cancellationToken)
    {
      return await (await _client.DeleteAsync(requestUri, cancellationToken).ConfigureAwait(false)).GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
    }

    public async Task<CloudFlareResult<TResult>?> DeleteAsync<TResult, TContent>(
      string requestUri,
      TContent content,
      CancellationToken cancellationToken)
    {
      CloudFlareResult<TResult> cloudFlareResult;
      try
      {
        cloudFlareResult = await (await _client.SendAsync(new HttpRequestMessage(HttpMethod.Delete, requestUri)
        {
          Content = (HttpContent) new StringContent(JsonConvert.SerializeObject((object) (TContent) content, this._serializerSettings), Encoding.UTF8, "application/json")
        }, cancellationToken).ConfigureAwait(false)).GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
      }
      catch (Exception ex)
      {
        throw new PersistenceUnavailableException(ex);
      }
      return cloudFlareResult;
    }

    public async Task<CloudFlareResult<TResult>?> PatchAsync<TResult>(
      string requestUri,
      TResult content,
      CancellationToken cancellationToken)
    {
      return await this.PatchAsync<TResult, TResult>(requestUri, content, cancellationToken);
    }

    public async Task<CloudFlareResult<TResult>?> PatchAsync<TResult, TContent>(
      string requestUri,
      TContent content,
      CancellationToken cancellationToken)
    {
      CloudFlareResult<TResult> cloudFlareResult;
      try
      {
        cloudFlareResult = await (await _client.SendAsync(new HttpRequestMessage(new HttpMethod("PATCH"), requestUri)
        {
          Content = (HttpContent) new StringContent(JsonConvert.SerializeObject((object) (TContent) content, this._serializerSettings), Encoding.UTF8, "application/json")
        }, cancellationToken).ConfigureAwait(false)).GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
      }
      catch (Exception ex)
      {
        throw new PersistenceUnavailableException(ex);
      }
      return cloudFlareResult;
    }
    
    public async Task<CloudFlareResult<TResult>?> PostAsync<TResult>(
      string requestUri,
      TResult content,
      CancellationToken cancellationToken)
    {
      return await this.PostAsync<TResult, TResult>(requestUri, content, cancellationToken);
    }

    public async Task<CloudFlareResult<TResult>?> PostAsync<TResult, TContent>(
      string requestUri,
      TContent content,
      CancellationToken cancellationToken)
    {
      HttpResponseMessage response;
      if (content is HttpContent content1)
        response = await _client.PostAsync(requestUri, content1, cancellationToken).ConfigureAwait(false);
      else
        response = await _client.PostAsync<TContent>(requestUri, content, (MediaTypeFormatter) this._formatter, cancellationToken).ConfigureAwait(false);
      return await response.GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
    }

    public async Task<CloudFlareResult<TResult>?> PutAsync<TResult>(
      string requestUri,
      TResult content,
      CancellationToken cancellationToken)
    {
      return await this.PutAsync<TResult, TResult>(requestUri, content, cancellationToken);
    }

    public async Task<CloudFlareResult<TResult>?> PutAsync<TResult, TContent>(
      string requestUri,
      TContent content,
      CancellationToken cancellationToken)
    {
      return await (await _client.PutAsync<TContent>(requestUri, content, (MediaTypeFormatter) this._formatter, cancellationToken).ConfigureAwait(false)).GetCloudFlareResultAsync<TResult>().ConfigureAwait(false);
    }
    
    public void Dispose()
    {
      this.Dispose(true);
      GC.SuppressFinalize((object) this);
    }
    
    protected virtual void Dispose(bool disposing)
    {
      if (this.IsDisposed)
        return;
      if (disposing)
      {
        _client?.CancelPendingRequests();
        _client?.Dispose();
      }
      this.IsDisposed = true;
    }

}