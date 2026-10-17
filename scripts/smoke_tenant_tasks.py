#!/usr/bin/env python3
"""Run real schedule lease checks in an owned disposable MongoDB container; no cloud credentials."""
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
    (ROOT / '.local').mkdir(exist_ok=True)
    name = 'commerce-schedule-test-' + uuid.uuid4().hex[:12]
    password = secrets.token_hex(32)
    with tempfile.TemporaryDirectory(prefix='tenant-tasks-', dir=ROOT / '.local') as temporary:
        folder = Path(temporary)
        try:
            subprocess.run(['docker', 'run', '-d', '--name', name, '--label', 'platform.fixture=tenant-schedule',
                '-e', 'MONGO_INITDB_ROOT_USERNAME=fixture', '-e', 'MONGO_INITDB_ROOT_PASSWORD=' + password,
                '-p', '127.0.0.1::27017', 'mongo:8.0'], check=True, stdout=subprocess.DEVNULL)
            script = 'if (!db.getSiblingDB("admin").auth("fixture", ' + json.dumps(password) + ')) throw Error("Fixture not ready"); db.adminCommand({ping:1});'
            for _ in range(90):
                ready = subprocess.run(['docker', 'exec', '-i', name, 'mongosh', '--quiet', '--file', '/dev/stdin'],
                    input=script, capture_output=True, text=True)
                if ready.returncode == 0: break
                time.sleep(1)
            else: raise RuntimeError('The owned MongoDB fixture did not become ready.')
            mapping = json.loads(subprocess.check_output(['docker', 'inspect', name], text=True))[0]['NetworkSettings']['Ports']['27017/tcp']
            if len(mapping) != 1 or mapping[0]['HostIp'] != '127.0.0.1': raise RuntimeError('The fixture must bind only loopback.')
            connection = folder / 'connection'
            connection.write_text('mongodb://fixture:' + password + '@127.0.0.1:' + mapping[0]['HostPort'] +
                                  '/platform_schedule_test_' + uuid.uuid4().hex + '?authSource=admin')
            connection.chmod(0o600)
            subprocess.run(['dotnet', 'run', '--project', str(ROOT / 'tests/Tenant.Tasks.Integration/Tenant.Tasks.Integration.csproj'),
                            '-c', 'Release', '--', str(connection)], cwd=ROOT, check=True)
        finally:
            subprocess.run(['docker', 'rm', '--force', '--volumes', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == '__main__': main()
