"""Verify actual generated Production settings, opt-in Android consent and persisted key/artifact boundaries."""
import copy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

import production_config as config
import production_android


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

    @classmethod
    def tearDownClass(cls): cls.temporary.cleanup()

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
