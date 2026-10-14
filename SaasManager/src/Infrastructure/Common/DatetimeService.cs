using System.Globalization;
using SaasManager.Application.Common.Interfaces.Security;

namespace SaasManager.Infrastructure.Common;

public class DateTimeService : IDateTime
{
    private static readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

    public DateTime Now => DateTime.UtcNow;

    public DateTime Today => DateTime.UtcNow.Date;

    public long UnixTimestamp => (long)(DateTime.UtcNow - UnixEpoch).TotalSeconds;

    public string FormatISO8601(DateTime dateTime)
    {
        return dateTime.ToUniversalTime().ToString("O");
    }

    public DateTime? ParseISO8601(string dateTimeStr)
    {
        if (string.IsNullOrEmpty(dateTimeStr))
            return null;

        return DateTime.TryParse(dateTimeStr, null, DateTimeStyles.RoundtripKind, out var result)
            ? result.ToUniversalTime()
            : null;
    }
}
