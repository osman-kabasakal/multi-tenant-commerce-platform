import {Inject, Injectable, PLATFORM_ID} from '@angular/core';
import {ActivatedRouteSnapshot, CanActivate, CanActivateChild, Router, RouterStateSnapshot} from '@angular/router';
import {AuthService} from '../services/auth.service.ngrx';
import {Store} from '@ngrx/store';
import {first, from, Observable, of, switchMap} from 'rxjs';
import {isPlatformBrowser} from '@angular/common';
import {catchError, map} from 'rxjs/operators';

@Injectable({providedIn: 'root'})
export class AuthStateGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private store: Store,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
  }

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean> {
    debugger;
    if (!isPlatformBrowser(this.platformId))
      return of(true);

    debugger;
    return of(true);
    // return this.authService.initAuth().pipe(catchError(err => of(true)),map(x=>true));
  }
}
