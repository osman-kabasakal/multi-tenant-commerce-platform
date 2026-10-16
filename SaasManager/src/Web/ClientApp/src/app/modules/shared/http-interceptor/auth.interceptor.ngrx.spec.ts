import {HttpErrorResponse, HttpHandler, HttpRequest, HttpResponse} from '@angular/common/http';
import {Store} from '@ngrx/store';
import {firstValueFrom, of, throwError} from 'rxjs';
import {AuthInterceptor} from './auth.interceptor.ngrx';
import {AuthService} from '../services/auth.service.ngrx';
import {selectIsAuthenticated} from '../../../core/auth/auth.selectors';

function fixture(authenticated = true) {
  const state = {credentialInfo: {accessToken: 'session-token'}};
  const store = {select: (selector: unknown) => of(selector === selectIsAuthenticated ? authenticated : state), dispatch: jasmine.createSpy('dispatch')};
  const auth = {refreshToken: jasmine.createSpy('refresh').and.returnValue(of(true))};
  return {auth, interceptor: new AuthInterceptor(store as unknown as Store, auth as unknown as AuthService)};
}
describe('SaaS session transport', () => {
  for (const status of [400, 409, 503]) {
    it('preserves backend status ' + status + ' for enrollment validation/recovery', async () => {
      const f = fixture(); const error = new HttpErrorResponse({status});
      const handler = {handle: () => throwError(() => error)} as HttpHandler;
      await expectAsync(firstValueFrom(f.interceptor.intercept(new HttpRequest('POST', '/api/TrialBusinesses', {}), handler))).toBeRejectedWith(error);
      expect(f.auth.refreshToken).not.toHaveBeenCalled();
    });
  }
  it('does not turn anonymous errors into a successful empty response', async () => {
    const f = fixture(false); const error = new HttpErrorResponse({status: 401});
    await expectAsync(firstValueFrom(f.interceptor.intercept(new HttpRequest('GET', '/api/Auth/sessionInfo'), {handle: () => throwError(() => error)}))).toBeRejectedWith(error);
  });
  it('does not attach a portal token to external resource requests', async () => {
    const f = fixture(); let forwarded: HttpRequest<unknown> | undefined;
    await firstValueFrom(f.interceptor.intercept(new HttpRequest('GET', 'https://external.example.test/file'), {handle: req => {forwarded = req; return of(new HttpResponse({status: 200}));}}));
    expect(forwarded!.headers.has('Authorization')).toBeFalse(); expect(forwarded!.withCredentials).toBeFalse();
  });
  it('refreshes at most once when an authenticated API request keeps failing', async () => {
    const f = fixture(); const error = new HttpErrorResponse({status: 401}); let calls = 0;
    await expectAsync(firstValueFrom(f.interceptor.intercept(new HttpRequest('GET', '/api/TrialBusinesses/configuration'), {handle: () => {calls++; return throwError(() => error);}}))).toBeRejectedWith(error);
    expect(calls).toBe(2); expect(f.auth.refreshToken).toHaveBeenCalledTimes(1);
  });
});
