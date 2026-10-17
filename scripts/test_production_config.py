"""Verify actual generated Production settings, opt-in Android consent and persisted key/artifact boundaries."""
import copy
import json
import os
import shutil
import tarfile
from unittest.mock import patch
from pathlib import Path
import subprocess
import tempfile
import unittest

import production_config as config
import production_android
import production_backup as snapshot


class ProductionConfigTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        (config.ROOT / '.local').mkdir(exist_ok=True)
        cls.temporary = tempfile.TemporaryDirectory(prefix='production-settings-', dir=config.ROOT / '.local')
        cls.root = Path(cls.temporary.name)
        cls.certificate = cls.root / 'certificate.pem'; cls.key = cls.root / 'private.key'
        subprocess.run(['openssl', 'req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-days', '1', '-subj', '/CN=portal.example.test',
            '-addext', 'subjectAltName=DNS:portal.example.test,DNS:identity.example.test,DNS:*.shops.example.test,DNS:*.manage.example.test',
            '-keyout', str(cls.key), '-out', str(cls.certificate)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        cls.plan = json.loads((config.ROOT / 'infra/production/deployment.example.json').read_text())
        cls.plan.update(PortalHost='portal.example.test', IdentityHost='identity.example.test', StoreParentDomain='shops.example.test', AdminParentDomain='manage.example.test')
        cls.plan['Tls'] = {'CertificateFile': str(cls.certificate), 'PrivateKeyFile': str(cls.key)}
        cls.plan['Providers']['Domains']['WildcardConfigured'] = True
        cls.mobile = json.loads((config.ROOT / 'infra/production/android.example.json').read_text())['Providers']['Mobile']
        cls.mobile['AcceptAndroidSdkLicenses'] = True
        cls.mobile['Android'].update(AllowSigningKeyCreation=True, SharedArtifactsConfirmed=True)
        cls.google = json.loads((config.ROOT / 'infra/google/provisioning.example.json').read_text())['Provisioning']['Google']
        cls.google.update(AllowCloudWrites=True, DeploymentId=cls.plan['DeploymentId'])
        cls.apns_key = cls.root / 'apns.p8'
        subprocess.run(['openssl', 'genpkey', '-algorithm', 'EC', '-pkeyopt', 'ec_paramgen_curve:prime256v1',
                        '-out', str(cls.apns_key)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        cls.apns_key.chmod(0o600)

    @classmethod
    def tearDownClass(cls): cls.temporary.cleanup()

    def test_private_identity_route_preserves_public_issuer_and_admin_boundary(self):
        state = self.root / 'private-identity-state'
        original = config.prepare(self.plan, state, 'commerce-platform:fixture')
        services = json.loads((state / 'compose.json').read_text())['services']
        edge = services['edge']['networks']['platform']['ipv4_address']
        for role in ('saas', 'worker', 'commerce', 'admin', 'gateway'):
            self.assertEqual(services[role]['extra_hosts'], {self.plan['IdentityHost']: edge})
        saas = json.loads((state / 'config/saas.json').read_text())
        worker = json.loads((state / 'config/worker.json').read_text())
        self.assertEqual(saas['AuthConfiguration']['IdentityProviderUrl'], 'https://' + self.plan['IdentityHost'] + '/realms/commerce')
        self.assertEqual(worker['Provisioning']['Portable']['KeycloakAuthority'], 'https://' + self.plan['IdentityHost'])
        caddy = (state / 'config/Caddyfile').read_text()
        self.assertIn('remote_ip ' + self.plan.get('NetworkSubnet', '172.30.80.0/24'), caddy)
        self.assertIn('respond 404', caddy)
        self.assertEqual(config.prepare(self.plan, state, 'commerce-platform:fixture')['Credentials'], original['Credentials'])
        custom = copy.deepcopy(self.plan); custom['HttpsPort'] = 9443
        custom_state = self.root / 'custom-identity-port-state'
        config.prepare(custom, custom_state, 'commerce-platform:fixture')
        self.assertNotIn('extra_hosts', json.loads((custom_state / 'compose.json').read_text())['services']['worker'])

    def android_plan(self):
        plan = copy.deepcopy(self.plan)
        plan['Providers'].update(Mobile=copy.deepcopy(self.mobile), Google=copy.deepcopy(self.google))
        return plan

    def test_android_is_opt_in_and_all_required_consents_are_enforced(self):
        for section, field in [('Mobile', 'AcceptAndroidSdkLicenses'), ('Android', 'AllowSigningKeyCreation'), ('Android', 'SharedArtifactsConfirmed'), ('Google', 'AllowCloudWrites')]:
            with self.subTest(field=field):
                plan = self.android_plan()
                target = plan['Providers']['Mobile']['Android'] if section == 'Android' else plan['Providers'][section]
                target[field] = False
                with self.assertRaises(ValueError): config.validate(plan)
        self.assertEqual(config.validate(copy.deepcopy(self.plan))['Providers']['Mobile']['Provider'], 'Disabled')

    def test_enabling_android_preserves_original_credentials_and_wires_both_hosts(self):
        state = self.root / 'enabled-state'
        original = config.prepare(self.plan, state, 'commerce-platform:fixture')
        enabled = config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        self.assertEqual(enabled['MasterKey'], original['MasterKey'])
        self.assertEqual(enabled['Credentials'], original['Credentials'])
        replay = config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        self.assertEqual(enabled, replay)
        compose = json.loads((state / 'compose.json').read_text())
        self.assertEqual(compose['services']['worker']['image'], 'commerce-platform:fixture-android')
        self.assertTrue(all(item['image'] == 'commerce-platform:fixture' for name, item in compose['services'].items() if name in ('saas', 'gateway', 'commerce', 'admin', 'bootstrap')))
        for role in ('saas', 'worker'):
            settings = json.loads((state / 'config' / (role + '.json')).read_text())
            self.assertEqual(settings['Provisioning']['Mobile']['Provider'], 'AndroidAppDistribution')
        worker = json.loads((state / 'config/worker.json').read_text())['Provisioning']['Mobile']['Android']
        mounts = {item['target'] for item in compose['services']['worker']['volumes']}
        self.assertIn(worker['WorkingDirectory'], mounts); self.assertIn(worker['ArtifactDirectory'], mounts)
        self.assertIn('/var/lib/commerce/mobile-cache', mounts)
        self.assertEqual(worker['SourceDirectory'], '/app/mobile-source')
        for role in ('saas', 'worker', 'gateway', 'commerce', 'admin', 'bootstrap'):
            runtime = compose['services'][role]['tmpfs']
            self.assertTrue(any(item.startswith('/run/platform-runtime:') and 'mode=0700' in item for item in runtime))
        (state / 'mobile-artifacts').rmdir()
        with self.assertRaises(ValueError): config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        self.assertEqual((state / 'secrets/platform-master-key').read_text(), original['MasterKey'])

    def test_android_cache_tuning_is_private_and_survives_profile_reprepare(self):
        state = self.root / 'android-cache-state'
        original = config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        settings = state / 'mobile-cache/gradle/gradle.properties'
        self.assertEqual(settings.stat().st_mode & 0o777, 0o600)
        self.assertIn('org.gradle.jvmargs=-Xmx2G', settings.read_text())
        custom = 'org.gradle.jvmargs=-Xmx1536m\norg.gradle.workers.max=1\n'
        settings.write_text(custom)
        replay = config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        self.assertEqual(settings.read_text(), custom)
        self.assertEqual(original['MasterKey'], replay['MasterKey'])
        self.assertEqual(original['Credentials'], replay['Credentials'])
        settings.unlink(); external = self.root / 'operator-cache-settings'; external.write_text('must survive')
        settings.symlink_to(external)
        with self.assertRaisesRegex(ValueError, 'symbolic'): config.prepare(self.android_plan(), state, 'commerce-platform:fixture')
        self.assertEqual(external.read_text(), 'must survive')

    def combined_plan(self):
        plan = self.android_plan()
        plan['Providers']['Mobile'].update(Provider='AndroidIosAppDistribution', Ios={'Release': {
            'DevelopmentTeam': 'ABCDE12345', 'SigningCertificateSha256': 'a' * 64, 'ExpectedSourceHash': 'b' * 64, 'BuildNumber': 7}})
        return plan

    def test_combined_mobile_keeps_mac_credentials_out_of_linux_and_selects_the_real_android_worker(self):
        plan = self.combined_plan(); state = self.root / 'combined-state'
        config.validate(plan); original = config.prepare(plan, state, 'commerce-platform:fixture')
        replay = config.prepare(plan, state, 'commerce-platform:fixture')
        self.assertEqual(original['MasterKey'], replay['MasterKey']); self.assertEqual(original['Credentials'], replay['Credentials'])
        worker = json.loads((state / 'config/worker.json').read_text())['Provisioning']['Mobile']
        saas = json.loads((state / 'config/saas.json').read_text())['Provisioning']['Mobile']
        self.assertEqual(saas, {'Provider': 'AndroidIosAppDistribution'})
        self.assertEqual(worker['Ios'], plan['Providers']['Mobile']['Ios'])
        self.assertEqual(worker['Android']['SourceDirectory'], '/app/mobile-source')
        services = json.loads((state / 'compose.json').read_text())['services']
        self.assertEqual(services['worker']['image'], 'commerce-platform:fixture-android')
        self.assertIn('/var/lib/commerce/mobile-artifacts', {item['target'] for item in services['worker']['volumes']})
        self.assertNotIn('Worker', worker['Ios']); self.assertNotIn('KeyFile', json.dumps(worker)); self.assertNotIn('RequiredDeviceUdids', json.dumps(worker))

    def test_combined_mobile_requires_the_exact_public_binding_and_rejects_private_mac_inputs(self):
        for change in ({'DevelopmentTeam': ''}, {'ExpectedSourceHash': 'b' * 64 + '\n'}, {'SigningCertificateSha256': 'A' * 64},
                       {'BuildNumber': True}, {'BuildNumber': 0}, {'KeyFile': '/private/key.p8'}):
            plan = self.combined_plan(); plan['Providers']['Mobile']['Ios']['Release'].update(change)
            with self.subTest(fields=tuple(change)), self.assertRaises(ValueError): config.validate(plan)
        plan = self.combined_plan(); plan['Providers']['Mobile']['Ios']['Worker'] = {'AppleConfigFile': '/private/apple.json'}
        with self.assertRaises(ValueError): config.validate(plan)
        plan = self.combined_plan(); plan['Providers']['Mobile']['Android']['AllowSigningKeyCreation'] = False
        with self.assertRaises(ValueError): config.validate(plan)

    def apns_plan(self):
        plan = self.combined_plan()
        plan['Providers']['Notifications'] = {'Provider': 'FcmApns', 'Apns': {
            'Environment': 'Production', 'DevelopmentTeam': 'ABCDE12345', 'KeyId': 'KEYID12345',
            'KeyFile': str(self.apns_key), 'LifetimeSeconds': 3600}}
        return plan

    def test_apns_team_key_reaches_only_notification_hosts_and_replay_keeps_master(self):
        state = self.root / 'apns-state'; plan = self.apns_plan()
        original = config.prepare(self.plan, state, 'commerce-platform:fixture')
        enabled = config.prepare(plan, state, 'commerce-platform:fixture')
        self.assertEqual(original['MasterKey'], enabled['MasterKey'])
        self.assertEqual(original['Credentials'], enabled['Credentials'])
        self.assertEqual(enabled, config.prepare(plan, state, 'commerce-platform:fixture'))
        self.assertEqual(self.apns_key.read_bytes(), (state / 'secrets/apns-key.p8').read_bytes())
        self.assertEqual(0o600, (state / 'secrets/apns-key.p8').stat().st_mode & 0o777)
        services = json.loads((state / 'compose.json').read_text())['services']
        for role, service in services.items():
            mounts = [item for item in service.get('volumes', []) if isinstance(item, dict) and item.get('target') == '/run/secrets/apns-key.p8']
            self.assertEqual(len(mounts), int(role in ('commerce', 'admin')), role)
            if mounts: self.assertTrue(mounts[0]['read_only'])
        for file in (state / 'config').glob('*.json'):
            value = json.loads(file.read_text())
            if file.stem in ('commerce', 'admin'):
                self.assertEqual('/run/secrets/apns-key.p8', value['Notifications']['Apns']['KeyFile'])
            else:
                self.assertNotIn('KEYID12345', file.read_text())
                self.assertNotIn('Apns', value.get('Notifications', {}))
        worker = json.loads((state / 'config/worker.json').read_text())
        self.assertEqual('Apns', worker['Provisioning']['Google']['IosPushTransport'])
        self.assertEqual('ABCDE12345', worker['Provisioning']['Google']['IosDevelopmentTeam'])
        self.assertEqual({'Provider': 'Disabled'}, json.loads((state / 'config/installer.json').read_text())['Notifications'])

    def test_apns_rejects_invalid_config_and_team_or_transport_drift_before_rendering(self):
        for update in ({'Environment': 'Sandbox'}, {'DevelopmentTeam': None}, {'DevelopmentTeam': 1234567890},
                       {'DevelopmentTeam': 'ABCDE12345\n'}, {'KeyId': None}, {'KeyId': []}, {'KeyFile': None},
                       {'KeyFile': 'relative.p8'}, {'LifetimeSeconds': True}, {'LifetimeSeconds': -1},
                       {'LifetimeSeconds': 86401}, {'PrivateKey': 'inline-material'}):
            plan = self.apns_plan(); plan['Providers']['Notifications']['Apns'].update(update)
            with self.subTest(fields=tuple(update)), self.assertRaises(ValueError): config.validate(plan)
        for section, update in [('Google', {'Provider': 'Disabled'}), ('Google', {'IosPushTransport': 'Fcm'}),
                                ('Google', {'IosDevelopmentTeam': 'OTHER12345'})]:
            plan = self.apns_plan(); plan['Providers'][section].update(update)
            with self.subTest(fields=tuple(update)), self.assertRaises(ValueError): config.validate(plan)
        plan = self.apns_plan(); plan['Providers']['Mobile']['Ios']['Release']['DevelopmentTeam'] = 'OTHER12345'
        with self.assertRaises(ValueError): config.validate(plan)
        for value in (None, [], 'FcmApns'):
            plan = self.apns_plan(); plan['Providers']['Notifications'] = value
            with self.subTest(value=value), self.assertRaises(ValueError): config.validate(plan)

    def test_apns_refuses_shared_readable_linked_or_empty_key_inputs(self):
        file = self.root / 'unsafe-apns.p8'; file.write_bytes(self.apns_key.read_bytes()); file.chmod(0o640)
        plan = self.apns_plan(); plan['Providers']['Notifications']['Apns']['KeyFile'] = str(file)
        with self.assertRaises(ValueError): config.validate(plan)
        file.chmod(0o600); file.write_bytes(b'')
        with self.assertRaises(ValueError): config.validate(plan)
        file.write_bytes(b'x' * 8193)
        with self.assertRaises(ValueError): config.validate(plan)
        file.unlink(); file.symlink_to(self.apns_key)
        with self.assertRaises(ValueError): config.validate(plan)
        directory = self.root / 'linked-key-parent'; directory.symlink_to(self.root, target_is_directory=True)
        plan['Providers']['Notifications']['Apns']['KeyFile'] = str(directory / self.apns_key.name)
        with self.assertRaises(ValueError): config.validate(plan)

    def test_apns_restore_uses_backed_up_key_after_original_input_disappears(self):
        state = self.root / 'restore-apns-source'; plan = self.apns_plan()
        missing = self.root / 'original-apns-input.p8'; shutil.copyfile(self.apns_key, missing); missing.chmod(0o600)
        plan['Providers']['Notifications']['Apns']['KeyFile'] = str(missing)
        original = config.prepare(plan, state, 'commerce-platform:fixture')
        definition = json.loads((state / 'compose.json').read_text())
        images = {service['image']: 'sha256:' + 'c' * 64 for service in definition['services'].values()}
        backup = self.root / 'apns-snapshot'; backup.mkdir(mode=0o700)
        snapshot.save_state(state, backup / 'state.tar')
        for name in snapshot.VOLUMES:
            file = backup / (name + '.tar')
            with tarfile.open(file, 'w'): pass
            file.chmod(0o600)
        revision = 'b' * 40
        config.write_json(backup / 'snapshot.json', {'version': 1, 'installationId': original['InstallationId'],
            'project': definition['name'], 'sourceRevision': revision, 'uid': os.getuid(), 'gid': os.getgid(),
            'images': images, 'archives': {file.name: snapshot.digest(file) for file in backup.glob('*.tar')}})
        missing.unlink()
        volumes = {}
        def inspect(kind, name):
            if kind == 'image': return {'Id': images[name]}
            return volumes.get(name) if kind == 'volume' else None
        actual_run = subprocess.run; actual_output = subprocess.check_output
        def run(command, *args, **kwargs):
            if command[:3] == ['docker', 'volume', 'create']:
                labels = dict(command[index + 1].split('=', 1) for index, value in enumerate(command) if value == '--label')
                volumes[command[-1]] = {'Labels': labels}
                return subprocess.CompletedProcess(command, 0)
            if command[0] == 'docker': raise AssertionError('Unexpected Docker mutation')
            return actual_run(command, *args, **kwargs)
        def output(command, *args, **kwargs):
            return revision if command[:3] == ['git', 'rev-parse', 'HEAD'] else actual_output(command, *args, **kwargs)
        destination = self.root / 'apns-restored'
        with patch.object(snapshot, 'existing', side_effect=inspect), patch.object(snapshot, 'images', return_value=images), \
             patch.object(snapshot.subprocess, 'run', side_effect=run), patch.object(snapshot.subprocess, 'check_output', side_effect=output), \
             patch.object(snapshot, 'volume_tar') as restore_volumes:
            snapshot.restore_state(backup, destination)
        self.assertEqual(len(snapshot.VOLUMES), restore_volumes.call_count)
        restored = json.loads((destination / 'deployment.json').read_text())
        key = Path(restored['Providers']['Notifications']['Apns']['KeyFile'])
        self.assertEqual(destination / 'recovery-inputs/apns-key.p8', key)
        self.assertEqual(self.apns_key.read_bytes(), key.read_bytes())
        self.assertEqual(0o600, key.stat().st_mode & 0o777)
        self.assertEqual(original['MasterKey'], json.loads((destination / 'installation.json').read_text())['MasterKey'])
        self.assertFalse(missing.exists())

    def test_organization_admin_owner_policy_is_explicit_and_reaches_only_the_provisioning_worker(self):
        plan = self.android_plan()
        plan['Providers']['Google']['GrantOrganizationAdminUsersProjectOwner'] = True
        state = self.root / 'organization-owner-state'
        config.prepare(plan, state, 'commerce-platform:fixture')
        worker = json.loads((state / 'config/worker.json').read_text())
        self.assertTrue(worker['Provisioning']['Google']['GrantOrganizationAdminUsersProjectOwner'])
        for role in ('saas', 'gateway', 'commerce', 'admin', 'bootstrap'):
            self.assertNotIn('GrantOrganizationAdminUsersProjectOwner', (state / 'config' / (role + '.json')).read_text())
        self.assertFalse(self.google['GrantOrganizationAdminUsersProjectOwner'])

    def test_google_administration_and_notification_credentials_have_separate_mounts(self):
        plan = copy.deepcopy(self.plan)
        for option in ('GoogleCredentialsFile', 'NotificationCredentialsFile'):
            path = self.root / (option + '.json'); path.write_text('{"fixture":"synthetic-private-adc"}')
            plan[option] = str(path)
        state = self.root / 'credential-state'; config.prepare(plan, state, 'commerce-platform:fixture')
        services = json.loads((state / 'compose.json').read_text())['services']
        for role in ('worker', 'commerce', 'admin', 'saas', 'gateway', 'bootstrap'):
            targets = {item['target'] for item in services[role]['volumes']}
            self.assertEqual('/run/secrets/google-provisioning.json' in targets, role == 'worker')
            self.assertEqual('/run/secrets/google-notifications.json' in targets, role in ('commerce', 'admin'))
        for name in ('google-provisioning.json', 'google-notifications.json'):
            self.assertEqual((state / 'secrets' / name).stat().st_mode & 0o777, 0o600)


    def test_payment_merchant_requires_real_plan_and_secrets_only_reach_saas(self):
        plan = copy.deepcopy(self.plan)
        plan['Providers']['Payments'] = {'Provider': 'Iyzico', 'Iyzico': {
            'ApiKey': 'synthetic-merchant-key', 'SecretKey': 'synthetic-merchant-secret', 'IsSandbox': True}}
        with self.assertRaises(ValueError): config.validate(plan)
        plan['TrialPlan']['Code'] = '22222222-2222-2222-2222-222222222222'
        state = self.root / 'payment-state'; original = config.prepare(plan, state, 'commerce-platform:fixture')
        saas = json.loads((state / 'config/saas.json').read_text())
        self.assertEqual({k: v for k, v in saas['Payments'].items() if k != 'ExclusiveSessionConfirmed'}, plan['Providers']['Payments'])
        self.assertTrue(saas['Payments']['ExclusiveSessionConfirmed'])
        self.assertEqual(saas['CardProtection']['Provider'], 'Platform')
        self.assertEqual((state / 'config/saas.json').stat().st_mode & 0o777, 0o600)
        for file in (state / 'config').iterdir():
            if file.name != 'saas.json': self.assertNotIn('synthetic-merchant-', file.read_text())
        self.assertNotIn('synthetic-merchant-', (state / 'compose.json').read_text())
        replay = config.prepare(plan, state, 'commerce-platform:fixture')
        self.assertEqual(original['MasterKey'], replay['MasterKey']); self.assertEqual(original['Credentials'], replay['Credentials'])
        for price in (True, float('nan'), float('inf'), 0, -1, '299'):
            with self.subTest(price_type=type(price).__name__):
                changed = copy.deepcopy(plan); changed['TrialPlan']['Price'] = price
                with self.assertRaises(ValueError): config.validate(changed)
        for mutation in ({'IsSandbox': 'false'}, {'ApiKey': ''}, {'SecretKey': None}):
            with self.subTest(mutation=tuple(mutation)):
                changed = copy.deepcopy(plan); changed['Providers']['Payments']['Iyzico'].update(mutation)
                with self.assertRaises(ValueError): config.validate(changed)

    def test_identity_registration_requires_explicit_smtp_and_keeps_original_secrets(self):
        for identity in ({'RegistrationAllowed': 'false'}, {'RegistrationAllowed': True},
                         {'RegistrationAllowed': True, 'Smtp': {'host': 'smtp.example.test', 'port': 587, 'from': 'accounts@example.test'}}):
            with self.subTest(identity=identity):
                plan = copy.deepcopy(self.plan); plan['Identity'] = identity
                with self.assertRaises(ValueError): config.validate(plan)
        plan = copy.deepcopy(self.plan)
        plan.update(json.loads((config.ROOT / 'infra/production/identity.example.json').read_text()))
        state = self.root / 'identity-state'
        original = config.prepare(self.plan, state, 'commerce-platform:fixture')
        updated = config.prepare(plan, state, 'commerce-platform:fixture')
        self.assertEqual(original['MasterKey'], updated['MasterKey']); self.assertEqual(original['Credentials'], updated['Credentials'])
        realm = json.loads((state / 'realm/commerce-realm.json').read_text())
        self.assertTrue(realm['registrationAllowed'] and realm['verifyEmail'])
        self.assertEqual(realm['smtpServer'], plan['Identity']['Smtp'])
        self.assertEqual(realm['attributes']['platform-installation-id'], original['InstallationId'])

    def test_container_probe_cleanup_removes_ephemeral_keys_without_following_links(self):
        private = self.root / 'container-probe'; private.mkdir()
        probe = private / 'flutter-release-synthetic'; probe.mkdir()
        outside = self.root / 'keep-outside'; outside.mkdir(); (outside / 'keep').write_text('keep')
        (probe / 'fixture.p12').write_bytes(b'synthetic-key')
        (probe / 'signing.properties').write_text('synthetic-private-signing')
        (probe / 'workspace').mkdir(); (probe / 'workspace/key').write_text('synthetic-key')
        (probe / 'linked-directory').symlink_to(outside, target_is_directory=True)
        (probe / 'fixture.log').write_text('synthetic diagnostics')
        production_android.cleanup_probe(private)
        self.assertEqual({path.name for path in probe.iterdir()}, {'fixture.log'})
        self.assertEqual((outside / 'keep').read_text(), 'keep')


if __name__ == '__main__': unittest.main()
