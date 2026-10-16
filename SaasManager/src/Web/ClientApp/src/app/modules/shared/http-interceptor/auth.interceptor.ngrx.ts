import {Injectable} from '@angular/core';
import {HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest} from '@angular/common/http';
import {Store} from '@ngrx/store';
import {Observable, throwError} from 'rxjs';
import {catchError, switchMap, take} from 'rxjs/operators';
import {selectAuthState, selectIsAuthenticated} from '../../../core/auth/auth.selectors';
import {logout} from '../../../core/auth/auth.actions';
import {AuthService} from '../services/auth.service.ngrx';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private store: Store, private authService: AuthService) {}

  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    let ownApi = req.url.startsWith('/api/');
    let apiPath = req.url.split('?')[0];
    if (!ownApi && typeof window !== 'undefined') {
      try { const url = new URL(req.url, window.location.origin); ownApi = url.origin === window.location.origin && url.pathname.startsWith('/api/'); apiPath = url.pathname; } catch { /* Let HttpClient report an invalid URL. */ }
    }
    if (!ownApi) return next.handle(req);
    const cookieRequest = req.clone({withCredentials: true});
    if (apiPath.toLowerCase().startsWith('/api/auth/refresh')) return next.handle(cookieRequest);
    return this.store.select(selectIsAuthenticated).pipe(take(1), switchMap(authenticated => {
      if (!authenticated) return next.handle(cookieRequest);
      return this.store.select(selectAuthState).pipe(take(1), switchMap(state => {
        const outgoing = state.credentialInfo ? cookieRequest.clone({setHeaders: {Authorization: 'Bearer ' + state.credentialInfo.accessToken}}) : cookieRequest;
        return next.handle(outgoing).pipe(catchError(error => {
          if (!(error instanceof HttpErrorResponse) || error.status !== 401) return throwError(() => error);
          return this.authService.refreshToken().pipe(take(1), switchMap(refreshed => this.store.select(selectAuthState).pipe(take(1), switchMap(fresh => {
            if (!refreshed || !fresh.credentialInfo) { this.store.dispatch(logout()); return throwError(() => error); }
            // A second failure reaches the caller; it cannot start another refresh loop.
            return next.handle(cookieRequest.clone({setHeaders: {Authorization: 'Bearer ' + fresh.credentialInfo.accessToken}}));
          }))));
        }));
      }));
    }));
  }
}
