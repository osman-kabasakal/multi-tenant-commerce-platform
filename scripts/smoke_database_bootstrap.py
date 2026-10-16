#!/usr/bin/env python3
"""Verify fresh owner-only database bootstrap, replay and read-only SaaS startup against isolated PostgreSQL."""
import json
import os
from pathlib import Path
import secrets
import signal
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]


def run_owned(command, log, environment):
    process = subprocess.Popen(command, cwd=ROOT / 'SaasManager', env=environment,
                               stdout=log, stderr=subprocess.STDOUT, start_new_session=(os.name != 'nt'))
    try:
        code = process.wait(timeout=600)
        if code: raise subprocess.CalledProcessError(code, command)
    except BaseException:
        if process.poll() is None:
            if os.name == 'nt': process.kill()
            else: os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise


def main():
    os.umask(0o077)
    identity = uuid.uuid4().hex
    fixture = ROOT / '.local' / ('database-bootstrap-' + identity[:10])
    fixture.mkdir(parents=True, mode=0o700)
    private = fixture / 'fixture.json'
    log_path = fixture / 'fixture.log'
    container = 'commerce-bootstrap-' + identity[:10]
    password = secrets.token_urlsafe(24)
    connection = lambda database: f'Host=127.0.0.1;Port=15442;Database={database};Username=commerce_probe;Password={password};Timeout=10;Command Timeout=30'
    plan = str(uuid.uuid4())
    private.write_text(json.dumps({
        'LocalDemo': {'Enabled': False},
        'DatabaseBootstrap': {'Mode': 'External'},
        'PlatformSecurity': {'Provider': 'AesGcm', 'InitializeSchema': False,
                             'ConnectionString': connection('bootstrap_security_' + identity),
                             'AesGcm': {'MasterKeyBase64': __import__('base64').b64encode(secrets.token_bytes(32)).decode()}},
        'ConnectionStrings': {'SaasManagerDb': connection('bootstrap_saas_' + identity)},
        'Provisioning': {'DeploymentId': 'bootstrap-fixture', 'InitializeSchema': False,
                         'ConnectionString': connection('bootstrap_queue_' + identity)},
        'TenantOnboarding': {'Trial': {'Enabled': True, 'PlanId': plan}},
        'Bootstrap': {'DeploymentId': 'bootstrap-fixture', 'AllowSchemaChanges': True,
                      'TrialPlan': {'Id': plan, 'Name': 'Configured production trial', 'Code': 'BOOTSTRAP_TRIAL',
                                    'Price': 299, 'TrialDays': 14, 'MaxProducts': 100, 'MaxUsers': 3,
                                    'MaxMonthlyOrders': 1000, 'Features': ['Catalog', 'Tenant notifications']}},
        'Fixture': {'Id': identity, 'CliPath': str(ROOT / 'tools/Platform.Bootstrap/bin/Release/net9.0/Platform.Bootstrap.dll')}
    }))
    prefixes = ('platformsecurity__', 'provisioning__', 'connectionstrings__', 'bootstrap__', 'tenantonboarding__', 'localdemo__')
    environment = {k: v for k, v in os.environ.items() if not k.lower().startswith(prefixes)}
    environment.update(POSTGRES_PASSWORD=password, DOTNET_ENVIRONMENT='Production')
    print('Private database bootstrap fixture: ' + str(fixture), flush=True)
    try:
        with log_path.open('w') as log:
            for project in ('../tools/Platform.Bootstrap/Platform.Bootstrap.csproj', '../tests/Bootstrap.Integration/Bootstrap.Integration.csproj'):
                run_owned(['dotnet', 'build', project, '-c', 'Release', '--nologo'], log, environment)
            subprocess.run(['docker', 'run', '--rm', '--detach', '--name', container, '--label', 'commerce.test=database-bootstrap',
                            '--publish', '127.0.0.1:15442:5432', '--env', 'POSTGRES_PASSWORD', '--env', 'POSTGRES_USER=commerce_probe',
                            '--env', 'POSTGRES_DB=postgres', 'postgres:16-alpine'],
                           env=environment, stdout=subprocess.DEVNULL, check=True)
            deadline = time.monotonic() + 60
            while time.monotonic() < deadline:
                ready = subprocess.run(['docker', 'exec', container, 'pg_isready', '-h', '127.0.0.1', '-U', 'commerce_probe', '-d', 'postgres'],
                                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                if ready.returncode == 0: break
                time.sleep(.5)
            else: raise RuntimeError('The isolated bootstrap database did not become ready.')
            run_owned(['dotnet', str(ROOT / 'tests/Bootstrap.Integration/bin/Release/net9.0/Bootstrap.Integration.dll'), str(private)], log, environment)
        lines = [line for line in log_path.read_text().splitlines() if line.startswith('PASS:')]
        for line in lines: print(line, flush=True)
        (fixture / 'result.json').write_text(json.dumps({'bootstrapVerified': True, 'checks': len(lines), 'liveCloudResourcesCreated': False}))
        return 0
    except Exception as error:
        print('Database bootstrap fixture failed (' + type(error).__name__ + '). Inspect its private fixture.log.', file=sys.stderr)
        return 1
    finally:
        subprocess.run(['docker', 'rm', '--force', '--volumes', container], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for path in fixture.glob('*.json'):
            if path.name != 'result.json': path.unlink()
        print('Only this fixture container, volume and temporary configuration were removed.', flush=True)


if __name__ == '__main__':
    raise SystemExit(main())
