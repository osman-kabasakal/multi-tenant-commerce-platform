#!/usr/bin/env python3
"""Cold data snapshots for the generated single-host Linux Compose deployment.

Restore requires the original runtime images, source revision and deployment UID/GID.
The archive contains private credentials. Store it only in protected backup storage.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import platform
import re
import shutil
import signal
import stat
import subprocess
import tarfile
import tempfile
import uuid

import production
import production_config as config

ROOT = production.ROOT
VOLUMES = ('postgres-data', 'mongo-data', 'redis-data')
CACHES = ('logs', 'mobile-work', 'mobile-cache')


def private_path(value):
    path = Path(os.path.abspath(value))
    if any(item.is_symlink() for item in (path, *path.parents)):
        raise ValueError('Private snapshot paths cannot contain symbolic links.')
    if path == ROOT or ROOT in path.parents and ROOT / '.local' not in path.parents:
        raise ValueError('Keep snapshots and restored private state outside Git or under .local.')
    return path


def private_directory(path):
    info = path.stat()
    if not stat.S_ISDIR(info.st_mode) or info.st_uid != os.getuid() or info.st_mode & 0o077:
        raise ValueError('Use an operator-owned 0700 private directory.')


def digest(path):
    result = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024 * 1024), b''): result.update(block)
    return result.hexdigest()


def members(archive):
    seen = set()
    for item in archive:
        name = PurePosixPath(item.name)
        if name.is_absolute() or '..' in name.parts or not (item.isfile() or item.isdir()) or name in seen or name == PurePosixPath('.') and not item.isdir():
            raise ValueError('Snapshot entries must be unique relative regular files or directories.')
        seen.add(name)
        yield item, name


def verify_snapshot(backup):
    private_directory(backup)
    manifest = backup / 'snapshot.json'
    info = manifest.lstat()
    if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_mode & 0o077:
        raise ValueError('The snapshot manifest must be an operator-owned private regular file.')
    value = json.loads(manifest.read_text())
    if not re.fullmatch('[a-f0-9]{32}', value.get('installationId', '')) or not re.fullmatch('commerce-prod-[a-z][a-z0-9-]{2,39}', value.get('project', '')) or not re.fullmatch('[a-f0-9]{40}', value.get('sourceRevision', '')):
        raise ValueError('The snapshot installation, project or source identity is invalid.')
    if type(value.get('uid')) is not int or value['uid'] <= 0 or type(value.get('gid')) is not int or value['gid'] < 0:
        raise ValueError('The snapshot must name its original non-root deployment account.')
    if not isinstance(value.get('images'), dict) or not value['images'] or any(not re.fullmatch(r'[a-z0-9][a-z0-9._/:@\-]*', key) or not re.fullmatch('sha256:[a-f0-9]{64}', image) for key, image in value['images'].items()):
        raise ValueError('The snapshot must identify exact original runtime images.')
    names = {'state.tar', *(name + '.tar' for name in VOLUMES)}
    if value.get('version') != 1 or set(value.get('archives', {})) != names:
        raise ValueError('Select a complete supported data snapshot.')
    for name, expected in value['archives'].items():
        path = backup / name
        info = path.lstat()
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_mode & 0o077 or digest(path) != expected:
            raise ValueError('Snapshot contents or private ownership do not match its manifest.')
        with tarfile.open(path, 'r:') as archive:
            for _ in members(archive): pass
    return value


def docker_json(*arguments):
    result = subprocess.run(['docker', *arguments], text=True, capture_output=True, check=True)
    return json.loads(result.stdout)


def existing(kind, name):
    found = subprocess.run(['docker', kind, 'inspect', name], text=True, capture_output=True)
    if found.returncode == 0: return json.loads(found.stdout)[0]
    if 'no such' in found.stderr.lower() or 'not found' in found.stderr.lower(): return None
    raise RuntimeError('Docker resource inspection failed.')


def images(definition):
    result = {}
    for reference in sorted({service['image'] for service in definition['services'].values()}):
        value = docker_json('image', 'inspect', reference)[0]
        result[reference] = value['Id']
    return result


def statuses(deployment):
    output = deployment.run('ps', '--all', '--format', 'json', capture=True).stdout.strip()
    return json.loads(output) if output.startswith('[') else [json.loads(line) for line in output.splitlines() if line]


def services_ready(deployment, selected):
    entries = [entry for entry in statuses(deployment) if entry['Service'] in selected]
    return {entry['Service'] for entry in entries} == set(selected) and all(
        entry['State'] == 'running' and entry.get('Health') in (None, '', 'healthy') for entry in entries)


def resume_services(deployment, running):
    # Older Compose releases have no start --wait; use portable start plus real readiness probes.
    running = set(running)
    databases = ('postgres', 'mongo', 'redis')
    for group in (databases, ('keycloak',), tuple(sorted(running - set(databases) - {'keycloak'}))):
        selected = [name for name in group if name in running]
        if not selected: continue
        deployment.run('start', *selected)
        deployment.wait('original snapshot services', lambda selected=selected: services_ready(deployment, selected), 240)
        if 'keycloak' in selected and 'postgres' in running:
            deployment.wait('restored identity service', deployment.verify_identity, 240)
    if {'postgres', 'mongo', 'redis', 'keycloak', 'edge', 'saas', 'commerce', 'admin', 'gateway', 'worker'} <= running:
        deployment.verify_hosts()


def volume_tar(image, name, output=None, source=None):
    operation = uuid.uuid4().hex
    helper = 'platform-data-snapshot-' + operation
    command = ['docker', 'run', '--rm', '--name', helper, '--label', 'commerce.snapshot.operation=' + operation,
        '--network', 'none', '--read-only', '--user', '0', '--cap-drop', 'ALL', '--cap-add', 'DAC_OVERRIDE',
        '--security-opt', 'no-new-privileges:true']
    try:
        if source:
            command += ['--cap-add', 'CHOWN', '--cap-add', 'FOWNER', '--mount', 'type=volume,source=' + name + ',target=/snapshot',
                '--entrypoint', '/bin/tar', '-i', image, '-C', '/snapshot', '-xpf', '-']
            with source.open('rb') as stream: subprocess.run(command, stdin=stream, stdout=subprocess.DEVNULL, check=True)
        else:
            command += ['--mount', 'type=volume,source=' + name + ',target=/snapshot,readonly',
                '--entrypoint', '/bin/tar', image, '-C', '/snapshot', '-cpf', '-', '.']
            with output.open('xb') as stream: subprocess.run(command, stdout=stream, check=True)
            output.chmod(0o600)
    finally:
        found = existing('container', helper)
        if found and found['Config'].get('Labels', {}).get('commerce.snapshot.operation') == operation:
            subprocess.run(['docker', 'rm', '--force', helper], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def save_state(state, destination):
    with tarfile.open(destination, 'w') as archive:
        for directory, folders, files in os.walk(state, followlinks=False):
            current = Path(directory)
            for path in [current, *(current / name for name in files), *(current / name for name in folders)]:
                if path.is_symlink(): raise ValueError('Private state cannot contain linked files or directories.')
            archive.add(current, arcname=current.relative_to(state).as_posix(), recursive=False)
            if current == state:
                for name in CACHES:
                    if name in folders:
                        archive.add(state / name, arcname=name, recursive=False)
                folders[:] = [name for name in folders if name not in CACHES]
            for name in files: archive.add(current / name, arcname=(current / name).relative_to(state).as_posix(), recursive=False)
    destination.chmod(0o600)


def unpack_state(source, destination):
    destination.mkdir(mode=0o700)
    with tarfile.open(source, 'r:') as archive:
        for item, name in members(archive):
            if name == PurePosixPath('.'): continue
            target = destination.joinpath(*name.parts)
            if item.isdir(): target.mkdir(parents=True, exist_ok=True, mode=0o700)
            else:
                target.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
                with archive.extractfile(item) as stream, target.open('xb') as output: shutil.copyfileobj(stream, output)
                target.chmod(0o600)


def backup_state(state, backup):
    private_directory(state)
    if backup.exists() or state in backup.parents or backup in state.parents:
        raise ValueError('Choose a new backup directory outside the deployment state.')
    backup.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    private_directory(backup.parent)
    deployment = production.Deployment(state)
    deployment.owned_resources()
    record = deployment.record
    if record['Uid'] != os.getuid() or record['Gid'] != os.getgid(): raise ValueError('Use the original deployment account.')
    project = deployment.definition['name']
    for key in VOLUMES:
        if existing('volume', project + '_' + key) is None: raise ValueError('An original data volume is missing.')
    selected = images(deployment.definition)
    entries = statuses(deployment)
    for entry in entries:
        container = docker_json('inspect', entry['ID'])[0]
        if container['Config'].get('Labels', {}).get('commerce.installation') != record['InstallationId']:
            raise ValueError('A Compose container does not belong to this installation.')
        if any(mount['Type'] == 'bind' and not Path(mount['Source']).is_relative_to(state) for mount in container.get('Mounts', [])):
            raise ValueError('External bind mounts need a separate coordinated backup; this snapshot supports generated private state only.')
        reference = deployment.definition['services'][entry['Service']]['image']
        if container['Image'] != selected[reference]: raise ValueError('A runtime image tag changed; preserve the original images before snapshotting.')
    running = [entry['Service'] for entry in entries if entry['State'] == 'running']
    if any(entry['State'] not in ('running', 'exited', 'created') for entry in entries):
        raise ValueError('Stabilize restarting or paused services before snapshotting.')
    stage = Path(tempfile.mkdtemp(prefix='.snapshot-', dir=backup.parent))
    try:
        try:
            deployment.run('stop', '--timeout', '60')
            if any(entry['State'] == 'running' for entry in statuses(deployment)): raise RuntimeError('The deployment did not stop completely.')
            save_state(state, stage / 'state.tar')
            for key in VOLUMES: volume_tar(selected[deployment.definition['services']['postgres']['image']], project + '_' + key, output=stage / (key + '.tar'))
            image = docker_json('image', 'inspect', deployment.definition['services']['saas']['image'])[0]
            value = {'version': 1, 'installationId': record['InstallationId'], 'project': project,
                'uid': record['Uid'], 'gid': record['Gid'], 'sourceRevision': image['Config']['Labels']['org.opencontainers.image.revision'],
                'images': selected, 'archives': {name: digest(stage / name) for name in ['state.tar', *(key + '.tar' for key in VOLUMES)]}}
            config.write_json(stage / 'snapshot.json', value)
            verify_snapshot(stage)
            for path in stage.iterdir():
                with path.open('rb+') as stream: os.fsync(stream.fileno())
            directory = os.open(stage, os.O_RDONLY | os.O_DIRECTORY)
            try: os.fsync(directory)
            finally: os.close(directory)
            stage.rename(backup)
            directory = os.open(backup.parent, os.O_RDONLY | os.O_DIRECTORY)
            try: os.fsync(directory)
            finally: os.close(directory)
        finally:
            # Release partial snapshot space before attempting to restart the original services.
            if stage.exists(): shutil.rmtree(stage)
            if running: resume_services(deployment, running)
    finally:
        if stage.exists(): shutil.rmtree(stage)
    print('Consistent private data snapshot created; previously running services restarted: ' + str(backup), flush=True)


def restore_state(backup, state):
    value = verify_snapshot(backup)
    if state.exists(): raise ValueError('Restore requires a new state directory; existing data is never overwritten.')
    if value['uid'] != os.getuid() or value['gid'] != os.getgid(): raise ValueError('Restore under the original deployment UID/GID.')
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    if revision != value['sourceRevision']: raise ValueError('Check out the exact snapshot source revision before restoration.')
    for reference, image in value['images'].items():
        found = existing('image', reference)
        if found is None or found['Id'] != image: raise ValueError('Load the exact original runtime images listed in snapshot.json before restoration.')
    project = value['project']
    if existing('network', project + '_platform') or any(existing('volume', project + '_' + key) for key in VOLUMES):
        raise ValueError('Restore requires an empty Docker destination with no existing installation data/network.')
    state.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    stage = Path(tempfile.mkdtemp(prefix='.restore-', dir=state.parent))
    restored = stage / 'state'
    operation = uuid.uuid4().hex
    created = []
    complete = False
    try:
        unpack_state(backup / 'state.tar', restored)
        deployment = production.Deployment(restored)
        if deployment.record['InstallationId'] != value['installationId'] or deployment.definition['name'] != project:
            raise ValueError('Private state and data snapshots have different installation owners.')
        if images(deployment.definition) != value['images']: raise ValueError('Private state and runtime image identities differ.')
        inputs = restored / 'recovery-inputs'; inputs.mkdir(mode=0o700, exist_ok=True)
        plan = deployment.plan
        replacements = []
        for option, source in [('CertificateFile', 'tls-fullchain.pem'), ('PrivateKeyFile', 'tls-private.key'), ('RootCertificateFile', 'root-ca.pem')]:
            if plan['Tls'].get(option):
                shutil.copyfile(restored / 'secrets' / source, inputs / source)
                plan['Tls'][option] = str(inputs / source)
                replacements.append((plan['Tls'], option, source))
        for option, source in [('GoogleCredentialsFile', 'google-provisioning.json'), ('NotificationCredentialsFile', 'google-notifications.json')]:
            if plan.get(option):
                shutil.copyfile(restored / 'secrets' / source, inputs / source)
                plan[option] = str(inputs / source)
                replacements.append((plan, option, source))
        if plan['Providers']['Notifications'].get('Provider') == 'FcmApns':
            apns = plan['Providers']['Notifications']['Apns']
            source = 'apns-key.p8'
            shutil.copyfile(restored / 'secrets' / source, inputs / source)
            (inputs / source).chmod(0o600)
            apns['KeyFile'] = str(inputs / source)
            replacements.append((apns, 'KeyFile', source))
        # Validate credentials, certificates and original directory/key ownership before Docker writes.
        config.prepare(plan, restored, deployment.definition['services']['saas']['image'])
        config.write_json(restored / '.restore-operation.json', {'id': operation})
        for key in VOLUMES:
            name = project + '_' + key
            subprocess.run(['docker', 'volume', 'create', '--label', 'commerce.installation=' + value['installationId'],
                '--label', 'com.docker.compose.project=' + project, '--label', 'com.docker.compose.volume=' + key,
                '--label', 'commerce.restore.operation=' + operation, name], check=True, stdout=subprocess.DEVNULL)
            actual = existing('volume', name)
            if actual['Labels'].get('commerce.restore.operation') != operation:
                raise ValueError('Another operation created this destination; no data was adopted.')
            created.append(name)
            volume_tar(value['images'][deployment.definition['services']['postgres']['image']], name, source=backup / (key + '.tar'))
        for owner, option, source in replacements: owner[option] = str(state / 'recovery-inputs' / source)
        if state.exists(): raise ValueError('A destination appeared during restoration; no existing state is replaced.')
        restored.rename(state)
        config.prepare(plan, state, deployment.definition['services']['saas']['image'])
        (state / '.restore-operation.json').unlink()
        complete = True
    finally:
        if not complete:
            removed = True
            for name in created:
                actual = existing('volume', name)
                if actual and actual['Labels'].get('commerce.restore.operation') == operation:
                    # Docker refuses removal of a volume that any container has adopted.
                    result = subprocess.run(['docker', 'volume', 'rm', name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    removed = removed and result.returncode == 0
            marker = state / '.restore-operation.json'
            if removed and marker.is_file() and json.loads(marker.read_text()).get('id') == operation:
                shutil.rmtree(state)
        shutil.rmtree(stage)
    print('Private state and owned data restored with original keys; run the ordinary Production startup command.', flush=True)


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['backup', 'restore', 'verify'])
    parser.add_argument('--state', type=Path, default=ROOT / '.local/production')
    parser.add_argument('--backup', type=Path, required=True)
    args = parser.parse_args()
    state = private_path(args.state); backup = private_path(args.backup)
    if args.action == 'verify': verify_snapshot(backup); print('Private snapshot checksums and archive boundaries verified.'); return
    if platform.system() != 'Linux' or os.getuid() == 0: raise ValueError('Use a non-root Linux deployment operator with Docker access.')
    state.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    lock_path = state.parent / (state.name + '.lock')
    if lock_path.is_symlink(): raise ValueError('The deployment lock cannot be linked.')
    with lock_path.open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if args.action == 'backup': backup_state(state, backup)
        else: restore_state(backup, state)


if __name__ == '__main__':
    def interrupted(*_): raise KeyboardInterrupt
    signal.signal(signal.SIGTERM, interrupted)
    main()
