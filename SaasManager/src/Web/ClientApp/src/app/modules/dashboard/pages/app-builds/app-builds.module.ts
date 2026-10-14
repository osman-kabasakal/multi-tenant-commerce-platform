import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AppBuildsRoutingModule } from './app-builds-routing.module';
import { AppBuildsComponent } from './app-builds.component';
import {AppsComponent} from './apps/apps.component';
import {NewBuildFormComponent} from './new-build-form/new-build-form.component';
import {AppBuildListComponent} from './components/app-build-list-component/app-build-list.component';
import {RouterLink} from '@angular/router';
import {ReactiveFormsModule} from '@angular/forms';
import {SharedModule} from '../../../shared/shared.module';


@NgModule({
  declarations: [
    AppBuildsComponent,
    AppsComponent,
    NewBuildFormComponent,
    AppBuildListComponent
  ],
  imports: [
    CommonModule,
    AppBuildsRoutingModule,
    RouterLink,
    ReactiveFormsModule,
    SharedModule
  ]
})
export class AppBuildsModule { }
