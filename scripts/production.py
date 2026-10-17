#!/usr/bin/env python3
"""Prepare, start, verify or stop this installation's Linux Docker Compose deployment."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import platform
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import ssl

import production_config as config
import production_image
import production_android

ROOT = config.ROOT
ROLES = ('owner', 'saas', 'worker', 'reader', 'keycloak_db')


class Deployment:
    def __init__(self, state, overrides=()):
        self.state = state
        self.plan = json.loads((state / 'deployment.json').read_text())
        self.record = json.loads((state / 'installation.json').read_text())
        self.definition = json.loads((state / 'compose.json').read_text())
        self.prefix = ['docker', 'compose', '--project-name', self.definition['name'], '--file', str(state / 'compose.json')]
        for path in overrides: self.prefix += ['--file', str(Path(path).resolve())]
        self.log_path = state / 'logs/deployment.log'

    def run(self, *arguments, input=None, capture=False, timeout=600):
        with self.log_path.open('a') as log:
            return subprocess.run([*self.prefix, *arguments], input=input, text=True, check=True, timeout=timeout,
                                  stdout=subprocess.PIPE if capture else log, stderr=log)

    def sql(self, script, database='postgres'):
        return self.run('exec', '-T', 'postgres', 'psql', '-U', 'postgres', '-d', database, '-v', 'ON_ERROR_STOP=1', '-At',
                        input=script, capture=True).stdout.strip()

    def owned_resources(self):
        project = self.definition['name']; owner = self.record['InstallationId']
        for kind, suffixes in (('volume', ['postgres-data', 'mongo-data', 'redis-data']), ('network', ['platform'])):
            for suffix in suffixes:
                name = project + '_' + suffix
                found = subprocess.run(['docker', kind, 'inspect', name], capture_output=True, text=True)
                if found.returncode == 0:
                    data = json.loads(found.stdout)[0]
                    if data.get('Labels', {}).get('commerce.installation') != owner or data.get('Labels', {}).get('com.docker.compose.project') != project:
                        raise ValueError('Refusing to adopt Docker data/network without this installation ownership record.')
                elif 'no such' not in found.stderr.lower() and 'not found' not in found.stderr.lower():
                    raise RuntimeError('Docker resource inspection failed; no resource was adopted.')

    def stop_task_worker(self):
        # Disabled optional services disappear from Compose; stop only this installation's old task host.
        ids = subprocess.check_output(['docker', 'ps', '-aq', '--no-trunc',
            '--filter', 'label=commerce.installation=' + self.record['InstallationId'],
            '--filter', 'label=com.docker.compose.project=' + self.definition['name'],
            '--filter', 'label=com.docker.compose.service=task-worker'], text=True).split()
        if any(not re.fullmatch('[a-f0-9]{64}', value) for value in ids):
            raise ValueError('Unexpected owned task container identity.')
        if ids: subprocess.run(['docker', 'stop', '--time', '30', *ids], check=True, stdout=subprocess.DEVNULL)

    def wait(self, label, predicate, seconds=180):
        deadline = time.monotonic() + seconds
        while time.monotonic() < deadline:
            try:
                if predicate(): return
            except (OSError, urllib.error.HTTPError, ValueError): pass
            time.sleep(1)
        raise RuntimeError(label + ' did not reach readiness; inspect private deployment logs.')

    def initialize_postgres(self):
        c = self.record['Credentials']; installation = self.record['InstallationId']
        # Our volume label was checked before server startup. This marker fences SQL replays too.
        self.sql('''CREATE SCHEMA IF NOT EXISTS platform_deployment;
CREATE TABLE IF NOT EXISTS platform_deployment.installation (singleton boolean PRIMARY KEY CHECK(singleton), id text NOT NULL, complete boolean NOT NULL);
''')
        existing = self.sql('SELECT id FROM platform_deployment.installation WHERE singleton;')
        if existing and existing != installation: raise ValueError('The PostgreSQL installation is owned by another deployment.')
        if not existing:
            self.sql("INSERT INTO platform_deployment.installation VALUES(true,'" + installation + "',false);")
        completed = self.sql('SELECT complete FROM platform_deployment.installation WHERE singleton;') == 't'
        for role in ROLES:
            username = 'platform_' + role
            present = self.sql("SELECT 1 FROM pg_roles WHERE rolname='" + username + "';") == '1'
            if not present:
                if completed: raise ValueError('An original database role is missing; restore a consistent backup.')
                self.sql('CREATE ROLE ' + username + " LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD '" + c[role] + "';")
            if self.sql("SELECT rolsuper OR rolcreatedb OR rolcreaterole OR rolreplication OR rolbypassrls FROM pg_roles WHERE rolname='" + username + "';") != 'f':
                raise ValueError('An application database role has unexpected administrative rights.')
        for database, owner in (('platform_security', 'platform_owner'), ('platform_saas', 'platform_owner'), ('platform_identity', 'platform_keycloak_db')):
            actual = self.sql("SELECT pg_get_userbyid(datdba) FROM pg_database WHERE datname='" + database + "';")
            if not actual:
                if completed: raise ValueError('An original application database is missing; restore a consistent backup.')
                self.sql('CREATE DATABASE ' + database + ' OWNER ' + owner + ';')
            elif actual != owner: raise ValueError('Refusing to adopt a database with a different owner.')
            self.sql('REVOKE CONNECT ON DATABASE ' + database + ' FROM PUBLIC; GRANT CONNECT ON DATABASE ' + database + ' TO ' +
                     (owner if database == 'platform_identity' else 'platform_owner,platform_saas,platform_worker,platform_reader') + ';')
        self.sql('UPDATE platform_deployment.installation SET complete=true WHERE singleton;')

    def grant_runtime(self):
        self.sql('''REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public,platform_bootstrap TO platform_saas;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO platform_saas;
REVOKE INSERT,UPDATE,DELETE ON public."__EFMigrationsHistory" FROM platform_saas;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA public TO platform_saas;
GRANT SELECT ON platform_bootstrap.saas_state TO platform_saas;
''', 'platform_saas')
        self.sql((ROOT / 'infra/production/runtime-security-grants.sql').read_text(), 'platform_security')

    def initialize_mongo(self):
        c = self.record['Credentials']
        settings = {'password': c['mongo'], 'owner': self.record['InstallationId'], 'context': c['mongo_context'], 'worker': c['mongo_worker']}
        script = 'const s=' + json.dumps(settings) + ';\n' + r'''
const a=db.getSiblingDB('admin'); if(!a.auth('platform_root',s.password))throw Error('Mongo bootstrap authentication failed');
const d=db.getSiblingDB('platform_runtime');
function user(database,name,password,roles){
 const old=database.getUser(name);
 if(old){if(old.customData?.platformInstallation!==s.owner||JSON.stringify(old.roles.map(r=>r.db+':'+r.role).sort())!==JSON.stringify(roles.map(r=>r.db+':'+r.role).sort()))throw Error('Foreign or changed Mongo user');}
 else database.createUser({user:name,pwd:password,roles,customData:{platformInstallation:s.owner}});
}
if(d.getCollectionNames().length)throw Error('The unseeded runtime context must remain empty');
user(d,'runtime_context',s.context,[{role:'read',db:'platform_runtime'}]);
user(a,'tenant_provisioner',s.worker,[{role:'readWriteAnyDatabase',db:'admin'},{role:'userAdminAnyDatabase',db:'admin'}]);
'''
        self.run('exec', '-T', 'mongo', 'mongosh', '--quiet', '--file', '/dev/stdin', input=script)

    def identity_token(self, administrative=False):
        ip = self.definition['services']['keycloak']['networks']['platform']['ipv4_address']
        c = self.record['Credentials']
        fields = {'grant_type': 'password', 'client_id': 'admin-cli', 'username': 'platform-admin', 'password': c['keycloak_admin']} if administrative else {
            'grant_type': 'client_credentials', 'client_id': 'tenant-provisioner', 'client_secret': c['provisioner']}
        url = 'http://' + ip + ':8080/realms/' + ('master' if administrative else 'commerce') + '/protocol/openid-connect/token'
        request = urllib.request.Request(url, urllib.parse.urlencode(fields).encode())
        # Direct operator access stays on the private Docker bridge; it is never published.
        with urllib.request.build_opener(urllib.request.ProxyHandler({})).open(request, timeout=10) as response:
            return json.load(response)['access_token']

    def verify_identity(self):
        self.identity_token()
        return True

    def reconcile_identity(self):
        # Startup import skips existing realms. Apply only the explicitly configured identity policy.
        token = self.identity_token(administrative=True)
        ip = self.definition['services']['keycloak']['networks']['platform']['ipv4_address']
        origin = 'http://' + ip + ':8080/admin/realms/commerce'
        direct = urllib.request.build_opener(urllib.request.ProxyHandler({}))
        def request(path='', body=None):
            value = None if body is None else json.dumps(body).encode()
            req = urllib.request.Request(origin + path, value, {'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json'},
                                         method='GET' if body is None else 'PUT')
            with direct.open(req, timeout=15) as response:
                data = response.read()
                return json.loads(data) if data else None
        realm = request()
        attributes = dict(realm.get('attributes') or {})
        owner = attributes.get('platform-installation-id')
        if realm.get('realm') != 'commerce' or not realm.get('enabled') or owner not in (None, self.record['InstallationId']):
            raise ValueError('The identity realm does not belong to this installation.')
        # Older owned installations have no realm marker. Both original private clients must still match.
        for name, secret in (('saas-manager', 'saas_client'), ('tenant-provisioner', 'provisioner')):
            clients = request('/clients?clientId=' + name)
            if len(clients) != 1 or clients[0].get('clientId') != name or clients[0].get('publicClient') or not clients[0].get('enabled'):
                raise ValueError('The original private identity client policy changed; repair explicitly.')
            saved = request('/clients/' + urllib.parse.quote(clients[0]['id'], safe='') + '/client-secret')
            if saved.get('value') != self.record['Credentials'][secret]:
                raise ValueError('The original identity client credential changed; refusing automatic replacement.')
        attributes['platform-installation-id'] = self.record['InstallationId']
        identity = self.plan.get('Identity', {})
        wanted = {'attributes': attributes, 'verifyEmail': True, 'registrationAllowed': identity.get('RegistrationAllowed', False),
                  'smtpServer': identity.get('Smtp', {})}
        # Admin representations can mask SMTP passwords; write the explicit private input, never a returned mask.
        visible = lambda value: {key: item for key, item in value.items() if key != 'password'}
        if any(realm.get(key) != value for key, value in wanted.items() if key != 'smtpServer') or visible(realm.get('smtpServer') or {}) != visible(wanted['smtpServer']) or 'password' in wanted['smtpServer']:
            request(body=wanted)
        actual = request()
        if any(actual.get(key) != value for key, value in wanted.items() if key != 'smtpServer') or visible(actual.get('smtpServer') or {}) != visible(wanted['smtpServer']):
            raise ValueError('The configured identity registration/email policy was not applied.')
        print('PASS: Owned Keycloak identity registration/email settings applied without replacing clients, users or credentials.', flush=True)

    def verify_hosts(self):
        roles = ['saas', 'commerce', 'admin', 'gateway', 'worker']
        if 'task-worker' in self.definition['services']: roles.append('task-worker')
        for role in roles:
            def ready(role=role):
                status = self.run('ps', '--format', 'json', role, capture=True).stdout.strip()
                entries = json.loads(status) if status.startswith('[') else [json.loads(line) for line in status.splitlines() if line]
                if not entries or any(item['State'] != 'running' for item in entries): return False
                log = self.run('logs', '--no-color', '--tail', '150', role, capture=True).stdout
                return 'Hosting environment: Production' in log and 'Application started' in log
            self.wait(role, ready)
        context = ssl.create_default_context(cafile=str(self.state / 'secrets/root-ca.pem') if self.plan['Tls'].get('RootCertificateFile') else None)
        port = '' if self.plan['HttpsPort'] == 443 else ':' + str(self.plan['HttpsPort'])
        def page(host, path, expected):
            try:
                with urllib.request.urlopen('https://' + host + port + path, context=context, timeout=15) as response:
                    return response.status == expected
            except urllib.error.HTTPError as error: return error.code == expected
        self.wait('public SaaS HTTPS', lambda: page(self.plan['PortalHost'], '/register', 200))
        self.wait('public identity HTTPS', lambda: page(self.plan['IdentityHost'], '/realms/commerce/.well-known/openid-configuration', 200))
        if not page('unknown-tenant.' + self.plan['StoreParentDomain'], '/_platform/ready', 404):
            raise RuntimeError('The public gateway did not refuse an unknown tenant.')
        print('PASS: Production SaaS, identity and empty tenant hosts are ready through validated HTTPS; unknown tenants are refused.', flush=True)

    def up(self, no_build=False):
        if platform.system() != 'Linux' or os.getuid() == 0: raise ValueError('Run Production startup as a non-root Linux deployment operator with Docker access.')
        self.owned_resources()
        if not self.plan['Providers'].get('TenantTasks', {}).get('Enabled'): self.stop_task_worker()
        image = self.definition['services']['saas']['image']
        expected = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
        found = subprocess.run(['docker', 'image', 'inspect', image], capture_output=True, text=True)
        if found.returncode:
            if no_build: raise ValueError('The explicitly selected Production image is missing.')
            architecture = 'linux/arm64' if platform.machine() in ('aarch64', 'arm64') else 'linux/amd64'
            production_image.build(image, architecture, os.getuid(), os.getgid())
            found = subprocess.run(['docker', 'image', 'inspect', image], capture_output=True, text=True, check=True)
        metadata = json.loads(found.stdout)[0]['Config']
        if metadata['User'] != str(os.getuid()) + ':' + str(os.getgid()) or metadata.get('Labels', {}).get('org.opencontainers.image.revision') != expected:
            raise ValueError('Build the committed source image for the current deployment account before startup.')
        worker_image = self.definition['services']['worker']['image']
        if worker_image != image:
            if platform.machine() not in ('x86_64', 'AMD64'):
                raise ValueError('The packaged Android build worker currently requires Linux amd64; run it on a dedicated compatible host.')
            mobile_image = subprocess.run(['docker', 'image', 'inspect', worker_image], capture_output=True)
            if mobile_image.returncode:
                if no_build: raise ValueError('The explicitly selected Android provisioning image is missing.')
                production_android.build(worker_image, image, self.plan['Providers']['Mobile']['AcceptAndroidSdkLicenses'])
            production_android.require_image(worker_image, True)
        keycloak = subprocess.run(['docker', 'image', 'inspect', 'commerce-keycloak:26.8.0'], capture_output=True)
        if keycloak.returncode:
            definition = subprocess.check_output(['git', 'show', expected + ':infra/production/Keycloak.Dockerfile'], cwd=ROOT)
            with self.log_path.open('a') as log:
                subprocess.run(['docker', 'build', '--tag', 'commerce-keycloak:26.8.0', '-'], input=definition, stdout=log, stderr=subprocess.STDOUT, check=True)
        self.run('config', '--quiet')
        self.run('up', '-d', '--wait', 'postgres', 'mongo', 'redis')
        self.initialize_postgres(); self.initialize_mongo()
        self.run('--profile', 'initialize', 'run', '--rm', '--no-deps', 'bootstrap')
        self.grant_runtime()
        self.run('up', '-d', 'keycloak')
        self.wait('scoped Keycloak client authentication', self.verify_identity, 240)
        self.reconcile_identity()
        applications = ['commerce', 'admin', 'saas', 'gateway', 'edge', 'worker']
        if 'task-worker' in self.definition['services']: applications.append('task-worker')
        self.run('up', '-d', '--force-recreate', *applications)
        self.verify_hosts()
        print('Deployment ready. Private state and operator credentials: ' + str(self.state), flush=True)


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['prepare', 'up', 'verify', 'stop'])
    parser.add_argument('--config', type=Path)
    parser.add_argument('--state', type=Path, default=ROOT / '.local/production')
    parser.add_argument('--image')
    parser.add_argument('--no-build', action='store_true')
    parser.add_argument('--compose-override', action='append', default=[])
    args = parser.parse_args(); state = Path(os.path.abspath(args.state))
    for path in (state, *state.parents):
        if path.is_symlink(): raise ValueError('Private deployment state/lock paths cannot contain symbolic links.')
    # Lock beside the state; lock creation must not make a new state appear nonempty.
    state.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    lock_path = state.parent / (state.name + '.lock')
    with lock_path.open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if args.action in ('prepare', 'up'):
            plan_path = args.config or state / 'deployment.json'
            plan = json.loads(plan_path.read_text())
            revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
            config.prepare(plan, state, args.image or 'commerce-platform:' + revision[:12])
        deployment = Deployment(state, args.compose_override)
        if args.action == 'prepare':
            deployment.run('config', '--quiet'); print('Private Production configuration prepared; no infrastructure was started.', flush=True)
        elif args.action == 'up': deployment.up(args.no_build)
        elif args.action == 'verify': deployment.verify_identity(); deployment.verify_hosts()
        elif args.action == 'stop':
            deployment.stop_task_worker(); deployment.run('stop')
            print('Only this Compose installation stopped; databases, keys and files retained.', flush=True)


if __name__ == '__main__':
    try: main()
    except ValueError as error:
        print('Configuration refused: ' + str(error), file=sys.stderr); raise SystemExit(1)
    except Exception as error:
        print('Deployment failed (' + type(error).__name__ + '); inspect the private state/logs/deployment.log. Existing data and keys were retained.', file=sys.stderr)
        raise SystemExit(1)
