import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { IdentityManagementRoutingModule } from './identity-management-routing.module';
import {ReactiveFormsModule} from '@angular/forms';
import { RegistrationComponent } from './registration/registration.component';
import {TenantDomainOwnershipComponent} from '../../../shared/components/tenant-domain-ownership/tenant-domain-ownership.component';
import {SharedModule} from '../../../shared/shared.module';


@NgModule({
  declarations: [
    RegistrationComponent
  ],
  imports: [
    ReactiveFormsModule,
    CommonModule,
    IdentityManagementRoutingModule,
    SharedModule,
    TenantDomainOwnershipComponent,
  ],
  exports: [

  ]
})
export class IdentityManagementModule { }
