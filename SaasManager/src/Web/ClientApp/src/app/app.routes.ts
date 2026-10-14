import { Routes } from '@angular/router';
import {AuthStateGuard} from './modules/shared/guards/auth-state.guard';

export const routes: Routes = [
  {
    path:'',
    children:[
      {
        path: 'dashboard',
        loadChildren: () => import('./modules/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: '',
        loadChildren: () => import('./modules/public/public.module').then(m => m.PublicModule)
      },
    ]
  }
];
