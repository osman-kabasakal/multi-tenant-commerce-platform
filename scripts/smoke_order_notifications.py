#!/usr/bin/env python3
"""Verify durable order projections in two owned disposable Mongo databases; no cloud delivery."""
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
    name = 'commerce-order-test-' + uuid.uuid4().hex[:12]
    password = secrets.token_hex(32)
    with tempfile.TemporaryDirectory(prefix='order-notifications-', dir=ROOT / '.local') as temporary:
        folder = Path(temporary)
        try:
            subprocess.run(['docker', 'run', '-d', '--name', name, '--label', 'platform.fixture=order-notifications',
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
            settings = folder / 'fixture.json'
            settings.write_text(json.dumps({'Provisioning': {'ManagedRuntime': True}, 'Fixture': {
                'Purpose': 'isolated-order-notifications-v1',
                'Connection': 'mongodb://fixture:' + password + '@127.0.0.1:' + mapping[0]['HostPort'] + '/admin?authSource=admin',
                'DatabaseA': 'tenant_' + uuid.uuid4().hex, 'DatabaseB': 'tenant_' + uuid.uuid4().hex}}))
            settings.chmod(0o600)
            subprocess.run(['dotnet', 'run', '--project', str(ROOT / 'tests/Order.Notifications.Integration/Order.Notifications.Integration.csproj'),
                            '-c', 'Release', '--', str(settings)], cwd=ROOT, check=True)
        finally:
            subprocess.run(['docker', 'rm', '--force', '--volumes', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == '__main__': main()
