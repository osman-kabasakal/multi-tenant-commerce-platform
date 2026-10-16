#!/usr/bin/env python3
"""Use the actual Docker builder to verify that private synthetic files never enter the source context."""
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    os.umask(0o077)
    local = ROOT / '.local'; local.mkdir(mode=0o700, exist_ok=True)
    logs = local / 'logs'; logs.mkdir(mode=0o700, exist_ok=True)
    data = ROOT / 'Ecommerce/src/Installer/Grand.Installer.Cli/App_Data'
    with tempfile.TemporaryDirectory(prefix='docker-boundary-', dir=data) as source, tempfile.TemporaryDirectory(prefix='docker-context-', dir=local) as workspace:
        probe = Path(source); temporary = Path(workspace)
        private = ['Settings.cfg', 'appsettings.json', 'appsettings.Production.json', 'DataProtectionKeys/key.xml',
                   '.env', 'client.pem', 'signing.key', 'signer.p12', 'key.properties', 'google-services.json', 'cloud-service-account.json']
        marker = ('SYNTHETIC_PRIVATE_DOCKER_' + probe.name).encode()
        for relative in private:
            target = probe / relative; target.parent.mkdir(exist_ok=True); target.write_bytes(marker)
        (probe / 'resource.xml').write_bytes(b'<Resource>Public Docker context control</Resource>')
        (temporary / 'credentials.json').write_bytes(marker)
        definition = temporary / 'Dockerfile'
        definition.write_text('FROM scratch\nCOPY . /source/\n')
        output = temporary / 'export'
        with (logs / 'docker-source-context.log').open('w') as log:
            subprocess.run(['docker', 'buildx', 'build', '--network=none', '--file', str(definition),
                            '--output', 'type=local,dest=' + str(output), str(ROOT)], cwd=ROOT,
                           stdout=log, stderr=subprocess.STDOUT, check=True)
        root = output / 'source'
        copied = root / data.relative_to(ROOT) / probe.name
        if not (copied / 'resource.xml').is_file():
            raise RuntimeError('The real Docker context lost a legitimate public installation resource.')
        if any((copied / relative).exists() for relative in private):
            raise RuntimeError('The real Docker context retained private runtime configuration or keys.')
        if any((root / path).exists() for path in ('.git', '.local', '.codegraph')):
            raise RuntimeError('The real Docker context retained Git history or private local state.')
        for path in root.rglob('*'):
            if path.is_file() and marker in path.read_bytes():
                raise RuntimeError('Synthetic private content entered the real Docker build context.')
        for relative in ('SaasManager/src/Web/appsettings.json', 'Shared/Platform.Security/Platform.Security.csproj',
                         'Ecommerce/src/Web/Grand.Web/App_Data/Resources/Installation/installation.en.xml'):
            if not (root / relative).is_file():
                raise RuntimeError('The Docker context lost required public build input.')
        print('PASS: actual Docker context excludes private settings, keys, cloud/signing files, local state and Git history while retaining required build inputs.', flush=True)
    print('Only this probe\'s temporary source files and export directory were removed.', flush=True)


if __name__ == '__main__':
    main()
