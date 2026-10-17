import {ComponentFixture, fakeAsync, TestBed, tick} from '@angular/core/testing';
import {HttpClientTestingModule, HttpTestingController} from '@angular/common/http/testing';
import {TenantDomainOwnershipComponent, TenantDomainSelection, TenantDomainView} from './tenant-domain-ownership.component';

describe('TenantDomainOwnershipComponent', () => {
  let fixture: ComponentFixture<TenantDomainOwnershipComponent>;
  let component: TenantDomainOwnershipComponent;
  let http: HttpTestingController;
  let selections: TenantDomainSelection[];
  const registrationId = '6662416e-2715-45f8-8ae8-eff09443e8fa';
  const requestId = '9d53235f-f540-4349-aa61-31c530451301';
  let ownerId: string;
  const view = (state: string): TenantDomainView => ({id: requestId, tenantId: registrationId.replace(/-/g, ''), domain: 'shop.example.net',
    storeUrl: 'https://shop.example.net', adminUrl: 'https://manage.shop.example.net/Admin', state, challengeName: '_commerce-verification.shop.example.net',
    challengeValue: 'synthetic-dns-ownership-challenge', expiresAt: '2030-01-01T00:00:00Z', errorCode: null, message: null, isPrimary: false});
  beforeEach(() => {
    TestBed.configureTestingModule({imports: [TenantDomainOwnershipComponent, HttpClientTestingModule]});
    fixture = TestBed.createComponent(TenantDomainOwnershipComponent); component = fixture.componentInstance;
    http = TestBed.inject(HttpTestingController); ownerId = crypto.randomUUID(); selections = [];
    fixture.componentRef.setInput('ownerId', ownerId); fixture.componentRef.setInput('registrationId', registrationId);
    fixture.componentRef.setInput('requestToken', 'synthetic-xsrf-request-token');
    component.selectionChange.subscribe(value => selections.push(value));
  });
  afterEach(() => { fixture.destroy(); http.verify(); window.localStorage.removeItem('tenant-domain-' + ownerId + '-' + registrationId); });
  it('permits the platform address only after availability is known and no custom domain was selected', () => {
    fixture.detectChanges(); expect(selections.at(-1)?.ready).toBeFalse();
    http.expectOne('/api/TenantDomains/availability').flush({enabled: true}); expect(selections.at(-1)).toEqual({hasDomain: false, ready: true, requestId: null});
  });
  it('keeps a restored domain selection blocked until its owned status has been read', fakeAsync(() => {
    window.localStorage.setItem('tenant-domain-' + ownerId + '-' + registrationId, requestId);
    fixture.detectChanges(); http.expectOne('/api/TenantDomains/availability').flush({enabled: true});
    expect(selections.at(-1)).toEqual({hasDomain: true, ready: false, requestId: null}); tick(0);
    http.expectOne('/api/TenantDomains/' + requestId).flush(view('Verified'));
    expect(selections.at(-1)).toEqual({hasDomain: true, ready: true, requestId});
  }));
  it('does not silently discard a restored selection when its status cannot be read', fakeAsync(() => {
    window.localStorage.setItem('tenant-domain-' + ownerId + '-' + registrationId, requestId);
    fixture.detectChanges(); http.expectOne('/api/TenantDomains/availability').flush({enabled: true}); tick(0);
    http.expectOne('/api/TenantDomains/' + requestId).flush({}, {status: 404, statusText: 'Not Found'});
    expect(selections.at(-1)?.ready).toBeFalse(); component.reset(); expect(selections.at(-1)?.ready).toBeTrue();
  }));
  it('requires separate TXT verification after a successful Cloudflare access check', fakeAsync(() => {
    fixture.detectChanges(); http.expectOne('/api/TenantDomains/availability').flush({enabled: true});
    component.domainName = 'shop.example.net'; component.domainChanged(); expect(selections.at(-1)?.ready).toBeFalse(); component.check();
    const create = http.expectOne('/api/TenantDomains'); expect(create.request.headers.get('X-XSRF-TOKEN')).toBe('synthetic-xsrf-request-token');
    expect(Object.keys(create.request.body).sort()).toEqual(['domain', 'id', 'registrationId']); expect(create.request.body.registrationId).toBe(registrationId);
    create.flush(view('PendingCheck')); tick(0); http.expectOne('/api/TenantDomains/' + requestId).flush(view('AwaitingOwnership'));
    expect(selections.at(-1)?.ready).toBeFalse(); fixture.detectChanges(); expect(fixture.nativeElement.textContent).toContain('_commerce-verification.shop.example.net');
    component.verify(); http.expectOne('/api/TenantDomains/' + requestId + '/verify').flush({requested: true}); tick(0);
    http.expectOne('/api/TenantDomains/' + requestId).flush(view('CheckingOwnership')); expect(selections.at(-1)?.ready).toBeFalse(); tick(2500);
    http.expectOne('/api/TenantDomains/' + requestId).flush(view('Verified')); expect(selections.at(-1)).toEqual({hasDomain: true, ready: true, requestId});
    component.domainName = 'different.example.net'; component.domainChanged(); expect(selections.at(-1)).toEqual({hasDomain: true, ready: false, requestId: null});
  }));
});
