import { Component } from '@angular/core';
import {AppBuildDto} from '../../../../../../web-api-client';
import {AppBuildService} from '../../../../services/app-build.service';

@Component({
  selector: 'app-build-list',
  templateUrl: './app-build-list.component.html',
  styleUrl: './app-build-list.component.scss'
})
export class AppBuildListComponent {
  appBuilds: AppBuildDto[] = [];
  currentPage = 1;
  totalPages = 0;
  isLoading = false;
  error: string | null = null;

  constructor(private appBuildService: AppBuildService) {}

  ngOnInit(): void {
    this.loadAppBuilds();
  }

  loadAppBuilds(): void {
    this.isLoading = true;
    this.appBuildService.getAppBuildList(this.currentPage)
      .subscribe({
        next: (data) => {
          this.appBuilds = data.appBuilds?.items??[];
          this.currentPage = data.appBuilds?.pageNumber??1;
          this.totalPages = data.appBuilds?.totalPages??0;
          this.isLoading = false;
        },
        error: (err) => {
          this.error = 'Failed to load app builds. Please try again.';
          this.isLoading = false;
          console.error('Error loading app builds:', err);
        }
      });
  }

  changePage(page: number): void {
    this.currentPage = page;
    this.loadAppBuilds();
  }

  formatFileSize(bytes: number): string {
    if (bytes < 1024) return bytes + ' B';
    else if (bytes < 1048576) return (bytes / 1024).toFixed(2) + ' KB';
    else if (bytes < 1073741824) return (bytes / 1048576).toFixed(2) + ' MB';
    else return (bytes / 1073741824).toFixed(2) + ' GB';
  }

  downloadAppBuild(buildId: string): void {
    this.appBuildService.downloadAppBuild(buildId)
      .subscribe({
        next: (data) => {
          const blob = data;
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          const build = this.appBuilds.find(item => item.id === buildId);
          a.download = data.type === 'application/vnd.android.package-archive' ? `app-${build?.buildNumber ?? 'build'}.apk` : 'app-build.zip';
          document.body.appendChild(a);
          a.click();
          a.remove();
          window.URL.revokeObjectURL(url);
        },
        error: (err) => {
          console.error('Error downloading app build:', err);
        }
      });
  }
}
