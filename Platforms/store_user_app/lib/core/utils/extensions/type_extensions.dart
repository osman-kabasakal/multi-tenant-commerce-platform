extension TypeExtensions on Type {
  /// Returns the type name without the library prefix.
  String get typeName => toString().split('.').last;

  bool isPrimitiveType() {
    return this == String ||
        this == int ||
        this == double ||
        this == bool ||
        this == num;
  }

  bool isApiResponse() {
    return toString().startsWith('ApiResponse<');
  }

  Type? getApiResponseGenericType() {
    if (!isApiResponse()) return null;
    final genericTypeName = toString().split('<')[1].split('>')[0];
    // Tip adından gerçek tipe dönüşüm için basit bir mapping
    switch (genericTypeName) {
      case 'String':
        return String;
      case 'int':
        return int;
      case 'double':
        return double;
      case 'bool':
        return bool;
      case 'num':
        return num;
      default:
        return null; // Diğer tipler için null dönebilir veya tip registry kullanılabilir
    }
  }
}
