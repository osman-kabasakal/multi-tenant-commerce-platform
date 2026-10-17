import {TestBed} from '@angular/core/testing';
import {provideHttpClient} from '@angular/common/http';
import {HttpTestingController, provideHttpClientTesting} from '@angular/common/http/testing';
import {provideRouter} from '@angular/router';
import {TenantDeploymentComponent} from './tenant-deployment.component';

const state = () => ({businessId: '11111111-1111-1111-1111-111111111111', ownerId: '22222222-2222-2222-2222-222222222222', businessName: 'Test Store',
  domainEnabled: false, identityEnabled: true, canChange: true, blockReason: null, storeUrl: 'https://shop.example.org', adminUrl: 'https://manage.shop.example.org/Admin',
  proposedPackageName: 'com.publisher.newstore', domains: [], identities: [{id: '33333333-3333-3333-3333-333333333333', packageName: 'com.example.old', iosBundleId: 'com.example.old', state: 'Active', isActive: true, androidReady: true, iosReady: false, androidCertificateSha256: null, iosCertificateSha256: null, storeUrl: 'https://shop.example.org', errorCode: null, updatedAt: new Date().toISOString()}]});

describe('Tenant deployment actions', () => {
  let http: HttpTestingController;
  beforeEach(() => {
    TestBed.configureTestingModule({imports: [TenantDeploymentComponent], providers: [provideHttpClient(), provideHttpClientTesting(), provideRouter([])]});
    http = TestBed.inject(HttpTestingController); localStorage.clear();
  });
  afterEach(() => http.verify());
  function page() {
    const fixture = TestBed.createComponent(TenantDeploymentComponent); fixture.detectChanges();
    http.expectOne('/api/TenantDeployment/availability').flush({enabled: true});
    http.expectOne('/api/TenantDeployment/configuration').flush({requestToken: 'synthetic-csrf'});
    http.expectOne('/api/TenantDeployment').flush(state()); fixture.detectChanges();
    return fixture;
  }
  it('shows the current identity while a new Android build waits for iOS', () => {
    const f = page(); const value = state();
    value.identities.push({...value.identities[0], id: '44444444-4444-4444-4444-444444444444', packageName: 'com.publisher.newstore', iosBundleId: 'com.publisher.newstore', state: 'WaitingBuilds', isActive: false});
    f.componentInstance.state = value; f.detectChanges();
    expect(f.componentInstance.changingIdentity).toBeTrue();
    expect(f.componentInstance.state.identities.find(x => x.isActive)?.packageName).toBe('com.example.old');
    expect(f.nativeElement.textContent).toContain('Derlemeler bekleniyor');
    f.componentInstance.createIdentity(); http.expectNone('/api/TenantDeployment/identity'); f.destroy();
  });
  it('sends an explicit stable request with a CSRF token for a new identity', () => {
    const f = page(); f.componentInstance.createIdentity();
    const first = http.expectOne('/api/TenantDeployment/identity');
    const id = first.request.body.requestId;
    expect(first.request.headers.get('X-XSRF-TOKEN')).toBe('synthetic-csrf');
    expect(id).toMatch(/^[a-f0-9-]{36}$/);
    first.flush({message: 'Temporary failure'}, {status: 503, statusText: 'Unavailable'});
    http.expectOne('/api/TenantDeployment').flush(state());
    f.componentInstance.createIdentity(); const retry = http.expectOne('/api/TenantDeployment/identity');
    expect(retry.request.body.requestId).toBe(id); retry.flush({}); http.expectOne('/api/TenantDeployment').flush(state()); f.destroy();
  });
  it('cannot activate a domain while a previous domain migration is running', () => {
    const f = page(); f.componentInstance.state!.domains = [{domain: {id: 'domain', tenantId: 'tenant', domain: 'shop.example.org', storeUrl: '', adminUrl: '', state: 'Verified', challengeName: '', challengeValue: '', expiresAt: '', errorCode: null, message: null, isPrimary: false}, activation: {state: 'Running', steps: {}, errorCode: null}}];
    expect(f.componentInstance.changingDomain).toBeTrue();
    f.componentInstance.activate('domain'); http.expectNone('/api/TenantDeployment/domain'); f.destroy();
  });
  it('preserves the existing mobile identity when combined signing is unavailable', () => {
    const f = page(); f.componentInstance.state!.identityEnabled = false;
    f.componentInstance.activate('11111111-1111-1111-1111-111111111111');
    const activation = http.expectOne('/api/TenantDeployment/domain');
    expect(activation.request.body.createMobileIdentity).toBeFalse();
    activation.flush({}); http.expectOne('/api/TenantDeployment').flush(state()); f.destroy();
  });
});
