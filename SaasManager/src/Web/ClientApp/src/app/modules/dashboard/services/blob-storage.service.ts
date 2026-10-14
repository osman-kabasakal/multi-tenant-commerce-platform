import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {IServiceResponse} from '../../shared/interfaces/api-response';
import {map} from 'rxjs/operators';
import {Observable} from 'rxjs';


interface UploadResponse {
  url: string;
  name: string;
}

@Injectable({
  providedIn: 'root'
})
export class BlobStorageService {

  constructor(private http: HttpClient) { }

  uploadFile(file: File, businessAppId: string, assetType: string, platform: string): Observable<{ url: string, name: string }> {
    // Create FormData for multipart/form-data request
    const formData = new FormData();
    formData.append('file', file);
    formData.append('businessAppId', businessAppId);
    formData.append('assetType', assetType);
    formData.append('platform', "Android");

    // Use ApiService to make the request
    return this.http.post<IServiceResponse<UploadResponse>>('/api/uploads/app-asset', formData)
      .pipe(
        map(response => response.data!)
      );
  }
}
