import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {RegistrationComponent} from './registration/registration.component';
import {AuthGuard} from '../../../shared/guards/auth.guard.ngrx';

const routes: Routes = [
  { path: '', component: RegistrationComponent,canActivate:[AuthGuard] },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class IdentityManagementRoutingModule { }
