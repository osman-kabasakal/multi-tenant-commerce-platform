import {HttpErrorResponse, HttpInterceptorFn} from '@angular/common/http';
import {catchError, map, timeout} from 'rxjs/operators';
import {throwError} from 'rxjs';

export const exceptionInterceptor: HttpInterceptorFn = (request, next) => {
debugger;
  const apiReq = request.clone({
    headers: request.headers.set('Content-Type', 'application/json')
  });

  return next(apiReq).pipe(timeout(30000)).pipe(
    catchError((error: HttpErrorResponse) => {
      // Global hata yönetimi
      if (error.status === 0) {
        // İnternet bağlantısı yok veya sunucuya erişilemiyor
        console.error('An error occurred:', error.error);
      } else {
        // Backend'den dönen hata
        console.error(
          `Backend returned code ${error.status}, body was: `,
          error.error
        );
      }
      return throwError(() => error);
    })
  );
};
