#!/usr/bin/env python3
"""Verify real Redis/WebSocket notification transport in independent isolated processes."""
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
    name = 'commerce-signalr-test-' + uuid.uuid4().hex[:12]
    password = secrets.token_hex(32)
    with tempfile.TemporaryDirectory(prefix='signalr-fixture-', dir=ROOT / '.local') as temporary:
        folder = Path(temporary)
        try:
            subprocess.run(['docker', 'run', '-d', '--name', name, '--label', 'platform.fixture=signalr',
                '-p', '127.0.0.1::6379', 'redis:7.4-alpine', 'redis-server', '--requirepass', password,
                '--save', '', '--appendonly', 'no'], check=True, stdout=subprocess.DEVNULL)
            for _ in range(60):
                ready = subprocess.run(['docker', 'exec', '-e', 'REDISCLI_AUTH=' + password, name, 'redis-cli', 'ping'], capture_output=True, text=True)
                if ready.returncode == 0 and ready.stdout.strip() == 'PONG': break
                time.sleep(1)
            else: raise RuntimeError('The owned Redis fixture did not become ready.')
            mapping = json.loads(subprocess.check_output(['docker', 'inspect', name], text=True))[0]['NetworkSettings']['Ports']['6379/tcp']
            if len(mapping) != 1 or mapping[0]['HostIp'] != '127.0.0.1': raise RuntimeError('The fixture must bind only loopback.')
            settings = folder / 'fixture.json'
            settings.write_text(json.dumps({'Fixture': {'Enabled': True}, 'Provisioning': {'ManagedRuntime': True},
                'PlatformSignalR': {'Provider': 'Redis', 'DeploymentId': 'signalr-test-' + uuid.uuid4().hex[:12]},
                'Redis': {'RedisPubSubConnectionString': '127.0.0.1:' + mapping[0]['HostPort'] + ',password=' + password}}))
            settings.chmod(0o600)
            subprocess.run(['dotnet', 'run', '--project', str(ROOT / 'tests/SignalR.Integration/SignalR.Integration.csproj'),
                            '-c', 'Release', '--', '--verify', str(settings)], cwd=ROOT, check=True)
        finally:
            subprocess.run(['docker', 'rm', '--force', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == '__main__': main()
