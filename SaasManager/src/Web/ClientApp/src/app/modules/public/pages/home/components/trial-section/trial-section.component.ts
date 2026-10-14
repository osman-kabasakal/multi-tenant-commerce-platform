import { Component } from '@angular/core';
import {NgForOf} from '@angular/common';

@Component({
  selector: 'app-trial-section',
  standalone: true,
  imports: [
  ],
  templateUrl: './trial-section.component.html',
  styleUrl: './trial-section.component.scss',
  styles:[
    `
      @keyframes blob {
        0% { transform: translate(0px, 0px) scale(1); }
        33% { transform: translate(30px, -50px) scale(1.1); }
        66% { transform: translate(-20px, 20px) scale(0.9); }
        100% { transform: translate(0px, 0px) scale(1); }
      }
      .animate-blob {
        animation: blob 7s infinite;
      }
      .animation-delay-2000 {
        animation-delay: 2s;
      }
    `
  ]
})
export class TrialSectionComponent {
  features: string[] = [
    'Özelleştirilmiş mobil uygulama',
    'Tam fonksiyonlu yönetim paneli',
    'Kurye entegrasyonu'
  ];
}
