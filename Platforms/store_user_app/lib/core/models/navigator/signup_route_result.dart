enum SignupRouteResult {
  success,
  failure,
  cancel,
  redirectToLogin,
}

enum SigninRouteResult {
  success,
  failure,
  cancel,
  continueAsGuest,
  redirectToSignup,
}
