#!/usr/bin/env python3
"""Production-mode SaaS readiness without Azure, using only this demo's private data."""
import copy, http.cookiejar, json, os, signal, ssl, subprocess, sys, time, urllib.error, urllib.parse, urllib.request
from html.parser import HTMLParser
from pathlib import Path
import demo
from smoke_onboarding import check, LoginForm, NoRedirect
from portable_test_identity import https_identity

def probe(identity,keys,certificate,private_key):
    config=json.loads((demo.LOCAL/'saas.json').read_text())
    config['LocalDemo']={'Enabled':False}
    security=config['PlatformSecurity'];master=security['Local']['MasterKeyFile']
    security['Provider']='AesGcm';security['AesGcm']={'MasterKeyFile':master};security['InitializeSchema']=False;security.pop('Local',None)
    config['Provisioning']['InitializeSchema']=False
    config['AuthConfiguration']['IdentityProviderUrl']=identity['authority']
    config['AuthConfiguration']['AuthorityRootCertificateFile']=str(identity['root'])
    config['CardProtection']={'Provider':'Platform'}
    config['ApplicationUrl']='https://localhost:18084'
    config['Web']={'AllowedOrigins':['https://localhost:18084'],'DataProtectionKeyDirectory':str(keys/'cookie-keys'),'DataProtectionApplicationName':'saas-portable-readiness'}
    config['Diagnostics']={'DatabaseQueries':{'Enabled':True}}
    config['AZURE_KEY_VAULT_ENDPOINT']='https://must-not-be-used.invalid'
    config['Kestrel']={'Endpoints':{'Https':{'Url':'https://127.0.0.1:18084','Certificate':{'Path':str(certificate),'KeyPath':str(private_key)}}}}
    identity_secret=config.pop('ClientSecret-centraladminapp')
    path=demo.LOCAL/'portable-saas-smoke.json';demo.write_json(path,config)
    env={key:value for key,value in os.environ.items() if not key.startswith(('AZURE_','LocalDemo__')) and key not in ('ASPNETCORE_URLS','WEBSITE_HOSTNAME','DOTNET_STARTUP_HOOKS','ASPNETCORE_HOSTINGSTARTUPASSEMBLIES')}
    env.update(DOTNET_ENVIRONMENT='Production',ASPNETCORE_ENVIRONMENT='Production',PlatformConfiguration__ConfigPath=str(path),PlatformConfiguration__Provider='Environment',AuthConfiguration__ClientSecret=identity_secret)
    run=demo.LOCAL/'runtime/saas';marker=str(run/'SaasManager.Web.dll');pfile=demo.LOCAL/'processes.json'
    pids=json.loads(pfile.read_text()) if pfile.exists() else {}
    if 'portable-saas' in pids:raise RuntimeError('A recorded portable readiness host already exists; stop it before retrying.')
    context=ssl.create_default_context(cafile=str(certificate));context.load_verify_locations(cafile=str(identity['root']))
    jar=http.cookiejar.CookieJar();opener=urllib.request.build_opener(urllib.request.HTTPSHandler(context=context),urllib.request.HTTPCookieProcessor(jar))
    with (demo.LOCAL/'logs/portable-saas.log').open('w') as log:
        proc=subprocess.Popen(['dotnet',marker],cwd=run,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    pids['portable-saas']={'pid':proc.pid,'marker':marker};demo.write_json(pfile,pids)
    def request(path,headers=None,method=None):
        try:
            with opener.open(urllib.request.Request('https://localhost:18084'+path,headers=headers or {},method=method),timeout=4) as response:return response.status,dict(response.headers),response.read()
        except urllib.error.HTTPError as error:return error.code,dict(error.headers),error.read()
    try:
        deadline=time.monotonic()+75;ready=False
        while time.monotonic()<deadline:
            if proc.poll() is not None:raise RuntimeError('Production SaaS stopped; inspect .local/logs/portable-saas.log')
            try:ready=request('/health')[0]==200
            except (OSError,urllib.error.URLError):pass
            if ready:break
            time.sleep(1)
        check(ready,'SaaS starts in Production with LocalDemo disabled, AesGcm and private filesystem storage')
        check(request('/health')[2]==b'Healthy','Production HTTPS readiness verifies the PostgreSQL connection without Azure credentials')
        code,_,body=request('/api/specification.json');document=json.loads(body) if code==200 else {}
        check(code==200 and bool(document.get('paths')),'Production host serves a real API document without a listen-address CORS dependency')
        check(not any('DbQueries' in name for name in document['paths']),'Production does not map the raw SQL diagnostic endpoints even when the flag is set')
        code,headers,_=request('/api/app-builds/get-vm',{'Origin':'https://foreign.example.test','Access-Control-Request-Method':'GET'},'OPTIONS')
        check('Access-Control-Allow-Origin' not in headers,'Production does not grant credentialed CORS access to a foreign origin')
        code,headers,_=request('/api/app-builds/get-vm',{'Origin':'https://localhost:18084','Access-Control-Request-Method':'GET'},'OPTIONS')
        check(code==204 and headers.get('Access-Control-Allow-Origin')=='https://localhost:18084' and headers.get('Access-Control-Allow-Credentials')=='true','Configured public origin receives credentialed CORS independently of the listen address')
        authenticate(opener,jar,identity,context)
        check(any((keys/'cookie-keys').glob('key-*.xml')),'Production cookie key material is persisted in the explicit private volume')
        check(proc.poll() is None,'Production SaaS remains running after readiness checks with an unused Key Vault endpoint configured')
        os.killpg(proc.pid,signal.SIGTERM);proc.wait(timeout=15)
        with (demo.LOCAL/'logs/portable-saas.log').open('a') as log:
            proc=subprocess.Popen(['dotnet',marker],cwd=run,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        current=json.loads(pfile.read_text());current['portable-saas']={'pid':proc.pid,'marker':marker};demo.write_json(pfile,current)
        deadline=time.monotonic()+45;ready=False
        while time.monotonic()<deadline and proc.poll() is None:
            try:ready=request('/health')[0]==200
            except (OSError,urllib.error.URLError):pass
            if ready:break
            time.sleep(1)
        check(ready,'A new Production process starts against the same persistent cookie key ring')
        with opener.open('https://localhost:18084/api/Auth/sessionInfo',timeout=30) as response:session=json.load(response)
        check(session.get('isSuccess') and session.get('data',{}).get('user',{}).get('email')==identity['account']['email'],'Authenticated Production session survives an independent process restart without Azure')
        refreshed=refresh_owner_session(opener,identity)
        revoke=urllib.parse.urlencode({'client_id':config['AuthConfiguration']['ClientId'],'client_secret':identity_secret,
            'token_type_hint':'refresh_token','token':refreshed['refreshToken']}).encode()
        with opener.open(urllib.request.Request(identity['authority']+'/protocol/openid-connect/revoke',revoke,
                {'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:
            check(response.status==200,'The fixture revokes its own actual Keycloak refresh grant')
        check(request('/api/Auth/refresh')[0]==401,'A revoked identity grant is refused by the actual Production refresh endpoint')
        check(not any(cookie.name.startswith('__Host-auth.session') for cookie in jar),
            'Rejected token renewal clears the unusable host-only cookie instead of retaining a portal login loop')
        check(request('/api/Auth/sessionInfo')[0]==401,'The rejected session requires authentication again')
        print('Portable SaaS Production HTTPS/OIDC checks passed. Full platform deployment remains a separate gate.',flush=True)
    finally:
        if proc.poll() is None:
            os.killpg(proc.pid,signal.SIGTERM)
            try:proc.wait(timeout=15)
            except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait(timeout=5)
        current=json.loads(pfile.read_text()) if pfile.exists() else {}
        if current.get('portable-saas',{}).get('pid')==proc.pid:current.pop('portable-saas',None);demo.write_json(pfile,current)

class CallbackForm(HTMLParser):
    def __init__(self):super().__init__();self.action=None;self.fields={};self.active=False
    def handle_starttag(self,tag,attributes):
        attributes=dict(attributes)
        if tag=='form' and attributes.get('action')=='https://localhost:18084/remote-auth/signin-oidc':self.active=True;self.action=attributes['action']
        if tag=='input' and self.active and attributes.get('name'):self.fields[attributes['name']]=attributes.get('value','')
    def handle_endtag(self,tag):
        if tag=='form':self.active=False

def authenticate(opener,jar,identity,context):
    with opener.open('https://localhost:18084/api/Auth/login?returnUrl=/',timeout=30) as response:
        page=response.read().decode();form=LoginForm();form.feed(page)
    check(bool(form.action) and form.action.startswith(identity['authority']+'/'),'Production OIDC reaches the real isolated HTTPS Keycloak login')
    values=dict(form.fields,username=identity['account']['username'],password=identity['account']['password'])
    with opener.open(urllib.request.Request(form.action,urllib.parse.urlencode(values).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:
        callback=CallbackForm();callback.feed(response.read().decode())
    check(bool(callback.action) and 'state' in callback.fields,'Keycloak returns the protected Production OIDC form callback')
    for tamper,message in [('correlation','Production rejects a real callback without its correlation cookie'),('state','Production rejects a tampered protected state')]:
        foreign=http.cookiejar.CookieJar()
        if tamper=='state':
            for cookie in jar:foreign.set_cookie(copy.copy(cookie))
        isolated=urllib.request.build_opener(urllib.request.HTTPSHandler(context=context),urllib.request.HTTPCookieProcessor(foreign),NoRedirect())
        fields=dict(callback.fields)
        if tamper=='state':fields['state']='invalid-protected-state'
        try:
            with isolated.open(urllib.request.Request(callback.action,urllib.parse.urlencode(fields).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:response.read()
        except urllib.error.HTTPError:pass
        check(not any(cookie.name.startswith('__Host-auth.session') for cookie in foreign),message)
    with opener.open(urllib.request.Request(callback.action,urllib.parse.urlencode(callback.fields).encode(),{'Content-Type':'application/x-www-form-urlencoded'}),timeout=30) as response:response.read()
    with opener.open('https://localhost:18084/api/Auth/sessionInfo',timeout=30) as response:session=json.load(response)
    check(session.get('isSuccess') and session.get('data',{}).get('user',{}).get('email')==identity['account']['email'],'Production validates a real identity token and establishes the SaaS owner session')
    auth=next((cookie for cookie in jar if cookie.name=='__Host-auth.session'),None)
    check(auth is not None and auth.secure and auth.path=='/' and not auth.domain_specified and any(key.lower()=='httponly' for key in auth._rest),'Production issues a secure HttpOnly host-only session cookie')

    refresh_owner_session(opener,identity)

def refresh_owner_session(opener,identity):
    with opener.open('https://localhost:18084/api/Auth/refresh',timeout=30) as response:refreshed=json.load(response)
    data=refreshed.get('data') or {}
    check(refreshed.get('isSuccess') and bool(data.get('accessToken')) and bool(data.get('refreshToken')) and data.get('expiresIn',0)>0,
        'The real Production refresh endpoint renews actual Keycloak tokens through explicit private CA trust')
    with opener.open('https://localhost:18084/api/Auth/sessionInfo',timeout=30) as response:session=json.load(response)
    check(session.get('isSuccess') and session.get('data',{}).get('user',{}).get('email')==identity['account']['email'],
        'Token renewal preserves the authenticated owner and usable cookie session')
    return data

def main():
    os.umask(0o077)
    config=json.loads((demo.LOCAL/'saas.json').read_text())
    check(config['LocalDemo']['Enabled'] is True,'Production readiness probe starts from this checkout demo configuration')
    if not config['ConnectionStrings']['SaasManagerDb'].startswith('Host=127.0.0.1;Port=15439;Database=commerce_saas;') or not config['PlatformSecurity']['ConnectionString'].startswith('Host=127.0.0.1;Port=15439;Database=commerce_secrets;'):
        raise RuntimeError('Only the known local demo databases are permitted.')
    keys=demo.LOCAL/'portable-smoke';keys.mkdir(mode=0o700,exist_ok=True)
    certificate=keys/'tls.crt';private_key=keys/'tls.key'
    subprocess.run(['openssl','req','-x509','-newkey','rsa:2048','-sha256','-nodes','-days','1',
        '-keyout',str(private_key),'-out',str(certificate),'-subj','/CN=localhost',
        '-addext','subjectAltName=DNS:localhost,IP:127.0.0.1'],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    private_key.chmod(0o600);certificate.chmod(0o600)
    project=demo.ROOT/'tests/Portable.Services.Integration/Portable.Services.Integration.csproj'
    with (demo.LOCAL/'logs/build-production-fixture.log').open('w') as output:
        subprocess.run(['dotnet','build',str(project),'-c','Release','--nologo'],cwd=demo.ROOT/'SaasManager',stdout=output,stderr=subprocess.STDOUT,check=True)
    with https_identity(keys) as identity:
        dll=project.parent/'bin/Release/net9.0/Portable.Services.Integration.dll'
        for root,url,expected,message in [
            (str(identity['root']),identity['authority']+'/.well-known/openid-configuration',True,'Explicit private identity CA accepts the real HTTPS metadata'),
            ('system',identity['authority']+'/.well-known/openid-configuration',False,'System trust rejects the unconfigured private identity CA'),
            (str(identity['root']),identity['authority'].replace('localhost','127.0.0.1')+'/.well-known/openid-configuration',False,'Private identity trust still rejects a certificate hostname mismatch')]:
            result=subprocess.run(['dotnet',str(dll),'--identity-tls',root,url],cwd=demo.ROOT/'SaasManager',text=True,capture_output=True,check=True)
            with (demo.LOCAL/'logs/identity-tls-probe.log').open('a') as output:output.write(message+'\n'+result.stderr+'\n')
            check(json.loads(result.stdout)['accepted'] is expected,message)
        probe(identity,keys,certificate,private_key)

if __name__=='__main__':
    signal.signal(signal.SIGTERM,lambda *_:sys.exit(143))
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
