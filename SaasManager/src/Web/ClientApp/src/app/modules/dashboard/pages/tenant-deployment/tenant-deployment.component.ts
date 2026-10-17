import {CommonModule} from '@angular/common';
import {Component, DestroyRef, OnInit} from '@angular/core';
import {FormsModule} from '@angular/forms';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {RouterLink} from '@angular/router';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';
import {timer} from 'rxjs';
import {TenantDomainOwnershipComponent, TenantDomainSelection, TenantDomainView} from '../../../shared/components/tenant-domain-ownership/tenant-domain-ownership.component';

interface Activation {state: string; errorCode: string | null; steps: Record<string, unknown>;}
interface DomainStatus {domain: TenantDomainView; activation: Activation | null;}
interface Identity {
  id: string; packageName: string; iosBundleId: string; state: string; isActive: boolean; androidReady: boolean; iosReady: boolean;
  androidCertificateSha256: string | null; iosCertificateSha256: string | null; storeUrl: string; errorCode: string | null; updatedAt: string;
}
interface Deployment {
  businessId: string; ownerId: string; businessName: string; domainEnabled: boolean; identityEnabled: boolean; canChange: boolean;
  blockReason: string | null; storeUrl: string; adminUrl: string; proposedPackageName: string; domains: DomainStatus[]; identities: Identity[];
}

@Component({
  selector: 'app-tenant-deployment', standalone: true,
  imports: [CommonModule, FormsModule, RouterLink, TenantDomainOwnershipComponent],
  templateUrl: './tenant-deployment.component.html'
})
export class TenantDeploymentComponent implements OnInit {
  state: Deployment | null = null;
  token = '';
  available: boolean | null = null;
  loading = false;
  busy = false;
  error: string | null = null;
  notice: string | null = null;
  selectedDomain: TenantDomainSelection = {hasDomain: false, ready: false, requestId: null};
  createMobileIdentity = true;
  constructor(private http: HttpClient, private destroy: DestroyRef) {}
  ngOnInit(): void {
    this.http.get<{enabled: boolean}>('/api/TenantDeployment/availability').pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: result => {
        this.available = result.enabled;
        if (this.available) this.http.get<{requestToken: string}>('/api/TenantDeployment/configuration').pipe(takeUntilDestroyed(this.destroy)).subscribe({
          next: value => { this.token = value.requestToken; this.load(); }, error: error => this.showError(error)
        });
      }, error: error => this.showError(error)
    });
    timer(10000, 10000).pipe(takeUntilDestroyed(this.destroy)).subscribe(() => { if (this.state && !this.loading && !this.busy) this.load(); });
  }
  load(): void {
    if (this.loading || !this.available) return;
    this.loading = true;
    this.http.get<Deployment>('/api/TenantDeployment').pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: result => { this.state = result; this.loading = false; },
      error: error => { this.loading = false; this.showError(error); }
    });
  }
  get changingDomain(): boolean { return this.state?.domains.some(x => x.activation?.state === 'Pending' || x.activation?.state === 'Running') ?? false; }
  get changingIdentity(): boolean { return this.state?.identities.some(x => ['Preparing', 'WaitingBuilds', 'Ready'].includes(x.state)) ?? false; }
  get alreadyUsesProposedIdentity(): boolean { return this.state?.identities.some(x => x.isActive && x.packageName === this.state?.proposedPackageName) ?? false; }
  activate(id: string | null): void {
    if (!id || this.busy || !this.state?.canChange || this.changingDomain) return;
    this.post('/domain', {domainRequestId: id, createMobileIdentity: this.state.identityEnabled && this.createMobileIdentity},
      'Alan adı geçişi sıraya alındı. DNS ve güvenli bağlantı kontrolleri tamamlandığında ana adres değişecek.');
  }
  createIdentity(): void {
    if (this.busy || !this.state?.canChange || !this.state.identityEnabled || this.changingIdentity || this.changingDomain || this.alreadyUsesProposedIdentity) return;
    const key = 'mobile-identity-request-' + this.state.ownerId + '-' + this.state.businessId + '-' + this.state.proposedPackageName;
    let id: string = crypto.randomUUID();
    try { const retained = localStorage.getItem(key); if (retained) id = retained; else localStorage.setItem(key, id); } catch { /* An unavailable storage does not persist credentials. */ }
    this.post('/identity', {requestId: id}, 'Yeni uygulama kimliği hazırlanıyor. Android ve iOS imzalı derlemeleri tamamlanınca aktifleşecek.');
  }
  retry(id: string, kind: 'domain' | 'identity'): void { if (!this.busy) this.post('/retry', {id, kind}, 'İşlem yeniden sıraya alındı.'); }
  label(state: string): string {
    return ({PendingCheck: 'Cloudflare kontrolü', AwaitingOwnership: 'Sahiplik kaydı bekleniyor', CheckingOwnership: 'Sahiplik kontrol ediliyor',
      Verified: 'Sahipliği doğrulandı', Active: 'Aktif', Retired: 'Önceki kimlik', Preparing: 'Uygulamalar hazırlanıyor', WaitingBuilds: 'Derlemeler bekleniyor',
      Ready: 'Aktifleştiriliyor', Superseded: 'Yeni alan adı nedeniyle durduruldu', Pending: 'Sırada', Running: 'İşleniyor', Succeeded: 'Tamamlandı', Failed: 'İşlem başarısız', Expired: 'Doğrulama süresi doldu'} as Record<string,string>)[state] ?? state;
  }
  private post(path: string, body: object, notice: string): void {
    if (!this.token) return;
    this.busy = true; this.error = null; this.notice = null;
    this.http.post('/api/TenantDeployment' + path, body, {headers: {'X-XSRF-TOKEN': this.token}}).pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: () => { this.busy = false; this.notice = notice; this.load(); },
      error: error => { this.busy = false; this.showError(error); this.load(); }
    });
  }
  private showError(error: HttpErrorResponse): void {
    this.error = error.status === 401 || error.status === 403 ? 'Doğrulanmış işletme sahibi hesabıyla giriş yapın.' :
      typeof error.error?.message === 'string' ? error.error.message : 'Kurulum bilgileri alınamadı. Yenileyip tekrar deneyin.';
  }
}
