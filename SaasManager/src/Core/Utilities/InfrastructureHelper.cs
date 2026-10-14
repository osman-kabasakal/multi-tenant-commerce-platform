using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Core.Utilities;

public static class InfrastructureHelper
{
    public static readonly Dictionary<char, char> InvalidCharToValidChar = new Dictionary<char, char>()
    {
        { ' ','a' },
        { '.','b' },
        { ',', 'c' },
        { ';', 'd' },
        { ':', 'e' },
        { '?' , 'f' },
        { '!', 'g' },
        { '@', 'h' },
        { '#', 'i' },
        { '$','o' },
        { '&','u' },
        { '=','v' },
        { '\'','y' },
        { '"','z' },
        { '/','x' },
        { '\\','j' },
        { '{','k' },
        { '}','l' },
        { '[','m' },
        { ']','n' },
        { '(','p' },
        { ')','q' },
        { '<' , 'r' },
        { '>', 's' },
        { '|','t' },
        { '%','w' },
        { '-', 'a' },
        { '+', 'b' }
    };
    
    public static readonly Dictionary<short, char> NumberToChar = new()
    {
        {0, 'a'},
        {1, 'b'},
        {2, 'c'},
        {3, 'd'},
        {4, 'e'},
        {5, 'f'},
        {6, 'g'},
        {7, 'h'},
        {8, 'i'},
        {9, 'j'}
    };
    public static T StartupConfig<T>(this IServiceCollection services, IConfiguration configuration)
        where T : class, new()
    {
        ArgumentNullException.ThrowIfNull(services);
        ArgumentNullException.ThrowIfNull(configuration);

        var config = new T();
        configuration.Bind(config);
        services.AddSingleton(config);
        return config;
    }
    
    public static DateTime ToIstanbulDateTime(this DateTime dateTime)
    {
        var timeZones = TimeZoneInfo.GetSystemTimeZones();
        var istanbulTimeZone = timeZones.FirstOrDefault(x => x.Id.Contains("Turkey") || x.Id.Contains("Istanbul"));
        var localTime = TimeZoneInfo.ConvertTime(new DateTime(dateTime.Ticks, DateTimeKind.Local),
            TimeZoneInfo.Local,
            istanbulTimeZone!);
        return localTime;
    }

    public static string ToDisplayString(this Enum value)
    {
        var displayProperty = value.GetType().GetField(value.ToString())?.GetCustomAttributes(typeof(DisplayAttribute), false).FirstOrDefault() as DisplayAttribute;
        
        return displayProperty?.Name ?? value.ToString();
    }

    public static string ToFlutterFlavorName(this string value)
    {
        if (string.IsNullOrEmpty(value))
            return string.Empty;
        
        var words= string.Join("",value.Select(c=>InvalidCharToValidChar.TryGetValue(c, out char value1)? char.ToUpper(value1) : char.IsDigit(c)? NumberToChar[short.Parse(c.ToString())]:c));

        return string.Concat([char.ToUpper(words[0]),words[1..]]);
    }
    
    public static byte[] ToByteArray(this Stream value)
    {
        using var memoryStream = new MemoryStream();
        value.CopyTo(memoryStream);
        return memoryStream.ToArray();
    }
}
