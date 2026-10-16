#!/usr/bin/env python3
"""Build the Linux runtime image from a committed, clean Git snapshot; never upload local private state."""
import argparse
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def build(image, platform, uid, gid):
    if not re.fullmatch(r'[a-z0-9][a-z0-9._/:\-]*', image) or image.startswith('-'):
        raise ValueError('Use a lowercase Docker image name and tag.')
    if platform not in ('linux/amd64', 'linux/arm64') or min(uid, gid) <= 0:
        raise ValueError('Select Linux amd64/arm64 and positive non-root numeric user/group ids.')
    # Never traverse or include the working tree, ignored files, private keys or .git history.
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    tracked = subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', revision], cwd=ROOT, text=True).splitlines()
    if 'infra/production/Dockerfile' not in tracked:
        raise ValueError('Commit the production image definition before building its clean source snapshot.')
    local = ROOT / '.local/production-build'; local.mkdir(parents=True, exist_ok=True, mode=0o700)
    with tempfile.TemporaryDirectory(prefix='source-', dir=local) as temporary:
        snapshot = Path(temporary) / 'source.tar'
        with snapshot.open('wb') as output:
            subprocess.run(['git', 'archive', '--format=tar', revision], cwd=ROOT, stdout=output, check=True)
        with snapshot.open('rb') as source:
            subprocess.run(['docker', 'build', '--platform', platform, '--file', 'infra/production/Dockerfile',
                            '--build-arg', 'SOURCE_REVISION=' + revision, '--build-arg', 'PLATFORM_UID=' + str(uid),
                            '--build-arg', 'PLATFORM_GID=' + str(gid), '--tag', image, '-'],
                           cwd=ROOT, stdin=source, check=True)
    print('Built committed Linux platform image: ' + image + ' (' + revision + ')', flush=True)


def verify(image):
    # Real container execution verifies both runtimes, artifact layout and the non-root entrypoint.
    probe = r'''
set -eu
[ "$(id -u)" -ne 0 ]
dotnet --list-runtimes | grep -E '^Microsoft.NETCore.App 8\.'
dotnet --list-runtimes | grep -E '^Microsoft.NETCore.App 9\.'
dotnet --list-runtimes | grep -E '^Microsoft.AspNetCore.App 8\.'
dotnet --list-runtimes | grep -E '^Microsoft.AspNetCore.App 9\.'
for file in commerce/Grand.Web.MultiTenant.dll admin/Grand.Web.OnlyAdmin.dll gateway/Platform.Gateway.dll saas/SaasManager.Web.dll worker/TenantManager.dll bootstrap/Platform.Bootstrap.dll installer/Grand.Installer.Cli.dll saas/wwwroot/index.html installer/wwwroot/logo.png installer/App_Data/Resources/Installation/installation.en.xml installer/App_Data/Resources/Installation/installation.pl.xml installer/App_Data/Resources/supportedcollation.xml; do
  test -s "/app/$file"
done
for directory in commerce/Plugins admin/Plugins installer/Plugins; do test -d "/app/$directory"; done
test -z "$(find /app -name Settings.cfg -o -name DataProtectionKeys -o -name service-account.json -o -name google-services.json -o -name appsettings.Production.json)"
/usr/local/bin/platform bootstrap --help
'''
    subprocess.run(['docker', 'run', '--rm', '--network', 'none', '--read-only', '--cap-drop', 'ALL',
                    '--security-opt', 'no-new-privileges:true', '--tmpfs', '/tmp:rw,noexec,nosuid,size=16m',
                    '--entrypoint', '/bin/sh', image, '-ec', probe], check=True)
    invalid = subprocess.run(['docker', 'run', '--rm', '--network', 'none', image, 'unknown-role'], capture_output=True)
    if invalid.returncode != 64 or b'Unknown platform role.' not in invalid.stderr:
        raise RuntimeError('The runtime accepted an unrecognized application role.')
    print('PASS: real offline non-root container contains every server/installer artifact and both .NET runtimes; bootstrap executes.', flush=True)


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['build', 'verify'])
    parser.add_argument('--image', default='commerce-platform:local')
    parser.add_argument('--platform', default='linux/amd64', choices=['linux/amd64', 'linux/arm64'])
    parser.add_argument('--uid', type=int, default=os.getuid())
    parser.add_argument('--gid', type=int, default=os.getgid())
    args = parser.parse_args()
    if args.action == 'build': build(args.image, args.platform, args.uid, args.gid)
    else: verify(args.image)


if __name__ == '__main__':
    main()
