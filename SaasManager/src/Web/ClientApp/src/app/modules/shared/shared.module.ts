import { APP_INITIALIZER, inject, NgModule, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { HeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';
import { RouterLink } from '@angular/router';
import { DynamicFormComponent } from './components/dynamic-form/dynamic-form.component';
import { ReactiveFormsModule } from '@angular/forms';
import {
  SubscriptionPlanSelectorComponent
} from './components/subscription-plan-selector/subscription-plan-selector.component';
import { FileUploadComponentComponent } from './components/file-upload-component/file-upload-component.component';

@NgModule({
  providers: [
  ],
  declarations: [
    HeaderComponent,
    FooterComponent,
    DynamicFormComponent,
    SubscriptionPlanSelectorComponent,
    FileUploadComponentComponent
  ],
  exports: [
    HeaderComponent,
    FooterComponent,
    DynamicFormComponent,
    SubscriptionPlanSelectorComponent,
    FileUploadComponentComponent
  ],
  imports: [
    CommonModule,
    RouterLink,
    ReactiveFormsModule
  ]
})
export class SharedModule { }
