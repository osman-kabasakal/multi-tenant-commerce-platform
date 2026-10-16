import {Component, DestroyRef, Inject, OnDestroy, OnInit, PLATFORM_ID, Signal} from '@angular/core';
import {RegistrationService} from '../../../../shared/services/identity-management/registration-service.service';
import {AuthService} from '../../../../shared/services/auth.service.ngrx';
import {Router} from '@angular/router';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {IFieldDefinition, IRegistrationStepResponse} from '../../../../shared/interfaces/api-response';
import {isPlatformBrowser} from '@angular/common';
import {Subscription, timer} from 'rxjs';
import {exhaustMap} from 'rxjs/operators';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';
import {environment} from '../../../../../../environments/environment';

interface TrialConfiguration {
  requestToken: string;
  ownerId: string;
  plan: {id: string; name: string; trialDays: number};
  fields: {[key: string]: IFieldDefinition};
  business: {id: string; name: string; databaseReady: boolean; form: {[key: string]: string}} | null;
}
interface TrialJob {
  state: string;
  steps: {[name: string]: {resources: {[key: string]: string}}};
  iosRelease?: {state: string; attempts: number; errorCode: string | null};
}

@Component({selector: 'app-registration', templateUrl: './registration.component.html', styleUrl: './registration.component.scss'})
export class RegistrationComponent implements OnInit, OnDestroy {
  currentStep$: Signal<IRegistrationStepResponse | null>;
  checking = true;
  trialMode = false;
  trial: TrialConfiguration | null = null;
  initialValues: {[key: string]: unknown} = {};
  submitting = false;
  error: string | null = null;
  fieldErrors: {[key: string]: string[]} | null = null;
  job: TrialJob | null = null;
  ready = false;
  storeUrl = '';
  adminUrl = '';
  private registrationId = '';
  private statusUrl = '';
  private polling?: Subscription;

  constructor(private registrationService: RegistrationService, private router: Router, private http: HttpClient,
    private auth: AuthService, private destroy: DestroyRef, @Inject(PLATFORM_ID) private platformId: Object) {
    this.currentStep$ = this.registrationService.getCurrentStep();
  }
  ngOnDestroy(): void { this.polling?.unsubscribe(); }
  ngOnInit(): void {
    if (!isPlatformBrowser(this.platformId)) return;
    if (environment.localDemo) { this.legacy(); return; }
    this.http.get<{enabled: boolean}>('/api/TrialBusinesses/availability').pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: value => { if (value.enabled) { this.trialMode = true; this.loadTrial(); } else this.legacy(); },
      error: () => { this.checking = false; this.error = 'Kayıt seçenekleri yüklenemedi. Sayfayı yenileyip tekrar deneyin.'; }
    });
  }
  private legacy(): void {
    this.checking = false;
    this.registrationService.initializeRegistration().pipe(takeUntilDestroyed(this.destroy)).subscribe(response => {
      if (response.isCompleted) this.router.navigate(['/dashboard']);
    });
  }
  private loadTrial(): void {
    this.http.get<TrialConfiguration>('/api/TrialBusinesses/configuration').pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: configuration => {
        this.checking = false; this.trial = configuration; this.initialValues = configuration.business?.form ?? {};
        const key = 'trial-enrollment-' + configuration.ownerId;
        try { this.registrationId = configuration.business?.id ?? window.localStorage.getItem(key) ?? crypto.randomUUID(); window.localStorage.setItem(key, this.registrationId); }
        catch { this.registrationId = configuration.business?.id ?? crypto.randomUUID(); }
        if (configuration.business) this.watch('/api/Provisioning/' + configuration.business.id);
      },
      error: error => { this.checking = false; this.showError(error); }
    });
  }
  onSubmit(formData: unknown): void {
    this.registrationService.submitStep(formData).pipe(takeUntilDestroyed(this.destroy)).subscribe(response => {
      if (response.isCompleted) this.router.navigate(['/dashboard']);
    });
  }
  onTrialSubmit(values: {[key: string]: string}): void {
    if (!this.trial || this.submitting) return;
    this.submitting = true; this.error = null; this.fieldErrors = null;
    const {adminPassword, ...business} = values;
    this.http.post<{businessId: string; statusUrl: string}>('/api/TrialBusinesses', {registrationId: this.registrationId, business, adminPassword},
      {headers: {'X-XSRF-TOKEN': this.trial.requestToken}}).pipe(takeUntilDestroyed(this.destroy)).subscribe({
        next: result => { this.submitting = false; this.watch(result.statusUrl); },
        error: error => { this.submitting = false; this.showError(error); }
      });
  }
  get iosReleaseMessage(): string {
    const messages: {[state: string]: string} = {
      NotQueued: 'iOS uygulamanız için mağaza kurulumu bekleniyor.',
      Pending: 'iOS uygulamanız sırada.', Running: 'iOS uygulamanız hazırlanıyor.',
      Succeeded: 'iOS test sürümünüzün dağıtımı tamamlandı.', Failed: 'iOS uygulaması hazırlanamadı. Kurulumu tekrar deneyebilirsiniz.'
    };
    return messages[this.job?.iosRelease?.state ?? ''] ?? 'iOS uygulamanızın durumu kontrol ediliyor.';
  }
  retry(): void {
    if (!this.trial || !this.statusUrl || this.submitting) return;
    this.submitting = true; this.error = null;
    this.http.post(this.statusUrl + '/retry', {}, {headers: {'X-XSRF-TOKEN': this.trial.requestToken}}).pipe(takeUntilDestroyed(this.destroy)).subscribe({
      next: () => { this.submitting = false; this.watch(this.statusUrl); },
      error: error => { this.submitting = false; this.showError(error); }
    });
  }
  private watch(url: string): void {
    if (!/^\/api\/Provisioning\/[a-f0-9-]{32,36}$/i.test(url)) { this.error = 'Kurulum adresi doğrulanamadı.'; return; }
    this.polling?.unsubscribe(); this.statusUrl = url;
    this.polling = timer(0, 2500).pipe(exhaustMap(() => this.http.get<TrialJob>(url)), takeUntilDestroyed(this.destroy)).subscribe({
      next: job => {
        this.job = job;
        if (job.state === 'Failed') { this.polling?.unsubscribe(); this.error = 'Mağaza kurulumu tamamlanamadı. Ayarlar düzeltildikten sonra tekrar deneyebilirsiniz.'; }
        if (job.state === 'Succeeded') this.http.get<TrialConfiguration>('/api/TrialBusinesses/configuration').pipe(takeUntilDestroyed(this.destroy)).subscribe(configuration => {
          this.trial = configuration;
          if (configuration.business?.databaseReady) {
            this.ready = true; this.polling?.unsubscribe();
            this.storeUrl = job.steps['publication']?.resources['storeUrl'] ?? ''; this.adminUrl = job.steps['publication']?.resources['adminUrl'] ?? '';
            this.auth.initAuth().pipe(takeUntilDestroyed(this.destroy)).subscribe();
          }
        });
      },
      error: error => { this.job = null; this.showError(error); }
    });
  }
  private showError(error: HttpErrorResponse): void {
    this.error = error.status === 401 ? 'Doğrulanmış hesabınızla tekrar oturum açın.' : error.status === 409 ? 'Bu işletmenin mevcut kaydını veya seçilen deneme planını kontrol edin.' : 'İşlem tamamlanamadı. Bilgileri kontrol edip tekrar deneyin.';
    const errors = error.error?.errors as {[key: string]: string[]} | undefined;
    this.fieldErrors = errors ? Object.fromEntries(Object.entries(errors).map(([key, value]) => { const field = key.split('.').pop()!; return [field[0].toLowerCase() + field.slice(1), value]; })) : null;
  }
  protected readonly parseInt = parseInt;
}
