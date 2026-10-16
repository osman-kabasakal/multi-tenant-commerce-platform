#!/usr/bin/env python3
"""Fresh Linux Compose rollout, actual SaaS enrollment, tenant readiness and restart with isolated synthetic HTTPS."""
import argparse
import http.cookiejar
import http.server
import json
import os
from pathlib import Path
from html.parser import HTMLParser
import secrets
import select
import shutil
import socket
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid

import production
import production_config
from portable_saas_enrollment import enroll, verify, browser, api
from smoke_onboarding import check
from fixture_identity_mail import IdentityMail

ROOT = production.ROOT


class HiddenFields(HTMLParser):
    def __init__(self): super().__init__(); self.values = {}
    def handle_starttag(self, tag, attributes):
        attributes = dict(attributes)
        if tag == 'input' and attributes.get('type') == 'hidden' and attributes.get('name'):
            self.values[attributes['name']] = attributes.get('value', '')


def page(opener, url, data=None):
    headers = {'Content-Type': 'application/x-www-form-urlencoded'} if data is not None else {}
    try: response = opener.open(urllib.request.Request(url, data, headers), timeout=30)
    except urllib.error.HTTPError as error: response = error
    with response: return response.code, response.headers, response.read().decode()


def tenant_pages(opener, publication, tenant):
    code, headers, body = page(opener, publication['storeUrl'] + '/_platform/ready')
    check(code == 200 and json.loads(body)['tenantId'] == tenant and not headers.get('x-store-token'),
          'The exact Compose tenant serves authenticated public HTTPS readiness without exposing its service token')
    code, _, body = page(opener, publication['storeUrl'] + '/')
    check(code == 200 and '<html' in body.lower(), 'The real Compose tenant storefront renders through validated public HTTPS')


def tenant_login(proxy, ca, publication, account, password):
    jar = http.cookiejar.CookieJar(); opener = browser(proxy, ca, jar, redirect=False)
    code, headers, _ = page(opener, publication['adminUrl'])
    origin = publication['adminUrl'].rsplit('/Admin', 1)[0]
    location = urllib.parse.urljoin(publication['adminUrl'], headers.get('Location', ''))
    check(code == 302 and location.startswith(origin + '/'), 'Compose administration redirects to its own HTTPS login')
    code, _, body = page(opener, location); check(code == 200, 'Compose owner login page renders')
    form = HiddenFields(); form.feed(body)
    fields = dict(form.values, Email=account['email'], Password=password, RememberMe='false')
    code, headers, _ = page(opener, origin + '/admin/login', urllib.parse.urlencode(fields).encode())
    check(code in (302, 303) and 'login' not in headers.get('Location', '').lower(), 'The actual provisioned owner password authenticates in Compose administration')
    code, _, body = page(opener, publication['adminUrl'])
    check(code == 200 and 'logout' in body.lower(), 'The authenticated Compose tenant dashboard renders')
    check(any(cookie.secure and cookie.domain == urllib.parse.urlsplit(origin).hostname for cookie in jar), 'Compose administration cookies remain Secure and scoped to this tenant host')
    return opener


def identity_admin_api(deployment, path, value=None):
    # Master-realm access tokens are short-lived; never retain one across provisioning or restart.
    token = deployment.identity_token(administrative=True)
    ip = deployment.definition['services']['keycloak']['networks']['platform']['ipv4_address']
    request = urllib.request.Request('http://' + ip + ':8080/admin/realms/commerce' + path,
        None if value is None else json.dumps(value).encode(), {'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json'})
    direct = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    with direct.open(request, timeout=15) as response:
        payload = response.read()
        return json.loads(payload) if payload else None


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__); parser.add_argument('--image', default='commerce-platform:ci'); parser.add_argument('--browser', action='store_true', help='Also exercise real Angular enrollment and preserved browser cookies with Firefox'); args = parser.parse_args()
    if args.browser:
        if not sys.platform.startswith('linux') or not shutil.which('node') or not shutil.which('certutil'):
            raise RuntimeError('Browser acceptance requires Linux, Node.js and libnss3-tools; see docs/VALIDATION.md.')
        subprocess.run(['node', '-e', "require('playwright')"], cwd=ROOT / 'tests/Browser.Acceptance', check=True, capture_output=True)
    identity_id = uuid.uuid4().hex
    root = ROOT / '.local' / ('production-compose-' + identity_id[:10]); root.mkdir(parents=True, mode=0o700)
    state = root / 'state'; log_path = root / 'fixture.log'
    server = None; thread = None; deployment = None; browser_process = None; mail = None; mail_thread = None
    with log_path.open('w') as log:
        try:
            for command in (
                ['openssl', 'req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-days', '2', '-subj', '/CN=Compose fixture CA',
                 '-addext', 'basicConstraints=critical,CA:TRUE', '-addext', 'keyUsage=critical,keyCertSign,cRLSign', '-keyout', str(root / 'ca.key'), '-out', str(root / 'ca.pem')],
                ['openssl', 'req', '-newkey', 'rsa:2048', '-nodes', '-subj', '/CN=portal.example.test', '-keyout', str(root / 'tls.key'), '-out', str(root / 'tls.csr')],
            ): subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
            (root / 'tls.ext').write_text('subjectKeyIdentifier=hash\nauthorityKeyIdentifier=keyid,issuer\nbasicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:portal.example.test,DNS:identity.example.test,DNS:*.shops.example.test,DNS:*.manage.example.test\n')
            subprocess.run(['openssl', 'x509', '-req', '-in', str(root / 'tls.csr'), '-CA', str(root / 'ca.pem'), '-CAkey', str(root / 'ca.key'),
                            '-CAcreateserial', '-days', '1', '-extfile', str(root / 'tls.ext'), '-out', str(root / 'tls.pem')], stdout=log, stderr=subprocess.STDOUT, check=True)
            plan = json.loads((ROOT / 'infra/production/deployment.example.json').read_text())
            plan.update(DeploymentId='compose-' + identity_id[:12], PortalHost='portal.example.test', IdentityHost='identity.example.test',
                        StoreParentDomain='shops.example.test', AdminParentDomain='manage.example.test', NetworkSubnet='172.30.81.0/24',
                        ListenAddress='127.0.0.1', HttpPort=19480, HttpsPort=19443)
            plan['Tls'] = {'CertificateFile': str(root / 'tls.pem'), 'PrivateKeyFile': str(root / 'tls.key'), 'RootCertificateFile': str(root / 'ca.pem')}
            plan['TrialPlan']['Id'] = str(uuid.uuid4()); plan['Providers']['Domains']['WildcardConfigured'] = True
            if args.browser:
                plan['Identity'] = {'RegistrationAllowed': False, 'Smtp': {'host': '172.30.81.1', 'port': '25',
                    'from': 'no-reply@example.test', 'fromDisplayName': 'Compose Fixture', 'auth': 'false', 'ssl': 'false', 'starttls': 'false'}}
            plan_path = root / 'plan.json'; production_config.write_json(plan_path, plan)
            command = [sys.executable, str(ROOT / 'scripts/production.py'), 'prepare', '--config', str(plan_path), '--state', str(state), '--image', args.image]
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
            original = (state / 'installation.json').read_bytes(); master = (state / 'secrets/platform-master-key').read_bytes()
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
            check(original == (state / 'installation.json').read_bytes() and master == (state / 'secrets/platform-master-key').read_bytes(),
                  'Repeated Compose preparation preserves original credentials, identity and master key')
            deployment = production.Deployment(state)
            deployment.owned_resources(); deployment.run('create', 'postgres', 'mongo', 'redis')
            gateway = '172.30.81.1'
            class Connect(http.server.BaseHTTPRequestHandler):
                def log_message(self, *_): pass
                def do_CONNECT(self):
                    destination = urllib.parse.urlsplit('//' + self.path); host = destination.hostname or ''
                    if destination.port != 19443 or not (host in ('portal.example.test', 'identity.example.test') or
                        any(host.endswith('.' + parent) for parent in ('shops.example.test', 'manage.example.test'))):
                        self.send_error(403); return
                    with socket.create_connection(('127.0.0.1', 19443), timeout=15) as target:
                        self.send_response(200, 'Connection established'); self.end_headers(); self.close_connection = True
                        peers = (self.connection, target)
                        while True:
                            readable, _, _ = select.select(peers, [], [], 30)
                            if not readable: return
                            for source in readable:
                                try:
                                    data = source.recv(65536)
                                    if not data: return
                                    (target if source is self.connection else self.connection).sendall(data)
                                except (ConnectionError, TimeoutError): return
            server = http.server.ThreadingHTTPServer((gateway, 0), Connect); server.daemon_threads = True
            thread = threading.Thread(target=server.serve_forever, daemon=True); thread.start()
            proxy = 'http://' + gateway + ':' + str(server.server_port)
            if args.browser:
                mail = IdentityMail((gateway, 0), root / 'identity-verification.json', 'browser-owner@example.test')
                mail_thread = threading.Thread(target=mail.serve_forever, daemon=True); mail_thread.start()
                plan['Identity']['Smtp']['port'] = str(mail.server_address[1]); production_config.write_json(plan_path, plan)
            override = root / 'proxy.json'
            production_config.write_json(override, {'services': {role: {'environment': {'HTTPS_PROXY': proxy, 'https_proxy': proxy,
                'NO_PROXY': 'localhost,127.0.0.1,postgres,mongo,redis,keycloak,commerce,admin,gateway,saas',
                'no_proxy': 'localhost,127.0.0.1,postgres,mongo,redis,keycloak,commerce,admin,gateway,saas'}} for role in ('worker', 'commerce', 'admin', 'gateway', 'saas')}})
            environment = dict(os.environ, HTTPS_PROXY=proxy, https_proxy=proxy,
                               NO_PROXY='localhost,127.0.0.1,172.30.81.23', no_proxy='localhost,127.0.0.1,172.30.81.23')
            up = [sys.executable, str(ROOT / 'scripts/production.py'), 'up', '--config', str(plan_path), '--state', str(state),
                  '--image', args.image, '--no-build', '--compose-override', str(override)]
            subprocess.run(up, stdout=log, stderr=subprocess.STDOUT, env=environment, check=True, timeout=600)
            check(True, 'The ordinary one-command Production rollout starts every real container from fresh owned data')
            deployment = production.Deployment(state, [override])
            def admin_api(path, value=None):
                return identity_admin_api(deployment, path, value)
            accounts = []
            for index in range(2):
                account = {'username': 'compose-owner-' + str(index), 'email': 'owner' + str(index) + '@example.test', 'password': secrets.token_urlsafe(24)}
                admin_api('/users', dict(username=account['username'], email=account['email'], firstName='Compose', lastName='Owner',
                    emailVerified=True, enabled=True, credentials=[{'type': 'password', 'value': account['password'], 'temporary': False}]))
                user = admin_api('/users?username=' + urllib.parse.quote(account['username']))[0]
                role = admin_api('/roles/business_owner')
                admin_api('/users/' + user['id'] + '/role-mappings/realm', [role])
                accounts.append(account)
            if args.browser:
                accounts.append({'username': 'browser-owner', 'email': 'browser-owner@example.test', 'password': secrets.token_urlsafe(24)})
            portal = 'https://portal.example.test:19443'
            identity = {'root': root / 'ca.pem', 'authority': 'https://identity.example.test:19443/realms/commerce', 'accounts': accounts[:2]}
            tenants = [uuid.uuid4().hex, uuid.uuid4().hex]; password = 'Compose-İstanbul-' + secrets.token_urlsafe(24)
            sessions = enroll(portal, identity, proxy, tenants, password)
            deadline = time.monotonic() + 180
            while time.monotonic() < deadline:
                jobs = [api(session[0], portal, session[2]['statusUrl'])[1] for session in sessions]
                if all(job and job['state'] == 'Succeeded' for job in jobs): break
                if any(job and job['state'] == 'Failed' for job in jobs): raise RuntimeError('A real Compose provisioning job failed; inspect private worker logs.')
                time.sleep(1)
            else: raise RuntimeError('Compose tenant provisioning did not finish.')
            verify(portal, sessions)
            tenant_sessions = []
            for account, tenant, (owner, _, result, _) in zip(accounts, tenants, sessions):
                job = api(owner, portal, result['statusUrl'])[1]
                publication = job['steps']['publication']['resources']
                opener = browser(proxy, root / 'ca.pem', redirect=False)
                tenant_pages(opener, publication, tenant)
                administration = tenant_login(proxy, root / 'ca.pem', publication, account, password)
                tenant_sessions.append((administration, publication, tenant))
            if args.browser:
                check(admin_api('')['registrationAllowed'] is False, 'The fresh owned identity realm initially keeps public registration disabled')
                plan['Identity']['RegistrationAllowed'] = True; production_config.write_json(plan_path, plan)
                subprocess.run(up, stdout=log, stderr=subprocess.STDOUT, env=environment, check=True, timeout=600)
                realm = admin_api('')
                check(realm['registrationAllowed'] and realm['verifyEmail'] and realm['smtpServer']['port'] == str(mail.server_address[1]),
                    'The ordinary startup command enables configured registration/email on an existing realm while preserving its users and tenant clients')
                browser_config = root / 'browser.json'
                browser_result = root / 'browser-result.json'
                production_config.write_json(browser_config, {
                    'portal': portal, 'identity': 'https://identity.example.test:19443', 'proxy': proxy,
                    'ca': str(root / 'ca.pem'), 'profile': str(root / 'browser-profile'), 'result': str(browser_result),
                    'screenshots': str(ROOT / 'output/playwright' / identity_id), 'resume': str(root / 'browser-resume.json'),
                    'account': accounts[2], 'adminPassword': password, 'selfRegistration': True,
                    'verificationMail': str(root / 'identity-verification.json'),
                    'business': {'name': 'browser-' + identity_id[:10], 'legalCompanyName': 'Browser Fixture Company',
                        'ownerName': 'Browser Owner', 'taxNumber': '9999999903', 'taxOffice': 'Fixture Office',
                        'phone': '5551234567', 'address': 'Browser Fixture Street 10', 'city': 'Fixture City',
                        'district': 'Fixture District', 'postalCode': '00000'},
                })
                browser_command = ['node', str(ROOT / 'tests/Browser.Acceptance/trial.cjs')]
                browser_process = subprocess.Popen(browser_command + [str(browser_config)], stdout=log, stderr=subprocess.STDOUT)
                deadline = time.monotonic() + 300
                while not browser_result.exists():
                    if browser_process.poll() is not None or time.monotonic() >= deadline:
                        raise RuntimeError('Real Angular browser enrollment did not reach its ready screen; inspect the private browser stage log.')
                    time.sleep(.5)
                log.flush()
                result = json.loads(browser_result.read_text())
                new_identity = admin_api('/users?username=' + urllib.parse.quote(accounts[2]['username']))
                check(len(new_identity) == 1 and new_identity[0]['emailVerified'] and new_identity[0]['email'] == accounts[2]['email'],
                    'The actual self-registered Keycloak owner verified its email through the received SMTP message')
                check(len(result['tenantId']) == 32 and result['tenantId'] not in tenants,
                    'Real Firefox submitted the Angular business form and observed a third, distinct tenant ready screen')
                publication = {name: result[name] for name in ('storeUrl', 'adminUrl')}
                tenant_pages(browser(proxy, root / 'ca.pem', redirect=False), publication, result['tenantId'])
                administration = tenant_login(proxy, root / 'ca.pem', publication, accounts[2], password)
                tenant_sessions.append((administration, publication, result['tenantId']))
            # Re-run the same real command; configuration/keys/data/identity must survive and hosts restart.
            subprocess.run(up, stdout=log, stderr=subprocess.STDOUT, env=environment, check=True, timeout=600)
            check(master == (state / 'secrets/platform-master-key').read_bytes(), 'Production restart preserves the original deployment encryption key')
            verify(portal, sessions)
            for administration, publication, tenant in tenant_sessions:
                tenant_pages(administration, publication, tenant)
                code, _, body = page(administration, publication['adminUrl'])
                check(code == 200 and 'logout' in body.lower(), 'The actual tenant administration session survives the full Compose restart')
            if args.browser:
                production_config.write_json(root / 'browser-resume.json', {'ready': True})
                if browser_process.wait(timeout=240) != 0:
                    raise RuntimeError('The real browser session did not survive Compose restart; inspect the private browser stage log.')
                log.flush()
                check(True, 'The actual Firefox owner session and Angular tenant success screen survive the complete Compose restart')
            check(deployment.sql("SELECT bool_and(NOT rolsuper AND NOT rolcreatedb AND NOT rolcreaterole AND NOT rolbypassrls) FROM pg_roles WHERE rolname IN ('platform_saas','platform_worker','platform_reader');") == 't',
                  'SaaS, worker and runtime secret reader have no database/server administration privileges')
            write = "SELECT has_schema_privilege('platform_saas','public','CREATE') OR has_schema_privilege('platform_worker','public','CREATE');"
            check(deployment.sql(write, 'platform_security') == 'f', 'Runtime database accounts cannot create application schemas')
            print('Complete real Compose rollout, two-owner enrollment and preserved-state restart checks passed.', flush=True)
        finally:
            if browser_process and browser_process.poll() is None:
                browser_process.terminate()
                try: browser_process.wait(timeout=15)
                except subprocess.TimeoutExpired: browser_process.kill(); browser_process.wait(timeout=10)
            if deployment:
                try:
                    deployment.run('logs', '--no-color', '--tail', '100', capture=False)
                finally:
                    deployment.run('down', '--volumes', '--remove-orphans')
                if deployment.log_path.exists(): shutil.copyfile(deployment.log_path, root / 'deployment.log')
            if mail: mail.shutdown(); mail.server_close()
            if mail_thread: mail_thread.join(timeout=5)
            if server: server.shutdown(); server.server_close()
            if thread: thread.join(timeout=5)
            for path in root.iterdir():
                if path.is_dir(): shutil.rmtree(path)
                elif path.name not in ('fixture.log', 'deployment.log', 'browser-diagnostics.json'): path.unlink()
            print('Only this synthetic Compose installation, owned volumes/network and disposable private files were removed.', flush=True)


if __name__ == '__main__':
    try: main()
    except Exception as error:
        status = ' HTTP ' + str(error.code) if isinstance(error, urllib.error.HTTPError) else ''
        print('Compose fixture failed (' + type(error).__name__ + status + '); inspect its private fixture/deployment logs.', file=sys.stderr)
        raise SystemExit(1)
