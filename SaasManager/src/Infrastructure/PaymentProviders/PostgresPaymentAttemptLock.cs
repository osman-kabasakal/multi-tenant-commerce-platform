using System.Buffers.Binary;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Configuration;
using Npgsql;
using SaasManager.Application.Common.Interfaces.PaymentProviders;

namespace SaasManager.Infrastructure.PaymentProviders;

/// <summary>A dedicated PostgreSQL session; no transaction spans a merchant HTTP call.</summary>
public sealed class PostgresPaymentAttemptLock(IConfiguration configuration) : IPaymentAttemptLock
{
    public async Task<IPaymentAttemptLease?> TryAcquireAsync(Guid businessId, CancellationToken ct = default)
    {
        if (businessId == Guid.Empty || !configuration.GetValue<bool>("Payments:ExclusiveSessionConfirmed"))
            throw new InvalidOperationException("Payment locking requires the shared secret database and confirmed direct/session PostgreSQL connectivity.");
        var settings = new NpgsqlConnectionStringBuilder(configuration["PlatformSecurity:ConnectionString"] ?? throw new InvalidOperationException("Configure the shared secret database.")) {
            ApplicationName = "commerce-payment-lock-v1", Multiplexing = false, NoResetOnClose = false,
            Pooling = true, MaxPoolSize = 16
        };
        var connection = new NpgsqlConnection(settings.ConnectionString);
        try
        {
            await connection.OpenAsync(ct);
            var key = BinaryPrimitives.ReadInt64BigEndian(SHA256.HashData(Encoding.UTF8.GetBytes("saas-subscription/v1/" + businessId.ToString("N"))));
            await using var command = new NpgsqlCommand("SELECT pg_backend_pid(), pg_try_advisory_lock($1)", connection);
            command.Parameters.AddWithValue(key);
            await using var result = await command.ExecuteReaderAsync(ct);
            if (!await result.ReadAsync(ct) || !result.GetBoolean(1)) { await result.DisposeAsync(); await connection.DisposeAsync(); return null; }
            return new Lease(connection, key, result.GetInt32(0));
        }
        catch { await connection.DisposeAsync(); throw; }
    }

    private sealed class Lease(NpgsqlConnection connection, long key, int backend) : IPaymentAttemptLease
    {
        private bool disposed;
        public async Task EnsureHeldAsync(CancellationToken ct = default)
        {
            ObjectDisposedException.ThrowIf(disposed, this);
            // A reconnect or transaction-pool backend change invalidates this session's exclusivity.
            await using var command = new NpgsqlCommand("SELECT pg_backend_pid()", connection);
            if (await command.ExecuteScalarAsync(ct) is not int pid || pid != backend)
                throw new InvalidOperationException("The exclusive payment session was lost.");
        }
        public async ValueTask DisposeAsync()
        {
            if (disposed) return;
            disposed = true;
            try
            {
                if (connection.State == System.Data.ConnectionState.Open)
                {
                    await using var command = new NpgsqlCommand("SELECT pg_advisory_unlock($1)", connection) { CommandTimeout = 5 };
                    command.Parameters.AddWithValue(key);
                    await command.ExecuteScalarAsync(CancellationToken.None);
                }
            }
            catch (NpgsqlException)
            {
                // A dead session has already lost its lock. Never return an uncertain session to the pool.
                NpgsqlConnection.ClearPool(connection);
            }
            finally { await connection.DisposeAsync(); }
        }
    }
}
