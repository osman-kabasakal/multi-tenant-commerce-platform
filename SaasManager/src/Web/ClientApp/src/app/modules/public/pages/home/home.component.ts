import { Component } from '@angular/core';
import {TrialSectionComponent} from './components/trial-section/trial-section.component';
import {FeatureSectionComponent} from './components/feature-section/feature-section.component';
import {HeroSectionComponent} from './components/hero-section/hero-section.component';
import {PricingSectionComponent} from './components/pricing-section/pricing-section.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    TrialSectionComponent,
    FeatureSectionComponent,
    HeroSectionComponent,
    PricingSectionComponent
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {

}
