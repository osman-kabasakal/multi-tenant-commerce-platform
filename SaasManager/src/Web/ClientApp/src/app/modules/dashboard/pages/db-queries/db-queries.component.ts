import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../../../environments/environment';

// TypeScript interface definitions for API responses
interface BaseResponse {
  success: boolean;
}

interface ErrorResponse extends BaseResponse {
  error: string;
}

interface QueryResponse<T> extends BaseResponse {
  data: T;
}

interface QueryAffectedRowsResponse extends BaseResponse {
  affectedRows: number;
}

interface TableNamesResponse extends BaseResponse {
  tables: string[];
}

interface TableColumnInfo {
  name: string;
  dataType: string;
  isNullable: boolean;
  defaultValue: string | null;
}

interface TableColumnsResponse extends BaseResponse {
  columns: TableColumnInfo[];
}

interface BusinessAppDto {
  id: string;
  businessId: string;
  type: string;
  appName: string;
  packageName: string;
  created: string;
  createdBy: string;
}

interface BusinessDto {
  id: string;
  name: string;
  legalCompanyName: string;
  createdByGuestId: string;
  status: string;
  isActive: boolean;
  created: string;
}

interface BusinessAppsResponse extends BaseResponse {
  data: BusinessAppDto[];
}

interface BusinessesResponse extends BaseResponse {
  data: BusinessDto[];
}

@Component({
  selector: 'app-db-queries',
  templateUrl: './db-queries.component.html',
  styleUrls: ['./db-queries.component.scss']
})
export class DbQueriesComponent implements OnInit {
  sqlQuery: string = '';
  queryResult: any[] = [];
  queryAffectedRows: number | null = null;
  errorMessage: string = '';
  tables: string[] = [];
  tableFilter: string = '';
  selectedTable: string | null = null;
  tableColumns: TableColumnInfo[] = [];
  apiKey: string = 'r876hjygfcfrvvbh'; // Varsayılan anahtar

  constructor(private http: HttpClient) { }

  ngOnInit(): void {
    this.loadTables();
  }

  // Tüm HTTP isteklerinde API anahtarını header olarak ekleyen yardımcı metod
  private getRequestOptions() {
    return {
      headers: {
        'db-query-key': this.apiKey
      }
    };
  }

  executeQuery(): void {
    this.errorMessage = '';
    this.queryResult = [];
    this.queryAffectedRows = null;

    if (!this.sqlQuery.trim()) {
      this.errorMessage = 'Sorgu boş olamaz';
      return;
    }

    const isSelectQuery = this.sqlQuery.trim().toLowerCase().startsWith('select');

    this.http.post<QueryResponse<any[]> | QueryAffectedRowsResponse>(
        `/api/DbQueries/execute`,
        { query: this.sqlQuery },
        this.getRequestOptions()
      ).subscribe({
        next: (response) => {
          if (response.success) {
            if ('data' in response) {
              // It's a SELECT query response
              this.queryResult = response.data || [];
            } else if ('affectedRows' in response) {
              // It's an INSERT/UPDATE/DELETE query response
              this.queryAffectedRows = response.affectedRows;
            }
          } else {
            const errorResp = response as unknown as ErrorResponse;
            this.errorMessage = errorResp.error || 'Bilinmeyen bir hata oluştu';
          }
        },
        error: (error) => {
          this.errorMessage = error.error?.error || error.message || 'Sorgu çalıştırılırken bir hata oluştu';
        }
      });
  }

  loadTables(): void {
    this.http.get<TableNamesResponse>(
      `/api/DbQueries/tables`,
      this.getRequestOptions()
    ).subscribe({
        next: (response) => {
          if (response.success) {
            this.tables = response.tables || [];
          }
        },
        error: (error) => {
          this.errorMessage = 'Tablolar yüklenirken bir hata oluştu';
        }
      });
  }

  get filteredTables(): string[] {
    if (!this.tableFilter) {
      return this.tables;
    }
    return this.tables.filter(table =>
      table.toLowerCase().includes(this.tableFilter.toLowerCase())
    );
  }

  selectTable(tableName: string): void {
    this.selectedTable = tableName;
    this.sqlQuery = `SELECT * FROM public."${tableName}" LIMIT 50`;
    this.loadTableColumns(tableName);
  }

  loadTableColumns(tableName: string): void {
    this.http.get<TableColumnsResponse>(
      `/api/DbQueries/table/${tableName}/columns`,
      this.getRequestOptions()
    ).subscribe({
        next: (response) => {
          if (response.success) {
            this.tableColumns = response.columns || [];
          }
        },
        error: (error) => {
          this.errorMessage = `Tablo yapısı yüklenirken bir hata oluştu: ${error.message}`;
        }
      });
  }

  getResultHeaders(): string[] {
    if (this.queryResult.length === 0) {
      return [];
    }
    return Object.keys(this.queryResult[0]);
  }

  formatValue(value: any): string {
    if (value === null || value === undefined) {
      return 'NULL';
    }

    if (typeof value === 'object') {
      if (value instanceof Date) {
        return value.toLocaleString();
      }
      return JSON.stringify(value);
    }

    return String(value);
  }
}
