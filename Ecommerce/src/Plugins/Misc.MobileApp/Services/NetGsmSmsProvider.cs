using Microsoft.Extensions.DependencyInjection;
using Misc.MobileApp.Domain.Enums;
using Newtonsoft.Json;
using System.Net.Http;

namespace Misc.MobileApp.Services;

public class NetGsmSmsProvider(
    SendCouponCodeNotificationSettings sendCouponCodeNotificationSettings
    ): ISmsProvider
{
    public async Task SendSmsAsync(string phoneNumber, string message)
    {
        var data = new
        {
            msgheader = sendCouponCodeNotificationSettings.MsgHeader,
            messages = new[]
            {
                new { msg = message, no = phoneNumber.TrimStart('+').TrimStart('9').TrimStart('0')},
            },
            encoding = "TR",
            iysfilter = "0",
            partnercode = ""
        };

        string url = "https://api.netgsm.com.tr/sms/rest/v2/send";
        string username =sendCouponCodeNotificationSettings.Username;
        string password = sendCouponCodeNotificationSettings.Password;

        using (HttpClient client = new HttpClient())
        {
            var credentials = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{username}:{password}"));
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", credentials);
            client.DefaultRequestHeaders.Add("Content-Type", "application/json");

            var jsonContent = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");

            try
            {
                HttpResponseMessage response = await client.PostAsync(url, jsonContent);
                string responseString = await response.Content.ReadAsStringAsync();
                Console.WriteLine("Yanıt: " + responseString);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Hata: " + ex.Message);
            }
        }
    }
}