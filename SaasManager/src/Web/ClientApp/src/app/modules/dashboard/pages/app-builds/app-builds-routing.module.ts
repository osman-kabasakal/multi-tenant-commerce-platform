import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppBuildsComponent } from './app-builds.component';
import {AuthGuard} from '../../../shared/guards/auth.guard.ngrx';
import {AppsComponent} from './apps/apps.component';
import {AppBuildListComponent} from './components/app-build-list-component/app-build-list.component';
import {NewBuildFormComponent} from './new-build-form/new-build-form.component';

const routes: Routes = [{ path: '', component: AppBuildsComponent,canActivate: [AuthGuard],
children:[
  {
    path: '',
    component: AppsComponent
  },
  {
    path: 'new',
    component: NewBuildFormComponent
  }
]
}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AppBuildsRoutingModule { }
