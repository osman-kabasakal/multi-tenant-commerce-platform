#!/usr/bin/env python3
"""Verify actual tenant cache/Redis transport across isolated web processes; no cloud accounts."""
import argparse
import json
import os
from pathlib import Path
import secrets
import socket
import subprocess
import tempfile
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--redis-server', type=Path, help='Optional existing Redis executable; otherwise use an owned Docker container.')
    args = parser.parse_args()
    os.umask(0o077)
    (ROOT / '.local').mkdir(exist_ok=True)
    name = 'commerce-cache-test-' + uuid.uuid4().hex[:12]
    password = secrets.token_hex(32)
    native = None
    container = False
    with tempfile.TemporaryDirectory(prefix='cache-fixture-', dir=ROOT / '.local') as temporary:
        folder = Path(temporary)
        try:
            if args.redis_server:
                executable = args.redis_server.resolve(strict=True)
                if not executable.is_file() or not os.access(executable, os.X_OK): raise ValueError('Choose an executable Redis server.')
                with socket.socket() as reserve:
                    reserve.bind(('127.0.0.1', 0)); port = reserve.getsockname()[1]
                configuration = folder / 'redis.conf'
                configuration.write_text('bind 127.0.0.1\nprotected-mode yes\nport ' + str(port) + '\nrequirepass ' + password +
                    '\nsave ""\nappendonly no\nmaxmemory 64mb\nmaxmemory-policy allkeys-lru\nlogfile ' + json.dumps(str(folder / 'redis.log'), ensure_ascii=False) +
                    '\ndir ' + json.dumps(str(folder), ensure_ascii=False) + '\n')
                configuration.chmod(0o600)
                native = subprocess.Popen([str(executable), str(configuration)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                container = True
                subprocess.run(['docker', 'run', '-d', '--name', name, '--label', 'platform.fixture=tenant-cache',
                    '-p', '127.0.0.1::6379', '--tmpfs', '/data:rw,nosuid,noexec,size=16m', 'redis:7.4-alpine', 'redis-server', '--requirepass', password,
                    '--save', '', '--appendonly', 'no', '--maxmemory', '64mb'], check=True, stdout=subprocess.DEVNULL)
                info = json.loads(subprocess.check_output(['docker', 'inspect', name], text=True))[0]
                if any(mount['Type'] == 'volume' for mount in info['Mounts']): raise RuntimeError('The Redis fixture must not leave an anonymous data volume.')
                mapping = info['NetworkSettings']['Ports']['6379/tcp']
                if len(mapping) != 1 or mapping[0]['HostIp'] != '127.0.0.1': raise RuntimeError('The fixture must bind only loopback.')
                port = int(mapping[0]['HostPort'])
            for _ in range(100):
                if native is not None and native.poll() is not None: raise RuntimeError('The owned Redis server exited before readiness.')
                try:
                    with socket.create_connection(('127.0.0.1', port), timeout=1) as connection:
                        connection.sendall(('*2\r\n$4\r\nAUTH\r\n$' + str(len(password)) + '\r\n' + password + '\r\n*1\r\n$4\r\nPING\r\n').encode())
                        stream = connection.makefile('rb')
                        if stream.readline() == b'+OK\r\n' and stream.readline() == b'+PONG\r\n': break
                except OSError:
                    pass
                time.sleep(.1)
            else: raise RuntimeError('The owned authenticated Redis fixture did not become ready.')
            settings = folder / 'fixture.json'
            settings.write_text(json.dumps({'Fixture': {'Purpose': 'isolated-tenant-cache-v1',
                'Connection': '127.0.0.1:' + str(port) + ',password=' + password, 'Channel': 'cache-fixture-' + uuid.uuid4().hex[:12]}}))
            settings.chmod(0o600)
            subprocess.run(['dotnet', 'run', '--project', str(ROOT / 'tests/Cache.Integration/Cache.Integration.csproj'),
                '-c', 'Release', '--', '--verify', str(settings)], cwd=ROOT, check=True, timeout=180)
        finally:
            if native is not None:
                native.terminate()
                try: native.wait(timeout=5)
                except subprocess.TimeoutExpired: native.kill(); native.wait()
            if container: subprocess.run(['docker', 'rm', '--force', '--volumes', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=30)


if __name__ == '__main__': main()
