import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PublicRoutingModule } from './public-routing.module';
import {SharedModule} from '../shared/shared.module';
import {PublicLayoutComponent} from './layouts/public-layout/public-layout.component';
import { IdentityManagementModule } from './pages/identity-management/identity-management.module';


@NgModule({
  declarations: [
    PublicLayoutComponent,
  ],
  imports: [
    CommonModule,
    PublicRoutingModule,
    SharedModule
  ]
})
export class PublicModule { }
