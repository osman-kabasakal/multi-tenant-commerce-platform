import {
  APP_ID,
  APP_INITIALIZER,
  ApplicationConfig,
  importProvidersFrom,
  PLATFORM_ID,
  provideZoneChangeDetection
} from '@angular/core';
import { provideRouter } from '@angular/router';
import {
  HTTP_INTERCEPTORS,
  provideHttpClient,
  withFetch,
  withInterceptorsFromDi,
  withXsrfConfiguration
} from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { SharedModule } from './modules/shared/shared.module';
import { provideState, provideStore } from '@ngrx/store';
import { AuthInterceptor } from './modules/shared/http-interceptor/auth.interceptor.ngrx';
import { AuthService } from './modules/shared/services/auth.service.ngrx';
import { authReducer } from './core/auth/auth.reducer';
import { isPlatformBrowser } from '@angular/common';
import { firstValueFrom, of } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';
import {routes} from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    importProvidersFrom(BrowserModule),
    provideHttpClient(
      withFetch(),
      withInterceptorsFromDi(),
      withXsrfConfiguration({
        headerName: 'X-XSRF-TOKEN',
        cookieName: 'X-XSRF-TOKEN'
      })
    ),
    { provide: APP_ID, useValue: 'ng-cli-universal' },
    importProvidersFrom(SharedModule),
    provideStore(),  // Önce store'u provide edin
    provideState({ name: "auth", reducer: authReducer }), // Sonra state'i provide edin
    {
      provide: APP_INITIALIZER,
      useFactory: (authService: AuthService, platformId: Object) => {
        return async () => {
          if (isPlatformBrowser(platformId)) {
            try {
              // Observable'ı Promise'e çevirerek async initialization sağlayın
              await firstValueFrom(
                authService.initAuth().pipe(
                  tap(s => console.log('init auth response', s)),
                  catchError(() => of(true))
                )
              );
              return true;
            } catch {
              return true;
            }
          }
          return true;
        };
      },
      deps: [AuthService, PLATFORM_ID],
      multi: true,
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true,
    },
    AuthService
  ]
};
