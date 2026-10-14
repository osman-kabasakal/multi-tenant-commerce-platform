import {Component, OnInit} from '@angular/core';

@Component({
  selector: 'app-apps',
  standalone: false,
  templateUrl: './apps.component.html',
  styleUrl: './apps.component.scss'
})
export class AppsComponent  implements  OnInit{
  activeTab = 'builds';

  ngOnInit(): void {}

  setActiveTab(tab: string): void {
    this.activeTab = tab;
  }
}
