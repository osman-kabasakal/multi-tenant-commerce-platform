#!/usr/bin/env python3
"""Verify public gateway readiness uses a verified tenant JWT and the real tenant database."""
import json, sys
import demo, smoke
from smoke_onboarding import check

def main():
    tokens={}
    for slug in demo.SLUGS:
        host=slug+'.localhost:18090';expected=json.loads((demo.LOCAL/'tenants'/(slug+'.json')).read_text())
        code,headers,body=smoke.request(18090,'/_platform/ready',host)
        payload=json.loads(body) if code==200 else {}
        check(code==200 and payload.get('storeId')==expected['storeId'],'Public gateway readiness resolves the actual '+slug+' store')
        check(set(payload)=={'tenantId','storeId'} and 'no-store' in headers.get('Cache-Control',''),'Readiness reveals no database credentials and is not cached')
        check(smoke.request(18082,'/_platform/ready',slug+'.localhost:18082')[0]==400,'Direct readiness without a verified tenant token is rejected')
        tokens[slug]=demo.request_json(demo.IDENTITY+'/realms/commerce-demo/protocol/openid-connect/token',
            {'grant_type':'client_credentials','client_id':slug,'client_secret':demo.secret('ClientSecret-'+slug)},form=True)['access_token']
    check(smoke.request(18082,'/_platform/ready','demo-b.localhost:18082',tokens['demo-a'])[0]==400,'Readiness refuses a token from the other tenant')
    check(smoke.request(18090,'/_platform/ready','unknown.localhost:18090')[0] in (400,404),'Readiness refuses an unpublished hostname')
    print('Tenant readiness HTTP checks passed.',flush=True)

if __name__=='__main__':
    try:main()
    except Exception as error:
        print('FAIL:',type(error).__name__,str(error)[:160],file=sys.stderr);sys.exit(1)
