#!/usr/bin/env python3
"""Build and verify the opt-in Linux amd64 Android provisioning image from committed public sources."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import tempfile
import uuid

import mobile_android as mobile

ROOT = Path(__file__).resolve().parents[1]


def source_context(destination, revision):
    """Extract only regular, approved committed mobile files; never traverse the working tree."""
    package = destination / 'mobile-source'; package.mkdir(mode=0o700)
    files = []
    with tempfile.TemporaryFile() as archive:
        subprocess.run(['git', 'archive', '--format=tar', revision, '--', 'Platforms/store_user_app', 'Platforms/modules', 'scripts/mobile_android.py'],
                       cwd=ROOT, stdout=archive, check=True)
        archive.seek(0)
        with tarfile.open(fileobj=archive) as entries:
            for entry in entries:
                if entry.isdir(): continue
                mobile.validate_source_name(entry.name)
                if not entry.isfile(): raise ValueError('Committed mobile sources must be regular files.')
                target = package / entry.name; target.parent.mkdir(parents=True, exist_ok=True)
                with entries.extractfile(entry) as source, target.open('xb') as output: shutil.copyfileobj(source, output)
                target.chmod(0o755 if entry.mode & 0o111 else 0o644)
                files.append({'path': entry.name, 'sha256': mobile.file_hash(target)})
    if not files: raise ValueError('The committed mobile source package is empty.')
    mobile.private_json(package / 'mobile-source.json', {'version': 1, 'files': sorted(files, key=lambda item: item['path'])})
    return package


def inspect(image):
    return json.loads(subprocess.check_output(['docker', 'image', 'inspect', image], text=True))[0]


def require_image(image, mobile_provider=False):
    if os.getuid() == 0: raise ValueError('Use a non-root deployment operator for the Android image.')
    data = inspect(image); config = data['Config']
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    if data['Os'] != 'linux' or data['Architecture'] != 'amd64' or config['User'] != str(os.getuid()) + ':' + str(os.getgid()) or config.get('Labels', {}).get('org.opencontainers.image.revision') != revision:
        raise ValueError('Use the current committed Linux amd64 image built for this non-root operator.')
    if mobile_provider and config.get('Labels', {}).get('commerce.mobile.provider') != 'AndroidAppDistribution':
        raise ValueError('Select the actual Android provisioning image.')
    return revision


def build(image, server_image, accept_licenses):
    if not accept_licenses: raise ValueError('Explicitly accept the Android SDK licenses before building its optional worker image.')
    for value in (image, server_image):
        if not re.fullmatch(r'[a-z0-9][a-z0-9._/:\-]*', value): raise ValueError('Use an explicit lowercase Docker image name and tag.')
    if image == server_image: raise ValueError('The Android worker image must have a separate tag.')
    revision = require_image(server_image)
    if shutil.disk_usage(ROOT).free < 30 * 1024**3: raise ValueError('The Android toolchain image requires at least 30 GiB free build disk.')
    local = ROOT / '.local/production-build'; local.mkdir(parents=True, exist_ok=True, mode=0o700)
    with tempfile.TemporaryDirectory(prefix='android-context-', dir=local) as directory:
        context = Path(directory); source_context(context, revision)
        (context / 'Dockerfile').write_bytes(subprocess.check_output(['git', 'show', revision + ':infra/production/AndroidWorker.Dockerfile'], cwd=ROOT))
        subprocess.run(['docker', 'build', '--platform', 'linux/amd64', '--build-arg', 'PLATFORM_SERVER_IMAGE=' + server_image,
                        '--build-arg', 'PLATFORM_UID=' + str(os.getuid()), '--build-arg', 'PLATFORM_GID=' + str(os.getgid()),
                        '--build-arg', 'ACCEPT_ANDROID_SDK_LICENSES=true', '--tag', image, str(context)], check=True)
    print('Built the optional Android provisioning image from committed sources: ' + image, flush=True)


def verify(image):
    require_image(image, True)
    probe = r'''
set -eu
[ "$(id -u)" -ne 0 ]
python3 --version
java -version
/opt/android-sdk/build-tools/35.0.0/apksigner version
/opt/android-sdk/build-tools/35.0.0/aapt2 version
test -s /opt/android-sdk/platforms/android-36/android.jar
grep -q '28.2.13676358' /opt/android-sdk/ndk/28.2.13676358/source.properties
test "$(git -C /opt/flutter rev-parse HEAD)" = ee80f08bbf97172ec030b8751ceab557177a34a6
python3 /app/mobile-source/scripts/mobile_android.py --source-hash
flutter --version --machine > /tmp/flutter-verified.json
python3 -c 'import json; v=json.load(open("/tmp/flutter-verified.json")); assert v["frameworkRevision"] == "ee80f08bbf97172ec030b8751ceab557177a34a6"'
'''
    subprocess.run(['docker', 'run', '--rm', '--network', 'none', '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
                    '--entrypoint', '/bin/sh', image, '-ec', probe], check=True, timeout=180)
    print('PASS: the actual non-root Android image executes its pinned SDK/Flutter/JDK tools and immutable source package offline.', flush=True)


def cleanup_probe(private):
    # Own disposable fixtures only; retain public diagnostics and never follow symlinks.
    for probe in private.glob('flutter-release-*'):
        if probe.is_symlink() or not probe.is_dir(): continue
        for path in probe.iterdir():
            if path.name in ('fixture.log', 'result.json', 'gradle-task-audit.json') and path.is_file() and not path.is_symlink(): continue
            if path.is_dir() and not path.is_symlink(): shutil.rmtree(path)
            else: path.unlink()


def smoke(image):
    require_image(image, True)
    if shutil.disk_usage(ROOT).free < 20 * 1024**3: raise ValueError('The real container Flutter release probe requires 20 GiB free.')
    os.umask(0o077); local = ROOT / '.local'; local.mkdir(parents=True, exist_ok=True, mode=0o700)
    private = local / ('android-runtime-' + uuid.uuid4().hex[:12]); private.mkdir(mode=0o700)
    name = 'platform-android-probe-' + uuid.uuid4().hex[:12]
    print('Private container release diagnostics: ' + str(private), flush=True)
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    with tempfile.TemporaryDirectory(prefix='acceptance-', dir=private) as directory:
        acceptance = Path(directory)
        for filename in ('smoke_flutter_release.py', 'test_mobile_android.py'):
            (acceptance / filename).write_bytes(subprocess.check_output(['git', 'show', revision + ':scripts/' + filename], cwd=ROOT))
        try:
            subprocess.run(['docker', 'run', '--rm', '--name', name, '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
                '--mount', 'type=bind,src=' + str(acceptance) + ',dst=/opt/platform-acceptance,readonly',
                '--mount', 'type=bind,src=' + str(private) + ',dst=/app/mobile-source/.local',
                '--env', 'PYTHONPATH=/app/mobile-source/scripts:/opt/platform-acceptance',
                '--entrypoint', '/usr/bin/python3', image, '/opt/platform-acceptance/smoke_flutter_release.py'], check=True, timeout=7200)
        finally:
            subprocess.run(['docker', 'rm', '--force', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            cleanup_probe(private)
    print('Real container Flutter release diagnostics: ' + str(private), flush=True)


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['build', 'verify', 'smoke'])
    parser.add_argument('--image', default='commerce-platform:local-android')
    parser.add_argument('--server-image', default='commerce-platform:local')
    parser.add_argument('--accept-android-sdk-licenses', action='store_true')
    args = parser.parse_args()
    if args.action == 'build': build(args.image, args.server_image, args.accept_android_sdk_licenses)
    elif args.action == 'verify': verify(args.image)
    else: smoke(args.image)


if __name__ == '__main__': main()
