import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
// import {AuthGuard} from '../shared/guards/auth.guard';
import {DashboardLayoutComponent} from './layouts/dashboard-layout/dashboard-layout.component';
import {DashboardHomeComponent} from './pages/dashboard-home/dashboard-home.component';
import {AuthGuard} from '../shared/guards/auth.guard.ngrx';
import { DbQueriesComponent } from './pages/db-queries/db-queries.component';

const routes: Routes = [
  {
    path: '',
    component: DashboardLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: '',
        component: DashboardHomeComponent,
        data:{

        }
      },
      { path: 'appbuilds', loadChildren: () => import('./pages/app-builds/app-builds.module').then(m => m.AppBuildsModule) },
      {
        path: 'db-queries',
        component: DbQueriesComponent,
        data: {

        }
      }
    ]
  },

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DashboardRoutingModule { }
