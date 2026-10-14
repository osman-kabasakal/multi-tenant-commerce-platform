import {Component, Inject, OnDestroy, OnInit, PLATFORM_ID, Signal, WritableSignal} from '@angular/core';
import {RegistrationService} from '../../../../shared/services/identity-management/registration-service.service';
import {Router} from '@angular/router';
import {Observable} from 'rxjs';
import {IRegistrationStepResponse} from '../../../../shared/interfaces/api-response';
import {toSignal} from '@angular/core/rxjs-interop';
import {isPlatformBrowser} from '@angular/common';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrl: './registration.component.scss'
})
export class RegistrationComponent implements OnInit, OnDestroy {
  currentStep$:Signal<IRegistrationStepResponse | null>;

  constructor(
    private registrationService: RegistrationService,
    private router: Router,
    @Inject(PLATFORM_ID)private  platformId:Object,
  ) {
    this.currentStep$ = this.registrationService.getCurrentStep();
  }

  ngOnDestroy(): void {
    }

  ngOnInit() {
    this.registrationService.initializeRegistration().subscribe(response=>{
      if(response.isCompleted){
        this.router.navigate(['/dashboard']);
      }
    });
  }

  onSubmit(formData: any) {
    this.registrationService.submitStep(formData).subscribe(response => {
      debugger;
      if (response.isCompleted) {
        this.router.navigate(['/dashboard']);
      }
    });
  }

  protected readonly parseInt = parseInt;
}
