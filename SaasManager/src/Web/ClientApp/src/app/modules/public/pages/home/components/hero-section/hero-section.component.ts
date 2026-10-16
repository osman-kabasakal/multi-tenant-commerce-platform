import { Component } from '@angular/core';
import {RouterLink} from '@angular/router';
import {FaIconComponent} from '@fortawesome/angular-fontawesome';
import {faChartLine, faClock, faStore} from '@fortawesome/free-solid-svg-icons';
import {ColorPalette} from '../../../../../shared/interfaces/collor-palette';
import {palletes} from './hero-color-palettes';

@Component({
  selector: 'app-hero-section',
  standalone: true,
  imports: [
    FaIconComponent,
    RouterLink
  ],
  templateUrl: './hero-section.component.html',
  styleUrl: './hero-section.component.scss',

})
export class HeroSectionComponent {

  // Örnek renk paleti - bu kısmı değiştirerek farklı renk kombinasyonlarını test edebilirsiniz
  colorPalette: ColorPalette = palletes.palette3;

  features = [
    {
      icon: faStore,//'fas fa-store',
      title: 'Fiziksel & Online Satış',
      description: 'Tek platformdan tüm satışlarınızı yönetin'
    },
    {
      icon: faClock,//'fas fa-clock',
      title: 'Hızlı Teslimat',
      description: 'Esnek kurye ağıyla siparişleri anında teslim edin'
    },
    {
      icon: faChartLine,//'fas fa-chart-line',
      title: 'Stok Optimizasyonu',
      description: 'Gerçek zamanlı stok takibiyle satışları kaçırmayın'
    }
  ];

  getGradientStyle() {
    return {
      'background': `linear-gradient(to bottom right, ${this.colorPalette.gradient.from}, ${this.colorPalette.gradient.via}, ${this.colorPalette.gradient.to})`
    };
  }

  getTitleGradientStyle() {
    return {
      // 'color':'transparent',
      // '--tw-gradient-to':`${this.colorPalette.text.secondary} var(--tw-gradient-to-position)`,
      // '--tw-gradient-from':`${this.colorPalette.text.primary} var(--tw-gradient-from-position)`,
      // '--tw-gradient-stops':'var(--tw-gradient-from), var(--tw-gradient-to)',
      // 'background': `-webkit-linear-gradient(to right, ${this.colorPalette.text.primary}, ${this.colorPalette.text.secondary})`,
      'background': `linear-gradient(to right, ${this.colorPalette.text.primary}, ${this.colorPalette.text.secondary})`,
      'color':`transparent`,
      'background-clip': 'text',
      'text-fill-color': 'transparent'
    };
  }

  getCardStyle() {
    return {
      'background-color': this.colorPalette.card.background,
      'border': `1px solid ${this.colorPalette.card.border}`,
      'backdrop-filter': 'blur(8px)'
    };
  }

  getPrimaryButtonStyle() {
    return {
      'background-color': this.colorPalette.button.primary.background,
      'color': this.colorPalette.button.primary.text,
      '&:hover': {
        'background-color': this.colorPalette.button.primary.hover
      }
    };
  }

  getSecondaryButtonStyle() {
    return {
      'border': `2px solid ${this.colorPalette.button.secondary.border}`,
      'color': this.colorPalette.button.secondary.text,
      '&:hover': {
        'background-color': this.colorPalette.button.secondary.hover
      }
    };
  }

  watchDemo() {
    // Demo izleme fonksiyonu
    console.log('Demo izleme başlatıldı');
  }
}
