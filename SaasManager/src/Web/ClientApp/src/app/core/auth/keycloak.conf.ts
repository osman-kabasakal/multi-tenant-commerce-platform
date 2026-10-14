import Keycloak, {KeycloakInitOptions} from "keycloak-js";
import {environment} from '../../../environments/environment';

export const keycloakConfig = {
  url: environment.keycloak.url,
  realm: environment.keycloak.realm,
  clientId: environment.keycloak.clientId,

  // OIDC yapılandırma
  oidcConfiguration: <KeycloakInitOptions>{
    pkceMethod: 'S256', // PKCE koruması
    // redirectUri: environment.selfHost + '/auth/callback',
    silentCheckSsoRedirectUri: environment.selfHost + '/silent-check-sso.html',
    silentCheckSsoFallback: true,
    scope: 'openid profile email roles',
    responseType: 'code',
    checkLoginIframe: false,
    onLoad: 'login-required', // check-sso yerine login-required kullan
    flow: 'standard',         // Standard Authorization Code flow kullan
    responseMode: 'query'
  },

  // Token yapılandırma
  tokenConfig: {
    minValidity: 30, // Token yenileme için minimum geçerlilik süresi (saniye)
    maxTokenExpiry: 300, // Maksimum token süresi (5 dakika)
    refreshTokenExpiry: 1800, // Refresh token süresi (30 dakika)
  },

  // Güvenlik yapılandırma
  securityConfig: {
    enableCsrfProtection: true,
    enableXssProtection: true,
    requireHttps: true,
  }
};
