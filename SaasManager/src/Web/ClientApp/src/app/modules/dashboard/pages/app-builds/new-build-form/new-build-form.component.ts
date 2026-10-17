import { Component } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import { Router } from '@angular/router';
import {finalize, forkJoin, of, switchMap} from 'rxjs';
import {catchError} from 'rxjs/operators';
import { NewBuildDto, NewBuildVm} from '../../../../../web-api-client';
import {AppBuildService} from '../../../services/app-build.service';
import {BlobStorageService} from '../../../services/blob-storage.service';
import {AppMediaAssetType} from '../../../../shared/interfaces/api-response';

@Component({
  selector: 'app-new-build-form',
  standalone: false,
  templateUrl: './new-build-form.component.html',
  styleUrl: './new-build-form.component.scss',
})
export class NewBuildFormComponent {
  buildForm: FormGroup;
  newBuildVm: NewBuildVm | null = null;
  isLoading = false;
  isSubmitting = false;
  error: string | null = null;
  logoFile: File | null = null;
  iconFile: File | null = null;
  splashFile: File | null = null;

  constructor(
    private fb: FormBuilder,
    private appBuildService: AppBuildService,
    private blobStorageService: BlobStorageService,
    private router: Router
  ) {
    this.buildForm = this.fb.group({
      businessAppId: ['', Validators.required],
      version: ['', [Validators.required, Validators.pattern(/^\d+\.\d+\.\d+$/)]],
      buildNumber: [1, [Validators.required, Validators.min(1)]]
    });
  }

  ngOnInit(): void {
    this.loadBuildViewModel();
  }

  loadBuildViewModel(): void {
    this.isLoading = true;
    this.appBuildService.getNewBuildVm().subscribe({
      next: (data) => {
        this.newBuildVm = data;
        this.buildForm.patchValue({
          businessAppId: data.businessAppId,
          version: data.version,
          buildNumber: data.buildNumber
        });
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Derleme bilgileri yüklenemedi. Lütfen yeniden deneyin.';
        this.isLoading = false;
        console.error('Error loading build VM:', err);
      }
    });
  }

  onLogoSelected(files: File[]): void {
    if (files.length > 0) {
      this.logoFile = files[0];
    } else {
      this.logoFile = null;
    }
  }

  onIconSelected(files: File[]): void {
    if (files.length > 0) {
      this.iconFile = files[0];
    } else {
      this.iconFile = null;
    }
  }

  onSplashSelected(files: File[]): void {
    this.splashFile = files[0] ?? null;
  }

  submitForm(): void {
    if (this.buildForm.invalid) {
      this.markAllAsTouched();
      return;
    }

    if (!this.newBuildVm?.usesExistingBranding && (!this.logoFile || !this.iconFile)) {
      this.error = 'Both logo and icon files are required.';
      return;
    }

    this.isSubmitting = true;
    this.error = null;
    const formValue = this.buildForm.value;

    const uploads = [];
    for (const platform of ['Android', 'Ios']) {
      for (const [file, type] of [
        [this.logoFile, AppMediaAssetType.Logo],
        [this.iconFile, AppMediaAssetType.Icon],
        [this.splashFile, AppMediaAssetType.WelcomeScreen]
      ] as const) {
        if (file) uploads.push(this.blobStorageService.uploadFile(file, formValue.businessAppId, type, platform));
      }
    }
    if (!uploads.length) uploads.push(of(null));

    forkJoin(uploads)
      .pipe(
        switchMap(() => {
          // After files are uploaded, create the build
          return this.appBuildService.createNewBuild(<NewBuildDto>{
            requestId: this.newBuildVm?.requestId,
            businessAppId: formValue.businessAppId,
            version: formValue.version,
            buildNumber: formValue.buildNumber,
            buildStatus: 'Queued'
          });
        }),
        catchError((error) => {
          this.error = error?.error?.errorMessage || error?.message || 'Derleme başlatılamadı. Sayfayı yenileyip tekrar deneyin.';
          console.error('Error creating build:', error);
          return of(null);
        }),
        finalize(() => {
          this.isSubmitting = false;
        })
      )
      .subscribe({
        next: (result) => {
          if (result) {
            // Navigate to the build list on success
            this.router.navigate(['/dashboard/appbuilds']);
          }
        }
      });
  }

  markAllAsTouched(): void {
    Object.keys(this.buildForm.controls).forEach(key => {
      this.buildForm.get(key)?.markAsTouched();
    });
  }

   hasError(field:string,validationType:string):boolean{
    let formField= this.buildForm.get(field);

    if(formField != null){
      if(formField!.errors != null){
        return formField!.errors![validationType] !== null;
      }else{
        return true;
      }
    }

    return true;
  }
}
