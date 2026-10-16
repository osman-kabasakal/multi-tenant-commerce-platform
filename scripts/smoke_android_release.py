#!/usr/bin/env python3
"""Real encrypted tenant keys, native APK signatures and PostgreSQL worker recovery; Google HTTP and Flutter compilation are fixture adapters."""
import argparse
import base64
import json
import os
from pathlib import Path
import secrets
import shutil
import signal
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]


def run_owned(command, log, environment, timeout=900):
    process = subprocess.Popen(command, cwd=ROOT, env=environment, stdout=log, stderr=subprocess.STDOUT, start_new_session=(os.name != 'nt'))
    try:
        result = process.wait(timeout=timeout)
        if result: raise subprocess.CalledProcessError(result, command)
    except BaseException:
        if process.poll() is None:
            if os.name == 'nt': process.kill()
            else: os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--android-sdk', default=os.environ.get('ANDROID_HOME') or os.environ.get('ANDROID_SDK_ROOT'))
    parser.add_argument('--keytool', type=Path, default=Path(os.environ['JAVA_HOME']) / 'bin/keytool' if os.environ.get('JAVA_HOME') else Path(shutil.which('keytool') or ''))
    args = parser.parse_args()
    if not args.android_sdk or not (Path(args.android_sdk) / 'build-tools').is_dir() or not args.keytool.is_file():
        parser.error('Install Android build-tools/platforms and JDK keytool, then supply --android-sdk/--keytool.')
    os.umask(0o077)
    identity = uuid.uuid4().hex
    fixture = ROOT / '.local' / ('android-release-integration-' + identity[:10]); fixture.mkdir(parents=True, mode=0o700)
    password = secrets.token_urlsafe(24)
    database = 'android_release_test_' + identity
    container = 'commerce-android-release-' + identity[:10]
    master = fixture / 'master.key'; master.write_text(base64.b64encode(secrets.token_bytes(32)).decode())
    private = fixture / 'fixture.json'
    private.write_text(json.dumps({
        'LocalDemo': {'Enabled': False},
        'PlatformSecurity': {'Provider': 'AesGcm', 'InitializeSchema': True,
                             'ConnectionString': f'Host=127.0.0.1;Port=15441;Database={database};Username=commerce_probe;Password={password}',
                             'AesGcm': {'MasterKeyFile': str(master)}},
        'Fixture': {'Android': {'AllowSigningKeyCreation': True, 'SharedArtifactsConfirmed': True, 'SourceDirectory': str(ROOT),
                                'WorkingDirectory': str(fixture / 'work'), 'ArtifactDirectory': str(fixture / 'artifacts'),
                                'PythonPath': sys.executable, 'KeytoolPath': str(args.keytool.absolute()), 'AndroidSdkDirectory': str(Path(args.android_sdk).absolute())}}
    }))
    environment = dict(os.environ, POSTGRES_PASSWORD=password)
    log_path = fixture / 'fixture.log'
    print('Private mobile worker fixture: ' + str(fixture), flush=True)
    try:
        subprocess.run(['docker', 'run', '--rm', '--detach', '--name', container, '--label', 'commerce.test=android-release', '--publish', '127.0.0.1:15441:5432',
                        '--env', 'POSTGRES_PASSWORD', '--env', 'POSTGRES_USER=commerce_probe', '--env', 'POSTGRES_DB=' + database, 'postgres:16-alpine'],
                       env=environment, stdout=subprocess.DEVNULL, check=True)
        deadline = time.monotonic() + 60
        while time.monotonic() < deadline:
            ready = subprocess.run(['docker', 'exec', container, 'pg_isready', '-U', 'commerce_probe', '-d', database], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if ready.returncode == 0: break
            time.sleep(.5)
        else: raise RuntimeError('The isolated PostgreSQL mobile fixture did not become ready.')
        with log_path.open('w') as log:
            run_owned(['dotnet', 'build', 'tests/Android.Release.Integration/Android.Release.Integration.csproj', '-c', 'Release', '--nologo'], log, environment)
            run_owned(['dotnet', str(ROOT / 'tests/Android.Release.Integration/bin/Release/net8.0/Android.Release.Integration.dll'), str(private)], log, environment)
        for line in log_path.read_text().splitlines():
            if line.startswith('PASS:') or line.startswith('Actual encrypted'): print(line, flush=True)
        (fixture / 'result.json').write_text(json.dumps({'nativeWorkerVerified': True, 'flutterReleaseBuilt': False, 'liveGoogleResourcesCreated': False}))
        return 0
    except Exception as error:
        print('Native mobile worker fixture failed (' + type(error).__name__ + '). Inspect its private fixture.log.', file=sys.stderr)
        return 1
    finally:
        subprocess.run(['docker', 'rm', '--force', '--volumes', container], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for path in (private, master):
            if path.exists(): path.unlink()
        for path in (fixture / 'work', fixture / 'artifacts'):
            if path.exists(): shutil.rmtree(path)
        print('Only this fixture container, volume and temporary key/artifact files were removed.', flush=True)


if __name__ == '__main__':
    raise SystemExit(main())
