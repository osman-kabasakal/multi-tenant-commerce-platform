export interface IServiceResponse<T> {
  isSuccess?: boolean;
  data?: T | undefined;
  errorCode?: string | undefined;
  errorMessage?: string | undefined;
}
export interface IFieldDefinition {
  type?: string;
  label?: string;
  required?: boolean;
  validations?: { [key: string]: any; } | undefined;
  validationMessages:{ [key: string]: string; } | undefined;
}


interface FieldDefinition {
  type: 'text' | 'email' | 'tel' | 'select' | 'textarea';
  label: string;
  required?: boolean;
  defaultValue?: any;
  validations?: {
    pattern?: string;
    min?: number;
    max?: number;
  };
  options?: Array<{
    value: string;
    label: string;
  }>
}



export interface IGuestTokenResponse {
  token?: string;
  expiresAt?: string;
  guestId?: string;
}


export interface IRegistrationCommand {
  stepKey?: string;
  data?: { [key: string]: any; };
  validationToken?: string | undefined;
}


export interface IRegistrationStepResponse {
  currentStep?: string;
  expectedParams?: { [key: string]: IFieldDefinition; } | undefined;
  validationUrl?: string | undefined;
  validationToken?: string | undefined;
  timeoutSeconds?: number | undefined;
  isCompleted?: boolean;
  redirectUrl?: string | undefined;

  hasValidationError: boolean;
  operationErrorMessage: string|undefined;
  errors:{[key:string]:string[]};
}


export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  code: string;
  description: string;
  features: string[];
  maxProducts: number;
  maxUsers: number;
  maxMonthlyOrders: number;
  hasPos: boolean;
  hasCourier: boolean;
  trialDays: number;
}

export enum AppMediaAssetType {
  Logo = 'Logo',
  Icon = 'Icon',
  Splash = 'Splash'
}
