import {Injectable, Signal, signal, WritableSignal} from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {BehaviorSubject, Observable, of, throwError} from 'rxjs';
import { map, catchError, tap, switchMap } from 'rxjs/operators';
import {
  IGuestTokenResponse,
  IRegistrationCommand,
  IRegistrationStepResponse,
  IServiceResponse
} from '../../interfaces/api-response';
import {CookieService} from 'ngx-cookie-service';

@Injectable({
  providedIn: 'root'
})
export class RegistrationService {
  private readonly GUEST_TOKEN_COOKIE = 'guest_token';
  private readonly GUEST_TOKEN_ENDPOINT = '/api/identity/guest-token';
  private readonly REGISTRATION_ENDPOINT = '/api/identity/registration';
  private readonly TOKEN_EXPIRY_DAYS = 7;

  private currentStep$ = signal<IRegistrationStepResponse | null>(null);

  constructor(
    private http: HttpClient,
    private cookieService: CookieService
  ) {}

  /**
   * Initializes or continues the registration process
   */
  initializeRegistration(): Observable<IRegistrationStepResponse> {
    return of(true).pipe(
      switchMap(tokenResponse => {
        const command: IRegistrationCommand = {
          stepKey: '',
          data: {},
          validationToken: undefined
        };

        return this.http.post<IServiceResponse<IRegistrationStepResponse>>(
          this.REGISTRATION_ENDPOINT,
          command
        ).pipe(
          map(response => {
            if (!response.isSuccess) {
              throw new Error(response.errorMessage || 'Registration initialization failed');
            }
            this.currentStep$.set(response.data!);
            return response.data!;
          })
        );
      }),
      catchError(error => {
        console.error('Registration initialization error:', error);
        return throwError(() => new Error('Registration initialization failed'));
      })
    );
  }

  /**
   * Submits data for the current registration step
   */
  submitStep(data: any, validationToken?: string): Observable<IRegistrationStepResponse> {
    return of(true).pipe(
      switchMap(tokenResponse => {
        const currentStep = this.currentStep$();

        if (!currentStep) {
          return throwError(() => new Error('No active registration step'));
        }

        const command: IRegistrationCommand = {
          stepKey: currentStep.currentStep,
          data: data,
          validationToken: validationToken || currentStep.validationToken
        };

        return this.http.post<IServiceResponse<IRegistrationStepResponse>>(
          this.REGISTRATION_ENDPOINT,
          command
        ).pipe(
          map(response => {
            if (!response.isSuccess) {
              throw new Error(response.errorMessage || 'Step validation failed');
            }
            this.currentStep$.set(response.data!);
            return response.data!;
          })
        );
      }),
      catchError(error => {
        console.error('Step submission error:', error);
        return throwError(() => error);
      })
    );
  }

  /**
   * Gets the current registration step
   */
  getCurrentStep(): Signal<IRegistrationStepResponse | null> {
    return this.currentStep$.asReadonly();
  }

  /**
   * Resets the registration process
   */
  resetRegistration(): void {
    this.cookieService.delete(this.GUEST_TOKEN_COOKIE, '/');
    this.currentStep$.set(null);
  }
}
