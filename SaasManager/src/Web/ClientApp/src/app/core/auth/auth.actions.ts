import {createAction, props} from '@ngrx/store';
import {ICredentialInfo, UserInfo} from './auth.state';
import {IRegistrationStepResponse} from '../../modules/shared/interfaces/api-response';

export const login = createAction('[Auth] Login');
export const loginSuccess = createAction(
  '[Auth] Login Success',
  props<{ user: UserInfo;
    roles: string[];
    permissions: string[],
    registrationStep:IRegistrationStepResponse|null,
    credentialInfo: ICredentialInfo |null
  }>()
);



export const credentialInfoSuccess = createAction(
  '[Auth] Credential info success',
  props<{ credentialInfo: ICredentialInfo }>()
);

export const loginFailure = createAction(
  '[Auth] Login Failure',
  props<{ error: string }>()
);
export const logout = createAction('[Auth] Logout');
export const updateSession = createAction(
  '[Auth] Update Session',
  props<{ user: UserInfo; roles: string[]; permissions: string[] }>()
);
