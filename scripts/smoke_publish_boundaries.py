#!/usr/bin/env python3
"""Exercise ordinary .NET publishing with synthetic private files; no services or cloud credentials are used."""
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PROJECTS = {
    'installer': 'src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj',
    'commerce': 'src/Web/Grand.Web.MultiTenant/Grand.Web.MultiTenant.csproj',
    'admin': 'src/Web/Grand.Web.OnlyAdmin/Grand.Web.OnlyAdmin.csproj',
}


def main():
    os.umask(0o077)
    logs = ROOT / '.local/logs'; logs.mkdir(parents=True, exist_ok=True)
    for name, project in PROJECTS.items():
        source = ROOT / 'Ecommerce' / Path(project).parent / 'App_Data'
        with tempfile.TemporaryDirectory(prefix='publish-boundary-', dir=source) as directory, tempfile.TemporaryDirectory(prefix='publish-output-', dir=ROOT / '.local') as output:
            probe = Path(directory); (probe / 'DataProtectionKeys').mkdir()
            marker = ('SYNTHETIC_PRIVATE_PUBLISH_' + probe.name).encode()
            private = ['Settings.cfg', 'appsettings.json', 'appsettings.Production.json', 'DataProtectionKeys/probe.xml']
            for path in private:
                (probe / path).write_bytes(marker)
            public = probe / 'resource.xml'; public.write_text('<Resource>Synthetic public publication probe</Resource>')
            with (logs / ('build-publish-boundary-' + name + '.log')).open('w') as log:
                subprocess.run(['dotnet', 'publish', project, '-c', 'Release', '--nologo', '-o', output,
                                '-p:BuildType='+{'commerce':'Frontend','admin':'Backend','installer':'Installer'}[name], '-p:PublishTenantPlugins=true', '-p:UseAppHost=false', '--verbosity', 'quiet'], cwd=ROOT / 'Ecommerce', stdout=log, stderr=subprocess.STDOUT, check=True)
            if not (Path(output) / 'Plugins').is_dir():
                raise RuntimeError(name + ' publish omitted its required plugin directory.')
            target = Path(output) / 'App_Data' / probe.name
            if any((target / path).exists() for path in private):
                raise RuntimeError(name + ' copied runtime configuration or a private key into its artifact.')
            if not (target / public.name).is_file() or (target / public.name).read_bytes() != public.read_bytes():
                raise RuntimeError(name + ' dropped a legitimate public resource during publishing.')
            for path in Path(output).rglob('*'):
                if path.is_file() and marker in path.read_bytes():
                    raise RuntimeError(name + ' retained synthetic private content elsewhere in its artifact.')
            print('PASS: ' + name + ' publish excludes settings, environment configuration and nested keys while retaining public resources and the required plugin directory.', flush=True)
            if name == 'installer':
                expected = {
                    'wwwroot/logo.png': ROOT / 'Ecommerce/src/Installer/Grand.Installer.Cli/wwwroot/logo.png',
                    'App_Data/Resources/Installation/installation.en.xml': ROOT / 'Ecommerce/src/Web/Grand.Web/App_Data/Resources/Installation/installation.en.xml',
                    'App_Data/Resources/Installation/installation.pl.xml': ROOT / 'Ecommerce/src/Web/Grand.Web/App_Data/Resources/Installation/installation.pl.xml',
                    'App_Data/Resources/supportedcollation.xml': ROOT / 'Ecommerce/src/Web/Grand.Web/App_Data/Resources/supportedcollation.xml',
                }
                for relative, original in expected.items():
                    packaged = Path(output) / relative
                    if not packaged.is_file() or hashlib.sha256(packaged.read_bytes()).digest() != hashlib.sha256(original.read_bytes()).digest():
                        raise RuntimeError('The ordinary installer publish has missing or changed installation resources.')
                print('PASS: ordinary installer publish packages the exact logo, installation translations and supported collations without helper copies.', flush=True)
    print('All real publish-boundary checks passed; temporary source probes and artifacts were removed.', flush=True)


if __name__ == '__main__':
    main()
