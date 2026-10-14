namespace SaasManager.Domain.Common;

public interface IOptimisticConcurrency
{
    uint RowVersion { get; set; }
}
