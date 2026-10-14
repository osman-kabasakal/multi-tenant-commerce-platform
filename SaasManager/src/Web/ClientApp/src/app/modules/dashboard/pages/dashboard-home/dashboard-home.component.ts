import {Component, OnInit} from '@angular/core';
import {AuthService} from '../../../shared/services/auth.service.ngrx';
import {UserInfo} from '../../../../core/auth/auth.state';
import {Store} from '@ngrx/store';
import {selectAuthState} from '../../../../core/auth/auth.selectors';

@Component({
  selector: 'app-dashboard-home',
  standalone: false,
  templateUrl: './dashboard-home.component.html',
  styleUrl: './dashboard-home.component.scss'
})
export class DashboardHomeComponent implements OnInit {

  constructor(private store: Store,) {

  }

   userInfo!: UserInfo;
    ngOnInit(): void {
      this.userInfo =  this.store.selectSignal(selectAuthState)().user!;
    }

}
