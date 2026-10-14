import { Injectable } from '@angular/core';
import {
  HttpErrorResponse,
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpResponse
} from '@angular/common/http';
import { Store } from '@ngrx/store';
import { Router } from '@angular/router';
import {EMPTY, empty, first, firstValueFrom, from, Observable, of, switchMap, throwError} from 'rxjs';
import { selectAuthState, selectIsAuthenticated } from '../../../core/auth/auth.selectors';
import { catchError, map } from 'rxjs/operators';
import { logout } from '../../../core/auth/auth.actions';
import { AuthService } from '../services/auth.service.ngrx';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(
    private store: Store,
    private router: Router,
    private authService: AuthService,
  ) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    return from(firstValueFrom(this.store.select(selectIsAuthenticated))).pipe(
      switchMap(isAuthenticated => {
        // Auth olmayan veya refresh token istekleri için direkt geçir
        if (!isAuthenticated || req.url.startsWith('/api/Auth/refresh')) {
          let reqClone= req.clone({
            withCredentials:true
          })
          return next.handle(req).pipe(catchError((e)=>{
            return of(new HttpResponse({
              body: "{}",
              status: 200, // İstediğiniz status kodu
              statusText: 'OK'
            }));
          }));
        }

        return from(firstValueFrom(this.store.select(selectAuthState))).pipe(
          switchMap(authState => {
            // Eğer credentials varsa direkt token ekle
            if (authState.credentialInfo != null) {
              return of(req.clone({
                headers: req.headers.append('Authorization', 'Bearer ' + authState.credentialInfo.accessToken),
                withCredentials: true,
              }));
            }

            // Credentials yoksa yeni token al
            return this.authService.initAccessToken(authState).pipe(
              map(accessTokenState => {
                if (accessTokenState) {
                  return req.clone({
                    headers: req.headers.append('Authorization', 'Bearer ' + this.store.selectSignal(selectAuthState)().credentialInfo!.accessToken),
                    withCredentials: true
                  });
                }
                return req;
              })
            );
          }),
          switchMap(newReq => {
            return next.handle(newReq).pipe(
              catchError(error => {
                if (error instanceof HttpErrorResponse && error.status === 401) {
                  // 401 hatası durumunda tekrar token almayı dene
                  return from(firstValueFrom( this.authService.refreshToken())).pipe(
                    switchMap(refreshResponse => {
                     let authState= this.store.selectSignal(selectAuthState)();
                      if (refreshResponse&&authState?.credentialInfo) {
                        // Yeni token ile isteği tekrarla
                        const retryReq = newReq.clone({
                          headers: newReq.headers.set('Authorization', 'Bearer ' + authState.credentialInfo.accessToken)
                        });
                        return next.handle(retryReq);
                      }

                      // Token alınamazsa logout yap
                      this.store.dispatch(logout());
                      this.router.navigate(['/auth/login']);
                      return of();
                      // return throwError(() => error);
                    }),
                    catchError(() => {
                      // Token alma başarısız olursa logout yap
                      this.store.dispatch(logout());
                      this.router.navigate(['/auth/login']);
                      return of();
                      // return throwError(() => error);
                    })
                  );
                }
                return of();
              })
            );
          })
        );
      }),
        catchError((er)=>of())
    );
  }
}
