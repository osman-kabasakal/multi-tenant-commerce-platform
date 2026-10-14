import {credentialInfoSuccess, login, loginFailure, loginSuccess, logout, updateSession} from './auth.actions';
import {AuthState} from './auth.state';
import {createReducer, on} from '@ngrx/store';

export const initialState: AuthState = {
  user: null,
  roles: [],
  permissions: [],
  isAuthenticated: false,
  isLoading: false,
  error: null,
  registrationStep:null,
  credentialInfo: null
};

export const authReducer = createReducer(
  initialState,
  on(login, (state) => ({
    ...state,
    isLoading: true,
    error: null
  })),
  on(loginSuccess, (state, { user, roles, permissions,registrationStep, credentialInfo }) => ({
    ...state,
    user,
    roles,
    permissions,
    registrationStep: registrationStep,
    businessId: user.businessId,
    isAuthenticated: true,
    isLoading: false,
    error: null,
    credentialInfo: credentialInfo
  })),
  on(loginFailure, (state, { error }) => ({
    ...state,
    user: null,
    roles: [],
    permissions: [],
    businessId: undefined,
    isAuthenticated: false,
    isLoading: false,
    error
  })),
  on(logout, () => initialState),
  on(updateSession, (state, { user, roles, permissions }) => ({
    ...state,
    user,
    roles,
    permissions,
    businessId: user.businessId
  })),

  on(credentialInfoSuccess, (state, { credentialInfo }) => ({
    ...state,
    credentialInfo:credentialInfo
  }))
);
