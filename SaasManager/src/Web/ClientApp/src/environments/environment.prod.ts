export const environment = {
  localDemo: false,
  production: true,
  selfHost:'https://commerce.test/',
  keycloak: {
    url: 'https://identity.commerce.test',
    realm: 'localhost',
    clientId: 'saas-management',
    redirectUri: 'https://localhost:44447/auth/callback',
    silentCheckSsoRedirectUri: 'https://localhost:44447/silent-check-sso.html'
  }
};
