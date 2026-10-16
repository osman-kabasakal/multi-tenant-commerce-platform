using Npgsql;

namespace Platform.Provisioning;

internal static class IosReleaseCompletionSchema
{
    public static async Task InitializeAsync(NpgsqlConnection connection, NpgsqlTransaction transaction, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand("""
            CREATE OR REPLACE FUNCTION platform_provisioning.enforce_ios_release_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            DECLARE ios_plan jsonb; ios_receipt jsonb; ios_state text;
                enqueued jsonb; delivered jsonb; field text; release_prefix text;
            BEGIN
                IF NEW.state<>'Succeeded' OR COALESCE(NEW.request->>'MobileReleaseProfile','Disabled')<>'AndroidIosAppDistribution' THEN
                    RETURN NEW;
                END IF;
                SELECT request,state,receipt INTO ios_plan,ios_state,ios_receipt
                    FROM platform_provisioning.ios_release_jobs WHERE tenant_id=NEW.tenant_id;
                IF ios_state IS DISTINCT FROM 'Succeeded' OR ios_receipt IS NULL THEN
                    RAISE EXCEPTION 'The required iOS release is not complete' USING ERRCODE='23514';
                END IF;
                enqueued:=NEW.steps->'mobile-ios-enqueue'->'Resources';
                delivered:=NEW.steps->'mobile-ios-release'->'Resources';
                IF COALESCE(NEW.steps->'mobile-ios-enqueue'->>'Provider','')<>'IosQueue' OR
                   COALESCE(NEW.steps->'mobile-ios-release'->>'Provider','')<>'IosAppDistribution' OR
                   COALESCE(ios_plan->>'tenantId','')<>NEW.tenant_id OR
                   COALESCE(ios_plan->>'deploymentId','')<>COALESCE(NEW.request->>'DeploymentId','') OR
                   COALESCE(ios_plan->>'iosBundleId','')<>COALESCE(NEW.request->>'IosBundleId','com.example.tenant'||NEW.tenant_id) OR
                   COALESCE(ios_plan->>'developmentTeam','') !~ '^[A-Z0-9]{10}$' OR
                   COALESCE(ios_plan->>'sourceHash','') !~ '^[a-f0-9]{64}$' OR
                   COALESCE(ios_plan->>'signingCertificateSha256','') !~ '^[a-f0-9]{64}$' OR
                   COALESCE(ios_plan->>'firebaseSdkSha256','') !~ '^[a-f0-9]{64}$' OR
                   COALESCE(ios_plan->>'projectNumber','') !~ '^[1-9][0-9]{0,19}$' OR
                   COALESCE(ios_plan->>'iosAppId','') !~ ('^1:'||COALESCE(ios_plan->>'projectNumber','')||':ios:[A-Za-z0-9]+$') OR
                   COALESCE(NEW.steps->'google-firebase'->'Resources'->>'projectId','')<>COALESCE(ios_plan->>'projectId','') OR
                   COALESCE(NEW.steps->'google-firebase'->'Resources'->>'iosAppId','')<>COALESCE(ios_plan->>'iosAppId','') OR
                   COALESCE(NEW.steps->'publication'->'Resources'->>'readiness','')<>'Verified' OR
                   COALESCE(NEW.steps->'publication'->'Resources'->>'storeUrl','')<>COALESCE(ios_plan->>'storeUrl','') OR
                   COALESCE(jsonb_typeof(ios_plan->'buildNumber'),'')<>'number' OR
                   NOT (CASE WHEN COALESCE(ios_plan->>'buildNumber','') ~ '^[1-9][0-9]{0,9}$'
                       THEN (ios_plan->>'buildNumber')::bigint BETWEEN 1 AND 2100000000 ELSE false END) THEN
                    RAISE EXCEPTION 'The iOS plan differs from its required tenant and public checkpoints' USING ERRCODE='23514';
                END IF;
                FOREACH field IN ARRAY ARRAY['iosAppId','iosBundleId','developmentTeam','sourceHash','signingCertificateSha256','firebaseSdkSha256','buildNumber'] LOOP
                    IF COALESCE(enqueued->>field,'')<>COALESCE(ios_plan->>field,'') OR
                       COALESCE(delivered->>field,'')<>COALESCE(ios_plan->>field,'') THEN
                        RAISE EXCEPTION 'The iOS checkpoints differ from the original plan' USING ERRCODE='23514';
                    END IF;
                END LOOP;
                FOREACH field IN ARRAY ARRAY['sourceHash','signingCertificateSha256','firebaseSdkSha256','buildNumber'] LOOP
                    IF COALESCE(ios_receipt->>field,'')<>COALESCE(ios_plan->>field,'') THEN
                        RAISE EXCEPTION 'The iOS receipt differs from its original plan' USING ERRCODE='23514';
                    END IF;
                END LOOP;
                IF COALESCE(ios_receipt->>'ipaSha256','') !~ '^[a-f0-9]{64}$' OR
                   COALESCE(delivered->>'sha256','')<>COALESCE(ios_receipt->>'ipaSha256','') OR
                   ios_receipt->'symbolsUploaded' IS DISTINCT FROM 'true'::jsonb OR
                   COALESCE(delivered->>'symbolsUploaded','')<>'true' OR
                   COALESCE(ios_receipt->>'applicationProfileUuid','') !~ '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$' OR
                   COALESCE(ios_receipt->>'extensionProfileUuid','') !~ '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$' OR
                   lower(ios_receipt->>'applicationProfileUuid')='00000000-0000-0000-0000-000000000000' OR
                   lower(ios_receipt->>'extensionProfileUuid')='00000000-0000-0000-0000-000000000000' OR
                   lower(ios_receipt->>'applicationProfileUuid')=lower(ios_receipt->>'extensionProfileUuid') OR
                   COALESCE(delivered->>'applicationProfileUuid','')<>COALESCE(ios_receipt->>'applicationProfileUuid','') OR
                   COALESCE(delivered->>'extensionProfileUuid','')<>COALESCE(ios_receipt->>'extensionProfileUuid','') THEN
                    RAISE EXCEPTION 'The required iOS native or symbol receipt is incomplete' USING ERRCODE='23514';
                END IF;
                release_prefix:='projects/'||(ios_plan->>'projectNumber')||'/apps/'||(ios_plan->>'iosAppId')||'/releases/';
                IF left(COALESCE(ios_receipt->>'releaseResource',''),length(release_prefix))<>release_prefix OR
                   substring(COALESCE(ios_receipt->>'releaseResource','') FROM length(release_prefix)+1) !~ '^[A-Za-z0-9_-]+$' OR
                   COALESCE(delivered->>'release','')<>COALESCE(ios_receipt->>'releaseResource','') THEN
                    RAISE EXCEPTION 'The iOS distribution receipt belongs to another app' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS enforce_ios_release_v1 ON platform_provisioning.jobs;
            CREATE TRIGGER enforce_ios_release_v1 BEFORE UPDATE OF state,steps,request ON platform_provisioning.jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.enforce_ios_release_v1();
            """, connection, transaction);
        await command.ExecuteNonQueryAsync(ct);
    }
}
