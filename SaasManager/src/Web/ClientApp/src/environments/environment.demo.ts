export const environment = {
  localDemo: true,
  production: false,
  selfHost: window.location.origin + '/',
  keycloak: {
    url: 'http://localhost:18080', realm: 'commerce-demo', clientId: 'centraladminapp',
    redirectUri: window.location.origin + '/auth/callback',
    silentCheckSsoRedirectUri: window.location.origin + '/silent-check-sso.html'
  }
};
