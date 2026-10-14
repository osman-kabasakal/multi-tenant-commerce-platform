import { Component } from '@angular/core';
import {SharedModule} from '../../../../../shared/shared.module';

@Component({
  selector: 'app-pricing-section',
  standalone: true,
  imports: [
    SharedModule
  ],
  templateUrl: './pricing-section.component.html',
  styleUrl: './pricing-section.component.scss'
})
export class PricingSectionComponent {

  planSelectionHandler(planId:string){
    console.log('plan seçildi',planId);
  }
}
