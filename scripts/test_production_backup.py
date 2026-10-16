import io
import json
import os
from pathlib import Path
import tarfile
import tempfile
import unittest
from unittest.mock import Mock, patch

import production_backup as snapshot
import production_config as config


class ProductionBackupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='commerce-backup-test-')
        self.root = Path(self.temp.name)
        self.backup = self.root / 'snapshot'
        self.backup.mkdir(mode=0o700)
        for name in ['state.tar', *(key + '.tar' for key in snapshot.VOLUMES)]:
            self.archive(name, [('private-file', b'synthetic private data')])
        self.metadata = {'version': 1, 'installationId': 'a' * 32, 'project': 'commerce-prod-test',
            'sourceRevision': 'b' * 40, 'uid': os.getuid(), 'gid': os.getgid(),
            'images': {'commerce-platform:test': 'sha256:' + 'c' * 64}}
        self.manifest()

    def tearDown(self):
        self.temp.cleanup()

    def archive(self, filename, entries):
        path = self.backup / filename
        with tarfile.open(path, 'w') as archive:
            for name, data in entries:
                item = tarfile.TarInfo(name); item.size = len(data); item.mode = 0o600
                archive.addfile(item, io.BytesIO(data))
        path.chmod(0o600)

    def manifest(self):
        self.metadata['archives'] = {name: snapshot.digest(self.backup / name)
            for name in ['state.tar', *(key + '.tar' for key in snapshot.VOLUMES)]}
        config.write_json(self.backup / 'snapshot.json', self.metadata)

    def test_complete_private_snapshot_verifies_and_corruption_refuses(self):
        self.assertEqual('a' * 32, snapshot.verify_snapshot(self.backup)['installationId'])
        with (self.backup / 'mongo-data.tar').open('ab') as output: output.write(b'corruption')
        with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)

    def test_traversal_absolute_paths_duplicate_entries_and_links_refuse(self):
        for entries in [[('../outside', b'data')], [('/outside', b'data')], [('.', b'data')], [('same', b'one'), ('same', b'two')]]:
            with self.subTest(entries=entries):
                self.archive('state.tar', entries); self.manifest()
                with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)
        with tarfile.open(self.backup / 'state.tar', 'w') as archive:
            item = tarfile.TarInfo('linked'); item.type = tarfile.SYMTYPE; item.linkname = '/outside'
            archive.addfile(item)
        (self.backup / 'state.tar').chmod(0o600); self.manifest()
        with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)
        self.assertFalse((self.root / 'outside').exists())

    def test_metadata_cannot_redirect_resource_names(self):
        self.metadata['project'] = 'foreign,target=/host'
        self.manifest()
        with patch.object(snapshot, 'docker_json') as docker:
            with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)
            docker.assert_not_called()

    def test_shared_readable_manifest_and_linked_archives_refuse(self):
        (self.backup / 'snapshot.json').chmod(0o640)
        with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)
        (self.backup / 'snapshot.json').chmod(0o600)
        outside = self.root / 'outside.tar'
        (self.backup / 'state.tar').rename(outside)
        (self.backup / 'state.tar').symlink_to(outside)
        with self.assertRaises(ValueError): snapshot.verify_snapshot(self.backup)

    def test_restore_never_overwrites_existing_private_state(self):
        state = self.root / 'original'; state.mkdir(mode=0o700)
        marker = state / 'preserve'; marker.write_bytes(b'original data')
        with patch.object(snapshot, 'docker_json') as docker, patch.object(snapshot, 'existing') as inspect:
            with self.assertRaises(ValueError): snapshot.restore_state(self.backup, state)
            docker.assert_not_called(); inspect.assert_not_called()
        self.assertEqual(b'original data', marker.read_bytes())

    def test_restore_refuses_foreign_docker_data_before_writes(self):
        state = self.root / 'destination'
        def inspect(kind, name):
            if kind == 'image': return {'Id': self.metadata['images'][name]}
            if kind == 'volume': return {'Labels': {'commerce.installation': 'foreign'}}
            return None
        with patch.object(snapshot.subprocess, 'check_output', return_value=self.metadata['sourceRevision']), patch.object(snapshot, 'existing', side_effect=inspect), patch.object(snapshot.subprocess, 'run') as mutate:
            with self.assertRaises(ValueError): snapshot.restore_state(self.backup, state)
            mutate.assert_not_called()
        self.assertFalse(state.exists())

    def test_restore_refuses_changed_image_tags_before_writes(self):
        state = self.root / 'destination'
        with patch.object(snapshot.subprocess, 'check_output', return_value=self.metadata['sourceRevision']), patch.object(snapshot, 'existing', return_value={'Id': 'sha256:' + 'd' * 64}), patch.object(snapshot.subprocess, 'run') as mutate:
            with self.assertRaises(ValueError): snapshot.restore_state(self.backup, state)
            mutate.assert_not_called()
        self.assertFalse(state.exists())

    def test_backup_refuses_a_destination_inside_its_source(self):
        state = self.root / 'source'; state.mkdir(mode=0o700)
        with patch.object(snapshot.production, 'Deployment') as deployment:
            with self.assertRaises(ValueError): snapshot.backup_state(state, state / 'snapshot')
            deployment.assert_not_called()

    def test_resume_uses_portable_start_and_preserves_the_original_running_subset(self):
        complete = {'postgres', 'mongo', 'redis', 'keycloak', 'edge', 'saas', 'commerce', 'admin', 'gateway', 'worker'}
        for running in [{'postgres', 'mongo', 'keycloak', 'worker'}, complete]:
            with self.subTest(running=running):
                deployment = Mock(); active = set(); started = []
                def start(action, *services):
                    self.assertEqual('start', action)
                    self.assertFalse(any(name.startswith('--') for name in services))
                    if 'keycloak' in services: self.assertIn('postgres', active)
                    if 'worker' in services: self.assertIn('keycloak', active)
                    active.update(services); started.extend(services)
                def wait(label, predicate, seconds): self.assertTrue(predicate())
                deployment.run.side_effect = start; deployment.wait.side_effect = wait
                deployment.verify_identity.return_value = True
                with patch.object(snapshot, 'statuses', side_effect=lambda _: [
                    {'Service': name, 'State': 'running', 'Health': 'healthy'} for name in active]):
                    snapshot.resume_services(deployment, running)
                self.assertEqual(running, set(started)); self.assertEqual(len(running), len(started))
                self.assertEqual(1, deployment.verify_identity.call_count)
                self.assertEqual(int(running == complete), deployment.verify_hosts.call_count)

    def test_private_keys_and_committed_artifacts_roundtrip_but_caches_are_empty(self):
        state = self.root / 'source'; state.mkdir(mode=0o700)
        values = {'secrets/platform-master-key': b'synthetic master', 'saas-cookie-keys/key.xml': b'synthetic cookie key',
            'mobile-artifacts/tenant/release.apk': b'synthetic artifact transport only',
            'mobile-cache/rebuildable': b'cache', 'mobile-work/temporary-signing-file': b'temporary', 'logs/runtime.log': b'private log'}
        for name, value in values.items():
            path = state / name; path.parent.mkdir(parents=True, exist_ok=True, mode=0o700); path.write_bytes(value)
        archive = self.root / 'state.tar'; snapshot.save_state(state, archive)
        restored = self.root / 'restored'; snapshot.unpack_state(archive, restored)
        for name in ['secrets/platform-master-key', 'saas-cookie-keys/key.xml', 'mobile-artifacts/tenant/release.apk']:
            self.assertEqual(values[name], (restored / name).read_bytes())
            self.assertEqual(0o600, (restored / name).stat().st_mode & 0o777)
        for name in snapshot.CACHES: self.assertEqual([], list((restored / name).iterdir()))


if __name__ == '__main__': unittest.main()
