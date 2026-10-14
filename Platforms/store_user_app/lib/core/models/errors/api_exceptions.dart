// lib/core/api/api_exceptions.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(message: message ?? 'Ağ bağlantısı sağlanamadı');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
    message: message ?? 'Oturum süresi doldu',
    statusCode: 401,
    code: 'UNAUTHORIZED',
  );
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
    message: message ?? 'İstenilen kaynak bulunamadı',
    statusCode: 404,
    code: 'NOT_FOUND',
  );
}

class ValidationException extends ApiException {
  ValidationException({
    String? message,
    Map<String, dynamic>? validationErrors,
  }) : super(
    message: message ?? 'Validasyon hatası',
    statusCode: 422,
    code: 'VALIDATION_ERROR',
    data: validationErrors,
  );
}

class ServerException extends ApiException {
  ServerException({String? message})
      : super(
    message: message ?? 'Sunucu hatası',
    statusCode: 500,
    code: 'SERVER_ERROR',
  );
}

class BadResponseException extends ApiException {
  BadResponseException({String? message, super.statusCode,super.data,})
      : super(
    message: message ?? 'Geçersiz yanıt',
    code: 'BAD_RESPONSE',
  );
}
