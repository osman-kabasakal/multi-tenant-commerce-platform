import 'dart:convert';

/// Only opaque server-issued request IDs are accepted; notices never contain model data.
class CacheChangeNotice {
  const CacheChangeNotice(this.ids, this.timestamp);
  final List<String> ids;
  final DateTime timestamp;
  static final _guid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  static bool validId(String value) => _guid.hasMatch(value);

  static CacheChangeNotice? socket(dynamic value) {
    try {
      if (value is! String || value.length > 16384) return null;
      final data = jsonDecode(value);
      if (data is! Map<String, dynamic>) return null;
      return _parse(data['correlationIds'], data['timestamp']);
    } on FormatException {
      return null;
    }
  }

  static CacheChangeNotice? push(
    Map<String, dynamic> data, {
    String expectedTenant = const String.fromEnvironment('TENANT_ID'),
  }) {
    if (data['Type'] != 'cache_invalidation' ||
        !RegExp(r'^[a-f0-9]{32}$').hasMatch(expectedTenant) ||
        data['TenantId'] != expectedTenant ||
        data['CorrelationIds'] is! String ||
        (data['CorrelationIds'] as String).length > 8192) {
      return null;
    }
    try {
      return _parse(
        jsonDecode(data['CorrelationIds'] as String),
        data['RefreshCacheTime'],
      );
    } on FormatException {
      return null;
    }
  }

  static CacheChangeNotice? _parse(dynamic ids, dynamic timestamp) {
    if (ids is! List ||
        ids.isEmpty ||
        ids.length > 100 ||
        ids.any((id) => id is! String || !validId(id))) {
      return null;
    }
    final time = timestamp is String ? DateTime.tryParse(timestamp) : null;
    if (time == null) return null;
    return CacheChangeNotice(
      ids.cast<String>().map((id) => id.toLowerCase()).toSet().toList(),
      time.toUtc(),
    );
  }
}
