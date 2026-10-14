using System;

namespace Grand.Domain.Cache;

public class CacheKeyCorrelation: BaseEntity
{
    public string CustomerId { get; set; }
    public string CorrelationId { get; set; }
    public List<string> CacheKeys { get; set; } = new List<string>();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsStale { get; set; } = false;
    public List<string> StaleReasons { get; set; } = new List<string>();
}
