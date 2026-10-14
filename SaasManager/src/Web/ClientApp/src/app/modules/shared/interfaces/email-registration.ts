export interface EmailVerificationRequest {
  email: string;
}

export interface EmailVerificationResponse {
  "tempToken": string,
  "expiresAt": string,
  "resendDelay": number,
  "remainingAttempts": number
}

export interface VerifyCodeRequest {
  email: string;
  code: string;
  tempToken: string;
}

export interface VerifyCodeResponse {
  isVerified: boolean;
  nextStep?: string;
  message?: string;
  "remainingAttempts": number,
  "waitDuration": number
}

export interface ResendCodeRequest {
  email: string;
  tempToken: string;
}

export interface ResendCodeResponse extends EmailVerificationResponse{}

