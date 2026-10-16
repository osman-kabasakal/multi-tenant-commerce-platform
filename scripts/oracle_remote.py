"""Committed SSH receiver. Called by oracle.py with `p` set to its validated request."""
import fcntl
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile


def receive(p, home=Path('/home/ubuntu')):
    os.umask(0o077)
    revision, deployment = p['revision'], p['deployment']
    if not re.fullmatch('[0-9a-f]{40}', revision) or not re.fullmatch('[a-z][a-z0-9-]{2,39}', deployment):
        raise ValueError('Invalid deployment request.')
    root = home / ('commerce-' + deployment)
    if str(root) != p['root'] or os.getuid() == 0:
        raise ValueError('Run only as the non-root Ubuntu deployment operator.')
    for path in (root, *root.parents):
        if path.is_symlink():
            raise ValueError('Refusing a symlinked deployment root.')
    if not root.exists():
        root.mkdir(mode=0o700)
    if root.stat().st_uid != os.getuid() or root.stat().st_mode & 0o077:
        raise ValueError('The deployment root must be private and owned by this operator.')
    for name in ('deploy.lock', 'oracle-installation.json', 'sources', 'state', 'deploy.log', 'last-successful-revision'):
        if (root / name).is_symlink():
            raise ValueError('Deployment files cannot be symbolic links.')
    with (root / 'deploy.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        marker = root / 'oracle-installation.json'
        expected = {'deployment': deployment, 'uid': os.getuid()}
        if marker.exists():
            if marker.is_symlink() or json.loads(marker.read_text()) != expected:
                raise ValueError('Foreign deployment ownership record.')
        else:
            # Operators may pre-create only the documented private inputs folder.
            if any(x.name not in {'inputs', 'deploy.lock'} for x in root.iterdir()):
                raise ValueError('Refusing to adopt an existing nonempty deployment.')
            marker.write_text(json.dumps(expected)); marker.chmod(0o600)
        subprocess.run(['cloud-init', 'status', '--wait'], check=True, timeout=900)
        subprocess.run(['docker', 'info'], check=True, stdout=subprocess.DEVNULL, timeout=30)
        for name in ('sources', 'state'):
            if (root / name).is_symlink():
                raise ValueError('Private source/state paths cannot be symlinks.')
        sources = root / 'sources'; sources.mkdir(exist_ok=True, mode=0o700)
        with tempfile.TemporaryDirectory(dir=root) as staging:
            bundle = Path(staging) / 'source.bundle'
            with bundle.open('wb') as output:
                while chunk := sys.stdin.buffer.read(1024 * 1024):
                    output.write(chunk)
            entries = subprocess.check_output(['git', 'bundle', 'list-heads', str(bundle)], text=True).splitlines()
            if entries != [revision + ' HEAD']:
                raise ValueError('The bundle does not contain exactly the requested committed HEAD.')
            source = sources / revision
            if source.exists():
                if source.is_symlink() or subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=source, text=True).strip() != revision:
                    raise ValueError('The existing source checkout is foreign.')
                if subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=source):
                    raise ValueError('The existing release checkout was edited; restore it explicitly.')
            else:
                checkout = Path(staging) / 'checkout'
                subprocess.run(['git', 'clone', '--no-checkout', str(bundle), str(checkout)], check=True)
                subprocess.run(['git', 'checkout', '--detach', revision], cwd=checkout, check=True)
                os.rename(checkout, source)
        inputs = root / 'inputs'
        if not inputs.is_dir() or inputs.is_symlink() or inputs.stat().st_uid != os.getuid() or inputs.stat().st_mode & 0o077:
            raise ValueError('The inputs directory must be private and owned by the deployment operator.')
        config = inputs / 'deployment.json'
        if any(x.is_symlink() for x in (config, *config.parents)) or not config.is_file() or config.stat().st_uid != os.getuid() or config.stat().st_mode & 0o077:
            raise ValueError('Supply the private Production deployment.json before deployment.')
        plan = json.loads(config.read_text())
        if plan.get('DeploymentId') != deployment:
            raise ValueError('Production and Oracle deployment IDs must match.')
        with (root / 'deploy.log').open('ab') as log:
            subprocess.run(['python3', str(source / 'scripts/production.py'), 'up', '--config', str(config), '--state', str(root / 'state')],
                           stdout=log, stderr=subprocess.STDOUT, check=True, timeout=6600)
        (root / 'last-successful-revision').write_text(revision + '\n')
        print('Production startup and public HTTPS verification passed for ' + revision)


if __name__ == '__main__':
    receive(p)
