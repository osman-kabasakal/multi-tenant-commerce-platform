"""Identity policy ownership fences; the full Compose fixture separately exercises real Keycloak."""
import copy
import io
import json
import unittest
from unittest.mock import patch

from production import Deployment


class IdentityPolicyTests(unittest.TestCase):
    def fixture(self):
        deployment = object.__new__(Deployment)
        deployment.record = {'InstallationId': '1' * 32, 'Credentials': {'saas_client': 'synthetic-saas-credential', 'provisioner': 'synthetic-provisioner-credential'}}
        deployment.plan = {'Identity': {'RegistrationAllowed': True, 'Smtp': {'host': 'smtp.example.test', 'port': '587', 'from': 'accounts@example.test', 'password': 'synthetic-smtp-input'}}}
        deployment.definition = {'services': {'keycloak': {'networks': {'platform': {'ipv4_address': '172.30.80.23'}}}}}
        deployment.identity_token = lambda administrative=False: 'synthetic-administrative-token'
        realm = {'realm': 'commerce', 'enabled': True, 'attributes': {'keep-existing': 'true'}, 'registrationAllowed': False, 'verifyEmail': False, 'smtpServer': {}}
        clients = [{'id': name, 'clientId': name, 'enabled': True, 'publicClient': False} for name in ('saas-manager', 'tenant-provisioner')]
        writes = []
        def open_request(request, timeout):
            path = request.full_url.split('/admin/realms/commerce', 1)[1]
            if request.method == 'PUT':
                value = json.loads(request.data)
                writes.append(value); realm.update(copy.deepcopy(value)); result = None
            elif path.startswith('/clients?clientId='):
                result = [client for client in clients if client['clientId'] == path.split('=', 1)[1]]
            elif path.endswith('/client-secret'):
                key = 'saas_client' if '/saas-manager/' in path else 'provisioner'
                result = {'value': deployment.record['Credentials'][key]}
            else:
                self.assertEqual(path, '')
                result = copy.deepcopy(realm)
                if result.get('smtpServer', {}).get('password'): result['smtpServer']['password'] = '**********'
            return io.BytesIO(b'' if result is None else json.dumps(result).encode())
        class Direct:
            open = staticmethod(open_request)
        return deployment, realm, clients, writes, Direct()

    def test_legacy_owned_realm_is_reconciled_with_explicit_smtp_input_and_retained_attributes(self):
        deployment, realm, _, writes, direct = self.fixture()
        with patch('urllib.request.build_opener', return_value=direct): deployment.reconcile_identity()
        self.assertEqual(len(writes), 1)
        self.assertTrue(realm['registrationAllowed'] and realm['verifyEmail'])
        self.assertEqual(realm['attributes'], {'keep-existing': 'true', 'platform-installation-id': deployment.record['InstallationId']})
        self.assertEqual(writes[0]['smtpServer']['password'], deployment.plan['Identity']['Smtp']['password'])
        self.assertEqual(set(writes[0]), {'attributes', 'verifyEmail', 'registrationAllowed', 'smtpServer'})

    def test_foreign_marker_or_changed_private_client_refuses_before_any_write(self):
        for change in ('foreign-realm', 'public-client', 'disabled-client', 'changed-secret'):
            with self.subTest(change=change):
                deployment, realm, clients, writes, direct = self.fixture()
                if change == 'foreign-realm': realm['attributes']['platform-installation-id'] = '2' * 32
                elif change == 'public-client': clients[0]['publicClient'] = True
                elif change == 'disabled-client': clients[0]['enabled'] = False
                else:
                    original = direct.open
                    def changed(request, timeout):
                        return io.BytesIO(b'{"value":"foreign-synthetic-credential"}') if request.full_url.endswith('/client-secret') else original(request, timeout)
                    direct.open = changed
                with patch('urllib.request.build_opener', return_value=direct):
                    with self.assertRaises(ValueError): deployment.reconcile_identity()
                self.assertEqual(writes, [])

    def test_default_policy_disables_public_registration_without_replacing_clients_or_users(self):
        deployment, realm, _, writes, direct = self.fixture()
        deployment.plan = {}; realm.update(registrationAllowed=True, verifyEmail=True)
        with patch('urllib.request.build_opener', return_value=direct): deployment.reconcile_identity()
        self.assertFalse(realm['registrationAllowed']); self.assertTrue(realm['verifyEmail'])
        self.assertEqual(realm['smtpServer'], {})
        self.assertNotIn('clients', writes[0]); self.assertNotIn('users', writes[0])
        with patch('urllib.request.build_opener', return_value=direct): deployment.reconcile_identity()
        self.assertEqual(len(writes), 1)


if __name__ == '__main__': unittest.main()
