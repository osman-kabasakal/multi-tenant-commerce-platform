#!/usr/bin/env python3
"""Real Production gateway/commerce/admin + worker, isolated database and HTTPS identity.

A loopback-only CONNECT fixture maps synthetic DNS names. It does not terminate
TLS, relax certificate validation, modify the hosts file or contact a DNS API.
"""
import argparse, base64, contextlib, copy, http.cookiejar, http.server, json, os, secrets, select, signal, socket, subprocess, sys, threading, time, urllib.error, urllib.parse, urllib.request, uuid
from html.parser import HTMLParser
from pathlib import Path
import ssl
import demo
from portable_test_identity import https_identity
from smoke_onboarding import NoRedirect, check

@contextlib.contextmanager
def synthetic_dns(port,portal=False):
    class Connect(http.server.BaseHTTPRequestHandler):
        def log_message(self,*_):pass
        def do_CONNECT(self):
            destination=urllib.parse.urlsplit('//'+self.path)
            host=destination.hostname or ''
            target_port=port if destination.port==port and any(host.endswith('.'+parent) for parent in ('shops.example.test','manage.example.test')) else 18084 if portal and destination.port==18084 and host=='portal.example.test' else 18443 if portal and destination.port==18443 and host=='localhost' else None
            if target_port is None:self.send_error(403);return
            with socket.create_connection(('127.0.0.1',target_port),timeout=10) as target:
                self.send_response(200,'Connection established');self.end_headers();self.close_connection=True
                connections=(self.connection,target)
                while True:
                    ready,_,_=select.select(connections,[],[],30)
                    if not ready:return
                    for source in ready:
                        try:
                            payload=source.recv(65536)
                            if not payload:return
                            (target if source is self.connection else self.connection).sendall(payload)
                        except (ConnectionError,TimeoutError):return
    server=http.server.ThreadingHTTPServer(('127.0.0.1',0),Connect);server.daemon_threads=True
    thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
    try:yield 'http://127.0.0.1:'+str(server.server_port)
    finally:server.shutdown();server.server_close();thread.join(timeout=5)

def wait_process(process,predicate,label,seconds=90):
    deadline=time.monotonic()+seconds
    while time.monotonic()<deadline:
        if process.poll() is not None:raise RuntimeError(label+' exited; inspect the private test logs.')
        if predicate():return
        time.sleep(.2)
    raise RuntimeError(label+' did not reach the expected state; inspect the private test logs.')

def production_started(path):
    text=path.read_text()
    return 'Application started' in text and 'Hosting environment: Production' in text

def stop(process):
    if process and process.poll() is None:
        os.killpg(process.pid,signal.SIGTERM)
        try:process.wait(timeout=15)
        except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.wait(timeout=5)

def empty_runtime_database(tenant,credentials,password,action,log_path):
    name='portable_empty_'+tenant
    script='const a=db.getSiblingDB("admin");a.auth("commerce_demo_root",'+json.dumps(credentials['mongo_root'])+');const d=db.getSiblingDB('+json.dumps(name)+');const u=d.getUser('+json.dumps(name)+');'
    owned='if(u.customData?.fixture!=='+json.dumps(tenant)+')throw Error("Foreign runtime context");'
    if action=='create':
        script+='if(u||d.getCollectionNames().length)throw Error("Runtime namespace already exists");d.createUser({user:'+json.dumps(name)+',pwd:'+json.dumps(password)+',roles:[{role:"read",db:'+json.dumps(name)+'}],customData:{fixture:'+json.dumps(tenant)+'}});'
    elif action=='verify':
        script+='if(!u)throw Error("Missing owned runtime context");'+owned+'if(u.roles.length!==1||u.roles[0].role!=="read"||u.roles[0].db!=='+json.dumps(name)+'||d.getCollectionNames().length)throw Error("Runtime context is not empty and read-only");'
    elif action=='drop':
        script+='if(u){'+owned+'d.dropUser(u.user);d.dropDatabase();}'
    else:raise ValueError('Unknown runtime fixture action')
    with log_path.open('a') as output:
        demo.compose('exec','-T','mongo','mongosh','--quiet','--file','/dev/stdin',input=script,text=True,stdout=output,stderr=output)
    return 'mongodb://'+name+':'+password+'@127.0.0.1:27028/'+name+'?authSource='+name

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument("--saas-enrollment",action="store_true");args=parser.parse_args()
    os.umask(0o077);demo.prepare()
    root=demo.LOCAL/('portable-deployment-'+uuid.uuid4().hex[:10]);root.mkdir(mode=0o700)
    tenant=uuid.uuid4().hex;slug='portable-'+tenant[:10];database='portable_worker_test_'+tenant
    original=json.loads((demo.LOCAL/'tenantmanager.json').read_text());credentials=json.loads((demo.LOCAL/'credentials.json').read_text())
    security=copy.deepcopy(original['PlatformSecurity']);security['Provider']='AesGcm';security['AesGcm']={'MasterKeyFile':security.pop('Local')['MasterKeyFile']}
    security['ConnectionString']=f'Host=127.0.0.1;Port=15439;Database={database};Username=commerce_demo;Password={credentials["postgres"]}';security['InitializeSchema']=True
    project=demo.ROOT/'tests/Portable.Provisioning.Integration/Portable.Provisioning.Integration.csproj'
    with (demo.LOCAL/'logs/build-portable-deployment-fixture.log').open('w') as log:subprocess.run(['dotnet','build',str(project),'-c','Release','--nologo'],cwd=demo.ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
    with (demo.LOCAL/'logs/build-portable-gateway.log').open('w') as log:subprocess.run(['dotnet','publish','tools/Platform.Gateway/Platform.Gateway.csproj','-c','Release','--nologo','-o',str(demo.LOCAL/'runtime/portable-gateway'),'-p:UseAppHost=false','--verbosity','quiet'],cwd=demo.ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
    installer_runtime=root/'installer-runtime'
    with (demo.LOCAL/'logs/build-portable-installer.log').open('w') as log:
        subprocess.run(['dotnet','publish','src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj','-c','Release','--nologo','-o',str(installer_runtime),'-p:UseAppHost=false','--verbosity','quiet'],cwd=demo.ROOT/'Ecommerce',stdout=log,stderr=subprocess.STDOUT,check=True)
    for relative in ['wwwroot/logo.png','App_Data/Resources/Installation/installation.en.xml','App_Data/Resources/Installation/installation.pl.xml','App_Data/Resources/supportedcollation.xml']:
        check((installer_runtime/relative).is_file(),'The ordinary fresh installer publish contains '+relative)
    children=[];native=None;created=False;saas_created=False;portal="https://portal.example.test:18084";saas_database="portable_saas_test_"+tenant;second_tenant=uuid.uuid4().hex;trial_plan=uuid.uuid4().hex
    runtime_context_created=False;runtime_context_password=secrets.token_hex(32);runtime_context_log=root/'runtime-context.log'
    saas_runtime=root/'saas-runtime'
    if args.saas_enrollment:
        for label,command,cwd in [
            ("saas-fixture",["dotnet","build",str(demo.ROOT/"tests/Portable.Services.Integration/Portable.Services.Integration.csproj"),"-c","Release","--nologo","--verbosity","quiet"],demo.ROOT/"SaasManager"),
            ("saas",["dotnet","publish","src/Web/Web.csproj","-c","Release","--nologo","-o",str(saas_runtime),"-p:UseAppHost=false","--verbosity","quiet"],demo.ROOT/"SaasManager")
        ]:
            with (demo.LOCAL/"logs"/("build-enrollment-"+label+".log")).open("w") as output:subprocess.run(command,cwd=cwd,stdout=output,stderr=subprocess.STDOUT,check=True)
    try:
        runtime_context_created=True
        runtime_connection=empty_runtime_database(tenant,credentials,runtime_context_password,'create',runtime_context_log)
        security.setdefault('BootstrapSecrets',{})['applicationdb']=runtime_connection
        with https_identity(root,provisioning=True,owner_count=2 if args.saas_enrollment else 1,portal_url=portal if args.saas_enrollment else "https://localhost:18084") as identity, synthetic_dns(18444,portal=args.saas_enrollment) as proxy:
            cert=root/'ingress.crt';key=root/'ingress.key';csr=root/'ingress.csr';extensions=root/'ingress-extensions.cnf';pfx=root/'ingress.pfx';password=root/'ingress-password'
            password.write_text(secrets.token_urlsafe(32));extensions.write_text('basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:localhost,DNS:portal.example.test,DNS:*.shops.example.test,DNS:*.manage.example.test\n')
            for command in [
                ['openssl','req','-new','-newkey','rsa:2048','-nodes','-keyout',str(key),'-out',str(csr),'-subj','/CN=PortableIngressTest'],
                ['openssl','x509','-req','-in',str(csr),'-CA',str(identity['root']),'-CAkey',str(root/'identity-ca.key'),'-CAcreateserial','-out',str(cert),'-days','1','-sha256','-extfile',str(extensions)],
                ['openssl','pkcs12','-export','-out',str(pfx),'-inkey',str(key),'-in',str(cert),'-passout','file:'+str(password)]
            ]:subprocess.run(command,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            settings=copy.deepcopy(original['Provisioning']['Local'])
            for name in ('KeycloakAdminUsername','KeycloakAdminPassword','SecretDirectory'):settings.pop(name,None)
            for name in ('WorkingDirectory','TenantDirectory','RouteDirectory','NotificationDirectory','MobileDirectory'):settings[name]=str(root/name);(root/name).mkdir(mode=0o700)
            authority=identity['authority'].split('/realms/')[0]
            settings.update(InstallerPath=str(installer_runtime/'Grand.Installer.Cli.dll'),DeploymentId='portable-runtime-smoke',StoreBaseUrl='https://shops.example.test:18444',AdminBaseUrl='https://manage.example.test:18444',
                KeycloakAuthority=authority,KeycloakRealm='commerce-demo',KeycloakAdminRealm='commerce-demo',KeycloakAdminClientId=identity['provisioningClientId'],KeycloakAdminClientSecret=identity['provisioningClientSecret'],IdentityRootCertificateFile=str(identity['root']),IngressRootCertificateFile=str(identity['root']))
            commerce=copy.deepcopy(json.loads((demo.LOCAL/'commerce.json').read_text()))
            commerce.update(PlatformSecurity=security,LocalDemo={'Enabled':False},PlatformConfiguration={'Provider':'Environment'},Notifications={'Provider':'Disabled'},AllowedHosts='localhost;127.0.0.1;*.shops.example.test;*.manage.example.test',
                Proxy={'Enabled':True,'KnownProxies':['127.0.0.1','::1'],'ForwardLimit':1},Provisioning={'ReadinessEndpoint':True})
            commerce['Database']['ConnectionString']=runtime_connection
            commerce['Application'].update(DisableHostedService=True,SkipMigrationProcess=True)
            commerce['AuthConfiguration'].update(IdentityProviderUrl=identity['authority'],AuthorityRootCertificateFile=str(identity['root']))
            commerce.setdefault('Logging',{}).setdefault('LogLevel',{})['Microsoft.Hosting.Lifetime']='Information'
            installer_config=root/'installer.json';demo.write_json(installer_config,commerce);settings['CommerceConfigPath']=str(installer_config)
            runtime=copy.deepcopy(commerce);runtime['PlatformSecurity'].update(ReadOnly=True,InitializeSchema=False)
            commerce_path=root/'commerce.json';demo.write_json(commerce_path,runtime)
            admin=copy.deepcopy(runtime);admin['TenantRouting']={'Provider':'Directory','RouteDirectory':settings['RouteDirectory'],'AdminParentDomains':['manage.example.test']}
            admin_path=root/'admin.json';demo.write_json(admin_path,admin)
            gateway={'Gateway':{'Provider':'Directory','RouteDirectory':settings['RouteDirectory'],'StoreBaseUrl':settings['StoreBaseUrl'],'AdminBaseUrl':settings['AdminBaseUrl'],
                'CommerceUpstream':'http://127.0.0.1:18182','AdminUpstream':'http://127.0.0.1:18183','AllowHttpUpstreams':True,'IdentityAuthority':authority,'IdentityRealm':'commerce-demo','IdentityRootCertificateFile':str(identity['root'])},
                'PlatformSecurity':runtime['PlatformSecurity'],'LocalDemo':{'Enabled':False},'AllowedHosts':'localhost;*.shops.example.test;*.manage.example.test',
                'Kestrel':{'Certificates':{'Default':{'Path':str(pfx),'Password':password.read_text()}}},'Logging':{'LogLevel':{'Default':'Warning','Microsoft.Hosting.Lifetime':'Information'}}}
            gateway_path=root/'gateway.json';demo.write_json(gateway_path,gateway)
            config={'PlatformSecurity':security,'LocalDemo':{'Enabled':False},'Provisioning':{'Enabled':True,'InitializeSchema':True,'Profile':'Portable','Portable':settings,'Google':{'Provider':'Disabled'},'Domains':{'Provider':'Wildcard','WildcardConfigured':True},'Worker':{'MaxAttempts':1,'PollInterval':'00:00:01'}},
                'Fixture':{'TenantId':tenant,'Slug':slug,'AdminPassword':'Şifre-İstanbul-🔐-'+secrets.token_urlsafe(20),'WorkerDll':str(demo.LOCAL/'runtime/worker/TenantManager.dll'),'ExpectPublicReady':True,'BootstrapSecrets':security.get('BootstrapSecrets',{})}}
            if args.saas_enrollment:
                config['Fixture'].update(ExternalEnrollment=True,SecondTenantId=second_tenant,TrialPlanId=trial_plan,EnrollmentTenants=[tenant,second_tenant],SaasRuntimePassword=secrets.token_hex(32))
                config['Bootstrap']={'DeploymentId':settings['DeploymentId'],'AllowSchemaChanges':True,'TrialPlan':{'Id':trial_plan,'Name':'Portable enrollment trial','Code':'PORTABLE_FIXTURE','Price':299,'TrialDays':14,'MaxProducts':100,'MaxUsers':3,'MaxMonthlyOrders':1000,'Features':['Catalog']}}
                config['TenantOnboarding']={'Trial':{'Enabled':True,'PlanId':trial_plan}}
                config['ConnectionStrings']={'SaasManagerDb':f'Host=127.0.0.1;Port=15439;Database={saas_database};Username=commerce_demo;Password={credentials["postgres"]}'}
                saas=copy.deepcopy(json.loads((demo.LOCAL/'saas.json').read_text()));saas['PlatformSecurity']=copy.deepcopy(security);saas['PlatformSecurity'].update(InitializeSchema=False,ReadOnly=False)
                saas.update(LocalDemo={'Enabled':False},DatabaseBootstrap={'Mode':'External'},PlatformConfiguration={'Provider':'Environment'},ApplicationUrl=portal,AllowedHosts='portal.example.test',ConnectionStrings=config['ConnectionStrings'],CardProtection={'Provider':'Disabled'},
                    Provisioning={'Enabled':True,'InitializeSchema':False,'Profile':'Portable','DeploymentId':settings['DeploymentId']},TenantOnboarding={'Trial':{'Enabled':True,'PlanId':trial_plan}},
                    FileStorage={'Provider':'FileSystem','FileSystem':{'RootDirectory':str(root/'SaasFiles')}},Web={'AllowedOrigins':[portal],'DataProtectionKeyDirectory':str(root/'SaasCookieKeys'),'DataProtectionApplicationName':'portable-enrollment-'+tenant},
                    Kestrel={'Certificates':{'Default':{'Path':str(pfx),'Password':password.read_text()}}},Diagnostics={'DatabaseQueries':{'Enabled':False}},Logging={'LogLevel':{'Default':'Warning','Microsoft.Hosting.Lifetime':'Information'}})
                runtime_identity='Username=portable_saas_runtime_'+tenant+';Password='+config['Fixture']['SaasRuntimePassword']
                saas['ConnectionStrings']={'SaasManagerDb':f'Host=127.0.0.1;Port=15439;Database={saas_database};'+runtime_identity}
                saas['PlatformSecurity']['ConnectionString']=f'Host=127.0.0.1;Port=15439;Database={database};'+runtime_identity
                saas['AuthConfiguration'].update(IdentityProviderUrl=identity['authority'],AuthorityRootCertificateFile=str(identity['root']),ClientSecret=saas.pop('ClientSecret-centraladminapp'),Scopes=['openid','profile','email','roles'])
                saas['GuestAuth'].update(Issuer=portal,Audience=portal);saas_path=root/'saas.json';demo.write_json(saas_path,saas)
            config_path=root/'worker.json';demo.write_json(config_path,config)
            demo.compose('exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','CREATE DATABASE '+database,stdout=subprocess.DEVNULL);created=True
            env=dict(os.environ,DOTNET_ENVIRONMENT='Production',ASPNETCORE_ENVIRONMENT='Production',LocalDemo__Enabled='false',HTTPS_PROXY=proxy,https_proxy=proxy,NO_PROXY='localhost,127.0.0.1',no_proxy='localhost,127.0.0.1')
            fixture_dll=demo.ROOT/'tests/Portable.Services.Integration/bin/Release/net9.0/Portable.Services.Integration.dll'
            if args.saas_enrollment:
                demo.compose('exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','CREATE DATABASE '+saas_database,stdout=subprocess.DEVNULL);saas_created=True
                with (root/'saas-initialization.log').open('w') as output:subprocess.run(['dotnet',str(fixture_dll),'--enrollment-database','init',str(config_path)],cwd=demo.ROOT/'SaasManager',env=env,stdout=output,stderr=subprocess.STDOUT,check=True)
            fixture_log=(root/'fixture.log').open('w')
            native=subprocess.Popen(['dotnet',str(project.parent/'bin/Release/net8.0/Portable.Provisioning.Integration.dll'),str(config_path)],cwd=demo.ROOT,env=env,stdin=subprocess.PIPE,stdout=fixture_log,stderr=subprocess.STDOUT,text=True,start_new_session=True)
            wait_process(native,lambda:(root/'initialized.json').exists(),'Fixture schema initialization')
            components=[('commerce',commerce_path,18182,'Grand.Web.MultiTenant.dll'),('admin',admin_path,18183,'Grand.Web.OnlyAdmin.dll'),('portable-gateway',gateway_path,18444,'Platform.Gateway.dll')]
            if args.saas_enrollment:components.append(('saas',saas_path,18084,'SaasManager.Web.dll'))
            for name,path,port,dll in components:
                directory=saas_runtime if name=='saas' else demo.LOCAL/'runtime'/name;log=root/(name+'.log');child_env=dict(env,ASPNETCORE_URLS=('https' if name in ('portable-gateway','saas') else 'http')+'://127.0.0.1:'+str(port),PlatformConfiguration__ConfigPath=str(path),Gateway__ConfigPath=str(path))
                with log.open('w') as output:process=subprocess.Popen(['dotnet',str(directory/dll)],cwd=directory,env=child_env,stdout=output,stderr=subprocess.STDOUT,start_new_session=True)
                children.append(process);wait_process(process,lambda path=log:production_started(path),name+' Production host')
                check('Hosting environment: Production' in log.read_text(),name+' confirms Production with LocalDemo disabled')
            empty_runtime_database(tenant,credentials,runtime_context_password,'verify',runtime_context_log)
            check(True,'Production commerce/admin start before any tenant is installed, using only an empty read-only default context')
            native.stdin.write('provision\n');native.stdin.flush()
            if args.saas_enrollment:
                wait_process(native,lambda:(root/'worker-started.json').exists(),'Actual Production enrollment worker')
                from portable_saas_enrollment import enroll,verify
                sessions=enroll(portal,identity,proxy,[tenant,second_tenant],config['Fixture']['AdminPassword'])
            wait_process(native,lambda:(root/'ready-result.json').exists(),'Actual worker/public tenant readiness',240)
            if args.saas_enrollment:
                verify(portal,sessions)
                with (root/'saas-verification.log').open('w') as output:subprocess.run(['dotnet',str(fixture_dll),'--enrollment-database','verify',str(config_path)],cwd=demo.ROOT/'SaasManager',env=env,stdout=output,stderr=subprocess.STDOUT,check=True)
                print((root/'saas-initialization.log').read_text(),end='',flush=True);print((root/'saas-verification.log').read_text(),end='',flush=True)
            result=json.loads((root/'ready-result.json').read_text());owner_email=result.get('ownerEmail',slug+'@example.test');context=ssl.create_default_context(cafile=str(identity['root']));jar=http.cookiejar.CookieJar()
            browser=urllib.request.build_opener(urllib.request.ProxyHandler({'https':proxy}),urllib.request.HTTPSHandler(context=context),urllib.request.HTTPCookieProcessor(jar),NoRedirect())
            def request(url,data=None,headers=None):
                try:response=browser.open(urllib.request.Request(url,data,headers or {}),timeout=30)
                except urllib.error.HTTPError as error:response=error
                with response:return response.code,response.headers,response.read().decode()
            code,headers,body=request(result['storeUrl']+'/_platform/ready?store_token=forged',headers={'x-store-token':'forged','X-Forwarded-Proto':'ftp','X-Platform-Tenant':'foreign'})
            check(code==200 and json.loads(body)=={'tenantId':tenant,'storeId':result['storeId']},'Public HTTPS gateway obtains the real tenant token and ignores forged caller credentials')
            check('no-store' in headers.get('Cache-Control','') and not headers.get('x-store-token'),'Public readiness exposes only identifiers and no internal tenant token')
            code,_,body=request(result['storeUrl']+'/');check(code==200 and '<html' in body.lower(),'Real Production storefront HTML renders through the gateway')
            code,_,body=request(result['storeUrl']+'/TenantTokenWeb/guest',b'',{'Content-Type':'application/json','Accept':'application/json','X-Response-View':'Json'})
            check(code==200 and 'AccessToken' in json.loads(body),'Production tenant issues a mobile customer guest token')
            customer_tokens=json.loads(body);customer=customer_tokens['AccessToken'];code,_,body=request(result['storeUrl']+'/Component/HomePageProducts',headers={'Accept':'application/json','X-Response-View':'Json','Authorization':'Bearer '+customer})
            check(code==200 and isinstance(json.loads(body),list),'Gateway preserves the customer bearer token for the real tenant catalog')
            code,headers,_=request(result['adminUrl']);location=urllib.parse.urljoin(result['adminUrl'],headers.get('Location',''))
            check(code==302 and location.startswith(result['adminUrl'].rsplit('/Admin',1)[0]+'/'),'Production admin redirects to its own HTTPS login')
            code,_,page=request(location)
            class Fields(HTMLParser):
                def __init__(self):super().__init__();self.values={}
                def handle_starttag(self,tag,attrs):
                    attrs=dict(attrs)
                    if tag=='input' and attrs.get('type')=='hidden' and attrs.get('name'):self.values[attrs['name']]=attrs.get('value','')
            fields=Fields();fields.feed(page);form=dict(fields.values,Email=owner_email,Password=config['Fixture']['AdminPassword'],RememberMe='false')
            admin_origin=result['adminUrl'].rsplit('/Admin',1)[0]
            code,headers,_=request(admin_origin+'/admin/login',urllib.parse.urlencode(form).encode(),{'Content-Type':'application/x-www-form-urlencoded'})
            check(code in (302,303) and 'login' not in headers.get('Location','').lower(),'The newly provisioned owner signs into the real Production tenant administration')
            code,_,page=request(urllib.parse.urljoin(admin_origin+'/',headers.get('Location','/Admin')));check(code==200 and 'logout' in page.lower(),'Production tenant dashboard loads after actual password authentication')
            check(any(cookie.secure and cookie.domain==urllib.parse.urlparse(admin_origin).hostname for cookie in jar),'Tenant session cookies remain Secure and scoped to the owned public host')
            for token_route in ('TenantTokenWeb','TokenWeb'):
                endpoint=result['storeUrl']+'/'+token_route+'/login'
                code,_,body=request(endpoint,json.dumps({'Email':owner_email,'Password':base64.b64encode(b'deliberately-wrong-password').decode()}).encode(),{'Content-Type':'application/json'})
                check(code==401 and 'AccessToken' not in body,token_route+' rejects an incorrect password without issuing a customer session')
                code,_,body=request(endpoint,json.dumps({'Email':owner_email,'Password':base64.b64encode(config['Fixture']['AdminPassword'].encode()).decode()}).encode(),{'Content-Type':'application/json'})
                check(code==200 and 'AccessToken' in json.loads(body),token_route+' verifies the actual installed owner password before issuing a session')
                code,_,body=request(endpoint,json.dumps({'Email':'unknown-customer@example.test','Password':base64.b64encode(b'deliberately-wrong-password').decode()}).encode(),{'Content-Type':'application/json'})
                check(code==401 and 'AccessToken' not in body,token_route+' safely rejects an unknown account')
                code,_,body=request(endpoint,json.dumps({'Email':owner_email,'Password':'%%%'}).encode(),{'Content-Type':'application/json'})
                check(code==400 and 'AccessToken' not in body and 'Exception' not in body,token_route+' rejects malformed mobile password encoding with a safe validation error')
            stop(children[1]);admin_log=root/'admin-restarted.log';admin_run=demo.LOCAL/'runtime/admin'
            admin_env=dict(env,ASPNETCORE_URLS='http://127.0.0.1:18183',PlatformConfiguration__ConfigPath=str(admin_path))
            with admin_log.open('w') as output:restarted=subprocess.Popen(['dotnet',str(admin_run/'Grand.Web.OnlyAdmin.dll')],cwd=admin_run,env=admin_env,stdout=output,stderr=subprocess.STDOUT,start_new_session=True)
            children.append(restarted);wait_process(restarted,lambda:production_started(admin_log),'Restarted Production administration')
            code,_,page=request(result['adminUrl']);check(code==200 and 'logout' in page.lower(),'The authenticated tenant admin session survives an independent Production process restart')
            unknown='https://unknown-shop.shops.example.test:18444/_platform/ready';check(request(unknown)[0]==404,'Unknown public tenant hosts cannot fall back to a default database')
            second=result['second'];code,_,body=request(second['storeUrl']+'/_platform/ready');check(code==200 and json.loads(body)=={'tenantId':second['tenantId'],'storeId':second['storeId']},'Second public HTTPS host selects its own newly installed store')
            # Catalog listings are intentionally public; use token refresh to verify the authentication boundary.
            code,_,_=request(second['storeUrl']+'/TenantTokenWeb/refresh',json.dumps(customer_tokens).encode(),{'Content-Type':'application/json'});check(code in (400,401,403),'A mobile customer token from the first Production tenant cannot refresh a session in the second tenant')
            code,_,body=request(result['storeUrl']+'/TenantTokenWeb/refresh',json.dumps(customer_tokens).encode(),{'Content-Type':'application/json'});check(code==200 and 'AccessToken' in json.loads(body),'The same valid mobile session still refreshes in its own Production tenant')
            for token_route in ('TenantTokenWeb','TokenWeb'):
                code,_,body=request(second['storeUrl']+'/'+token_route+'/login',json.dumps({'Email':owner_email,'Password':base64.b64encode(config['Fixture']['AdminPassword'].encode()).decode()}).encode(),{'Content-Type':'application/json'})
                check(code==401 and 'AccessToken' not in body,token_route+' cannot authenticate an owner from another tenant database')
            foreign_cookie='; '.join(cookie.name+'='+cookie.value for cookie in jar if cookie.domain==urllib.parse.urlparse(admin_origin).hostname)
            code,headers,_=request(second['adminUrl'],headers={'Cookie':foreign_cookie});check(code in (302,401,403) and (code!=302 or 'login' in headers.get('Location','').lower()),'A forged cross-host admin cookie does not authenticate in another Production tenant')
            mobile=json.loads((Path(settings['MobileDirectory'])/(slug+'.json')).read_text());check(mobile['localDemo'] is False and mobile['baseUrl']==result['storeUrl'],'Published mobile configuration selects the real HTTPS tenant with LocalDemo disabled')
            logs=''.join(path.read_text(errors='replace') for path in root.glob('*.log'));check(config['Fixture']['AdminPassword'] not in logs and identity['provisioningClientSecret'] not in logs,'Runtime diagnostics do not expose the owner password or provisioning credential')
            native.stdin.write('done\n');native.stdin.flush();native.wait(timeout=30);fixture_log.close()
            print((root/'fixture.log').read_text(),end='',flush=True)
            check(native.returncode==0,'Actual worker and resource fixture finish cleanly')
            empty_runtime_database(tenant,credentials,runtime_context_password,'verify',runtime_context_log)
            check(True,'Actual tenant installation and login leave the unseeded runtime context empty and read-only')
            print('Portable public Production deployment checks passed.',flush=True)
    finally:
        if native and native.poll() is None:
            try:native.stdin.write('done\n');native.stdin.flush();native.wait(timeout=20)
            except (OSError,subprocess.TimeoutExpired):stop(native)
        for process in reversed(children):stop(process)
        if saas_created:
            demo.compose('exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','DROP DATABASE IF EXISTS '+saas_database+' WITH (FORCE)',stdout=subprocess.DEVNULL)
        if created:
            # Only this invocation's random namespace is eligible for cleanup; validate remote ownership before deleting.
            owned_file=root/'owned-tenants.json';owned=json.loads(owned_file.read_text()) if owned_file.exists() else [tenant]
            if not isinstance(owned,list) or not 1<=len(owned)<=2 or tenant not in owned or any(not isinstance(value,str) or uuid.UUID(value).hex!=value for value in owned):raise RuntimeError('Unsafe fixture cleanup metadata')
            for owned_tenant in owned:
                cleanup='const a=db.getSiblingDB("admin");a.auth("commerce_demo_root",'+json.dumps(credentials['mongo_root'])+');const d=db.getSiblingDB('+json.dumps('tenant_'+owned_tenant)+');const u=d.getUser('+json.dumps('tenant_'+owned_tenant)+');if(u){if(!u.customData||u.customData.platformTenantId!=='+json.dumps(owned_tenant)+')throw Error("Foreign fixture ownership");d.dropUser(u.user);d.dropDatabase();}'
                demo.compose('exec','-T','mongo','mongosh','--quiet','--file','/dev/stdin',input=cleanup,text=True,stdout=subprocess.DEVNULL)
            demo.compose('exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','DROP DATABASE IF EXISTS '+database+' WITH (FORCE)',stdout=subprocess.DEVNULL)
        if runtime_context_created:
            empty_runtime_database(tenant,credentials,runtime_context_password,'drop',runtime_context_log)
        if args.saas_enrollment:
            runtime_role='portable_saas_runtime_'+tenant
            cleanup_role="DO $owned$ BEGIN IF EXISTS(SELECT 1 FROM pg_catalog.pg_roles r WHERE r.rolname='"+runtime_role+"' AND pg_catalog.shobj_description(r.oid,'pg_authid')='portable-saas-fixture:"+tenant+"') THEN EXECUTE 'DROP ROLE "+runtime_role+"'; END IF; END $owned$;"
            demo.compose('exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c',cleanup_role,stdout=subprocess.DEVNULL)

if __name__=='__main__':
    signal.signal(signal.SIGTERM,lambda *_:sys.exit(143))
    try:main()
    except Exception as error:print('FAIL:',type(error).__name__,str(error)[:180],file=sys.stderr);sys.exit(1)
