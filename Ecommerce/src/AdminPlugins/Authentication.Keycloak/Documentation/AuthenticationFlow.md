# Keycloak Authentication Flow

This document outlines the authentication flow between the application and Keycloak, showing both the login and logout processes.

## Login Flow

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant AdminUI as Grand.Web.OnlyAdmin
    participant KeycloakMiddleware
    participant AuthController as KeycloakAuthenticationController
    participant Keycloak
    participant CookieAuth as CookieAuthenticationService
    participant OpnIdService as OpnIdConnectGrandAuthenticationService
    participant DataStore as ExternalAuthentication Repository

    User->>Browser: Attempts to access protected resource
    Browser->>AdminUI: GET /admin/resource
    AdminUI->>KeycloakMiddleware: Request passes through middleware
    
    KeycloakMiddleware->>KeycloakMiddleware: Checks authentication status
    
    alt User not authenticated
        KeycloakMiddleware->>AuthController: Redirect to SuperAdminLogin
        AuthController->>Keycloak: Challenge with KeycloakAuthenticationScheme
        Browser->>Keycloak: Redirects to Keycloak login page
        User->>Keycloak: Enters credentials
        Keycloak->>Browser: Successful authentication (with auth code)
        Browser->>AdminUI: GET /signin-oidc (callback with code)
        AdminUI->>AuthController: Invokes KeycloakLoginCallback
        AuthController->>Keycloak: Exchange code for tokens
        Keycloak->>AuthController: Returns access_token, id_token, refresh_token
        
        AuthController->>AuthController: Validates JWT token
        AuthController->>OpnIdService: Authenticate(ExternalAuthParam, refreshToken, returnUrl)
        
        OpnIdService->>OpnIdService: Look up existing user
        
        alt Existing User
            OpnIdService->>DataStore: Update authentication tokens
            OpnIdService->>CookieAuth: Sign in existing user
        else New User
            OpnIdService->>DataStore: Create external auth record
            OpnIdService->>CookieAuth: Sign in new user
        end
        
        CookieAuth->>CookieAuth: Create tenant-specific cookies
        CookieAuth->>Browser: Set cookies
        OpnIdService->>Browser: Redirect to returnUrl
    else User has valid token
        KeycloakMiddleware->>KeycloakMiddleware: Extract user/tenant info from token
        KeycloakMiddleware->>AdminUI: Continue request processing
    end
    
    Browser->>User: Display protected resource
```

## Middleware Processing

```mermaid
flowchart TD
    A[Request] --> B{Has user token?}
    B -->|Yes| C[Validate JWT]
    B -->|No| D{Has store token?}
    
    C -->|Valid| E[Extract group info]
    C -->|Invalid| J[Redirect to login]
    
    D -->|Yes| F[Validate store JWT]
    D -->|No| G{Is OData request?}
    
    F -->|Valid| H[Set store context]
    F -->|Invalid| J
    
    G -->|Yes| I[Return 401]
    G -->|No| K{Should redirect?}
    
    K -->|Yes| J
    K -->|No| L[Continue]
    
    E --> L
    H --> L
```

## Logout Flow

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant AdminUI as Grand.Web.OnlyAdmin
    participant AuthController as KeycloakAuthenticationController
    participant Keycloak
    participant BackChannelMiddleware
    participant CookieAuth as CookieAuthenticationService
    participant SessionManager as LogoutSessionManager
    
    alt User-initiated logout
        User->>Browser: Clicks logout
        Browser->>AdminUI: GET /admin/logout
        AdminUI->>AuthController: Invokes OpenIdSignOut
        AuthController->>Keycloak: Logout with id_token_hint
        Keycloak->>Browser: Logout response
        AuthController->>CookieAuth: Sign out from all schemes
        CookieAuth->>Browser: Clear cookies
        Browser->>User: Redirect to login page
    else Back-channel logout
        Keycloak->>AdminUI: POST /admin/KeycloakLogout with logout_token
        AdminUI->>AuthController: KeycloakLogout(logout_token)
        AuthController->>AuthController: ValidateLogoutToken
        AuthController->>SessionManager: Add(sub, sid)
        AuthController->>CookieAuth: SignOut
        CookieAuth->>AuthController: Confirmation
        AuthController->>Keycloak: 200 OK Response
        
        note over Browser,BackChannelMiddleware: Next user request
        Browser->>AdminUI: Any authenticated request
        AdminUI->>BackChannelMiddleware: Request passes through middleware
        BackChannelMiddleware->>SessionManager: Check if session logged out
        SessionManager->>BackChannelMiddleware: Session is logged out
        BackChannelMiddleware->>CookieAuth: Sign out from all schemes
        BackChannelMiddleware->>Browser: Redirect to index page
    end
```

## Data Flow for Authentication

```mermaid
flowchart TD
    A[KeycloakGroupMiddleware] -->|Extract JWT claims| B[Tenant Context]
    C[KeycloakAuthenticationController] -->|Access and refresh tokens| D[OpnIdConnectGrandAuthenticationService]
    D -->|Store tokens| E[ExternalAuthentication Repository]
    D -->|Create cookies| F[CookieAuthenticationService]
    F -->|Create tenant-specific cookies| G[Browser Cookies]
    
    H[BackchannelLogoutCheckMiddleware] -->|Validate sessions| I[LogoutSessionManager]
    
    B -->|StoreId| J[NotificationHub SignalR]
    
    K[KeycloakJwtValidationService] -->|Validate tokens| A
    K -->|Validate tokens| C
    K -->|Validate tokens| H
```

## Component Relationships

```mermaid
classDiagram
    class KeycloakAuthenticationController {
        +KeycloakLogin(returnUrl)
        +KeycloakLoginCallback(returnurl)
        +OpenIdSignOut()
        +KeycloakLogout(logout_token)
        -ValidateLogoutToken(logoutToken)
    }
    
    class KeycloakGroupMiddleware {
        +InvokeAsync(context, ...)
        -HandleUserTokenAsync(context, token, ...)
        -HandleStoreTokenAsync(context, storeToken, ...)
        -ShouldRedirectToLogin(path)
        -RedirectToLogin(context, path, ...)
    }
    
    class BackchannelLogoutCheckMiddleware {
        +InvokeAsync(context, ...)
        -ValidateUserSessionAsync(context, externalAuthInfo, ...)
        -HandleTokenRefreshAsync(context, externalAuthInfo, ...)
        -SignoutAndRedirectAsync(context, linkGenerator)
        -GetNewTokenAsync(tokenEndpoint, refreshToken, ...)
    }
    
    class OpnIdConnectGrandAuthenticationService {
        +Authenticate(parameters, refreshToken, returnUrl)
        -SetExternalAuthenticationUserField(parameters, refreshToken, associatedUser)
    }
    
    class CookieAuthenticationService {
        +SignIn(customer, isPersistent)
        +SignOut()
        +GetAuthenticatedCustomer()
        +GetCustomerGuid()
        +SetCustomerGuid(customerGuid)
    }
    
    class NotificationHub {
        +OnConnectedAsync()
        +OnDisconnectedAsync(exception)
        +InvokeMethodAsync(invocationContext, next)
    }
    
    KeycloakAuthenticationController --> OpnIdConnectGrandAuthenticationService : Uses
    KeycloakAuthenticationController --> CookieAuthenticationService : Uses
    OpnIdConnectGrandAuthenticationService --> CookieAuthenticationService : Uses
    BackchannelLogoutCheckMiddleware --> CookieAuthenticationService : Uses
    NotificationHub --> KeycloakGroupMiddleware : Depends on StoreId set by
```

This documentation visualizes the complete authentication flow between the application, Keycloak, and various middleware components, highlighting how tenant-specific data is maintained throughout the process.