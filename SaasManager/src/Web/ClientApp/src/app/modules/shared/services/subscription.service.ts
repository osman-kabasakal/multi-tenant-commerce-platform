import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {IServiceResponse, SubscriptionPlan} from '../interfaces/api-response';

@Injectable({
  providedIn: 'root'
})
export class SubscriptionService {
  constructor(private http: HttpClient) {}

  getPlans(): Observable<IServiceResponse<SubscriptionPlan[]>> {
    return this.http.get<IServiceResponse<SubscriptionPlan[]>>('/api/subscription/plans');
  }
}
