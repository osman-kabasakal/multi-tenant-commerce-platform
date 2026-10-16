#!/usr/bin/env python3
"""Private, stable configuration for the single-host Linux Compose deployment."""
import base64
import copy
import hashlib
import ipaddress
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import subprocess
import tempfile
import uuid

ROOT = Path(__file__).resolve().parents[1]
SECRET_NAMES = ('postgres', 'mongo', 'owner', 'saas', 'worker', 'reader', 'keycloak_db',
                'keycloak_admin', 'provisioner', 'saas_client', 'mongo_worker', 'mongo_context',
                'redis', 'guest', 'frontend', 'backend')


def write_json(path, value):
    with tempfile.NamedTemporaryFile(mode='w', prefix='.atomic-', dir=path.parent, delete=False) as temporary:
        temporary.write(json.dumps(value, indent=2) + '\n'); temporary.flush(); os.fsync(temporary.fileno())
    os.replace(temporary.name, path)
    path.chmod(0o600)


def validate(plan):
    if not re.fullmatch(r'[a-z][a-z0-9-]{2,39}', plan['DeploymentId']):
        raise ValueError('Choose a 3-40 character lowercase deployment id.')
    names = [plan[key] for key in ('PortalHost', 'IdentityHost', 'StoreParentDomain', 'AdminParentDomain')]
    for host in names:
        if not isinstance(host, str) or len(host) > 200 or host != host.lower() or not re.fullmatch(r'(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z][a-z0-9-]{1,62}', host) or host.endswith('.localhost'):
            raise ValueError('Choose explicit lowercase DNS names without a port, wildcard or URL.')
    if len(set(names)) != 4 or any(a.endswith('.' + b) for a in names for b in names if a != b):
        raise ValueError('Portal, identity and tenant parent domains must be distinct and must not overlap.')
    subnet = ipaddress.ip_network(plan.get('NetworkSubnet', '172.30.80.0/24'))
    if subnet.version != 4 or subnet.prefixlen != 24 or not subnet.is_private:
        raise ValueError('Select a dedicated private IPv4 /24 Docker subnet.')
    plan['NetworkSubnet'] = str(subnet)
    if ipaddress.ip_address(plan.get('ListenAddress', '0.0.0.0')).version != 4: raise ValueError('Use an explicit IPv4 ingress bind address.')
    for key, default in (('HttpPort', 80), ('HttpsPort', 443)):
        port = plan.get(key, default)
        if type(port) is not int or not 1 <= port <= 65535: raise ValueError('Use valid public HTTP/HTTPS ports.')
        plan[key] = port
    if plan['HttpPort'] == plan['HttpsPort']: raise ValueError('HTTP and HTTPS ports must differ.')
    providers = plan['Providers']
    domains = providers['Domains']
    if domains.get('Provider') == 'Wildcard':
        if domains.get('WildcardConfigured') is not True: raise ValueError('Confirm wildcard DNS only after configuring the four public domain targets.')
    elif domains.get('Provider') != 'Cloudflare' or domains.get('AllowCloudWrites') is not True:
        raise ValueError('Explicitly configure Wildcard DNS or authorized Cloudflare provisioning.')
    if providers.get('Google', {}).get('Provider') not in ('Disabled', 'Google'):
        raise ValueError('Explicitly select Disabled or Google provisioning.')
    if providers.get('ReadinessEmail', {}).get('Provider') not in ('Disabled', 'Smtp'):
        raise ValueError('Explicitly select Disabled or Smtp readiness delivery.')
    if providers.get('Notifications', {}).get('Provider') not in ('Disabled', 'Fcm'):
        raise ValueError('Explicitly select Disabled or Fcm notifications.')
    trial = plan['TrialPlan']
    if uuid.UUID(trial['Id']).int == 0: raise ValueError('Select the stable public trial plan GUID.')
    # The owner CLI performs the complete policy/schema validation before hosts start.
    tls = plan['Tls']
    for key in ('CertificateFile', 'PrivateKeyFile'):
        path = Path(tls[key])
        if not path.is_absolute() or not path.is_file(): raise ValueError('Supply absolute existing TLS certificate/key paths.')
    certificate = ['openssl', 'x509', '-in', tls['CertificateFile'], '-noout']
    subprocess.run(certificate + ['-checkend', '0'], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for host in names[:2] + ['tenant-probe.' + names[2], 'tenant-probe.' + names[3]]:
        subprocess.run(certificate + ['-checkhost', host], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    cert_key = subprocess.check_output(['openssl', 'x509', '-in', tls['CertificateFile'], '-pubkey', '-noout'], stderr=subprocess.DEVNULL)
    actual_key = subprocess.check_output(['openssl', 'pkey', '-in', tls['PrivateKeyFile'], '-pubout'], stderr=subprocess.DEVNULL)
    if cert_key.strip() != actual_key.strip(): raise ValueError('The TLS certificate does not match its private key.')
    if tls.get('RootCertificateFile') and not Path(tls['RootCertificateFile']).is_file(): raise ValueError('The explicit CA file is missing.')
    return plan


def fingerprint(plan):
    return hashlib.sha256(json.dumps({key: plan.get(key) for key in
        ('DeploymentId', 'PortalHost', 'IdentityHost', 'StoreParentDomain', 'AdminParentDomain', 'NetworkSubnet', 'HttpsPort', 'TrialPlan')}, sort_keys=True).encode()).hexdigest()


def prepare(plan, state, image):
    plan = validate(copy.deepcopy(plan))
    for path in (state, *state.parents):
        if path.is_symlink(): raise ValueError('The private deployment state cannot contain symbolic links.')
    if state == ROOT or ROOT in state.parents and ROOT / '.local' not in state.parents:
        raise ValueError('Keep private deployment state outside Git or under the ignored .local directory.')
    if not state.exists(): state.mkdir(parents=True, mode=0o700)
    if state.stat().st_uid != os.getuid() or state.stat().st_mode & 0o077:
        raise ValueError('The private state directory must belong to this operator and have mode 0700.')
    manifest = state / 'installation.json'
    if not manifest.exists():
        if any(state.iterdir()): raise ValueError('Refusing to adopt a nonempty directory without its installation record.')
        credentials = {key: secrets.token_hex(32) for key in SECRET_NAMES}
        key = base64.b64encode(secrets.token_bytes(32)).decode()
        # A complete initial record is written first; interrupted rendering can resume without key rotation.
        write_json(manifest, {'Version': 1, 'InstallationId': uuid.uuid4().hex, 'Fingerprint': fingerprint(plan),
                              'Uid': os.getuid(), 'Gid': os.getgid(), 'MasterKey': key, 'Credentials': credentials})
    if manifest.is_symlink() or manifest.stat().st_mode & 0o077: raise ValueError('The installation record must be a private regular file.')
    record = json.loads(manifest.read_text())
    if record['Version'] != 1 or record['Fingerprint'] != fingerprint(plan) or record['Uid'] != os.getuid() or record['Gid'] != os.getgid():
        raise ValueError('Restore the original deployment inputs/account; changing targets is an explicit migration.')
    if len(base64.b64decode(record['MasterKey'], validate=True)) != 32 or any(not re.fullmatch('[a-f0-9]{64}', record['Credentials'][key]) for key in SECRET_NAMES):
        raise ValueError('The original deployment key/credentials are damaged; restore their backup.')
    if not re.fullmatch('[a-f0-9]{32}', record['InstallationId']): raise ValueError('Invalid installation ownership record.')
    for directory in ('config', 'secrets', 'logs', 'realm', 'keycloak-data', 'onboarding', 'tenants', 'routes', 'readiness-outbox', 'mobile', 'saas-files', 'saas-cookie-keys', 'media-images', 'media-files'):
        path = state / directory
        if path.is_symlink(): raise ValueError('Private deployment directories cannot be symbolic links.')
        if record.get('Rendered') and not path.is_dir(): raise ValueError('An original private deployment directory is missing; restore a consistent backup.')
        path.mkdir(exist_ok=True, mode=0o700)
    c = record['Credentials']
    for path in (state / 'config').iterdir():
        if path.is_symlink(): raise ValueError('Private generated configuration cannot be a symbolic link.')
    for path in (state / 'secrets').iterdir():
        if path.is_symlink(): raise ValueError('Private generated secrets cannot be symbolic links.')
    master = state / 'secrets/platform-master-key'
    if master.exists() and master.read_text().strip() != record['MasterKey']: raise ValueError('The original shared encryption key was changed.')
    master.write_text(record['MasterKey']); master.chmod(0o600)
    for name in ('postgres', 'mongo', 'keycloak_db', 'keycloak_admin'):
        (state / 'secrets' / name).write_text(c[name]); (state / 'secrets' / name).chmod(0o600)
    for name, source in (('tls-fullchain.pem', plan['Tls']['CertificateFile']), ('tls-private.key', plan['Tls']['PrivateKeyFile'])):
        shutil.copyfile(source, state / 'secrets' / name); (state / 'secrets' / name).chmod(0o600)
    ca = plan['Tls'].get('RootCertificateFile')
    if ca: shutil.copyfile(ca, state / 'secrets/root-ca.pem'); (state / 'secrets/root-ca.pem').chmod(0o600)
    for option, filename in (('GoogleCredentialsFile', 'google-provisioning.json'), ('NotificationCredentialsFile', 'google-notifications.json')):
        if plan.get(option):
            source = Path(plan[option])
            if not source.is_absolute() or not source.is_file(): raise ValueError('Supply an absolute existing private Google credential file.')
            shutil.copyfile(source, state / 'secrets' / filename); (state / 'secrets' / filename).chmod(0o600)
    render(plan, state, record, image)
    write_json(state / 'deployment.json', plan)
    record['Rendered'] = True
    write_json(manifest, record)
    return record


def render(p, state, record, image):
    c = record['Credentials']; ident = p['DeploymentId']; port = '' if p['HttpsPort'] == 443 else ':' + str(p['HttpsPort'])
    origin = lambda host: 'https://' + host + port
    portal = origin(p['PortalHost']); identity = origin(p['IdentityHost']); store = origin(p['StoreParentDomain']); admin = origin(p['AdminParentDomain'])
    connection = lambda database, user: 'Host=postgres;Database=' + database + ';Username=platform_' + user + ';Password=' + c[user]
    security = lambda user, reader=False: {'Provider': 'AesGcm', 'InitializeSchema': False, 'ReadOnly': reader,
        'ConnectionString': connection('platform_security', user), 'AesGcm': {'MasterKeyFile': '/run/secrets/platform-master-key'}}
    proxy = lambda peers: {'Enabled': True, 'KnownProxies': peers, 'ForwardLimit': 1}
    subnet = ipaddress.ip_network(p.get('NetworkSubnet', '172.30.80.0/24'))
    ip = lambda number: str(subnet.network_address + number)
    ca = '/run/secrets/root-ca.pem' if p['Tls'].get('RootCertificateFile') else None
    base = {'LocalDemo': {'Enabled': False}, 'PlatformConfiguration': {'Provider': 'Environment'},
            'Logging': {'LogLevel': {'Default': 'Warning', 'Microsoft.Hosting.Lifetime': 'Information'}}}
    commerce = copy.deepcopy(base)
    commerce.update(PlatformSecurity=security('reader', True), Database={'DbProvider': 0,
        'ConnectionString': 'mongodb://runtime_context:' + c['mongo_context'] + '@mongo:27017/platform_runtime?authSource=platform_runtime'},
        Redis={'RedisPubSubEnabled': True, 'RedisPubSubConnectionString': 'redis:6379,password=' + c['redis'],
               'PersistKeysToRedis': True, 'PersistKeysToRedisUrl': 'redis:6379,password=' + c['redis'], 'RedisPubSubChannel': ident},
        Application={'DisableHostedService': True, 'SkipMigrationProcess': True, 'DisplayFullErrorStack': False},
        Security={'UseHsts': True, 'UseDefaultSecurityHeaders': True, 'UseHttpsRedirection': False, 'CookieSecurePolicyAlways': True,
                  'CookieSameSite': 'Lax', 'CookieSameSiteExternalAuth': 'Lax', 'EnableRuntimeCompilation': False, 'UseForwardedHeaders': False},
        Azure={'RunOnAzureWebApps': False, 'PersistKeysToAzureKeyVault': False, 'PersistKeysToAzureBlobStorage': False},
        AuthConfiguration={'IdentityProviderUrl': identity + '/realms/commerce', 'Audience': 'saas-manager', 'ClientId': 'saas-manager'},
        FrontendAPI={'Enabled': True, 'JsonContentType': True, 'SecretKey': c['frontend']},
        BackendAPI={'Enabled': True, 'SecretKey': c['backend']},
        Extensions={'InstalledPlugins': '', 'PluginSkipLoadingPattern': '.*'}, MultitenantTask={'Enabled': False},
        Notifications=p['Providers']['Notifications'], Provisioning={'ReadinessEndpoint': True},
        Proxy=proxy([ip(11)]), AllowedHosts='*.' + p['StoreParentDomain'])
    if ca: commerce['AuthConfiguration']['AuthorityRootCertificateFile'] = ca
    administration = copy.deepcopy(commerce)
    administration.update(AllowedHosts='*.' + p['AdminParentDomain'],
        TenantRouting={'Provider': 'Directory', 'RouteDirectory': '/var/lib/commerce/routes', 'AdminParentDomains': [p['AdminParentDomain']]})
    installer = copy.deepcopy(commerce); installer['PlatformSecurity'] = security('worker')
    gateway = copy.deepcopy(base)
    gateway.update(PlatformSecurity=security('reader', True), Proxy=proxy([ip(10)]),
        AllowedHosts='*.' + p['StoreParentDomain'] + ';*.' + p['AdminParentDomain'],
        Gateway={'Provider': 'Directory', 'RouteDirectory': '/var/lib/commerce/routes', 'StoreBaseUrl': store, 'AdminBaseUrl': admin,
                 'CommerceUpstream': 'http://commerce:8080', 'AdminUpstream': 'http://admin:8080', 'AllowHttpUpstreams': True,
                 'IdentityAuthority': identity, 'IdentityRealm': 'commerce'})
    if ca: gateway['Gateway']['IdentityRootCertificateFile'] = ca
    saas = copy.deepcopy(base)
    saas.update(PlatformSecurity=security('saas'), ApplicationUrl=portal, AllowedHosts=p['PortalHost'],
        AuthConfiguration={'IdentityProviderUrl': identity + '/realms/commerce', 'Audience': 'saas-manager', 'ClientId': 'saas-manager',
                           'ClientSecret': c['saas_client'], 'Scopes': ['openid', 'profile', 'email', 'roles']},
        ConnectionStrings={'SaasManagerDb': connection('platform_saas', 'saas')}, DatabaseBootstrap={'Mode': 'External'},
        Provisioning={'Enabled': True, 'InitializeSchema': False, 'Profile': 'Portable', 'DeploymentId': ident, 'Mobile': {'Provider': 'Disabled'}},
        TenantOnboarding={'Trial': {'Enabled': True, 'PlanId': p['TrialPlan']['Id']}}, CardProtection={'Provider': 'Disabled'},
        FileStorage={'Provider': 'FileSystem', 'FileSystem': {'RootDirectory': '/var/lib/commerce/saas-files'}},
        Web={'AllowedOrigins': [portal], 'DataProtectionKeyDirectory': '/var/lib/commerce/saas-cookie-keys', 'DataProtectionApplicationName': ident},
        GuestAuth={'Issuer': portal, 'Audience': portal, 'SecretKey': c['guest']}, redispublisher='redis:6379,password=' + c['redis'],
        Proxy=proxy([ip(10)]), Diagnostics={'DatabaseQueries': {'Enabled': False}})
    if ca: saas['AuthConfiguration']['AuthorityRootCertificateFile'] = ca
    worker = copy.deepcopy(base)
    worker.update(PlatformSecurity=security('worker'), Provisioning={'Enabled': True, 'InitializeSchema': False, 'Profile': 'Portable',
        'Google': p['Providers']['Google'], 'Domains': p['Providers']['Domains'], 'ReadinessEmail': p['Providers']['ReadinessEmail'],
        'Mobile': {'Provider': 'Disabled'}, 'Worker': {'MaxAttempts': 5, 'PollInterval': '00:00:02'},
        'Portable': {'DeploymentId': ident, 'MongoAdminConnection': 'mongodb://tenant_provisioner:' + c['mongo_worker'] + '@mongo:27017/admin?authSource=admin',
            'InstallerPath': '/app/installer/Grand.Installer.Cli.dll', 'CommerceConfigPath': '/run/secrets/installer.json',
            'WorkingDirectory': '/var/lib/commerce/onboarding', 'TenantDirectory': '/var/lib/commerce/tenants',
            'RouteDirectory': '/var/lib/commerce/routes', 'NotificationDirectory': '/var/lib/commerce/readiness-outbox', 'MobileDirectory': '/var/lib/commerce/mobile',
            'StoreBaseUrl': store, 'AdminBaseUrl': admin, 'KeycloakAuthority': identity, 'KeycloakRealm': 'commerce',
            'KeycloakAdminRealm': 'commerce', 'KeycloakAdminClientId': 'tenant-provisioner', 'KeycloakAdminClientSecret': c['provisioner']}})
    if ca: worker['Provisioning']['Portable'].update(IdentityRootCertificateFile=ca, IngressRootCertificateFile=ca)
    bootstrap = copy.deepcopy(base)
    bootstrap.update(PlatformSecurity=security('owner'), ConnectionStrings={'SaasManagerDb': connection('platform_saas', 'owner')},
                     Provisioning={'DeploymentId': ident, 'InitializeSchema': False},
                     TenantOnboarding={'Trial': {'Enabled': True, 'PlanId': p['TrialPlan']['Id']}},
                     Bootstrap={'DeploymentId': ident, 'AllowSchemaChanges': True, 'TrialPlan': p['TrialPlan']})
    for role, value in {'commerce': commerce, 'admin': administration, 'installer': installer, 'gateway': gateway, 'saas': saas, 'worker': worker, 'bootstrap': bootstrap}.items():
        write_json(state / 'config' / (role + '.json'), value)
    realm = {'realm': 'commerce', 'enabled': True, 'sslRequired': 'external', 'registrationAllowed': False,
        'verifyEmail': True, 'resetPasswordAllowed': True,
        'roles': {'realm': [{'name': 'business_owner'}, {'name': 'admin'}]},
        'clients': [{'clientId': 'saas-manager', 'enabled': True, 'publicClient': False, 'secret': c['saas_client'],
                     'standardFlowEnabled': True, 'directAccessGrantsEnabled': False, 'redirectUris': [portal + '/remote-auth/signin-oidc'], 'webOrigins': [portal],
                     'attributes': {'post.logout.redirect.uris': portal + '/remote-auth/signout-callback-oidc'}},
                    {'clientId': 'tenant-provisioner', 'enabled': True, 'publicClient': False, 'secret': c['provisioner'],
                     'serviceAccountsEnabled': True, 'standardFlowEnabled': False, 'directAccessGrantsEnabled': False}],
        'users': [{'username': 'service-account-tenant-provisioner', 'enabled': True, 'serviceAccountClientId': 'tenant-provisioner',
                   'clientRoles': {'realm-management': ['create-client', 'query-clients', 'view-clients', 'manage-clients']}}]}
    if p.get('Identity', {}).get('RegistrationAllowed'):
        if not p['Identity'].get('Smtp'): raise ValueError('Configure Keycloak SMTP before enabling public identity registration.')
        realm.update(registrationAllowed=True, smtpServer=p['Identity']['Smtp'])
    write_json(state / 'realm/commerce-realm.json', realm)
    (state / 'secrets/redis.conf').write_text('bind 0.0.0.0\nprotected-mode yes\nrequirepass ' + c['redis'] + '\nappendonly yes\n')
    (state / 'secrets/redis.conf').chmod(0o600)
    edge = '{\n admin off\n auto_https disable_redirects\n}\n'
    for host, target in ((p['PortalHost'], 'saas:8080'), (p['IdentityHost'], 'keycloak:8080'),
                         ('*.' + p['StoreParentDomain'], 'gateway:8080'), ('*.' + p['AdminParentDomain'], 'gateway:8080')):
        edge += 'https://' + host + ' {\n tls /run/secrets/tls-fullchain.pem /run/secrets/tls-private.key\n'
        if host == p['IdentityHost']:
            edge += ' @privateAdmin {\n  path /admin/realms/commerce/*\n  remote_ip ' + str(subnet) + '\n }\n handle @privateAdmin {\n  reverse_proxy ' + target + ' {\n   header_up -Forwarded\n   header_up X-Forwarded-For {remote_host}\n   header_up X-Forwarded-Proto https\n   header_up X-Forwarded-Port ' + str(p['HttpsPort']) + '\n  }\n }\n @public path /realms/commerce/* /resources/* /.well-known/*\n handle @public {\n'
        edge += ' reverse_proxy ' + target + ' {\n  header_up -Forwarded\n  header_up X-Forwarded-For {remote_host}\n  header_up X-Forwarded-Proto https\n  header_up X-Forwarded-Port ' + str(p['HttpsPort']) + '\n }\n'
        if host == p['IdentityHost']: edge += ' }\n handle {\n  respond 404\n }\n'
        edge += '}\n'
    edge += ':80 {\n redir https://{host}' + port + '{uri} permanent\n}\n'
    (state / 'config/Caddyfile').write_text(edge)
    write_json(state / 'compose.json', compose(p, state, record, image, ip, identity))


def compose(p, state, record, image, ip, identity):
    bind = lambda source, target, readonly=True: {'type': 'bind', 'source': str(state / source), 'target': target, 'read_only': readonly, 'bind': {'create_host_path': False}}
    label = {'commerce.installation': record['InstallationId']}
    services = {}
    def service(name, number, **settings):
        if 'entrypoint' in settings: settings['entrypoint'] = [value.replace('$', '$$') for value in settings['entrypoint']]
        settings.update(networks={'platform': {'ipv4_address': ip(number)}}, labels=label, restart='unless-stopped')
        services[name] = settings; return settings
    pg = service('postgres', 20, image='postgres:16-alpine',
        entrypoint=['/bin/sh', '-ec', 'export POSTGRES_PASSWORD="$(cat /run/secrets/postgres)"; exec docker-entrypoint.sh "$@"', 'platform-postgres'], command=['postgres'],
        environment={'POSTGRES_USER': 'postgres', 'POSTGRES_DB': 'postgres'},
        volumes=['postgres-data:/var/lib/postgresql/data', bind('secrets/postgres', '/run/secrets/postgres')],
        healthcheck={'test': ['CMD', 'pg_isready', '-h', '127.0.0.1', '-U', 'postgres'], 'interval': '5s', 'timeout': '3s', 'retries': 40})
    service('mongo', 21, image='mongo:8.0',
        entrypoint=['/bin/sh', '-ec', 'export MONGO_INITDB_ROOT_PASSWORD="$(cat /run/secrets/mongo)"; exec docker-entrypoint.sh "$@"', 'platform-mongo'],
        command=['mongod', '--auth', '--bind_ip_all'], environment={'MONGO_INITDB_ROOT_USERNAME': 'platform_root'},
        volumes=['mongo-data:/data/db', bind('secrets/mongo', '/run/secrets/mongo')],
        healthcheck={'test': ['CMD', 'mongosh', '--host', 'mongo', '--quiet', '--eval', "db.adminCommand('ping').ok"], 'interval': '5s', 'timeout': '5s', 'retries': 40})
    service('redis', 22, image='redis:7.4-alpine',
        entrypoint=['/bin/sh', '-ec', 'cp /run/secrets/redis.conf /data/platform.conf; chown redis:redis /data/platform.conf; chmod 600 /data/platform.conf; exec docker-entrypoint.sh redis-server /data/platform.conf'],
        volumes=['redis-data:/data', bind('secrets/redis.conf', '/run/secrets/redis.conf')])
    service('keycloak', 23, image='commerce-keycloak:26.8.0', user=str(record['Uid']) + ':' + str(record['Gid']),
        entrypoint=['/bin/bash', '-ec', 'export KC_DB_PASSWORD="$(cat /run/secrets/keycloak_db)" KC_BOOTSTRAP_ADMIN_PASSWORD="$(cat /run/secrets/keycloak_admin)"; exec /opt/keycloak/bin/kc.sh start --optimized --import-realm'],
        environment={'KC_DB_URL': 'jdbc:postgresql://postgres:5432/platform_identity', 'KC_DB_USERNAME': 'platform_keycloak_db',
            'KC_BOOTSTRAP_ADMIN_USERNAME': 'platform-admin', 'KC_HOSTNAME': identity, 'KC_HTTP_ENABLED': 'true',
            'KC_PROXY_HEADERS': 'xforwarded', 'KC_PROXY_TRUSTED_ADDRESSES': ip(10), 'KC_HEALTH_ENABLED': 'true'},
        volumes=[bind('secrets/keycloak_db', '/run/secrets/keycloak_db'), bind('secrets/keycloak_admin', '/run/secrets/keycloak_admin'),
                 bind('keycloak-data', '/opt/keycloak/data', False), bind('realm', '/opt/keycloak/data/import')])
    service('edge', 10, image='caddy:2.10-alpine', ports=[p.get('ListenAddress', '0.0.0.0') + ':' + str(p['HttpPort']) + ':80', p.get('ListenAddress', '0.0.0.0') + ':' + str(p['HttpsPort']) + ':443'],
        volumes=[bind('config/Caddyfile', '/etc/caddy/Caddyfile'), bind('secrets/tls-fullchain.pem', '/run/secrets/tls-fullchain.pem'),
                 bind('secrets/tls-private.key', '/run/secrets/tls-private.key')],
        read_only=True, tmpfs=['/data:rw,nosuid,size=16m', '/config:rw,nosuid,size=16m', '/tmp:rw,nosuid,size=16m'],
        security_opt=['no-new-privileges:true'])
    numbers = {'gateway': 11, 'commerce': 12, 'admin': 13, 'saas': 14, 'worker': 15, 'bootstrap': 16}
    for role, number in numbers.items():
        mounts = [bind('config/' + role + '.json', '/run/secrets/config.json'), bind('secrets/platform-master-key', '/run/secrets/platform-master-key')]
        if p['Tls'].get('RootCertificateFile'): mounts.append(bind('secrets/root-ca.pem', '/run/secrets/root-ca.pem'))
        environment = {'PlatformConfiguration__ConfigPath': '/run/secrets/config.json', 'Gateway__ConfigPath': '/run/secrets/config.json',
                       'Provisioning__ConfigPath': '/run/secrets/config.json', 'ASPNETCORE_URLS': 'http://0.0.0.0:8080'}
        credential = ('GoogleCredentialsFile', 'google-provisioning.json') if role == 'worker' else ('NotificationCredentialsFile', 'google-notifications.json') if role in ('commerce', 'admin') else None
        if credential and p.get(credential[0]):
            target = '/run/secrets/' + credential[1]
            mounts.append(bind('secrets/' + credential[1], target))
            environment['GOOGLE_APPLICATION_CREDENTIALS'] = target
        writable = {'worker': ['onboarding', 'tenants', 'routes', 'readiness-outbox', 'mobile'], 'saas': ['saas-files', 'saas-cookie-keys']}.get(role, [])
        for directory in writable: mounts.append(bind(directory, '/var/lib/commerce/' + directory, False))
        if role in ('admin', 'gateway'): mounts.append(bind('routes', '/var/lib/commerce/routes'))
        if role in ('commerce', 'admin'):
            for directory, target in (('media-images', 'images'), ('media-files', 'files')):
                mounts.append(bind(directory, '/app/' + role + '/wwwroot/assets/' + target + '/uploaded', False))
        if role == 'worker': mounts.append(bind('config/installer.json', '/run/secrets/installer.json'))
        settings = service(role, number, image=image, command=[role], environment=environment, volumes=mounts,
                           security_opt=['no-new-privileges:true'], cap_drop=['ALL'])
        if role == 'bootstrap': settings.update(profiles=['initialize'], restart='no', command=['bootstrap', 'initialize', '--config', '/run/secrets/config.json'])
    return {'name': 'commerce-prod-' + p['DeploymentId'], 'services': services,
        'networks': {'platform': {'driver': 'bridge', 'labels': label, 'ipam': {'config': [{'subnet': p.get('NetworkSubnet', '172.30.80.0/24')}]}}},
        'volumes': {name: {'labels': label} for name in ('postgres-data', 'mongo-data', 'redis-data')}}
