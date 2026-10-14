import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {PublicLayoutComponent} from './layouts/public-layout/public-layout.component';
import {HomeComponent} from './pages/home/home.component';

const routes: Routes = [
  {
    path: '',
    component: PublicLayoutComponent,

    children:[
      {
        path: '',
        component: HomeComponent
      },
      {
        path: 'register',
        loadChildren: ()=> import('./pages/identity-management/identity-management.module').then(m => m.IdentityManagementModule),
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PublicRoutingModule { }
