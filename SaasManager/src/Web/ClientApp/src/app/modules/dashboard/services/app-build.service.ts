import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {IServiceResponse} from '../../shared/interfaces/api-response';
import {AppBuildList, NewBuildDto, NewBuildVm} from '../../../web-api-client';
import {map} from 'rxjs/operators';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AppBuildService {

  constructor(private http: HttpClient) { }

  getAppBuildList(pageNumber: number = 1, pageSize: number = 10): Observable<AppBuildList> {
    return this.http
      .post<IServiceResponse<AppBuildList>>('/api/app-builds/list', { pageNumber, pageSize })
      .pipe(map(response => response.data!));
  }

  getNewBuildVm(): Observable<NewBuildVm> {
    return this.http
      .get<IServiceResponse<NewBuildVm>>('/api/app-builds/get-vm')
      .pipe(map(response => response.data!));
  }

  createNewBuild(newBuild: NewBuildDto): Observable<NewBuildDto> {
    return this.http
      .post<IServiceResponse<NewBuildDto>>('/api/app-builds/new-build', { newBuild })
      .pipe(map(response => response.data!));
  }

  downloadAppBuild(buildId: string): Observable<Blob> {
    return this.http
      .get('/api/app-builds/download?', { responseType: 'blob',params:{'AppBuildId':buildId} });
  }
}
