import {Component, EventEmitter, Injectable, Input, Output} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {firstValueFrom, Observable} from 'rxjs';
import {IServiceResponse, SubscriptionPlan} from '../../interfaces/api-response';
import {SubscriptionService} from '../../services/subscription.service';

@Component({
  selector: 'app-subscription-plan-selector',
  standalone: false,
  templateUrl: './subscription-plan-selector.component.html',
  styleUrl: './subscription-plan-selector.component.scss'
})
export class SubscriptionPlanSelectorComponent {
  @Input() selectedPlanId?: string;
  @Input() loading = false;
  @Output() planSelected = new EventEmitter<string>();

  plans: SubscriptionPlan[] = [];
  error: string | null = null;
  isSelectionLocked = false;
  constructor(private subscriptionService: SubscriptionService) {}

  ngOnInit() {
    this.loadPlans();
  }

  private async loadPlans() {
    try {
      this.loading = true;
      this.plans = (await firstValueFrom(this.subscriptionService.getPlans())).data??[];
    } catch (err) {
      this.error = 'Abonelik planları yüklenirken bir hata oluştu.';
      console.error('Plan yükleme hatası:', err);
    } finally {
      this.loading = false;
    }
  }

  selectPlan(planId: string) {
    if (this.isSelectionLocked) return;

    this.selectedPlanId = planId;
    this.planSelected.emit(planId);
    // Seçim yapıldıktan sonra kilitle
    this.isSelectionLocked = true;
  }

  // Seçimi resetlemek için
  reset() {
    this.selectedPlanId = undefined;
    this.isSelectionLocked = false;
  }
}
