import {CommonModule} from '@angular/common';
import {Component, DestroyRef, EventEmitter, Input, OnChanges, OnDestroy, OnInit, Output, SimpleChanges} from '@angular/core';
import {FormsModule} from '@angular/forms';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';
import {Subscription, timer} from 'rxjs';
import {exhaustMap} from 'rxjs/operators';

export interface TenantDomainView {
  id: string; tenantId: string; domain: string; storeUrl: string; adminUrl: string; state: string;
  challengeName: string; challengeValue: string; expiresAt: string; errorCode: string | null; message: string | null; isPrimary: boolean;
}
export interface TenantDomainSelection { requestId: string | null; ready: boolean; hasDomain: boolean; }

@Component({
  selector: 'app-tenant-domain-ownership', standalone: true, imports: [CommonModule, FormsModule],
  template: `
    @if (availabilityError) { <p class="my-4 rounded bg-red-50 p-3 text-sm text-red-800" role="alert">Alan adı seçenekleri yüklenemedi. Sayfayı yenileyip tekrar deneyin.</p> }
    @if (enabled) {
      <section class="my-5 rounded border border-gray-200 bg-white p-5" aria-labelledby="business-domain-title">
        <h2 id="business-domain-title" class="text-lg font-semibold text-gray-900">İşletmenizin alan adı</h2>
        <p class="mt-2 text-sm text-gray-600">İsterseniz kendi alan adınızı kullanabilirsiniz. Cloudflare erişimi kontrol edilir ve ekleyeceğiniz TXT kaydıyla sahiplik doğrulanır.</p>
        <label for="business-domain-name" class="mt-4 block text-sm font-medium">Alan adı <span class="font-normal text-gray-500">(isteğe bağlı)</span></label>
        <input id="business-domain-name" name="businessDomain" type="text" autocomplete="url" autocapitalize="none" spellcheck="false"
          class="mt-1 block w-full rounded border border-gray-300 p-2" placeholder="isletmeniz.com" maxlength="190"
          [(ngModel)]="domainName" [ngModelOptions]="{standalone: true}" (ngModelChange)="domainChanged()" [disabled]="busy" />
        <p class="mt-2 text-xs text-gray-600">Mağazanız bu alan adında, yönetim paneliniz manage. ile başlayan ayrı adreste açılır. Alan adı boş bırakılırsa platform adresleri kullanılır. Sahiplik doğrulandıktan sonra farklı bir sunucuyu gösteren mevcut A kaydı mağazaya taşınır; önceki web sitesinin yönlendirmesi değişir.</p>
        @if (domainName && !status) {
          <button type="button" class="mt-3 rounded bg-blue-700 px-4 py-2 text-white disabled:opacity-50" (click)="check()" [disabled]="busy || !registrationId">Alan adını kontrol et</button>
        }
        @if (busy) { <p class="mt-3 text-sm text-gray-700" role="status">Alan adı kontrol ediliyor…</p> }
        @if (error) { <p class="mt-3 rounded bg-red-50 p-3 text-sm text-red-800" role="alert">{{ error }}</p> }
        @if (status) {
          <div class="mt-4 text-sm" aria-live="polite">
            <p><span class="font-medium">Mağaza:</span> {{ status.storeUrl }}</p>
            <p class="mt-1"><span class="font-medium">Yönetim:</span> {{ status.adminUrl }}</p>
            @if (status.state === 'AwaitingOwnership' || status.state === 'CheckingOwnership') {
              <p class="mt-4">Cloudflare DNS panelinizde aşağıdaki TXT kaydını ekleyin. Kurulum tamamlanana kadar bu kaydı koruyun.</p>
              <dl class="mt-3 rounded bg-gray-50 p-3">
                <dt class="font-medium">Kayıt türü</dt><dd class="font-mono">TXT</dd>
                <dt class="mt-2 font-medium">Ad</dt><dd class="break-all font-mono text-xs">{{ status.challengeName }}</dd>
                <dt class="mt-2 font-medium">Değer</dt><dd class="break-all font-mono text-xs">{{ status.challengeValue }}</dd>
              </dl>
              <p class="mt-2 text-xs text-gray-500">Doğrulama isteği {{ status.expiresAt | date:'short' }} tarihine kadar geçerlidir.</p>
              <button type="button" class="mt-3 rounded bg-blue-700 px-4 py-2 text-white disabled:opacity-50" (click)="verify()" [disabled]="busy">TXT kaydını ekledim, doğrula</button>
            }
            @if (status.state === 'Verified') { <p class="mt-4 font-medium text-green-800">Alan adı sahipliği doğrulandı. {{ mode === 'settings' ? 'Etkinleştirme işlemini aşağıdan başlatabilirsiniz.' : 'İşletme kaydına bu alan adıyla devam edebilirsiniz.' }}</p> }
            @if (status.state === 'Active') { <p class="mt-4 font-medium text-green-800">Alan adı kullanıma hazır.</p> }
            @if (status.state === 'Expired') { <p class="mt-4 text-red-800">Doğrulama süresi doldu. Alan adını yeniden kontrol edin.</p> }
            @if (status.state === 'Failed' || status.state === 'Expired') {
              <button type="button" class="mt-3 rounded border px-4 py-2" (click)="reset()">Başka alan adı seç</button>
            }
          </div>
        }
      </section>
    }
  `
})
export class TenantDomainOwnershipComponent implements OnInit, OnChanges, OnDestroy {
  @Input() mode: 'registration' | 'settings' = 'registration';
  @Input() registrationId = '';
  @Input() ownerId = '';
  @Input() requestToken = '';
  @Output() selectionChange = new EventEmitter<TenantDomainSelection>();
  @Output() verified = new EventEmitter<TenantDomainView>();
  enabled = false;
  domainName = '';
  status: TenantDomainView | null = null;
  busy = false;
  error: string | null = null;
  private polling?: Subscription;
  private available = false;
  availabilityError = false;
  private retainedRequestId: string | null = null;
  constructor(private http: HttpClient, private destroy: DestroyRef) {}
  ngOnInit(): void {
    this.selectionChange.emit({hasDomain: false, ready: false, requestId: null});
    this.http.get<{enabled: boolean}>('/api/TenantDomains/availability').pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: value => { this.enabled = value.enabled; this.available = true; if (this.enabled) this.restore(); this.emit(); },
      error: () => { this.availabilityError = true; this.selectionChange.emit({hasDomain: false, ready: false, requestId: null}); }
    });
  }
  ngOnChanges(changes: SimpleChanges): void {
    if (this.available && this.enabled && (changes['registrationId'] || changes['ownerId'])) this.restore();
  }
  ngOnDestroy(): void { this.polling?.unsubscribe(); }
  domainChanged(): void {
    this.polling?.unsubscribe(); this.status = null; this.error = null; this.remember(null); this.emit();
  }
  check(): void {
    if (this.busy || !this.registrationId || !this.requestToken) return;
    this.error = null; this.busy = true; const domain = this.domainName.trim().toLowerCase();
    this.http.post<TenantDomainView>('/api/TenantDomains', {id: crypto.randomUUID(), registrationId: this.registrationId, domain},
      {headers: {'X-XSRF-TOKEN': this.requestToken}}).pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: result => { this.status = result; this.domainName = result.domain; this.remember(result.id); this.watch(result.id); },
      error: error => { this.busy = false; this.showError(error); }
    });
  }
  verify(): void {
    if (this.busy || !this.status || !this.requestToken) return;
    this.busy = true; this.error = null;
    const id = this.status.id;
    this.http.post<{requested: boolean}>('/api/TenantDomains/' + encodeURIComponent(id) + '/verify', {},
      {headers: {'X-XSRF-TOKEN': this.requestToken}}).pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: result => { if (result.requested) this.watch(id); else { this.busy = false; this.error = 'Doğrulama isteği başlatılamadı. Mevcut durumu yenileyin.'; this.watch(id); } },
      error: error => { this.busy = false; this.showError(error); }
    });
  }
  reset(): void { this.busy = false; this.domainName = ''; this.domainChanged(); }
  private get storageKey(): string { return 'tenant-domain-' + this.ownerId + '-' + this.registrationId; }
  private remember(id: string | null): void {
    this.retainedRequestId = id;
    try { if (id) window.localStorage.setItem(this.storageKey, id); else window.localStorage.removeItem(this.storageKey); } catch { /* Private browsing can disable persistence. */ }
  }
  private restore(): void {
    this.polling?.unsubscribe(); this.status = null; this.domainName = ''; this.busy = false;
    if (!this.registrationId || !this.ownerId) { this.emit(); return; }
    let id: string | null = null;
    try { id = window.localStorage.getItem(this.storageKey); } catch { /* No stored selection. */ }
    this.retainedRequestId = id;
    if (id && /^[a-f0-9-]{36}$/i.test(id)) { this.emit(); this.watch(id); }
    else this.emit();
  }
  private watch(id: string): void {
    this.polling?.unsubscribe(); this.busy = true;
    this.polling = timer(0, 2500).pipe(exhaustMap(() => this.http.get<TenantDomainView>('/api/TenantDomains/' + encodeURIComponent(id))),
      takeUntilDestroyed(this.destroy)).subscribe({
        next: result => {
          this.status = result; this.domainName = result.domain; this.error = result.message;
          const pending = result.state === 'PendingCheck' || result.state === 'CheckingOwnership';
          if (!pending) { this.busy = false; this.polling?.unsubscribe(); }
          this.emit(); if (result.state === 'Verified' || result.state === 'Active') this.verified.emit(result);
        },
        error: error => { this.busy = false; this.polling?.unsubscribe(); this.showError(error); }
      });
  }
  private emit(): void {
    const hasDomain = this.enabled && (this.domainName.trim().length > 0 || this.retainedRequestId !== null);
    const ready = !hasDomain || this.status?.state === 'Verified' || this.status?.state === 'Active';
    this.selectionChange.emit({hasDomain, ready, requestId: ready && hasDomain ? this.status?.id ?? null : null});
  }
  private showError(error: HttpErrorResponse): void {
    this.error = error.status === 401 || error.status === 403 ? 'Alan adını doğrulanmış işletme sahibi hesabıyla yönetin.' :
      typeof error.error?.message === 'string' ? error.error.message : 'Alan adı kontrolü tamamlanamadı. Tekrar deneyin.';
    this.emit();
  }
}
