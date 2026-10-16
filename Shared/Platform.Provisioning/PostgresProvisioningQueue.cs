using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Durable onboarding jobs. Every mutation is fenced by an expiring claim token.</summary>
public sealed class PostgresProvisioningQueue : IProvisioningQueue, IAsyncDisposable
{
    private readonly NpgsqlDataSource _db;
    public PostgresProvisioningQueue(string connectionString) => _db = NpgsqlDataSource.Create(connectionString);
    public async Task InitializeAsync(CancellationToken ct = default)
    {
        await using var connection = await _db.OpenConnectionAsync(ct);
        await using var transaction = await connection.BeginTransactionAsync(ct);
        await using var cmd = new NpgsqlCommand("""
            SELECT pg_advisory_xact_lock(734180226);
            CREATE SCHEMA IF NOT EXISTS platform_provisioning;
            CREATE TABLE IF NOT EXISTS platform_provisioning.jobs (
                id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                tenant_id text NOT NULL UNIQUE,
                slug text NOT NULL UNIQUE,
                request jsonb NOT NULL,
                state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Succeeded','Failed')),
                attempts integer NOT NULL DEFAULT 0 CHECK(attempts >= 0),
                steps jsonb NOT NULL DEFAULT '{}',
                claim_token uuid,
                lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(),
                error_code text,
                created_at timestamptz NOT NULL DEFAULT now(),
                updated_at timestamptz NOT NULL DEFAULT now()
            );
            CREATE INDEX IF NOT EXISTS jobs_available ON platform_provisioning.jobs(available_at,id)
                WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.enforce_job_requirements_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            DECLARE mobile text;
            BEGIN
                IF NEW.request IS DISTINCT FROM OLD.request THEN
                    RAISE EXCEPTION 'The original provisioning request is immutable' USING ERRCODE='23514';
                END IF;
                IF NEW.state='Succeeded' THEN
                    mobile:=COALESCE(NEW.request->>'MobileReleaseProfile','Disabled');
                    IF mobile NOT IN ('Disabled','AndroidAppDistribution','AndroidIosAppDistribution') THEN
                        RAISE EXCEPTION 'Unsupported required mobile release profile' USING ERRCODE='23514';
                    END IF;
                    IF mobile IN ('AndroidAppDistribution','AndroidIosAppDistribution') AND NOT (
                        COALESCE(NEW.steps->'mobile-android-release'->>'Provider','')='AndroidAppDistribution' AND
                        COALESCE(NEW.steps->'mobile-android-release'->'Resources'->>'androidApplicationId','')=
                            COALESCE(NEW.request->>'AndroidPackageName','com.example.tenant'||NEW.tenant_id) AND
                        COALESCE(NEW.steps->'mobile-android-release'->'Resources'->>'sourceHash','') ~ '^[a-f0-9]{64}$' AND
                        COALESCE(NEW.steps->'mobile-android-release'->'Resources'->>'sha256','') ~ '^[a-f0-9]{64}$' AND
                        COALESCE(NEW.steps->'mobile-android-release'->'Resources'->>'signingCertificateSha256','') ~ '^[a-f0-9]{64}$' AND
                        COALESCE(NEW.steps->'mobile-android-release'->'Resources'->>'release','') ~ '^projects/[1-9][0-9]*/apps/1:[1-9][0-9]*:android:[A-Za-z0-9]+/releases/[A-Za-z0-9_-]+$'
                    ) THEN
                        RAISE EXCEPTION 'The required Android release is not complete' USING ERRCODE='23514';
                    END IF;
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS enforce_job_requirements_v1 ON platform_provisioning.jobs;
            CREATE TRIGGER enforce_job_requirements_v1 BEFORE UPDATE OF state,steps,request ON platform_provisioning.jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.enforce_job_requirements_v1();
            """, connection, transaction);
        await cmd.ExecuteNonQueryAsync(ct);
        await ReadinessDeliverySchema.InitializeAsync(connection,transaction,ct);
        await PostgresIosReleaseQueue.InitializeAsync(connection,transaction,ct);
        await IosReleaseCompletionSchema.InitializeAsync(connection,transaction,ct);
        await transaction.CommitAsync(ct);
    }

    public async Task<ProvisioningJob> EnqueueAsync(TenantProvisioningRequest request, CancellationToken cancellationToken = default)
    {
        request.Validate();
        if(request.MobileReleaseProfile is "AndroidAppDistribution" or "AndroidIosAppDistribution")
        {
            await using var compatibility=_db.CreateCommand("""
                SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_trigger
                    WHERE tgrelid='platform_provisioning.jobs'::regclass AND tgname='enforce_job_requirements_v1'
                    AND NOT tgisinternal AND tgenabled IN ('O','A'))
                """);
            if(await compatibility.ExecuteScalarAsync(cancellationToken) is not true)
                throw new InvalidOperationException("Initialize the mobile-aware queue schema with its owner before enabling signed enrollment.");
        }
        if (request.MobileReleaseProfile == "AndroidIosAppDistribution")
        {
            await using var protocol = _db.CreateCommand("""
                SELECT pg_catalog.to_regclass('platform_provisioning.ios_release_jobs') IS NOT NULL AND EXISTS(
                    SELECT 1 FROM pg_catalog.pg_trigger WHERE tgrelid='platform_provisioning.jobs'::regclass
                    AND tgname='enforce_ios_release_v1' AND NOT tgisinternal AND tgenabled IN ('O','A'))
                """);
            if (await protocol.ExecuteScalarAsync(cancellationToken) is not true)
                throw new InvalidOperationException("Apply the current iOS completion protocol with the schema owner before combined enrollment.");
        }
        await using var cmd = _db.CreateCommand("""
            INSERT INTO platform_provisioning.jobs(tenant_id,slug,request)
            VALUES($1,$2,$3::jsonb) ON CONFLICT DO NOTHING
            """);
        cmd.Parameters.AddWithValue(request.TenantId);
        cmd.Parameters.AddWithValue(request.Slug);
        cmd.Parameters.AddWithValue(JsonSerializer.Serialize(request));
        await cmd.ExecuteNonQueryAsync(cancellationToken);
        var job = await GetAsync(request.TenantId, cancellationToken);
        // Legacy jobs omitted the disabled mobile policy. Equivalent disabled replays preserve the old request unchanged.
        if (job == null || (job.Request with { MobileReleaseProfile = null }) != (request with { MobileReleaseProfile = null }) ||
            (job.Request.MobileReleaseProfile ?? "Disabled") != (request.MobileReleaseProfile ?? "Disabled"))
            throw new ProvisioningConflictException();
        return job;
    }

    public async Task<ProvisioningJob?> GetAsync(string tenantId, CancellationToken cancellationToken = default)
    {
        await using var cmd = _db.CreateCommand("""
            SELECT request::text,state,attempts,steps::text,error_code,created_at,updated_at
            FROM platform_provisioning.jobs WHERE tenant_id=$1
            """);
        cmd.Parameters.AddWithValue(tenantId);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? ReadJob(reader) : null;
    }

    public async Task<ProvisioningLease?> ClaimAsync(TimeSpan lease, CancellationToken ct = default)
    {
        if (lease < TimeSpan.FromSeconds(3)) throw new ArgumentOutOfRangeException(nameof(lease));
        var token = Guid.NewGuid();
        await using var cmd = _db.CreateCommand("""
            UPDATE platform_provisioning.jobs SET state='Running',attempts=attempts+1,
                claim_token=$1,lease_until=now()+$2,updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.jobs
                WHERE (state='Pending' AND available_at<=now()) OR (state='Running' AND lease_until<now())
                ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING request::text,state,attempts,steps::text,error_code,created_at,updated_at
            """);
        cmd.Parameters.AddWithValue(token);
        cmd.Parameters.AddWithValue(lease);
        await using var reader = await cmd.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct) ? new(ReadJob(reader), token) : null;
    }

    public async Task RenewAsync(ProvisioningLease lease, TimeSpan duration, CancellationToken ct = default)
    {
        await using var cmd = OwnedCommand("lease_until=now()+$3,updated_at=now()", lease);
        cmd.Parameters.AddWithValue(duration);
        await RequireOwnedAsync(cmd, ct);
    }

    public async Task CheckpointAsync(ProvisioningLease lease, string step, ProvisioningStepResult result, CancellationToken ct = default)
    {
        await using var cmd = OwnedCommand("steps=steps || jsonb_build_object($3::text,$4::jsonb),error_code=NULL,updated_at=now()", lease);
        cmd.Parameters.AddWithValue(step);
        cmd.Parameters.AddWithValue(JsonSerializer.Serialize(result));
        await RequireOwnedAsync(cmd, ct);
    }

    public async Task CompleteAsync(ProvisioningLease lease, CancellationToken ct = default)
    {
        await using var cmd = OwnedCommand("state='Succeeded',claim_token=NULL,lease_until=NULL,error_code=NULL,updated_at=now()", lease);
        await RequireOwnedAsync(cmd, ct);
    }

    public async Task FailAsync(ProvisioningLease lease, string errorCode, int maxAttempts, CancellationToken ct = default)
    {
        await using var cmd = OwnedCommand("""
            state=CASE WHEN attempts >= $3 THEN 'Failed' ELSE 'Pending' END,
            available_at=now()+$4,error_code=$5,claim_token=NULL,lease_until=NULL,updated_at=now()
            """, lease);
        cmd.Parameters.AddWithValue(maxAttempts);
        cmd.Parameters.AddWithValue(TimeSpan.FromSeconds(Math.Min(300, Math.Pow(2, Math.Min(lease.Job.Attempts, 8)))));
        cmd.Parameters.AddWithValue(errorCode);
        await RequireOwnedAsync(cmd, ct);
    }

    public async Task DeferAsync(ProvisioningLease lease, ProvisioningDeferredException waiting, CancellationToken ct = default)
    {
        await using var cmd = OwnedCommand("""
            state='Pending',attempts=GREATEST(attempts-1,0),available_at=now()+$3,error_code=$4,
            claim_token=NULL,lease_until=NULL,updated_at=now()
            """, lease);
        cmd.Parameters.AddWithValue(waiting.RetryAfter); cmd.Parameters.AddWithValue(waiting.ReasonCode);
        await RequireOwnedAsync(cmd, ct);
    }

    public async Task<bool> RetryAsync(string tenantId, CancellationToken cancellationToken = default)
    {
        await using var connection = await _db.OpenConnectionAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);
        await using var cmd = new NpgsqlCommand("""
            UPDATE platform_provisioning.jobs SET state='Pending',attempts=0,error_code=NULL,available_at=now(),updated_at=now()
            WHERE tenant_id=$1 AND state='Failed' RETURNING request->>'MobileReleaseProfile'
            """, connection, transaction);
        cmd.Parameters.AddWithValue(tenantId);
        var profile = await cmd.ExecuteScalarAsync(cancellationToken);
        if (profile == null) return false;
        if (profile is string mobile && mobile == "AndroidIosAppDistribution")
        {
            await using var child = new NpgsqlCommand("""
                UPDATE platform_provisioning.ios_release_jobs SET state='Pending',attempts=0,error_code=NULL,available_at=now(),updated_at=now()
                WHERE tenant_id=$1 AND state='Failed'
                """, connection, transaction);
            child.Parameters.AddWithValue(tenantId); await child.ExecuteNonQueryAsync(cancellationToken);
        }
        await transaction.CommitAsync(cancellationToken); return true;
    }

    private NpgsqlCommand OwnedCommand(string update, ProvisioningLease lease)
    {
        // update is an internal SQL literal. Tenant data is always parameterized.
        var cmd = _db.CreateCommand($"UPDATE platform_provisioning.jobs SET {update} WHERE tenant_id=$1 AND claim_token=$2 AND state='Running' AND lease_until>now()");
        cmd.Parameters.AddWithValue(lease.Job.Request.TenantId);
        cmd.Parameters.AddWithValue(lease.Token);
        return cmd;
    }
    private static async Task RequireOwnedAsync(NpgsqlCommand cmd, CancellationToken ct)
    {
        if (await cmd.ExecuteNonQueryAsync(ct) != 1) throw new ProvisioningLeaseLostException();
    }
    private static ProvisioningJob ReadJob(NpgsqlDataReader reader) => new(
        JsonSerializer.Deserialize<TenantProvisioningRequest>(reader.GetString(0))!, reader.GetString(1), reader.GetInt32(2),
        JsonSerializer.Deserialize<Dictionary<string, ProvisioningStepResult>>(reader.GetString(3))!,
        reader.IsDBNull(4) ? null : reader.GetString(4), reader.GetFieldValue<DateTimeOffset>(5), reader.GetFieldValue<DateTimeOffset>(6));
    public ValueTask DisposeAsync() => _db.DisposeAsync();
}
