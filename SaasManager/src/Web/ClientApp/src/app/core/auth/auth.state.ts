import {IRegistrationStepResponse} from '../../modules/shared/interfaces/api-response';


export interface ICredentialInfo{
  accessToken:string;
  refreshToken: string;
  expiresIn:number;
  refreshExpiresIn: number;
}

export interface AuthState {
  user: UserInfo | null;
  roles: string[];
  permissions: string[];
  businessId?: string;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  registrationStep: IRegistrationStepResponse | null
  credentialInfo: ICredentialInfo|null
}

export interface UserInfo {
  id: string;
  email: string;
  name: string;
  businessId?: string;
  type: 'business_owner' | 'business_staff' | 'courier' | 'super_admin';
  isSetupCompleted:boolean;
}
