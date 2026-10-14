import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';
import {SharedModule} from '../shared/shared.module';
import {DashboardLayoutComponent} from './layouts/dashboard-layout/dashboard-layout.component';
import {DashboardHomeComponent} from './pages/dashboard-home/dashboard-home.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { DatabaseCreationDashboardComponent } from './pages/dashboard-home/components/database-creation-dashboard/database-creation-dashboard.component';
import { DbQueriesComponent } from './pages/db-queries/db-queries.component';


@NgModule({
  declarations: [
    DashboardLayoutComponent,
    DashboardHomeComponent,
    DatabaseCreationDashboardComponent,
    DbQueriesComponent
  ],
  imports: [
    CommonModule,
    DashboardRoutingModule,
    SharedModule,
    ReactiveFormsModule,
    FormsModule
  ],
  exports:[
    SharedModule,
    ReactiveFormsModule
  ]
})
export class DashboardModule { }
