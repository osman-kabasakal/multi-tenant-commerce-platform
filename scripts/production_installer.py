#!/usr/bin/env python3
"""Publish an installer-only fix on verified existing server/Android images. Full fresh builds still use Dockerfile."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
COMPONENT = 'Ecommerce/src/Installer/Grand.Installer.Cli/'
HELPERS = {'scripts/production_installer.py', 'scripts/test_production_installer.py', 'infra/production/InstallerPatch.Dockerfile'}


def require_component_changes(paths):
    if not any(path.startswith(COMPONENT) for path in paths):
        raise ValueError('An installer runtime source change is required.')
    if any(not (path.startswith((COMPONENT, 'docs/', 'tests/')) or path in HELPERS) for path in paths):
        raise ValueError('Other runtime/build sources changed; use the ordinary full image build.')


def inspect(image):
    return json.loads(subprocess.check_output(['docker', 'image', 'inspect', image], text=True))[0]


def require_base(image, revision, android):
    data = inspect(image); config = data['Config']
    if data['Os'] != 'linux' or data['Architecture'] != 'amd64' or config['User'] != str(os.getuid()) + ':' + str(os.getgid()) or config.get('Labels', {}).get('org.opencontainers.image.revision') != revision:
        raise ValueError('Use this operator-owned Linux amd64 image from the exact base revision.')
    if android and config.get('Labels', {}).get('commerce.mobile.provider') != 'AndroidAppDistribution':
        raise ValueError('The Android base must include the verified mobile toolchain.')
    return data


def require_preserved_runtime(base, patched, revision):
    old = base['Config']; new = patched['Config']
    if patched['RootFS']['Layers'][:len(base['RootFS']['Layers'])] != base['RootFS']['Layers']:
        raise ValueError('The patched image lost the verified base layers.')
    if any(old.get(key) != new.get(key) for key in ('User', 'Env', 'Entrypoint', 'Cmd', 'WorkingDir')):
        raise ValueError('The patch changed a runtime/SDK setting.')
    if new.get('Labels', {}).get('org.opencontainers.image.revision') != revision:
        raise ValueError('The patch does not identify its actual source revision.')


def build(base_revision):
    if not re.fullmatch('[0-9a-f]{40}', base_revision) or os.getuid() == 0:
        raise ValueError('Use a full base revision as a non-root deployment operator.')
    current = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    subprocess.run(['git', 'merge-base', '--is-ancestor', base_revision, current], cwd=ROOT, check=True)
    changed = subprocess.check_output(['git', 'diff', '--name-only', base_revision, current], cwd=ROOT, text=True).splitlines()
    require_component_changes(changed)
    if shutil.disk_usage(ROOT).free < 12 * 1024**3:
        raise ValueError('The installer-only build requires 12 GiB free.')
    bases = {False: 'commerce-platform:' + base_revision[:12], True: 'commerce-platform:' + base_revision[:12] + '-android'}
    original = {android: require_base(image, base_revision, android) for android, image in bases.items()}
    local = ROOT / '.local/production-build'; local.mkdir(parents=True, exist_ok=True, mode=0o700)
    results = {}
    with tempfile.TemporaryDirectory(prefix='installer-patch-', dir=local) as directory:
        archive = Path(directory) / 'source.tar'
        with archive.open('wb') as output:
            subprocess.run(['git', 'archive', '--format=tar', current], cwd=ROOT, stdout=output, check=True)
        for android, target in ((False, 'patched-server'), (True, 'patched-android')):
            image = 'commerce-platform:' + current[:12] + ('-android' if android else '')
            command = ['docker', 'build', '--platform', 'linux/amd64', '--target', target, '--file', 'infra/production/InstallerPatch.Dockerfile',
                '--build-arg', 'BASE_SERVER_IMAGE=' + bases[False], '--build-arg', 'BASE_ANDROID_IMAGE=' + bases[True],
                '--build-arg', 'SOURCE_REVISION=' + current, '--build-arg', 'BASE_REVISION=' + base_revision,
                '--build-arg', 'PLATFORM_UID=' + str(os.getuid()), '--build-arg', 'PLATFORM_GID=' + str(os.getgid()), '--tag', image, '-']
            with archive.open('rb') as source:
                subprocess.run(command, cwd=ROOT, stdin=source, check=True)
            patched = inspect(image); require_preserved_runtime(original[android], patched, current)
            results[image] = {'id': patched['Id'], 'baseId': original[android]['Id'], 'runtimeAndSdkSettingsPreserved': True}
    receipt = local / ('installer-patch-' + current + '.json')
    receipt.write_text(json.dumps({'sourceRevision': current, 'baseRevision': base_revision, 'changedPaths': changed, 'images': results}, indent=2) + '\n')
    receipt.chmod(0o600)
    print('Installer-only images built from committed source; unchanged runtime and Android SDK base layers verified.', flush=True)


if __name__ == '__main__':
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base-revision', required=True)
    build(parser.parse_args().base_revision)
