import {Injectable} from '@angular/core';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {Store} from '@ngrx/store';
import {firstValueFrom, from, Observable, of, switchMap, switchMapTo, throwError} from 'rxjs';
import {credentialInfoSuccess, login, loginSuccess, logout, updateSession} from '../../../core/auth/auth.actions';
import {catchError, map, tap} from 'rxjs/operators';
import {AuthState, ICredentialInfo} from '../../../core/auth/auth.state';
import {selectAuthState, selectIsAuthenticated} from '../../../core/auth/auth.selectors';
import {IServiceResponse} from '../interfaces/api-response';

@Injectable({providedIn: 'root'})
export class AuthService {
  constructor(
    private http: HttpClient,
    private store: Store
  ) {
  }

  private refreshTimeout?: number;

  initAuth(): Observable<boolean> {
    return this.http.get<IServiceResponse<AuthState>>('/api/Auth/sessionInfo', {
      withCredentials: true
    }).pipe(
      catchError(error => {
        return of(null); // HTTP hatasını yakala ve null dön
      }),
      map(response => response?.data), // response null ise undefined dönecek
      switchMap(response => from(firstValueFrom(this.initAccessToken(response)))),
      map(response => {
        if (response) {
          this.store.dispatch(loginSuccess({
            user: response.user!,
            roles: response.roles,
            permissions: response.permissions,
            registrationStep: response.registrationStep,
            credentialInfo: response.credentialInfo
          }));
          return true;
        }
        return false;
      }),
      catchError(error => {
        return of(false);
      })
    );
  }

  private scheduleTokenRefresh(expiresIn: number) {
    if (this.refreshTimeout) {
      clearTimeout(this.refreshTimeout);
    }

    // Token'ın süresinin dolmasına 1 dakika kala yenileme
    const refreshTime = (expiresIn - 60) * 1000;

    this.refreshTimeout = window.setTimeout(() => {
      this.refreshToken().subscribe();
    }, refreshTime);
  }

  initAccessToken(authState: AuthState | undefined): Observable<AuthState | undefined> {
    return of(!!authState).pipe(
      switchMap(isAuthenticated => {
        if (isAuthenticated) {
          return this.http.get<IServiceResponse<ICredentialInfo>>('/api/Auth/refresh',{withCredentials:true})
            .pipe(
              tap(credentialInfoResponse => {
                if (credentialInfoResponse.isSuccess && credentialInfoResponse.data) {
                  // Yeni token alındığında yeni bir timeout planla
                  this.scheduleTokenRefresh(credentialInfoResponse.data.expiresIn);
                }
              }),
              map(credentialInfoResponse => {
                if (credentialInfoResponse.isSuccess) {
                  authState!.credentialInfo = credentialInfoResponse.data!;
                }
                return authState;
              })
            );
        }
        return of(authState);
      }),
      catchError(er => of(undefined))
    );
  }

  refreshToken(): Observable<boolean> {
    return from(firstValueFrom(this.store.select(selectIsAuthenticated))).pipe(
      switchMap(isAuthenticated => {
        if (isAuthenticated) {
          return this.http.get<IServiceResponse<ICredentialInfo>>('/api/Auth/refresh',{withCredentials:true})
            .pipe(
              tap(credentialInfoResponse => {
                if (credentialInfoResponse.isSuccess && credentialInfoResponse.data) {
                  // Refresh token başarılı olduğunda yeni bir timeout planla
                  this.scheduleTokenRefresh(credentialInfoResponse.data.expiresIn);
                }
              }),
              map(credentialInfoResponse => {
                if (credentialInfoResponse.isSuccess) {
                  this.store.dispatch(credentialInfoSuccess({
                    credentialInfo: credentialInfoResponse.data!,
                  }));
                }
                return credentialInfoResponse.isSuccess ?? false;
              })
            );
        }
        return of(false);
      })
    );
  }

  // Component destroy olduğunda timeout'u temizlemek için
  clearRefreshTimeout() {
    if (this.refreshTimeout) {
      clearTimeout(this.refreshTimeout);
    }
  }

  logout(): Observable<boolean> {
    window.location.href='/api/auth/logout';
    return of(true);
    // return this.http.post<IServiceResponse<ILogoutResponse>>('/api/auth/logouth', {
    //   withCredentials: true
    // }).pipe(
    //   tap((res) => {
    //     this.store.dispatch(logout());
    //     window.location.href=res.data!.logoutUrl!;
    //   }),
    //   map(x=>true)
    // );
  }
}
