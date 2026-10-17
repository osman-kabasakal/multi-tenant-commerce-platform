import {Component, computed, Inject, OnDestroy, OnInit, PLATFORM_ID, Signal} from '@angular/core';
// import {AuthService} from '../../../shared/services/auth.service';
import {Router} from '@angular/router';
import {toSignal} from '@angular/core/rxjs-interop';
import {isPlatformBrowser} from '@angular/common';
import {firstValueFrom, Observable, of, Subject, Subscription, switchMap, takeUntil} from 'rxjs';
import {AuthService} from '../../../shared/services/auth.service.ngrx';
import {Store} from '@ngrx/store';
import {selectCurrentUser, selectUserRoles} from '../../../../core/auth/auth.selectors';
import {AuthState, UserInfo} from '../../../../core/auth/auth.state';


interface MenuItem {
  icon: string;
  title: string;
  route: string;
  roles?: string[];
}
@Component({
  selector: 'app-dashboard-layout',
  standalone: false,
  templateUrl: './dashboard-layout.component.html',
  styleUrl: './dashboard-layout.component.scss'
})
export class DashboardLayoutComponent implements OnInit, OnDestroy {
  private destroy$ = new Subject<void>();
  sidebarOpen = true;
  userName = computed<string>(()=>{
    let user= this.user$();
    if(user){
      return user.name;
    }
    return '';
  });
  userEmail = computed<string>(()=>{
    let user= this.user$();
    if(user){
      return user.email;
    }
    return '';
  });
  user$!: Signal<UserInfo|null>;
  menuItems: MenuItem[] = [
    { icon: 'home', title: 'Ana Sayfa', route: '/dashboard' },
    { icon: 'app', title: 'Uygulamalarım', route: '/dashboard/appbuilds' },
    { icon: 'globe', title: 'Alan adı ve uygulama', route: '/dashboard/deployment' },
    { icon: 'database', title: 'Veritabanı Sorguları', route: '/dashboard/db-queries', },
    { icon: 'package', title: 'Ürünler', route: '/products', roles: ['business_admin', 'business_staff'] },
    { icon: 'users', title: 'Müşteriler', route: '/customers', roles: ['business_admin'] },
    { icon: 'truck', title: 'Kuryeler', route: '/couriers', roles: ['business_admin'] },
    { icon: 'bar-chart', title: 'Raporlar', route: '/reports', roles: ['business_admin'] },
    { icon: 'settings', title: 'Ayarlar', route: '/settings', roles: ['business_admin'] }
  ];
  private authenticatedSubscription!: Subscription;

  currentDate:Date = new Date();

  constructor(
    private store: Store,
    private authService: AuthService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId:Object
  ) {
    this.user$= this.store.selectSignal(selectCurrentUser);
  }
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
    this.authenticatedSubscription.unsubscribe();
  }

  ngOnInit(): void {
    // if(isPlatformBrowser(this.platformId)){
    //   this.authenticatedSubscription=this.authService.initAuth().isAuthenticated$.subscribe(isAuthenticated => {
    //     if(isAuthenticated){
    //       this.authService.currentUser$.pipe(
    //         takeUntil(this.destroy$),
    //         switchMap(account => {
    //           if (account) {
    //             return of(account);
    //           }
    //           return of(null);
    //         })
    //       ).subscribe(profile => {
    //         if (profile) {
    //           this.userName = profile.username ?? 'Kullanıcı';
    //           this.userEmail = profile.email ?? '';
    //         }
    //       });
    //     }
    //   })
    // }
  }

  hasRequiredRole(item: MenuItem): boolean {
    if (!item.roles) return true;
    let currentUSerRoles= this.store.selectSignal(selectUserRoles)();
    return item.roles.some(role => currentUSerRoles.some(a=>a===role));
  }

  toggleSidebar(): void {
    this.sidebarOpen = !this.sidebarOpen;
  }

  async logout(): Promise<void> {
    try {
      await firstValueFrom(this.authService.logout());
      // await this.router.navigate(['/']);
    } catch (error) {
      console.error('Logout error:', error);
    }
  }


}
