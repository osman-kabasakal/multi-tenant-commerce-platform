using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

public sealed record IosSourceRepairReceipt(Guid RepairId, Guid IdentityId, string TenantId,
    string PreviousSourceHash, string SourceHash, string Reason);

/// <summary>Explicit operator repair of an unbuilt iOS recipe; packages, keys and completed receipts never change.</summary>
public sealed class MobileIdentitySourceRepair(string connectionString) : IAsyncDisposable
{
    private readonly NpgsqlDataSource db = NpgsqlDataSource.Create(connectionString);
    internal static async Task InitializeAsync(NpgsqlConnection connection, NpgsqlTransaction transaction, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.mobile_identity_source_repairs (
                id uuid PRIMARY KEY, identity_id uuid NOT NULL, tenant_id text NOT NULL,
                old_prepared jsonb NOT NULL, new_prepared jsonb NOT NULL,
                reason text NOT NULL CHECK(length(reason) BETWEEN 12 AND 500),
                operator_name text NOT NULL DEFAULT current_user,
                transaction_id bigint NOT NULL DEFAULT txid_current(),
                created_at timestamptz NOT NULL DEFAULT now(),
                FOREIGN KEY(identity_id,tenant_id) REFERENCES platform_provisioning.mobile_identity_versions(id,tenant_id)
            );
            CREATE INDEX IF NOT EXISTS mobile_identity_repairs_identity ON platform_provisioning.mobile_identity_source_repairs(identity_id,created_at);
            CREATE OR REPLACE FUNCTION platform_provisioning.guard_mobile_source_repair_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            DECLARE v platform_provisioning.mobile_identity_versions%ROWTYPE;
            BEGIN
                IF TG_OP <> 'INSERT' THEN RAISE EXCEPTION 'Source repair history is append-only' USING ERRCODE='23514'; END IF;
                SELECT * INTO v FROM platform_provisioning.mobile_identity_versions WHERE id=NEW.identity_id AND tenant_id=NEW.tenant_id FOR UPDATE;
                IF NOT FOUND OR v.legacy OR v.state NOT IN ('WaitingBuilds','Failed') OR v.prepared IS NULL OR v.ios_receipt IS NOT NULL OR
                    v.ios_token IS NOT NULL AND (v.ios_until IS NULL OR v.ios_until > now()-interval '2 minutes') OR
                    v.linux_token IS NOT NULL AND (v.linux_until IS NULL OR v.linux_until > now()) OR
                    NEW.transaction_id<>txid_current() OR NEW.operator_name<>current_user OR
                    NEW.old_prepared IS DISTINCT FROM v.prepared OR
                    (NEW.old_prepared #- '{IosPlan,SourceHash}') IS DISTINCT FROM (NEW.new_prepared #- '{IosPlan,SourceHash}') OR
                    COALESCE(NEW.new_prepared->'IosPlan'->>'SourceHash','') !~ '^[a-f0-9]{64}$' OR
                    NEW.new_prepared->'IosPlan'->>'SourceHash'=NEW.old_prepared->'IosPlan'->>'SourceHash' OR
                    NOT EXISTS(SELECT 1 FROM platform_provisioning.domain_requests d WHERE d.id=v.domain_request_id AND d.tenant_id=v.tenant_id AND d.state='Active' AND d.is_primary) OR
                    EXISTS(SELECT 1 FROM platform_security.secrets s WHERE s.scope='tenant-'||v.tenant_id AND s.name IN (
                        'ios-identity-'||replace(v.id::text,'-','')||'-release-artifact-v1',
                        'ios-identity-'||replace(v.id::text,'-','')||'-release-symbols-v1',
                        'ios-identity-'||replace(v.id::text,'-','')||'-release-distribution-v1')) THEN
                    RAISE EXCEPTION 'Only an idle, unpublished iOS source recipe on the current domain can be repaired' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS guard_mobile_source_repair_v1 ON platform_provisioning.mobile_identity_source_repairs;
            CREATE TRIGGER guard_mobile_source_repair_v1 BEFORE INSERT OR UPDATE OR DELETE ON platform_provisioning.mobile_identity_source_repairs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.guard_mobile_source_repair_v1();
            """, connection, transaction);
        await command.ExecuteNonQueryAsync(ct);
    }

    public async Task<IosSourceRepairReceipt> ApplyAsync(Guid repairId, string tenant, Guid identityId,
        string expectedSourceHash, IosWorkerIdentity target, string reason, CancellationToken ct = default)
    {
        IosReleasePlan.Tenant(tenant); target.Validate();
        if (repairId == Guid.Empty || identityId == Guid.Empty || !IosReleasePlan.Digest(expectedSourceHash) ||
            expectedSourceHash == target.SourceHash || reason.Length is < 12 or > 500 || reason.Any(char.IsControl))
            throw new ArgumentException("Select the exact previous source, new Mac identity and a bounded operator reason.");
        await using var connection = await db.OpenConnectionAsync(ct);
        await using var transaction = await connection.BeginTransactionAsync(ct);
        await using (var limits = new NpgsqlCommand("SET LOCAL lock_timeout='5s'; SET LOCAL statement_timeout='15s'", connection, transaction))
            await limits.ExecuteNonQueryAsync(ct);
        MobileIdentityRequest request; PreparedMobileIdentity prepared;
        await using (var select = new NpgsqlCommand("SELECT request::text,prepared::text FROM platform_provisioning.mobile_identity_versions WHERE id=$1 AND tenant_id=$2 FOR UPDATE", connection, transaction))
        {
            select.Parameters.AddWithValue(identityId); select.Parameters.AddWithValue(tenant);
            await using var reader = await select.ExecuteReaderAsync(ct);
            if (!await reader.ReadAsync(ct) || reader.IsDBNull(1)) throw new ProvisioningConflictException();
            request = JsonSerializer.Deserialize<MobileIdentityRequest>(reader.GetString(0))!;
            prepared = JsonSerializer.Deserialize<PreparedMobileIdentity>(reader.GetString(1))!;
        }
        var receipt = new IosSourceRepairReceipt(repairId, identityId, tenant, expectedSourceHash, target.SourceHash, reason);
        await using (var replay = new NpgsqlCommand("SELECT tenant_id,identity_id,old_prepared::text,new_prepared::text,reason FROM platform_provisioning.mobile_identity_source_repairs WHERE id=$1", connection, transaction))
        {
            replay.Parameters.AddWithValue(repairId); await using var reader = await replay.ExecuteReaderAsync(ct);
            if (await reader.ReadAsync(ct))
            {
                var before = JsonSerializer.Deserialize<PreparedMobileIdentity>(reader.GetString(2))!;
                var after = JsonSerializer.Deserialize<PreparedMobileIdentity>(reader.GetString(3))!;
                if (reader.GetString(0) != tenant || reader.GetGuid(1) != identityId || reader.GetString(4) != reason ||
                    before.IosPlan.SourceHash != expectedSourceHash || new IosWorkerIdentity(after.IosPlan.DeploymentId,
                        after.IosPlan.DevelopmentTeam, after.IosPlan.SigningCertificateSha256, after.IosPlan.SourceHash) != target)
                    throw new ProvisioningConflictException();
                return receipt;
            }
        }
        prepared.Validate(request);
        if (prepared.IosPlan.SourceHash != expectedSourceHash || prepared.IosPlan.DeploymentId != target.DeploymentId ||
            prepared.IosPlan.DevelopmentTeam != target.DevelopmentTeam || prepared.IosPlan.SigningCertificateSha256 != target.SigningCertificateSha256)
            throw new ProvisioningConflictException();
        var next = prepared with { IosPlan = prepared.IosPlan with { SourceHash = target.SourceHash } }; next.Validate(request);
        var oldJson = JsonSerializer.Serialize(prepared); var newJson = JsonSerializer.Serialize(next);
        await using (var audit = new NpgsqlCommand("INSERT INTO platform_provisioning.mobile_identity_source_repairs(id,identity_id,tenant_id,old_prepared,new_prepared,reason) VALUES($1,$2,$3,$4::jsonb,$5::jsonb,$6)", connection, transaction))
        {
            foreach (var value in new object[] {repairId, identityId, tenant, oldJson, newJson, reason}) audit.Parameters.Add(new NpgsqlParameter {Value=value});
            await audit.ExecuteNonQueryAsync(ct);
        }
        await using (var update = new NpgsqlCommand("""
            UPDATE platform_provisioning.mobile_identity_versions SET prepared=$3::jsonb,state='WaitingBuilds',
                ios_token=NULL,ios_until=NULL,ios_attempts=0,error_code=NULL,available_at=now(),updated_at=now()
            WHERE id=$1 AND tenant_id=$2
            """, connection, transaction))
        {
            update.Parameters.AddWithValue(identityId); update.Parameters.AddWithValue(tenant); update.Parameters.AddWithValue(newJson);
            if (await update.ExecuteNonQueryAsync(ct)!=1) throw new ProvisioningConflictException();
        }
        await transaction.CommitAsync(ct); return receipt;
    }
    public ValueTask DisposeAsync() => db.DisposeAsync();
}
