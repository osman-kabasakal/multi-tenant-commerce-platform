"""Ephemeral HTTPS Keycloak for the Production probe; never touches the demo identity volume."""
import contextlib, json, secrets, ssl, subprocess, time, urllib.request, uuid
import demo

@contextlib.contextmanager
def https_identity(directory,provisioning=False):
    authority_root=directory/'identity-ca.crt';authority_key=directory/'identity-ca.key'
    certificate=directory/'identity.crt';key=directory/'identity.key';csr=directory/'identity.csr';extensions=directory/'identity-extensions.cnf'
    commands=[['openssl','req','-x509','-newkey','rsa:2048','-sha256','-nodes','-days','1','-keyout',str(authority_key),'-out',str(authority_root),
        '-subj','/CN=PortableIdentityTestCA','-addext','basicConstraints=critical,CA:TRUE','-addext','keyUsage=critical,keyCertSign,cRLSign'],
        ['openssl','req','-new','-newkey','rsa:2048','-nodes','-keyout',str(key),'-out',str(csr),'-subj','/CN=localhost'],
        ['openssl','x509','-req','-in',str(csr),'-CA',str(authority_root),'-CAkey',str(authority_key),'-CAcreateserial','-out',str(certificate),'-days','1','-sha256','-extfile',str(extensions)]]
    extensions.write_text('basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:localhost\n')
    for command in commands:subprocess.run(command,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    key.chmod(0o600);authority_key.chmod(0o600);certificate.chmod(0o600);authority_root.chmod(0o600)
    suffix=uuid.uuid4().hex[:10];name='commerce-portable-identity-'+suffix;volume=name+'-data'
    account={'username':'portable-'+suffix,'email':'portable-'+suffix+'@example.test','password':secrets.token_urlsafe(28)}
    realm=json.loads((demo.LOCAL/'realm/commerce-demo-realm.json').read_text());realm['sslRequired']='all'
    realm['users']=[{'username':account['username'],'email':account['email'],'emailVerified':True,'enabled':True,
        'firstName':'Portable','lastName':'Probe','realmRoles':['business_owner','admin'],
        'credentials':[{'type':'password','value':account['password'],'temporary':False}]}]
    for client in realm['clients']:
        if client['clientId']=='centraladminapp':
            client['redirectUris']=['https://localhost:18084/*'];client['webOrigins']=['https://localhost:18084']
    provisioner_secret=secrets.token_urlsafe(32)
    if provisioning:
        realm['clients'].append({'clientId':'tenant-provisioner','enabled':True,'publicClient':False,'secret':provisioner_secret,
            'standardFlowEnabled':False,'serviceAccountsEnabled':True})
        realm['users'].append({'username':'service-account-tenant-provisioner','enabled':True,'serviceAccountClientId':'tenant-provisioner',
            'clientRoles':{'realm-management':['manage-clients','query-clients','view-clients','create-client']}})
    payload=b'\0'.join([certificate.read_bytes(),key.read_bytes(),json.dumps(realm).encode()])+b'\0'
    image='quay.io/keycloak/keycloak:26.8.0';created=False;started=False
    try:
        subprocess.run(['docker','volume','create','--label','commerce.test=portable-identity',volume],check=True,stdout=subprocess.DEVNULL);created=True
        subprocess.run(['docker','run','--rm','-i','--user','0','--entrypoint','/bin/bash','-v',volume+':/opt/keycloak/data',image,'-ec',
            'umask 077; mkdir -p /opt/keycloak/data/private /opt/keycloak/data/import; '
            'IFS= read -r -d \"\" payload; printf \"%s\" \"$payload\" > /opt/keycloak/data/private/tls.crt; '
            'IFS= read -r -d \"\" payload; printf \"%s\" \"$payload\" > /opt/keycloak/data/private/tls.key; '
            'IFS= read -r -d \"\" payload; printf \"%s\" \"$payload\" > /opt/keycloak/data/import/commerce-demo-realm.json; '
            'chown -R 1000:0 /opt/keycloak/data; chmod 700 /opt/keycloak/data/private /opt/keycloak/data/import'],
            input=payload,check=True,stdout=subprocess.DEVNULL)
        subprocess.run(['docker','run','--rm','-d','--name',name,'--label','commerce.test=portable-identity','--memory','1g',
            '-p','127.0.0.1:18443:8443','-v',volume+':/opt/keycloak/data','-e','KC_HOSTNAME=https://localhost:18443',
            '-e','KC_HTTP_ENABLED=false','-e','KC_HTTPS_PORT=8443','-e','KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/data/private/tls.crt',
            '-e','KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/data/private/tls.key',image,'start-dev','--import-realm','--http-enabled=false'],check=True,stdout=subprocess.DEVNULL);started=True
        context=ssl.create_default_context(cafile=str(authority_root));authority='https://localhost:18443/realms/commerce-demo';deadline=time.monotonic()+150
        while time.monotonic()<deadline:
            try:
                with urllib.request.urlopen(authority+'/.well-known/openid-configuration',context=context,timeout=4) as response:metadata=json.load(response)
                if metadata['issuer']==authority and metadata['token_endpoint'].startswith(authority):break
            except (OSError,ValueError):time.sleep(1)
        else:raise RuntimeError('The isolated HTTPS identity server did not become ready.')
        yield {'authority':authority,'root':authority_root,'account':account,'provisioningClientId':'tenant-provisioner','provisioningClientSecret':provisioner_secret}
    finally:
        if started:
            logs=subprocess.run(['docker','logs',name],text=True,capture_output=True)
            (demo.LOCAL/'logs/portable-keycloak.log').write_text(logs.stdout+logs.stderr)
            subprocess.run(['docker','stop','-t','5',name],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=20)
        if created:subprocess.run(['docker','volume','rm',volume],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=20)
