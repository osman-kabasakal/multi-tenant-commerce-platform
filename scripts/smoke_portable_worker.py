#!/usr/bin/env python3
"""Real Production installer, Mongo isolation and scoped HTTPS Keycloak; public ingress stays gated."""
import copy, json, os, secrets, signal, subprocess, sys, uuid
from pathlib import Path
import demo
from portable_test_identity import https_identity

def main():
    os.umask(0o077);demo.prepare()
    root=demo.LOCAL/('portable-worker-'+uuid.uuid4().hex[:10]);root.mkdir(mode=0o700)
    project=demo.ROOT/'tests/Portable.Provisioning.Integration/Portable.Provisioning.Integration.csproj'
    with (demo.LOCAL/'logs/build-portable-worker-fixture.log').open('w') as log:
        subprocess.run(['dotnet','build',str(project),'-c','Release','--nologo'],cwd=demo.ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
    with https_identity(root,provisioning=True) as identity:
        original=json.loads((demo.LOCAL/'tenantmanager.json').read_text());settings=copy.deepcopy(original['Provisioning']['Local']);credentials=json.loads((demo.LOCAL/'credentials.json').read_text())
        tenant=uuid.uuid4().hex;database='portable_worker_test_'+tenant
        connection=f'Host=127.0.0.1;Port=15439;Database={database};Username=commerce_demo;Password={credentials["postgres"]}'
        security=copy.deepcopy(original['PlatformSecurity']);security['Provider']='AesGcm';security['AesGcm']={'MasterKeyFile':security.pop('Local')['MasterKeyFile']};security['ConnectionString']=connection;security['InitializeSchema']=True
        commerce=json.loads((demo.LOCAL/'commerce.json').read_text());commerce.update(PlatformSecurity=security,LocalDemo={'Enabled':False},PlatformConfiguration={'Provider':'Environment'})
        child=root/'commerce.json';demo.write_json(child,commerce)
        for key in ('KeycloakAdminUsername','KeycloakAdminPassword','SecretDirectory'):settings.pop(key,None)
        for key in ('WorkingDirectory','TenantDirectory','RouteDirectory','NotificationDirectory','MobileDirectory'):settings[key]=str(root/key)
        settings.update(DeploymentId='portable-smoke',CommerceConfigPath=str(child),StoreBaseUrl='https://shops.example.test',AdminBaseUrl='https://manage.example.test',
            KeycloakAuthority=identity['authority'].split('/realms/')[0],KeycloakRealm='commerce-demo',KeycloakAdminRealm='commerce-demo',
            KeycloakAdminClientId=identity['provisioningClientId'],KeycloakAdminClientSecret=identity['provisioningClientSecret'],IdentityRootCertificateFile=str(identity['root']))
        config={'PlatformSecurity':security,'LocalDemo':{'Enabled':False},'Provisioning':{'Enabled':True,'InitializeSchema':True,'Profile':'Portable','Portable':settings,
            'Google':{'Provider':'Disabled'},'Domains':{'Provider':'Wildcard','WildcardConfigured':True}},'Fixture':{'TenantId':tenant,'Slug':'portable-'+tenant[:10],'AdminPassword':secrets.token_urlsafe(28),'WorkerDll':str(demo.LOCAL/'runtime/worker/TenantManager.dll')}}
        path=root/'worker.json';demo.write_json(path,config)
        subprocess.run(['docker','compose','--env-file',str(demo.LOCAL/'compose.env'),'-f',str(demo.ROOT/'compose.yaml'),'exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','CREATE DATABASE '+database],check=True,stdout=subprocess.DEVNULL)
        env=dict(os.environ,DOTNET_ENVIRONMENT='Production',ASPNETCORE_ENVIRONMENT='Production',NO_PROXY='localhost,127.0.0.1,.example.test',no_proxy='localhost,127.0.0.1,.example.test')
        dll=project.parent/'bin/Release/net8.0/Portable.Provisioning.Integration.dll'
        process=subprocess.Popen(['dotnet',str(dll),str(path)],cwd=demo.ROOT,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
        try:
            stdout,stderr=process.communicate(timeout=240)
        except BaseException:
            if process.poll() is None:
                os.killpg(process.pid,signal.SIGTERM)
                try:process.communicate(timeout=10)
                except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.communicate(timeout=5)
            raise
        finally:
            subprocess.run(['docker','compose','--env-file',str(demo.LOCAL/'compose.env'),'-f',str(demo.ROOT/'compose.yaml'),'exec','-T','postgres','psql','-U','commerce_demo','-d','postgres','-v','ON_ERROR_STOP=1','-c','DROP DATABASE IF EXISTS '+database+' WITH (FORCE)'],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
        (demo.LOCAL/'logs/portable-worker-resource-checks.log').write_text(stdout+stderr)
        print(stdout,end='',flush=True)
        if process.returncode:raise RuntimeError('Production worker resource check failed; inspect the private resource-check log.')

if __name__=='__main__':
    signal.signal(signal.SIGTERM,lambda *_:sys.exit(143))
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
