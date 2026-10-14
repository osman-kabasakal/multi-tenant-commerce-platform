#!/usr/bin/env python3
"""Reproducible local demo. All generated state stays in .local; no cloud account is used."""
import argparse, json, os, secrets, shutil, signal, socket, subprocess, sys, time, urllib.request, urllib.parse
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
LOCAL = ROOT / '.local'
SLUGS = ('demo-a', 'demo-b')
IDENTITY = 'http://localhost:18080'
PROJECTS = {
    'admin': ('Ecommerce', 'src/Web/Grand.Web.OnlyAdmin/Grand.Web.OnlyAdmin.csproj', 'Grand.Web.OnlyAdmin.dll'),
    'saas': ('SaasManager', 'src/Web/Web.csproj', 'SaasManager.Web.dll'),
    'installer': ('Ecommerce', 'src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj', 'Grand.Installer.Cli.dll'),
    'commerce': ('Ecommerce', 'src/Web/Grand.Web.MultiTenant/Grand.Web.MultiTenant.csproj', 'Grand.Web.MultiTenant.dll'),
}
def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2)); path.chmod(0o600)
def secret(name):
    p=LOCAL/'secrets'/name
    if not p.exists(): p.write_text(secrets.token_hex(32)); p.chmod(0o600)
    return p.read_text()
def prepare():
    os.umask(0o077)
    for d in ('secrets','realm','logs','tenants','runtime'): (LOCAL/d).mkdir(parents=True,exist_ok=True)
    credentials=LOCAL/'credentials.json'
    if not credentials.exists():
        write_json(credentials, {'keycloak_admin':secrets.token_urlsafe(24), 'postgres':secrets.token_hex(24),
            'store_admin':secrets.token_urlsafe(24), 'saas_user':secrets.token_urlsafe(24)})
    c=json.loads(credentials.read_text())
    p=LOCAL/'compose.env';p.write_text(f'DEMO_POSTGRES_PASSWORD={c["postgres"]}\nDEMO_KEYCLOAK_PASSWORD={c["keycloak_admin"]}\n');p.chmod(0o600)
    conf={
        'LocalDemo':{'Enabled':True,'SecretsPath':str(LOCAL/'secrets'),'TenantDirectory':str(LOCAL/'tenants')},
        'Database':{'ConnectionString':'mongodb://127.0.0.1:27028/commerce_demo_a','DbProvider':0},
        'Application':{'DisableHostedService':True,'SkipMigrationProcess':True},
        'Security':{'UseHsts':False,'UseDefaultSecurityHeaders':False,'UseHttpsRedirection':False,
            'CookieSecurePolicyAlways':False,'CookieSameSite':'Lax','CookieSameSiteExternalAuth':'Lax','EnableRuntimeCompilation':False,'UseForwardedHeaders':False},
        'Azure':{'RunOnAzureWebApps':False,'PersistKeysToAzureKeyVault':False,'PersistKeysToAzureBlobStorage':False},
        'Redis':{'RedisPubSubEnabled':True,'RedisPubSubConnectionString':'127.0.0.1:16389',
            'PersistKeysToRedis':True,'PersistKeysToRedisUrl':'127.0.0.1:16389','RedisPubSubChannel':'commerce-demo'},
        'KeyCloakServiceClient':{'Authority':IDENTITY,'Realm':'commerce-demo','ClientId':'demo-service'},
        'AuthConfiguration':{'IdentityProviderUrl':IDENTITY+'/realms/commerce-demo','Audience':'centraladminapp','ClientId':'centraladminapp'},
        'Web':{'Scheme':'http','Host':'localhost:18090'},
        'MultitenantTask':{'Enabled':False},
        'FrontendAPI':{'Enabled':True,'JsonContentType':True,'SecretKey':secret('FrontendAPI-Secret-default')},
        'BackendAPI':{'Enabled':True,'SecretKey':secret('BackendAPI-Secret-default')},
        'Extensions':{'InstalledPlugins':'','PluginSkipLoadingPattern':'.*'},
        'Logging':{'LogLevel':{'Default':'Warning','Microsoft':'Warning'}},
        'AllowedHosts':'localhost;127.0.0.1;demo-a.localhost;demo-b.localhost'
    }
    write_json(LOCAL/'commerce.json',conf)
    saas={
        'LocalDemo':{'Enabled':True,'MailDirectory':str(LOCAL/'mail')},
        'AZURE_KEY_VAULT_ENDPOINT':'',
        'ConnectionStrings':{'SaasManagerDb':f'Host=127.0.0.1;Port=15439;Database=commerce_saas;Username=commerce_demo;Password={c["postgres"]}'},
        'AuthConfiguration':conf['AuthConfiguration'],
        'ClientSecret-centraladminapp':secret('ClientSecret-centraladminapp'),
        'redispublisher':'127.0.0.1:16389',
        'ApplicationUrl':'http://localhost:18081',
        'GuestAuth':{'Issuer':'http://localhost:18081','Audience':'http://localhost:18081','SecretKey':secret('GuestAuth-Secret')},
        'Logging':{'LogLevel':{'Default':'Warning','Microsoft':'Warning'}},
        'AllowedHosts':'localhost;127.0.0.1'
    }
    write_json(LOCAL/'saas.json',saas)

    realm={'realm':'commerce-demo','enabled':True,'sslRequired':'none','registrationAllowed':False,
        'roles':{'realm':[{'name':'admin'},{'name':'business_owner'}]},
        'clients':[
            {'clientId':'demo-service','enabled':True,'publicClient':False,'secret':secret('ClientSecret-demo-service'),
             'serviceAccountsEnabled':True,'standardFlowEnabled':False},
            {'clientId':'centraladminapp','enabled':True,'publicClient':False,'secret':secret('ClientSecret-centraladminapp'),
             'standardFlowEnabled':True,'redirectUris':['http://localhost:18081/*','http://localhost:18083/*'],
             'webOrigins':['http://localhost:18081','http://localhost:18083']}
        ],
        'users':[{'username':'demo-owner','email':'owner@example.test','firstName':'Demo','lastName':'Owner','emailVerified':True,
            'enabled':True,'realmRoles':['business_owner','admin'],
            'credentials':[{'type':'password','value':c['saas_user'],'temporary':False}]}]}
    write_json(LOCAL/'realm'/'commerce-demo-realm.json',realm)
    print('Local configuration prepared. Credentials: .local/credentials.json (never commit).')
def compose(*args, **kwargs):
    subprocess.run(['docker','compose','--env-file',str(LOCAL/'compose.env'),'-f',str(ROOT/'compose.yaml'),*args],cwd=ROOT,check=True,timeout=300,**kwargs)
def infra():
    # A Linux bind mount preserves host UID/mode: Keycloak UID 1000 cannot
    # read a runner-owned 0600 file. Copy over stdin into our named volume;
    # both the host copy and the container copy remain owner-readable only.
    compose('run','--rm','--no-deps','-T','--user','0','--entrypoint','/bin/bash','keycloak','-ec',
        'mkdir -p /opt/keycloak/data/import && '
        'cat > /opt/keycloak/data/import/commerce-demo-realm.json && '
        'chown 1000:0 /opt/keycloak/data/import /opt/keycloak/data/import/commerce-demo-realm.json && '
        'chmod 700 /opt/keycloak/data/import && chmod 600 /opt/keycloak/data/import/commerce-demo-realm.json',
        input=(LOCAL/'realm/commerce-demo-realm.json').read_bytes())
    compose('up','-d','--wait','mongo','redis','postgres','keycloak')
    wait_url(IDENTITY+'/realms/commerce-demo/.well-known/openid-configuration',180)
def wait_url(url, seconds=60):
    until=time.monotonic()+seconds
    while time.monotonic()<until:
        try:
            with urllib.request.urlopen(url,timeout=3) as res:
                if res.status==200:return
        except Exception:time.sleep(1)
    raise RuntimeError(f'Service did not become ready: {url}')
def build(component=None):
    for name,(base,project,dll) in PROJECTS.items():
        if component and name != component: continue
        log=LOCAL/'logs'/f'build-{name}.log'
        with log.open('w') as output:
            result=subprocess.run(['dotnet','publish',project,'--nologo','-c','Release','-o',str(LOCAL/'runtime'/name),
                '-p:UseAppHost=false','-v','quiet'],cwd=ROOT/base,stdout=output,stderr=subprocess.STDOUT)
        if result.returncode:raise RuntimeError(f'{name} build failed; see {log}')
        (LOCAL/'runtime'/name/'Plugins').mkdir(exist_ok=True)
        shutil.copytree(ROOT/'Ecommerce/src/Web/Grand.Web/App_Data/Resources/Installation',
            LOCAL/'runtime'/name/'App_Data/Resources/Installation', dirs_exist_ok=True)
        if name == 'saas':
            client=ROOT/'SaasManager/src/Web/ClientApp'
            with (LOCAL/'logs/build-saas-ui.log').open('w') as output:
                for command in (['npm','ci','--no-audit','--no-fund'],['npm','run','build','--','--configuration','demo']):
                    if subprocess.run(command,cwd=client,stdout=output,stderr=subprocess.STDOUT).returncode:
                        raise RuntimeError('SaaS UI build failed; see .local/logs/build-saas-ui.log')
            shutil.copytree(client/'dist/browser', LOCAL/'runtime/saas/wwwroot',dirs_exist_ok=True)
        print(f'{name} built.')
def app_env():
    return dict(os.environ,ASPNETCORE_ENVIRONMENT='Development',DOTNET_ENVIRONMENT='Development',
        LocalDemo__Enabled='true',LocalDemo__ConfigPath=str(LOCAL/'commerce.json'),TENANT_APP_INSTANCE_ID='commerce-demo')
def seed():
    c=json.loads((LOCAL/'credentials.json').read_text())
    for slug in SLUGS:
        env=app_env();env.update({
            'TenantMessage__StoreName': 'Demo Coffee' if slug=='demo-a' else 'Demo Books',
            'TenantMessage__StoreSubDomain':slug,'TenantMessage__OwnerEmail':slug+'@example.test',
            'TenantMessage__Password':c['store_admin'],'TenantMessage__CompanyName':slug,
            'TenantMessage__CompanyAddress':'Demo Street 1','TenantMessage__CompanyPhoneNumber':'0000000000',
            'TenantMessage__CompanyEmail':slug+'@example.test',
            'TenantMessage__MongoConnectionString':'mongodb://127.0.0.1:27028/commerce_'+slug.replace('-','_'),
            'LocalDemo__TenantOutput':str(LOCAL/'tenants'/f'{slug}.json')})
        run=LOCAL/'runtime'/'installer';log=LOCAL/'logs'/f'seed-{slug}.log'
        with log.open('w') as out:
            result=subprocess.run(['dotnet',str(run/PROJECTS['installer'][2])],cwd=run,env=env,stdout=out,stderr=subprocess.STDOUT)
        if result.returncode:raise RuntimeError(f'Seed failed: {log}')
        print(f'{slug} database seeded.')
def request_json(url, data=None, bearer=None, method=None, form=False):
    headers={}
    if bearer:headers['Authorization']='Bearer '+bearer
    body=None
    if data is not None:
        body=urllib.parse.urlencode(data).encode() if form else json.dumps(data).encode()
        headers['Content-Type']='application/x-www-form-urlencoded' if form else 'application/json'
    with urllib.request.urlopen(urllib.request.Request(url,body,headers,method=method),timeout=30) as response:
        payload=response.read();return json.loads(payload) if payload else None

def identity():
    c=json.loads((LOCAL/'credentials.json').read_text())
    auth=request_json(IDENTITY+'/realms/master/protocol/openid-connect/token',
        {'grant_type':'password','client_id':'admin-cli','username':'demo-admin','password':c['keycloak_admin']},form=True)['access_token']
    api=IDENTITY+'/admin/realms/commerce-demo'
    for slug in SLUGS:
        tenant=json.loads((LOCAL/'tenants'/f'{slug}.json').read_text())
        mappers=[]
        for name,value in [('sub_domainname',slug),('store_id',tenant['encryptedStoreId']),('db_connection',tenant['encryptedConnection'])]:
            mappers.append({'name':name,'protocol':'openid-connect','protocolMapper':'oidc-hardcoded-claim-mapper',
                'config':{'claim.name':name,'claim.value':value,'jsonType.label':'String','access.token.claim':'true'}})
        mappers.append({'name':'tenant-audience','protocol':'openid-connect','protocolMapper':'oidc-audience-mapper',
            'config':{'included.client.audience':slug,'access.token.claim':'true'}})
        client={'clientId':slug,'enabled':True,'publicClient':False,'secret':secret('ClientSecret-'+slug),
            'standardFlowEnabled':False,'serviceAccountsEnabled':True,'protocolMappers':mappers}
        existing=request_json(api+'/clients?clientId='+slug,bearer=auth)
        if existing:request_json(api+'/clients/'+existing[0]['id'],client,auth,'PUT')
        else:request_json(api+'/clients',client,auth,'POST')
    print('Keycloak tenant clients configured; confidential credentials stay on the server.')
def start():
    env=app_env();env['ASPNETCORE_URLS']='http://127.0.0.1:18082'
    run=LOCAL/'runtime'/'commerce';log=LOCAL/'logs'/'commerce.log'
    pfile=LOCAL/'processes.json';pids=json.loads(pfile.read_text()) if pfile.exists() else {}
    if pids:raise RuntimeError('Run stop before start to avoid duplicate demo processes.')
    with log.open('w') as out:
        proc=subprocess.Popen(['dotnet',str(run/PROJECTS['commerce'][2])],cwd=run,env=env,stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
    pids['commerce']={'pid':proc.pid,'marker':str(run/PROJECTS['commerce'][2])};write_json(pfile,pids)
    # The tenant middleware protects /health too, so readiness is validated through a token below.
    time.sleep(3)
    if proc.poll() is not None:raise RuntimeError(f'Commerce startup failed: {log}')
    print('Commerce API started on 127.0.0.1:18082.')
    gateway=ROOT/'scripts/gateway.py'
    with (LOCAL/'logs/gateway.log').open('w') as out:
        proxy=subprocess.Popen([sys.executable,str(gateway)],cwd=ROOT,stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
    pids['gateway']={'pid':proxy.pid,'marker':str(gateway)};write_json(pfile,pids)
    wait_url('http://127.0.0.1:18090',60)
    print('Open http://demo-a.localhost:18090 and http://demo-b.localhost:18090')
    saasrun=LOCAL/'runtime/saas'
    saasenv=app_env();saasenv.update(ASPNETCORE_URLS='http://127.0.0.1:18081',LocalDemo__ConfigPath=str(LOCAL/'saas.json'))
    with (LOCAL/'logs/saas.log').open('w') as out:
        saas=subprocess.Popen(['dotnet',str(saasrun/PROJECTS['saas'][2])],cwd=saasrun,env=saasenv,stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
    pids['saas']={'pid':saas.pid,'marker':str(saasrun/PROJECTS['saas'][2])};write_json(pfile,pids)
    wait_url('http://127.0.0.1:18081/health',120)
    print('SaaS management demo: http://localhost:18081')
    adminrun=LOCAL/'runtime/admin';adminenv=app_env();adminenv['ASPNETCORE_URLS']='http://127.0.0.1:18083'
    with (LOCAL/'logs/admin.log').open('w') as out:
        admin=subprocess.Popen(['dotnet',str(adminrun/PROJECTS['admin'][2])],cwd=adminrun,env=adminenv,stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
    pids['admin']={'pid':admin.pid,'marker':str(adminrun/PROJECTS['admin'][2])};write_json(pfile,pids)
    wait_url('http://127.0.0.1:18083/health',120)
    print('Store admin: http://demo-a.localhost:18083/Admin and http://demo-b.localhost:18083/Admin')



def stop():
    pfile=LOCAL/'processes.json'
    if pfile.exists():
        for value in json.loads(pfile.read_text()).values():
            result=subprocess.run(['ps','-p',str(value['pid']),'-o','command='],capture_output=True,text=True)
            if value['marker'] in result.stdout:
                try: os.killpg(value['pid'],signal.SIGTERM)
                except ProcessLookupError: pass
        pfile.unlink()
    if (LOCAL/'compose.env').exists():compose('stop')
    print('Demo stopped. Data retained.')
def check():
    if os.name != 'posix':
        raise RuntimeError('Use macOS, Linux or WSL2 for the host launcher.')
    for command in ('python3','dotnet','docker','npm','node'):
        if not shutil.which(command): raise RuntimeError(f'Missing prerequisite: {command}')
    versions=subprocess.check_output(['dotnet','--list-sdks'],text=True)
    if not all(any(line.startswith(version) for line in versions.splitlines()) for version in ('8.0.','9.0.')):
        raise RuntimeError('Install both .NET 8 and .NET 9 SDKs.')
    node=int(subprocess.check_output(['node','--version'],text=True).strip().lstrip('v').split('.')[0])
    if node < 20: raise RuntimeError('Node.js 20 or newer is required; Node.js 22 LTS is the documented version.')
    if shutil.disk_usage(ROOT).free < 2*1024**3:
        raise RuntimeError('Less than 2 GiB free. Free disk space before building; allow at least 10 GiB for a fresh web setup, 15 GiB extra for Android.')
    subprocess.run(['docker','info','--format','{{.ServerVersion}}'],check=True,timeout=15,stdout=subprocess.DEVNULL)
    subprocess.run(['docker','compose','version'],check=True,timeout=15,stdout=subprocess.DEVNULL)
    print('Prerequisites available.')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command',choices=['check','prepare','infra','build','seed','identity','start','stop','up','smoke'])
    parser.add_argument('--component',choices=list(PROJECTS),help='Build only this component (build command).')
    args=parser.parse_args();command=args.command
    if command=='up':
        check()
        # Restart only processes recorded by this checkout. Data and generated credentials are retained.
        pfile=LOCAL/'processes.json'
        if pfile.exists() and json.loads(pfile.read_text()): stop()
        for step in (prepare,infra,build,seed,identity,start):step()
    elif command=='build': prepare();build(args.component)
    elif command=='smoke': subprocess.run([sys.executable,str(ROOT/'scripts/smoke.py')],check=True)
    else:globals()[command]()
if __name__=='__main__':
    try:main()
    except (RuntimeError,OSError,subprocess.CalledProcessError,subprocess.TimeoutExpired) as error:
        print(str(error),file=sys.stderr);sys.exit(1)
