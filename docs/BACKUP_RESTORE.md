# Consistent Linux Compose data snapshots

The generated single-host Linux deployment has a cold data snapshot tool. It stops only that owned Compose project, captures private state and all three database volumes, verifies the archives, then restarts the services that were previously running. It uses the same deployment lock as startup. The original installation ID, credentials and master key are retained.

**Current evidence:** nine filesystem/archive/ownership refusal tests pass locally. The complete cold database restoration gate has been added to clean Linux CI and is pending its own result. The separately verified full registration/restart baseline is recorded in [VALIDATION.md](VALIDATION.md#verified-real-registration-and-linux-restart-2026-10-16). Do not treat archive validation alone as a successful database restoration.

## Snapshot a running installation

Use the original non-root Linux deployment account with Docker access. Choose a new backup directory with enough free disk for the private files plus PostgreSQL, MongoDB and Redis data. The immediate backup parent must be owned by that account and mode 0700. Snapshot creation is a maintenance operation: this installation is unavailable while its data is captured.

```sh
mkdir -p .local/backups
chmod 700 .local/backups
python3 scripts/production_backup.py backup \
  --state .local/production --backup .local/backups/production-snapshot
python3 scripts/production_backup.py verify \
  --backup .local/backups/production-snapshot
```

The snapshot directory contains `snapshot.json`, `state.tar`, `postgres-data.tar`, `mongo-data.tar` and `redis-data.tar`. Files are private 0600 and the directory is 0700. The manifest records installation ownership, source revision, deployment UID/GID, exact runtime image IDs and SHA-256 checksums. Verification rejects corrupt archives, absolute/traversal paths, duplicate entries, links and non-regular data. Checksums detect corruption; they are not an authenticated signature from another party.

Private state includes the shared encryption key, SaaS cookie keys, TLS/private provider inputs, routes, onboarding checkpoints, uploaded files, public tenant manifests and committed mobile artifacts. PostgreSQL includes the encrypted tenant signing identities and queue/security/SaaS/Keycloak data; Redis includes the shared commerce/admin key ring. Logs, temporary mobile work and rebuildable mobile caches are represented as empty directories. The tool refuses bind mounts outside the generated private state. Custom infrastructure, extra external credential dependencies, multi-host writers and external cloud resources need their own coordinated backup; this tool covers the selected generated single-host deployment.

The snapshot contains credentials and is not encrypted by the tool. Retain it in access-controlled encrypted backup storage outside Git. Retain the exact runtime images listed in `snapshot.json` as well, using a private registry or Docker image export. Images and the repository source are not embedded in these data archives. Preserve the original UID/GID and source revision for restoration.

## Restore to an empty destination

Use a fresh Docker destination with the original images loaded and no volumes/network belonging to this project. Check out the exact recorded source revision and run under the recorded deployment UID/GID. The tool verifies these requirements before creating data; it never overwrites an existing private state directory, data volume or project network. Restoring over a live installation requires a separate operator-led recovery/migration plan.

```sh
python3 scripts/production_backup.py verify \
  --backup .local/backups/production-snapshot
python3 scripts/production_backup.py restore \
  --backup .local/backups/production-snapshot --state .local/restored-production
python3 scripts/production.py up --state .local/restored-production --no-build
python3 scripts/production.py verify --state .local/restored-production
```

The example uses the generated default image tag. If the original startup selected a custom `--image`, repeat that same option on startup. Its reference and immutable ID are recorded in the private snapshot. Restore refuses a moved tag or missing image; load the originals before retrying. TLS/provider input paths are rewritten to protected copies in the restored state, while domains, deployment targets, passwords and keys stay the same. Certificates must still be valid. Reapply any deliberate environment/proxy overrides separately. Startup remains an explicit operation after restoration.

Use the ordinary SaaS portal and each tenant storefront/admin to verify the restored installation. A restored session is subject to its normal expiry and identity-provider validity. Cloud resources and external messages are not rolled back by restoring local data; existing resource ownership and idempotent reconciliation rules still apply.

## Disposable full acceptance

On a dedicated clean Linux validation machine with the current committed server image and [browser prerequisites](VALIDATION.md#real-angular-registration-browser-gate-2026-10-16):

```sh
python3 scripts/smoke_production_compose.py \
  --image commerce-platform:local --browser --backup-restore
```

Only this fixture removes its own disposable project/volumes and private state to simulate an empty destination. It then runs the actual restore and ordinary startup commands, verifies original key/private-file bytes, real tenant data, SaaS/admin sessions and the original Firefox success screen. No live cloud account, external email recipient or unrelated Docker data is used. CI selects this gate; its result must pass before cold restoration is recorded as verified.
