#!/usr/bin/env python3
"""Actual PostgreSQL outbox and TCP SMTP acceptance; no external email/cloud service is contacted."""
import base64
from email import policy
from email.parser import BytesParser
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


def run_owned(command, log, environment, directory=ROOT):
    process = subprocess.Popen(command, cwd=directory, env=environment, stdout=log, stderr=subprocess.STDOUT, start_new_session=(os.name != 'nt'))
    try:
        code = process.wait(timeout=300)
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
    fixture = ROOT / '.local' / ('readiness-email-' + identity[:10]); fixture.mkdir(parents=True, mode=0o700)
    private = fixture / 'fixture.json'; log_path = fixture / 'fixture.log'
    container = 'commerce-readiness-email-' + identity[:10]
    password = secrets.token_urlsafe(24)
    private.write_text(json.dumps({
        'LocalDemo': {'Enabled': True},
        'PlatformSecurity': {'Provider': 'AesGcm', 'InitializeSchema': False,
                             'ConnectionString': f'Host=127.0.0.1;Port=15443;Database=readiness_delivery_test_{identity};Username=commerce_probe;Password={password}',
                             'AesGcm': {'MasterKeyBase64': base64.b64encode(secrets.token_bytes(32)).decode()}},
        'Provisioning': {'Enabled': True, 'InitializeSchema': False, 'Profile': 'Local', 'ReadinessEmail': {'Provider': 'Smtp', 'Smtp': {'Host': '127.0.0.1', 'Port': 1025,
            'FromAddress': 'platform@example.test', 'EnableStartTls': False, 'AllowPlaintextLoopback': True,
            'LeaseDuration': '00:00:03', 'PollInterval': '00:00:00.1', 'Timeout': '00:00:30', 'MaxAttempts': 5}}},
        'Fixture': {'Id': identity, 'WorkerDll': str(ROOT / 'TenantManager/bin/Release/net9.0/TenantManager.dll')}
    }))
    environment = dict(os.environ, POSTGRES_PASSWORD=password)
    print('Private readiness SMTP fixture: ' + str(fixture), flush=True)
    try:
        with log_path.open('w') as log:
            run_owned(['dotnet', 'build', 'TenantManager.csproj', '-c', 'Release', '--nologo'], log, environment, ROOT / 'TenantManager')
            run_owned(['dotnet', 'build', 'tests/Readiness.Email.Integration/Readiness.Email.Integration.csproj', '-c', 'Release', '--nologo'], log, environment)
            subprocess.run(['docker', 'run', '--rm', '--detach', '--name', container, '--label', 'commerce.test=readiness-email',
                            '--publish', '127.0.0.1:15443:5432', '--env', 'POSTGRES_PASSWORD', '--env', 'POSTGRES_USER=commerce_probe',
                            '--env', 'POSTGRES_DB=readiness_delivery_test_' + identity, 'postgres:16-alpine'],
                           env=environment, stdout=subprocess.DEVNULL, check=True)
            deadline = time.monotonic() + 60
            while time.monotonic() < deadline:
                ready = subprocess.run(['docker', 'exec', container, 'pg_isready', '-U', 'commerce_probe', '-d', 'readiness_delivery_test_' + identity],
                                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                if ready.returncode == 0: break
                time.sleep(.5)
            else: raise RuntimeError('The isolated readiness database did not become ready.')
            run_owned(['dotnet', str(ROOT / 'tests/Readiness.Email.Integration/bin/Release/net8.0/Readiness.Email.Integration.dll'), str(private)], log, environment)
        expected = {event['tenantId']: event for event in json.loads((fixture / 'expected.json').read_text())}
        actual = {}
        for path in fixture.glob('accepted-*.eml'):
            mail = BytesParser(policy=policy.default).parsebytes(path.read_bytes())
            tenant = str(mail['X-Platform-Tenant']); event = expected[tenant]
            body = mail.get_content()
            assert str(mail['To']) == event['recipient'] and str(mail['Subject']) == 'Mağazanız hazır'
            assert event['storeUrl'] in body and event['adminUrl'] in body
            assert all(other['storeUrl'] not in body for key, other in expected.items() if key != tenant)
            assert str(mail['Message-ID']).startswith('<tenant-ready.')
            assert 'never-log-provider-token' not in body
            actual[tenant] = True
        assert set(actual) == set(expected) and len(actual) == 3
        lines = [line for line in log_path.read_text().splitlines() if line.startswith('PASS:')]
        for line in lines: print(line, flush=True)
        print('PASS: Real SMTP MIME messages have the correct recipient, UTF-8 subject, stable Message-ID and only that tenant\'s public URLs', flush=True)
        (fixture / 'result.json').write_text(json.dumps({'smtpAccepted': 3, 'checks': len(lines) + 1, 'externalEmailSent': False}))
        return 0
    except Exception as error:
        print('Readiness SMTP fixture failed (' + type(error).__name__ + '). Inspect its private fixture.log.', file=sys.stderr)
        return 1
    finally:
        subprocess.run(['docker', 'rm', '--force', '--volumes', container], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for path in fixture.glob('*'):
            if path.name not in ('fixture.log', 'result.json') and path.is_file(): path.unlink()
        print('Only this SMTP fixture, container, volume and private configuration/captures were removed.', flush=True)


if __name__ == '__main__':
    raise SystemExit(main())
