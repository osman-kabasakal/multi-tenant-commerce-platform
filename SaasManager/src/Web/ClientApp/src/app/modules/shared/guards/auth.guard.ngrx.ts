import {Inject, Injectable, PLATFORM_ID} from '@angular/core';
import {ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot} from '@angular/router';
import {Store} from '@ngrx/store';
import {concat, first, firstValueFrom, Observable, of, switchMap, takeUntil} from 'rxjs';
import {selectAuthState, selectIsAuthenticated, selectUserRoles} from '../../../core/auth/auth.selectors';
import {map, tap} from 'rxjs/operators';
import {isPlatformBrowser, isPlatformServer} from '@angular/common';
import {updateSession} from '../../../core/auth/auth.actions';
import {AuthService} from '../services/auth.service.ngrx';


@Injectable({providedIn: 'root'})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private store: Store,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
  }

  async canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Promise<boolean> {
    let isAuthenticated = await firstValueFrom(this.store.select(selectIsAuthenticated));
    if (!isAuthenticated) {
      return this.redirectToLogin(state);
    }

    let currentState= this.store.selectSignal(selectAuthState)();

    if(!(currentState.registrationStep?.isCompleted??false) && !(state.url.startsWith('/register'))){
      this.router.navigateByUrl('/register');
      return false;
    }
    const requiredRoles = route.data['roles'] as string[];
    if (!requiredRoles?.length) {
      return true;
    }

    let userRoles = this.store.selectSignal(selectUserRoles)();
    const hasRequiredRole = requiredRoles.some(role =>
      userRoles.includes(role)
    );

    if (!hasRequiredRole) {
      this.router.navigateByUrl('/unauthorized');
      return false;
    }

    return true;
  }

  redirectToLogin(state: RouterStateSnapshot):boolean{
    window.location.href= `/api/auth/login?returnUrl=${encodeURIComponent(state.url)}`;
    return false;
  }
}
