import { Component } from '@angular/core';
import {interval, Subscription} from 'rxjs';

@Component({
  selector: 'app-database-creation-dashboard',
  templateUrl: './database-creation-dashboard.component.html',
  styleUrl: './database-creation-dashboard.component.scss'
})
export class DatabaseCreationDashboardComponent {
  progress: number = 35;
  timeRemaining: number = 120; // seconds
  currentStep: string = 'creating_database';
  subscription!: Subscription;
  currentDate:Date = new Date();

  ngOnInit() {
    this.subscription = interval(1000).subscribe(() => {
      this.updateProgress();
    });
  }

  ngOnDestroy() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  }

  private updateProgress() {
    if (this.progress >= 100) {
      this.progress = 100;
      if (this.subscription) {
        this.subscription.unsubscribe();
      }
      return;
    }

    this.progress += 0.5;

    if (this.timeRemaining > 0) {
      this.timeRemaining -= 1;
    }

    // Update current step based on progress
    if (this.progress >= 75) {
      this.currentStep = 'finalizing';
    } else if (this.progress >= 50) {
      this.currentStep = 'migration';
    } else if (this.progress >= 25) {
      this.currentStep = 'creating_database';
    } else {
      this.currentStep = 'initializing';
    }
  }

  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  }

  getStepStatus(stepName: string): string {
    const steps = ['initializing', 'creating_database', 'migration', 'finalizing'];
    const currentIndex = steps.indexOf(this.currentStep);
    const stepIndex = steps.indexOf(stepName);

    if (stepIndex < currentIndex) return 'completed';
    if (stepIndex === currentIndex) return 'active';
    return 'pending';
  }

  protected readonly Date = Date;
}
