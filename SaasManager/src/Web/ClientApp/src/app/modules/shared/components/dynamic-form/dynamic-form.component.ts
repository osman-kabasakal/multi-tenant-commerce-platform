import {
  Component,
  Input,
  Output,
  EventEmitter,
  OnInit,
  OnDestroy,
  signal,
  OnChanges,
  SimpleChanges
} from '@angular/core';
import {FormGroup, FormBuilder, Validators} from '@angular/forms';
import {Subscription, interval} from 'rxjs';
import {takeWhile} from 'rxjs/operators';
import {IFieldDefinition} from '../../interfaces/api-response';

@Component({
  selector: 'app-dynamic-form',
  standalone: false,
  templateUrl: './dynamic-form.component.html',
  styleUrl: './dynamic-form.component.scss'
})
export class DynamicFormComponent implements OnInit, OnDestroy, OnChanges {
  @Input() fields: { [key: string]: IFieldDefinition } = {};
  @Input() validationToken: string | null = null;
  @Input() submitButtonText = 'İlerle';
  @Input() isSubmitting = false;
  @Input() error: string | null = null;
  @Input() timeoutSeconds = 0;

  @Input() serverError: { [key: string]: string[] } | null = null;

  @Output() formSubmit = new EventEmitter<any>();

  @Input() stateKey:string|null=null;

  handledFields= signal< { [key: string]: IFieldDefinition }>({})


  form: FormGroup;
  timeLeft = 0;
  private timerSubscription?: Subscription;

  formSubmitted = signal(false);

  constructor(private fb: FormBuilder) {
    this.form = this.fb.group({});
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes["fields"]) {
      this.formSubmitted.set(false);
    }

    if(changes["stateKey"]){
      this.initializeForm();
      this.handledFields.set(this.fields);
    }
  }

  ngOnInit() {
    this.initializeForm();
    this.startTimer();


  }

  ngOnDestroy() {
    if (this.timerSubscription) {
      this.timerSubscription.unsubscribe();
    }
  }

  private initializeForm() {
    this.formSubmitted.set(false);
    const group: any = {};
    if(!this.fields){
      this.form= new FormGroup({});
      return;
    }

    Object.entries(this.fields).forEach(([key, field]) => {
      const validators = [];

      if (field.required) {
        validators.push(Validators.required);
      }

      if (((field.validations) ?? false)) {
        if ((field.validations!["pattern"] ?? false)) {
          validators.push(Validators.pattern(field.validations!["pattern"]));
        }

        if ((field.validations!["minLength"] ?? false)) {
          validators.push(Validators.minLength(field.validations!["minLength"]));
        }

        if ((field.validations!["maxLength"] ?? false)) {
          validators.push(Validators.maxLength(field.validations!["maxLength"]));
        }

        if ((field.validations!["min"] ?? false)) {
          validators.push(Validators.min(field.validations!["min"]));
        }

        if ((field.validations!["max"] ?? false)) {
          validators.push(Validators.max(field.validations!["max"]));
        }

      }

      if (field.type === 'email') {
        validators.push(Validators.email);
      }

      group[key] = ['', validators];
    });


    this.form = this.fb.group(group);
  }

  private startTimer() {
    if (this.validationToken && this.timeoutSeconds > 0) {
      this.timeLeft = this.timeoutSeconds;

      this.timerSubscription = interval(1000)
        .pipe(takeWhile(() => this.timeLeft > 0))
        .subscribe(() => {
          this.timeLeft--;
          if (this.timeLeft === 0) {
            this.form.disable();
          }
        });
    }
  }

  isFieldInvalid(fieldName: string): boolean {
    const field = this.form.get(fieldName);
    return field ? (field.invalid && (field.dirty || field.touched)) : false;
  }

  getErrorMessages(fieldName:string):string[]{
    const field = this.form.get(fieldName);
    let messages:string[]= [];
    if(field && field.errors && this.fields[fieldName] && this.fields[fieldName].validationMessages){
      for (const fieldElement of Object.keys(field.errors)) {
        if(this.fields[fieldName].validationMessages[fieldElement]){
          messages.push(this.fields[fieldName].validationMessages[fieldElement]);
        }
      }
    }
    return messages;
  }

  onSubmit() {
    if (!this.formSubmitted() && this.form.valid && !this.isSubmitting && !(this.timeoutSeconds > 0 && this.timeLeft === 0)) {
      this.formSubmitted.set(true);
      this.formSubmit.emit(this.form.value);
    }
  }

  onPlanSelected(planId: string) {
    if (this.stateKey === 'SubscriptionSelectionState') {
      this.form.patchValue({ planId });
      this.formSubmit.emit(this.form.value);
    }
  }

  protected readonly Object = Object;
}
