#!/usr/bin/env python3
"""Exercise the real non-root Production image against its own fresh PostgreSQL, without host SDKs/cloud accounts."""
import argparse
import base64
import json
import os
from pathlib import Path
import secrets
import subprocess
import tempfile
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', default='commerce-platform:ci')
    args = parser.parse_args()
    identity = uuid.uuid4().hex
    name = 'commerce-image-' + identity[:12]
    network = name + '-network'
    local = ROOT / '.local'; local.mkdir(mode=0o700, exist_ok=True)
    logs = local / 'logs'; logs.mkdir(mode=0o700, exist_ok=True)
    password = secrets.token_hex(32); owner_password = secrets.token_hex(32)
    environment = dict(os.environ, POSTGRES_PASSWORD=password)
    started_network = False; started_database = False
    # Matching the image UID to the deployment operator permits 0600 bind mounts on Linux.
    user = subprocess.check_output(['docker', 'image', 'inspect', '--format', '{{.Config.User}}', args.image], text=True).strip()
    if user != str(os.getuid()) + ':' + str(os.getgid()):
        raise RuntimeError('Build the image with this non-root operator UID/GID before mounting private configuration.')
    with tempfile.TemporaryDirectory(prefix='production-image-', dir=local) as directory, (logs / 'production-image-bootstrap.log').open('w') as log:
        private = Path(directory)
        (private / 'master-key').write_text(base64.b64encode(secrets.token_bytes(32)).decode())
        plan = str(uuid.uuid4())
        connection = lambda database: 'Host=' + name + ';Database=' + database + ';Username=platform_owner;Password=' + owner_password + ';Timeout=10;Command Timeout=30'
        config = {
            'LocalDemo': {'Enabled': False},
            'PlatformSecurity': {'Provider': 'AesGcm', 'InitializeSchema': False,
                                 'ConnectionString': connection('platform_security'),
                                 'AesGcm': {'MasterKeyFile': '/run/platform/master-key'}},
            'ConnectionStrings': {'SaasManagerDb': connection('platform_saas')},
            'Provisioning': {'DeploymentId': name, 'InitializeSchema': False, 'ConnectionString': connection('platform_security')},
            'TenantOnboarding': {'Trial': {'Enabled': True, 'PlanId': plan}},
            'Bootstrap': {'DeploymentId': name, 'AllowSchemaChanges': True,
                          'TrialPlan': {'Id': plan, 'Name': 'Image verification trial', 'Code': 'IMAGE_TRIAL', 'Price': 299,
                                        'TrialDays': 14, 'MaxProducts': 100, 'MaxUsers': 3, 'MaxMonthlyOrders': 1000,
                                        'Features': ['Catalog']}}
        }
        (private / 'bootstrap.json').write_text(json.dumps(config))
        try:
            subprocess.run(['docker', 'network', 'create', '--label', 'commerce.test=production-image', network], stdout=log, stderr=subprocess.STDOUT, check=True)
            started_network = True
            subprocess.run(['docker', 'run', '--detach', '--name', name, '--network', network,
                            '--label', 'commerce.test=production-image', '--env', 'POSTGRES_PASSWORD',
                            'postgres:16-alpine'], env=environment, stdout=log, stderr=subprocess.STDOUT, check=True)
            started_database = True
            deadline = time.monotonic() + 90
            while time.monotonic() < deadline:
                ready = subprocess.run(['docker', 'exec', name, 'pg_isready', '-h', '127.0.0.1', '-U', 'postgres'], stdout=log, stderr=subprocess.STDOUT)
                if ready.returncode == 0: break
                time.sleep(.5)
            else: raise RuntimeError('The isolated PostgreSQL did not become ready.')
            # Only fixed identifiers and freshly generated hexadecimal fixture credentials enter this private stdin.
            sql = "CREATE ROLE platform_owner LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD '" + owner_password + "';\nCREATE DATABASE platform_security OWNER platform_owner;\nCREATE DATABASE platform_saas OWNER platform_owner;\n"
            subprocess.run(['docker', 'exec', '-i', name, 'psql', '-U', 'postgres', '-d', 'postgres', '-v', 'ON_ERROR_STOP=1'],
                           input=sql, text=True, stdout=log, stderr=subprocess.STDOUT, check=True)
            prefix = ['docker', 'run', '--rm', '--network', network, '--read-only', '--cap-drop', 'ALL',
                      '--security-opt', 'no-new-privileges:true', '--tmpfs', '/tmp:rw,nosuid,size=64m',
                      '--tmpfs', '/run/platform-runtime:rw,nosuid,noexec,size=16m,uid=' + str(os.getuid()) + ',gid=' + str(os.getgid()) + ',mode=0700',
                      '--mount', 'type=bind,src=' + str(private.resolve()) + ',dst=/run/platform,readonly', args.image, 'bootstrap']
            for action in ('initialize', 'verify', 'initialize', 'verify'):
                subprocess.run(prefix + [action, '--config', '/run/platform/bootstrap.json'], stdout=log, stderr=subprocess.STDOUT, check=True, timeout=180)
            print('PASS: the real non-root Linux image initializes and replays fresh security/queue/SaaS schemas with a nonsuperuser owner and 0600 private key/config mounts.', flush=True)
            wrong_key = base64.b64encode(secrets.token_bytes(32)).decode()
            (private / 'master-key').write_text(wrong_key)
            refused = subprocess.run(prefix + ['verify', '--config', '/run/platform/bootstrap.json'], stdout=log, stderr=subprocess.STDOUT, timeout=90)
            if refused.returncode != 1:
                raise RuntimeError('The real container accepted a different encryption master key.')
            print('PASS: an incorrect deployment key is rejected by an independent read-only verification container.', flush=True)
        finally:
            if started_database:
                subprocess.run(['docker', 'rm', '--force', '--volumes', name], stdout=log, stderr=subprocess.STDOUT)
            if started_network:
                subprocess.run(['docker', 'network', 'rm', network], stdout=log, stderr=subprocess.STDOUT)
            print('Only this image probe\'s database, network and disposable private key/config files were removed.', flush=True)


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('Production image probe failed (' + type(error).__name__ + '); inspect .local/logs/production-image-bootstrap.log.', flush=True)
        raise SystemExit(1)
