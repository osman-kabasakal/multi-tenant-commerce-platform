import {createFeatureSelector, createSelector} from '@ngrx/store';
import {AuthState} from './auth.state';

export const selectAuthState = createFeatureSelector<AuthState>('auth');

export const selectCurrentUser = createSelector(
  selectAuthState,
  (state) => state.user
);

export const selectIsAuthenticated = createSelector(
  selectAuthState,
  (state) => state.isAuthenticated
);

export const selectUserRoles = createSelector(
  selectAuthState,
  (state) => state.roles
);

export const selectUserPermissions = createSelector(
  selectAuthState,
  (state) => state.permissions
);

export const selectBusinessId = createSelector(
  selectAuthState,
  (state) => state.businessId
);
