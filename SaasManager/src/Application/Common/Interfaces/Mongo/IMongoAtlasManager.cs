using SaasManager.Application.Common.Models;
using SaasManager.Application.Stores.Commands.RegisterStore;

namespace SaasManager.Application.Common.Interfaces.Mongo;

public interface IMongoAtlasManager
{
    Task<TenantStatusMessage> CreateDatabaseUserByStoreAsync(RegisterStoreCommand storeCommand, CancellationToken cancellationToken = default);
}
