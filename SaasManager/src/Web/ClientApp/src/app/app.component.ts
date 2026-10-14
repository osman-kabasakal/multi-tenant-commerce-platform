import {environment} from '../environments/environment';
import {APP_INITIALIZER, Component, Inject, OnDestroy, OnInit, PLATFORM_ID} from '@angular/core';
import {RouterOutlet} from '@angular/router';
import {SharedModule} from './modules/shared/shared.module';
import {
  Subject,
  filter,
  takeUntil,
  fromEvent,
  interval,
  timer,
  Subscription,
  switchMap,
  delay,
  distinctUntilChanged
} from 'rxjs';
import {AuthService} from './modules/shared/services/auth.service.ngrx';
import {isPlatformBrowser} from '@angular/common';
import {Store} from '@ngrx/store';
import {selectAuthState, selectIsAuthenticated} from './core/auth/auth.selectors';
import {map, tap, timeout} from 'rxjs/operators';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit, OnDestroy {
  title = 'SaasManager.Web';
  readonly localDemo = environment.localDemo;
  constructor(private store: Store, private authService: AuthService, @Inject(PLATFORM_ID) private platformId: Object) {
  }

  ngOnInit() {
  }



  ngOnDestroy() {
    this.authService.clearRefreshTimeout();
  }
}
